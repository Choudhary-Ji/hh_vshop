-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.14-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.1.0.6116
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for impact
CREATE DATABASE IF NOT EXISTS `impact` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `impact`;

-- Dumping structure for table impact.vehicles_display
CREATE TABLE IF NOT EXISTS `vehicles_display` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(50) NOT NULL,
  `commission` int(11) NOT NULL DEFAULT 10,
  `baseprice` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table impact.vehicles_display: ~6 rows (approximately)
/*!40000 ALTER TABLE `vehicles_display` DISABLE KEYS */;
INSERT INTO `vehicles_display` (`ID`, `model`, `commission`, `baseprice`) VALUES
	(1, 'futo', 20, 37000),
	(2, 'issi3', 20, 28000),
	(3, 'sanctus', 20, 26000),
	(4, 'kuruma', 20, 81000),
	(5, 'feltzer3', 20, 77000),
	(6, 'exemplar', 20, 42000);
/*!40000 ALTER TABLE `vehicles_display` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
