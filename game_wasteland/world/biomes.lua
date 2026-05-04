-- game_wasteland/world/biomes.lua

return {
    wasteland = {
        id = "wasteland",
        display_name = "Wasteland",
        temperature = 0.2,
        humidity = 0.1,
        dominant_nodes = { "default:stone", "default:sand", "default:gravel" },
        ambient_light = 0.6,
        spawn_density = 0.05,
    },
    ruined_city = {
        id = "ruined_city",
        display_name = "Ruined City",
        temperature = 0.3,
        humidity = 0.05,
        dominant_nodes = { "default:stone", "default:brick", "default:glass" },
        ambient_light = 0.4,
        spawn_density = 0.08,
    },
}
