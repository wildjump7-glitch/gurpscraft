-- core_factions/api.lua
-- Public API for faction management, reputation, relations, and territory.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local factions = {}
factions.data = {}

local state = {
    registry = {},
    actor_state = {},
}

factions._state = state

factions.registry = dofile(modpath .. "/internal/registry.lua")
factions.reputation = dofile(modpath .. "/internal/reputation.lua")
factions.relations = dofile(modpath .. "/internal/relations.lua")
factions.hostility = dofile(modpath .. "/internal/hostility.lua")
factions.territory = dofile(modpath .. "/internal/territory.lua")

--- Registers a new faction in the faction registry.
-- @param faction_id string: Unique identifier for the faction
-- @param faction_data table: Faction configuration data containing name, description, color, etc.
-- @return boolean: True if registration successful, false if faction already exists
function factions.register(faction_id, faction_data)
    assert(type(faction_id) == "string", "faction_id must be a string")
    assert(type(faction_data) == "table", "faction_data must be a table")
    if state.registry and state.registry["register"] then
        return state.registry["register"](faction_id, faction_data)
    end
    return nil
end

--- Retrieves faction data by ID.
-- @param faction_id string: The faction identifier to look up
-- @return table|nil: Faction data table if found, nil otherwise
function factions.get(faction_id)
    assert(type(faction_id) == "string", "faction_id must be a string")
    if state.registry and state.registry["get"] then
        return state.registry["get"](faction_id)
    end
    return nil
end

--- Returns all registered factions.
-- @return table: Table of all faction data keyed by faction_id
function factions.all()
    if state.registry and state.registry["all"] then
        return state.registry["all"]()
    end
    return {}
end

--- Checks if a faction exists in the registry.
-- @param faction_id string: The faction identifier to check
-- @return boolean: True if faction exists, false otherwise
function factions.exists(faction_id)
    assert(type(faction_id) == "string", "faction_id must be a string")
    if state.registry and state.registry["exists"] then
        return state.registry["exists"](faction_id)
    end
    return false
end

--- Gets the diplomatic relation between two factions.
-- @param faction_a string: First faction ID
-- @param faction_b string: Second faction ID
-- @return number: Relation value (-100 to 100, negative = hostile, positive = friendly)
function factions.get_relation(faction_a, faction_b)
    assert(type(faction_a) == "string", "faction_a must be a string")
    assert(type(faction_b) == "string", "faction_b must be a string")
    if state.registry and state.registry["get_relation"] then
        return state.registry["get_relation"](faction_a, faction_b)
    end
    return 0
end

--- Sets the diplomatic relation between two factions.
-- @param faction_a string: First faction ID
-- @param faction_b string: Second faction ID
-- @param relation number: Relation value (-100 to 100)
-- @return boolean: True if successful
function factions.set_relation(faction_a, faction_b, relation)
    assert(type(faction_a) == "string", "faction_a must be a string")
    assert(type(faction_b) == "string", "faction_b must be a string")
    assert(type(relation) == "number", "relation must be a number")
    if state.registry and state.registry["set_relation"] then
        return state.registry["set_relation"](faction_a, faction_b, relation)
    end
    return false
end

--- Modifies the diplomatic relation between two factions by a delta value.
-- @param faction_a string: First faction ID
-- @param faction_b string: Second faction ID
-- @param delta number: Amount to modify relation by
-- @return boolean: True if successful
function factions.modify_relation(faction_a, faction_b, delta)
    assert(type(faction_a) == "string", "faction_a must be a string")
    assert(type(faction_b) == "string", "faction_b must be a string")
    assert(type(delta) == "number", "delta must be a number")
    if state.registry and state.registry["modify_relation"] then
        return state.registry["modify_relation"](faction_a, faction_b, delta)
    end
    return false
end

--- Gets the current diplomatic stance between two factions.
-- @param faction_a string: First faction ID
-- @param faction_b string: Second faction ID
-- @return string: Stance ("hostile", "neutral", "friendly", "allied")
function factions.get_stance(faction_a, faction_b)
    assert(type(faction_a) == "string", "faction_a must be a string")
    assert(type(faction_b) == "string", "faction_b must be a string")
    if state.registry and state.registry["get_stance"] then
        return state.registry["get_stance"](faction_a, faction_b)
    end
    return "neutral"
end

--- Gets an actor's reputation with a faction.
-- @param actor_id string: The actor identifier
-- @param faction_id string: The faction identifier
-- @return number: Reputation value (-100 to 100)
function factions.get_reputation(actor_id, faction_id)
    assert(type(actor_id) == "string", "actor_id must be a string")
    assert(type(faction_id) == "string", "faction_id must be a string")
    if state.registry and state.registry["get_reputation"] then
        return state.registry["get_reputation"](actor_id, faction_id)
    end
    return 0
