-- AS Ambulance Database Tables

-- Medical records table (optional - for tracking deaths/revives)
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

-- Note: The ambulance job should already exist in your jobs table from as-core
-- If not, you can add it with:
-- INSERT INTO `jobs` (`name`, `label`) VALUES ('ambulance', 'EMS');
-- INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `salary`) VALUES
-- ('ambulance', 0, 'Trainee', 50),
-- ('ambulance', 1, 'Paramedic', 75),
-- ('ambulance', 2, 'Senior Paramedic', 100),
-- ('ambulance', 3, 'EMS Supervisor', 125),
-- ('ambulance', 4, 'Chief of EMS', 150);
