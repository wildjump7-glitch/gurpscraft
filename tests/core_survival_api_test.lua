-- tests/core_survival_api_test.lua

local api = dofile("../core_survival/api.lua")

return {
    module = "core_survival",
    has_api = type(api) == "table",
    checks = {
        get_hunger = type(api.get_hunger) == "function",
        modify_hunger = type(api.modify_hunger) == "function",
        set_hunger = type(api.set_hunger) == "function",
        apply_starvation = type(api.apply_starvation) == "function",
        get_thirst = type(api.get_thirst) == "function",
        modify_thirst = type(api.modify_thirst) == "function",
        set_thirst = type(api.set_thirst) == "function",
        apply_dehydration = type(api.apply_dehydration) == "function",
        get_temperature = type(api.get_temperature) == "function",
        update_temperature = type(api.update_temperature) == "function",
        apply_hypothermia = type(api.apply_hypothermia) == "function",
        apply_heatstroke = type(api.apply_heatstroke) == "function",
        get_radiation = type(api.get_radiation) == "function",
        modify_radiation = type(api.modify_radiation) == "function",
        apply_radiation_sickness = type(api.apply_radiation_sickness) == "function",
        infect = type(api.infect) == "function",
        cure = type(api.cure) == "function",
        update_diseases = type(api.update_diseases) == "function",
        apply_poison = type(api.apply_poison) == "function",
        update_poison = type(api.update_poison) == "function",
        get_fatigue = type(api.get_fatigue) == "function",
        modify_fatigue = type(api.modify_fatigue) == "function",
        apply_exhaustion = type(api.apply_exhaustion) == "function",
        apply_environmental_damage = type(api.apply_environmental_damage) == "function",
        check_environment = type(api.check_environment) == "function",
    },
}