end

--- Sets an actor's reputation with a faction.
-- @param actor_id string: The actor identifier
-- @param faction_id string: The faction identifier
-- @param reputation number: Reputation value (-100 to 100)
-- @return boolean: True if successful
function factions.set_reputation(actor_id, faction_id, reputation)
    assert(type(actor_id) == "string", "actor_id must be a string")
    assert(type(faction_id) == "string", "faction_id must be a string")
    assert(type(reputation) == "number", "reputation must be a number")
    if state.registry and state.registry["set_reputation"] then
        return state.registry["set_reputation"](actor_id, faction_id, reputation)
    end
    return false
end

--- Modifies an actor's reputation with a faction by a delta value.
-- @param actor_id string: The actor identifier
-- @param faction_id string: The faction identifier
-- @param delta number: Amount to modify reputation by
-- @return boolean: True if successful
function factions.modify_reputation(actor_id, faction_id, delta)
    assert(type(actor_id) == "string", "actor_id must be a string")
    assert(type(faction_id) == "string", "faction_id must be a string")
    assert(type(delta) == "number", "delta must be a number")
    if state.registry and state.registry["modify_reputation"] then
        return state.registry["modify_reputation"](actor_id, faction_id, delta)
    end
    return false
end

--- Gets the reputation-based stance an actor has with a faction.
-- @param actor_id string: The actor identifier
-- @param faction_id string: The faction identifier
-- @return string: Stance ("hated", "disliked", "neutral", "liked", "respected", "venerated")
function factions.get_reputation_stance(actor_id, faction_id)
    assert(type(actor_id) == "string", "actor_id must be a string")
    assert(type(faction_id) == "string", "faction_id must be a string")
    if state.registry and state.registry["get_reputation_stance"] then
        return state.registry["get_reputation_stance"](actor_id, faction_id)
    end
    return "neutral"
end

--- Checks if an actor is hostile toward another actor based on faction relations.
-- @param actor_a string: First actor ID
-- @param actor_b string: Second actor ID
-- @return boolean: True if hostile
function factions.is_hostile(actor_a, actor_b)
    assert(type(actor_a) == "string", "actor_a must be a string")
    assert(type(actor_b) == "string", "actor_b must be a string")
    if state.registry and state.registry["is_hostile"] then
        return state.registry["is_hostile"](actor_a, actor_b)
    end
    return false
end

--- Checks if two factions are hostile toward each other.
-- @param faction_a string: First faction ID
-- @param faction_b string: Second faction ID
-- @return boolean: True if hostile
function factions.is_faction_hostile(faction_a, faction_b)
    assert(type(faction_a) == "string", "faction_a must be a string")
    assert(type(faction_b) == "string", "faction_b must be a string")
    if state.registry and state.registry["is_faction_hostile"] then
        return state.registry["is_faction_hostile"](faction_a, faction_b)
    end
    return false
end

--- Gets the reason for hostility between two actors.
-- @param actor_a string: First actor ID
-- @param actor_b string: Second actor ID
-- @return string: Hostility reason or empty string
function factions.get_hostility_reason(actor_a, actor_b)
    assert(type(actor_a) == "string", "actor_a must be a string")
    assert(type(actor_b) == "string", "actor_b must be a string")
    if state.registry and state.registry["get_hostility_reason"] then
        return state.registry["get_hostility_reason"](actor_a, actor_b)
    end
    return ""
end

--- Performs a reaction roll for an actor toward another actor.
-- @param actor_a string: The actor doing the reaction
-- @param actor_b string: The actor being reacted to
-- @return table: Reaction result with roll, modifiers, and final reaction
function factions.reaction_roll(actor_a, actor_b)
    assert(type(actor_a) == "string", "actor_a must be a string")
    assert(type(actor_b) == "string", "actor_b must be a string")
    if state.registry and state.registry["reaction_roll"] then
        return state.registry["reaction_roll"](actor_a, actor_b)
    end
    return {roll = 0, modifiers = {}, reaction = "neutral"}
end

--- Gets the reaction modifier between two actors.
-- @param actor_a string: First actor ID
-- @param actor_b string: Second actor ID
-- @return number: Reaction modifier value
function factions.get_reaction_modifier(actor_a, actor_b)
    assert(type(actor_a) == "string", "actor_a must be a string")
    assert(type(actor_b) == "string", "actor_b must be a string")
    if state.registry and state.registry["get_reaction_modifier"] then
        return state.registry["get_reaction_modifier"](actor_a, actor_b)
    end
    return 0
