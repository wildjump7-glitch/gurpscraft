-- core_actor/internal/actor_state.lua

local actors = {}
local next_actor_index = 0

local function clone(value)
    if type(value) ~= "table" then
        return value
    end
    local copy = {}
    for key, item in pairs(value) do
        copy[key] = clone(item)
    end
    return copy
end

local function allocate_actor_id(base)
    base = (type(base) == "string" and base ~= "") and base or "actor"
    next_actor_index = next_actor_index + 1
    return base .. "_" .. tostring(next_actor_index)
end

local function find_actor(subject)
    if type(subject) == "table" then
        if type(subject.id) == "string" and actors[subject.id] then
            return actors[subject.id], subject.id
        end
        if type(subject.get_luaentity) == "function" then
            local entity = subject:get_luaentity()
            if entity and type(entity._actor_id) == "string" and actors[entity._actor_id] then
                return actors[entity._actor_id], entity._actor_id
            end
        end
    elseif type(subject) == "string" then
        return actors[subject], subject
    end
    return nil, nil
end

local function normalize_actor(actor_template)
    if type(actor_template) ~= "table" then
        return nil
    end

    local actor = clone(actor_template)
    actor.id = type(actor.id) == "string" and actor.id or allocate_actor_id(actor.archetype)
    actor.archetype = type(actor.archetype) == "string" and actor.archetype or "unknown"
    actor.display_name = type(actor.display_name) == "string" and actor.display_name or actor.id
    actor.position = type(actor.position) == "table" and actor.position or { x = 0, y = 0, z = 0 }
    actor.state = type(actor.state) == "string" and actor.state or "idle"
    actor.hp = type(actor.hp) == "number" and actor.hp or type(actor.health) == "number" and actor.health or 100
    actor.max_hp = type(actor.max_hp) == "number" and actor.max_hp or actor.hp
    actor.faction = type(actor.faction) == "string" and actor.faction or "neutral"
    actor.inventory = type(actor.inventory) == "table" and actor.inventory or {}
    actor.stats = type(actor.stats) == "table" and actor.stats or {}
    actor.behavior = type(actor.behavior) == "string" and actor.behavior or "passive"
    actor.alertness = type(actor.alertness) == "number" and actor.alertness or 0
    actor.suppression = type(actor.suppression) == "number" and actor.suppression or 0
    actor.moving = actor.moving == true
    actor.destination = actor.destination
    actor.target = actor.target
    actor.last_update = type(actor.last_update) == "number" and actor.last_update or 0

    return actor
end

local function spawn(archetype_id, position, data)
    if type(archetype_id) ~= "string" or archetype_id == "" then
        return nil
    end

    local actor_def = normalize_actor({
        archetype = archetype_id,
        position = position,
        state = data and data.state,
        faction = data and data.faction,
        behavior = data and data.behavior,
        inventory = data and data.inventory,
        stats = data and data.stats,
        display_name = data and data.display_name,
        custom = data and data.custom,
    })

    if not actor_def then
        return nil
    end

    if actors[actor_def.id] then
        return nil
    end

    actor_def.region = nil
    actors[actor_def.id] = actor_def
    if type(core_simulation) == "table" and type(core_simulation.register_actor) == "function" then
        core_simulation.register_actor(actor_def.id, actor_def.faction, actor_def.position)
    end
    return actor_def
end

local function despawn(subject)
    local actor, id = find_actor(subject)
    if not actor or not id then
        return false
    end
    actors[id] = nil
    if type(core_simulation) == "table" and type(core_simulation.unregister_actor) == "function" then
        core_simulation.unregister_actor(id)
    end
    return true
end

local function is_actor(subject)
    local actor, _ = find_actor(subject)
    return type(actor) == "table"
end

local function list_actors()
    local result = {}
    for _, actor in pairs(actors) do
        result[#result + 1] = actor
    end
    return result
end

local function get_faction(subject)
    local actor = find_actor(subject)
    return actor and actor.faction
end

local function set_faction(subject, faction_id)
    local actor = find_actor(subject)
    if not actor or type(faction_id) ~= "string" then
        return false
    end
    actor.faction = faction_id
    return true
end

local function get_stats(subject)
    local actor = find_actor(subject)
    return actor and actor.stats or {}
end

local function get_inventory(subject)
    local actor = find_actor(subject)
    return actor and actor.inventory or {}
end

local function set_state(subject, state)
    local actor = find_actor(subject)
    if not actor or type(state) ~= "string" then
        return false
    end
    actor.state = state
    return true
end

local function get_state(subject)
    local actor = find_actor(subject)
    return actor and actor.state
end

local function update(subject, dt)
    local actor = find_actor(subject)
    if not actor then
        return false
    end
    actor.last_update = (actor.last_update or 0) + (dt or 0)
    if actor.state ~= "dead" then
        actor.alertness = math.min((actor.alertness or 0) + 0.01 * (dt or 0), 1)
        actor.suppression = math.max((actor.suppression or 0) - 0.03 * (dt or 0), 0)
    end
    if type(core_actor) == "table" and core_actor.goals and type(core_actor.goals.process_goals) == "function" then
        core_actor.goals.process_goals(actor, dt)
    end
    return true
end

local function kill(subject)
    local actor = find_actor(subject)
    if not actor then
        return false
    end
    actor.hp = 0
    actor.state = "dead"
    return true
end

local function respawn(subject)
    local actor = find_actor(subject)
    if not actor then
        return false
    end
    actor.hp = actor.max_hp or 100
    actor.state = "idle"
    actor.alertness = 0
    actor.suppression = 0
    return true
end

local function is_dead(subject)
    local actor = find_actor(subject)
    return actor and actor.hp <= 0
end

return {
    spawn = spawn,
    despawn = despawn,
    is_actor = is_actor,
    get_faction = get_faction,
    set_faction = set_faction,
    get_stats = get_stats,
    get_inventory = get_inventory,
    set_state = set_state,
    get_state = get_state,
    update = update,
    kill = kill,
    respawn = respawn,
    is_dead = is_dead,
    list_actors = list_actors,
}
