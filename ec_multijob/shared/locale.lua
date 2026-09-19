Locales = {}

local function loadFile(lang)
    local raw = LoadResourceFile(GetCurrentResourceName(), ('locales/%s.json'):format(lang))
    if not raw then return nil end

    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= 'table' then
        print(('^1[ec_multijob] locales/%s.json is not valid JSON^7'):format(lang))
        return nil
    end

    return data
end

local fallback = loadFile('en') or {}
local selected = Config.Locale ~= 'en' and loadFile(Config.Locale) or nil

if Config.Locale ~= 'en' and not selected then
    print(('^3[ec_multijob] locale "%s" not found, using en^7'):format(Config.Locale))
end

for key, value in pairs(fallback) do Locales[key] = value end
if selected then
    for key, value in pairs(selected) do Locales[key] = value end
end

function _U(key, ...)
    local str = Locales[key]
    if not str then return key end
    if select('#', ...) > 0 then return str:format(...) end
    return str
end
