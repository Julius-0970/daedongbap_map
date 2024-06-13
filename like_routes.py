from flask import Blueprint, Flask, request, jsonify, session
import pymysql
import os  # os 모듈 임포트

like_routes = Blueprint('like_routes', __name__)

db_config = {
    'host': os.getenv('DATABASE_HOST'),
    'port': int(os.getenv('DATABASE_PORT')),
    'user': os.getenv('DATABASE_USER'),
    'password': os.getenv('DATABASE_PASSWORD'),
    'database': os.getenv('DATABASE_NAME'),
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

@like_routes.route('/like', methods=['POST'])
def like():
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401 # 로그인 체크

    # 프론트에서 넘겨주는 값.
    data = request.json
    user_id = session['user_id']        # 유저 아이디
    item_id = data.get('item_id')       # 좋아요를 누른 게시글의 아이디
    item_type = data.get('item_type')   # 좋아요를 누른 게시판이 어디인지(피드, 리뷰, 식당, 댓글)

    if not item_id or not item_type:
        return jsonify({'message': '필요한 데이터가 제공되지 않았습니다.'}), 400

    table_name = ""
    column_name = ""
    if item_type == "feed":
        table_name = "Feed_Like"
        column_name = "Feed_ID"
    elif item_type == "review":
        table_name = "Review_Like"
        column_name = "Review_ID"
    elif item_type == "restaurant":
        table_name = "Restaurant_Like"
        column_name = "Restaurant_ID"
    elif item_type == "comment":
        table_name = "Comment_Like"
        column_name = "Comment_ID"
    else:
        return jsonify({'message': '올바르지 않은 item_type 입니다.'}), 400

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            # 좋아요 추가
            sql = f"INSERT INTO {table_name} (Liker_ID, {column_name}) VALUES (%s, %s)"
            cursor.execute(sql, (user_id, item_id))
            connection.commit()
        return jsonify({'message': '좋아요가 추가되었습니다.'}), 201
    except pymysql.MySQLError as e:
        return jsonify({'message': '좋아요 추가 중 오류가 발생했습니다.', 'error': str(e)}), 500
    finally:
        connection.close()

@like_routes.route('/unlike', methods=['POST'])
def unlike():
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401 # 로그인 체크

    data = request.json
    user_id = session['user_id']
    item_id = data.get('item_id')
    item_type = data.get('item_type')

    if not item_id or not item_type:
        return jsonify({'message': '필요한 데이터가 제공되지 않았습니다.'}), 400

    table_name = ""
    column_name = ""
    if item_type == "feed":
        table_name = "Feed_Like"
        column_name = "Feed_ID"
    elif item_type == "review":
        table_name = "Review_Like"
        column_name = "Review_ID"
    elif item_type == "restaurant":
        table_name = "Restaurant_Like"
        column_name = "Restaurant_ID"
    elif item_type == "comment":
        table_name = "Comment_Like"
        column_name = "Comment_ID"
    else:
        return jsonify({'message': '올바르지 않은 item_type 입니다.'}), 400

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            # 좋아요 삭제(데이터베이스 상의 제거) 
            sql = f"DELETE FROM {table_name} WHERE Liker_ID = %s AND {column_name} = %s"
            cursor.execute(sql, (user_id, item_id))
            connection.commit()
        return jsonify({'message': '좋아요가 삭제되었습니다.'}), 200
    except pymysql.MySQLError as e:
        return jsonify({'message': '좋아요 삭제 중 오류가 발생했습니다.', 'error': str(e)}), 500
    finally:
        connection.close()
