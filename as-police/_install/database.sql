-- AS-Police Database Schema
-- This file contains the database structure for the as-police resource

-- Jail Records
CREATE TABLE IF NOT EXISTS `jail_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `officer_identifier` varchar(60) NOT NULL,
  `time` int(11) NOT NULL,
  `reason` text NOT NULL,
  `jailed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `released` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`),
  KEY `released` (`released`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Warrants
CREATE TABLE IF NOT EXISTS `warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `issued_by` varchar(60) NOT NULL,
  `reason` text NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `executed_by` varchar(60) DEFAULT NULL,
  `executed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Evidence
CREATE TABLE IF NOT EXISTS `evidence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `coords` text NOT NULL,
  `data` text NOT NULL,
  `collected_by` varchar(60) DEFAULT NULL,
  `collected_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `type` (`type`),
  KEY `collected_by` (`collected_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Police Reports
CREATE TABLE IF NOT EXISTS `police_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `officer_identifier` varchar(60) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `suspects` text DEFAULT NULL,
  `witnesses` text DEFAULT NULL,
  `evidence` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `officer_identifier` (`officer_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Police Fines
CREATE TABLE IF NOT EXISTS `police_fines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `officer_identifier` varchar(60) NOT NULL,
  `citizen_identifier` varchar(60) NOT NULL,
  `amount` int(11) NOT NULL,
  `reason` text NOT NULL,
  `issued_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `paid` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `officer_identifier` (`officer_identifier`),
  KEY `citizen_identifier` (`citizen_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dispatch Logs
CREATE TABLE IF NOT EXISTS `dispatch_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) NOT NULL,
  `code` varchar(10) NOT NULL,
  `coords` text NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;