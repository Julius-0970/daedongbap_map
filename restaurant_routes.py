from flask import Blueprint, request, jsonify, session
import pymysql
import uuid

restaurant_routes = Blueprint('restaurant_routes', __name__)

# 데이터베이스 연결 정보 설정
def connect_db():
    db_config = {
        'host': 'localhost',
        'user': 'root',
        'password': '0000',
        'database': 'daedongbap_map',
        'charset': 'utf8mb4',
        'cursorclass': pymysql.cursors.DictCursor
    }

    return pymysql.connect(
        host=db_config['host'],
        user=db_config['user'],
        password=db_config['password'],
        database=db_config['database'],
        charset=db_config['charset'],
        cursorclass=db_config['cursorclass']
    )

# 식당 정보 저장
@restaurant_routes.route('/save_restaurant', methods=['POST'])
def save_restaurant():
    data = request.json
    restaurant_id = str(uuid.uuid4())
    restaurant_name = data.get('restaurant_name')
    restaurant_address = data.get('restaurant_address')
    category_name = data.get('category_name')

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            # 카테고리 처리
            sql = "SELECT Category_Number FROM Category WHERE Category_Name = %s"
            cursor.execute(sql, (category_name,))
            category = cursor.fetchone()
            
            if category:
                category_number = category['Category_Number']
            else:
                sql = "INSERT INTO Category (Category_Name) VALUES (%s)"
                cursor.execute(sql, (category_name,))
                category_number = cursor.lastrowid

            # 식당 정보 저장
            sql = """
            INSERT INTO Restaurant (Restaurant_ID, Restaurant_Name, Restaurant_Address, restaurant_like_number, Category_Number)
            VALUES (%s, %s, %s, 0, %s)
            ON DUPLICATE KEY UPDATE Restaurant_Name = VALUES(Restaurant_Name), Restaurant_Address = VALUES(Restaurant_Address), Category_Number = VALUES(Category_Number)
            """
            cursor.execute(sql, (restaurant_id, restaurant_name, restaurant_address, category_number))
            
            connection.commit()
        return jsonify({'message': '식당 정보가 저장되었습니다.'}), 201
    finally:
        connection.close()

# 리뷰 작성 (회원 전용)
@restaurant_routes.route('/write_review', methods=['POST'])
def write_review():
    data = request.json
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    review_id = str(uuid.uuid4())
    restaurant_id = data.get('restaurant_id')
    review_content = data.get('review_content')
    rating = int(data.get('rating'))  # 별점은 1~5의 정수로 받음

    if rating < 1 or rating > 5:
        return jsonify({'message': '별점은 1에서 5 사이의 정수여야 합니다.'}), 400

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            # 리뷰 추가
            sql = """
            INSERT INTO review (review_ID, restaurant_id, review_writer_ID, review_content, review_like_number, rating, review_write_date)
            VALUES (%s, %s, %s, %s, 0, %s, CURRENT_TIMESTAMP)
            """
            cursor.execute(sql, (review_id, restaurant_id, user_id, review_content, rating))
            connection.commit()
        return jsonify({'message': '리뷰가 작성되었습니다.'}), 201
    finally:
        connection.close()

# 리뷰 수정 (회원 전용)
@restaurant_routes.route('/update_review/<review_id>', methods=['PUT'])
def update_review(review_id):
    data = request.json
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    review_content = data.get('review_content')
    rating = int(data.get('rating'))  # 별점은 1~5의 정수로 받음

    if rating < 1 or rating > 5:
        return jsonify({'message': '별점은 1에서 5 사이의 정수여야 합니다.'}), 400

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            # 리뷰 수정
            sql = """
            UPDATE review
            SET review_content = %s, rating = %s, review_write_date = CURRENT_TIMESTAMP
            WHERE review_ID = %s AND review_writer_ID = %s
            """
            cursor.execute(sql, (review_content, rating, review_id, user_id))
            connection.commit()
        return jsonify({'message': '리뷰가 수정되었습니다.'}), 200
    finally:
        connection.close()

# 식당 리뷰 가져오기 (회원, 비회원 공용)_ 모달
@restaurant_routes.route('/restaurant_reviews_modal', methods=['POST'])
def get_restaurant_reviews():
    data = request.json
    restaurant_ids = data.get('restaurant_ids')
    if not restaurant_ids:
        return jsonify({'message': '식당 ID가 제공되지 않았습니다.'}), 400

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            reviews = []
            for restaurant_id in restaurant_ids:
                sql = """
                SELECT user_id, rating, SUBSTRING(content, 1, 20) AS content, created_at
                FROM reviews
                WHERE restaurant_id = %s
                ORDER BY created_at DESC
                LIMIT 4
                """
                cursor.execute(sql, (restaurant_id,))
                result = cursor.fetchall()
                if result:
                    reviews.append({restaurant_id: result})
                else:
                    reviews.append({restaurant_id: '리뷰가 없습니다.'})
            return jsonify(reviews), 200
    finally:
        connection.close()

# 리뷰 테이블에서 리뷰 목록 가져오기 (회원, 비회원 공용)
@restaurant_routes.route('/reviews', methods=['GET'])
def get_reviews():
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = """
            SELECT r.review_ID, r.restaurant_id, r.review_writer_ID, r.review_content, r.review_like_number, r.rating, r.review_write_date,
                   res.Restaurant_Name, res.Restaurant_Address, cat.Category_Name
            FROM review r
            JOIN Restaurant res ON r.restaurant_id = res.Restaurant_ID
            JOIN Category cat ON res.Category_Number = cat.Category_Number
            ORDER BY r.review_write_date DESC
            """
            cursor.execute(sql)
            reviews = cursor.fetchall()
            return jsonify(reviews), 200
    finally:
        connection.close()
