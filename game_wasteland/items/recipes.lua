-- game_wasteland/items/recipes.lua

return {
    pipe_rifle = {
        id = 'pipe_rifle',
        inputs = { 'scrap_core', 'rifle_round', 'scrap_plate' },
        output = 'pipe_rifle',
        time = 20,
    },
    leather_vest = {
        id = 'leather_vest',
        inputs = { 'canned_food', 'scrap_plate' },
        output = 'leather_vest',
        time = 12,
    },
    water_bottle = {
        id = 'water_bottle',
        inputs = { 'scrap_core' },
        output = 'water_bottle',
        time = 5,
    },
}
