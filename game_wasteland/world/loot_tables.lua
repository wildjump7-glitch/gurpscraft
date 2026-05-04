-- game_wasteland/world/loot_tables.lua

return {
    common_crate = {
        id = 'common_crate',
        items = { 'water_bottle', 'canned_food', 'scrap_core' },
        weights = { 60, 30, 10 },
    },
    rare_cache = {
        id = 'rare_cache',
        items = { 'glowstone', 'void_crystal', 'pipe_rifle' },
        weights = { 50, 35, 15 },
    },
}