end

--- Gets the faction that owns a territory at given coordinates.
-- @param pos table: Position table with x, y, z coordinates
-- @return string|nil: Faction ID if territory is claimed, nil otherwise
function factions.get_territory_owner(pos)
    assert(type(pos) == "table", "pos must be a table")
    assert(type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number", "pos must have x, y, z number fields")
    if state.registry and state.registry["get_territory_owner"] then
        return state.registry["get_territory_owner"](pos)
    end
    return nil
end

--- Sets the faction that owns a territory at given coordinates.
-- @param pos table: Position table with x, y, z coordinates
-- @param faction_id string: Faction ID to claim territory, or nil to unclaim
-- @return boolean: True if successful
function factions.set_territory_owner(pos, faction_id)
    assert(type(pos) == "table", "pos must be a table")
    assert(type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number", "pos must have x, y, z number fields")
    if faction_id then assert(type(faction_id) == "string", "faction_id must be a string or nil") end
    if state.registry and state.registry["set_territory_owner"] then
        return state.registry["set_territory_owner"](pos, faction_id)
    end
    return false
end

--- Gets the influence level of a faction in a territory.
-- @param pos table: Position table with x, y, z coordinates
-- @param faction_id string: Faction ID to check influence for
-- @return number: Influence level (0-100)
function factions.get_territory_influence(pos, faction_id)
    assert(type(pos) == "table", "pos must be a table")
    assert(type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number", "pos must have x, y, z number fields")
    assert(type(faction_id) == "string", "faction_id must be a string")
    if state.registry and state.registry["get_territory_influence"] then
        return state.registry["get_territory_influence"](pos, faction_id)
    end
    return 0
end

--- Adjusts faction influence in a region.
-- @param rx number
-- @param rz number
-- @param faction_id string
-- @param delta number
-- @return boolean
function factions.adjust_influence(rx, rz, faction_id, delta)
    assert(type(rx) == "number", "rx must be a number")
    assert(type(rz) == "number", "rz must be a number")
    assert(type(faction_id) == "string", "faction_id must be a string")
    assert(type(delta) == "number", "delta must be a number")
    if state.registry and state.registry["adjust_influence"] then
        return state.registry["adjust_influence"](rx, rz, faction_id, delta)
    end
    return false
end

--- Creates a new squad for a faction.
-- @param def table
-- @return table|nil
function factions.create_squad(def)
    assert(type(def) == "table", "def must be a table")
    if state.registry and state.registry["create_squad"] then
        return state.registry["create_squad"](def)
    end
    return nil
end

--- Redirects a squad to a new target region.
-- @param id string
-- @param target_region table
-- @return boolean
function factions.redirect_squad(id, target_region)
    assert(type(id) == "string", "id must be a string")
    assert(type(target_region) == "table", "target_region must be a table")
    if state.registry and state.registry["redirect_squad"] then
        return state.registry["redirect_squad"](id, target_region)
    end
    return false
end

--- Gets objective priority modifiers for a faction.
-- @param faction_id string
-- @param objective table
-- @return number
function factions.get_objective_priority_modifier(faction_id, objective)
    assert(type(faction_id) == "string", "faction_id must be a string")
    assert(type(objective) == "table", "objective must be a table")
    if state.registry and state.registry["get_objective_priority_modifier"] then
        return state.registry["get_objective_priority_modifier"](faction_id, objective)
    end
    return 0
end

--- Gets faction tags used for objective filtering.
-- @param faction_id string
-- @return table
function factions.get_faction_tags(faction_id)
    assert(type(faction_id) == "string", "faction_id must be a string")
    if state.registry and state.registry["get_faction_tags"] then
        return state.registry["get_faction_tags"](faction_id)
    end
    return {}
end

--- Gets territory-aware behavior modifiers for an actor.
-- @param actor table
-- @param rx number
-- @param rz number
-- @return table
function factions.get_territory_behavior_modifiers(actor, rx, rz)
    assert(type(actor) == "table", "actor must be a table")
    assert(type(rx) == "number", "rx must be a number")
    assert(type(rz) == "number", "rz must be a number")
    if state.registry and state.registry["get_territory_behavior_modifiers"] then
        return state.registry["get_territory_behavior_modifiers"](actor, rx, rz)
    end
    return { aggression = 0, caution = 0 }
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    factions.faction_overlay = dofile(modpath .. "/debug/faction_overlay.lua")
    factions.faction_inspector = dofile(modpath .. "/debug/faction_inspector.lua")
end

return factions
