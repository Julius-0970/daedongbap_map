from flask import Flask, render_template
from flask_sqlalchemy import SQLAlchemy
import os

# Flask 애플리케이션 초기화
app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'hw0212321')  # 비밀번호

# MySQL 데이터베이스 URI 설정
app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"mysql+pymysql://{os.getenv('DATABASE_HOST')}:{os.getenv('DATABASE_PASSWORD')}"
    f"@{os.getenv('DATABASE_HOST')}:{os.getenv('DATABASE_PORT')}/{os.getenv('DATABASE_DB')}"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# SQLAlchemy 객체 생성
db = SQLAlchemy(app)

from user_routes import user_routes
from comment_routes import comment_routes
from feed_routes import feed_routes
from like_routes import like_routes
from restaurant_routes import restaurant_routes
from search_routes import search_routes
from alarm_routes import alarm_routes

app.register_blueprint(user_routes)
app.register_blueprint(comment_routes)
app.register_blueprint(feed_routes)
app.register_blueprint(like_routes)
app.register_blueprint(restaurant_routes)
app.register_blueprint(search_routes)
app.register_blueprint(alarm_routes)


@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

