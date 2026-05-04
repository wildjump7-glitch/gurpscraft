-- core_magic/api.lua
-- Public API for magic system, spells, mana, rituals, and enchantments.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local magic = {}
magic.data = {}

local state = {
    registry = {},
    actor_state = {},
}

magic._state = state

magic.casting = dofile(modpath .. "/internal/casting.lua")
magic.mana = dofile(modpath .. "/internal/mana.lua")
magic.rituals = dofile(modpath .. "/internal/rituals.lua")
magic.effects = dofile(modpath .. "/internal/effects.lua")
magic.enchantments = dofile(modpath .. "/internal/enchantments.lua")

--- Registers a new spell in the magic system.
-- @param spell_id string: Unique identifier for the spell
-- @param spell_data table: Spell configuration data containing cost, effects, casting time, etc.
-- @return boolean: True if registration successful, false if spell already exists
function magic.register_spell(spell_id, spell_data)
    assert(type(spell_id) == "string", "spell_id must be a string")
    assert(type(spell_data) == "table", "spell_data must be a table")
    if state.registry and state.registry["register_spell"] then
        return state.registry["register_spell"](spell_id, spell_data)
    end
    return false
end

--- Retrieves spell data by ID.
-- @param spell_id string: The spell identifier to look up
-- @return table|nil: Spell data table if found, nil otherwise
function magic.get_spell(spell_id)
    assert(type(spell_id) == "string", "spell_id must be a string")
    if state.registry and state.registry["get_spell"] then
        return state.registry["get_spell"](spell_id)
    end
    return nil
end

--- Returns all registered spells.
-- @return table: Table of all spell data keyed by spell_id
function magic.all_spells()
    if state.registry and state.registry["all_spells"] then
        return state.registry["all_spells"]()
    end
    return {}
end

--- Attempts to cast a spell for an actor.
-- @param actor table: The actor casting the spell
-- @param spell_id string: The spell identifier to cast
-- @param target table: Target information (position, entity, etc.) - optional
-- @return boolean: True if casting started successfully
function magic.cast(actor, spell_id, target)
    assert(type(actor) == "table", "actor must be a table")
    assert(type(spell_id) == "string", "spell_id must be a string")
    if target then assert(type(target) == "table", "target must be a table") end
    if state.registry and state.registry["cast"] then
        return state.registry["cast"](actor, spell_id, target)
    end
    return false
end

--- Checks if an actor can cast a specific spell.
-- @param actor table: The actor object attempting to cast
-- @param spell_id string: The spell identifier to check
-- @return boolean: True if actor can cast the spell
function magic.can_cast(actor, spell_id)
    assert(type(actor) == "table", "actor must be a table")
    assert(type(spell_id) == "string", "spell_id must be a string")
    if state.registry and state.registry["can_cast"] then
        return state.registry["can_cast"](actor, spell_id)
    end
    return false
end

--- Gets the mana cost to cast a spell.
-- @param spell_id string: The spell identifier
-- @return number: Mana cost (0 if spell not found or free)
function magic.get_cast_cost(spell_id)
    assert(type(spell_id) == "string", "spell_id must be a string")
    if state.registry and state.registry["get_cast_cost"] then
        return state.registry["get_cast_cost"](spell_id)
    end
    return 0
end

--- Interrupts any spell casting for an actor.
-- @param actor table: The actor to interrupt
-- @return boolean: True if casting was interrupted
function magic.interrupt(actor)
    assert(type(actor) == "table", "actor must be a table")
    if state.registry and state.registry["interrupt"] then
        return state.registry["interrupt"](actor)
    end
    return false
end

--- Gets the current mana level for an actor.
-- @param actor table: The actor object to query
-- @return number: Current mana (0-100)
function magic.get_mana(actor)
    assert(type(actor) == "table", "actor must be a table")
    if state.registry and state.registry["get_mana"] then
        return state.registry["get_mana"](actor)
    end
    return 0
end

--- Sets an actor's mana to a specific value.
-- @param actor table: The actor object
-- @param mana number: New mana value (0-100)
-- @return boolean: True if mana set successfully
function magic.set_mana(actor, mana)
    assert(type(actor) == "table", "actor must be a table")
    assert(type(mana) == "number", "mana must be a number")
    if state.registry and state.registry["set_mana"] then
        return state.registry["set_mana"](actor, mana)
    end
    return false
end

--- Modifies an actor's mana by a delta value.
-- @param actor table: The actor object
-- @param delta number: Amount to modify mana by
-- @return boolean: True if mana modified successfully
function magic.modify_mana(actor, delta)
    assert(type(actor) == "table", "actor must be a table")
    assert(type(delta) == "number", "delta must be a number")
    if state.registry and state.registry["modify_mana"] then
        return state.registry["modify_mana"](actor, delta)
    end
    return false
end

--- Gets the mana regeneration rate for an actor.
-- @param actor table: The actor object
-- @return number: Mana regeneration rate per second
function magic.get_mana_regen(actor)
    assert(type(actor) == "table", "actor must be a table")
    if state.registry and state.registry["get_mana_regen"] then
        return state.registry["get_mana_regen"](actor)
    end
    return 0
end

--- Applies mana regeneration to an actor.
-- @param actor table: The actor object
-- @param dt number: Time delta in seconds
-- @return boolean: True if regeneration applied
function magic.apply_mana_regen(actor, dt)
    assert(type(actor) == "table", "actor must be a table")
    assert(type(dt) == "number", "dt must be a number")
    if state.registry and state.registry["apply_mana_regen"] then
        return state.registry["apply_mana_regen"](actor, dt)
    end
    return false
