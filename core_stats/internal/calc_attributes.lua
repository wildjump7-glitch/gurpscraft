-- core_stats/internal/calc_attributes.lua
-- Attribute calculation and modification.

--[[
Set an attribute to a specific value.
Clamps to the attribute definition's min/max range.
Recalculates derived stats afterward.
]]
local function set_attribute(actor, attr_id, value)
    assert(type(actor) == "table", "set_attribute: actor must be a table")
    assert(type(attr_id) == "string", "set_attribute: attr_id must be a string")
    assert(type(value) == "number" or type(tonumber(value)) == "number", "set_attribute: value must be numeric")
    
    if not actor.stats or not actor.stats.attributes then
        return
    end
    
    local def = core_stats and core_stats.attributes and core_stats.attributes[attr_id]
    if def then
        local numeric = tonumber(value) or def.default or 10
        actor.stats.attributes[attr_id] = core_foundation.util.clamp(numeric, def.min or 1, def.max or 20)
        core_stats.recalculate_derived(actor)
    end
end

--[[
Modify an attribute by adding/subtracting a delta.
The new value is clamped to min/max range.
Recalculates derived stats afterward.
]]
local function modify_attribute(actor, attr_id, delta)
    assert(type(actor) == "table", "modify_attribute: actor must be a table")
    assert(type(attr_id) == "string", "modify_attribute: attr_id must be a string")
    assert(type(delta) == "number" or type(tonumber(delta)) == "number", "modify_attribute: delta must be numeric")
    
    local def = core_stats and core_stats.attributes and core_stats.attributes[attr_id]
    if not def then
        return
    end
    
    local current = actor.stats.attributes[attr_id] or def.default or 10
    set_attribute(actor, attr_id, current + (tonumber(delta) or 0))
end

return {
    set_attribute = set_attribute,
    modify_attribute = modify_attribute,
}