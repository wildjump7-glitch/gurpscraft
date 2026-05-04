-- tests/core_items_api_test.lua

local function run()
    assert(type(core_items) == "table", "core_items should be loaded")
    assert(type(core_items.register) == "function", "register should exist")
    assert(type(core_items.get) == "function", "get should exist")
    assert(type(core_items.exists) == "function", "exists should exist")

    local test_item = {
        type = "misc",
        tags = { "test", "debug" },
        weight = 0.5,
    }
    assert(core_items.register("test_item", test_item), "should register a new item")
    assert(core_items.exists("test_item"), "registered item should exist")

    local loaded = core_items.get("test_item")
    assert(type(loaded) == "table", "loaded item should be a table")
    assert(loaded.type == "misc", "loaded item type should be preserved")
    assert(#loaded.tags == 2, "loaded item tags should be preserved")

    assert(core_items.has_tag("test_item", "test"), "item should report tag membership")
    local tag_list = core_items.get_by_tag("test")
    assert(type(tag_list) == "table" and #tag_list > 0, "get_by_tag should return matching ids")

    local recipe = core_items.get_recipe("pistol_recipe")
    assert(type(recipe) == "table" and recipe.output == "pistol", "should retrieve crafting recipe")
    local recipe_list = core_items.get_recipes_by_output("pistol")
    assert(type(recipe_list) == "table" and #recipe_list >= 1, "should find recipes by output")

    local item_slots = core_items.get_attachment_slots("pistol")
    assert(type(item_slots) == "table", "attachment slots query should return a table")

    local compatible = core_items.get_compatible_attachments("pistol")
    assert(type(compatible) == "table", "compatible attachments query should return a table")

    local actor = { stats = { attributes = { DX = 10 } }, hp = 50 }
    local effect_result = core_items.apply_effects(actor, "pistol", "equip")
    assert(effect_result == true, "apply_effects should return true for valid effects")
    assert(actor.stats.attributes.DX >= 10, "actor stat should be modified by equip effects")

    return true
end

return {
    run = run,
}
