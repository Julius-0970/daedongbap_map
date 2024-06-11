#show databases ; 
use  daedongbap_map ; 

#SET foreign_key_checks = 0; # 외래키 비활성화
#SET foreign_key_checks = 1; # 외래키 활성화

#select * from  user ;
#drop table Category ; 
#TRUNCATE TABLE  ;

CREATE TABLE user (
    user_id VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL Unique,
    age INT NOT NULL,
    gender TINYINT NOT NULL,
    email VARCHAR(255) NOT NULL Unique,
    user_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

INSERT INTO user (user_id, password, name, age, gender, email) 
VALUES ('user1', 'password1', 'Alice', 30, 1, 'alice@example.com'),
('user2', 'password2', 'Bob', 25, 0, 'bob@example.com'),
('user3', 'password3', 'Charlie', 28, 1, 'charlie@example.com'),
('user4', 'password4', 'David', 22, 0, 'david@example.com'),
('user5', 'password5', 'Eve', 35, 1, 'eve@example.com');


CREATE TABLE feed (
    feed_ID VARCHAR(255) PRIMARY KEY,
    feed_writer_id VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    feed_content VARCHAR(10000) NOT NULL,
    feed_like_number INT NOT NULL,
    feed_write_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (feed_writer_id) REFERENCES user(user_id)
);


CREATE TABLE review (
    review_ID VARCHAR(255) PRIMARY KEY,
    restaurant_id VARCHAR(255) NOT NULL,
    review_writer_ID VARCHAR(255) NOT NULL,
    review_content VARCHAR(10000) NOT NULL,
    review_like_number INT NOT NULL,
    rating TINYINT NOT NULL, 
	review_write_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (review_writer_ID) REFERENCES user(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id)
);


CREATE TABLE comment (
    Comment_ID VARCHAR(255) PRIMARY KEY,
    Parent_Comment_ID VARCHAR(255),
    feed_id VARCHAR(255) NOT NULL, 
    comment_writer_ID VARCHAR(255) NOT NULL,
    comment_Text VARCHAR(5000) NOT NULL,
    comment_like_number INT NOT NULL,
    comment_write_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (Parent_Comment_ID) REFERENCES comment(Comment_ID), 
    FOREIGN KEY (Feed_id) REFERENCES feed(feed_ID),
    FOREIGN KEY (comment_writer_ID) REFERENCES user(User_ID)
);

CREATE TABLE category (
    Category_Number INT PRIMARY KEY,
    Category_Name VARCHAR(40) NOT NULL
);

CREATE TABLE restaurant (
    Restaurant_ID VARCHAR(255) PRIMARY KEY,
    Restaurant_Name VARCHAR(255) NOT NULL,
    Restaurant_Address VARCHAR(255) NOT NULL,
    restaurant_like_number INT NOT NULL,
    Category_Number INT,
    restaurant_upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (Category_Number) REFERENCES category(Category_Number)
);

CREATE TABLE Feed_Like (
    Like_ID INT PRIMARY KEY AUTO_INCREMENT,
    Liker_ID VARCHAR(255) NOT NULL,
    Feed_ID VARCHAR(255) NOT NULL,
    FOREIGN KEY (Liker_ID) REFERENCES user(user_ID),
    FOREIGN KEY (feed_ID) REFERENCES feed(feed_ID)
);

CREATE TABLE Review_Like (
    Like_ID INT PRIMARY KEY AUTO_INCREMENT,
    Liker_ID VARCHAR(255) NOT NULL,
    Review_ID VARCHAR(255) NOT NULL,
    FOREIGN KEY (Liker_ID) REFERENCES user(user_ID),
    FOREIGN KEY (review_ID) REFERENCES review(review_ID)
);

CREATE TABLE Restaurant_Like (
    Like_ID INT PRIMARY KEY AUTO_INCREMENT,
    Liker_ID VARCHAR(255) NOT NULL,
    Restaurant_ID VARCHAR(255) NOT NULL,
    FOREIGN KEY (Liker_ID) REFERENCES user(user_ID),
    FOREIGN KEY (restaurant_ID) REFERENCES restaurant(restaurant_ID)
);

CREATE TABLE Comment_Like (
    Like_ID INT PRIMARY KEY AUTO_INCREMENT,
    Liker_ID VARCHAR(255) NOT NULL,
    Comment_ID VARCHAR(255) NOT NULL,
    FOREIGN KEY (Liker_ID) REFERENCES user(user_ID),
    FOREIGN KEY (comment_ID) REFERENCES comment(comment_ID)
);

# 좋아요에 대한 알람, 댓글에 대한 알람으로 테이블을 세분화.
CREATE TABLE Alarm (
    Alarm_ID INT PRIMARY KEY AUTO_INCREMENT,
    Receiver_ID VARCHAR(255) NOT NULL,
    Liker_ID VARCHAR(255),
    Item_ID VARCHAR(255),
    Item_Type VARCHAR(255), -- 좋아요 항목 유형 (feed, review, restaurant, comment)
    Message VARCHAR(10000),
    Confirmation_Status BOOLEAN NOT NULL DEFAULT FALSE, -- 확인유무
    Transmission_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 전송시간
    FOREIGN KEY (Receiver_ID) REFERENCES user(user_id),
    FOREIGN KEY (Liker_ID) REFERENCES user(user_id)
);
-- Item_ID, Item_Type으로 어느 게시판의, 어떤 글의 id인지 식별가능하게만 하는 용도. 
-- 위의 내용들은 백엔드 코드문에서 다룰 것이기에 따로 외래키 지정x(지정하기도 힘듬)

