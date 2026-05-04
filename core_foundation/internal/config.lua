-- core_foundation/internal/config.lua
-- Configuration access layer wrapping minetest.settings.

--[[
Get a string configuration value.
Returns the value from minetest.settings or the default.
]]
local function get_string(key, default)
    assert(type(key) == "string", "config.get_string: key must be a string")
    return minetest.settings:get(key) or default or ""
end

--[[
Get a numeric configuration value.
Converts string values to numbers, returns default on parse failure.
]]
local function get_number(key, default)
    assert(type(key) == "string", "config.get_number: key must be a string")
    local val = minetest.settings:get(key)
    if val then
        local num = tonumber(val)
        return num or (default or 0)
    end
    return default or 0
end

--[[
Get a boolean configuration value.
Returns the result of minetest.settings:get_bool for proper boolean parsing.
]]
local function get_bool(key, default)
    assert(type(key) == "string", "config.get_bool: key must be a string")
    return minetest.settings:get_bool(key, default or false)
end

return {
    get_string = get_string,
    get_number = get_number,
    get_bool = get_bool,
}