-- =====================================================
-- AS FRAMEWORK - COMPLETE DATABASE SCHEMA
-- =====================================================
-- This file contains all database tables for the AS Framework
-- Including: Core, Banking, Police, Ambulance, and Drugs
-- =====================================================

-- =====================================================
-- AS-CORE TABLES
-- =====================================================

-- Users table - Main player data
CREATE TABLE IF NOT EXISTS `users` (
    `identifier` VARCHAR(60) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `money` LONGTEXT NULL DEFAULT NULL,
    `job` VARCHAR(50) DEFAULT 'unemployed',
    `job_grade` INT(11) DEFAULT 0,
    `group` VARCHAR(50) DEFAULT 'user',
    `position` VARCHAR(255) DEFAULT NULL,
    `inventory` LONGTEXT NULL DEFAULT NULL,
    `metadata` LONGTEXT NULL DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `last_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`),
    KEY `job` (`job`),
    KEY `group` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User characters table - For multi-character support
CREATE TABLE IF NOT EXISTS `user_characters` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(60) NOT NULL,
    `char_id` INT(11) NOT NULL,
    `firstname` VARCHAR(50) NOT NULL,
    `lastname` VARCHAR(50) NOT NULL,
    `dateofbirth` VARCHAR(25) NOT NULL,
    `sex` VARCHAR(1) NOT NULL DEFAULT 'M',
    `height` INT(11) NOT NULL DEFAULT 175,
    `appearance` LONGTEXT NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `identifier` (`identifier`),
    UNIQUE KEY `identifier_charid` (`identifier`, `char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Jobs table
CREATE TABLE IF NOT EXISTS `jobs` (
    `name` VARCHAR(50) NOT NULL,
    `label` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Job grades table
CREATE TABLE IF NOT EXISTS `job_grades` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `job_name` VARCHAR(50) NOT NULL,
    `grade` INT(11) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `label` VARCHAR(50) NOT NULL,
    `salary` INT(11) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `job_name` (`job_name`),
    UNIQUE KEY `job_grade` (`job_name`, `grade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Vehicles table
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `owner` VARCHAR(60) NOT NULL,
    `plate` VARCHAR(12) NOT NULL,
    `vehicle` LONGTEXT NOT NULL,
    `type` VARCHAR(20) NOT NULL DEFAULT 'car',
    `garage` VARCHAR(50) DEFAULT NULL,
    `stored` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `owner` (`owner`),
    UNIQUE KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- AS-BANKING TABLES
-- =====================================================

-- Bank Cards Table
CREATE TABLE IF NOT EXISTS `bank_cards` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `citizenid` VARCHAR(50) NOT NULL,
    `card_number` VARCHAR(16) NOT NULL UNIQUE,
    `pin` VARCHAR(4) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `active` TINYINT(1) DEFAULT 1,
    INDEX `citizenid_index` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bank Transactions Table
CREATE TABLE IF NOT EXISTS `bank_transactions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `citizenid` VARCHAR(50) NOT NULL,
    `transaction_type` VARCHAR(50) NOT NULL,
    `amount` INT NOT NULL,
    `from_account` VARCHAR(50) NULL,
    `to_account` VARCHAR(50) NULL,
    `description` VARCHAR(255) DEFAULT '',
    `balance_after` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `citizenid_index` (`citizenid`),
    INDEX `type_index` (`transaction_type`),
    INDEX `date_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bank Loans Table
CREATE TABLE IF NOT EXISTS `bank_loans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `citizenid` VARCHAR(50) NOT NULL,
    `amount` INT NOT NULL,
    `interest_rate` DECIMAL(5,2) NOT NULL,
    `remaining` INT NOT NULL,
    `payment_amount` INT NOT NULL,
    `payment_due` TIMESTAMP NULL,
    `status` VARCHAR(20) DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `citizenid_index` (`citizenid`),
    INDEX `status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- AS-POLICE TABLES
-- =====================================================

-- Jail Records
CREATE TABLE IF NOT EXISTS `jail_records` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(60) NOT NULL,
    `officer_identifier` VARCHAR(60) NOT NULL,
    `time` INT(11) NOT NULL,
    `reason` TEXT NOT NULL,
    `jailed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `released` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `identifier` (`identifier`),
    KEY `released` (`released`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Warrants
CREATE TABLE IF NOT EXISTS `warrants` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(60) NOT NULL,
    `issued_by` VARCHAR(60) NOT NULL,
    `reason` TEXT NOT NULL,
    `expires_at` TIMESTAMP NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `executed_by` VARCHAR(60) DEFAULT NULL,
    `executed_at` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `identifier` (`identifier`),
    KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Evidence
CREATE TABLE IF NOT EXISTS `evidence` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `type` VARCHAR(50) NOT NULL,
    `coords` TEXT NOT NULL,
    `data` TEXT NOT NULL,
    `collected_by` VARCHAR(60) DEFAULT NULL,
    `collected_at` TIMESTAMP NULL DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `type` (`type`),
    KEY `collected_by` (`collected_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Police Reports
CREATE TABLE IF NOT EXISTS `police_reports` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `officer_identifier` VARCHAR(60) NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT NOT NULL,
    `suspects` TEXT DEFAULT NULL,
    `witnesses` TEXT DEFAULT NULL,
    `evidence` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `officer_identifier` (`officer_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Police Fines
CREATE TABLE IF NOT EXISTS `police_fines` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `officer_identifier` VARCHAR(60) NOT NULL,
    `citizen_identifier` VARCHAR(60) NOT NULL,
    `amount` INT(11) NOT NULL,
    `reason` TEXT NOT NULL,
    `issued_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `paid` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `officer_identifier` (`officer_identifier`),
    KEY `citizen_identifier` (`citizen_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dispatch Logs
CREATE TABLE IF NOT EXISTS `dispatch_logs` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `type` VARCHAR(50) NOT NULL,
    `code` VARCHAR(10) NOT NULL,
    `coords` TEXT NOT NULL,
    `message` TEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- AS-AMBULANCE TABLES
-- =====================================================

-- Medical records table
CREATE TABLE IF NOT EXISTS `ambulance_records` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(60) NOT NULL,
    `event_type` ENUM('death', 'revive', 'heal') NOT NULL,
    `ems_identifier` VARCHAR(60) DEFAULT NULL,
    `cause` VARCHAR(255) DEFAULT NULL,
    `location` VARCHAR(255) DEFAULT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `identifier_idx` (`identifier`),
    INDEX `ems_idx` (`ems_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- AS-DRUGS TABLES
-- =====================================================

-- Drug sales log table
CREATE TABLE IF NOT EXISTS `drug_sales` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `seller_identifier` VARCHAR(60) NOT NULL,
    `seller_name` VARCHAR(100) NOT NULL,
    `buyer_identifier` VARCHAR(60) DEFAULT NULL,
    `buyer_name` VARCHAR(100) DEFAULT NULL,
    `drug_type` VARCHAR(50) NOT NULL,
    `amount` INT(11) NOT NULL DEFAULT 1,
    `price` INT(11) NOT NULL,
    `sale_type` ENUM('player','npc') NOT NULL DEFAULT 'npc',
    `zone` VARCHAR(50) DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `seller_identifier` (`seller_identifier`),
    KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Drug crafting log table
CREATE TABLE IF NOT EXISTS `drug_crafting` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `player_identifier` VARCHAR(60) NOT NULL,
    `player_name` VARCHAR(100) NOT NULL,
    `lab_type` VARCHAR(50) NOT NULL,
    `drug_crafted` VARCHAR(50) NOT NULL,
    `amount` INT(11) NOT NULL DEFAULT 1,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `player_identifier` (`player_identifier`),
    KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Player drug statistics
CREATE TABLE IF NOT EXISTS `player_drug_stats` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(60) NOT NULL,
    `total_sales` INT(11) NOT NULL DEFAULT 0,
    `total_earnings` INT(11) NOT NULL DEFAULT 0,
    `total_crafted` INT(11) NOT NULL DEFAULT 0,
    `total_arrests` INT(11) NOT NULL DEFAULT 0,
    `most_sold_drug` VARCHAR(50) DEFAULT NULL,
    `last_sale` TIMESTAMP NULL DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Drug dealer inventory
CREATE TABLE IF NOT EXISTS `dealer_inventory` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `dealer_id` VARCHAR(50) NOT NULL,
    `item_name` VARCHAR(50) NOT NULL,
    `stock` INT(11) NOT NULL DEFAULT 100,
    `price` INT(11) NOT NULL,
    `last_restock` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `dealer_item` (`dealer_id`,`item_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- DEFAULT DATA INSERTS
-- =====================================================

-- Insert default jobs
INSERT INTO `jobs` (name, label) VALUES 
    ('unemployed', 'Unemployed'),
    ('police', 'Police'),
    ('ambulance', 'EMS'),
    ('mechanic', 'Mechanic')
ON DUPLICATE KEY UPDATE label = VALUES(label);

-- Insert default job grades
INSERT INTO `job_grades` (job_name, grade, name, label, salary) VALUES 
    ('unemployed', 0, 'unemployed', 'Unemployed', 200),
    ('police', 0, 'recruit', 'Recruit', 750),
    ('police', 1, 'officer', 'Officer', 1000),
    ('police', 2, 'sergeant', 'Sergeant', 1250),
    ('police', 3, 'lieutenant', 'Lieutenant', 1500),
    ('police', 4, 'captain', 'Captain', 1750),
    ('police', 5, 'chief', 'Chief', 2000),
    ('ambulance', 0, 'trainee', 'Trainee', 500),
    ('ambulance', 1, 'paramedic', 'Paramedic', 750),
    ('ambulance', 2, 'doctor', 'Doctor', 1000),
    ('ambulance', 3, 'surgeon', 'Surgeon', 1250),
    ('ambulance', 4, 'chief', 'Chief', 1500),
    ('mechanic', 0, 'apprentice', 'Apprentice', 400),
    ('mechanic', 1, 'mechanic', 'Mechanic', 600),
    ('mechanic', 2, 'specialist', 'Specialist', 800),
    ('mechanic', 3, 'manager', 'Manager', 1000)
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    label = VALUES(label),
    salary = VALUES(salary);

-- Insert default dealer inventory
INSERT INTO `dealer_inventory` (`dealer_id`, `item_name`, `stock`, `price`) VALUES
    ('street_dealer', 'weed_seed', 100, 25),
    ('street_dealer', 'lsd_paper', 100, 50),
    ('chemical_supplier', 'coca_leaf', 100, 50),
    ('chemical_supplier', 'pseudoephedrine', 100, 75),
    ('chemical_supplier', 'chemical', 100, 100)
ON DUPLICATE KEY UPDATE stock = VALUES(stock), price = VALUES(price);

-- =====================================================
-- DATABASE SETUP COMPLETE
-- =====================================================
