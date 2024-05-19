-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: daedongbap_map
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `address_number` varchar(255) NOT NULL,
  `Restaurant_Address` varchar(255) NOT NULL,
  `resident_id` varchar(255) NOT NULL,
  `address_name` varchar(255) NOT NULL,
  PRIMARY KEY (`address_number`),
  KEY `resident_id` (`resident_id`),
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`resident_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES ('2394ulwsk','충청남도 아산시 탕정면 선문로221번길 70','yhr1435','대학교');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alarm`
--

DROP TABLE IF EXISTS `alarm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alarm` (
  `Alarm_ID` int NOT NULL,
  `Receiver_ID` varchar(255) NOT NULL,
  `Message` varchar(10000) NOT NULL,
  `Confirmation_Status` tinyint(1) NOT NULL,
  `Transmission_Time` datetime NOT NULL,
  PRIMARY KEY (`Alarm_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alarm`
--

LOCK TABLES `alarm` WRITE;
/*!40000 ALTER TABLE `alarm` DISABLE KEYS */;
/*!40000 ALTER TABLE `alarm` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `Category_Number` int NOT NULL,
  `Category_Name` varchar(40) NOT NULL,
  PRIMARY KEY (`Category_Number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'한식');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `Comment_ID` varchar(255) NOT NULL,
  `Parent_Comment_ID` varchar(255) DEFAULT NULL,
  `feed_id` varchar(255) NOT NULL,
  `comment_writer_ID` varchar(255) NOT NULL,
  `comment_Text` varchar(5000) NOT NULL,
  `comment_like_number` int NOT NULL,
  `comment_write_date` datetime NOT NULL,
  PRIMARY KEY (`Comment_ID`),
  KEY `Parent_Comment_ID` (`Parent_Comment_ID`),
  KEY `feed_id` (`feed_id`),
  KEY `comment_writer_ID` (`comment_writer_ID`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`Parent_Comment_ID`) REFERENCES `comment` (`Comment_ID`),
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`feed_id`) REFERENCES `feed` (`feed_ID`),
  CONSTRAINT `comment_ibfk_3` FOREIGN KEY (`comment_writer_ID`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES ('asd234',NULL,'sdf80s9','yhr1435','이것은 댓글이다',3,'2024-03-10 00:05:49');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed`
--

DROP TABLE IF EXISTS `feed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feed` (
  `feed_ID` varchar(255) NOT NULL,
  `feed_writer_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `feed_content` varchar(10000) NOT NULL,
  `feed_like_number` int NOT NULL,
  `feed_write_date` datetime NOT NULL,
  PRIMARY KEY (`feed_ID`),
  KEY `feed_writer_id` (`feed_writer_id`),
  CONSTRAINT `feed_ibfk_1` FOREIGN KEY (`feed_writer_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed`
--

LOCK TABLES `feed` WRITE;
/*!40000 ALTER TABLE `feed` DISABLE KEYS */;
INSERT INTO `feed` VALUES ('sdf80s9','yhr1435','소개','이 웹은 한국에서 ~asdasdasdasdasdasdasdas',10,'2024-03-11 00:00:00');
/*!40000 ALTER TABLE `feed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_type`
--

DROP TABLE IF EXISTS `item_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_type` (
  `Type_ID` int NOT NULL AUTO_INCREMENT,
  `Type_Name` varchar(40) NOT NULL,
  PRIMARY KEY (`Type_ID`),
  UNIQUE KEY `Type_Name` (`Type_Name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_type`
--

LOCK TABLES `item_type` WRITE;
/*!40000 ALTER TABLE `item_type` DISABLE KEYS */;
INSERT INTO `item_type` VALUES (2,'댓글'),(3,'리뷰'),(4,'식당'),(1,'피드');
/*!40000 ALTER TABLE `item_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `like_`
--

DROP TABLE IF EXISTS `like_`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `like_` (
  `Like_Number` int NOT NULL,
  `Liker_ID` varchar(255) NOT NULL,
  `Liked_Item_User` varchar(255) NOT NULL,
  `Liked_Item_ID` varchar(255) NOT NULL,
  `Liked_Item_Type_ID` int NOT NULL,
  PRIMARY KEY (`Like_Number`),
  KEY `Liker_ID` (`Liker_ID`),
  KEY `Liked_Item_User` (`Liked_Item_User`),
  KEY `Liked_Item_Type_ID` (`Liked_Item_Type_ID`),
  CONSTRAINT `like__ibfk_1` FOREIGN KEY (`Liker_ID`) REFERENCES `user` (`user_id`),
  CONSTRAINT `like__ibfk_2` FOREIGN KEY (`Liked_Item_User`) REFERENCES `user` (`user_id`),
  CONSTRAINT `like__ibfk_3` FOREIGN KEY (`Liked_Item_Type_ID`) REFERENCES `item_type` (`Type_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `like_`
--

LOCK TABLES `like_` WRITE;
/*!40000 ALTER TABLE `like_` DISABLE KEYS */;
/*!40000 ALTER TABLE `like_` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant` (
  `Restaurant_ID` varchar(255) NOT NULL,
  `Restaurant_Name` varchar(255) NOT NULL,
  `Restaurant_Address` varchar(255) NOT NULL,
  `restaurant_like_number` int NOT NULL,
  `Category_Number` int DEFAULT NULL,
  `restaurant_upload_date` datetime NOT NULL,
  PRIMARY KEY (`Restaurant_ID`),
  KEY `Category_Number` (`Category_Number`),
  CONSTRAINT `restaurant_ibfk_1` FOREIGN KEY (`Category_Number`) REFERENCES `category` (`Category_Number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant`
--

LOCK TABLES `restaurant` WRITE;
/*!40000 ALTER TABLE `restaurant` DISABLE KEYS */;
/*!40000 ALTER TABLE `restaurant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `review_ID` varchar(255) NOT NULL,
  `restaurant_id` varchar(255) NOT NULL,
  `review_writer_ID` varchar(255) NOT NULL,
  `review_content` varchar(10000) NOT NULL,
  `review_like_number` int NOT NULL,
  `rating` tinyint NOT NULL,
  `review_write_date` datetime NOT NULL,
  PRIMARY KEY (`review_ID`),
  KEY `review_writer_ID` (`review_writer_ID`),
  KEY `restaurant_id` (`restaurant_id`),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`review_writer_ID`) REFERENCES `user` (`user_id`),
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`Restaurant_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `age` int NOT NULL,
  `gender` tinyint NOT NULL,
  `email` varchar(255) NOT NULL,
  `user_create_date` datetime NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('yhr1435','sdfsdfs','정희원',24,0,'yhr1435@gmail.com','2024-03-15 00:00:00');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-17 17:53:53
