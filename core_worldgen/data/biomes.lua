-- core_worldgen/data/biomes.lua

return {
    default_land = {
        id = 'default_land',
        name = 'Default Land',
        temperature = 0.5,
        humidity = 0.5,
        noise_factor = 1.0,
    },
    desert = {
        id = 'desert',
        name = 'Desert',
        temperature = 0.8,
        humidity = 0.1,
        noise_factor = 0.8,
    },
    forest = {
        id = 'forest',
        name = 'Forest',
        temperature = 0.4,
        humidity = 0.7,
        noise_factor = 1.2,
    },
}
