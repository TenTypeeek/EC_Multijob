if not Framework.name then return end

local TICK_SECONDS = 60
local SAVE_SECONDS = 300

local Cache = {}
local lastAction = {}

local blocked = { [Config.UnemployedJob] = true }
for _, job in ipairs(Config.BlockedJobs) do blocked[job] = true end

local locked = {}
for _, job in ipairs(Config.LockedJobs) do locked[job] = true end

local function notify(src, key, ntype, ...)
    lib.notify(src, {
        title = _U('notify_title'),
        description = _U(key, ...),
        type = ntype or 'inform',
        icon = 'briefcase',
        position = Config.NotifyPosition,
        duration = Config.NotifyDuration,
    })
end

local function dayKey()
    return os.date('%Y-%m-%d')
end

local function weekKey()
    local sinceMonday = (os.date('*t').wday + 5) % 7
    return os.date('%Y-%m-%d', os.time() - sinceMonday * 86400)
end

local function newRow(grade)
    return {
        grade = grade, active = true,
        total = 0, week = 0, day = 0,
        weekKey = weekKey(), dayKey = dayKey(),
        dirty = false,
    }
end

local function rollover(row)
    local d, w = dayKey(), weekKey()
    if row.dayKey ~= d then row.day = 0; row.dayKey = d; row.dirty = true end
    if row.weekKey ~= w then row.week = 0; row.weekKey = w; row.dirty = true end
end

local function activeCount(c)
    local n = 0
    for _, row in pairs(c.jobs) do
        if row.active then n = n + 1 end
    end
    return n
end

local UPSERT = [[
    INSERT INTO multijob_jobs
        (identifier, job, grade, active, total_seconds, week_seconds, day_seconds, week_key, day_key)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
        grade = VALUES(grade), active = VALUES(active),
        total_seconds = VALUES(total_seconds), week_seconds = VALUES(week_seconds),
        day_seconds = VALUES(day_seconds), week_key = VALUES(week_key), day_key = VALUES(day_key)
]]

local function saveRow(identifier, job, row, sync)
    row.dirty = false
    local params = {
        identifier, job, row.grade, row.active and 1 or 0,
        row.total, row.week, row.day, row.weekKey, row.dayKey,
    }
    if sync then
        MySQL.query.await(UPSERT, params)
    else
        MySQL.query(UPSERT, params)
    end
end

local function flushPlayer(c, sync)
    for job, row in pairs(c.jobs) do
        if row.dirty then saveRow(c.id, job, row, sync) end
    end
end

local function setJobInternal(src, job, grade)
    local c = Cache[src]
    if not c then return false end

    c.internal = true
    local ok, result = pcall(Framework.SetJob, src, job, grade)
    c.internal = false

    if ok and result then
        c.current = job
        return true
    end
    return false
end

local function buildPayload(src)
    local c = Cache[src]
    if not c then return nil end

    local current = Framework.GetJob(src)
    local jobs = {}

    for name, row in pairs(c.jobs) do
        if row.active then
            rollover(row)
            local info = Framework.GetJobInfo(name, row.grade)
            jobs[#jobs + 1] = {
                job = name,
                label = info and info.label or name,
                grade = row.grade,
                gradeLabel = info and info.gradeLabel or tostring(row.grade),
                salary = info and info.salary or 0,
                total = row.total,
                week = row.week,
                day = row.day,
                current = name == current,
                locked = locked[name] == true,
            }
        end
    end

    jobs[#jobs + 1] = {
        job = Config.UnemployedJob,
        label = '',
        gradeLabel = '',
        unemployed = true,
        locked = true,
        current = current == Config.UnemployedJob,
        salary = 0, total = 0, week = 0, day = 0, grade = 0,
    }

    table.sort(jobs, function(a, b)
        if a.current ~= b.current then return a.current end
        local au, bu = a.unemployed == true, b.unemployed == true
        if au ~= bu then return bu end
        return a.label:lower() < b.label:lower()
    end)

    return { jobs = jobs, current = current, max = Config.MaxJobs, target = Config.WeeklyTarget }
end

local function pushRefresh(src)
    local payload = buildPayload(src)
    if payload then TriggerClientEvent('mp_multijob:refresh', src, payload) end
end

