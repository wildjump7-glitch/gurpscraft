-- game_wasteland/world/spawn_tables.lua

return {
    wasteland_npcs = {
        id = 'wasteland_npcs',
        spawns = { 'scavenger', 'raider', 'mutant' },
        weights = { 40, 35, 25 },
    },
    city_npcs = {
        id = 'city_npcs',
        spawns = { 'raider', 'mutant' },
        weights = { 55, 45 },
    },
}
