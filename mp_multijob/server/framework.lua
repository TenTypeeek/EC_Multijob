Framework = { name = nil }

local function isRunning(resource)
    local state = GetResourceState(resource)
    return state == 'started' or state == 'starting'
end

local function detect()
    if Config.Framework == 'esx' or Config.Framework == 'qb' then
        return Config.Framework
    end
    if isRunning('es_extended') then return 'esx' end
    if isRunning('qb-core') then return 'qb' end
end

Framework.name = detect()

if not Framework.name then
    print('^1[mp_multijob] No framework found. Make sure es_extended or qb-core starts BEFORE mp_multijob.^7')
    return
end

print(('^2[mp_multijob] Framework: %s^7'):format(Framework.name))

if Framework.name == 'esx' then
    local ESX = exports['es_extended']:getSharedObject()

    function Framework.GetIdentifier(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer and xPlayer.identifier or nil
    end

    function Framework.GetJob(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer or not xPlayer.job then return nil end
        return xPlayer.job.name, tonumber(xPlayer.job.grade) or 0
    end

    function Framework.SetJob(src, job, grade)
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return false end
        xPlayer.setJob(job, grade)
        return true
    end

    function Framework.GetJobInfo(job, grade)
        local jobs = ESX.GetJobs and ESX.GetJobs() or ESX.Jobs
        local data = jobs and jobs[job]
        if not data or not data.grades then return nil end

        local g = data.grades[tostring(grade)] or data.grades[tonumber(grade)]
        if not g then return nil end

        return {
            label = data.label or job,
            gradeLabel = g.label or tostring(grade),
            salary = g.salary or 0,
        }
    end
else
    local QBCore = exports['qb-core']:GetCoreObject()

    function Framework.GetIdentifier(src)
        local player = QBCore.Functions.GetPlayer(src)
        return player and player.PlayerData.citizenid or nil
    end

    function Framework.GetJob(src)
        local player = QBCore.Functions.GetPlayer(src)
        if not player or not player.PlayerData.job then return nil end
        local job = player.PlayerData.job
        local grade = type(job.grade) == 'table' and job.grade.level or job.grade
        return job.name, tonumber(grade) or 0
    end

    function Framework.SetJob(src, job, grade)
        local player = QBCore.Functions.GetPlayer(src)
        if not player then return false end
        local ok = player.Functions.SetJob(job, grade)
        if ok then player.Functions.SetJobDuty(true) end
        return ok == true
    end

    function Framework.GetJobInfo(job, grade)
        local data = QBCore.Shared.Jobs and QBCore.Shared.Jobs[job]
        if not data or not data.grades then return nil end

        local g = data.grades[tostring(grade)] or data.grades[tonumber(grade)]
        if not g then return nil end

        return {
            label = data.label or job,
            gradeLabel = g.name or tostring(grade),
            salary = g.payment or 0,
        }
    end
end
