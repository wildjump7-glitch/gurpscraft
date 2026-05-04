-- core_simulation/internal/territory.lua

local events = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/events.lua")
local grid = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/grid.lua")
local config = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/config.lua")

local function update_region_status(region)
    if type(region) ~= "table" then
        return false
    end

    local previous_owner = region.ownerfactionid
    local previous_contested = region.contested
    local winner = nil
    local winner_value = 0
    local runner_up = 0

    for faction_id, value in pairs(region.influence or {}) do
        if type(value) == "number" and value > winner_value then
            runner_up = winner_value
            winner_value = value
            winner = faction_id
        elseif type(value) == "number" and value > runner_up then
            runner_up = value
        end
    end

    local contested = false
    if winner and runner_up > 0 then
        contested = math.abs(winner_value - runner_up) <= config.CONTENDED_DIFFERENCE
    end

    region.contested = contested
    if not contested then
        region.ownerfactionid = winner
    end

    region.lastsimtick = region.lastsimtick + 1

    if previous_owner ~= region.ownerfactionid then
        events.dispatch_event("onterritorychanged", {
            rx = region.rx,
            rz = region.rz,
            previous_owner = previous_owner,
            new_owner = region.ownerfactionid,
            region = region,
        })
    end

    if previous_contested ~= region.contested and region.contested then
        events.dispatch_event("onregionconflict", {
            rx = region.rx,
            rz = region.rz,
            region = region,
        })
    end

    return true
end

local function set_region_influence(rx, rz, faction_id, value)
    if type(rx) ~= "number" or type(rz) ~= "number" or type(faction_id) ~= "string" or type(value) ~= "number" then
        return false
    end
    local region = grid.get_region(rx, rz)
    if not region then
        return false
    end

    region.influence = region.influence or {}
    region.influence[faction_id] = math.max(0, value)
    return update_region_status(region)
end

local function add_region_influence(rx, rz, faction_id, delta)
    if type(rx) ~= "number" or type(rz) ~= "number" or type(faction_id) ~= "string" or type(delta) ~= "number" then
        return false
    end
    local region = grid.get_region(rx, rz)
    if not region then
        return false
    end
    region.influence = region.influence or {}
    local previous = region.influence[faction_id] or 0
    region.influence[faction_id] = math.max(0, previous + delta)
    return update_region_status(region)
end

local function get_region_owner(rx, rz)
    return grid.get_region_owner(rx, rz)
end

local function get_region_influence(rx, rz)
    return grid.get_region_influence(rx, rz)
end

return {
    set_region_influence = set_region_influence,
    add_region_influence = add_region_influence,
    get_region_owner = get_region_owner,
    get_region_influence = get_region_influence,
}
