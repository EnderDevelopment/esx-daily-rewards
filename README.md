# ESX Daily Rewards FiveM Resource

ESX Daily Rewards is a configurable FiveM daily reward resource with a 30-day reward cycle, a player-facing NUI menu, and server-side reward claims. Players use the `/daily` command to view the rewards and claim the current day's configured money, black money, or item reward.

## Install

1. Install and start the `es_extended` and `oxmysql` dependencies.
2. Place the resource folder in your server's resources directory.
3. Edit `config.lua` to set the menu text, reset hour, and rewards. Make sure configured item names exist in your server's inventory system.
4. Add `ensure ender_daily_rewards` to your server configuration after its dependencies.
5. Start or restart the server. The resource creates its database table automatically.

## Use

1. Join the server and enter `/daily` in chat.
2. Review the 30-day reward menu. Only the current day's unclaimed reward is selectable; future days are locked.
3. Select the available reward to claim it. Use Escape or the close button to dismiss the menu.

---

More FiveM resource projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/d17f0353-2afe-47a6-b295-ff9b0160c776?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=d17f0353-2afe-47a6-b295-ff9b0160c776
