-- core_actor/data/behaviors.lua

return {
    guardian = {
        id = 'guardian',
        description = 'Protects a location and attacks intruders.',
        aggression = 0.7,
        alert_radius = 10,
    },
    wanderer = {
        id = 'wanderer',
        description = 'Roams the area and reacts to threats.',
        aggression = 0.3,
        alert_radius = 6,
    },
    ambusher = {
        id = 'ambusher',
        description = 'Hides and strikes from cover.',
        aggression = 0.9,
        alert_radius = 8,
    },
}
