local nuiOpen = false

local function setNui(state)
    nuiOpen = state
    SetNuiFocus(state, state)
    SendNUIMessage({ action = state and 'show' or 'hide' })
end

RegisterNetEvent('ender_daily:open', function(data)
    nuiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', data = data })
end)

RegisterNetEvent('ender_daily:notify', function(message, kind)
    SendNUIMessage({ action = 'toast', message = message, kind = kind or 'info' })
end)

RegisterNUICallback('close', function(_, callback)
    setNui(false)
    callback({ ok = true })
end)

RegisterNUICallback('claim', function(data, callback)
    local day = tonumber(data.day)
    if day then TriggerServerEvent('ender_daily:claim', day) end
    callback({ ok = true })
end)

CreateThread(function()
    while true do
        if nuiOpen and IsControlJustReleased(0, 322) then setNui(false) end
        Wait(0)
    end
end)
