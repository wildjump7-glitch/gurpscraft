-- tests/core_crafting_api_test.lua

local minetest = minetest or {
    get_modpath = function(_)
        return "../core_crafting"
    end,
    get_current_modname = function()
        return "core_crafting"
    end,
    settings = {
        get_bool = function()
            return false
        end,
    },
}

local api = dofile("../core_crafting/init.lua")

assert(type(api) == "table")
assert(type(api.register_recipe) == "function")
assert(type(api.get_recipe) == "function")
assert(type(api.get_recipes_by_output) == "function")
assert(type(api.get_recipes_by_tag) == "function")
assert(type(api.all_recipes) == "function")
assert(type(api.can_craft) == "function")
assert(type(api.craft) == "function")
assert(type(api.get_craft_result) == "function")
assert(type(api.get_failure_result) == "function")
assert(type(api.get_critical_success_result) == "function")
assert(type(api.match_ingredients) == "function")
assert(type(api.match_tags) == "function")
assert(type(api.match_tools) == "function")
assert(type(api.get_skill_modifier) == "function")
assert(type(api.roll_crafting_check) == "function")
assert(type(api.reverse_engineer) == "function")
assert(type(api.unlock_recipe) == "function")
assert(type(api.get_unlocked_recipes) == "function")
assert(type(api.calculate_quality) == "function")
assert(type(api.apply_quality) == "function")

assert(api.get_recipe("iron_sword") ~= nil)
assert(next(api.get_recipes_by_output("iron_sword")) ~= nil)
assert(type(api.get_recipes_by_tag("weapon")) == "table")

local inventory = { iron_ingot = 1, stick = 1 }
assert(api.can_craft("iron_sword", inventory, {}))
local result = api.craft("iron_sword", inventory, {})
assert(type(result) == "table" and result.success == true)
assert(type(api.get_craft_result("iron_sword")) == "table")
assert(api.get_failure_result("iron_sword") == nil)
assert(api.get_critical_success_result("iron_sword") == nil)
assert(api.match_ingredients({ inputs = { "iron_ingot", "stick" } }, inventory))
assert(api.match_tags({ tags = { "weapon" } }, { "weapon", "metal" }))
assert(api.match_tools({ tools = { "hammer" } }, { hammer = true }))

local item = { quality = 1 }
assert(api.calculate_quality(item, {}) == 1)
assert(api.apply_quality(item, 2) == true)
assert(item.quality == 2)

return {
    module = "core_crafting",
    has_api = type(api) == "table",
    checks = {
        register_recipe = type(api.register_recipe) == "function",
        get_recipe = type(api.get_recipe) == "function",
        get_recipes_by_output = type(api.get_recipes_by_output) == "function",
        get_recipes_by_tag = type(api.get_recipes_by_tag) == "function",
        all_recipes = type(api.all_recipes) == "function",
        can_craft = type(api.can_craft) == "function",
        craft = type(api.craft) == "function",
        get_craft_result = type(api.get_craft_result) == "function",
        get_failure_result = type(api.get_failure_result) == "function",
        get_critical_success_result = type(api.get_critical_success_result) == "function",
        match_ingredients = type(api.match_ingredients) == "function",
        match_tags = type(api.match_tags) == "function",
        match_tools = type(api.match_tools) == "function",
        get_skill_modifier = type(api.get_skill_modifier) == "function",
        roll_crafting_check = type(api.roll_crafting_check) == "function",
        reverse_engineer = type(api.reverse_engineer) == "function",
        unlock_recipe = type(api.unlock_recipe) == "function",
        get_unlocked_recipes = type(api.get_unlocked_recipes) == "function",
        calculate_quality = type(api.calculate_quality) == "function",
        apply_quality = type(api.apply_quality) == "function",
    },
}