-- Player class constructor
function CreatePlayer(playerId, identifier, playerData)
    local self = {}
    
    self.source = playerId
    self.identifier = identifier
    self.name = GetPlayerName(playerId)
    
    -- Player data
    self.data = {
        money = playerData.money or json.encode(Config.Player.DefaultMoney),
        job = playerData.job or Config.Jobs.Default,
        job_grade = playerData.job_grade or 0,
        group = playerData.group or 'user',
        position = playerData.position or nil,
        inventory = playerData.inventory or '[]',
        metadata = playerData.metadata or '{}'
    }
    
    -- Parse JSON data
    if type(self.data.money) == 'string' then
        self.data.money = json.decode(self.data.money)
    end
    
    if type(self.data.inventory) == 'string' then
        self.data.inventory = json.decode(self.data.inventory)
    end
    
    if type(self.data.metadata) == 'string' then
        self.data.metadata = json.decode(self.data.metadata)
    end
    
    -- Get money
    function self.getMoney(account)
        if not account then
            return self.data.money.cash or 0
        end
        return self.data.money[account] or 0
    end
    
    -- Add money
    function self.addMoney(account, amount)
        if not account or not self.data.money[account] then return false end
        
        amount = AS.Shared.Round(amount, 2)
        self.data.money[account] = self.data.money[account] + amount
        
        TriggerClientEvent('as-core:client:updateMoney', self.source, account, self.data.money[account])
        
        return true
    end
    
    -- Remove money
    function self.removeMoney(account, amount)
        if not account or not self.data.money[account] then return false end
        if self.data.money[account] < amount then return false end
        
        amount = AS.Shared.Round(amount, 2)
        self.data.money[account] = self.data.money[account] - amount
        
        TriggerClientEvent('as-core:client:updateMoney', self.source, account, self.data.money[account])
        
        return true
    end
    
    -- Set money
    function self.setMoney(account, amount)
        if not account or not self.data.money[account] then return false end
        
        amount = AS.Shared.Round(amount, 2)
        self.data.money[account] = amount
        
        TriggerClientEvent('as-core:client:updateMoney', self.source, account, self.data.money[account])
        
        return true
    end
    
    -- Get job
    function self.getJob()
        return {
            name = self.data.job,
            grade = self.data.job_grade
        }
    end
    
    -- Set job
    function self.setJob(job, grade)
        self.data.job = job
        self.data.job_grade = grade or 0
        
        TriggerClientEvent('as-core:client:updateJob', self.source, self.data.job, self.data.job_grade)
    end
    
    -- Get group
    function self.getGroup()
        return self.data.group
    end
    
    -- Set group
    function self.setGroup(group)
        self.data.group = group
        TriggerClientEvent('as-core:client:updateGroup', self.source, self.data.group)
    end
    
    -- Get metadata
    function self.getMeta(key)
        if key then
            return self.data.metadata[key]
        end
        return self.data.metadata
    end
    
    -- Set metadata
    function self.setMeta(key, value)
        self.data.metadata[key] = value
        TriggerClientEvent('as-core:client:updateMetadata', self.source, key, value)
    end
    
    -- Get inventory
    function self.getInventory()
        return self.data.inventory
    end
    
    -- Set position
    function self.setCoords(coords)
        self.data.position = json.encode({
            x = coords.x,
            y = coords.y,
            z = coords.z,
            heading = coords.w or coords.heading or 0.0
        })
    end
    
    -- Get position
    function self.getCoords()
        if self.data.position then
            local pos = json.decode(self.data.position)
            return vector4(pos.x, pos.y, pos.z, pos.heading)
        end
        return Config.Player.StartingLocation
    end
    
    -- Show notification
    function self.showNotification(data)
        lib.notify(self.source, data)
    end
    
    -- Save player data
    function self.save()
        MySQL.update('UPDATE users SET money = ?, job = ?, job_grade = ?, `group` = ?, position = ?, inventory = ?, metadata = ? WHERE identifier = ?', {
            json.encode(self.data.money),
            self.data.job,
            self.data.job_grade,
            self.data.group,
            self.data.position,
            json.encode(self.data.inventory),
            json.encode(self.data.metadata),
            self.identifier
        })
        
        if Config.Debug then
            print('^3[AS-CORE]^7 Saved player: ' .. self.name .. ' (' .. self.identifier .. ')')
        end
    end
    
    return self
end

-- Load player
function LoadPlayer(playerId)
    local identifiers = GetPlayerIdentifiers(playerId)
    local identifier = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, 'license:') then
            identifier = id
            break
        end
    end
    
    if not identifier then
        DropPlayer(playerId, 'No valid license found')
        return
    end
    
    local result = MySQL.single.await('SELECT * FROM users WHERE identifier = ?', {identifier})
    
    if not result then
        -- Create new player
        MySQL.insert('INSERT INTO users (identifier, name, money, job, job_grade, `group`) VALUES (?, ?, ?, ?, ?, ?)', {
            identifier,
            GetPlayerName(playerId),
            json.encode(Config.Player.DefaultMoney),
            Config.Jobs.Default,
            0,
            'user'
        })
        
        result = {
            identifier = identifier,
            money = json.encode(Config.Player.DefaultMoney),
            job = Config.Jobs.Default,
            job_grade = 0,
            group = 'user',
            position = nil,
            inventory = '[]',
            metadata = '{}'
        }
        
        print('^2[AS-CORE]^7 Created new player: ' .. GetPlayerName(playerId))
    end
    
    -- Create player object
    local player = CreatePlayer(playerId, identifier, result)
    AS.Players[playerId] = player
    
    -- Trigger loaded event
    TriggerEvent('as-core:server:onPlayerLoaded', playerId, player)
    TriggerClientEvent('as-core:client:playerLoaded', playerId, player.data)
    
    if Config.Debug then
        print('^3[AS-CORE]^7 Loaded player: ' .. player.name .. ' (' .. identifier .. ')')
    end
end

-- Player selecting character
RegisterNetEvent('as-core:server:loadPlayer', function()
    local playerId = source
    LoadPlayer(playerId)
end)

-- Update player coords on disconnect
RegisterNetEvent('as-core:server:updateCoords', function(coords)
    local playerId = source
    local player = AS.Server.GetPlayer(playerId)
    
    if player then
        player.setCoords(coords)
    end
end)

print('^2[AS-CORE]^7 Player module loaded')
