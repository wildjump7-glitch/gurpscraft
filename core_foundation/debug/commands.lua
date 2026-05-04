-- core_foundation/debug/commands.lua
-- Debug tools for core_foundation and module introspection.
-- Only enabled if gurpscraft_debug is true in minetest.conf/luanti.conf.

local debug_enabled = minetest.settings:get_bool("gurpscraft_debug", false)

if debug_enabled then
    --[[
    /modules - List all loaded modules
    ]]
    minetest.register_chatcommand("modules", {
        description = "List all loaded GURPScraft modules",
        func = function(name, _)
            if not core_foundation then
                minetest.chat_send_player(name, "Error: core_foundation not loaded")
                return
            end
            local list = core_foundation.init.list_modules()
            if #list == 0 then
                minetest.chat_send_player(name, "No modules loaded")
            else
                minetest.chat_send_player(name, "Loaded modules: " .. table.concat(list, ", "))
            end
        end
    })

    --[[
    /config_dump - Dump engine configuration values
    ]]
    minetest.register_chatcommand("config_dump", {
        description = "Dump GURPScraft configuration values",
        func = function(name, _)
            if not core_foundation then
                minetest.chat_send_player(name, "Error: core_foundation not loaded")
                return
            end
            local keys = {
                "gurpscraft_debug",
            }
            local lines = {}
            for _, key in ipairs(keys) do
                local val = minetest.settings:get(key) or "(not set)"
                table.insert(lines, key .. " = " .. val)
            end
            for _, line in ipairs(lines) do
                minetest.chat_send_player(name, line)
            end
        end
    })

    --[[
    /log_test [level] - Test logging at specified level
    Levels: trace, debug, info, warn, error
    ]]
    minetest.register_chatcommand("log_test", {
        description = "Test logging at specified level (trace, debug, info, warn, error)",
        params = "[level]",
        func = function(name, param)
            if not core_foundation then
                minetest.chat_send_player(name, "Error: core_foundation not loaded")
                return
            end
            local level = core_foundation.util.trim(param) or "info"
            local msg = "Test log message for " .. name
            
            if core_foundation.log[level] then
                core_foundation.log[level](msg, "debug")
                minetest.chat_send_player(name, "Logged at level: " .. level)
            else
                minetest.chat_send_player(name, "Unknown level: " .. level .. ". Use: trace, debug, info, warn, error")
            end
        end
    })
end