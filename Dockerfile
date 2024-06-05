# 베이스 이미지로 Python 3.11 사용
FROM python:3.11-slim-buster

# Python 환경 설정
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 사용자 및 그룹 설정
ARG UID=1000
ARG GID=1000

RUN groupadd -g "${GID}" python \
  && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" python
WORKDIR /home/python

# 필요 패키지 설치
COPY --chown=python:python requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 소스 코드 복사
USER python:python
ENV PATH="/home/${USER}/.local/bin:${PATH}"
COPY --chown=python:python . .

# 환경 변수 설정
ARG FLASK_ENV
ENV FLASK_ENV=${FLASK_ENV}

EXPOSE 5000

# Gunicorn을 사용하여 애플리케이션 실행
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
