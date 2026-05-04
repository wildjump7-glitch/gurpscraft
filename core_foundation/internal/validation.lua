-- core_foundation/internal/validation.lua
-- Lightweight schema validation for development and debugging.

--[[
Validate a table against a schema.

Arguments:
  name: string - human-readable name for the table being validated
  tbl: table - the table to validate
  schema: table - keys are expected table keys, values are expected types

Behavior:
  - Logs a warning (not an error) if required keys are missing
  - Logs a warning if actual types don't match expected types
  - Never throws a hard error (this is a dev aid, not production validation)

Example:
  validate.table("my_config", config, {
    max_health = "number",
    name = "string",
    enabled = "boolean"
  })
]]
local function validate_table(name, tbl, schema)
    assert(type(name) == "string", "validate.table: name must be a string")
    assert(type(tbl) == "table", "validate.table: tbl must be a table")
    assert(type(schema) == "table", "validate.table: schema must be a table")
    
    for key, expected_type in pairs(schema) do
        if tbl[key] == nil then
            minetest.log("warning", "Validation: " .. name .. " missing key '" .. key .. "'")
        elseif type(tbl[key]) ~= expected_type then
            minetest.log("warning", "Validation: " .. name .. " key '" .. key .. 
                         "' type mismatch: expected " .. expected_type .. 
                         ", got " .. type(tbl[key]))
        end
    end
end

return {
    table = validate_table,
}