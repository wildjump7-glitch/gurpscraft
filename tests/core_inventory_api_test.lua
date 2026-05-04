-- tests/core_inventory_api_test.lua

local function run()
    assert(type(core_inventory) == "table", "core_inventory should be loaded")
    assert(type(core_inventory.equip) == "function", "equip should exist")
    assert(type(core_inventory.unequip) == "function", "unequip should exist")
    assert(type(core_inventory.get_total_weight) == "function", "get_total_weight should exist")

    local actor = { stats = { derived = { Carry_Weight = 20 } }, equipment = {}, quickslots = {}, loadouts = {} }
    local pistol_stack = { name = "pistol", count = 1 }

    assert(core_inventory.can_equip(actor, pistol_stack, "weapon_primary"), "pistol should be equippable in weapon_primary")
    assert(core_inventory.equip(actor, pistol_stack, "weapon_primary"), "equip should succeed")
    assert(actor.equipment.weapon_primary and actor.equipment.weapon_primary.name == "pistol", "pistol should be equipped in weapon_primary")

    local item_weight = core_inventory.get_total_weight(actor)
    assert(type(item_weight) == "number" and item_weight >= 0, "total weight should be calculable")
    local loadout_name = "combat"
    assert(core_inventory.save_loadout(actor, loadout_name), "save_loadout should succeed")
    assert(core_inventory.load_loadout(actor, loadout_name), "load_loadout should succeed")

    assert(core_inventory.validate_actor_equipment(actor), "actor equipment should validate")

    local quick_item = { name = "pistol", count = 1 }
    assert(core_inventory.can_quickslot(actor, quick_item), "pistol should be valid for quickslot")
    assert(core_inventory.set_quickslot(actor, 1, quick_item), "set_quickslot should succeed")
    assert(core_inventory.get_quickslots(actor)[1].name == "pistol", "quickslot should store the item")

    local encumbrance = core_inventory.get_encumbrance_level(actor)
    assert(type(encumbrance) == "string", "encumbrance level should be a string")
    local penalty = core_inventory.get_encumbrance_penalty(actor)
    assert(type(penalty) == "number", "encumbrance penalty should be numeric")

    return true
end

return {
    run = run,
}