local function addJob(src, job, grade, silent)
    local c = Cache[src]
    if not c then return false, 'err_generic' end

    grade = tonumber(grade) or 0
    if type(job) ~= 'string' or blocked[job] then return false, 'err_blacklisted' end

    local info = Framework.GetJobInfo(job, grade)
    if not info then return false, 'err_invalid_job' end

    local row = c.jobs[job]
    local alreadyListed = row and row.active

    if not alreadyListed and activeCount(c) >= Config.MaxJobs then
        return false, 'err_max_jobs'
    end

    if not row then
        row = newRow(grade)
        c.jobs[job] = row
    end

    row.grade = grade
    row.active = true
    saveRow(c.id, job, row)

    if not alreadyListed and not silent then
        notify(src, 'job_added', 'success', info.label)
    end

    return true
end

local function removeJob(src, job, silent)
    local c = Cache[src]
    local row = c and c.jobs[job]
    if not row or not row.active then return false end

    local info = Framework.GetJobInfo(job, row.grade)
    local label = info and info.label or job

    if Framework.GetJob(src) == job then
        setJobInternal(src, Config.UnemployedJob, 0)
    end

    if Config.KeepHours then
        row.active = false
        saveRow(c.id, job, row)
    else
        c.jobs[job] = nil
        MySQL.query('DELETE FROM multijob_jobs WHERE identifier = ? AND job = ?', { c.id, job })
    end

    if not silent then notify(src, 'job_removed', 'inform', label) end
    return true
end

local function onJobChanged(src, name, grade)
    local c = Cache[src]
    if not c or not name then return end

    local previous = c.current
    c.current = name

    if not c.internal then
        if name == Config.UnemployedJob then
            local prevRow = previous and previous ~= name and c.jobs[previous]
            if Config.RemoveFiredJobs and prevRow and prevRow.active then
                removeJob(src, previous)
            end
        elseif not blocked[name] then
            local row = c.jobs[name]
            if row and row.active then
                if row.grade ~= grade then
                    row.grade = tonumber(grade) or 0
                    saveRow(c.id, name, row)
                end
            elseif Config.AutoAddJobs then
                local ok, reason = addJob(src, name, grade)
                if not ok and reason == 'err_max_jobs' then
                    local info = Framework.GetJobInfo(name, grade)
                    notify(src, 'err_max_jobs_auto', 'error', info and info.label or name)
                end
            end
        end
    end

    pushRefresh(src)
end

local function loadPlayer(src)
    src = tonumber(src)
    if not src then return end

    local id
    for _ = 1, 10 do
        id = Framework.GetIdentifier(src)
        if id then break end
        Wait(500)
    end
    if not id then return end

    local rows = MySQL.query.await(
        'SELECT job, grade, active, total_seconds, week_seconds, day_seconds, week_key, day_key FROM multijob_jobs WHERE identifier = ?',
        { id }
    ) or {}

    local c = { id = id, jobs = {}, internal = false }
    for _, r in ipairs(rows) do
        local row = {
            grade = r.grade, active = r.active == 1,
            total = r.total_seconds, week = r.week_seconds, day = r.day_seconds,
            weekKey = r.week_key, dayKey = r.day_key,
            dirty = false,
        }
        rollover(row)
        c.jobs[r.job] = row
    end
    Cache[src] = c

    local name, grade = Framework.GetJob(src)
    c.current = name
    if name and Config.AutoAddJobs and not blocked[name] then
        local row = c.jobs[name]
        if not (row and row.active) then addJob(src, name, grade, true) end
    end
end

local function unloadPlayer(src)
    local c = Cache[src]
    if c then flushPlayer(c) end
    Cache[src] = nil
    lastAction[src] = nil
end

if Framework.name == 'esx' then
    AddEventHandler('esx:playerLoaded', function(src) loadPlayer(src) end)
    AddEventHandler('esx:playerLogout', function(src) unloadPlayer(src) end)
    AddEventHandler('esx:setJob', function(src, job)
        if job then onJobChanged(src, job.name, tonumber(job.grade)) end
    end)
else
    AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
        loadPlayer(player.PlayerData.source)
    end)
    AddEventHandler('QBCore:Server:OnPlayerUnload', function(src) unloadPlayer(src) end)
    AddEventHandler('QBCore:Server:OnJobUpdate', function(src, job)
        if not job then return end
        local grade = type(job.grade) == 'table' and job.grade.level or job.grade
        onJobChanged(src, job.name, tonumber(grade))
    end)
end

