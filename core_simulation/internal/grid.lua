-- core_simulation/internal/grid.lua

local config = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/config.lua")

local regions = {}

local function region_key(rx, rz)
    if type(rx) ~= "number" or type(rz) ~= "number" then
        return nil
    end
    return string.format("%d:%d", rx, rz)
end

local function world_to_region(x, z)
    if type(x) ~= "number" or type(z) ~= "number" then
        return nil
    end
    local rx = math.floor(x / config.REGION_SIZE)
    local rz = math.floor(z / config.REGION_SIZE)
    return { rx = rx, rz = rz }
end

local function region_to_world_bounds(rx, rz)
    if type(rx) ~= "number" or type(rz) ~= "number" then
        return nil
    end
    local minx = rx * config.REGION_SIZE
    local minz = rz * config.REGION_SIZE
    local maxx = minx + config.REGION_SIZE - 1
    local maxz = minz + config.REGION_SIZE - 1
    return { minx = minx, maxx = maxx, minz = minz, maxz = maxz }
end

local function create_region(rx, rz)
    local key = region_key(rx, rz)
    if not key then
        return nil
    end
    if regions[key] then
        return regions[key]
    end
    regions[key] = {
        rx = rx,
        rz = rz,
        ownerfactionid = nil,
        contested = false,
        influence = {},
        lastsimtick = 0,
    }
    return regions[key]
end

local function get_region(rx, rz)
    if type(rx) ~= "number" or type(rz) ~= "number" then
        return nil
    end
    return regions[region_key(rx, rz)] or create_region(rx, rz)
end

local function get_region_owner(rx, rz)
    local region = get_region(rx, rz)
    if region then
        return region.ownerfactionid
    end
    return nil
end

local function get_region_influence(rx, rz)
    local region = get_region(rx, rz)
    if not region then
        return {}
    end
    local copy = {}
    for faction_id, value in pairs(region.influence or {}) do
        copy[faction_id] = value
    end
    return copy
end

return {
    world_to_region = world_to_region,
    region_to_world_bounds = region_to_world_bounds,
    get_region = get_region,
    get_region_owner = get_region_owner,
    get_region_influence = get_region_influence,
}
