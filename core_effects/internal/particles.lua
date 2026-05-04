-- core_effects/internal/particles.lua

local function particle(def)
    minetest.add_particle(def)
end

local function particles(def)
    minetest.add_particlespawner(def)
end

local function apply_position(def, pos)
    if type(pos) == "table" then
        def.pos = pos
    end
end

local function preset_particles(id, pos, _context)
    local preset = core_effects.particle_presets[id]
    if not preset or not preset.particles then
        return
    end

    local def = core_foundation.util.deepcopy(preset.particles)
    apply_position(def, pos)

    if def.amount and def.amount > 1 and def.time then
        minetest.add_particlespawner(def)
    else
        minetest.add_particle(def)
    end
end

return {
    particle = particle,
    particles = particles,
    preset_particles = preset_particles,
}