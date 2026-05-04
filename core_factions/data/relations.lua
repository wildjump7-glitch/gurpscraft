-- core_factions/data/relations.lua

return {
    scavengers = {
        enforcers = 'hostile',
        wanderers = 'neutral',
    },
    enforcers = {
        scavengers = 'hostile',
        wanderers = 'cautious',
    },
    wanderers = {
        scavengers = 'neutral',
        enforcers = 'cautious',
    },
}
