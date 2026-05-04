-- core_dimension/api.lua
-- Public API for dimension management, teleportation, and dimensional rules.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local dimension = {}
dimension.data = {}

local state = {
    registry = {},
    actor_state = {},
}

dimension._state = state

dimension.dimension_loader = dofile(modpath .. "/internal/dimension_loader.lua")
dimension.teleport = dofile(modpath .. "/internal/teleport.lua")
dimension.rulesets = dofile(modpath .. "/internal/rulesets.lua")

--- Registers a new dimension in the dimension registry.
-- @param dimension_id string: Unique identifier for the dimension
-- @param dimension_data table: Dimension configuration data containing name, rules, spawn_point, etc.
-- @return boolean: True if registration successful, false if dimension already exists
function dimension.register(dimension_id, dimension_data)
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    assert(type(dimension_data) == "table", "dimension_data must be a table")
    if state.registry and state.registry["register"] then
        return state.registry["register"](dimension_id, dimension_data)
    end
    return false
end

--- Retrieves dimension data by ID.
-- @param dimension_id string: The dimension identifier to look up
-- @return table|nil: Dimension data table if found, nil otherwise
function dimension.get(dimension_id)
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    if state.registry and state.registry["get"] then
        return state.registry["get"](dimension_id)
    end
    return nil
end

--- Returns all registered dimensions.
-- @return table: Table of all dimension data keyed by dimension_id
function dimension.all()
    if state.registry and state.registry["all"] then
        return state.registry["all"]()
    end
    return {}
end

--- Teleports an actor to a position in a specific dimension.
-- @param actor ObjectRef: The actor to teleport
-- @param dimension_id string: Target dimension ID
-- @param pos table: Target position {x, y, z}
-- @return boolean: True if teleport successful
function dimension.teleport(actor, dimension_id, pos)
    assert(actor and (actor:is_player() or actor:get_luaentity()), "actor must be a valid ObjectRef")
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    assert(type(pos) == "table", "pos must be a table")
    assert(type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number", "pos must have x, y, z number fields")
    if state.registry and state.registry["teleport"] then
        return state.registry["teleport"](actor, dimension_id, pos)
    end
    return false
end

--- Teleports an actor to a safe position in a specific dimension.
-- @param actor ObjectRef: The actor to teleport
-- @param dimension_id string: Target dimension ID
-- @param pos table: Preferred target position {x, y, z}
-- @return boolean: True if safe teleport successful
function dimension.teleport_safe(actor, dimension_id, pos)
    assert(actor and (actor:is_player() or actor:get_luaentity()), "actor must be a valid ObjectRef")
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    assert(type(pos) == "table", "pos must be a table")
    assert(type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number", "pos must have x, y, z number fields")
    if state.registry and state.registry["teleport_safe"] then
        return state.registry["teleport_safe"](actor, dimension_id, pos)
    end
    return false
end

--- Checks if an actor can enter a dimension.
-- @param actor_id string: The actor identifier
-- @param dimension_id string: The dimension identifier
-- @return boolean: True if actor can enter the dimension
function dimension.can_enter(actor_id, dimension_id)
    assert(type(actor_id) == "string", "actor_id must be a string")
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    if state.registry and state.registry["can_enter"] then
        return state.registry["can_enter"](actor_id, dimension_id)
    end
    return false
end

--- Checks if an actor can exit a dimension.
-- @param actor_id string: The actor identifier
-- @param dimension_id string: The dimension identifier
-- @return boolean: True if actor can exit the dimension
function dimension.can_exit(actor_id, dimension_id)
    assert(type(actor_id) == "string", "actor_id must be a string")
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    if state.registry and state.registry["can_exit"] then
        return state.registry["can_exit"](actor_id, dimension_id)
    end
    return false
end

--- Applies dimensional rules to an actor.
-- @param actor ObjectRef: The actor to apply rules to
-- @param dimension_id string: The dimension identifier
-- @return boolean: True if rules applied successfully
function dimension.apply_rules(actor, dimension_id)
    assert(actor and (actor:is_player() or actor:get_luaentity()), "actor must be a valid ObjectRef")
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    if state.registry and state.registry["apply_rules"] then
        return state.registry["apply_rules"](actor, dimension_id)
    end
    return false
end

--- Gets the rules for a dimension.
-- @param dimension_id string: The dimension identifier
-- @return table|nil: Dimension rules table if found, nil otherwise
function dimension.get_rules(dimension_id)
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    if state.registry and state.registry["get_rules"] then
        return state.registry["get_rules"](dimension_id)
    end
    return nil
end

--- Updates the rules for a dimension.
-- @param dimension_id string: The dimension identifier
-- @param rules table: New rules configuration
-- @return boolean: True if rules updated successfully
function dimension.update_rules(dimension_id, rules)
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    assert(type(rules) == "table", "rules must be a table")
    if state.registry and state.registry["update_rules"] then
        return state.registry["update_rules"](dimension_id, rules)
    end
    return false
end

--- Gets the current dimension an actor is in.
-- @param actor ObjectRef: The actor to check
-- @return string|nil: Current dimension ID, or nil if not in any dimension
function dimension.get_current(actor)
    assert(actor and (actor:is_player() or actor:get_luaentity()), "actor must be a valid ObjectRef")
    if state.registry and state.registry["get_current"] then
        return state.registry["get_current"](actor)
    end
    return nil
end

--- Sets the current dimension for an actor (internal use).
-- @param actor ObjectRef: The actor to set dimension for
-- @param dimension_id string: The dimension identifier
-- @return boolean: True if dimension set successfully
function dimension.set_current(actor, dimension_id)
    assert(actor and (actor:is_player() or actor:get_luaentity()), "actor must be a valid ObjectRef")
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    if state.registry and state.registry["set_current"] then
        return state.registry["set_current"](actor, dimension_id)
    end
    return false
end

--- Gets the spawn point for a dimension.
-- @param dimension_id string: The dimension identifier
-- @return table|nil: Spawn position {x, y, z} if found, nil otherwise
function dimension.get_spawn_point(dimension_id)
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    if state.registry and state.registry["get_spawn_point"] then
        return state.registry["get_spawn_point"](dimension_id)
    end
    return nil
end

--- Called when an actor enters a dimension.
-- @param actor ObjectRef: The actor entering
-- @param dimension_id string: The dimension being entered
-- @return boolean: True if enter event handled successfully
function dimension.on_enter(actor, dimension_id)
    assert(actor and (actor:is_player() or actor:get_luaentity()), "actor must be a valid ObjectRef")
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    if state.registry and state.registry["on_enter"] then
        return state.registry["on_enter"](actor, dimension_id)
    end
    return false
end

--- Called when an actor exits a dimension.
-- @param actor ObjectRef: The actor exiting
-- @param dimension_id string: The dimension being exited
-- @return boolean: True if exit event handled successfully
function dimension.on_exit(actor, dimension_id)
    assert(actor and (actor:is_player() or actor:get_luaentity()), "actor must be a valid ObjectRef")
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    if state.registry and state.registry["on_exit"] then
        return state.registry["on_exit"](actor, dimension_id)
    end
    return false
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    dimension.dimension_portal = dofile(modpath .. "/debug/dimension_portal.lua")
    dimension.dimension_inspector = dofile(modpath .. "/debug/dimension_inspector.lua")
end

return dimension
