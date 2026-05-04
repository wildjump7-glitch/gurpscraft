-- tests/core_magic_api_test.lua

local minetest = minetest or {
    get_modpath = function(_)
        return "../core_magic"
    end,
    get_current_modname = function()
        return "core_magic"
    end,
    settings = {
        get_bool = function()
            return false
        end,
    },
}

local api = dofile("../core_magic/init.lua")
assert(type(api) == "table")
assert(type(api.register_spell) == "function")
assert(type(api.get_spell) == "function")
assert(type(api.all_spells) == "function")
assert(type(api.cast) == "function")
assert(type(api.can_cast) == "function")
assert(type(api.get_cast_cost) == "function")
assert(type(api.get_mana) == "function")
assert(type(api.set_mana) == "function")
assert(type(api.modify_mana) == "function")
assert(type(api.apply_enchantment) == "function")
assert(type(api.get_enchantments) == "function")
assert(type(api.start_ritual) == "function")
assert(type(api.update_ritual) == "function")
assert(type(api.finish_ritual) == "function")
assert(type(api.abort_ritual) == "function")

local actor = { id = "magic_actor", position = { x = 0, y = 0, z = 0 } }
assert(api.get_mana(actor) == 0)
assert(api.set_mana(actor, 100))
assert(api.get_mana(actor) == 100)
assert(api.modify_mana(actor, -10))
assert(api.get_mana(actor) == 90)

assert(api.get_spell("fireball") ~= nil)
assert(api.get_cast_cost("fireball") == 25)
assert(api.can_cast(actor, "fireball"))
assert(api.register_spell("test_fire", { id = "test_fire", name = "Test Fire", mana_cost = 20, effect_id = "fire_effect", power = 1 }))
assert(not api.register_spell("test_fire", { id = "test_fire", name = "Test Fire", mana_cost = 20, effect_id = "fire_effect", power = 1 }))
assert(api.get_cast_cost("test_fire") == 20)
assert(api.can_cast(actor, "test_fire"))
assert(api.cast(actor, "test_fire", { position = { x = 1, y = 1, z = 1 } }))
assert(api.get_mana(actor) == 70)

local item = {}
item = api.apply_enchantment(item, "sharpness", 2)
assert(item.enchantments and item.enchantments.sharpness == 2)
item = api.remove_enchantment(item, "sharpness")
assert(item.enchantments.sharpness == nil)
assert(type(api.get_enchantments(item)) == "table")

local ritual_instance = api.start_ritual(actor, "summoning", { x = 0, y = 0, z = 0 })
assert(type(ritual_instance) == "string")
assert(api.update_ritual(ritual_instance, 1))
assert(api.abort_ritual(ritual_instance))

return {
    module = "core_magic",
    has_api = type(api) == "table",
    checks = {
        register_spell = true,
        get_spell = true,
        all_spells = true,
        cast = true,
        can_cast = true,
    },
}
