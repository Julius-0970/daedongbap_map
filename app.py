from flask import Blueprint, Flask, render_template
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
app.secret_key = 'daedongbap_map'

# MySQL 데이터베이스 URI 설정
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URI', 'mysql+pymysql://root:0000@localhost/daedongbap_map')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# SQLAlchemy 객체 생성
db = SQLAlchemy(app)

# user_routes와 search_routes를 가져오기
from user_routes import user_routes
from search_routes import search_routes

# 블루프린트 등록
app.register_blueprint(user_routes)
app.register_blueprint(search_routes)

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
