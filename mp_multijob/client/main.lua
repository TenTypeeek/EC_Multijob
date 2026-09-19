local isOpen = false

local function notify(key)
    lib.notify({
        title = _U('notify_title'),
        description = _U(key),
        type = 'error',
        icon = 'briefcase',
        position = Config.NotifyPosition,
        duration = Config.NotifyDuration,
    })
end

local function closeUI()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
end

local function openUI()
    if isOpen then return end

    if IsEntityDead(cache.ped) or IsPauseMenuActive() then
        return notify('err_unavailable')
    end

    local data = lib.callback.await('mp_multijob:getData', false)
    if not data then return end

    isOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'OPEN_MULTIJOB',
        data = data,
        locale = Locales,
    })
end

RegisterCommand(Config.Command, openUI, false)

if Config.Keybind and Config.Keybind ~= '' then
    RegisterKeyMapping(Config.Command, _U('keybind_description'), 'keyboard', Config.Keybind)
end

RegisterNUICallback('closeUI', function(_, cb)
    closeUI()
    cb('ok')
end)

RegisterNUICallback('clockIn', function(body, cb)
    cb(lib.callback.await('mp_multijob:clockIn', false, body and body.job) or { ok = false })
end)

RegisterNUICallback('clockOut', function(body, cb)
    cb(lib.callback.await('mp_multijob:clockOut', false, body and body.job) or { ok = false })
end)

RegisterNUICallback('removeJob', function(body, cb)
    cb(lib.callback.await('mp_multijob:removeJob', false, body and body.job) or { ok = false })
end)

RegisterNetEvent('mp_multijob:refresh', function(data)
    if isOpen then
        SendNUIMessage({ type = 'UPDATE_JOBS', data = data })
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)
