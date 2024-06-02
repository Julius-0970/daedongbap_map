from flask import Flask, render_template

app = Flask(__name__)

# 라우트를 user_routes에서 가져오기
import user_routes
import search_routes

@app.route('/')
def index():
    return render_template('index.html')
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
