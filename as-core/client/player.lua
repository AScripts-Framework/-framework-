-- Client-side player utilities

-- Get player money
function GetMoney(account)
    if not account then
        account = 'cash'
    end
    
    if AS.PlayerData.money then
        if type(AS.PlayerData.money) == 'string' then
            AS.PlayerData.money = json.decode(AS.PlayerData.money)
        end
        return AS.PlayerData.money[account] or 0
    end
    
    return 0
end

-- Get player job
function GetJob()
    return {
        name = AS.PlayerData.job or 'unemployed',
        grade = AS.PlayerData.job_grade or 0
    }
end

-- Get player group
function GetGroup()
    return AS.PlayerData.group or 'user'
end

-- Get metadata
function GetMetadata(key)
    if type(AS.PlayerData.metadata) == 'string' then
        AS.PlayerData.metadata = json.decode(AS.PlayerData.metadata)
    end
    
    if key then
        return AS.PlayerData.metadata[key]
    end
    
    return AS.PlayerData.metadata
end

-- Show notification helper
function ShowNotification(data)
    lib.notify(data)
end

-- Progress bar helper
function ShowProgress(data)
    return lib.progressBar(data)
end

-- Progress circle helper
function ShowProgressCircle(data)
    return lib.progressCircle(data)
end

-- Input dialog helper
function ShowInput(data)
    return lib.inputDialog(data)
end

-- Alert dialog helper
function ShowAlert(data)
    return lib.alertDialog(data)
end

-- Context menu helper
function ShowContext(data)
    lib.registerContext(data)
    lib.showContext(data.id)
end

-- Textui helper
function ShowTextUI(text, options)
    lib.showTextUI(text, options)
end

function HideTextUI()
    lib.hideTextUI()
end

-- Exports for other resources
exports('GetMoney', GetMoney)
exports('GetJob', GetJob)
exports('GetGroup', GetGroup)
exports('GetMetadata', GetMetadata)
exports('ShowNotification', ShowNotification)
exports('ShowProgress', ShowProgress)
exports('ShowProgressCircle', ShowProgressCircle)
exports('ShowInput', ShowInput)
exports('ShowAlert', ShowAlert)
exports('ShowContext', ShowContext)
exports('ShowTextUI', ShowTextUI)
exports('HideTextUI', HideTextUI)

print('^2[AS-CORE]^7 Client player utilities loaded')
