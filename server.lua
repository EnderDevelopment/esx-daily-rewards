local ESX = exports['es_extended']:getSharedObject()
local tableReady = false
local claimsInProgress = {}

local function ensureTable()
    MySQL.query(([=[CREATE TABLE IF NOT EXISTS `%s` (
        `identifier` VARCHAR(80) NOT NULL,
        `cycle_start` BIGINT NOT NULL,
        `claimed_days` LONGTEXT NOT NULL,
        PRIMARY KEY (`identifier`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;]=]):format(Config.DatabaseTable), {}, function()
        tableReady = true
        print(('[%s] Database table ready.'):format(GetCurrentResourceName()))
    end)
end

local function dayStart(timestamp)
    local offset = (Config.ResetHourUTC or 0) * 3600
    return math.floor((timestamp - offset) / 86400) * 86400 + offset
end

local function decodeClaims(raw)
    local ok, decoded = pcall(json.decode, raw or '[]')
    if not ok or type(decoded) ~= 'table' then return {} end
    local claims = {}
    for _, value in ipairs(decoded) do
        local day = tonumber(value)
        if day and day >= 1 and day <= Config.CycleDays then claims[day] = true end
    end
    return claims
end

local function getReward(day)
    local reward = Config.Rewards[day]
    local allowed = { money = true, black_money = true, item = true }
    if not reward or not allowed[reward.type] or type(reward.amount) ~= 'number' or reward.amount < 1 then return nil end
    if reward.type == 'item' and (type(reward.name) ~= 'string' or reward.name == '') then return nil end
    return reward
end

local function sendState(source)
    local player = ESX.GetPlayerFromId(source)
    if not player then return end
    if not tableReady then
        TriggerClientEvent('ender_daily:notify', source, 'Daily rewards are still loading. Try again shortly.', 'error')
        return
    end
    local identifier = player.identifier
    MySQL.single(('SELECT cycle_start, claimed_days FROM `%s` WHERE identifier = ?'):format(Config.DatabaseTable), { identifier }, function(row)
        if not GetPlayerName(source) then return end
        local today = dayStart(os.time())
        local cycleStart = row and tonumber(row.cycle_start) or today
        local claims = row and decodeClaims(row.claimed_days) or {}
        if today - cycleStart >= Config.CycleDays * 86400 then cycleStart, claims = today, {} end
        local values = {}
        for day in pairs(claims) do values[#values + 1] = day end
        table.sort(values)
        MySQL.prepare(('INSERT INTO `%s` (identifier, cycle_start, claimed_days) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE cycle_start = VALUES(cycle_start), claimed_days = VALUES(claimed_days)'):format(Config.DatabaseTable), { identifier, cycleStart, json.encode(values) })
        local elapsed = math.floor((today - cycleStart) / 86400)
        local currentDay = math.min(Config.CycleDays, elapsed + 1)
        local rewards = {}
        for day = 1, Config.CycleDays do
            local reward = getReward(day)
            rewards[day] = reward and { label = reward.label or reward.name or ('$' .. reward.amount), description = reward.description or '', type = reward.type } or { label = 'Unavailable', description = 'Reward is not configured', type = 'locked' }
        end
        TriggerClientEvent('ender_daily:open', source, { title = Config.Title, subtitle = Config.Subtitle, currentDay = currentDay, claimed = values, rewards = rewards })
    end)
end

local function grantReward(player, reward)
    if reward.type == 'money' then player.addMoney(reward.amount)
    elseif reward.type == 'black_money' then player.addAccountMoney('black_money', reward.amount)
    elseif reward.type == 'item' then player.addInventoryItem(reward.name, reward.amount) end
end

RegisterNetEvent('ender_daily:claim', function(day)
    local source = source
    day = tonumber(day)
    if not day or day % 1 ~= 0 or day < 1 or day > Config.CycleDays then return end
    local player = ESX.GetPlayerFromId(source)
    if not player or not tableReady then return end
    local identifier = player.identifier
    if claimsInProgress[identifier] then return end
    claimsInProgress[identifier] = true
    local function finish() claimsInProgress[identifier] = nil end
    local reward = getReward(day)
    if not reward then
        finish()
        TriggerClientEvent('ender_daily:notify', source, 'This reward is not configured.', 'error')
        return
    end
    MySQL.single(('SELECT cycle_start, claimed_days FROM `%s` WHERE identifier = ?'):format(Config.DatabaseTable), { identifier }, function(row)
        if not GetPlayerName(source) then finish() return end
        local today = dayStart(os.time())
        local cycleStart = row and tonumber(row.cycle_start) or today
        local claims = row and decodeClaims(row.claimed_days) or {}
        if today - cycleStart >= Config.CycleDays * 86400 then cycleStart, claims = today, {} end
        local currentDay = math.min(Config.CycleDays, math.floor((today - cycleStart) / 86400) + 1)
        if day ~= currentDay then
            finish()
            TriggerClientEvent('ender_daily:notify', source, 'Only today’s reward can be claimed.', 'error')
            sendState(source)
            return
        end
        if claims[day] then
            finish()
            TriggerClientEvent('ender_daily:notify', source, 'You have already claimed today’s reward.', 'error')
            sendState(source)
            return
        end
        claims[day] = true
        local values = {}
        for claimedDay in pairs(claims) do values[#values + 1] = claimedDay end
        table.sort(values)
        MySQL.prepare(('INSERT INTO `%s` (identifier, cycle_start, claimed_days) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE cycle_start = VALUES(cycle_start), claimed_days = VALUES(claimed_days)'):format(Config.DatabaseTable), { identifier, cycleStart, json.encode(values) }, function(success)
            if not success then
                finish()
                TriggerClientEvent('ender_daily:notify', source, 'Could not save your claim. Please try again.', 'error')
                return
            end
            local onlinePlayer = ESX.GetPlayerFromId(source)
            if onlinePlayer and onlinePlayer.identifier == identifier then
                grantReward(onlinePlayer, reward)
                TriggerClientEvent('ender_daily:notify', source, 'Reward claimed: ' .. (reward.label or tostring(reward.amount)), 'success')
                sendState(source)
            end
            finish()
        end)
    end)
end)

RegisterCommand(Config.Command, function(source)
    if source == 0 then return end
    sendState(source)
end, false)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then ensureTable() end
end)
