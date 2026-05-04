-- core_magic/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.spells = dofile(modpath .. "/data/spells.lua")
api.data.rituals = dofile(modpath .. "/data/rituals.lua")
api.data.enchantments = dofile(modpath .. "/data/enchantments.lua")

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

register_module_functions(api.casting)
register_module_functions(api.mana)
register_module_functions(api.rituals)
register_module_functions(api.effects)
register_module_functions(api.enchantments)

if type(api.data.spells) == "table" then
    for spell_id, spell_data in pairs(api.data.spells) do
        api.register_spell(spell_id, spell_data)
    end
end

core_magic = api

return core_magic
