-- Example resource using AS Framework

-- Server-side example
if IsDuplicityVersion() then
    -- Get framework
    local AS = exports['as-core']:GetCoreObject()
    
    -- Example: Give money to player
    RegisterCommand('givemoney', function(source, args, rawCommand)
        local player = AS.Server.GetPlayer(source)
        
        if player then
            local amount = tonumber(args[1]) or 1000
            player.addMoney('cash', amount)
            player.showNotification({
                title = 'Money',
                description = 'Received $' .. amount,
                type = 'success'
            })
        end
    end, false)
    
    -- Example: Set job
    RegisterCommand('setjob', function(source, args, rawCommand)
        local player = AS.Server.GetPlayer(source)
        
        if player and player.getGroup() == 'admin' then
            local targetId = tonumber(args[1])
            local job = args[2] or 'unemployed'
            local grade = tonumber(args[3]) or 0
            
            local targetPlayer = AS.Server.GetPlayer(targetId)
            if targetPlayer then
                targetPlayer.setJob(job, grade)
                targetPlayer.showNotification({
                    title = 'Job Updated',
                    description = 'Your job is now ' .. job,
                    type = 'info'
                })
            end
        end
    end, false)
    
    -- Example: Custom callback
    AS.Server.RegisterCallback('example:getData', function(source, cb)
        local player = AS.Server.GetPlayer(source)
        
        if player then
            cb({
                money = player.getMoney('cash'),
                job = player.getJob(),
                group = player.getGroup()
            })
        else
            cb(nil)
        end
    end)
    
    -- Example: Listen to player loaded event
    AddEventHandler('as-core:server:onPlayerLoaded', function(source, player)
        print('Player loaded: ' .. player.name)
        
        -- Give welcome bonus
        player.addMoney('cash', 500)
        player.showNotification({
            title = 'Welcome!',
            description = 'You received $500 welcome bonus',
            type = 'success'
        })
    end)
end

-- Client-side example
if not IsDuplicityVersion() then
    -- Get framework
    local AS = exports['as-core']:GetCoreObject()
    
    -- Wait for player to load
    CreateThread(function()
        while not AS.Client.IsPlayerLoaded() do
            Wait(100)
        end
        
        print('Player is ready!')
        
        -- Get player data
        local playerData = AS.Client.GetPlayerData()
        print('Job: ' .. playerData.job)
    end)
    
    -- Example: Show notification
    RegisterCommand('testnotify', function()
        exports['as-core']:ShowNotification({
            title = 'Test',
            description = 'This is a test notification',
            type = 'info'
        })
    end, false)
    
    -- Example: Progress bar
    RegisterCommand('testprogress', function()
        local success = exports['as-core']:ShowProgress({
            duration = 5000,
            label = 'Testing progress...',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true
            },
            anim = {
                dict = 'amb@prop_human_bum_bin@idle_b',
                clip = 'idle_d'
            }
        })
        
        if success then
            print('Progress completed!')
        else
            print('Progress cancelled!')
        end
    end, false)
    
    -- Example: Input dialog
    RegisterCommand('testinput', function()
        local input = exports['as-core']:ShowInput({
            {
                type = 'input',
                label = 'Name',
                description = 'Enter your name',
                required = true,
                min = 3,
                max = 50
            },
            {
                type = 'number',
                label = 'Age',
                description = 'Enter your age',
                required = true,
                min = 18,
                max = 99
            },
            {
                type = 'select',
                label = 'Gender',
                options = {
                    {value = 'male', label = 'Male'},
                    {value = 'female', label = 'Female'}
                },
                required = true
            }
        })
        
        if input then
            print('Name: ' .. input[1])
            print('Age: ' .. input[2])
            print('Gender: ' .. input[3])
        end
    end, false)
    
    -- Example: Text UI
    RegisterCommand('testtextui', function()
        exports['as-core']:ShowTextUI('[E] - Interact')
        
        CreateThread(function()
            Wait(5000)
            exports['as-core']:HideTextUI()
        end)
    end, false)
    
    -- Example: Listen to money change
    AddEventHandler('as-core:client:onMoneyChange', function(account, amount)
        print('Money changed - ' .. account .. ': $' .. amount)
    end)
end
