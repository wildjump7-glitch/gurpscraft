-- core_factions/data/factions.lua

return {
    scavengers = {
        id = 'scavengers',
        name = 'Scavengers',
        description = 'Survivors who fight over scrap and ruins.',
        default_reputation = 0,
    },
    enforcers = {
        id = 'enforcers',
        name = 'Enforcers',
        description = 'A disciplined faction enforcing order through force.',
        default_reputation = -10,
    },
    wanderers = {
        id = 'wanderers',
        name = 'Wanderers',
        description = 'Nomadic individuals avoiding faction politics.',
        default_reputation = 5,
    },
}
