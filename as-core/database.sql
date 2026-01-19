-- AS Framework Database Schema
-- Run this file to set up your database

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

-- Insert default job
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
