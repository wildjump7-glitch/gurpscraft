-- game_wasteland/items/consumables.lua

return {
    water_bottle = {
        id = 'water_bottle',
        display_name = 'Water Bottle',
        hunger_restore = 0,
        thirst_restore = 30,
    },
    canned_food = {
        id = 'canned_food',
        display_name = 'Canned Food',
        hunger_restore = 25,
        thirst_restore = 0,
    },
    stim_pack = {
        id = 'stim_pack',
        display_name = 'Stim Pack',
        heal_amount = 15,
        duration = 10,
    },
}
