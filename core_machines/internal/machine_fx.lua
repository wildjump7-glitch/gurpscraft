-- core_machines/internal/machine_fx.lua
-- Visual and audio effects for machine operation

local function play_effect(instance_id, effect_name)
    if type(instance_id) ~= "string" or type(effect_name) ~= "string" then
        return false
    end
    -- In real implementation, would trigger minetest effects via core_effects
    -- For now, just validate parameters
    return true
end

local function particle_effect(position, particlespawner)
    if type(position) ~= "table" or type(particlespawner) ~= "table" then
        return false
    end
    -- Spawn particles (smoke, sparks, glow, steam)
    return true
end

local function sound_effect(position, sound_name)
    if type(position) ~= "table" or type(sound_name) ~= "string" then
        return false
    end
    -- Play sound (mechanical noise, hum, spark sound)
    return true
end

local function add_sound(instance_id, sound_id, sound_config)
    if type(instance_id) ~= "string" or type(sound_id) ~= "string" or type(sound_config) ~= "table" then
        return false
    end
    -- Register a sound for this machine type
    return true
end

local function add_particle_emitter(instance_id, particle_id, particle_config)
    if type(instance_id) ~= "string" or type(particle_id) ~= "string" or type(particle_config) ~= "table" then
        return false
    end
    -- Register a particle emitter for this machine type
    return true
end

return {
    play_effect = play_effect,
    particle_effect = particle_effect,
    sound_effect = sound_effect,
    add_sound = add_sound,
    add_particle_emitter = add_particle_emitter,
}
