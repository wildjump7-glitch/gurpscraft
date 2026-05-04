-- core_dimension/internal/teleport.lua

local function teleport(actor, dimension_id, pos)
    if type(actor) ~= "table" or type(dimension_id) ~= "string" or type(pos) ~= "table" then
        return false
    end
    if type(pos.x) ~= "number" or type(pos.y) ~= "number" or type(pos.z) ~= "number" then
        return false
    end
    actor.position = pos
    actor.dimension = dimension_id
    return true
end

local function teleport_safe(actor, dimension_id, pos)
    if type(actor) ~= "table" or type(dimension_id) ~= "string" or type(pos) ~= "table" then
        return false
    end
    if type(pos.x) ~= "number" or type(pos.y) ~= "number" or type(pos.z) ~= "number" then
        return false
    end
    local destination = pos
    if minetest and minetest.get_node then
        local node = minetest.get_node_or_nil(pos)
        if node and node.name ~= "air" then
            destination = core_dimension.get_spawn_point(dimension_id) or destination
        end
    end
    actor.position = destination
    actor.dimension = dimension_id
    return true
end

local function can_enter(actor, dimension_id)
    if type(actor) ~= "table" or type(dimension_id) ~= "string" then
        return false
    end
    return core_dimension and core_dimension.get(dimension_id) ~= nil
end

local function can_exit(actor, dimension_id)
    if type(actor) ~= "table" or type(dimension_id) ~= "string" then
        return false
    end
    return actor.dimension == dimension_id
end

local function get_spawn_point(dimension_id)
    if type(dimension_id) ~= "string" then
        return { x = 0, y = 10, z = 0 }
    end
    local def = core_dimension and core_dimension.get(dimension_id)
    return (def and def.spawn) or { x = 0, y = 10, z = 0 }
end

local function on_enter(actor, dimension_id)
    if type(actor) ~= "table" or type(dimension_id) ~= "string" then
        return false
    end
    actor.dimension = dimension_id
    return true
end

local function on_exit(actor, dimension_id)
    if type(actor) ~= "table" or type(dimension_id) ~= "string" then
        return false
    end
    actor.dimension = nil
    return true
end

return {
    teleport = teleport,
    teleport_safe = teleport_safe,
    can_enter = can_enter,
    can_exit = can_exit,
    get_spawn_point = get_spawn_point,
    on_enter = on_enter,
    on_exit = on_exit,
}
