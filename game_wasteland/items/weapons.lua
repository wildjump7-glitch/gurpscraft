-- game_wasteland/items/weapons.lua

return {
    pipe_rifle = {
        id = "pipe_rifle",
        display_name = "Pipe Rifle",
        damage = 8,
        range = 24,
        durability = 120,
        ammo_type = "rifle_round",
        tags = { "firearm", "improvised" },
    },
    machete = {
        id = "machete",
        display_name = "Machete",
        damage = 4,
        durability = 80,
        tags = { "melee", "light" },
    },
}
