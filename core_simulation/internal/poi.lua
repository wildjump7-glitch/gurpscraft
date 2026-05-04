-- core_simulation/internal/poi.lua

local grid = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/grid.lua")
local events = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/events.lua")

local pois = {}

local function normalize_poi(def)
    if type(def) ~= "table" or type(def.id) ~= "string" or type(def.pos) ~= "table" then
        return nil
    end
    if type(def.pos.x) ~= "number" or type(def.pos.y) ~= "number" or type(def.pos.z) ~= "number" then
        return nil
    end
    local region = grid.world_to_region(def.pos.x, def.pos.z)
    if not region then
        return nil
    end
    return {
        id = def.id,
        pos = { x = def.pos.x, y = def.pos.y, z = def.pos.z },
        region = { rx = region.rx, rz = region.rz },
        faction_id = type(def.faction_id) == "string" and def.faction_id or nil,
        strategic_value = type(def.strategic_value) == "number" and def.strategic_value or 0,
        tags = type(def.tags) == "table" and def.tags or {},
        state = {
            alert_level = 0,
            lastsimtick = 0,
        },
        metadata = type(def.metadata) == "table" and def.metadata or {},
    }
end

local function register_poi(def)
    local poi = normalize_poi(def)
    if not poi then
        return nil
    end
    pois[poi.id] = poi
    return poi
end

local function get_poi(id)
    if type(id) ~= "string" then
        return nil
    end
    return pois[id]
end

local function get_pois_in_region(rx, rz)
    local result = {}
    for _, poi in pairs(pois) do
        if poi.region and poi.region.rx == rx and poi.region.rz == rz then
            result[#result + 1] = poi
        end
    end
    return result
end

local function set_poi_faction(id, faction_id)
    if type(id) ~= "string" or (faction_id ~= nil and type(faction_id) ~= "string") then
        return false
    end
    local poi = pois[id]
    if not poi then
        return false
    end
    local previous_owner = poi.faction_id
    poi.faction_id = faction_id
    if previous_owner ~= faction_id then
        events.dispatch_event("onpoicaptured", {
            poi = poi,
            previous_owner = previous_owner,
            new_owner = faction_id,
        })
    end
    return true
end

local function update_poi_state(id, state)
    if type(id) ~= "string" or type(state) ~= "table" then
        return false
    end
    local poi = pois[id]
    if not poi then
        return false
    end
    poi.state = poi.state or { alert_level = 0, lastsimtick = 0 }
    for key, value in pairs(state) do
        poi.state[key] = value
    end
    poi.state.lastsimtick = poi.state.lastsimtick + 1
    return true
end

local function tick_poi_alerts(current_tick)
    for _, poi in pairs(pois) do
        poi.state = poi.state or { alert_level = 0, lastsimtick = 0 }
        if type(poi.state.alert_level) == "number" then
            poi.state.alert_level = math.max(0, poi.state.alert_level - 0.1)
        end
        poi.state.lastsimtick = current_tick
    end
end

return {
    register_poi = register_poi,
    get_poi = get_poi,
    get_pois_in_region = get_pois_in_region,
    set_poi_faction = set_poi_faction,
    update_poi_state = update_poi_state,
    tick_poi_alerts = tick_poi_alerts,
}
