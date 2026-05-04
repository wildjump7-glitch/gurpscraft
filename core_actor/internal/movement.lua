-- core_actor/internal/movement.lua

local function get_position(actor)
    if type(actor) ~= "table" then
        return nil
    end
    return type(actor.position) == "table" and actor.position or nil
end

local function normalize_vector(vec)
    if type(vec) ~= "table" then
        return { x = 0, y = 0, z = 0 }
    end
    return { x = vec.x or 0, y = vec.y or 0, z = vec.z or 0 }
end

local function vector_distance(a, b)
    a = normalize_vector(a)
    b = normalize_vector(b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    local dz = a.z - b.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function update_simulation_position(actor)
    if type(core_simulation) == "table" and type(core_simulation.update_actor_position) == "function" and type(actor) == "table" and type(actor.id) == "string" and type(actor.position) == "table" then
        core_simulation.update_actor_position(actor.id, actor.position)
    end
end

local function move_towards(actor, position)
    if type(actor) ~= "table" or type(position) ~= "table" then
        return false
    end

    actor.position = actor.position or { x = 0, y = 0, z = 0 }
    local current = normalize_vector(actor.position)
    local goal = normalize_vector(position)
    local dx, dy, dz = goal.x - current.x, goal.y - current.y, goal.z - current.z
    local distance = vector_distance(current, goal)
    if distance <= 0 then
        actor.moving = false
        return true
    end

    local speed = (actor.stats and actor.stats.attributes and actor.stats.attributes.speed) or 1
    local step = math.max(0.1, speed)
    local ratio = math.min(1, step / distance)

    actor.position.x = current.x + dx * ratio
    actor.position.y = current.y + dy * ratio
    actor.position.z = current.z + dz * ratio
    actor.moving = true
    actor.destination = goal
    update_simulation_position(actor)
    return true
end

local function move_away(actor, position)
    if type(actor) ~= "table" or type(position) ~= "table" then
        return false
    end

    actor.position = actor.position or { x = 0, y = 0, z = 0 }
    local current = normalize_vector(actor.position)
    local threat = normalize_vector(position)
    local dx, dy, dz = current.x - threat.x, current.y - threat.y, current.z - threat.z
    local distance = vector_distance(current, threat)
    if distance <= 0 then
        actor.moving = false
        return true
    end

    local speed = (actor.stats and actor.stats.attributes and actor.stats.attributes.speed) or 1
    local step = math.max(0.1, speed)
    local ratio = math.min(1, step / distance)

    actor.position.x = current.x + dx * ratio
    actor.position.y = current.y + dy * ratio
    actor.position.z = current.z + dz * ratio
    actor.moving = true
    actor.destination = { x = actor.position.x, y = actor.position.y, z = actor.position.z }
    update_simulation_position(actor)
    return true
end

local function stop(actor)
    if type(actor) ~= "table" then
        return false
    end
    actor.moving = false
    actor.destination = nil
    return true
end

local function pathfind(actor, destination)
    if type(actor) ~= "table" or type(destination) ~= "table" then
        return false
    end

    local actor_pos = normalize_vector(actor.position or {})
    local dest_pos = normalize_vector(destination)

    if type(minetest) == "table" and type(minetest.find_path) == "function" then
        local path = minetest.find_path(actor_pos, dest_pos, 20)
        actor.path = path or {}
        actor.destination = dest_pos
        actor.moving = #actor.path > 0
        update_simulation_position(actor)
        return true
    end

    actor.destination = dest_pos
    actor.moving = true
    update_simulation_position(actor)
    return true
end

return {
    move_towards = move_towards,
    move_away = move_away,
    stop = stop,
    pathfind = pathfind,
}
