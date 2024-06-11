from flask import Blueprint, request, jsonify, session
import pymysql
import uuid
from dotenv import load_dotenv
import os  # os 모듈 임포트

# .env 파일의 환경 변수를 읽어들입니다.
load_dotenv()

feed_routes = Blueprint('feed_routes', __name__)


db_config = {
    'host': os.getenv('DATABASE_HOST'),
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
        user=db_config['user'],
        password=db_config['password'],
        database=db_config['database'],
        charset=db_config['charset'],
        cursorclass=db_config['cursorclass']
    )

# 피드 목록 가져오기
@feed_routes.route('/feeds', methods=['GET'])
def get_feeds():
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = """
            SELECT f.feed_id, f.title, f.feed_content, f.feed_like_number, f.feed_write_date, 
                   COUNT(c.comment_id) AS comment_count
            FROM feed f
            LEFT JOIN comment c ON f.feed_id = c.feed_id
            GROUP BY f.feed_id
            ORDER BY f.feed_write_date DESC
            """
            cursor.execute(sql)
            feeds = cursor.fetchall()
            return jsonify(feeds), 200
    finally:
        connection.close()

# 특정 피드 상세 정보 가져오기
@feed_routes.route('/feeds/<feed_id>', methods=['GET'])
def get_feed_detail(feed_id):
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = "SELECT * FROM feed WHERE feed_id = %s"
            cursor.execute(sql, (feed_id,))
            feed = cursor.fetchone()
            if not feed:
                return jsonify({'message': '피드를 찾을 수 없습니다.'}), 404
            
            # 피드에 대한 댓글 가져오기
            sql = "SELECT * FROM comment WHERE feed_id = %s ORDER BY comment_write_date DESC"
            cursor.execute(sql, (feed_id,))
            comments = cursor.fetchall()

            return jsonify({'feed': feed, 'comments': comments}), 200
    finally:
        connection.close()

# 피드 작성하기
@feed_routes.route('/feeds', methods=['POST'])
def create_feed():
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    data = request.json
    user_id = session['user_id']
    title = data.get('title')
    feed_content = data.get('feed_content')
    feed_id = str(uuid.uuid4())

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = """
            INSERT INTO feed (feed_id, feed_writer_id, title, feed_content, feed_like_number)
            VALUES (%s, %s, %s, %s, 0)
            """
            cursor.execute(sql, (feed_id, user_id, title, feed_content))
            connection.commit()

            # 댓글 수를 0으로 설정
            update_sql = "UPDATE feed SET comment_count = 0 WHERE feed_id = %s"
            cursor.execute(update_sql, (feed_id,))
            connection.commit()
            
        return jsonify({'message': '피드가 작성되었습니다.'}), 201
    finally:
        connection.close()

# 피드 수정하기
@feed_routes.route('/feeds/<feed_id>', methods=['PUT'])
def update_feed(feed_id):
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    data = request.json
    user_id = session['user_id']
    title = data.get('title')
    feed_content = data.get('feed_content')

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = """
            UPDATE feed
            SET title = %s, feed_content = %s
            WHERE feed_id = %s AND feed_writer_id = %s
            """
            cursor.execute(sql, (title, feed_content, feed_id, user_id))
            connection.commit()
        return jsonify({'message': '피드가 수정되었습니다.'}), 200
    finally:
        connection.close()

# 피드 삭제하기
@feed_routes.route('/feeds/<feed_id>', methods=['DELETE'])
def delete_feed(feed_id):
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    user_id = session['user_id']

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = "DELETE FROM feed WHERE feed_id = %s AND feed_writer_id = %s"
            cursor.execute(sql, (feed_id, user_id))
            connection.commit()
        return jsonify({'message': '피드가 삭제되었습니다.'}), 200
    finally:
        connection.close()

        
