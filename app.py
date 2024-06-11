from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
import os
from dotenv import load_dotenv

# .env 파일의 환경 변수를 읽어들입니다.
load_dotenv()

# Flask 애플리케이션 초기화
app = Flask(__name__)
app.secret_key = 'daedongbap_map' # 비밀번호 

# MySQL 데이터베이스 URI 설정
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URI', 'mysql+pymysql://root:0000@localhost/daedongbap_map')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# SQLAlchemy 객체 생성
db = SQLAlchemy(app)

# 라우트 가져오기
from user_routes import user_routes
from search_routes import search_routes
from restaurant_routes import restaurant_routes
from feed_routes import feed_routes
from comment_routes import comment_routes
from like_routes import like_routes
from alarm_routes import alarm_routes 

# 블루프린트 등록
app.register_blueprint(user_routes)
app.register_blueprint(search_routes)
app.register_blueprint(restaurant_routes)
app.register_blueprint(feed_routes)
app.register_blueprint(comment_routes)
app.register_blueprint(like_routes)
app.register_blueprint(alarm_routes) 

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
