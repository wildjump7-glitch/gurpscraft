-- game_wasteland/backrooms/transitions.lua

return {
    stair_down = {
        id = 'stair_down',
        from = 'level_1',
        to = 'level_2',
        description = 'A damaged staircase leading deeper underground.',
    },
    elevator_shaft = {
        id = 'elevator_shaft',
        from = 'level_2',
        to = 'level_3',
        description = 'A ruined elevator shaft full of debris.',
    },
}
