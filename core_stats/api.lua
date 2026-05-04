-- core_stats/api.lua
-- Public API for character attributes, skills, traits, and stat checks.
-- Implements GURPS-style character statistics for all actors.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local calc_attributes = dofile(modpath .. "/internal/calc_attributes.lua")
local calc_skills = dofile(modpath .. "/internal/calc_skills.lua")
local derived = dofile(modpath .. "/internal/derived.lua")
local checks = dofile(modpath .. "/internal/checks.lua")
local serialization = dofile(modpath .. "/internal/serialization.lua")

--[[
Ensure an actor has the full stat sheet structure.
Creates empty tables if they don't exist.
]]
local function ensure_actor_stats(actor)
    if type(actor) ~= "table" then
        return
    end
    actor.stats = actor.stats or {}
    actor.stats.attributes = actor.stats.attributes or {}
    actor.stats.skills = actor.stats.skills or {}
    actor.stats.traits = actor.stats.traits or {}
    actor.stats.derived = actor.stats.derived or {}
    actor.stats.points = actor.stats.points or 0
end

--[[
Initialize an actor with default attributes from core_stats.attributes.
All attributes are set to their default values.
All skills and traits are cleared.
Derived stats are recalculated.
]]
local function init_actor(actor)
    ensure_actor_stats(actor)
    actor.stats.attributes = {}
    actor.stats.skills = {}
    actor.stats.traits = {}
    actor.stats.derived = {}
    actor.stats.points = 0
    
    -- Initialize attributes from definitions
    if core_stats and core_stats.attributes then
        for attr, def in pairs(core_stats.attributes) do
            actor.stats.attributes[attr] = def.default or 10
        end
    end
    
    derived.recalculate(actor)
end

--[[
Get a generic stat value from actor.stats.
]]
local function get(actor, key)
    ensure_actor_stats(actor)
    return actor.stats[key]
end

--[[
Set a generic stat value in actor.stats.
]]
local function set(actor, key, value)
    ensure_actor_stats(actor)
    actor.stats[key] = value
end

--[[
Modify a generic stat value by adding/subtracting a delta.
]]
local function modify(actor, key, delta)
    ensure_actor_stats(actor)
    actor.stats[key] = (actor.stats[key] or 0) + (tonumber(delta) or 0)
end

--[[
Recalculate all derived statistics for an actor.
Called automatically when attributes or traits change.
]]
local function recalculate(actor)
    ensure_actor_stats(actor)
    derived.recalculate(actor)
end

--[[
Get an attribute value (ST, DX, IQ, or HT).
Returns the numeric value, or nil if undefined.
]]
local function get_attribute(actor, attr_id)
    ensure_actor_stats(actor)
    return actor.stats.attributes[attr_id]
end

--[[
Set an attribute value (ST, DX, IQ, or HT).
Value is clamped to the attribute's min/max range.
Recalculates dependent derived stats.
]]
local function set_attribute(actor, attr_id, value)
    calc_attributes.set_attribute(actor, attr_id, value)
end

--[[
Modify an attribute by a delta (e.g., -1 for a penalty).
Clamps to min/max range and recalculates derived stats.
]]
local function modify_attribute(actor, attr_id, delta)
    calc_attributes.modify_attribute(actor, attr_id, delta)
end

--[[
Get a derived stat value (HP, Will, Perception, etc.).
Returns the calculated numeric value.
]]
local function get_derived(actor, id)
    ensure_actor_stats(actor)
    return derived.get(actor, id)
end

--[[
Recalculate derived statistics.
Call this after changing attributes or traits.
]]
local function recalculate_derived(actor)
    derived.recalculate(actor)
end

--[[
Get a skill level for an actor.
Returns the skill value, or 0 if not set.
]]
local function get_skill(actor, skill_id)
    ensure_actor_stats(actor)
    return actor.stats.skills[skill_id] or 0
end

--[[
Set a skill level for an actor.
]]
local function set_skill(actor, skill_id, level)
    calc_skills.set_skill(actor, skill_id, level)
end

--[[
Modify a skill level by a delta.
]]
local function modify_skill(actor, skill_id, delta)
    calc_skills.modify_skill(actor, skill_id, delta)
end

--[[
Check if an actor has a specific trait.
Returns true if the trait is present, false otherwise.
]]
local function has_trait(actor, trait_id)
    ensure_actor_stats(actor)
    return actor.stats.traits[trait_id] == true
end

--[[
Add a trait to an actor.
Recalculates derived stats after adding.
]]
local function add_trait(actor, trait_id)
    ensure_actor_stats(actor)
    actor.stats.traits[trait_id] = true
    derived.recalculate(actor)
end

--[[
Remove a trait from an actor.
Recalculates derived stats after removal.
]]
local function remove_trait(actor, trait_id)
    ensure_actor_stats(actor)
    actor.stats.traits[trait_id] = nil
    derived.recalculate(actor)
end

--[[
Perform a 3d6 check against an attribute.
modifier is optional (default 0).
Returns: success (bool), roll (number), target (number), margin (number).
Success is true if roll <= target.
]]
local function check_attribute(actor, attr_id, modifier)
    return checks.check_attribute(actor, attr_id, modifier)
end

--[[
Perform a 3d6 check against a skill.
modifier is optional (default 0).
Returns: success (bool), roll (number), target (number), margin (number).
]]
local function check_skill(actor, skill_id, modifier)
    return checks.check_skill(actor, skill_id, modifier)
end

--[[
Perform a 3d6 roll against a raw value.
Useful for testing or non-actor checks.
Returns: success (bool), roll (number), target (number), margin (number).
]]
local function check_value(value, modifier)
    return checks.check_value(value, modifier)
end

--[[
Standard contest between two actors on a skill.
Both roll and compare results.
Returns: winner ("A", "B", or "tie"), details table with rolls and margins.
]]
local function contest(actorA, actorB, skill_id)
    return checks.contest(actorA, actorB, skill_id)
end

--[[
Quick contest between two actors on a skill.
Functions identically to standard contest in current implementation.
]]
local function quick_contest(actorA, actorB, skill_id)
    return checks.quick_contest(actorA, actorB, skill_id)
end

--[[
Serialize an actor's stats to a Lua table.
Can be saved and restored via deserialize.
]]
local function serialize(actor)
    return serialization.serialize(actor)
end

--[[
Deserialize a previously serialized stat sheet into an actor.
]]
local function deserialize(actor, data)
    ensure_actor_stats(actor)
    return serialization.deserialize(actor, data)
end

return {
    -- Initialization
    init_actor = init_actor,
    
    -- Generic stat access
    get = get,
    set = set,
    modify = modify,
    recalculate = recalculate,
    
    -- Attribute access
    get_attribute = get_attribute,
    set_attribute = set_attribute,
    modify_attribute = modify_attribute,
    
    -- Derived stats
    get_derived = get_derived,
    recalculate_derived = recalculate_derived,
    
    -- Skills
    get_skill = get_skill,
    set_skill = set_skill,
    modify_skill = modify_skill,
    
    -- Traits
    has_trait = has_trait,
    add_trait = add_trait,
    remove_trait = remove_trait,
    
    -- Checks and contests
    check_attribute = check_attribute,
    check_skill = check_skill,
    check_value = check_value,
    contest = contest,
    quick_contest = quick_contest,
    
    -- Serialization
    serialize = serialize,
    deserialize = deserialize,
}