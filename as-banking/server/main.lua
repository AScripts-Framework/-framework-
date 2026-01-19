local AS = exports['as-core']:GetCoreObject()

-- Get Player Bank Balance
AS.RegisterCallback('as-banking:server:getBalance', function(source, cb)
    local player = AS.Server.GetPlayer(source)
    if not player then return cb(0) end
    
    cb(player.getMoney('bank'))
end)

-- Get Account Info
AS.RegisterCallback('as-banking:server:getAccountInfo', function(source, cb)
    local player = AS.Server.GetPlayer(source)
    if not player then return cb(nil) end
    
    local card = MySQL.single.await('SELECT * FROM bank_cards WHERE citizenid = ? AND active = 1', {
        player.citizenid
    })
    
    local transactions = MySQL.query.await('SELECT * FROM bank_transactions WHERE citizenid = ? ORDER BY created_at DESC LIMIT 10', {
        player.citizenid
    })
    
    local loans = MySQL.query.await('SELECT * FROM bank_loans WHERE citizenid = ? AND status = "active"', {
        player.citizenid
    })
    
    cb({
        name = player.getName(),
        citizenid = player.citizenid,
        balance = player.getMoney('bank'),
        cash = player.getMoney('cash'),
        card = card,
        transactions = transactions or {},
        loans = loans or {}
    })
end)

-- Deposit Money
AS.RegisterCallback('as-banking:server:deposit', function(source, cb, amount)
    local player = AS.Server.GetPlayer(source)
    if not player then return cb(false) end
    
    amount = tonumber(amount)
    if not amount or amount <= 0 then return cb(false) end
    
    local cash = player.getMoney('cash')
    if cash < amount then
        return cb(false, 'Insufficient cash')
    end
    
    player.removeMoney('cash', amount)
    player.addMoney('bank', amount)
    
    -- Log transaction
    MySQL.insert('INSERT INTO bank_transactions (citizenid, transaction_type, amount, description, balance_after) VALUES (?, ?, ?, ?, ?)', {
        player.citizenid,
        'deposit',
        amount,
        'Cash deposit',
        player.getMoney('bank')
    })
    
    cb(true, 'Deposit successful')
end)

-- Withdraw Money
AS.RegisterCallback('as-banking:server:withdraw', function(source, cb, amount, isATM)
    local player = AS.Server.GetPlayer(source)
    if not player then return cb(false) end
    
    amount = tonumber(amount)
    if not amount or amount <= 0 then return cb(false) end
    
    -- Check ATM limit
    if isATM and amount > Config.ATMWithdrawLimit then
        return cb(false, 'ATM withdrawal limit exceeded ($' .. Config.ATMWithdrawLimit .. ')')
    end
    
    local balance = player.getMoney('bank')
    if balance < amount then
        return cb(false, 'Insufficient funds')
    end
    
    player.removeMoney('bank', amount)
    player.addMoney('cash', amount)
    
    -- Log transaction
    MySQL.insert('INSERT INTO bank_transactions (citizenid, transaction_type, amount, description, balance_after) VALUES (?, ?, ?, ?, ?)', {
        player.citizenid,
        'withdraw',
        amount,
        isATM and 'ATM withdrawal' or 'Bank withdrawal',
        player.getMoney('bank')
    })
    
    cb(true, 'Withdrawal successful')
end)

-- Transfer Money
AS.RegisterCallback('as-banking:server:transfer', function(source, cb, targetId, amount)t)
    local player = AS.Server.GetPlayer(source)
    if not player then return cb(false) end
    
    amount = tonumber(amount)
    if not amount or amount <= 0 then return cb(false) end
    
    if amount > Config.MaxTransferAmount then
        return cb(false, 'Transfer amount exceeds maximum ($' .. Config.MaxTransferAmount .. ')')
    end
    
    local balance = player.getMoney('bank')
    local fee = math.floor(amount * (Config.TransactionFee / 100))
    local total = amount + fee
    
    if balance < total then
        return cb(false, 'Insufficient funds')
    end
    
    local targetPlayer = AS.Server.GetPlayerByCitizenId(targetId)
    if not targetPlayer then
        return cb(false, 'Recipient not found')
    end
    
    -- Execute transfer
    player.removeMoney('bank', total)
    targetPlayer.addMoney('bank', amount)
    
    -- Log sender transaction
    MySQL.insert('INSERT INTO bank_transactions (citizenid, transaction_type, amount, to_account, description, balance_after) VALUES (?, ?, ?, ?, ?, ?)', {
        player.citizenid,
        'transfer',
        -total,
        targetId,
        'Transfer to ' .. targetPlayer.getName(),
        player.getMoney('bank')
    })
    
    -- Log recipient transaction
    MySQL.insert('INSERT INTO bank_transactions (citizenid, transaction_type, amount, from_account, description, balance_after) VALUES (?, ?, ?, ?, ?, ?)', {
        targetId,
        'transfer',
        amount,
        player.citizenid,
        'Transfer from ' .. player.getName(),
        targetPlayer.getMoney('bank')
    })
    
    -- Notify recipient if online
    if targetPlayer.source then
        AS.Notify(targetPlayer.source, 'Received $' .. amount .. ' from ' .. player.getName(), 'success')
    end
    
    cb(true, 'Transfer successful')
