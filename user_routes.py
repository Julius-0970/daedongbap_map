from flask import Blueprint, Flask, request, jsonify, render_template, session
import pymysql
import hashlib
import sys
import os  # os 모듈 임포트

user_routes = Blueprint('user_routes', __name__)

db_config = {
    'host': os.getenv('DATABASE_HOST'),
    'port': int(os.getenv('DATABASE_PORT')),
    'user': os.getenv('DATABASE_USER'),
    'password': os.getenv('DATABASE_PASSWORD'),
    'database': os.getenv('DATABASE_DB'),
    'charset': 'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor
}

# 데이터베이스에 연결하는 함수
def connect_db():
    return pymysql.connect(
        host=db_config['host'],
        port=db_config['port'],
        user=db_config['user'],
        password=db_config['password'],
        database=db_config['database'],
        charset=db_config['charset'],
        cursorclass=db_config['cursorclass']
    )
# 메뉴 접근 함수
# 이거는 지금 필요없는 내용이라 잠시 치워둠.

# 회원가입 라우트
@user_routes.route('/add_user', methods=['POST'])
def add_user():
    data = request.json
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            if 'user_id' in data and 'password' in data and 'name' in data and 'age' in data and 'gender' in data and 'email' in data:
                user_id = data['user_id']
                password = hashlib.sha256(data['password'].encode()).hexdigest()  # 비밀번호 해시 처리(보안)
                name = data['name']
                age = data['age']
                gender = data['gender']
                email = data['email']

                insert_query = """
                INSERT INTO user (user_id, password, name, age, gender, email)
                VALUES (%s, %s, %s, %s, %s, %s)
                """
                cursor.execute(insert_query, (user_id, password, name, age, gender, email))
                connection.commit()
                return jsonify({'message': '사용자 정보가 추가되었습니다.'}), 201
                # 회원가입 성공!
            else:
                return jsonify({'message': '필요한 데이터가 부족합니다.'}), 400
                # 회원가입을 위한 정보가 부족! 
    finally:
        connection.close()

#로그인 라우트 
@user_routes.route('/login', methods=['POST'])
def login():
    data = request.json
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            if 'user_id' in data and 'password' in data:
                user_id = data['user_id']
                password = hashlib.sha256(data['password'].encode()).hexdigest()  # 비밀번호 해시 처리(보안)

                select_query = "SELECT * FROM user WHERE user_id = %s"
                cursor.execute(select_query, (user_id,))
                user = cursor.fetchone()

                if user and user['password'] == password:  
                    session['user_id'] = user['user_id']
                    return jsonify({'message': '로그인 성공', 'user': user}), 200
                else:
                    return jsonify({'message': '로그인 실패. 아이디 또는 비밀번호를 확인하세요.'}), 401
            else:
                return jsonify({'message': '아이디 혹은 비밀번호의 입력을 해주세요.'}), 400
    except Exception as e:
        return jsonify({'message': '오류가 발생했습니다: {}'.format(str(e))}), 500
    finally:
        connection.close()

# 로그아웃 라우트 / 필요없음.
@user_routes.route('/logout', methods=['POST'])
def logout():
    if 'user_id' in session:
        session.pop('user_id')
        return jsonify({'message': '로그아웃되었습니다.'}), 200
    else:
        return jsonify({'message': '로그인된 사용자가 없습니다.'}), 400

# 회원탈퇴 라우트
@user_routes.route('/delete_user', methods=['POST'])
def delete_user():
    user_id = session.get('user_id')
    if user_id : # 로그인 상태에서만 회원탈퇴를 진행하기 위함.
        connection = connect_db()
        try:
            with connection.cursor() as cursor:
                delete_query = "DELETE FROM user WHERE user_id = %s"
                cursor.execute(delete_query, (user_id,))
                connection.commit()
                
                session.pop('user_id')
                return jsonify({'message': '회원 탈퇴가 완료되었습니다.'}), 200
        finally:
            connection.close()
    else:
        return jsonify({'message': '로그인된 사용자가 없습니다.'}), 400