AddEventHandler('playerDropped', function()
    unloadPlayer(source)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, c in pairs(Cache) do flushPlayer(c, true) end
end)

CreateThread(function()
    Wait(1000)
    for _, id in ipairs(GetPlayers()) do
        CreateThread(function() loadPlayer(id) end)
    end
end)

if Config.TrackHours then
    CreateThread(function()
        local sinceSave = 0

        while true do
            Wait(TICK_SECONDS * 1000)

            for _, c in pairs(Cache) do
                local row = c.current and c.jobs[c.current]
                if row and row.active then
                    rollover(row)
                    row.total = row.total + TICK_SECONDS
                    row.week = row.week + TICK_SECONDS
                    row.day = row.day + TICK_SECONDS
                    row.dirty = true
                end
            end

            sinceSave = sinceSave + TICK_SECONDS
            if sinceSave >= SAVE_SECONDS then
                sinceSave = 0
                for _, c in pairs(Cache) do flushPlayer(c) end
            end
        end
    end)
end

local function onCooldown(src)
    local now = GetGameTimer()
    local last = lastAction[src]
    if last and now - last < Config.Cooldown * 1000 then return true end
    lastAction[src] = now
    return false
end

local function result(src, ok)
    return { ok = ok, data = buildPayload(src) }
end

local function fail(src, key, ...)
    notify(src, key, 'error', ...)
    return result(src, false)
end

local function switchToUnemployed(src, c)
    if Framework.GetJob(src) == Config.UnemployedJob then return fail(src, 'err_already_unemployed') end
    if not Framework.GetJobInfo(Config.UnemployedJob, 0) then return fail(src, 'err_no_unemployed') end

    flushPlayer(c)

    if not setJobInternal(src, Config.UnemployedJob, 0) then return fail(src, 'err_generic') end

    notify(src, 'clocked_out', 'inform')
    return result(src, true)
end

lib.callback.register('mp_multijob:getData', function(src)
    return buildPayload(src)
end)

lib.callback.register('mp_multijob:clockIn', function(src, job)
    local c = Cache[src]
    if not c or type(job) ~= 'string' then return { ok = false } end
    if onCooldown(src) then return fail(src, 'err_cooldown') end

    if job == Config.UnemployedJob then return switchToUnemployed(src, c) end

    local row = c.jobs[job]
    if not row or not row.active then return fail(src, 'err_not_found') end

    local info = Framework.GetJobInfo(job, row.grade)
    if not info then return fail(src, 'err_invalid_job') end

    if Framework.GetJob(src) == job then return fail(src, 'err_already_clocked_in') end

    if not setJobInternal(src, job, row.grade) then return fail(src, 'err_generic') end

    notify(src, 'clocked_in', 'success', info.label)
    return result(src, true)
end)

lib.callback.register('mp_multijob:clockOut', function(src, job)
    local c = Cache[src]
    if not c or type(job) ~= 'string' then return { ok = false } end
    if onCooldown(src) then return fail(src, 'err_cooldown') end

    if Framework.GetJob(src) ~= job then return fail(src, 'err_not_clocked_in') end
    if job == Config.UnemployedJob then return fail(src, 'err_already_unemployed') end

    return switchToUnemployed(src, c)
end)

lib.callback.register('mp_multijob:removeJob', function(src, job)
    local c = Cache[src]
    if not c or type(job) ~= 'string' then return { ok = false } end
    if onCooldown(src) then return fail(src, 'err_cooldown') end

    if job == Config.UnemployedJob or locked[job] then return fail(src, 'err_unremovable') end

    local row = c.jobs[job]
    if not row or not row.active then return fail(src, 'err_not_found') end

    removeJob(src, job)
    return result(src, true)
end)

exports('AddJob', function(src, job, grade)
    return addJob(src, job, grade)
end)

exports('RemoveJob', function(src, job)
    if job == Config.UnemployedJob then return false end
    return removeJob(src, job)
end)

exports('HasJob', function(src, job)
    local c = Cache[src]
    local row = c and c.jobs[job]
    return row ~= nil and row.active
end)

exports('GetJobs', function(src)
    local c = Cache[src]
    local list = {}
    if not c then return list end
    for name, row in pairs(c.jobs) do
        if row.active then
            list[#list + 1] = { job = name, grade = row.grade, total = row.total, week = row.week, day = row.day }
        end
    end
    return list
end)
