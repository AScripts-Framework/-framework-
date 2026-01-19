Config = {}

-- Use target system (set via convar: setr as_use_target 1)
Config.UseTarget = GetConvar('as_use_target', '1') == '1'

-- Banking Settings
Config.MaxTransferAmount = 1000000 -- Max amount for single transfer
Config.TransactionFee = 0 -- Fee percentage for transfers (0 = no fee)
Config.ATMWithdrawLimit = 10000 -- Max withdrawal from ATM per transaction
Config.MinBalance = 0 -- Minimum balance allowed (can be negative for overdraft)

-- Card Settings
Config.CardCost = 50 -- Cost to get a new bank card
Config.PINLength = 4 -- Length of PIN code

-- Loan Settings
Config.EnableLoans = true
Config.MaxLoanAmount = 50000
Config.LoanInterestRate = 5 -- Percentage
Config.LoanPaymentPeriod = 7 -- Days

-- ATM Model Hashes (props that will be targeted)
Config.ATMModels = {
    `prop_atm_01`,
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`
}

-- Bank Locations
Config.Banks = {
    {
        name = 'Pacific Standard Bank',
        coords = vector3(241.7, 227.5, 106.3),
        blip = true,
        accounts = {
            {coords = vector3(241.3, 228.0, 106.3), heading = 160.0},
            {coords = vector3(243.2, 226.9, 106.3), heading = 160.0},
            {coords = vector3(245.0, 225.8, 106.3), heading = 160.0},
        }
    },
    {
        name = 'Fleeca Bank - Legion Square',
        coords = vector3(149.9, -1040.5, 29.4),
        blip = true,
        accounts = {
            {coords = vector3(149.5, -1040.7, 29.4), heading = 340.0},
            {coords = vector3(147.8, -1041.2, 29.4), heading = 340.0},
        }
    },
    {
        name = 'Fleeca Bank - Hawick',
        coords = vector3(-1212.9, -330.8, 37.8),
        blip = true,
        accounts = {
            {coords = vector3(-1212.5, -331.3, 37.8), heading = 26.0},
        }
    },
    {
        name = 'Fleeca Bank - Del Perro',
        coords = vector3(-2962.6, 482.6, 15.7),
        blip = true,
        accounts = {
            {coords = vector3(-2962.3, 482.9, 15.7), heading = 358.0},
        }
    },
    {
        name = 'Fleeca Bank - Paleto Bay',
        coords = vector3(-112.2, 6469.9, 31.6),
        blip = true,
        accounts = {
            {coords = vector3(-112.5, 6470.2, 31.6), heading = 315.0},
        }
    },
}

-- ATM Models
Config.ATMModels = {
    `prop_atm_01`,
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`,
}

-- Blip Settings
Config.BankBlip = {
    sprite = 108,
    color = 2,
    scale = 0.8,
    label = 'Bank'
}

Config.ATMBlip = {
    sprite = 277,
    color = 2,
    scale = 0.6,
    label = 'ATM',
    display = 2 -- Only show when nearby
}
