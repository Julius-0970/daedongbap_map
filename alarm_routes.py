from flask import Blueprint, request, jsonify, session
import pymysql
from datetime import datetime, timedelta
from apscheduler.schedulers.background import BackgroundScheduler
import os  # os 모듈 임포트
from dotenv import load_dotenv

# .env 파일의 환경 변수를 읽어들입니다.
load_dotenv()

# 블루프린트 생성
alarm_routes = Blueprint('alarm_routes', __name__)

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

# 알람 생성 함수
def create_alarm(receiver_id, message):
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            # 동일한 알람이 이미 있는지 확인
            sql_check = """
            SELECT * FROM alarm WHERE receiver_ID = %s AND message = %s AND confirmation_status = %s
            """
            cursor.execute(sql_check, (receiver_id, message, False))
            existing_alarm = cursor.fetchone()
            
            if existing_alarm:
                return
            # 동일한 알람이 이미 존재하면 새 알람을 생성하지 않음

            # 알람 데이터를 데이터베이스에 삽입
            sql_insert = """
            INSERT INTO alarm (receiver_ID, message, confirmation_status)
            VALUES (%s, %s, %s)
            """
            cursor.execute(sql_insert, (receiver_id, message, False))
            connection.commit()
    finally:
        connection.close()

# 사용자 알람 조회 엔드포인트
@alarm_routes.route('/alarm', methods=['POST'])
def get_alarms():
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    user_id = session['user_id']
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = "SELECT * FROM alarm WHERE receiver_ID = %s"
            cursor.execute(sql, (user_id,))
            alarms = cursor.fetchall()
        return jsonify(alarms)
    finally:
        connection.close()

# 알람 확인 엔드포인트
@alarm_routes.route('/alarm/<int:alarm_id>/confirm', methods=['POST'])
def confirm_alarm(alarm_id):
    if 'user_id' not in session:
        return jsonify({'message': '로그인이 필요합니다.'}), 401

    user_id = session['user_id']
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            sql = "UPDATE alarm SET confirmation_status = %s, transmission_time = %s WHERE alarm_ID = %s AND receiver_ID = %s"
            cursor.execute(sql, (True, datetime.now(), alarm_id, user_id))
            connection.commit()
        return jsonify({'message': '알람이 확인되었습니다.'})
    finally:
        connection.close()

# 1주일이 지난 확인된 알람 삭제 함수
def delete_old_alarms():
    connection = connect_db()
    try:
        with connection.cursor() as cursor:
            one_week_ago = datetime.now() - timedelta(weeks=1)
            sql = "DELETE FROM alarm WHERE confirmation_status = %s AND transmission_time < %s"
            cursor.execute(sql, (True, one_week_ago))
            connection.commit()
    finally:
        connection.close()

# 스케줄러 설정
scheduler = BackgroundScheduler()
scheduler.add_job(func=delete_old_alarms, trigger="interval", weeks=1)  # 매일 한 번 실행
scheduler.start()