# 회원정보 수정 라우트

# 유저 정보 업데이트
@user_routes.route('/update_user', methods=['PUT'])
def update_user():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    data = request.json
    password = data.get('password')
    name = data.get('name')
    age = data.get('age')
    gender = data.get('gender')
    email = data.get('email')

    updates = {}
    if password:
        updates['password'] = hashlib.sha256(password.encode()).hexdigest()
    if name:
        updates['name'] = name
    if age:
        updates['age'] = age
    if gender:
        updates['gender'] = gender
    if email:
        updates['email'] = email

    if not updates:
        return jsonify({'message': '업데이트할 필드를 입력해주세요.'}), 400

    set_clause = ", ".join([f"{key} = %s" for key in updates.keys()])
    values = list(updates.values())
    values.append(user_id)

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = f"UPDATE user SET {set_clause} WHERE user_id = %s"
            cursor.execute(sql, values)
            connection.commit()
        return jsonify({'message': '유저 정보가 업데이트되었습니다.'}), 200
    finally:
        connection.close()

# 여기서 부터는 내가 작성한 글. 좋아요 누른 글 가져오기

# 유저가 작성한 피드글 가져오기
@user_routes.route('/my_feeds', methods=['GET'])
def get_my_feeds():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = "SELECT * FROM feed WHERE feed_writer_id = %s ORDER BY feed_write_date DESC"
            cursor.execute(sql, (user_id,))
            feeds = cursor.fetchall()
        return jsonify(feeds), 200
    finally:
        connection.close()

# 유저가 작성한 댓글 가져오기
@user_routes.route('/my_comments', methods=['GET'])
def get_my_comments():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = "SELECT * FROM comment WHERE comment_writer_ID = %s ORDER BY comment_write_date DESC"
            cursor.execute(sql, (user_id,))
            comments = cursor.fetchall()
        return jsonify(comments), 200
    finally:
        connection.close()

# 유저가 작성한 리뷰글 가져오기
@user_routes.route('/my_reviews', methods=['GET'])
def get_my_reviews():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = "SELECT * FROM review WHERE review_writer_ID = %s ORDER BY review_write_date DESC"
            cursor.execute(sql, (user_id,))
            reviews = cursor.fetchall()
        return jsonify(reviews), 200
    finally:
        connection.close()

# 유저가 좋아요 누른 피드글 가져오기
@user_routes.route('/liked_feeds', methods=['GET'])
def get_liked_feeds():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = """
            SELECT f.*
            FROM feed f
            JOIN Feed_Like fl ON f.feed_id = fl.Feed_ID
            WHERE fl.Liker_ID = %s
            ORDER BY fl.Like_ID DESC
            """
            cursor.execute(sql, (user_id,))
            liked_feeds = cursor.fetchall()
        return jsonify(liked_feeds), 200
    finally:
        connection.close()

# 유저가 좋아요 누른 댓글 가져오기
@user_routes.route('/liked_comments', methods=['GET'])
def get_liked_comments():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = """
            SELECT c.*
            FROM comment c
            JOIN Comment_Like cl ON c.Comment_ID = cl.Comment_ID
            WHERE cl.Liker_ID = %s
            ORDER BY cl.Like_ID DESC
            """
            cursor.execute(sql, (user_id,))
            liked_comments = cursor.fetchall()
        return jsonify(liked_comments), 200
    finally:
        connection.close()

# 유저가 좋아요 누른 리뷰글 가져오기
@user_routes.route('/liked_reviews', methods=['GET'])
def get_liked_reviews():
    user_id = session.get('user_id')
    if not user_id:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = """
            SELECT r.*
            FROM review r
            JOIN Review_Like rl ON r.review_ID = rl.Review_ID
            WHERE rl.Liker_ID = %s
            ORDER BY rl.Like_ID DESC
            """
            cursor.execute(sql, (user_id,))
            liked_reviews = cursor.fetchall()
        return jsonify(liked_reviews), 200
    finally:
        connection.close()
