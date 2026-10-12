-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: 127.0.0.1    Database: soporte_ti
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categorias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (4,'Accesos'),(1,'Hardware'),(5,'Otros'),(3,'Redes'),(2,'Software');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notificaciones` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `usuario_id` int(10) unsigned NOT NULL,
  `referencia_ticket` int(10) unsigned NOT NULL,
  `tipo` enum('Asignacion','Estado','Comentario') NOT NULL,
  `mensaje` varchar(255) NOT NULL,
  `leido` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_notificacion_ticket` (`referencia_ticket`),
  KEY `idx_usuario_leido_fecha` (`usuario_id`,`leido`,`created_at`),
  CONSTRAINT `fk_notificacion_ticket` FOREIGN KEY (`referencia_ticket`) REFERENCES `tickets` (`id`),
  CONSTRAINT `fk_notificacion_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones`
--

LOCK TABLES `notificaciones` WRITE;
/*!40000 ALTER TABLE `notificaciones` DISABLE KEYS */;
INSERT INTO `notificaciones` VALUES (1,3,1,'Asignacion','Ticket #1: Asignación de ejemplo al equipo de soporte.',0,'2026-09-21 22:34:27'),(2,2,1,'Asignacion','Ticket #1: Asignación de ejemplo al equipo de soporte.',0,'2026-09-21 22:34:27'),(3,3,1,'Estado','Ticket #1: Se inició la revisión del incidente.',0,'2026-09-21 22:39:27'),(4,3,3,'Asignacion','Ticket #3: Asignación de ejemplo al equipo de soporte.',0,'2026-09-21 20:52:27'),(5,2,3,'Asignacion','Ticket #3: Asignación de ejemplo al equipo de soporte.',0,'2026-09-21 20:52:27'),(6,3,3,'Estado','Ticket #3: Se inició la revisión del incidente.',0,'2026-09-21 20:57:27'),(7,3,4,'Asignacion','Ticket #4: Asignación de ejemplo al equipo de soporte.',0,'2026-09-21 17:52:27'),(8,2,4,'Asignacion','Ticket #4: Asignación de ejemplo al equipo de soporte.',0,'2026-09-21 17:52:27'),(9,3,4,'Estado','Ticket #4: Se inició la revisión del incidente.',0,'2026-09-21 17:57:27'),(10,3,4,'Estado','Ticket #4: Acceso habilitado y verificado.',0,'2026-09-21 19:42:27');
/*!40000 ALTER TABLE `notificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prioridades`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prioridades` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(10) NOT NULL,
  `horas_sla` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  CONSTRAINT `chk_horas_sla` CHECK (`horas_sla` > 0)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prioridades`
--

LOCK TABLES `prioridades` WRITE;
/*!40000 ALTER TABLE `prioridades` DISABLE KEYS */;
INSERT INTO `prioridades` VALUES (1,'Alta',4),(2,'Media',24),(3,'Baja',72);
/*!40000 ALTER TABLE `prioridades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_fotos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_fotos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `nombre_original` varchar(255) NOT NULL,
  `archivo` varchar(80) NOT NULL,
  `mime` varchar(30) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `archivo` (`archivo`),
  KEY `fk_foto_ticket` (`ticket_id`),
  CONSTRAINT `fk_foto_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_fotos`
--

LOCK TABLES `ticket_fotos` WRITE;
/*!40000 ALTER TABLE `ticket_fotos` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_fotos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_historial`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ticket_historial` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(10) unsigned NOT NULL,
  `usuario_id` int(10) unsigned NOT NULL,
  `tipo` enum('Registro','Asignacion','Estado','Comentario') NOT NULL,
  `estado_anterior` varchar(15) DEFAULT NULL,
  `estado_nuevo` varchar(15) DEFAULT NULL,
  `tecnico_anterior_id` int(10) unsigned DEFAULT NULL,
  `tecnico_nuevo_id` int(10) unsigned DEFAULT NULL,
  `comentario` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_historial_usuario` (`usuario_id`),
  KEY `fk_historial_anterior` (`tecnico_anterior_id`),
  KEY `fk_historial_nuevo` (`tecnico_nuevo_id`),
  KEY `idx_historial_fecha` (`ticket_id`,`created_at`),
  CONSTRAINT `fk_historial_anterior` FOREIGN KEY (`tecnico_anterior_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_historial_nuevo` FOREIGN KEY (`tecnico_nuevo_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_historial_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`),
  CONSTRAINT `fk_historial_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `users` (`id`),
  CONSTRAINT `chk_comentario` CHECK (char_length(trim(`comentario`)) > 0)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_historial`
--

LOCK TABLES `ticket_historial` WRITE;
/*!40000 ALTER TABLE `ticket_historial` DISABLE KEYS */;
INSERT INTO `ticket_historial` VALUES (1,1,3,'Registro',NULL,'Abierto',NULL,NULL,'Registro de ejemplo.','2026-09-21 22:24:27'),(2,1,1,'Asignacion',NULL,NULL,NULL,2,'Asignación de ejemplo al equipo de soporte.','2026-09-21 22:34:27'),(3,1,2,'Estado','Abierto','En proceso',NULL,NULL,'Se inició la revisión del incidente.','2026-09-21 22:39:27'),(4,2,3,'Registro',NULL,'Abierto',NULL,NULL,'Registro de ejemplo.','2026-09-21 23:42:27'),(5,3,3,'Registro',NULL,'Abierto',NULL,NULL,'Registro de ejemplo.','2026-09-21 20:42:27'),(6,3,1,'Asignacion',NULL,NULL,NULL,2,'Asignación de ejemplo al equipo de soporte.','2026-09-21 20:52:27'),(7,3,2,'Estado','Abierto','En proceso',NULL,NULL,'Se inició la revisión del incidente.','2026-09-21 20:57:27'),(8,4,3,'Registro',NULL,'Abierto',NULL,NULL,'Registro de ejemplo.','2026-09-21 17:42:27'),(9,4,1,'Asignacion',NULL,NULL,NULL,2,'Asignación de ejemplo al equipo de soporte.','2026-09-21 17:52:27'),(10,4,2,'Estado','Abierto','En proceso',NULL,NULL,'Se inició la revisión del incidente.','2026-09-21 17:57:27'),(11,4,2,'Estado','En proceso','Resuelto',NULL,NULL,'Acceso habilitado y verificado.','2026-09-21 19:42:27');
/*!40000 ALTER TABLE `ticket_historial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tickets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `asunto` varchar(150) NOT NULL,
  `descripcion` text NOT NULL,
  `categoria_id` int(10) unsigned NOT NULL,
  `prioridad_id` int(10) unsigned NOT NULL,
  `solicitante_id` int(10) unsigned NOT NULL,
  `tecnico_id` int(10) unsigned DEFAULT NULL,
  `estado` enum('Abierto','En proceso','Resuelto','Cerrado') NOT NULL DEFAULT 'Abierto',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_limite` datetime NOT NULL,
  `fecha_resolucion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ticket_categoria` (`categoria_id`),
  KEY `fk_ticket_prioridad` (`prioridad_id`),
  KEY `idx_estado_limite` (`estado`,`fecha_limite`),
  KEY `idx_solicitante_fecha` (`solicitante_id`,`created_at`),
  KEY `idx_tecnico_estado` (`tecnico_id`,`estado`),
  CONSTRAINT `fk_ticket_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`),
  CONSTRAINT `fk_ticket_prioridad` FOREIGN KEY (`prioridad_id`) REFERENCES `prioridades` (`id`),
  CONSTRAINT `fk_ticket_solicitante` FOREIGN KEY (`solicitante_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_ticket_tecnico` FOREIGN KEY (`tecnico_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
INSERT INTO `tickets` VALUES (1,'No puedo conectarme a la red de oficina','La conexión por cable se interrumpe desde esta mañana. Se reinició el equipo y el problema continúa.',3,1,3,2,'En proceso','2026-09-21 22:24:27','2026-09-21 22:24:27','2026-09-22 02:24:27',NULL),(2,'La impresora no reconoce el papel','La impresora del área indica falta de papel aunque la bandeja está completa.',1,2,3,NULL,'Abierto','2026-09-21 23:42:27','2026-09-21 23:42:27','2026-09-22 23:42:27',NULL),(3,'Error al abrir el sistema de asistencia','Al iniciar el sistema aparece un error de conexión al servidor y no permite registrar la asistencia.',2,1,3,2,'En proceso','2026-09-21 20:42:27','2026-09-21 20:42:27','2026-09-22 00:42:27',NULL),(4,'Solicitud de acceso a carpeta compartida','Se requiere acceso a la carpeta de documentos del área para continuar las tareas asignadas.',4,3,3,2,'Resuelto','2026-09-21 17:42:27','2026-09-21 19:42:27','2026-09-24 17:42:27','2026-09-21 19:42:27');
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol` enum('Administrador','Tecnico','Solicitante') NOT NULL DEFAULT 'Solicitante',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Ana','Administradora','admin@demo.local','scrypt:32768:8:1$to1X8EPvX1rKhi5T$8cb2412df71cf9ebfba61325215240177d199c31934f9021683fd761f7a941c5356aa8f38ac5e4b458fe00f8ea3d20ef5d46ed66bd2243ef1a3379054f5d3e6e','Administrador',1,'2026-09-22 01:42:26'),(2,'Luis','Soporte','tecnico@demo.local','scrypt:32768:8:1$bgR0lTOHK5EErcNN$a2d0a8381dd15a04b0e77dcdf5dbde4f5f7fd17f4f5e38f6709f6c11ee78e2a54311c5aa109595c2865d04034b01325ed6c7c7a5ede3110864a13403d8ee0ea5','Tecnico',1,'2026-09-22 01:42:27'),(3,'Carla','Solicitante','solicitante@demo.local','scrypt:32768:8:1$xr5of50NhgoBxDf4$64cca6fdee8530f0ea820374ab81bc3ec2616c93bd6c7d45c3cf8f6d89fe80784059e39a28c13e964a550a160081b261da0e8c1f6eebe4030ed0a87b95f665a4','Solicitante',1,'2026-09-22 01:42:27');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'soporte_ti'
--

--
-- Dumping routines for database 'soporte_ti'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-29 13:42:07