end

--- Starts a ritual for an actor.
-- @param actor table: The actor object starting the ritual
-- @param ritual_id string: The ritual identifier
-- @param position table: Position to perform the ritual {x, y, z}
-- @return string|boolean: Ritual instance id if started successfully, false otherwise
function magic.start_ritual(actor, ritual_id, position)
    assert(type(actor) == "table", "actor must be a table")
    assert(type(ritual_id) == "string", "ritual_id must be a string")
    assert(type(position) == "table", "position must be a table")
    assert(type(position.x) == "number" and type(position.y) == "number" and type(position.z) == "number", "position must have x, y, z number fields")
    if state.registry and state.registry["start_ritual"] then
        return state.registry["start_ritual"](actor, ritual_id, position)
    end
    return false
end

--- Updates an ongoing ritual.
-- @param ritual_instance_id string: The ritual instance identifier
-- @param dt number: Time delta in seconds
-- @return boolean: True if ritual updated successfully
function magic.update_ritual(ritual_instance_id, dt)
    assert(type(ritual_instance_id) == "string", "ritual_instance_id must be a string")
    assert(type(dt) == "number", "dt must be a number")
    if state.registry and state.registry["update_ritual"] then
        return state.registry["update_ritual"](ritual_instance_id, dt)
    end
    return false
end

--- Finishes a completed ritual.
-- @param ritual_instance_id string: The ritual instance identifier
-- @return boolean: True if ritual finished successfully
function magic.finish_ritual(ritual_instance_id)
    assert(type(ritual_instance_id) == "string", "ritual_instance_id must be a string")
    if state.registry and state.registry["finish_ritual"] then
        return state.registry["finish_ritual"](ritual_instance_id)
    end
    return false
end

--- Aborts an ongoing ritual.
-- @param ritual_instance_id string: The ritual instance identifier
-- @return boolean: True if ritual aborted successfully
function magic.abort_ritual(ritual_instance_id)
    assert(type(ritual_instance_id) == "string", "ritual_instance_id must be a string")
    if state.registry and state.registry["abort_ritual"] then
        return state.registry["abort_ritual"](ritual_instance_id)
    end
    return false
end

--- Applies an enchantment to an item.
-- @param itemstack table: The item to enchant
-- @param enchantment_id string: The enchantment identifier
-- @param level number: Enchantment level
-- @return table: The enchanted itemstack
function magic.apply_enchantment(itemstack, enchantment_id, level)
    assert(type(itemstack) == "table", "itemstack must be a table")
    assert(type(enchantment_id) == "string", "enchantment_id must be a string")
    assert(type(level) == "number", "level must be a number")
    if state.registry and state.registry["apply_enchantment"] then
        return state.registry["apply_enchantment"](itemstack, enchantment_id, level)
    end
    return itemstack
end

--- Removes an enchantment from an item.
-- @param itemstack table: The item to disenchant
-- @param enchantment_id string: The enchantment identifier to remove
-- @return table: The disenchanted itemstack
function magic.remove_enchantment(itemstack, enchantment_id)
    assert(type(itemstack) == "table", "itemstack must be a table")
    assert(type(enchantment_id) == "string", "enchantment_id must be a string")
    if state.registry and state.registry["remove_enchantment"] then
        return state.registry["remove_enchantment"](itemstack, enchantment_id)
    end
    return itemstack
end

--- Gets all enchantments on an item.
-- @param itemstack table: The item to check
-- @return table: Table of enchantments keyed by enchantment_id with level values
function magic.get_enchantments(itemstack)
    assert(type(itemstack) == "table", "itemstack must be a table")
    if state.registry and state.registry["get_enchantments"] then
        return state.registry["get_enchantments"](itemstack)
    end
    return {}
end

--- Applies a spell effect to a target.
-- @param effect_id string: The effect identifier
-- @param target table: Target information (position, entity, etc.)
-- @param caster table: The caster of the effect
-- @param power number: Effect power multiplier
-- @return boolean: True if effect applied successfully
function magic.apply_spell_effect(effect_id, target, caster, power)
    assert(type(effect_id) == "string", "effect_id must be a string")
    assert(type(target) == "table", "target must be a table")
    assert(type(caster) == "table", "caster must be a table")
    assert(type(power) == "number", "power must be a number")
    if state.registry and state.registry["apply_spell_effect"] then
        return state.registry["apply_spell_effect"](effect_id, target, caster, power)
    end
    return false
end

--- Applies an area effect at a position.
-- @param effect_id string: The effect identifier
-- @param position table: Center position {x, y, z}
-- @param radius number: Effect radius
-- @param caster table: The caster of the effect
-- @param power number: Effect power multiplier
-- @return boolean: True if area effect applied successfully
function magic.apply_area_effect(effect_id, position, radius, caster, power)
    assert(type(effect_id) == "string", "effect_id must be a string")
    assert(type(position) == "table", "position must be a table")
    assert(type(position.x) == "number" and type(position.y) == "number" and type(position.z) == "number", "position must have x, y, z number fields")
    assert(type(radius) == "number", "radius must be a number")
    assert(type(caster) == "table", "caster must be a table")
    assert(type(power) == "number", "power must be a number")
    if state.registry and state.registry["apply_area_effect"] then
        return state.registry["apply_area_effect"](effect_id, position, radius, caster, power)
    end
    return false
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    magic.cast_spell = dofile(modpath .. "/debug/cast_spell.lua")
    magic.ritual_test = dofile(modpath .. "/debug/ritual_test.lua")
    magic.enchant_test = dofile(modpath .. "/debug/enchant_test.lua")
end

return magic
