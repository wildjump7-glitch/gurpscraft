-- core_physics/api.lua
-- Public API for physics simulation, movement, fall damage, and environmental forces.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local movement = dofile(modpath .. "/internal/movement.lua")
local fall_damage = dofile(modpath .. "/internal/fall_damage.lua")
local knockback = dofile(modpath .. "/internal/knockback.lua")
local climbing = dofile(modpath .. "/internal/climbing.lua")
local swimming = dofile(modpath .. "/internal/swimming.lua")
local stamina_drain = dofile(modpath .. "/internal/stamina_drain.lua")

--- Applies wind force to an actor.
-- @param actor ObjectRef: The actor to apply wind to
-- @param force table: Force vector {x, y, z}
-- @return boolean: True if wind applied successfully
local function apply_wind(actor, force)
    assert(actor and (actor:is_player() or actor:get_luaentity()), "actor must be a valid ObjectRef")
    assert(type(force) == "table", "force must be a table")
    assert(type(force.x) == "number" and type(force.y) == "number" and type(force.z) == "number", "force must have x, y, z number fields")
    if actor and actor.add_velocity and force then
        actor:add_velocity(force)
        return true
    end
    return false
end

--- Applies water current force to an actor.
-- @param actor ObjectRef: The actor to apply current to
-- @param force table: Force vector {x, y, z}
-- @return boolean: True if current applied successfully
local function apply_current(actor, force)
    return apply_wind(actor, force)
end

--- Gets the gravity value for an actor.
-- @param actor ObjectRef: The actor to get gravity for (currently unused)
-- @return number: Gravity multiplier (default 1.0)
local function get_gravity(actor)
    local _ = actor
    return (core_physics.gravity and core_physics.gravity.default) or 1.0
end

return {
    --- Gets the movement speed for an actor.
    -- @param actor_id string: The actor identifier
    -- @return number: Movement speed in nodes per second
    get_move_speed = movement.get_move_speed,

    --- Applies movement to an actor based on input.
    -- @param actor ObjectRef: The actor to move
    -- @param direction table: Movement direction vector {x, y, z}
    -- @param speed number: Movement speed multiplier
    -- @return boolean: True if movement applied successfully
    apply_movement = movement.apply_movement,

    --- Gets the jump height for an actor.
    -- @param actor_id string: The actor identifier
    -- @return number: Jump height in nodes
    get_jump_height = movement.get_jump_height,

    --- Applies jump force to an actor.
    -- @param actor ObjectRef: The actor to make jump
    -- @return boolean: True if jump applied successfully
    apply_jump = movement.apply_jump,

    --- Applies fall damage to an actor based on fall distance.
    -- @param actor ObjectRef: The actor that fell
    -- @param distance number: Fall distance in nodes
    -- @return boolean: True if damage applied
    apply_fall_damage = fall_damage.apply_fall_damage,

    --- Calculates fall damage for a given distance.
    -- @param distance number: Fall distance in nodes
    -- @param actor_id string: The actor identifier (for damage calculation modifiers)
    -- @return number: Damage amount
    get_fall_damage = fall_damage.get_fall_damage,

    --- Applies knockback force to an actor.
    -- @param actor ObjectRef: The actor to knock back
    -- @param direction table: Knockback direction vector {x, y, z}
    -- @param force number: Knockback force multiplier
    -- @return boolean: True if knockback applied successfully
    apply_knockback = knockback.apply_knockback,

    --- Gets the knockback resistance for an actor.
    -- @param actor_id string: The actor identifier
    -- @return number: Knockback resistance multiplier (0-1, where 1 = full resistance)
    get_knockback_resistance = knockback.get_knockback_resistance,

    --- Checks if an actor is currently climbing.
    -- @param actor ObjectRef: The actor to check
    -- @return boolean: True if climbing
    is_climbing = climbing.is_climbing,

    --- Applies climbing movement to an actor.
    -- @param actor ObjectRef: The actor climbing
    -- @param direction table: Climb direction vector {x, y, z}
    -- @return boolean: True if climbing movement applied successfully
    apply_climb_movement = climbing.apply_climb_movement,

    --- Checks if an actor is currently swimming.
    -- @param actor ObjectRef: The actor to check
    -- @return boolean: True if swimming
    is_swimming = swimming.is_swimming,

    --- Applies swimming movement to an actor.
    -- @param actor ObjectRef: The actor swimming
    -- @param direction table: Swim direction vector {x, y, z}
    -- @return boolean: True if swimming movement applied successfully
    apply_swim_movement = swimming.apply_swim_movement,

    --- Applies drowning damage to an actor.
    -- @param actor ObjectRef: The actor drowning
    -- @param time_underwater number: Time spent underwater in seconds
    -- @return boolean: True if drowning damage applied
    apply_drowning = swimming.apply_drowning,

    --- Gets the current stamina level for an actor.
    -- @param actor_id string: The actor identifier
    -- @return number: Current stamina (0-100)
    get_stamina = stamina_drain.get_stamina,

    --- Modifies an actor's stamina by a delta value.
    -- @param actor_id string: The actor identifier
    -- @param delta number: Amount to modify stamina by
    -- @return boolean: True if stamina modified successfully
    modify_stamina = stamina_drain.modify_stamina,

    --- Sets an actor's stamina to a specific value.
    -- @param actor_id string: The actor identifier
    -- @param stamina number: New stamina value (0-100)
    -- @return boolean: True if stamina set successfully
    set_stamina = stamina_drain.set_stamina,

    --- Applies stamina drain based on activity.
    -- @param actor_id string: The actor identifier
    -- @param activity string: Activity type ("running", "jumping", "climbing", etc.)
    -- @param intensity number: Activity intensity multiplier
    -- @return boolean: True if stamina drained
    apply_stamina_drain = stamina_drain.apply_stamina_drain,

    --- Applies stamina regeneration.
    -- @param actor_id string: The actor identifier
    -- @param rate number: Regeneration rate multiplier
    -- @return boolean: True if stamina regenerated
    apply_stamina_regen = stamina_drain.apply_stamina_regen,

    --- Applies wind force to an actor.
    -- @param actor ObjectRef: The actor to apply wind to
    -- @param force table: Wind force vector {x, y, z}
    -- @return boolean: True if wind applied successfully
    apply_wind = apply_wind,

    --- Applies water current force to an actor.
    -- @param actor ObjectRef: The actor to apply current to
    -- @param force table: Current force vector {x, y, z}
    -- @return boolean: True if current applied successfully
    apply_current = apply_current,

    --- Gets the gravity value for an actor.
    -- @param actor ObjectRef: The actor to get gravity for
    -- @return number: Gravity multiplier
    get_gravity = get_gravity,
}