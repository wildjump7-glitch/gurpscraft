-- core_simulation/internal/actors.lua

local grid = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/grid.lua")

local actor_registry = {}

local function register_actor(actor_id, faction_id, pos)
    if type(actor_id) ~= "string" or actor_id == "" or type(faction_id) ~= "string" or type(pos) ~= "table" then
        return false
    end
    if type(pos.x) ~= "number" or type(pos.y) ~= "number" or type(pos.z) ~= "number" then
        return false
    end
    local region = grid.world_to_region(pos.x, pos.z)
    actor_registry[actor_id] = {
        faction_id = faction_id,
        pos = { x = pos.x, y = pos.y, z = pos.z },
        region = region or { rx = 0, rz = 0 },
    }
    return true
end

local function update_actor_position(actor_id, pos)
    if type(actor_id) ~= "string" or type(pos) ~= "table" then
        return false
    end
    local record = actor_registry[actor_id]
    if not record then
        return false
    end
    if type(pos.x) ~= "number" or type(pos.y) ~= "number" or type(pos.z) ~= "number" then
        return false
    end
    record.pos = { x = pos.x, y = pos.y, z = pos.z }
    local region = grid.world_to_region(pos.x, pos.z)
    if region then
        record.region = region
    end
    return true
end

local function unregister_actor(actor_id)
    if type(actor_id) ~= "string" then
        return false
    end
    actor_registry[actor_id] = nil
    return true
end

local function get_actor(actor_id)
    if type(actor_id) ~= "string" then
        return nil
    end
    return actor_registry[actor_id]
end

return {
    register_actor = register_actor,
    update_actor_position = update_actor_position,
    unregister_actor = unregister_actor,
    get_actor = get_actor,
}
