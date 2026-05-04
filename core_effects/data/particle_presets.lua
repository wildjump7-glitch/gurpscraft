-- core_effects/data/particle_presets.lua

return {
    fireball_explosion = {
        particles = {
            amount = 40,
            texture = "fire_particle.png",
            velocity = { min = -2, max = 2 },
            gravity = -4,
            glow = 10,
        },
        sound = "explosion_large",
        screen_shake = { intensity = 1.2, duration = 0.3 },
    }
}