-- tests/core_destruction_api_test.lua

local minetest = minetest or {
    get_modpath = function(_)
        return "../core_destruction"
    end,
    get_current_modname = function()
        return "core_destruction"
    end,
    settings = {
        get_bool = function()
            return false
        end,
    },
    pos_to_string = function(pos)
        return (pos.x or 0) .. "," .. (pos.y or 0) .. "," .. (pos.z or 0)
    end,
    get_node = function(_)
        return { name = "stone" }
    end,
    remove_node = function(_)
    end,
    get_objects_inside_radius = function(_, __)
        return {}
    end,
}

local api = dofile("../core_destruction/init.lua")
assert(type(api) == "table")
assert(type(api.register_material) == "function")
assert(type(api.get_material) == "function")
assert(type(api.apply_damage) == "function")
assert(type(api.get_block_hp) == "function")
assert(type(api.set_block_hp) == "function")
assert(type(api.break_block) == "function")
assert(type(api.check_support) == "function")
assert(type(api.get_integrity) == "function")
assert(type(api.trigger_collapse) == "function")
assert(type(api.update_integrity) == "function")
assert(type(api.explode) == "function")
assert(type(api.apply_shockwave) == "function")
assert(type(api.penetrate) == "function")
assert(type(api.get_penetration_cost) == "function")
assert(type(api.ignite) == "function")
assert(type(api.extinguish) == "function")
assert(type(api.apply_corrosion) == "function")
assert(type(api.save_ruin) == "function")
assert(type(api.load_ruin) == "function")
assert(type(api.clear_ruin) == "function")
assert(type(api.apply_siege_damage) == "function")
assert(type(api.apply_kaiju_impact) == "function")
assert(type(api.create_breach) == "function")
assert(type(api.undermine) == "function")

local stone_mat = api.get_material("stone")
assert(type(stone_mat) == "table")
assert(api.register_material("test_block", { id = "test_block", hardness = 50, resistance = 0.8 }))
assert(api.get_material("test_block") ~= nil)

local pos = { x = 0, y = 0, z = 0 }
assert(type(api.get_block_hp(pos)) == "number")
assert(api.set_block_hp(pos, 50))
assert(api.get_block_hp(pos) == 50)
assert(api.apply_damage(pos, 10, "explosive") <= 50)
assert(api.check_support(pos) == false or api.check_support(pos) == true)
assert(type(api.get_integrity(pos)) == "number")
assert(api.update_integrity(pos))
assert(api.trigger_collapse(pos, 3))
assert(api.explode(pos, 50, { radius = 5 }))
assert(type(api.apply_shockwave(pos, 50)) == "number")

return {
    module = "core_destruction",
    has_api = type(api) == "table",
    checks = {
        apply_damage = true,
        get_block_hp = true,
        set_block_hp = true,
        break_block = true,
        check_support = true,
        get_integrity = true,
        trigger_collapse = true,
        update_integrity = true,
        explode = true,
        apply_shockwave = true,
    },
}
