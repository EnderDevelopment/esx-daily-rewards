Config = {}

Config.Command = 'daily'
Config.Title = 'Daily Rewards'
Config.Subtitle = 'Log in every day and claim your rewards.'
Config.CycleDays = 30
Config.ResetHourUTC = 0
Config.DatabaseTable = 'ender_daily_rewards'
Config.ClaimDistance = nil
Config.UseDiscordAvatar = false

-- Rewards are granted in order. Edit these entries to match your server economy.
Config.Rewards = {
    { type = 'money', amount = 250, label = '$250', description = 'Pocket money' },
    { type = 'item', name = 'bread', amount = 3, label = '3x Bread', description = 'Freshly baked' },
    { type = 'money', amount = 500, label = '$500', description = 'A little boost' },
    { type = 'item', name = 'water', amount = 4, label = '4x Water', description = 'Stay hydrated' },
    { type = 'black_money', amount = 300, label = '$300', description = 'Off the books' },
    { type = 'item', name = 'bandage', amount = 2, label = '2x Bandage', description = 'Be prepared' },
    { type = 'money', amount = 1000, label = '$1,000', description = 'Weekly milestone' },
    { type = 'item', name = 'phone', amount = 1, label = 'Mobile Phone', description = 'Stay connected' },
    { type = 'money', amount = 750, label = '$750', description = 'Keep it going' },
    { type = 'item', name = 'repairkit', amount = 1, label = 'Repair Kit', description = 'Back on the road' },
    { type = 'money', amount = 1250, label = '$1,250', description = 'A solid bonus' },
    { type = 'item', name = 'bread', amount = 6, label = '6x Bread', description = 'Stock up' },
    { type = 'black_money', amount = 900, label = '$900', description = 'A quiet payout' },
    { type = 'money', amount = 2000, label = '$2,000', description = 'Two-week milestone' },
    { type = 'item', name = 'water', amount = 8, label = '8x Water', description = 'A useful supply' },
    { type = 'money', amount = 1500, label = '$1,500', description = 'Keep climbing' },
    { type = 'item', name = 'bandage', amount = 5, label = '5x Bandage', description = 'Medical supplies' },
    { type = 'black_money', amount = 1500, label = '$1,500', description = 'Under the table' },
    { type = 'money', amount = 2500, label = '$2,500', description = 'A bigger payday' },
    { type = 'item', name = 'repairkit', amount = 2, label = '2x Repair Kit', description = 'Double the tools' },
    { type = 'money', amount = 3000, label = '$3,000', description = 'Three-week milestone' },
    { type = 'item', name = 'phone', amount = 1, label = 'Mobile Phone', description = 'A spare device' },
    { type = 'black_money', amount = 2500, label = '$2,500', description = 'A discreet reward' },
    { type = 'money', amount = 4000, label = '$4,000', description = 'The finish line is close' },
    { type = 'item', name = 'bread', amount = 10, label = '10x Bread', description = 'A full pantry' },
    { type = 'money', amount = 5000, label = '$5,000', description = 'A serious bonus' },
    { type = 'item', name = 'bandage', amount = 10, label = '10x Bandage', description = 'Emergency supplies' },
    { type = 'black_money', amount = 5000, label = '$5,000', description = 'A final quiet payout' },
    { type = 'money', amount = 7500, label = '$7,500', description = 'Almost there' },
    { type = 'money', amount = 15000, label = '$15,000', description = '30-day completion reward' }
}
