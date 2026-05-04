-- core_factions/internal/territory.lua

local territories = {}

local function territory_key(pos)
    if type(pos) ~= "table" or type(pos.x) ~= "number" or type(pos.y) ~= "number" or type(pos.z) ~= "number" then
        return nil
    end
    return string.format("%d:%d:%d", pos.x, pos.y, pos.z)
end

local function get_territory_owner(pos)
    local key = territory_key(pos)
    if not key then
        return nil
    end
    return territories[key] and territories[key].owner
end

local function set_territory_owner(pos, faction_id)
    local key = territory_key(pos)
    if not key or (faction_id ~= nil and type(faction_id) ~= "string") then
        return false
    end
    territories[key] = territories[key] or {}
    territories[key].owner = faction_id
    return true
end

local function get_territory_influence(pos, faction_id)
    local key = territory_key(pos)
    if not key then
        return 0
    end
    local entry = territories[key] or {}
    if faction_id then
        return entry[faction_id] or 0
    end
    return entry.influence or 0
end

return {
    get_territory_owner = get_territory_owner,
    set_territory_owner = set_territory_owner,
    get_territory_influence = get_territory_influence,
}