end)

-- Request Loan
AS.RegisterCallback('as-banking:server:requestLoan', function(source, cb, amount)t)
    if not Config.EnableLoans then return cb(false, 'Loans are not available') end
    
    local player = AS.Server.GetPlayer(source)
    if not player then return cb(false) end
    
    amount = tonumber(amount)
    if not amount or amount <= 0 or amount > Config.MaxLoanAmount then
        return cb(false, 'Invalid loan amount')
    end
    
    -- Check existing loans
    local existingLoans = MySQL.scalar.await('SELECT COUNT(*) FROM bank_loans WHERE citizenid = ? AND status = "active"', {
        player.citizenid
    })
    
    if existingLoans > 0 then
        return cb(false, 'You already have an active loan')
    end
    
    local interest = math.floor(amount * (Config.LoanInterestRate / 100))
    local total = amount + interest
    local paymentDue = os.time() + (Config.LoanPaymentPeriod * 24 * 60 * 60)
    
    -- Create loan
    MySQL.insert('INSERT INTO bank_loans (citizenid, amount, interest_rate, remaining, payment_amount, payment_due) VALUES (?, ?, ?, ?, ?, FROM_UNIXTIME(?))', {
        player.citizenid,
        amount,
        Config.LoanInterestRate,
        total,
        total,
        paymentDue
    })
    
    -- Add money to bank
    player.addMoney('bank', amount)
    
    -- Log transaction
    MySQL.insert('INSERT INTO bank_transactions (citizenid, transaction_type, amount, description, balance_after) VALUES (?, ?, ?, ?, ?)', {
        player.citizenid,
        'loan',
        amount,
        'Loan approved',
        player.getMoney('bank')
    })
    
    cb(true, 'Loan approved')
end)

-- Pay Loan
AS.RegisterCallback('as-banking:server:payLoan', function(source, cb, loanId, amount)t)
    local player = AS.Server.GetPlayer(source)
    if not player then return cb(false) end
    
    amount = tonumber(amount)
    if not amount or amount <= 0 then return cb(false) end
    
    local loan = MySQL.single.await('SELECT * FROM bank_loans WHERE id = ? AND citizenid = ? AND status = "active"', {
        loanId,
        player.citizenid
    })
    
    if not loan then
        return cb(false, 'Loan not found')
    end
    
    if amount > loan.remaining then
        amount = loan.remaining
    end
    
    local balance = player.getMoney('bank')
    if balance < amount then
        return cb(false, 'Insufficient funds')
    end
    
    player.removeMoney('bank', amount)
    
    local newRemaining = loan.remaining - amount
    local newStatus = newRemaining <= 0 and 'paid' or 'active'
    
    MySQL.update('UPDATE bank_loans SET remaining = ?, status = ? WHERE id = ?', {
        newRemaining,
        newStatus,
        loanId
    })
    
    -- Log transaction
    MySQL.insert('INSERT INTO bank_transactions (citizenid, transaction_type, amount, description, balance_after) VALUES (?, ?, ?, ?, ?)', {
        player.citizenid,
        'payment',
        -amount,
        'Loan payment',
        player.getMoney('bank')
    })
    
    cb(true, newStatus == 'paid' and 'Loan paid off!' or 'Payment successful')
end)

-- Generate Bank Card
AS.RegisterCallback('as-banking:server:getCard', function(source, cb)b)
    local player = AS.Server.GetPlayer(source)
    if not player then return cb(false) end
    
    -- Check if player already has a card
    local existingCard = MySQL.single.await('SELECT * FROM bank_cards WHERE citizenid = ? AND active = 1', {
        player.citizenid
    })
    
    if existingCard then
        return cb(false, 'You already have a bank card')
    end
    
    -- Check if player can afford
    local cash = player.getMoney('cash')
    if cash < Config.CardCost then
        return cb(false, 'Insufficient cash ($' .. Config.CardCost .. ' required)')
    end
    
    player.removeMoney('cash', Config.CardCost)
    
    -- Generate card number and PIN
    local cardNumber = string.format('%04d%04d%04d%04d', math.random(1000, 9999), math.random(1000, 9999), math.random(1000, 9999), math.random(1000, 9999))
    local pin = string.format('%04d', math.random(0, 9999))
    
    MySQL.insert('INSERT INTO bank_cards (citizenid, card_number, pin) VALUES (?, ?, ?)', {
        player.citizenid,
        cardNumber,
        pin
    })
    
    cb(true, 'Bank card issued! PIN: ' .. pin)
end)
