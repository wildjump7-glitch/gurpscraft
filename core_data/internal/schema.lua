-- core_data/internal/schema.lua
-- Schema validation for data tables.

local function warn(context, message)
    local scope = context and ("[" .. context .. "] ") or ""
    if core_foundation and core_foundation.log and core_foundation.log.warn then
        core_foundation.log.warn(scope .. message, "core_data")
    else
        minetest.log("warning", scope .. message)
    end
end

--[[
Check if a value exists in an allowed list.
]]
local function is_allowed_value(value, allowed)
    for _, candidate in ipairs(allowed) do
        if candidate == value then
            return true
        end
    end
    return false
end

--[[
Validate a single field in a table against a rule.

Rule formats:
- "typename" — Required field of exact type
- { type = "typename" } — Required field with explicit type
- { type = "typename", optional = true } — Optional field
- { allowed = {...} } — Field restricted to allowed values
- { optional = true } — Optional field of any type

Returns true if valid, false otherwise.
Logs warning if validation fails.
]]
local function validate_rule(value, key, rule, context)
    if type(rule) == "string" then
        if value == nil then
            warn(context, "missing required key '" .. key .. "'")
            return false
        end
        if type(value) ~= rule then
            warn(context, "key '" .. key .. "' expected type '" .. rule .. "' got '" .. type(value) .. "'")
            return false
        end
        return true
    end

    if type(rule) ~= "table" then
        warn(context, "invalid schema rule for key '" .. key .. "'")
        return false
    end

    local expected_type = rule.type or rule[1]
    local optional = rule.optional == true
    local allowed_values = rule.allowed

    if value == nil then
        if optional then
            return true
        end
        warn(context, "missing required key '" .. key .. "'")
        return false
    end

    if expected_type and type(value) ~= expected_type then
        warn(context, "key '" .. key .. "' expected type '" .. expected_type .. "' got '" .. type(value) .. "'")
        return false
    end

    if allowed_values and not is_allowed_value(value, allowed_values) then
        warn(context, "key '" .. key .. "' has disallowed value '" .. tostring(value) .. "'")
        return false
    end

    return true
end

--[[
Validate a table against a schema.
Schema is a table where keys are field names and values are type rules.

Example:
  validate({
    id = "string",
    level = "number",
    tags = { type = "table", optional = true }
  }, {
    id = "string",
    level = "number",
    tags = { type = "table", optional = true }
  }, "my_object")

Returns true if all rules pass, false if any fail.
Logs a warning for each failure.
]]
local function validate(def, schema, context)
    assert(type(def) == "table", "validate: def must be a table")
    assert(type(schema) == "table", "validate: schema must be a table")
    if context ~= nil then
        assert(type(context) == "string", "validate: context must be a string or nil")
    end

    local ok = true
    for key, spec in pairs(schema) do
        local rule_ok = validate_rule(def[key], key, spec, context)
        if not rule_ok then
            ok = false
        end
    end

    return ok
end

return {
    validate = validate,
}