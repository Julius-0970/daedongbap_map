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
  `Transmission_Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
  `comment_write_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_like`
--

DROP TABLE IF EXISTS `comment_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_like` (
  `Like_ID` int NOT NULL AUTO_INCREMENT,
  `Liker_ID` varchar(255) NOT NULL,
  `Comment_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Like_ID`),
  KEY `Liker_ID` (`Liker_ID`),
  KEY `Comment_ID` (`Comment_ID`),
  CONSTRAINT `comment_like_ibfk_1` FOREIGN KEY (`Liker_ID`) REFERENCES `user` (`user_id`),
  CONSTRAINT `comment_like_ibfk_2` FOREIGN KEY (`Comment_ID`) REFERENCES `comment` (`Comment_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_like`
--

LOCK TABLES `comment_like` WRITE;
/*!40000 ALTER TABLE `comment_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_like` ENABLE KEYS */;
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
  `feed_write_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
/*!40000 ALTER TABLE `feed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feed_like`
--

DROP TABLE IF EXISTS `feed_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feed_like` (
  `Like_ID` int NOT NULL AUTO_INCREMENT,
  `Liker_ID` varchar(255) NOT NULL,
  `Feed_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Like_ID`),
  KEY `Liker_ID` (`Liker_ID`),
  KEY `Feed_ID` (`Feed_ID`),
  CONSTRAINT `feed_like_ibfk_1` FOREIGN KEY (`Liker_ID`) REFERENCES `user` (`user_id`),
  CONSTRAINT `feed_like_ibfk_2` FOREIGN KEY (`Feed_ID`) REFERENCES `feed` (`feed_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feed_like`
--

LOCK TABLES `feed_like` WRITE;
/*!40000 ALTER TABLE `feed_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `feed_like` ENABLE KEYS */;
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
  `restaurant_upload_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
-- Table structure for table `restaurant_like`
--

DROP TABLE IF EXISTS `restaurant_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `restaurant_like` (
  `Like_ID` int NOT NULL AUTO_INCREMENT,
  `Liker_ID` varchar(255) NOT NULL,
  `Restaurant_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Like_ID`),
  KEY `Liker_ID` (`Liker_ID`),
  KEY `Restaurant_ID` (`Restaurant_ID`),
  CONSTRAINT `restaurant_like_ibfk_1` FOREIGN KEY (`Liker_ID`) REFERENCES `user` (`user_id`),
  CONSTRAINT `restaurant_like_ibfk_2` FOREIGN KEY (`Restaurant_ID`) REFERENCES `restaurant` (`Restaurant_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurant_like`
--

LOCK TABLES `restaurant_like` WRITE;
/*!40000 ALTER TABLE `restaurant_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `restaurant_like` ENABLE KEYS */;
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
  `rating` decimal(2,1) NOT NULL,
  `review_write_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
-- Table structure for table `review_like`
--

DROP TABLE IF EXISTS `review_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_like` (
  `Like_ID` int NOT NULL AUTO_INCREMENT,
  `Liker_ID` varchar(255) NOT NULL,
  `Review_ID` varchar(255) NOT NULL,
  PRIMARY KEY (`Like_ID`),
  KEY `Liker_ID` (`Liker_ID`),
  KEY `Review_ID` (`Review_ID`),
  CONSTRAINT `review_like_ibfk_1` FOREIGN KEY (`Liker_ID`) REFERENCES `user` (`user_id`),
  CONSTRAINT `review_like_ibfk_2` FOREIGN KEY (`Review_ID`) REFERENCES `review` (`review_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_like`
--

LOCK TABLES `review_like` WRITE;
/*!40000 ALTER TABLE `review_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_like` ENABLE KEYS */;
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
  `user_create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
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

-- Dump completed on 2024-05-31 19:20:43
