-- core_dimension/internal/rulesets.lua

local rules = {}

local function apply_rules(actor, dimension_id)
    if type(actor) ~= "table" or type(dimension_id) ~= "string" then
        return false
    end
    actor.dimension_rules = rules[dimension_id] or {}
    return true
end

local function get_rules(dimension_id)
    return rules[dimension_id] or {}
end

local function update_rules(dimension_id, new_rules)
    if type(dimension_id) ~= "string" or type(new_rules) ~= "table" then
        return false
    end
    rules[dimension_id] = new_rules
    return true
end

return {
    apply_rules = apply_rules,
    get_rules = get_rules,
    update_rules = update_rules,
}
