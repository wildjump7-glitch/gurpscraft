-- tests/core_factions_api_test.lua

local api = dofile("../core_factions/api.lua")

return {
    module = "core_factions",
    has_api = type(api) == "table",
    checks = {
        register = type(api.register) == "function",
        get = type(api.get) == "function",
        all = type(api.all) == "function",
        exists = type(api.exists) == "function",
        get_relation = type(api.get_relation) == "function",
        set_relation = type(api.set_relation) == "function",
        modify_relation = type(api.modify_relation) == "function",
        get_stance = type(api.get_stance) == "function",
        get_reputation = type(api.get_reputation) == "function",
        set_reputation = type(api.set_reputation) == "function",
        modify_reputation = type(api.modify_reputation) == "function",
        is_hostile = type(api.is_hostile) == "function",
        is_faction_hostile = type(api.is_faction_hostile) == "function",
        get_hostility_reason = type(api.get_hostility_reason) == "function",
        reaction_roll = type(api.reaction_roll) == "function",
        get_reaction_modifier = type(api.get_reaction_modifier) == "function",
        get_territory_owner = type(api.get_territory_owner) == "function",
        set_territory_owner = type(api.set_territory_owner) == "function",
        get_territory_influence = type(api.get_territory_influence) == "function",
    },
}
