-- core_actor/api.lua
-- Public API for actor management, AI, perception, and behavior trees.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local actor = {}
actor.data = {}

local state = {
    registry = {},
    actor_state = {},
}

actor._state = state

actor.actor_state = dofile(modpath .. "/internal/actor_state.lua")
actor.behavior_tree = dofile(modpath .. "/internal/behavior_tree.lua")
actor.perception = dofile(modpath .. "/internal/perception.lua")
actor.movement = dofile(modpath .. "/internal/movement.lua")
actor.combat_ai = dofile(modpath .. "/internal/combat_ai.lua")

--[[
Spawn a new actor at a position.
archetype_id: string (from actor data)
pos: table with x, y, z coordinates
data: optional table with archetype-specific parameters
Returns: object reference or nil
]]
function actor.spawn(archetype_id, pos, data)
    if type(archetype_id) ~= "string" or archetype_id == "" then
        return nil
    end

    local archetype = actor.data and actor.data.archetypes and actor.data.archetypes[archetype_id]
    if type(archetype) ~= "table" then
        return nil
    end

    local position = nil
    local overrides = {}
    if type(pos) == "table" and type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number" then
        position = pos
        if type(data) == "table" then
            overrides = data
        end
    elseif type(pos) == "table" then
        overrides = pos
        if type(overrides.position) == "table" then
            position = overrides.position
        end
    end

    local clone = function(value)
        if type(value) ~= "table" then
            return value
        end
        local copy = {}
        for key, item in pairs(value) do
            if type(item) == "table" then
                copy[key] = clone(item)
            else
                copy[key] = item
            end
        end
        return copy
    end

    local actor_def = clone(archetype)
    actor_def.archetype = archetype_id
    actor_def.position = position or actor_def.position or { x = 0, y = 0, z = 0 }
    actor_def.state = overrides.state or actor_def.state or "idle"
    actor_def.faction = overrides.faction or actor_def.faction or "neutral"
    actor_def.behavior = overrides.behavior or actor_def.behavior or "passive"
    actor_def.inventory = overrides.inventory or actor_def.inventory or {}
    actor_def.stats = overrides.stats or actor_def.stats or {}
    actor_def.display_name = overrides.display_name or actor_def.display_name or archetype_id
    actor_def.custom = overrides.custom or actor_def.custom

    if state.registry and state.registry["spawn"] then
        local result = state.registry["spawn"](archetype_id, actor_def.position, actor_def)
        if result and type(result) == "table" then
            result.hp = result.hp or archetype.health or 100
            result.max_hp = result.max_hp or result.hp
            if core_stats and type(core_stats.init_actor) == "function" then
                core_stats.init_actor(result)
                if type(archetype.damage) == "number" then
                    result.stats.attributes = result.stats.attributes or {}
                    result.stats.attributes.damage = result.stats.attributes.damage or archetype.damage
                end
                if type(archetype.speed) == "number" then
                    result.stats.attributes = result.stats.attributes or {}
                    result.stats.attributes.speed = result.stats.attributes.speed or archetype.speed
                end
                if type(archetype.armor) == "number" then
                    result.stats.attributes = result.stats.attributes or {}
                    result.stats.attributes.armor = result.stats.attributes.armor or archetype.armor
                end
            end
        end
        return result
    end
    return nil
end

--[[
Despawn an actor, removing it from the world.
]]
function actor.despawn(...)
    if state.registry and state.registry["despawn"] then
        return state.registry["despawn"](...)
    end
    return nil
end

--[[
Check if an object is a valid actor.
Returns: true if the object is an actor, false otherwise
]]
function actor.is_actor(...)
    if state.registry and state.registry["is_actor"] then
        return state.registry["is_actor"](...)
    end
    return nil
end

--[[
Get an actor's current faction ID.
]]
function actor.get_faction(...)
    if state.registry and state.registry["get_faction"] then
        return state.registry["get_faction"](...)
    end
    return nil
end

--[[
Set an actor's faction.
faction_id: string (from core_factions)
]]
function actor.set_faction(...)
    if state.registry and state.registry["set_faction"] then
        return state.registry["set_faction"](...)
    end
    return nil
end

--[[
Get an actor's stat sheet.
Returns: reference to actor.stats table
]]
function actor.get_stats(...)
    if state.registry and state.registry["get_stats"] then
        return state.registry["get_stats"](...)
    end
    return nil
end

--[[
Get an actor's inventory object.
Returns: reference to actor's inventory table
]]
function actor.get_inventory(...)
    if state.registry and state.registry["get_inventory"] then
        return state.registry["get_inventory"](...)
    end
    return nil
end

--[[
Get an actor's current behavior tree.
Returns: behavior tree definition table
]]
function actor.get_behavior(...)
    if state.registry and state.registry["get_behavior"] then
        return state.registry["get_behavior"](...)
    end
    return nil
end

--[[
Set an actor's state (Idle, Alert, Combat, Flee, etc).
state_id: string
]]
function actor.set_state(...)
    if state.registry and state.registry["set_state"] then
        return state.registry["set_state"](...)
    end
    return nil
end

--[[
Get an actor's current state ID.
Returns: string
]]
function actor.get_state(...)
    if state.registry and state.registry["get_state"] then
        return state.registry["get_state"](...)
    end
    return nil
end

--[[
Update an actor's state and behavior (called each frame).
dtime: elapsed time since last update (seconds)
]]
function actor.update(...)
    if state.registry and state.registry["update"] then
        return state.registry["update"](...)
    end
    return nil
end

--[[
Execute an actor's behavior tree one cycle.
dtime: elapsed time since last update (seconds)
Returns: result of behavior tree execution
]]
function actor.run_behavior(...)
    if state.registry and state.registry["run_behavior"] then
        return state.registry["run_behavior"](...)
    end
    return nil
