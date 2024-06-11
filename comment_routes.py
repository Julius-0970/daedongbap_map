from flask import Blueprint, request, jsonify, session
import pymysql
import uuid
from dotenv import load_dotenv

# .env 파일의 환경 변수를 읽어들입니다.
load_dotenv()

comment_routes = Blueprint('comment_routes', __name__)

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

# 댓글 가져오기
@comment_routes.route('/comments/<feed_id>', methods=['GET'])
def get_comments(feed_id):
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            # 댓글을 오래된 순서부터 출력(오름차순)
            sql = "SELECT * FROM comment WHERE feed_id = %s ORDER BY comment_write_date ASC"
            cursor.execute(sql, (feed_id,))
            comments = cursor.fetchall()
            return jsonify(comments), 200
    finally:
        connection.close()

# 댓글 작성하기
@comment_routes.route('/comments', methods=['POST'])
def create_comment():
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    data = request.json
    user_id = session['user_id']
    feed_id = data.get('feed_id')
    parent_comment_id = data.get('parent_comment_id')
    comment_text = data.get('comment_text')
    comment_id = str(uuid.uuid4())

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = """
            INSERT INTO comment (comment_id, parent_comment_id, feed_id, comment_writer_id, comment_text, comment_like_number)
            VALUES (%s, %s, %s, %s, %s, 0)
            """
            cursor.execute(sql, (comment_id, parent_comment_id, feed_id, user_id, comment_text))
            connection.commit()

            # 상위 피드의 댓글 수 증가
            update_sql = "UPDATE feed SET comment_count = comment_count + 1 WHERE feed_id = %s"
            cursor.execute(update_sql, (feed_id,))
            connection.commit()

        return jsonify({'message': '댓글이 작성되었습니다.', 'comment_id': comment_id}), 201
    finally:
        connection.close()

# 댓글 수정하기
@comment_routes.route('/comments/<comment_id>', methods=['PUT'])
def update_comment(comment_id):
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    data = request.json
    user_id = session['user_id']
    comment_text = data.get('comment_text')

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = """
            UPDATE comment
            SET comment_text = %s
            WHERE comment_id = %s AND comment_writer_id = %s
            """
            cursor.execute(sql, (comment_text, comment_id, user_id))
            connection.commit()
        return jsonify({'message': '댓글이 수정되었습니다.'}), 200
    finally:
        connection.close()

# 하위 댓글 수 조회하는 함수
def get_descendant_comment_count(cursor, comment_id):
    cursor.execute("SELECT comment_id FROM comment WHERE parent_comment_id = %s", (comment_id,))
    descendants = cursor.fetchall()
    count = len(descendants)
    for descendant in descendants:
        count += get_descendant_comment_count(cursor, descendant['comment_id'])
    return count

# 댓글 삭제하기
@comment_routes.route('/comments/<comment_id>', methods=['DELETE'])
def delete_comment(comment_id):
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    user_id = session['user_id']

    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            # 댓글 삭제 전에 feed_id와 Parent_Comment_ID를 가져옵니다
            get_comment_sql = "SELECT feed_id, parent_comment_id FROM comment WHERE comment_id = %s AND comment_writer_id = %s"
            cursor.execute(get_comment_sql, (comment_id, user_id))
            result = cursor.fetchone()

            if not result:
                return jsonify({'message': '댓글을 찾을 수 없거나 권한이 없습니다.'}), 404

            feed_id = result['feed_id']
            parent_comment_id = result['parent_comment_id']

            if parent_comment_id is None:
                # 상위 댓글인 경우, 하위 댓글 수를 조회
                descendant_count = get_descendant_comment_count(cursor, comment_id)
                total_count_to_remove = descendant_count + 1

                # 상위 댓글과 하위 댓글 모두 삭제
                delete_sql = "DELETE FROM comment WHERE comment_id = %s OR parent_comment_id = %s"
                cursor.execute(delete_sql, (comment_id, comment_id))
                connection.commit()

                # 상위 피드의 댓글 수 감소
                update_sql = "UPDATE feed SET comment_count = comment_count - %s WHERE feed_id = %s"
                cursor.execute(update_sql, (total_count_to_remove, feed_id))
            else:
                # 하위 댓글인 경우, 해당 댓글만 삭제
                delete_sql = "DELETE FROM comment WHERE comment_id = %s AND comment_writer_id = %s"
                cursor.execute(delete_sql, (comment_id, user_id))
                connection.commit()

                # 상위 피드의 댓글 수 감소
                update_sql = "UPDATE feed SET comment_count = comment_count - 1 WHERE feed_id = %s"
                cursor.execute(update_sql, (feed_id,))
            
            connection.commit()

        return jsonify({'message': '댓글이 삭제되었습니다.'}), 200
    finally:
        connection.close()
