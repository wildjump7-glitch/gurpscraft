-- core_survival/api.lua
-- Public API for hunger, thirst, temperature, radiation, disease, and poison.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local survival = {}
survival.data = {}

local state = {
    registry = {},
    actor_state = {},
}

survival._state = state

survival.hunger = dofile(modpath .. "/internal/hunger.lua")
survival.thirst = dofile(modpath .. "/internal/thirst.lua")
survival.temperature = dofile(modpath .. "/internal/temperature.lua")
survival.radiation = dofile(modpath .. "/internal/radiation.lua")
survival.disease = dofile(modpath .. "/internal/disease.lua")
survival.poison = dofile(modpath .. "/internal/poison.lua")
survival.fatigue = dofile(modpath .. "/internal/fatigue.lua")
survival.environment = dofile(modpath .. "/internal/environment.lua")

--[[ HUNGER SYSTEM ]]
function survival.get_hunger(...) if state.registry and state.registry["get_hunger"] then return state.registry["get_hunger"](...) end return nil end
function survival.modify_hunger(...) if state.registry and state.registry["modify_hunger"] then return state.registry["modify_hunger"](...) end return nil end
function survival.set_hunger(...) if state.registry and state.registry["set_hunger"] then return state.registry["set_hunger"](...) end return nil end
function survival.apply_starvation(...) if state.registry and state.registry["apply_starvation"] then return state.registry["apply_starvation"](...) end return nil end

--[[ THIRST SYSTEM ]]
function survival.get_thirst(...) if state.registry and state.registry["get_thirst"] then return state.registry["get_thirst"](...) end return nil end
function survival.modify_thirst(...) if state.registry and state.registry["modify_thirst"] then return state.registry["modify_thirst"](...) end return nil end
function survival.set_thirst(...) if state.registry and state.registry["set_thirst"] then return state.registry["set_thirst"](...) end return nil end
function survival.apply_dehydration(...) if state.registry and state.registry["apply_dehydration"] then return state.registry["apply_dehydration"](...) end return nil end

--[[ TEMPERATURE SYSTEM (hypothermia, heatstroke, environmental exposure) ]]
function survival.get_temperature(...) if state.registry and state.registry["get_temperature"] then return state.registry["get_temperature"](...) end return nil end
function survival.update_temperature(...) if state.registry and state.registry["update_temperature"] then return state.registry["update_temperature"](...) end return nil end
function survival.apply_hypothermia(...) if state.registry and state.registry["apply_hypothermia"] then return state.registry["apply_hypothermia"](...) end return nil end
function survival.apply_heatstroke(...) if state.registry and state.registry["apply_heatstroke"] then return state.registry["apply_heatstroke"](...) end return nil end

--[[ RADIATION SYSTEM ]]
function survival.get_radiation(...) if state.registry and state.registry["get_radiation"] then return state.registry["get_radiation"](...) end return nil end
function survival.modify_radiation(...) if state.registry and state.registry["modify_radiation"] then return state.registry["modify_radiation"](...) end return nil end
function survival.apply_radiation_sickness(...) if state.registry and state.registry["apply_radiation_sickness"] then return state.registry["apply_radiation_sickness"](...) end return nil end

--[[ DISEASE SYSTEM ]]
function survival.infect(...) if state.registry and state.registry["infect"] then return state.registry["infect"](...) end return nil end
function survival.cure(...) if state.registry and state.registry["cure"] then return state.registry["cure"](...) end return nil end
function survival.update_diseases(...) if state.registry and state.registry["update_diseases"] then return state.registry["update_diseases"](...) end return nil end

--[[ POISON SYSTEM ]]
function survival.apply_poison(...) if state.registry and state.registry["apply_poison"] then return state.registry["apply_poison"](...) end return nil end
function survival.update_poison(...) if state.registry and state.registry["update_poison"] then return state.registry["update_poison"](...) end return nil end

--[[ FATIGUE SYSTEM (stamina exhaustion) ]]
function survival.get_fatigue(...) if state.registry and state.registry["get_fatigue"] then return state.registry["get_fatigue"](...) end return nil end
function survival.modify_fatigue(...) if state.registry and state.registry["modify_fatigue"] then return state.registry["modify_fatigue"](...) end return nil end
function survival.apply_exhaustion(...) if state.registry and state.registry["apply_exhaustion"] then return state.registry["apply_exhaustion"](...) end return nil end

--[[ ENVIRONMENT INTEGRATION ]]
function survival.apply_environmental_damage(...) if state.registry and state.registry["apply_environmental_damage"] then return state.registry["apply_environmental_damage"](...) end return nil end
function survival.check_environment(...) if state.registry and state.registry["check_environment"] then return state.registry["check_environment"](...) end return nil end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    survival.survival_overlay = dofile(modpath .. "/debug/survival_overlay.lua")
    survival.apply_hazard = dofile(modpath .. "/debug/apply_hazard.lua")
end

return survival
