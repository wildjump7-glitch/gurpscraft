-- core_crafting/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.recipes = dofile(modpath .. "/data/recipes.lua")
api.data.reverse_engineering = dofile(modpath .. "/data/reverse_engineering.lua")
api.data.quality_profiles = dofile(modpath .. "/data/quality_profiles.lua")

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

register_module_functions(api.recipe_match)
register_module_functions(api.craft_logic)
register_module_functions(api.reverse_engineering)
register_module_functions(api.quality)

if type(api.data.recipes) == "table" then
    for id, recipe in pairs(api.data.recipes) do
        api.register_recipe(id, recipe)
    end
end

core_crafting = api

return core_crafting
