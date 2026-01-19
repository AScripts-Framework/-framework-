AS.Database = {}

-- Initialize database
function AS.Database.Initialize()
    MySQL.ready(function()
        print('^2[AS-CORE]^7 Database connection established')
        
        -- Create tables if they don't exist
        MySQL.query([[
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
                PRIMARY KEY (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
        
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `user_characters` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `identifier` VARCHAR(60) NOT NULL,
                `char_id` INT(11) NOT NULL,
                `firstname` VARCHAR(50) NOT NULL,
                `lastname` VARCHAR(50) NOT NULL,
                `dateofbirth` VARCHAR(25) NOT NULL,
                `sex` VARCHAR(1) NOT NULL DEFAULT 'M',
                `height` INT(11) NOT NULL DEFAULT 175,
                PRIMARY KEY (`id`),
                KEY `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
        
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `jobs` (
                `name` VARCHAR(50) NOT NULL,
                `label` VARCHAR(50) NOT NULL,
                PRIMARY KEY (`name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
        
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `job_grades` (
                `id` INT(11) NOT NULL AUTO_INCREMENT,
                `job_name` VARCHAR(50) NOT NULL,
                `grade` INT(11) NOT NULL,
                `name` VARCHAR(50) NOT NULL,
                `label` VARCHAR(50) NOT NULL,
                `salary` INT(11) NOT NULL,
                PRIMARY KEY (`id`),
                KEY `job_name` (`job_name`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
        
        -- Insert default job if not exists
        MySQL.query('INSERT IGNORE INTO `jobs` (name, label) VALUES (?, ?)', {
            'unemployed', 'Unemployed'
        })
        
        MySQL.query('INSERT IGNORE INTO `job_grades` (job_name, grade, name, label, salary) VALUES (?, ?, ?, ?, ?)', {
            'unemployed', 0, 'unemployed', 'Unemployed', 200
        })
    end)
end

-- Execute query (returns result)
function AS.Database.Query(query, parameters)
    return MySQL.query.await(query, parameters)
end

-- Execute single query (returns single row)
function AS.Database.Single(query, parameters)
    return MySQL.single.await(query, parameters)
end

-- Execute scalar query (returns single value)
function AS.Database.Scalar(query, parameters)
    return MySQL.scalar.await(query, parameters)
end

-- Insert query (returns insert id)
function AS.Database.Insert(query, parameters)
    return MySQL.insert.await(query, parameters)
end

-- Update query (returns affected rows)
function AS.Database.Update(query, parameters)
    return MySQL.update.await(query, parameters)
end

-- Execute raw query
function AS.Database.Execute(query, parameters)
    return MySQL.query.await(query, parameters)
end

-- Transaction support
function AS.Database.Transaction(queries, parameters)
    return MySQL.transaction.await(queries, parameters)
end

print('^2[AS-CORE]^7 Database module loaded')
