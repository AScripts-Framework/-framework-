local AS = exports['as-core']:GetCoreObject()
local currentAccount = nil
local inBank = false
local inATM = false

-- Create Blips
CreateThread(function()
    for _, bank in ipairs(Config.Banks) do
        if bank.blip then
            local blip = AddBlipForCoord(bank.coords.x, bank.coords.y, bank.coords.z)
            SetBlipSprite(blip, Config.BankBlip.sprite)
            SetBlipColour(blip, Config.BankBlip.color)
            SetBlipScale(blip, Config.BankBlip.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(bank.name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Setup Target for Banks
CreateThread(function()
    if Config.UseTarget then
        -- Using as-target
        for i, bank in ipairs(Config.Banks) do
            for j, account in ipairs(bank.accounts) do
                exports['as-target']:AddBoxZone('bank_' .. i .. '_' .. j, {
                    coords = account.coords,
                    size = vec3(1.0, 1.0, 2.0),
                    rotation = account.heading,
                }, {
                    {
                        name = 'open_bank',
                        icon = 'fas fa-university',
                        label = 'Access Bank',
                        onSelect = function()
                            OpenBank()
                        end
                    }
                })
            end
        end
    else
        -- Using framework TextUI
        while true do
            local sleep = 1000
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            
            for _, bank in ipairs(Config.Banks) do
                for _, account in ipairs(bank.accounts) do
                    local dist = #(pos - account.coords)
                    if dist < 2.0 then
                        sleep = 0
                        if not inBank then
                            AS.ShowTextUI('[E] Access Bank')
                            inBank = true
                        end
                        
                        if IsControlJustReleased(0, 38) then -- E key
                            AS.HideTextUI()
                            OpenBank()
                        end
                    elseif inBank and dist > 2.5 then
                        AS.HideTextUI()
                        inBank = false
                    end
                end
            end
            
            Wait(sleep)
        end
    end
end)

-- Setup Target for ATMs (using model hashes)
CreateThread(function()
    if Config.UseTarget then
        -- Using as-target for ATM models
        exports['as-target']:AddModel(Config.ATMModels, {
            {
                name = 'use_atm',
                icon = 'fas fa-credit-card',
                label = 'Use ATM',
                onSelect = function()
                    OpenATM()
                end
            }
        })
    else
        -- Using framework TextUI for nearby ATMs
        while true do
            local sleep = 1000
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local nearbyATM = false
            
            -- Check for nearby ATM props
            for _, model in ipairs(Config.ATMModels) do
                local atm = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.5, model, false, false, false)
                if atm ~= 0 then
                    nearbyATM = true
                    sleep = 0
                    if not inATM then
                        AS.ShowTextUI('[E] Use ATM')
                        inATM = true
                    end
                    
                    if IsControlJustReleased(0, 38) then -- E key
                        AS.HideTextUI()
                        OpenATM()
                    end
                    break
                end
            end
            
            if inATM and not nearbyATM then
                AS.HideTextUI()
                inATM = false
            end
            
            Wait(sleep)
        end
    end
end)

-- Open Bank
function OpenBank()
    AS.ServerCallback('as-banking:server:getAccountInfo', function(data)
        if data then
            currentAccount = data
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'openBank',
                data = data
            })
        end
    end)
end

-- Open ATM
function OpenATM()
    AS.ServerCallback('as-banking:server:getAccountInfo', function(data)
        if data then
            currentAccount = data
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'openATM',
                data = data
            })
        end
    end)
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    currentAccount = nil
    cb('ok')
end)

RegisterNUICallback('deposit', function(data, cb)
    AS.ServerCallback('as-banking:server:deposit', function(success, message)
        if success then
            AS.Notify(message or 'Deposit successful', 'success')
            RefreshAccount()
        else
            AS.Notify(message or 'Deposit failed', 'error')
        end
        cb(success)
    end, data.amount)
end)

RegisterNUICallback('withdraw', function(data, cb)
    AS.ServerCallback('as-banking:server:withdraw', function(success, message)
        if success then
            AS.Notify(message or 'Withdrawal successful', 'success')
            RefreshAccount()
        else
            AS.Notify(message or 'Withdrawal failed', 'error')
        end
        cb(success)
    end, data.amount, data.isATM)
end)

RegisterNUICallback('transfer', function(data, cb)
    AS.ServerCallback('as-banking:server:transfer', function(success, message)
        if success then
            AS.Notify(message or 'Transfer successful', 'success')
            RefreshAccount()
        else
            AS.Notify(message or 'Transfer failed', 'error')
        end
        cb(success)
    end, data.targetId, data.amount)
end)

RegisterNUICallback('requestLoan', function(data, cb)
    AS.ServerCallback('as-banking:server:requestLoan', function(success, message)
        if success then
            AS.Notify(message or 'Loan approved', 'success')
            RefreshAccount()
        else
            AS.Notify(message or 'Loan request denied', 'error')
        end
        cb(success)
    end, data.amount)
end)

RegisterNUICallback('payLoan', function(data, cb)
    AS.ServerCallback('as-banking:server:payLoan', function(success, message)
        if success then
            AS.Notify(message or 'Payment successful', 'success')
            RefreshAccount()
        else
            AS.Notify(message or 'Payment failed', 'error')
        end
        cb(success)
    end, data.loanId, data.amount)
end)

RegisterNUICallback('getCard', function(data, cb)
    AS.ServerCallback('as-banking:server:getCard', function(success, message)
        AS.Notify(message, success and 'success' or 'error')
        if success then
            RefreshAccount()
        end
        cb(success)
    end)
end)

-- Refresh Account
function RefreshAccount()
    AS.ServerCallback('as-banking:server:getAccountInfo', function(data)
        if data then
            currentAccount = data
            SendNUIMessage({
                action = 'updateAccount',
                data = data
            })
        end
    end)
end

-- Exports
exports('OpenBank', OpenBank)
exports('OpenATM', OpenATM)
