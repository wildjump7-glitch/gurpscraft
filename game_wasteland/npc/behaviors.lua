-- game_wasteland/npc/behaviors.lua

return {
    patrol = {
        id = 'patrol',
        aggression = 0.4,
        alert_range = 12,
    },
    ambush = {
        id = 'ambush',
        aggression = 0.8,
        alert_range = 8,
    },
    scavenging = {
        id = 'scavenging',
        aggression = 0.2,
        alert_range = 6,
    },
}
