-- core_items/data/weapons.lua

return {
    pistol = {
        type = "weapon",
        tags = { "ranged", "firearm" },
        weight = 1.2,
        durability = 100,
        effects = {
            equip = { stats = { DX = 1 } }
        }
    }
}