-- Banking Tables for AS Framework

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
    `transaction_type` VARCHAR(50) NOT NULL, -- deposit, withdraw, transfer, payment
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
    `status` VARCHAR(20) DEFAULT 'active', -- active, paid, defaulted
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `citizenid_index` (`citizenid`),
    INDEX `status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
