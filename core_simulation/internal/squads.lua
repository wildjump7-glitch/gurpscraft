-- core_simulation/internal/squads.lua

local grid = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/grid.lua")
local events = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/events.lua")
local territory = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/territory.lua")

local squads = {}

local function normalize_region(region)
    if type(region) ~= "table" or type(region.rx) ~= "number" or type(region.rz) ~= "number" then
        return nil
    end
    return { rx = region.rx, rz = region.rz }
end

local function create_squad(def)
    if type(def) ~= "table" or type(def.id) ~= "string" or type(def.faction_id) ~= "string" then
        return nil
    end

    local region = normalize_region(def.region) or { rx = 0, rz = 0 }
    local target_region = normalize_region(def.target_region) or { rx = region.rx, rz = region.rz }

    local squad = {
        id = def.id,
        faction_id = def.faction_id,
        region = { rx = region.rx, rz = region.rz },
        target_region = { rx = target_region.rx, rz = target_region.rz },
        behavior = type(def.behavior) == "string" and def.behavior or "patrol",
        strength = type(def.strength) == "number" and def.strength or 1.0,
        supplies = type(def.supplies) == "number" and def.supplies or 1.0,
        morale = type(def.morale) == "number" and def.morale or 1.0,
        state = {
            path = {},
            path_index = 1,
            lastsimtick = 0,
        },
        metadata = type(def.metadata) == "table" and def.metadata or {},
    }

    squads[squad.id] = squad
    events.dispatch_event("onsquadcreated", { squad = squad })
    return squad
end

local function get_squad(id)
    if type(id) ~= "string" then
        return nil
    end
    return squads[id]
end

local function get_squads_in_region(rx, rz)
    local result = {}
    for _, squad in pairs(squads) do
        if squad.region.rx == rx and squad.region.rz == rz then
            result[#result + 1] = squad
        end
    end
    return result
end

local function set_squad_target(id, target_region)
    if type(id) ~= "string" then
        return false
    end
    local squad = squads[id]
    if not squad then
        return false
    end
    local normalized = normalize_region(target_region)
    if not normalized then
        return false
    end
    squad.target_region = normalized
    return true
end

local function destroy_squad(id)
    if type(id) ~= "string" then
        return false
    end
    if not squads[id] then
        return false
    end
    squads[id] = nil
    events.dispatch_event("onsquaddestroyed", { squad_id = id })
    return true
end

local function find_adjacent_region(region, target)
    local rx = region.rx
    local rz = region.rz
    if target.rx > rx then
        rx = rx + 1
    elseif target.rx < rx then
        rx = rx - 1
    elseif target.rz > rz then
        rz = rz + 1
    elseif target.rz < rz then
        rz = rz - 1
    end
    return { rx = rx, rz = rz }
end

local function resolve_region_conflicts()
    local region_map = {}
    for _, squad in pairs(squads) do
        local key = string.format("%d:%d", squad.region.rx, squad.region.rz)
        region_map[key] = region_map[key] or {}
        region_map[key][squad.faction_id] = region_map[key][squad.faction_id] or 0
        region_map[key][squad.faction_id] = region_map[key][squad.faction_id] + squad.strength
    end

    for key, factions in pairs(region_map) do
        local rx, rz = key:match("^(%-?%d+):(%-?%d+)$")
        rx = tonumber(rx)
        rz = tonumber(rz)
        if rx and rz then
            local count = 0
            for _ in pairs(factions) do
                count = count + 1
            end
            if count > 1 then
                events.dispatch_event("onregionconflict", {
                    rx = rx,
                    rz = rz,
                    factions = factions,
                })
                for faction_id, strength in pairs(factions) do
                    territory.add_region_influence(rx, rz, faction_id, strength * 0.1)
                end
            end
        end
    end
end

local function move_squads()
    for _, squad in pairs(squads) do
        if squad.region.rx ~= squad.target_region.rx or squad.region.rz ~= squad.target_region.rz then
            local next_region = find_adjacent_region(squad.region, squad.target_region)
            squad.region = next_region
            squad.state.lastsimtick = squad.state.lastsimtick + 1
            if squad.region.rx == squad.target_region.rx and squad.region.rz == squad.target_region.rz then
                squad.behavior = squad.behavior or "patrol"
            end
        end
    end
end

return {
    create_squad = create_squad,
    get_squad = get_squad,
    get_squads_in_region = get_squads_in_region,
    set_squad_target = set_squad_target,
    destroy_squad = destroy_squad,
    move_squads = move_squads,
    resolve_region_conflicts = resolve_region_conflicts,
}
