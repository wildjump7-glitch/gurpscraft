-- core_foundation/internal/utils.lua
-- Shared utility functions for math, tables, and strings.

--[[
Clamp value to range [min, max].
Returns the value clamped within the specified bounds.
]]
local function clamp(x, min, max)
    assert(type(x) == "number", "clamp: x must be a number")
    assert(type(min) == "number", "clamp: min must be a number")
    assert(type(max) == "number", "clamp: max must be a number")
    if x < min then return min
    elseif x > max then return max
    else return x
    end
end

--[[
Linear interpolation between a and b by t (0-1).
Returns a + (b - a) * t.
]]
local function lerp(a, b, t)
    assert(type(a) == "number", "lerp: a must be a number")
    assert(type(b) == "number", "lerp: b must be a number")
    assert(type(t) == "number", "lerp: t must be a number")
    return a + (b - a) * t
end

--[[
Round x to specified number of decimal places.
If decimals is 0 or omitted, rounds to nearest integer.
]]
local function round(x, decimals)
    assert(type(x) == "number", "round: x must be a number")
    decimals = decimals or 0
    assert(type(decimals) == "number", "round: decimals must be a number")
    local mult = 10 ^ decimals
    return math.floor(x * mult + 0.5) / mult
end

--[[
Deep copy a table recursively.
Non-table values are returned as-is.
]]
local function deepcopy(tbl)
    if type(tbl) ~= "table" then return tbl end
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = deepcopy(v)
    end
    return copy
end

--[[
Merge src table into dst table.
If overwrite is true, src values replace dst values.
Otherwise, only missing keys are added to dst.
]]
local function merge(dst, src, overwrite)
    assert(type(dst) == "table", "merge: dst must be a table")
    assert(type(src) == "table", "merge: src must be a table")
    for k, v in pairs(src) do
        if overwrite or dst[k] == nil then
            dst[k] = v
        end
    end
    return dst
end

--[[
Create a read-only wrapper around a table.
Attempting to modify the wrapper raises an error.
]]
local function readonly(tbl)
    assert(type(tbl) == "table", "readonly: tbl must be a table")
    return setmetatable({}, {
        __index = tbl,
        __newindex = function() error("attempt to modify read-only table") end,
    })
end

--[[
Split a string by separator (default: whitespace).
Returns a table of substrings.
]]
local function split(str, sep)
    assert(type(str) == "string", "split: str must be a string")
    sep = sep or "%s"
    local t = {}
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, s)
    end
    return t
end

--[[
Trim leading and trailing whitespace from a string.
]]
local function trim(str)
    assert(type(str) == "string", "trim: str must be a string")
    return str:match("^%s*(.-)%s*$")
end

--[[
Convert a value to a string safely.
Tables are converted to the string "table" instead of "table: 0x...".
]]
local function safe_tostring(value)
    if type(value) == "table" then
        return "table"
    else
        return tostring(value)
    end
end

return {
    clamp = clamp,
    lerp = lerp,
    round = round,
    deepcopy = deepcopy,
    merge = merge,
    readonly = readonly,
    split = split,
    trim = trim,
    safe_tostring = safe_tostring,
}