end

--[[
Check if an actor can see a target using line-of-sight and vision cone.
target: object reference or position
Returns: true if target is visible, false otherwise
]]
function actor.can_see(...)
    if state.registry and state.registry["can_see"] then
        return state.registry["can_see"](...)
    end
    return nil
end

--[[
Check if an actor can hear a target within hearing range.
target: object reference or position
Returns: true if target is audible, false otherwise
]]
function actor.can_hear(...)
    if state.registry and state.registry["can_hear"] then
        return state.registry["can_hear"](...)
    end
    return nil
end

--[[
Get all potential targets within perception range.
radius: search radius in nodes (optional, uses perception stats if omitted)
Returns: table of object references
]]
function actor.get_targets_in_range(...)
    if state.registry and state.registry["get_targets_in_range"] then
        return state.registry["get_targets_in_range"](...)
    end
    return nil
end

--[[
Get an actor's current alertness level (0-1 spectrum).
Returns: number 0.0 to 1.0
]]
function actor.get_alertness(...)
    if state.registry and state.registry["get_alertness"] then
        return state.registry["get_alertness"](...)
    end
    return nil
end

--[[
Move an actor toward a position.
pos: table with x, y, z coordinates
]]
function actor.move_towards(...)
    if state.registry and state.registry["move_towards"] then
        return state.registry["move_towards"](...)
    end
    return nil
end

--[[
Move an actor away from a position (retreat).
pos: table with x, y, z coordinates
]]
function actor.move_away(...)
    if state.registry and state.registry["move_away"] then
        return state.registry["move_away"](...)
    end
    return nil
end

--[[
Stop an actor's current movement.
]]
function actor.stop(...)
    if state.registry and state.registry["stop"] then
        return state.registry["stop"](...)
    end
    return nil
end

--[[
Pathfind to a destination and move along the path.
pos: target position (x, y, z table)
]]
function actor.pathfind(...)
    if state.registry and state.registry["pathfind"] then
        return state.registry["pathfind"](...)
    end
    return nil
end

--[[
Assign an objective to an actor.
actor: actor reference or id
objective: objective table
Returns: true if accepted, false otherwise
]]
function actor.assign_objective(...)
    if state.registry and state.registry["assign_objective"] then
        return state.registry["assign_objective"](...)
    end
    return false
end

--- Alias for `assign_objective`.
-- @param actor object reference or id
-- @param objective table
-- @return boolean
function actor.receive_objective(...)
    return actor.assign_objective(...)
end

--[[
Evaluate whether an actor can accept an objective.
actor: actor reference or id
objective: objective table
Returns: true if objective is acceptable, false otherwise
]]
function actor.evaluate_objective(...)
    if state.registry and state.registry["evaluate_objective"] then
        return state.registry["evaluate_objective"](...)
    end
    return false
end

--[[
Report objective progress back to quest systems.
actor: actor reference or id
objective_id: string
status: string
Returns: true if report accepted
]]
function actor.report_progress(...)
    if state.registry and state.registry["report_progress"] then
        return state.registry["report_progress"](...)
    end
    return false
end

--[[
Join the actor to a squad.
actor: actor reference or id
squad_id: string
Returns: true if squad joined
]]
function actor.join_squad(...)
    if state.registry and state.registry["join_squad"] then
        return state.registry["join_squad"](...)
    end
    return false
end

--[[
Remove the actor from a squad.
actor: actor reference or id
Returns: true if squad left
]]
function actor.leave_squad(...)
    if state.registry and state.registry["leave_squad"] then
        return state.registry["leave_squad"](...)
    end
    return false
end

--[[
Broadcast an objective to actors with the same faction or region.
faction_id: string
objective: objective table
Returns: number of actors notified
]]
function actor.broadcast_objective(...)
    if state.registry and state.registry["broadcast_objective"] then
        return state.registry["broadcast_objective"](...)
    end
    return 0
end

--[[
Choose an optimal combat target from visible/audible enemies.
Returns: object reference to target, or nil if no targets available
]]
function actor.choose_target(...)
    if state.registry and state.registry["choose_target"] then
        return state.registry["choose_target"](...)
    end
    return nil
end

--[[
Evaluate whether an actor should flee from combat.
Returns: true if should flee, false otherwise
]]
function actor.should_flee(...)
    if state.registry and state.registry["should_flee"] then
        return state.registry["should_flee"](...)
    end
    return nil
end

--[[
Evaluate whether an actor should reload their weapon.
Returns: true if should reload, false otherwise
]]
function actor.should_reload(...)
    if state.registry and state.registry["should_reload"] then
        return state.registry["should_reload"](...)
    end
    return nil
end

--[[
Evaluate whether an actor should switch to a different weapon.
Returns: true if should switch, false otherwise
]]
function actor.should_switch_weapon(...)
    if state.registry and state.registry["should_switch_weapon"] then
        return state.registry["should_switch_weapon"](...)
    end
    return nil
end

--[[
Kill an actor, entering death state and cleanup.
]]
function actor.kill(...)
    if state.registry and state.registry["kill"] then
        return state.registry["kill"](...)
    end
    return nil
end

--[[
Respawn an actor at its spawn point.
]]
function actor.respawn(...)
    if state.registry and state.registry["respawn"] then
        return state.registry["respawn"](...)
    end
    return nil
end

--[[
Check if an actor is currently dead.
Returns: true if dead, false if alive
]]
function actor.is_dead(...)
    if state.registry and state.registry["is_dead"] then
        return state.registry["is_dead"](...)
    end
    return nil
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    actor.spawn_actor = dofile(modpath .. "/debug/spawn_actor.lua")
    actor.ai_visualizer = dofile(modpath .. "/debug/ai_visualizer.lua")
end

return actor
