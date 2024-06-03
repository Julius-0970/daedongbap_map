from app import app
from flask import Blueprint, Flask, request, jsonify, render_template, session
import pymysql


search_routes = Blueprint('search_routes', __name__)

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


@search_routes.route('/search', methods=['POST'])
def search():
    data = request.json
    query = data.get('query')
    connection = connect_db()
    if not query:
        return jsonify({'message': '검색어가 제공되지 않았습니다.'}), 400

    try:
        #결과값 저장
        search_results = {
            'feeds': [],
            'restaurants': [],
            'reviews': [],
            'comments': []
        }

        # 게시글 검색
        with connection.cursor() as cursor:
            sql = "SELECT * FROM posts WHERE title LIKE %s OR content LIKE %s"
            cursor.execute(sql, (f"%{query}%", f"%{query}%"))
            search_results['feeds'] = cursor.fetchall()

        # 식당 정보 검색
        with connection.cursor() as cursor:
            sql = "SELECT * FROM restaurants WHERE name LIKE %s OR address LIKE %s"
            cursor.execute(sql, (f"%{query}%", f"%{query}%"))
            search_results['restaurants'] = cursor.fetchall()

        # 리뷰글 검색
        with connection.cursor() as cursor:
            sql = "SELECT * FROM reviews WHERE content LIKE %s"
            cursor.execute(sql, (f"%{query}%",))
            search_results['reviews'] = cursor.fetchall()

        # 댓글 검색
        with connection.cursor() as cursor:
            sql = "SELECT * FROM comments WHERE content LIKE %s"
            cursor.execute(sql, (f"%{query}%",))
            search_results['comments'] = cursor.fetchall()
    except Exception as e:
        return jsonify({'message': '검색 중 오류가 발생했습니다.', 'error': str(e)}), 500        
    finally:
        # 데이터베이스 연결 닫기
        connection.close()
    
    
    # 결과를 JSON 형식으로 반환
    return jsonify(search_results)
