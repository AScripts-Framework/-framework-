local AS = exports['as-core']:GetCoreObject()

-- Get player characters
AS.Server.RegisterCallback('as-spawn:server:getCharacters', function(source)
    local identifiers = GetPlayerIdentifiers(source)
    local license = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, 'license:') then
            license = id
            break
        end
    end
    
    if not license then
        return {}
    end
    
    local result = MySQL.query.await('SELECT * FROM user_characters WHERE identifier = ? ORDER BY char_id ASC', {license})
    
    return result or {}
end)

-- Create new character
AS.Server.RegisterCallback('as-spawn:server:createCharacter', function(source, data)
    local identifiers = GetPlayerIdentifiers(source)
    local license = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, 'license:') then
            license = id
            break
        end
    end
    
    if not license then
        return {success = false, message = 'No license found'}
    end
    
    -- Check character count
    local characters = MySQL.query.await('SELECT COUNT(*) as count FROM user_characters WHERE identifier = ?', {license})
    
    if characters and characters[1] and characters[1].count >= Config.Player.MaxCharacters then
        return {success = false, message = 'Maximum characters reached'}
    end
    
    -- Get next char_id
    local nextId = MySQL.scalar.await('SELECT COALESCE(MAX(char_id), 0) + 1 FROM user_characters WHERE identifier = ?', {license})
    
    -- Insert character
    local success = MySQL.insert.await([[
        INSERT INTO user_characters (identifier, char_id, firstname, lastname, dateofbirth, sex, height)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ]], {
        license,
        nextId,
        data.firstname,
        data.lastname,
        data.dateofbirth,
        data.sex,
        data.height
    })
    
    if success then
        -- Create user entry for this character if it doesn't exist
        local userExists = MySQL.scalar.await('SELECT identifier FROM users WHERE identifier = ?', {license})
        
        if not userExists then
            MySQL.insert('INSERT INTO users (identifier, name, money, job, job_grade, `group`) VALUES (?, ?, ?, ?, ?, ?)', {
                license,
                data.firstname .. ' ' .. data.lastname,
                json.encode(Config.Spawn.CharacterDefaults.startMoney),
                Config.Spawn.CharacterDefaults.startJob,
                Config.Spawn.CharacterDefaults.startJobGrade,
                'user'
            })
        end
        
        return {success = true, message = 'Character created successfully', charId = nextId}
    else
        return {success = false, message = 'Failed to create character'}
    end
end)

-- Delete character
AS.Server.RegisterCallback('as-spawn:server:deleteCharacter', function(source, charId)
    local identifiers = GetPlayerIdentifiers(source)
    local license = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, 'license:') then
            license = id
            break
        end
    end
    
    if not license then
        return {success = false, message = 'No license found'}
    end
    
    local success = MySQL.query.await('DELETE FROM user_characters WHERE identifier = ? AND char_id = ?', {
        license,
        charId
    })
    
    if success then
        return {success = true, message = 'Character deleted'}
    else
        return {success = false, message = 'Failed to delete character'}
    end
end)

-- Select character
RegisterNetEvent('as-spawn:server:selectCharacter', function(charId)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local license = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, 'license:') then
            license = id
            break
        end
    end
    
    if not license then
        DropPlayer(source, 'No license found')
        return
    end
    
    -- Verify character exists
    local character = MySQL.single.await('SELECT * FROM user_characters WHERE identifier = ? AND char_id = ?', {
        license,
        charId
    })
    
    if not character then
        DropPlayer(source, 'Invalid character')
        return
    end
    
    -- Load player with as-core
    TriggerEvent('as-core:server:loadPlayer', source)
end)

-- Save character appearance
RegisterNetEvent('as-spawn:server:saveAppearance', function(charId, appearance)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local license = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, 'license:') then
            license = id
            break
        end
    end
    
    if not license then return end
    
    -- Save appearance data to user_characters table
    MySQL.update('UPDATE user_characters SET appearance = ? WHERE identifier = ? AND char_id = ?', {
        json.encode(appearance),
        license,
        charId
    })
    
    if Config.Debug then
        print('^3[AS-SPAWN]^7 Saved appearance for character: ' .. charId)
    end
end)

print('^2[AS-SPAWN]^7 Character server module loaded')
