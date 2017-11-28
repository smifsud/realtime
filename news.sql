# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.20)
# Database: news
# Generation Time: 2017-11-26 16:57:30 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE news;
USE news;

# Dump of table headlines
# ------------------------------------------------------------

DROP TABLE IF EXISTS `headlines`;

CREATE TABLE `headlines` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table newsgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `newsgroups`;

CREATE TABLE `newsgroups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `newsgroup` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `newsgroups` WRITE;
/*!40000 ALTER TABLE `newsgroups` DISABLE KEYS */;

INSERT INTO `newsgroups` (`id`, `newsgroup`)
VALUES
	(1,'Local News'),
	(2,'National News');

/*!40000 ALTER TABLE `newsgroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_newsgroups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_newsgroups`;

CREATE TABLE `user_newsgroups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `newsgroup_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `user_newsgroups` WRITE;
/*!40000 ALTER TABLE `user_newsgroups` DISABLE KEYS */;

INSERT INTO `user_newsgroups` (`id`, `user_id`, `newsgroup_id`)
VALUES
	(1,1,1),
	(2,2,2);

/*!40000 ALTER TABLE `user_newsgroups` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `userID` int(11) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `userID`, `token`)
VALUES
	(1,1,'ABC438s'),
	(2,2,'asliwemx');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
