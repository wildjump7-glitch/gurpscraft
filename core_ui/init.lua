-- core_ui/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.hud_layout = dofile(modpath .. "/data/hud_layout.lua")
api.data.status_effect_icons = dofile(modpath .. "/data/status_effect_icons.lua")

local function register_module_functions(module)
    if type(module) ~= "table" then
        return
    end
    for key, value in pairs(module) do
        if type(value) == "function" then
            api._state.registry[key] = value
        end
    end
end

-- Register status effect icons at init time
if type(api.data.status_effect_icons) == "table" then
    for effect_id, effect_data in pairs(api.data.status_effect_icons) do
        api.icons.register_icon(effect_id, effect_data.icon, {size = 32, color = effect_data.color})
    end
end

-- Register internal function modules
register_module_functions(api.hud)
register_module_functions(api.status_effects)
register_module_functions(api.notifications)
register_module_functions(api.icons)
register_module_functions(api.overlays)

core_ui = api

return core_ui
