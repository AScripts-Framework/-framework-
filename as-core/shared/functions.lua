AS = {}
AS.Shared = {}

-- Round number to decimals
function AS.Shared.Round(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / power
end

-- Generate random string
function AS.Shared.RandomStr(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = {}
    
    for i = 1, length do
        local rand = math.random(#charset)
        table.insert(result, charset:sub(rand, rand))
    end
    
    return table.concat(result)
end

-- Generate random integer
function AS.Shared.RandomInt(length)
    local result = {}
    
    for i = 1, length do
        table.insert(result, math.random(0, 9))
    end
    
    return tonumber(table.concat(result))
end

-- Split string by delimiter
function AS.Shared.SplitStr(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    
    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    
    table.insert(result, string.sub(str, from))
    return result
end

-- Trim whitespace
function AS.Shared.Trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

-- Table length
function AS.Shared.TableLength(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

-- Check if table has value
function AS.Shared.TableHasValue(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

-- Format money
function AS.Shared.FormatMoney(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return '$' .. formatted
end

-- Group digits
function AS.Shared.GroupDigits(value)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end
