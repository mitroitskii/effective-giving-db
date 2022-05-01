-- MySQL dump 10.13  Distrib 8.0.28, for macos11 (x86_64)
--
-- Host: localhost    Database: effective_giving
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cause_area`
--

DROP TABLE IF EXISTS `cause_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cause_area` (
  `cause_id` int NOT NULL AUTO_INCREMENT,
  `cause_name` varchar(64) NOT NULL,
  PRIMARY KEY (`cause_id`),
  UNIQUE KEY `cause_name` (`cause_name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cause_area`
--

LOCK TABLES `cause_area` WRITE;
/*!40000 ALTER TABLE `cause_area` DISABLE KEYS */;
INSERT INTO `cause_area` VALUES (1,'Animal Welfare'),(4,'Effective Altruism Infrastructure'),(8,'Evidence Based Policy'),(5,'Global Catastrophic Risks'),(2,'Global Health and Development'),(6,'Human Rights'),(3,'Long-Term Future'),(7,'Public Mental Health');
/*!40000 ALTER TABLE `cause_area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `charity`
--

DROP TABLE IF EXISTS `charity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `charity` (
  `charity_id` int NOT NULL AUTO_INCREMENT,
  `charity_name` varchar(64) NOT NULL,
  `charity_website` varchar(64) NOT NULL,
  `charity_description` varchar(256) NOT NULL,
  `charity_type` enum('Community','Program Delivery','Research') NOT NULL,
  `charity_cause` int NOT NULL,
  `donations_link` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`charity_id`),
  UNIQUE KEY `charity_name` (`charity_name`),
  KEY `charity_cause` (`charity_cause`),
  CONSTRAINT `charity_ibfk_1` FOREIGN KEY (`charity_cause`) REFERENCES `cause_area` (`cause_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charity`
--

LOCK TABLES `charity` WRITE;
/*!40000 ALTER TABLE `charity` DISABLE KEYS */;
INSERT INTO `charity` VALUES (1,'Against Malaria Foundation','https://www.againstmalaria.com/','Against Malaria Foundation works to prevent the spread of malaria by distributing long-lasting, insecticide-treated mosquito nets to susceptible populations in developing countries.','Program Delivery',2,'https://app.effectivealtruism.org/donations/new/allocation?allocation%5Bagainst-malaria-foundation%5D=100'),(2,'Clean Air Task Force','https://www.catf.us/','The Clean Air Task Force (CATF) is an impact-focused non-profit that advocates for clean air policies. In addition, CATF promotes innovation in and adoption of neglected low-carbon technologies. ','Program Delivery',5,'https://tlycs.networkforgood.com/projects/54204-clean-air-task-force-clean-air-task-force'),(3,'Development Media International','http://www.developmentmedia.net/','Development Media International runs large-scale media campaigns in low-income countries via radio, television, and mobile video.','Program Delivery',2,'https://app.effectivealtruism.org/donations/new/allocation?allocation%5Bdevelopment-media-international%5D=100'),(4,'Evidence Action','https://www.evidenceaction.org/','Evidence Action operates three main initiatives. Dispensers for Safe Water installs and maintains chlorine dispensers in rural Africa. The Deworm the World Initiative partners with governments in India, Nigeria, and Pakistan school-based deworming programs','Program Delivery',2,'https://tlycs.networkforgood.com/projects/53335-evidence-action-evidence-action'),(5,'Fistula Foundation','https://fistulafoundation.org/','Fistula Foundation is the global leader in treating obstetric fistula, a devastating childbirth injury that leaves women incontinent, humiliated, and often shunned by their communities.','Program Delivery',2,'https://tlycs.networkforgood.com/projects/53336-fistula-foundation-fistula-foundation'),(6,'Fred Hollows Foundation','https://www.hollows.org/us/home','The Fred Hollows Foundation is a leading international development organisation with a vision for a world where no person is needlessly blind or vision impaired.','Program Delivery',2,'https://tlycs.networkforgood.com/projects/53337-fred-hollows-foundation-fred-hollows-foundation'),(7,'GiveDirectly','https://www.givedirectly.org/','GiveDirectly provides unconditional cash transfers using cell phone technology to some of the world’s poorest people, as well as refugees, urban youth, and disaster victims.','Program Delivery',2,'https://app.effectivealtruism.org/donations/new/allocation?allocation%5Bgivedirectly%5D=100'),(8,'Global Alliance for Improved Nutrition','https://www.gainhealth.org/','Global Alliance for Improved Nutrition\'s (GAIN’s) mission is to increase the consumption of nutritious foods among vulnerable populations, especially women, girls, and children.','Program Delivery',2,'https://tlycs.networkforgood.com/projects/53339-global-alliance-for-improved-nutrition-global-alliance-for-improved-nutrition'),(9,'Helen Keller International','https://www.hki.org/','Helen Keller International’s Vitamin A Supplementation programs provide critical nutrition to children around the world at-risk for vitamin A deficiency — a condition that can lead to blindness and death.','Program Delivery',2,'https://app.effectivealtruism.org/donations/new/allocation?allocation%5Bhelen-keller-vitamin-a%5D=100'),(10,'Innovations for Poverty Action','http://www.poverty-action.org/','IPA is a global research and policy nonprofit that leads the field of development in cutting-edge research quality and innovation.','Research',2,'https://rcforward.org/charity/ipa/'),(11,'Malaria Consortium','https://www.malariaconsortium.org/','Malaria Consortium delivers programs that protect the poorest and most marginalized children in Africa and Asia from a range of deadly diseases, including malaria and pneumonia.','Program Delivery',2,'https://app.effectivealtruism.org/donations/new/allocation?allocation%5Bmalaria-consortium%5D=100'),(12,'New Incentives','https://www.newincentives.org/','New Incentives educates caregivers about the importance of vaccinating children and disburses cash incentives that are conditional on infants receiving four life-saving vaccines, which are provided through government clinics free of charge.','Program Delivery',2,'https://app.effectivealtruism.org/donations/new/allocation?allocation%5Bnew-incentives%5D=100'),(13,'One Acre Fund','https://oneacrefund.org/','One Acre Fund helps smallholder African farmers boost productivity by delivering a bundle of services directly to their doorsteps, including start-up financing, high-quality farming inputs, agricultural training, and market facilitation to help maximize pr','Program Delivery',2,'https://tlycs.networkforgood.com/projects/53346-one-acre-fund-one-acre-fund'),(14,'SCI Foundation','https://schistosomiasiscontrolinitiative.org/','SCI Foundation, formerly the Schistosomiasis Control Initiative (SCI), works with Ministries of Health and Education in sub-Saharan African countries to support programs controlling and eliminating two types of parasitic worm infections.','Program Delivery',2,'https://app.effectivealtruism.org/donations/new/allocation?allocation%5Bschistosomiasis-control-initiative%5D=100'),(15,'Faunalytics','https://faunalytics.org/','Faunalytics is a U.S.-based organization working to connect animal advocates with information relevant to advocacy.','Research',1,'https://animalcharityevaluators.org/donation-advice/recommended-charities/?form=tc'),(16,'The Humane League','https://thehumaneleague.org/','The Humane League (THL) currently operates in the U.S., Mexico, the U.K., and Japan, where they work to improve animal welfare standards through grassroots campaigns, movement building, veg*n advocacy, research, and advocacy training, as well as through co','',1,'https://app.effectivealtruism.org/donations/new/allocation?allocation%5Bthe-humane-league%5D=100'),(17,'Wild Animal Initiative','https://www.wildanimalinitiative.org/','Wild Animal Initiative (WAI) currently operates in the U.S., where they work to strengthen the animal advocacy movement through creating an academic field dedicated to wild animal welfare. They compile literature reviews, write theoretical and opinion arti','Research',1,'https://app.effectivealtruism.org/donations/new/allocation?allocation%5Bwild-animal-suffering-research%5D=100'),(18,'Anima International','https://animainternational.org/','Anima International works to improve welfare standards for farmed animals through corporate outreach, investigations, legislative work, and media outreach, primarily in Eastern Europe.','Program Delivery',1,'https://animalcharityevaluators.org/charity-review/anima/?form=rcf'),(19,'Compassion USA','https://www.ciwf.com/','Compassion USA is a branch of the international organization Compassion in World Farming (CIWF), which works to improve farmed animal welfare and end all factory farming practices. Compassion USA engages in corporate outreach to encourage food companies to','Program Delivery',1,'https://animalcharityevaluators.org/charity-review/compassion-in-world-farming-usa-ciwf/?form=rcf');
/*!40000 ALTER TABLE `charity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `country` (
  `country_id` int NOT NULL AUTO_INCREMENT,
  `country_name` varchar(64) NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE KEY `country_name` (`country_name`)
) ENGINE=InnoDB AUTO_INCREMENT=194 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (1,'Afghanistan'),(2,'Albania'),(3,'Algeria'),(4,'Andorra'),(5,'Angola'),(6,'Antigua and Barbuda'),(7,'Argentina'),(8,'Armenia'),(9,'Australia'),(10,'Austria'),(11,'Azerbaijan'),(12,'Bahamas'),(13,'Bahrain'),(14,'Bangladesh'),(15,'Barbados'),(16,'Belarus'),(17,'Belgium'),(18,'Belize'),(19,'Benin'),(20,'Bhutan'),(21,'Bolivia (Plurinational State of)'),(22,'Bosnia and Herzegovina'),(23,'Botswana'),(24,'Brazil'),(25,'Brunei Darussalam'),(26,'Bulgaria'),(27,'Burkina Faso'),(28,'Burundi'),(29,'Cabo Verde'),(30,'Cambodia'),(31,'Cameroon'),(32,'Canada'),(33,'Central African Republic'),(34,'Chad'),(35,'Chile'),(36,'China'),(37,'Colombia'),(38,'Comoros'),(39,'Congo'),(40,'Congo, Democratic Republic of the'),(41,'Costa Rica'),(42,'Cote d\'Ivoire'),(43,'Croatia'),(44,'Cuba'),(45,'Cyprus'),(46,'Czechia'),(47,'Denmark'),(48,'Djibouti'),(49,'Dominica'),(50,'Dominican Republic'),(51,'Ecuador'),(52,'Egypt'),(53,'El Salvador'),(54,'Equatorial Guinea'),(55,'Eritrea'),(56,'Estonia'),(57,'Eswatini'),(58,'Ethiopia'),(59,'Fiji'),(60,'Finland'),(61,'France'),(62,'Gabon'),(63,'Gambia'),(64,'Georgia'),(65,'Germany'),(66,'Ghana'),(67,'Greece'),(68,'Grenada'),(69,'Guatemala'),(70,'Guinea'),(71,'Guinea-Bissau'),(72,'Guyana'),(73,'Haiti'),(74,'Honduras'),(75,'Hungary'),(76,'Iceland'),(77,'India'),(78,'Indonesia'),(79,'Iran (Islamic Republic of)'),(80,'Iraq'),(81,'Ireland'),(82,'Israel'),(83,'Italy'),(84,'Jamaica'),(85,'Japan'),(86,'Jordan'),(87,'Kazakhstan'),(88,'Kenya'),(89,'Kiribati'),(90,'Korea (Democratic People\'s Republic of)'),(91,'Korea, Republic of'),(92,'Kuwait'),(93,'Kyrgyzstan'),(94,'Lao People\'s Democratic Republic'),(95,'Latvia'),(96,'Lebanon'),(97,'Lesotho'),(98,'Liberia'),(99,'Libya'),(100,'Liechtenstein'),(101,'Lithuania'),(102,'Luxembourg'),(103,'Madagascar'),(104,'Malawi'),(105,'Malaysia'),(106,'Maldives'),(107,'Mali'),(108,'Malta'),(109,'Marshall Islands'),(110,'Mauritania'),(111,'Mauritius'),(112,'Mexico'),(113,'Micronesia (Federated States of)'),(114,'Moldova, Republic of'),(115,'Monaco'),(116,'Mongolia'),(117,'Montenegro'),(118,'Morocco'),(119,'Mozambique'),(120,'Myanmar'),(121,'Namibia'),(122,'Nauru'),(123,'Nepal'),(124,'Netherlands'),(125,'New Zealand'),(126,'Nicaragua'),(127,'Niger'),(128,'Nigeria'),(129,'North Macedonia'),(130,'Norway'),(131,'Oman'),(132,'Pakistan'),(133,'Palau'),(134,'Panama'),(135,'Papua New Guinea'),(136,'Paraguay'),(137,'Peru'),(138,'Philippines'),(139,'Poland'),(140,'Portugal'),(141,'Qatar'),(142,'Romania'),(143,'Russian Federation'),(144,'Rwanda'),(145,'Saint Kitts and Nevis'),(146,'Saint Lucia'),(147,'Saint Vincent and the Grenadines'),(148,'Samoa'),(149,'San Marino'),(150,'Sao Tome and Principe'),(151,'Saudi Arabia'),(152,'Senegal'),(153,'Serbia'),(154,'Seychelles'),(155,'Sierra Leone'),(156,'Singapore'),(157,'Slovakia'),(158,'Slovenia'),(159,'Solomon Islands'),(160,'Somalia'),(161,'South Africa'),(162,'South Sudan'),(163,'Spain'),(164,'Sri Lanka'),(165,'Sudan'),(166,'Suriname'),(167,'Sweden'),(168,'Switzerland'),(169,'Syrian Arab Republic'),(170,'Tajikistan'),(171,'Tanzania, United Republic of'),(172,'Thailand'),(173,'Timor-Leste'),(174,'Togo'),(175,'Tonga'),(176,'Trinidad and Tobago'),(177,'Tunisia'),(178,'Turkey'),(179,'Turkmenistan'),(180,'Tuvalu'),(181,'Uganda'),(182,'Ukraine'),(183,'United Arab Emirates'),(184,'United Kingdom of Great Britain and Northern Ireland'),(185,'United States of America'),(186,'Uruguay'),(187,'Uzbekistan'),(188,'Vanuatu'),(189,'Venezuela (Bolivarian Republic of)'),(190,'Viet Nam'),(191,'Yemen'),(192,'Zambia'),(193,'Zimbabwe');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donation`
--

DROP TABLE IF EXISTS `donation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donation` (
  `donation_id` int NOT NULL AUTO_INCREMENT,
  `donation_donor` int DEFAULT NULL,
  `donation_charity` int NOT NULL,
  `donation_datetime` datetime NOT NULL,
  `donation_amount` int NOT NULL,
  PRIMARY KEY (`donation_id`),
  KEY `donation_donor` (`donation_donor`),
  KEY `donation_charity` (`donation_charity`),
  CONSTRAINT `donation_ibfk_1` FOREIGN KEY (`donation_donor`) REFERENCES `donor` (`donor_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `donation_ibfk_2` FOREIGN KEY (`donation_charity`) REFERENCES `charity` (`charity_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation`
--

LOCK TABLES `donation` WRITE;
/*!40000 ALTER TABLE `donation` DISABLE KEYS */;
INSERT INTO `donation` VALUES (1,2,1,'2019-12-31 12:23:01',20),(2,2,4,'2020-01-31 11:13:02',20),(3,2,11,'2020-02-27 14:24:05',20),(4,2,1,'2020-03-31 15:23:00',20),(5,2,1,'2020-04-29 14:25:01',20),(6,2,4,'2020-05-31 15:12:00',20),(7,2,7,'2020-06-15 12:45:02',20),(8,2,7,'2020-07-31 11:43:10',20),(9,2,16,'2020-08-31 09:32:01',20),(10,2,17,'2020-09-28 23:53:23',20),(11,2,1,'2020-10-31 08:12:01',20),(12,2,1,'2020-11-30 21:29:23',20),(13,2,7,'2020-12-31 22:13:45',20),(14,7,9,'2022-05-01 07:44:34',100),(15,7,9,'2022-05-01 07:47:37',123);
/*!40000 ALTER TABLE `donation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donor`
--

DROP TABLE IF EXISTS `donor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donor` (
  `donor_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(64) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `email` varchar(64) NOT NULL,
  `donor_country` int DEFAULT NULL,
  `source` int DEFAULT NULL,
  `income_rank` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`donor_id`),
  UNIQUE KEY `email` (`email`),
  KEY `donor_country` (`donor_country`),
  KEY `source` (`source`),
  KEY `income_rank` (`income_rank`),
  CONSTRAINT `donor_ibfk_1` FOREIGN KEY (`donor_country`) REFERENCES `country` (`country_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `donor_ibfk_2` FOREIGN KEY (`source`) REFERENCES `source` (`source_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `donor_ibfk_3` FOREIGN KEY (`income_rank`) REFERENCES `income_rank` (`percentile`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donor`
--

LOCK TABLES `donor` WRITE;
/*!40000 ALTER TABLE `donor` DISABLE KEYS */;
INSERT INTO `donor` VALUES (1,'Ayesha','Aziz','aa@email.com',132,6,85.69),(2,'Dmitrii','Troitskii','dt@email.com',143,3,83.78),(3,'Will','MacAskill','wdmacaskill@gmail.com',184,7,99.82),(4,'Jo','Duyvestyn','jd@email.com',125,6,98.82),(6,'test','e','e@e.com',134,5,85.69),(7,'test','test','test',2,4,85.69);
/*!40000 ALTER TABLE `donor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluation`
--

DROP TABLE IF EXISTS `evaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evaluation` (
  `evaluator` int NOT NULL,
  `charity` int NOT NULL,
  `evaluation_year` year NOT NULL,
  `effectiveness_rank` enum('1','2','3','4','5','6','7','8','9','10') NOT NULL,
  PRIMARY KEY (`evaluation_year`,`effectiveness_rank`,`evaluator`),
  KEY `evaluator` (`evaluator`),
  KEY `charity` (`charity`),
  CONSTRAINT `evaluation_ibfk_1` FOREIGN KEY (`evaluator`) REFERENCES `evaluator` (`evaluator_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `evaluation_ibfk_2` FOREIGN KEY (`charity`) REFERENCES `charity` (`charity_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluation`
--

LOCK TABLES `evaluation` WRITE;
/*!40000 ALTER TABLE `evaluation` DISABLE KEYS */;
INSERT INTO `evaluation` VALUES (4,1,2020,'1'),(4,1,2021,'1'),(2,1,2021,'2'),(4,2,2020,'3'),(4,2,2021,'3'),(4,3,2021,'5'),(4,4,2020,'4'),(2,4,2021,'4'),(4,4,2021,'4'),(4,5,2021,'8'),(4,6,2020,'6'),(4,6,2021,'6'),(4,7,2020,'8'),(2,7,2021,'5'),(4,7,2021,'7'),(4,8,2020,'7'),(4,8,2021,'10'),(4,9,2020,'9'),(2,9,2021,'3'),(4,9,2021,'9'),(4,10,2021,'2'),(2,11,2021,'1'),(4,12,2020,'10'),(4,13,2020,'5'),(4,14,2020,'2'),(2,14,2021,'6'),(1,15,2021,'1'),(1,16,2021,'2'),(1,17,2021,'3'),(1,18,2021,'4'),(1,19,2021,'5');
/*!40000 ALTER TABLE `evaluation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluator`
--

DROP TABLE IF EXISTS `evaluator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evaluator` (
  `evaluator_id` int NOT NULL AUTO_INCREMENT,
  `evaluator_name` varchar(128) NOT NULL,
  `evaluator_website` varchar(64) NOT NULL,
  PRIMARY KEY (`evaluator_id`),
  UNIQUE KEY `evaluator_name` (`evaluator_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluator`
--

LOCK TABLES `evaluator` WRITE;
/*!40000 ALTER TABLE `evaluator` DISABLE KEYS */;
INSERT INTO `evaluator` VALUES (1,'Animal Charity Evaluators','https://animalcharityevaluators.org/'),(2,'GiveWell','https://www.givewell.org/'),(4,'The Life You Can Save','https://www.thelifeyoucansave.org/');
/*!40000 ALTER TABLE `evaluator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `income_rank`
--

DROP TABLE IF EXISTS `income_rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income_rank` (
  `percentile` decimal(4,2) NOT NULL,
  `annual_income` decimal(9,2) NOT NULL,
  PRIMARY KEY (`percentile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `income_rank`
--

LOCK TABLES `income_rank` WRITE;
/*!40000 ALTER TABLE `income_rank` DISABLE KEYS */;
INSERT INTO `income_rank` VALUES (0.00,0.00),(0.08,22.68),(0.15,45.33),(0.24,68.04),(0.36,90.72),(0.51,113.40),(0.71,136.08),(0.92,158.76),(1.16,181.44),(1.45,204.12),(1.76,226.80),(2.09,249.48),(2.46,272.16),(2.85,294.84),(3.26,317.52),(3.71,340.20),(4.15,362.88),(4.62,385.56),(5.12,408.24),(5.64,430.92),(6.16,453.60),(6.69,476.28),(7.23,498.96),(7.83,521.64),(8.42,544.32),(9.02,567.00),(9.63,589.68),(10.24,612.36),(10.89,635.04),(11.47,657.72),(12.09,680.40),(12.72,703.08),(13.33,725.76),(13.94,748.44),(14.55,771.12),(15.15,793.80),(15.74,816.48),(16.36,839.16),(16.90,861.84),(17.46,884.52),(18.03,907.20),(18.61,929.88),(19.21,952.56),(19.79,975.24),(20.36,997.92),(20.92,1020.60),(21.53,1043.28),(22.06,1065.96),(22.60,1088.64),(23.13,1111.32),(23.66,1134.00),(24.18,1156.68),(24.72,1179.36),(25.21,1202.04),(25.71,1224.72),(26.25,1247.40),(26.76,1270.08),(27.23,1292.76),(27.72,1315.44),(28.20,1338.12),(28.67,1360.80),(29.14,1383.48),(29.61,1406.16),(30.08,1428.84),(30.52,1451.52),(30.99,1474.20),(31.43,1496.88),(31.89,1519.56),(32.35,1542.24),(32.80,1564.92),(33.23,1587.60),(33.63,1610.28),(34.05,1632.96),(34.42,1655.64),(34.86,1678.32),(35.24,1701.00),(35.64,1723.68),(36.05,1746.36),(36.47,1769.04),(36.85,1791.72),(37.22,1814.40),(37.59,1837.08),(37.94,1859.76),(38.35,1882.44),(38.69,1905.12),(39.04,1927.80),(39.37,1950.48),(39.71,1973.16),(40.05,1995.84),(40.37,2018.52),(40.68,2041.20),(40.99,2063.88),(41.34,2086.56),(41.65,2109.24),(41.98,2131.92),(42.27,2154.60),(42.60,2177.28),(42.90,2199.96),(43.20,2222.64),(43.48,2245.32),(43.76,2268.00),(44.05,2290.68),(44.30,2313.36),(44.59,2336.04),(44.88,2358.72),(45.15,2381.40),(45.41,2404.08),(45.66,2426.76),(45.91,2449.44),(46.16,2472.12),(46.47,2494.80),(46.76,2517.48),(47.02,2540.16),(47.25,2562.84),(47.52,2585.52),(47.78,2608.20),(48.03,2630.88),(48.26,2653.56),(48.51,2676.24),(48.75,2698.92),(49.00,2721.60),(49.23,2744.28),(49.46,2766.96),(49.69,2789.64),(49.91,2812.32),(50.13,2835.00),(50.35,2857.68),(50.58,2880.36),(50.80,2903.04),(51.04,2925.72),(51.25,2948.40),(51.46,2971.08),(51.67,2993.76),(51.86,3016.44),(52.05,3039.12),(52.26,3061.80),(52.45,3084.48),(52.65,3107.16),(52.90,3129.84),(53.08,3152.52),(53.25,3175.20),(53.44,3197.88),(53.62,3220.56),(53.81,3243.24),(53.99,3265.92),(54.18,3288.60),(54.35,3311.28),(54.55,3333.96),(54.73,3356.64),(54.92,3379.32),(55.10,3402.00),(55.27,3424.68),(55.44,3447.36),(55.61,3470.04),(55.82,3492.72),(55.98,3515.40),(56.14,3538.08),(56.31,3560.76),(56.47,3583.44),(56.64,3606.12),(56.81,3628.80),(56.97,3651.48),(57.15,3674.16),(57.30,3696.84),(57.45,3719.52),(57.64,3742.20),(57.79,3764.88),(57.94,3787.56),(58.10,3810.24),(58.25,3832.92),(58.40,3855.60),(58.55,3878.28),(58.69,3900.96),(58.84,3923.64),(58.99,3946.32),(59.13,3969.00),(59.29,3991.68),(59.42,4014.36),(59.55,4037.04),(59.69,4059.72),(59.82,4082.40),(59.95,4105.08),(60.09,4127.76),(60.22,4150.44),(60.40,4173.12),(60.54,4195.80),(60.66,4218.48),(60.80,4241.16),(60.92,4263.84),(61.04,4286.52),(61.16,4309.20),(61.29,4331.88),(61.42,4354.56),(61.56,4377.24),(61.69,4399.92),(61.82,4422.60),(61.94,4445.28),(62.06,4467.96),(62.19,4490.64),(62.30,4513.32),(62.42,4536.00),(62.53,4558.68),(62.65,4581.36),(62.77,4604.04),(62.89,4626.72),(63.01,4649.40),(63.13,4672.08),(63.25,4694.76),(63.36,4717.44),(63.45,4740.12),(63.56,4762.80),(63.68,4785.48),(63.79,4808.16),(63.89,4830.84),(64.01,4853.52),(64.12,4876.20),(64.23,4898.88),(64.32,4921.56),(64.42,4944.24),(64.53,4966.92),(64.66,4989.60),(64.78,5012.28),(64.89,5034.96),(64.99,5057.64),(65.08,5080.32),(65.19,5103.00),(65.28,5125.68),(65.39,5148.36),(65.48,5171.04),(65.57,5193.72),(65.69,5216.40),(65.79,5239.08),(65.88,5261.76),(65.98,5284.44),(66.08,5307.12),(66.18,5329.80),(66.30,5352.48),(66.39,5375.16),(66.49,5397.84),(66.60,5420.52),(66.71,5443.20),(66.79,5465.88),(66.90,5488.56),(66.99,5511.24),(67.08,5533.92),(67.18,5556.60),(67.26,5579.28),(67.35,5601.96),(67.44,5624.64),(67.53,5647.32),(67.62,5670.00),(67.70,5692.68),(67.79,5715.36),(67.87,5738.04),(67.96,5760.72),(68.03,5783.40),(68.13,5806.08),(68.21,5828.76),(68.29,5851.44),(68.37,5874.12),(68.45,5896.80),(68.54,5919.48),(68.61,5942.16),(68.69,5964.84),(68.78,5987.52),(68.87,6010.20),(68.95,6032.88),(69.03,6055.56),(69.12,6078.24),(69.19,6100.92),(69.27,6123.60),(69.34,6146.28),(69.41,6168.96),(69.49,6191.64),(69.57,6214.32),(69.66,6237.00),(69.77,6259.68),(69.84,6282.36),(69.91,6305.04),(69.98,6327.72),(70.06,6350.40),(70.14,6373.08),(70.22,6395.76),(70.28,6418.44),(70.36,6441.12),(70.43,6463.80),(70.50,6486.48),(70.57,6509.16),(70.64,6531.84),(70.71,6554.52),(70.79,6577.20),(70.85,6599.88),(70.94,6622.56),(71.00,6645.24),(71.08,6667.92),(71.17,6690.60),(71.24,6713.28),(71.30,6735.96),(71.37,6758.64),(71.44,6781.32),(71.51,6804.00),(71.57,6826.68),(71.64,6849.36),(71.71,6872.04),(71.79,6894.72),(71.85,6917.40),(71.92,6940.08),(72.03,6962.76),(72.09,6985.44),(72.16,7008.12),(72.23,7030.80),(72.30,7053.48),(72.36,7076.16),(72.42,7098.84),(72.48,7121.52),(72.55,7144.20),(72.61,7166.88),(72.68,7189.56),(72.74,7212.24),(72.81,7234.92),(72.87,7257.60),(72.94,7280.28),(73.00,7302.96),(73.06,7325.64),(73.13,7348.32),(73.19,7371.00),(73.25,7393.68),(73.31,7416.36),(73.37,7439.04),(73.43,7461.72),(73.50,7484.40),(73.57,7507.08),(73.64,7529.76),(73.70,7552.44),(73.77,7575.12),(73.82,7597.80),(73.88,7620.48),(73.94,7643.16),(73.99,7665.84),(74.06,7688.52),(74.11,7711.20),(74.17,7733.88),(74.21,7756.56),(74.27,7779.24),(74.33,7801.92),(74.39,7824.60),(74.45,7847.28),(74.51,7869.96),(74.56,7892.64),(74.61,7915.32),(74.67,7938.00),(74.72,7960.68),(74.79,7983.36),(74.84,8006.04),(74.90,8028.72),(74.97,8051.40),(75.02,8074.08),(75.07,8096.76),(75.14,8119.44),(75.19,8142.12),(75.24,8164.80),(75.29,8187.48),(75.34,8210.16),(75.40,8232.84),(75.46,8255.52),(75.51,8278.20),(75.56,8300.88),(75.64,8323.56),(75.72,8346.24),(75.77,8368.92),(75.82,8391.60),(75.88,8414.28),(75.93,8436.96),(75.98,8459.64),(76.03,8482.32),(76.08,8505.00),(76.13,8527.68),(76.19,8550.36),(76.24,8573.04),(76.29,8595.72),(76.33,8618.40),(76.39,8641.08),(76.44,8663.76),(76.51,8686.44),(76.56,8709.12),(76.62,8731.80),(76.68,8754.48),(76.74,8777.16),(76.78,8799.84),(76.83,8822.52),(76.87,8845.20),(76.92,8867.88),(76.97,8890.56),(77.01,8913.24),(77.05,8935.92),(77.10,8958.60),(77.15,8981.28),(77.20,9003.96),(77.25,9026.64),(77.29,9049.32),(77.34,9072.00),(77.39,9094.68),(77.43,9117.36),(77.48,9140.04),(77.53,9162.72),(77.58,9185.40),(77.62,9208.08),(77.67,9230.76),(77.71,9253.44),(77.76,9276.12),(77.81,9298.80),(77.86,9321.48),(77.90,9344.16),(77.95,9366.84),(77.99,9389.52),(78.05,9412.20),(78.10,9434.88),(78.15,9457.56),(78.19,9480.24),(78.24,9502.92),(78.29,9525.60),(78.34,9548.28),(78.38,9570.96),(78.43,9593.64),(78.47,9616.32),(78.51,9639.00),(78.56,9661.68),(78.60,9684.36),(78.64,9707.04),(78.69,9729.72),(78.73,9752.40),(78.77,9775.08),(78.82,9797.76),(78.86,9820.44),(78.90,9843.12),(78.95,9865.80),(78.99,9888.48),(79.03,9911.16),(79.07,9933.84),(79.10,9956.52),(79.15,9979.20),(79.19,10001.88),(79.24,10024.56),(79.28,10047.24),(79.33,10069.92),(79.37,10092.60),(79.40,10115.28),(79.45,10137.96),(79.49,10160.64),(79.52,10183.32),(79.56,10206.00),(79.60,10228.68),(79.64,10251.36),(79.68,10274.04),(79.72,10296.72),(79.76,10319.40),(79.80,10342.08),(79.83,10364.76),(79.87,10387.44),(79.92,10410.12),(79.98,10432.80),(80.01,10455.48),(80.06,10478.16),(80.09,10500.84),(80.13,10523.52),(80.17,10546.20),(80.21,10568.88),(80.25,10591.56),(80.29,10614.24),(80.34,10636.92),(80.37,10659.60),(80.41,10682.28),(80.46,10704.96),(80.50,10727.64),(80.54,10750.32),(80.57,10773.00),(80.60,10795.68),(80.64,10818.36),(80.68,10841.04),(80.72,10863.72),(80.76,10886.40),(80.80,10909.08),(80.83,10931.76),(80.86,10954.44),(80.92,10977.12),(80.96,10999.80),(81.00,11022.48),(81.03,11045.16),(81.07,11067.84),(81.10,11090.52),(81.14,11113.20),(81.17,11135.88),(81.20,11158.56),(81.24,11181.24),(81.28,11203.92),(81.31,11226.60),(81.35,11249.28),(81.38,11271.96),(81.42,11294.64),(81.45,11317.32),(81.49,11340.00),(81.52,11362.68),(81.56,11385.36),(81.59,11408.04),(81.63,11430.72),(81.66,11453.40),(81.69,11476.08),(81.73,11498.76),(81.76,11521.44),(81.79,11544.12),(81.82,11566.80),(81.87,11589.48),(81.90,11612.16),(81.94,11634.84),(81.97,11657.52),(82.01,11680.20),(82.05,11702.88),(82.08,11725.56),(82.11,11748.24),(82.15,11770.92),(82.18,11793.60),(82.22,11816.28),(82.25,11838.96),(82.28,11861.64),(82.31,11884.32),(82.35,11907.00),(82.37,11929.68),(82.40,11952.36),(82.43,11975.04),(82.46,11997.72),(82.49,12020.40),(82.52,12043.08),(82.56,12065.76),(82.59,12088.44),(82.63,12111.12),(82.65,12133.80),(82.69,12156.48),(82.72,12179.16),(82.75,12201.84),(82.78,12224.52),(82.81,12247.20),(82.84,12269.88),(82.87,12292.56),(82.91,12315.24),(82.94,12337.92),(82.97,12360.60),(83.01,12383.28),(83.04,12405.96),(83.07,12428.64),(83.10,12451.32),(83.14,12474.00),(83.17,12496.68),(83.22,12519.36),(83.25,12542.04),(83.27,12564.72),(83.30,12587.40),(83.33,12610.08),(83.36,12632.76),(83.39,12655.44),(83.42,12678.12),(83.45,12700.80),(83.48,12723.48),(83.50,12746.16),(83.54,12768.84),(83.57,12791.52),(83.60,12814.20),(83.63,12836.88),(83.66,12859.56),(83.70,12882.24),(83.72,12904.92),(83.75,12927.60),(83.78,12950.28),(83.82,12972.96),(83.84,12995.64),(83.87,13018.32),(83.91,13041.00),(83.94,13063.68),(83.96,13086.36),(83.99,13109.04),(84.01,13131.72),(84.05,13154.40),(84.08,13177.08),(84.10,13199.76),(84.13,13222.44),(84.15,13245.12),(84.18,13267.80),(84.20,13290.48),(84.23,13313.16),(84.25,13335.84),(84.28,13358.52),(84.32,13381.20),(84.34,13403.88),(84.37,13426.56),(84.40,13449.24),(84.43,13471.92),(84.45,13494.60),(84.48,13517.28),(84.51,13539.96),(84.54,13562.64),(84.57,13585.32),(84.60,13608.00),(84.62,13630.68),(84.65,13653.36),(84.67,13676.04),(84.71,13698.72),(84.73,13721.40),(84.75,13744.08),(84.78,13766.76),(84.81,13789.44),(84.84,13812.12),(84.86,13834.80),(84.89,13857.48),(84.92,13880.16),(84.96,13902.84),(84.99,13925.52),(85.01,13948.20),(85.04,13970.88),(85.07,13993.56),(85.10,14016.24),(85.12,14038.92),(85.14,14061.60),(85.18,14084.28),(85.20,14106.96),(85.22,14129.64),(85.25,14152.32),(85.28,14175.00),(85.30,14197.68),(85.33,14220.36),(85.35,14243.04),(85.38,14265.72),(85.41,14288.40),(85.43,14311.08),(85.46,14333.76),(85.49,14356.44),(85.51,14379.12),(85.54,14401.80),(85.56,14424.48),(85.59,14447.16),(85.61,14469.84),(85.64,14492.52),(85.66,14515.20),(85.69,14537.88),(85.71,14560.56),(85.74,14583.24),(85.76,14605.92),(85.79,14628.60),(85.81,14651.28),(85.84,14673.96),(85.86,14696.64),(85.89,14719.32),(85.91,14742.00),(85.94,14764.68),(85.96,14787.36),(85.99,14810.04),(86.01,14832.72),(86.04,14855.40),(86.06,14878.08),(86.08,14900.76),(86.11,14923.44),(86.13,14946.12),(86.15,14968.80),(86.18,14991.48),(86.21,15014.16),(86.23,15036.84),(86.26,15059.52),(86.29,15082.20),(86.31,15104.88),(86.33,15127.56),(86.35,15150.24),(86.37,15172.92),(86.40,15195.60),(86.42,15218.28),(86.44,15240.96),(86.46,15263.64),(86.49,15286.32),(86.51,15309.00),(86.54,15331.68),(86.57,15354.36),(86.59,15377.04),(86.62,15399.72),(86.64,15422.40),(86.66,15445.08),(86.68,15467.76),(86.70,15490.44),(86.72,15513.12),(86.75,15535.80),(86.77,15558.48),(86.79,15581.16),(86.82,15603.84),(86.84,15626.52),(86.87,15649.20),(86.89,15671.88),(86.91,15694.56),(86.93,15717.24),(86.95,15739.92),(86.97,15762.60),(87.00,15785.28),(87.02,15807.96),(87.04,15830.64),(87.07,15853.32),(87.09,15876.00),(87.20,15989.40),(87.32,16102.80),(87.43,16216.20),(87.54,16329.60),(87.67,16443.00),(87.76,16556.40),(87.87,16669.80),(87.98,16783.20),(88.08,16896.60),(88.18,17010.00),(88.28,17123.40),(88.38,17236.80),(88.47,17350.20),(88.58,17463.60),(88.68,17577.00),(88.78,17690.40),(88.87,17803.80),(88.96,17917.20),(89.05,18030.60),(89.15,18144.00),(89.24,18257.40),(89.34,18370.80),(89.42,18484.20),(89.51,18597.60),(89.61,18711.00),(89.69,18824.40),(89.77,18937.80),(89.86,19051.20),(89.94,19164.60),(90.03,19278.00),(90.11,19391.40),(90.20,19504.80),(90.27,19618.20),(90.35,19731.60),(90.42,19845.00),(90.50,19958.40),(90.57,20071.80),(90.65,20185.20),(90.73,20298.60),(90.81,20412.00),(90.88,20525.40),(90.96,20638.80),(91.04,20752.20),(91.13,20865.60),(91.20,20979.00),(91.28,21092.40),(91.35,21205.80),(91.42,21319.20),(91.49,21432.60),(91.57,21546.00),(91.63,21659.40),(91.70,21772.80),(91.76,21886.20),(91.84,21999.60),(91.91,22113.00),(91.97,22226.40),(92.05,22339.80),(92.11,22453.20),(92.18,22566.60),(92.24,22680.00),(92.30,22793.40),(92.36,22906.80),(92.43,23020.20),(92.48,23133.60),(92.54,23247.00),(92.60,23360.40),(92.65,23473.80),(92.70,23587.20),(92.76,23700.60),(92.82,23814.00),(92.88,23927.40),(92.93,24040.80),(92.99,24154.20),(93.05,24267.60),(93.10,24381.00),(93.16,24494.40),(93.21,24607.80),(93.27,24721.20),(93.32,24834.60),(93.37,24948.00),(93.42,25061.40),(93.47,25174.80),(93.52,25288.20),(93.57,25401.60),(93.62,25515.00),(93.67,25628.40),(93.72,25741.80),(93.77,25855.20),(93.82,25968.60),(93.86,26082.00),(93.91,26195.40),(93.96,26308.80),(94.00,26422.20),(94.05,26535.60),(94.09,26649.00),(94.14,26762.40),(94.19,26875.80),(94.23,26989.20),(94.27,27102.60),(94.31,27216.00),(94.35,27329.40),(94.40,27442.80),(94.44,27556.20),(94.48,27669.60),(94.52,27783.00),(94.56,27896.40),(94.61,28009.80),(94.66,28123.20),(94.70,28236.60),(94.74,28350.00),(94.78,28463.40),(94.82,28576.80),(94.86,28690.20),(94.90,28803.60),(94.94,28917.00),(94.98,29030.40),(95.01,29143.80),(95.05,29257.20),(95.09,29370.60),(95.12,29484.00),(95.16,29597.40),(95.19,29710.80),(95.23,29824.20),(95.26,29937.60),(95.30,30051.00),(95.34,30164.40),(95.37,30277.80),(95.40,30391.20),(95.43,30504.60),(95.47,30618.00),(95.49,30731.40),(95.53,30844.80),(95.56,30958.20),(95.59,31071.60),(95.62,31185.00),(95.66,31298.40),(95.69,31411.80),(95.72,31525.20),(95.75,31638.60),(95.78,31752.00),(95.81,31865.40),(95.84,31978.80),(95.87,32092.20),(95.90,32205.60),(95.93,32319.00),(95.96,32432.40),(95.99,32545.80),(96.02,32659.20),(96.04,32772.60),(96.08,32886.00),(96.10,32999.40),(96.13,33112.80),(96.15,33226.20),(96.18,33339.60),(96.21,33453.00),(96.23,33566.40),(96.26,33679.80),(96.29,33793.20),(96.31,33906.60),(96.33,34020.00),(96.36,34133.40),(96.38,34246.80),(96.41,34360.20),(96.43,34473.60),(96.45,34587.00),(96.48,34700.40),(96.51,34813.80),(96.53,34927.20),(96.55,35040.60),(96.58,35154.00),(96.60,35267.40),(96.62,35380.80),(96.65,35494.20),(96.67,35607.60),(96.70,35721.00),(96.72,35834.40),(96.74,35947.80),(96.76,36061.20),(96.79,36174.60),(96.81,36288.00),(96.83,36401.40),(96.85,36514.80),(96.87,36628.20),(96.89,36741.60),(96.91,36855.00),(96.93,36968.40),(96.95,37081.80),(96.97,37195.20),(97.01,37308.60),(97.03,37422.00),(97.05,37535.40),(97.07,37648.80),(97.08,37762.20),(97.10,37875.60),(97.12,37989.00),(97.14,38102.40),(97.16,38215.80),(97.18,38329.20),(97.20,38442.60),(97.21,38556.00),(97.23,38669.40),(97.25,38782.80),(97.27,38896.20),(97.29,39009.60),(97.30,39123.00),(97.32,39236.40),(97.34,39349.80),(97.35,39463.20),(97.37,39576.60),(97.38,39690.00),(97.40,39803.40),(97.41,39916.80),(97.43,40030.20),(97.45,40143.60),(97.47,40257.00),(97.48,40370.40),(97.50,40483.80),(97.51,40597.20),(97.53,40710.60),(97.54,40824.00),(97.56,40937.40),(97.58,41050.80),(97.59,41164.20),(97.60,41277.60),(97.62,41391.00),(97.63,41504.40),(97.65,41617.80),(97.66,41731.20),(97.68,41844.60),(97.69,41958.00),(97.71,42071.40),(97.72,42184.80),(97.73,42298.20),(97.75,42411.60),(97.76,42525.00),(97.77,42638.40),(97.79,42751.80),(97.80,42865.20),(97.82,42978.60),(97.83,43092.00),(97.84,43205.40),(97.86,43318.80),(97.87,43432.20),(97.88,43545.60),(97.89,43659.00),(97.91,43772.40),(97.92,43885.80),(97.93,43999.20),(97.94,44112.60),(97.96,44226.00),(97.97,44339.40),(97.98,44452.80),(97.99,44566.20),(98.00,44679.60),(98.01,44793.00),(98.03,44906.40),(98.04,45019.80),(98.05,45133.20),(98.06,45246.60),(98.07,45360.00),(98.08,45473.40),(98.09,45586.80),(98.11,45700.20),(98.12,45813.60),(98.13,45927.00),(98.14,46040.40),(98.15,46153.80),(98.16,46267.20),(98.17,46380.60),(98.18,46494.00),(98.19,46607.40),(98.20,46720.80),(98.21,46834.20),(98.22,46947.60),(98.23,47061.00),(98.24,47174.40),(98.25,47287.80),(98.26,47401.20),(98.27,47514.60),(98.28,47628.00),(98.29,47741.40),(98.30,47854.80),(98.31,47968.20),(98.32,48081.60),(98.33,48195.00),(98.34,48308.40),(98.35,48421.80),(98.36,48535.20),(98.37,48648.60),(98.38,48762.00),(98.39,48875.40),(98.40,48988.80),(98.41,49215.60),(98.42,49329.00),(98.43,49442.40),(98.44,49555.80),(98.45,49669.20),(98.46,49896.00),(98.47,50009.40),(98.48,50122.80),(98.49,50236.20),(98.50,50349.60),(98.51,50576.40),(98.52,50689.80),(98.53,50803.20),(98.54,50916.60),(98.55,51143.40),(98.56,51256.80),(98.57,51370.20),(98.58,51483.60),(98.59,51710.40),(98.60,51823.80),(98.61,51937.20),(98.62,52164.00),(98.63,52277.40),(98.64,52390.80),(98.65,52617.60),(98.66,52731.00),(98.67,52844.40),(98.68,52957.80),(98.69,53184.60),(98.70,53298.00),(98.71,53411.40),(98.72,53638.20),(98.73,53751.60),(98.74,53978.40),(98.75,54091.80),(98.76,54318.60),(98.77,54432.00),(98.78,54658.80),(98.79,54772.20),(98.80,54999.00),(98.81,55112.40),(98.82,55339.20),(98.83,55566.00),(98.84,55679.40),(98.85,55906.20),(98.86,56133.00),(98.87,56359.80),(98.88,56586.60),(98.89,56700.00),(98.90,56926.80),(98.91,57153.60),(98.92,57267.00),(98.93,57493.80),(98.94,57720.60),(98.95,57834.00),(98.96,58060.80),(98.97,58287.60),(98.98,58627.80),(98.99,58741.20),(99.00,59081.40),(99.01,59308.20),(99.02,59535.00),(99.03,59761.80),(99.04,59988.60),(99.05,60215.40),(99.06,60442.20),(99.07,60782.40),(99.08,61009.20),(99.09,61236.00),(99.10,61576.20),(99.11,61803.00),(99.12,62029.80),(99.13,62256.60),(99.14,62596.80),(99.15,62937.00),(99.16,63163.80),(99.17,63504.00),(99.18,63844.20),(99.19,64184.40),(99.20,64411.20),(99.21,64751.40),(99.22,64978.20),(99.23,65431.80),(99.24,65772.00),(99.25,65998.80),(99.26,66339.00),(99.27,66679.20),(99.28,67019.40),(99.29,67359.60),(99.30,67699.80),(99.31,68040.00),(99.32,68493.60),(99.33,68947.20),(99.34,69400.80),(99.35,69741.00),(99.36,70081.20),(99.37,70648.20),(99.38,70988.40),(99.39,71328.60),(99.40,71782.20),(99.41,72122.40),(99.42,72576.00),(99.43,73029.60),(99.44,73483.20),(99.45,73936.80),(99.46,74390.40),(99.47,74844.00),(99.48,75297.60),(99.49,75864.60),(99.50,76431.60),(99.51,76998.60),(99.52,77565.60),(99.53,78019.20),(99.54,78586.20),(99.55,79153.20),(99.57,80514.00),(99.58,81648.00),(99.60,82782.00),(99.61,83916.00),(99.63,85050.00),(99.64,86184.00),(99.65,87318.00),(99.66,88452.00),(99.68,89586.00),(99.69,90720.00),(99.70,91854.00),(99.71,92988.00),(99.72,94122.00),(99.73,95256.00),(99.75,96390.00),(99.76,97524.00),(99.77,99792.00),(99.78,100926.00),(99.79,103194.00),(99.80,104328.00),(99.81,106596.00),(99.82,108864.00),(99.83,111132.00),(99.84,113400.00),(99.85,114534.00),(99.86,117936.00),(99.87,121338.00),(99.88,124740.00),(99.89,128142.00),(99.90,132678.00),(99.91,138348.00),(99.92,142884.00),(99.93,145152.00),(99.94,153090.00),(99.95,163296.00),(99.96,175770.00),(99.97,190512.00),(99.98,209790.00),(99.99,340200.00);
/*!40000 ALTER TABLE `income_rank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intervention`
--

DROP TABLE IF EXISTS `intervention`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intervention` (
  `intervention_name` varchar(64) NOT NULL,
  `qaly` decimal(4,2) DEFAULT NULL,
  `problem` int NOT NULL,
  PRIMARY KEY (`intervention_name`,`problem`),
  UNIQUE KEY `intervention_name` (`intervention_name`),
  KEY `problem` (`problem`),
  CONSTRAINT `intervention_ibfk_1` FOREIGN KEY (`problem`) REFERENCES `problem` (`problem_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intervention`
--

LOCK TABLES `intervention` WRITE;
/*!40000 ALTER TABLE `intervention` DISABLE KEYS */;
INSERT INTO `intervention` VALUES ('Animal rights advocacy',NULL,1),('Cash transfers',NULL,4),('Coordinated poverty alleviation',NULL,4),('Deworming',NULL,3),('Evaluating solutions to global poverty',NULL,16),('Improving welfare standards for farmed animals',NULL,1),('Long-lasting insecticidal bed nets',NULL,2),('Low cost vision care',NULL,12),('Malaria nets',NULL,2),('Media health campaigns',NULL,14),('Nuclear disarmament advocacy',NULL,8),('Policy and technology changes in the global energy system',NULL,11),('Restorative surgery',NULL,13),('Vitamin supplementation',NULL,5),('Wild animal suffering research',NULL,18);
/*!40000 ALTER TABLE `intervention` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `problem`
--

DROP TABLE IF EXISTS `problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `problem` (
  `problem_id` int NOT NULL AUTO_INCREMENT,
  `problem_name` varchar(64) NOT NULL,
  `cause` int NOT NULL,
  PRIMARY KEY (`problem_id`),
  UNIQUE KEY `problem_name` (`problem_name`),
  KEY `cause` (`cause`),
  CONSTRAINT `problem_ibfk_1` FOREIGN KEY (`cause`) REFERENCES `cause_area` (`cause_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `problem`
--

LOCK TABLES `problem` WRITE;
/*!40000 ALTER TABLE `problem` DISABLE KEYS */;
INSERT INTO `problem` VALUES (1,'Factory Farming',1),(2,'Malaria',2),(3,'Schistosomiasis',2),(4,'Economic inequality and social injustice',2),(5,'Malnutrition',2),(6,'Potential Risks from Advanced Artificial Intelligence',3),(7,'Biosecurity and Pandemic Preparedness',5),(8,'Nuclear Arms Control',5),(9,'Criminal Justice Reform',6),(10,'Immigration Policy',8),(11,'Climate Change',5),(12,'Avoidable blindness',2),(13,'Obstetric fistula',2),(14,'Lack of access to health and wellness information',2),(16,'Lack of evidence on how to reduce global poverty',2),(17,'Lack of advocacy-relevant animal sufferring research',1),(18,'Wild animal suffering',1);
/*!40000 ALTER TABLE `problem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project` (
  `intervention` varchar(64) NOT NULL,
  `charity` int NOT NULL,
  `project_name` varchar(64) NOT NULL,
  `year_init` year NOT NULL,
  `project_status` enum('Active','Completed','Planned','Frozen') NOT NULL,
  PRIMARY KEY (`project_name`,`charity`,`intervention`),
  UNIQUE KEY `project_name` (`project_name`),
  KEY `intervention` (`intervention`),
  KEY `charity` (`charity`),
  CONSTRAINT `project_ibfk_1` FOREIGN KEY (`intervention`) REFERENCES `intervention` (`intervention_name`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `project_ibfk_2` FOREIGN KEY (`charity`) REFERENCES `charity` (`charity_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES ('Cash transfers',7,'Cash Transfers in Africa',2008,'Active'),('Improving welfare standards for farmed animals',18,'Corporate outreach program',2020,'Active'),('Restorative surgery',5,'Cost-Effective Restorative surgeries',2009,'Active'),('Deworming',4,'Deworm the World Initiative',2013,'Active'),('Restorative surgery',4,'Dispensers for Safe Water',2013,'Active'),('Long-lasting insecticidal bed nets',1,'Distributing bed nets in Africa',2004,'Active'),('Vitamin supplementation',9,'Global VAS Program',2007,'Active'),('Wild animal suffering research',17,'Grant Assistance Program',2020,'Active'),('Animal rights advocacy',16,'Improving Animal Welfare Standards',2011,'Active'),('Evaluating solutions to global poverty',10,'IPA Global Poverty Solutions Evidence Program',2002,'Active'),('Cash transfers',7,'Kenya Universal Basic Income initiative',2016,'Active'),('Media health campaigns',3,'KINSHASA FAMILY PLANNING MASS MEDIA CAMPAIGN',2015,'Completed'),('Media health campaigns',3,'Kinshasha Family Planning Mass Media Campaign',2015,'Completed'),('Low cost vision care',6,'Low Cost Cataract Surgeries',1992,'Active'),('Media health campaigns',3,'TB REACH',2020,'Completed'),('Vitamin supplementation',8,'Universal Salt Iodization',2008,'Active');
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `source`
--

DROP TABLE IF EXISTS `source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `source` (
  `source_id` int NOT NULL AUTO_INCREMENT,
  `source_name` varchar(64) NOT NULL,
  PRIMARY KEY (`source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `source`
--

LOCK TABLES `source` WRITE;
/*!40000 ALTER TABLE `source` DISABLE KEYS */;
INSERT INTO `source` VALUES (1,'Read about it in the \"Doing Dood Better\" book'),(2,'Read about it in the \"The Life You Can Save\" book'),(3,'Read about it on the \"80000 Hours\" website'),(4,'Heard about it on the \"80000 Hours\" podcast'),(5,'Google Search'),(6,'Word of mouth'),(7,'Other');
/*!40000 ALTER TABLE `source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'effective_giving'
--

--
-- Dumping routines for database 'effective_giving'
--
/*!50003 DROP FUNCTION IF EXISTS `checkCauseAreaMatch` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `checkCauseAreaMatch`(inter_ VARCHAR(128), char_ INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE check_ BOOLEAN;
    SET check_ = FALSE;
    IF -- compare causes from intervention table and charity table
	(SELECT cause FROM intervention
    LEFT JOIN problem
    ON intervention.problem = problem.problem_id
    WHERE intervention_name = inter_) =
    (SELECT charity_cause FROM charity WHERE charity_id = char_)
    THEN
		SET check_ = TRUE;
	END IF;
    RETURN check_;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `checkEmail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `checkEmail`(email_id VARCHAR(128)) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE check_ BOOLEAN;
    IF EXISTS(SELECT email FROM donor WHERE email = email_id) THEN
		SET check_ = FALSE;
	ELSE SET check_ = TRUE;
    END IF;
    RETURN check_;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getIncomeRank` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getIncomeRank`(income DECIMAL(9,2)) RETURNS decimal(4,2)
    DETERMINISTIC
BEGIN
	DECLARE rank_ DECIMAL(4, 2) DEFAULT 0;
	DECLARE income_ DECIMAL(9, 2) DEFAULT 0;
	DECLARE counter INT DEFAULT 0;
	DECLARE total_ranks INT;
	DECLARE condition_ DECIMAL(9,2);
	SET total_ranks = (SELECT COUNT(*) FROM income_rank);

	WHILE counter < total_ranks DO
		SET condition_ = (SELECT annual_income FROM income_rank LIMIT counter, 1);
        IF  condition_ > income_ AND condition_ < income THEN
		SET income_ = (SELECT annual_income FROM income_rank LIMIT counter, 1);
		END IF;
        SET counter = counter + 1;
	END WHILE;
	SET rank_ = (SELECT percentile FROM income_rank WHERE annual_income = income_);
	RETURN(rank_);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addDonation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addDonation`(donor INT, charity INT, amount INT)
BEGIN
    DECLARE date DATETIME;
    SET date = NOW();
    INSERT INTO donation(donation_donor, donation_charity, donation_datetime, donation_amount) VALUES
    (donor, charity, date, amount);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addDonor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addDonor`(first VARCHAR(128), last VARCHAR(128), mail VARCHAR(128),
country INT, source_ INT, income DECIMAL(9,2))
BEGIN
    DECLARE percentile DECIMAL(4, 2);
	IF checkEmail(mail) IS FALSE THEN -- generate error if donor already exists
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Email ID already exists';
    ELSE
		SET percentile = getIncomeRank(income);
		INSERT INTO donor(first_name, last_name, email, donor_country, source, income_rank)
		VALUES (first, last, mail, country, source_, percentile);
	END IF;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addProject` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addProject`(intervention_ VARCHAR(128), charity_ INT, name VARCHAR(128), year INT, status VARCHAR(128))
BEGIN
    -- check if project doesn't already exist
    IF (intervention_, charity_, name) IN (SELECT intervention, charity, project_name FROM project) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Project already exists';
	ELSEIF (year < 1970 OR year > YEAR(NOW())) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Invalid year';
	ELSEIF checkCauseAreaMatch(intervention_, charity_) IS FALSE THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "Intervention and Charity's cause don't match";
	ELSE
		INSERT INTO project(intervention, charity, project_name, year_init, project_status)
		VALUES (intervention_, charity_, name, year, status);
	END IF;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllCountries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllCountries`()
BEGIN
	SELECT country_id AS "ID", country_name AS "country" FROM country;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCauseAreas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCauseAreas`()
BEGIN
	SELECT cause_id AS "ID", cause_name AS "Causes" FROM cause_area;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCauseProblems` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCauseProblems`(causeID INT)
BEGIN
	IF causeID NOT IN (SELECT cause_id FROM cause_area) THEN -- generate error if cause does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cause does not exist';
	ELSE
		SELECT problem_id AS "ID", problem_name AS "problem" FROM problem
		WHERE cause = causeID;
	END IF;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCharities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCharities`()
BEGIN
	SELECT charity_id, charity_name, charity_website, charity_type, cause_name,
	       donations_link
	FROM charity
    LEFT JOIN cause_area
    ON charity_cause = cause_id;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCharitiesFromCause` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCharitiesFromCause`(IN id INT)
BEGIN
	IF id NOT IN (SELECT cause_id FROM cause_area) THEN -- generate error if cause does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Cause does not exist';
    ELSE
		SELECT charity_id AS "id", charity_name AS "charity", charity_website AS "website", charity_type AS
		"charity type" FROM
		charity
		WHERE charity_cause = id;
	END IF;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getDonations` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDonations`()
BEGIN
	SELECT donation_id, first_name, charity_name, donation_datetime, donation_amount
	FROM donation
    LEFT JOIN donor on donation.donation_donor = donor.donor_id
    left join charity on donation.donation_charity = charity.charity_id;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getDonorId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDonorId`(IN email_id VARCHAR(128))
BEGIN
	IF email_id NOT IN (SELECT email FROM donor) THEN -- generate error if donor does not exist
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Donor does not exist';
	ELSE
		SELECT donor_id FROM donor WHERE email = email_id;
    END IF;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getDonors` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDonors`()
BEGIN
	SELECT donor_id, first_name, last_name, email, country_name, source_name, income_rank
	FROM donor
    LEFT JOIN country on donor_country = country_id
    left join source on source = source_id;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getEvaluators` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEvaluators`()
BEGIN
	SELECT DISTINCT evaluator_id AS "ID", evaluator_name as "Evaluator", evaluator_website AS "Website" FROM evaluator
    WHERE evaluator_id IN (SELECT evaluator FROM evaluation);
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getInterventions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getInterventions`()
BEGIN
	SELECT intervention_name, qaly, problem_name FROM intervention
    LEFT JOIN problem
    ON problem = problem.problem_id;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getLastEvaluatedCharities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getLastEvaluatedCharities`(evaluator_ INT)
BEGIN
    DECLARE year INT;
	IF evaluator_ NOT IN (SELECT evaluator_id FROM evaluator) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Evaluator does not exist';
	ELSE
		SELECT MAX(evaluation_year) INTO year FROM evaluation;
		SELECT charity as "ID", charity_name AS "charity", effectiveness_rank AS "rank", charity_website AS "website",
		charity_type AS "charity type" FROM
		(SELECT * FROM evaluation
			LEFT JOIN charity -- evaluation x charity
			ON evaluation.charity = charity.charity_id
			WHERE (evaluation_year = year AND evaluator = evaluator_)
			ORDER BY effectiveness_rank) AS T1;
	END IF;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getProblems` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getProblems`()
BEGIN
	SELECT problem_id, problem_name, cause, cause_name FROM problem
    LEFT JOIN cause_area
    ON cause = cause_id;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getProjects` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getProjects`()
BEGIN
	SELECT intervention, charity_name, project_name, year_init, project_status
	FROM project
    LEFT JOIN charity
    ON charity = charity.charity_id;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getSources` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSources`()
BEGIN
	SELECT source_id AS "ID", source_name AS "source" FROM source;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-05-01  9:48:33
