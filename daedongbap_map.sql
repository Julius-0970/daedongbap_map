show databases ; 
use  daedongbap_map ; 

SET foreign_key_checks = 0; # 외래키 비활성화
SET foreign_key_checks = 1; # 외래키 활성화
CREATE TABLE user (
    user_id VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL Unique,
    age INT NOT NULL,
    gender TINYINT NOT NULL,
    email VARCHAR(255) NOT NULL Unique,
    user_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
# 비밀번호 업데이트를 위한 비밀번호 변경일을 추가할까 고민중...
select * from user ;
drop table user ; 
TRUNCATE TABLE user ;

INSERT INTO user (user_id, password, name, age, gender, email) 
values('yhr1435','sdfsdfs', '정희원', 24, 0, 'yhr1435@gmail.com') ; 


CREATE TABLE feed (
    feed_ID VARCHAR(255) PRIMARY KEY,
    feed_writer_id VARCHAR(255) NOT NULL,
    title VARCHAR(255) NOT NULL,
    feed_content VARCHAR(10000) NOT NULL,
    feed_like_number INT NOT NULL,
    feed_write_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (feed_writer_id) REFERENCES user(user_id)
);

select * from feed ;
drop table feed ;
TRUNCATE TABLE feed ;

INSERT INTO feed (feed_ID, feed_writer_id, title, feed_content, feed_like_number)
values('sdf80s9','yhr1435', '소개', '이 웹은 한국에서 ~asdasdasdasdasdasdasdas', 10) ; 

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

select * from review ;
drop table review ;
TRUNCATE TABLE review ;

insert into review(review_ID, restaurant_id, review_writer_ID, review_content, review_like_number, rating)
values('dr0dfgj', 'RES123', 'yhr1435', '맛집이나 평범하다', 11, 4.5) ; 

CREATE TABLE Comment (
    Comment_ID VARCHAR(255) PRIMARY KEY,
    Parent_Comment_ID VARCHAR(255),
    feed_id VARCHAR(255) NOT NULL, 
    comment_writer_ID VARCHAR(255) NOT NULL,
    comment_Text VARCHAR(5000) NOT NULL,
    comment_like_number INT NOT NULL,
    comment_write_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (Parent_Comment_ID) REFERENCES Comment(Comment_ID), 
    FOREIGN KEY (Feed_id) REFERENCES Feed(feed_ID),
    FOREIGN KEY (comment_writer_ID) REFERENCES User(User_ID)
);
select * from comment ;
drop table comment ;
TRUNCATE TABLE comment ;

INSERT INTO Comment(Comment_ID, Parent_Comment_ID, feed_id, comment_writer_ID, comment_Text, comment_like_number)
VALUES('asd234', null, 'sdf80s9', 'yhr1435', '이것은 댓글이다', 0);

CREATE TABLE Restaurant (
    Restaurant_ID VARCHAR(255) PRIMARY KEY,
    Restaurant_Name VARCHAR(255) NOT NULL,
    Restaurant_Address VARCHAR(255) NOT NULL,
    restaurant_like_number INT NOT NULL,
    Category_Number INT,
    restaurant_upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (Category_Number) REFERENCES Category(Category_Number)
);

select * from Restaurant ;
drop table Restaurant ;
TRUNCATE TABLE restaurant ; 

INSERT INTO Restaurant(Restaurant_ID, Restaurant_Name, Restaurant_Address, restaurant_like_number, Category_Number) 
VALUES('RES123', '밥집', '서울특별시 어쩌구 저쩌구', 1004, 1);

CREATE TABLE Category (
    Category_Number INT PRIMARY KEY,
    Category_Name VARCHAR(40) NOT NULL
);
select * from Category ;
drop table Category ;
TRUNCATE TABLE category ;

INSERT INTO Category 
VALUES(1, '한식');


CREATE TABLE Feed_Like (
    Like_ID INT PRIMARY KEY AUTO_INCREMENT,
    Liker_ID VARCHAR(255) NOT NULL,
    Feed_ID VARCHAR(255) NOT NULL,
    FOREIGN KEY (Liker_ID) REFERENCES User(User_ID),
    FOREIGN KEY (Feed_ID) REFERENCES feed(feed_ID)
);
select * from Feed_Like ;
drop table Feed_Like ;
INSERT INTO Feed_Like 
VALUES();

CREATE TABLE Review_Like (
    Like_ID INT PRIMARY KEY AUTO_INCREMENT,
    Liker_ID VARCHAR(255) NOT NULL,
    Review_ID VARCHAR(255) NOT NULL,
    FOREIGN KEY (Liker_ID) REFERENCES User(User_ID),
    FOREIGN KEY (Review_ID) REFERENCES review(review_ID)
);
select * from Review_Like ;
drop table Review_Like ;
INSERT INTO Review_Like 
VALUES();

CREATE TABLE Restaurant_Like (
    Like_ID INT PRIMARY KEY AUTO_INCREMENT,
    Liker_ID VARCHAR(255) NOT NULL,
    Restaurant_ID VARCHAR(255) NOT NULL,
    FOREIGN KEY (Liker_ID) REFERENCES User(User_ID),
    FOREIGN KEY (Restaurant_ID) REFERENCES restaurant(restaurant_ID)
);
select * from Restaurant_Like ;
drop table Restaurant_Like ;
INSERT INTO Restaurant_Like 
VALUES();

CREATE TABLE Comment_Like (
    Like_ID INT PRIMARY KEY AUTO_INCREMENT,
    Liker_ID VARCHAR(255) NOT NULL,
    Comment_ID VARCHAR(255) NOT NULL,
    FOREIGN KEY (Liker_ID) REFERENCES User(User_ID),
    FOREIGN KEY (Comment_ID) REFERENCES comment(comment_ID)
);
select * from Comment_Like ;
drop table Comment_Like ;
INSERT INTO Comment_Like 
VALUES();

# 좋아요에 대한 알람, 댓글에 대한 알람으로 테이블을 세분화.
CREATE TABLE Like_Alarm (
    Alarm_ID INT PRIMARY KEY AUTO_INCREMENT,
    Receiver_ID VARCHAR(255) NOT NULL,
	Liker_ID VARCHAR(255) NOT NULL,
    Item_ID VARCHAR(255) NOT NULL,
    Item_Type VARCHAR(255) NOT NULL, -- 좋아요 항목 유형 (feed, review, restaurant, comment)
     Message VARCHAR(10000) NOT NULL,
    Confirmation_Status BOOLEAN NOT NULL DEFAULT FALSE, -- 확인유무
    Transmission_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 전송시간
    FOREIGN KEY (Receiver_ID) REFERENCES User(user_id),
    FOREIGN KEY (Liker_ID) REFERENCES User(user_id)
);
-- Item_ID, Item_Type으로 어느 게시판의, 어떤 글의 id인지 식별가능하게만 하는 용도. 
-- 위의 내용들은 백엔드 코드문에서 다룰 것이기에 따로 외래키 지정x(지정하기도 힘듬)

CREATE TABLE Comment_Alarm (
    Alarm_ID INT PRIMARY KEY AUTO_INCREMENT,
    Receiver_ID VARCHAR(255) NOT NULL,
    Message VARCHAR(10000) NOT NULL,
    Confirmation_Status BOOLEAN NOT NULL DEFAULT FALSE, -- 확인유무
    Transmission_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- 전송시간
    Commenter_ID VARCHAR(255) NOT NULL,
    Parent_ID VARCHAR(255), -- 상위 댓글 또는 피드의 ID
    Parent_Type VARCHAR(255) NOT NULL, -- 상위 댓글 또는 피드 유형 (feed, comment, review)
    FOREIGN KEY (Receiver_ID) REFERENCES User(user_id),
    FOREIGN KEY (Commenter_ID) REFERENCES User(user_id)
);


CREATE TABLE Alarm (
    Alarm_ID INT PRIMARY KEY,
    Receiver_ID VARCHAR(255) NOT NULL,
    Message VARCHAR(10000) NOT NULL,
    Confirmation_Status BOOLEAN NOT NULL, #확인유무
    Transmission_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL    #전송시간
);

select * from alarm ;
drop table alarm ;
INSERT INTO alarm 
VALUES();
