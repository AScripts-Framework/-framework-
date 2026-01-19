# AS Banking 💰

Modern banking system for AS Framework with dual UI interfaces - terminal-style ATM and professional bank interface.

## Features

✅ **Dual UI System**
- ATM: Green terminal-style interface for quick transactions
- Bank: Professional purple-themed interface with comprehensive features

✅ **Core Banking**
- Deposit and withdraw money
- Transfer funds between players
- Transaction history with logging
- Balance checking

✅ **Bank Cards**
- Request debit cards ($500 fee)
- PIN protection system
- Card management

✅ **Loan System**
- Request loans from the bank
- Interest rates and payment schedules
- Track active loans
- Make loan payments

✅ **Flexible Interaction**
- Target system (as-target) when enabled via convar
- AS Framework text UI fallback when target disabled
- Works seamlessly with both methods

✅ **ATM Network**
- Automatically detects all ATM props in the world
- 4 different ATM prop models supported
- No manual coordinate placement needed
- Limited transactions at ATMs

✅ **Bank Locations**
- 6 bank branches with blips
- Full banking services at branches
- Professional bank teller interaction

## Dependencies

- [as-core](../as-core) - AS Framework Core
- [oxmysql](https://github.com/overextended/oxmysql) - MySQL wrapper
- [as-target](../as-target) - (Optional) For target interaction

## Installation

1. **Download and Extract**
   ```bash
   cd resources
   # Place as-banking folder here
   ```

2. **Import Database**
   ```bash
   # Import database.sql into your MySQL database
   # Creates: bank_cards, bank_transactions, bank_savings tables
   ```

3. **Configure ConVar**
   
   Add to your `server.cfg`:
   ```bash
   # Use target system (1) or text UI (0)
   setr as_use_target "1"
   ```

4. **Start Resource**
   
   Add to your `server.cfg`:
   ```bash
   ensure as-banking
   ```

## Configuration

Edit `shared/config.lua`:

```lua
Config = {}

-- Use target system (from convar)
Config.UseTarget = GetConvar('as_use_target', '0') == '1'
-- ATM Model Hashes (props that will be targeted)
Config.ATMModels = {
    `prop_atm_01`,
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`
}   'prop_fleeca_atm'
}

-- Transaction Limits
Config.MaxWithdraw = 50000      -- Max withdrawal amount
Config.MaxDeposit = 100000       -- Max deposit amount
Config.MaxTransfer = 25000       -- Max transfer amount
Config.MinTransferAmount = 1     -- Minimum transfer

-- Fees
Config.TransferFee = 0.02        -- 2% transfer fee
Config.CardFee = 500             -- Bank card creation fee

-- Interest Rates
Config.InterestRate = 0.0005     -- 0.05% interest rate
Config.DailyInterestLimit = 500  -- Max daily interest
```

### Bank Locations

6 bank branches with coordinates:
- Legion Square (Pillbox Hill)
- Hawick Avenue
- Del Perro Boulevard
- Great Ocean Highway
- Paleto Bay
- Blaine County Savings Bank

### ATM Locations

ATMs are automatically detected using prop models. The script will find all ATM props in the world without needing manual coordinate placement. See `shared/config.lua` for supported ATM models.

## Usage

### As a Player

**Using ATMs:**
1. Approach any ATM
2. If target enabled: Target the ATM and select "Use ATM"
3. If text UI: Press `E` when prompted
4. Use the green terminal interface for transactions

**Using Banks:**
1. Go to any bank location (purple blip)
2. If target enabled: Target the bank teller and select "Access Bank"
3. If text UI: Press `E` when near the teller
4. Use the professional bank interface

**ATM Operations:**
- Withdraw cash (with ATM limits)
- Deposit cash
- Transfer funds
- Check balance
- Change PIN
- Manage cards

**Bank Operations:**
- All ATM operations
- Request loans
- Pay off loans
- View detailed transaction history
- Advanced card management

### For Developers

**Get Player Balance:**
```lua
AS.ServerCallback('as-banking:server:getBalance', function(balance)
    print('Bank Balance: $' .. balance)
end)
```
**Deposit Money:**
```lua
AS.ServerCallback('as-banking:server:deposit', function(success)
    if success then
        print('Deposited $' .. amount)
    end
end, amount) print('Deposited $' .. amount)
end
**Withdraw Money:**
```lua
AS.ServerCallback('as-banking:server:withdraw', function(success)
    if success then
        print('Withdrew $' .. amount)
    end
end, amount, false)success then
    print('Withdrew $' .. amount)
**Transfer Money:**
```lua
AS.ServerCallback('as-banking:server:transfer', function(success)
    if success then
        print('Transferred $' .. amount)
    end
end, targetId, amount)al success = lib.callback.await('as-banking:server:transfer', false, targetId, amount)
if success then
    print('Transferred $' .. amount)
**Create Card:**
```lua
AS.ServerCallback('as-banking:server:createCard', function(card)
    if card then
        print('Card Number: ' .. card.card_number)
    end
end, pin)al card = lib.callback.await('as-banking:server:createCard', false, pin)
if card then
    print('Card Number: ' .. card.card_number)
end
```

**Request Loan:**
```lua
-- Add your own loan callback on server side
-- This is a placeholder for loan system expansion
```

## Database Structure

### bank_cards
```sql
- id (INT) - Primary key
- identifier (VARCHAR) - Player identifier
- card_number (VARCHAR) - 16-digit card number
- pin (VARCHAR) - 4-digit PIN
- created_at (TIMESTAMP) - Creation date
```

### bank_transactions
```sql
- id (INT) - Primary key
- identifier (VARCHAR) - Player identifier
- type (VARCHAR) - Transaction type (deposit/withdraw/transfer)
- amount (INT) - Transaction amount
- from_account (VARCHAR) - Source account
- to_account (VARCHAR) - Target account
- description (TEXT) - Transaction description
- timestamp (TIMESTAMP) - Transaction time
```

### bank_savings
```sql
- id (INT) - Primary key
- identifier (VARCHAR) - Player identifier
- amount (INT) - Savings amount
- interest_rate (FLOAT) - Interest rate
- created_at (TIMESTAMP) - Creation date
```

## Target vs Text UI

The script automatically detects the interaction method:

**Target System (as_use_target = "1"):**
- Uses `as-target` exports
- Target ATMs and bank tellers
- Clean interaction with icons

**Text UI (as_use_target = "0"):**
- Uses AS Framework text UI
- Distance-based prompts
- Press E to interact

Switch between modes by changing the convar in `server.cfg`.

## Integration with AS Framework

This resource integrates seamlessly with AS Framework:

- Uses `AS.Server.GetPlayer()` for player data
- Manages bank/cash through AS core functions
- Compatible with all AS Framework resources
- Follows AS Framework naming conventions

## Troubleshooting

**ATM/Bank not working:**
- Ensure `as-core` is started first
- Check `as_use_target` convar is set correctly
- Import database tables

**Target not showing:**
- Ensure `as-target` is installed and started
- Check that `as_use_target` convar is "1"
- Restart the resource

**Text UI not showing:**
- Ensure you're within interaction distance
- Verify `as_use_target` convar is "0"

## Credits

Developed for AS Framework by AS Development Team

## License

See main AS Framework license

---

**AS Framework** - Building the future of FiveM roleplay 🚀
