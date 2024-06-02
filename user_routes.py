from app import app
from flask import Flask, request, jsonify, render_template, session
import pymysql
import hashlib
import sys

# 데이터베이스 연결 정보 설정
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '0000',
    'database': 'daedongbap_map',
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

# 메뉴 접근 함수
# 이거는 지금 필요없는 내용이라 잠시 치워둠.

# 회원가입 라우트
@app.route('/add_user', methods=['POST'])
def add_user():
    data = request.json
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            if 'user_id' in data and 'password' in data and 'name' in data and 'age' in data and 'gender' in data and 'email' in data:
                user_id = data['user_id']
                password = data['password']
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

# 로그인 라우트
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            if 'user_id' in data and 'password' in data:
                user_id = data['user_id']
                password = hashlib.sha256(data['password'].encode()).hexdigest()  # 비밀번호 해시 처리(보안)

                select_query = "SELECT * FROM user WHERE user_id = %s AND password = %s"
                cursor.execute(select_query, (user_id, password))
                user = cursor.fetchone()

                if user:
                    return jsonify({'message': '로그인 성공', 'user': user}), 200
                else:
                    return jsonify({'message': '로그인 실패. 아이디 또는 비밀번호를 확인하세요.'}), 401
            else:
                return jsonify({'message': '아이디 혹은 비밀번호의 입력을 해주세요.'}), 400
    finally:
        connection.close()

# 로그아웃 라우트 / 필요없음.
@app.route('/logout', methods=['POST'])
def logout():
    if 'user_id' in session:
        session.pop('user_id')
        return jsonify({'message': '로그아웃되었습니다.'}), 200
    else:
        return jsonify({'message': '로그인된 사용자가 없습니다.'}), 400

# 회원탈퇴 라우트
@app.route('/delete_user', methods=['POST'])
def delete_user():
    user_id = session.get('user_id')
    if user_id : # 로그인 상태에서만 회원탈퇴를 진행하기 위함.
        connection = connect_db()
        try:
            with connection.cursor() as cursor:
                delete_query = "DELETE FROM user WHERE user_id = %s"
                cursor.execute(delete_query, (user_id,))
                connection.commit()

                return jsonify({'message': '회원 탈퇴가 완료되었습니다.'}), 200
        finally:
            connection.close()
    else:
        return jsonify({'message': '로그인된 사용자가 없습니다.'}), 400

# 회원정보 수정 라우트

