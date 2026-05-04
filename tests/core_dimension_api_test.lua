-- tests/core_dimension_api_test.lua

local api = dofile("../core_dimension/api.lua")

return {
    module = "core_dimension",
    has_api = type(api) == "table",
    checks = {
        register = type(api.register) == "function",
        get = type(api.get) == "function",
        all = type(api.all) == "function",
        teleport = type(api.teleport) == "function",
        teleport_safe = type(api.teleport_safe) == "function",
        can_enter = type(api.can_enter) == "function",
        can_exit = type(api.can_exit) == "function",
        apply_rules = type(api.apply_rules) == "function",
        get_rules = type(api.get_rules) == "function",
        update_rules = type(api.update_rules) == "function",
        get_current = type(api.get_current) == "function",
        set_current = type(api.set_current) == "function",
        get_spawn_point = type(api.get_spawn_point) == "function",
        on_enter = type(api.on_enter) == "function",
        on_exit = type(api.on_exit) == "function",
    },
}
