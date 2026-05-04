-- core_factions/internal/registry.lua

local factions = {}

local function normalize_id(id)
    return tostring(id)
end

local function register(faction_id, faction_data)
    if type(faction_id) ~= "string" or faction_id == "" or type(faction_data) ~= "table" then
        return false
    end
    local id = normalize_id(faction_id)
    if factions[id] then
        return false
    end
    factions[id] = faction_data
    return true
end

local function get(faction_id)
    if type(faction_id) ~= "string" then
        return nil
    end
    return factions[normalize_id(faction_id)]
end

local function all()
    local copy = {}
    for id, def in pairs(factions) do
        copy[id] = def
    end
    return copy
end

local function exists(faction_id)
    if type(faction_id) ~= "string" then
        return false
    end
    return factions[normalize_id(faction_id)] ~= nil
end

return {
    register = register,
    get = get,
    all = all,
    exists = exists,
}
