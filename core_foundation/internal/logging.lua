-- core_foundation/internal/logging.lua
-- Unified logging API wrapping minetest.log with optional module-scoped prefixes.

--[[
Map internal log levels to Minetest levels:
- trace → "verbose" (Minetest's most detailed level)
- debug → "verbose"
- info → "info"
- warn → "warning"
- error → "error"
]]

local function trace(msg, module_id)
    assert(type(msg) == "string", "logging.trace: msg must be a string")
    local prefix = module_id and ("[" .. module_id .. "] ") or ""
    minetest.log("verbose", prefix .. msg)
end

local function debug(msg, module_id)
    assert(type(msg) == "string", "logging.debug: msg must be a string")
    local prefix = module_id and ("[" .. module_id .. "] ") or ""
    minetest.log("verbose", prefix .. msg)
end

local function info(msg, module_id)
    assert(type(msg) == "string", "logging.info: msg must be a string")
    local prefix = module_id and ("[" .. module_id .. "] ") or ""
    minetest.log("info", prefix .. msg)
end

local function warn(msg, module_id)
    assert(type(msg) == "string", "logging.warn: msg must be a string")
    local prefix = module_id and ("[" .. module_id .. "] ") or ""
    minetest.log("warning", prefix .. msg)
end

local function error(msg, module_id)
    assert(type(msg) == "string", "logging.error: msg must be a string")
    local prefix = module_id and ("[" .. module_id .. "] ") or ""
    minetest.log("error", prefix .. msg)
end

return {
    trace = trace,     -- Detailed diagnostic logging
    debug = debug,     -- Debug-level logging
    info = info,       -- Informational logging
    warn = warn,       -- Warning logging
    error = error,     -- Error logging
}