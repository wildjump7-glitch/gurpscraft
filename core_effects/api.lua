-- core_effects/api.lua
-- Public API for particles, screen effects, sounds, and weather.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local particles = dofile(modpath .. "/internal/particles.lua")
local screen_fx = dofile(modpath .. "/internal/screen_fx.lua")
local sound_fx = dofile(modpath .. "/internal/sound_fx.lua")
local weather = dofile(modpath .. "/internal/weather.lua")

--[[
Play a combined effect preset at a position.
id: preset identifier string
pos: table with x, y, z coordinates
context: optional table with player reference for screen effects
Returns: true if played successfully
]]
local function play(id, pos, context)
    local preset = core_effects.particle_presets[id]
    if not preset then
        return false
    end

    if preset.particles then
        particles.preset_particles(id, pos, context)
    end

    if preset.sound then
        sound_fx.sound(preset.sound, pos, preset.sound_params or {})
    end

    if preset.screen_shake and context and context.player then
        screen_fx.screen_shake(context.player, preset.screen_shake.intensity or 1.0, preset.screen_shake.duration or 0.2)
    end

    return true
end

--[[
Register a new effect preset for reuse.
id: preset identifier string
def: definition table with particles, sound, screen effects
]]
local function register_preset(id, def)
    core_effects.particle_presets = core_effects.particle_presets or {}
    if type(id) ~= "string" or id == "" or type(def) ~= "table" then
        return false
    end
    core_effects.particle_presets[id] = def
    return true
end

--[[
Get a registered effect preset by ID.
Returns: preset definition table or nil
]]
local function get_preset(id)
    if type(core_effects.particle_presets) ~= "table" then
        return nil
    end
    return core_effects.particle_presets[id]
end

--[[
Start a looping effect that plays repeatedly.
id: preset identifier
pos: world position
context: optional context table (player reference)
Returns: loop handle string (use with stop_loop)
]]
local function start_loop(id, pos, context)
    local handle = "fx_loop_" .. tostring(id) .. "_" .. tostring(math.random(1000000))
    core_effects._state.loops[handle] = {
        id = id,
        pos = pos,
        context = context,
    }
    if core_effects.particle_presets[id] and core_effects.particle_presets[id].loop_interval then
        local function tick()
            if not core_effects._state.loops[handle] then
                return
            end
            play(id, pos, context)
            minetest.after(core_effects.particle_presets[id].loop_interval or 1.0, tick)
        end
        minetest.after(0, tick)
    end
    return handle
end

--[[
Stop a looping effect.
loop_handle: handle returned by start_loop
]]
local function stop_loop(loop_handle)
    core_effects._state.loops[loop_handle] = nil
end

return {
    -- Particles
    particle = particles.particle,
    particles = particles.particles,
    preset_particles = particles.preset_particles,
    
    -- Screen effects
    screen_shake = screen_fx.screen_shake,
    screen_flash = screen_fx.screen_flash,
    screen_overlay = screen_fx.screen_overlay,
    hit_indicator = screen_fx.hit_indicator,
    
    -- Sound effects
    sound = sound_fx.sound,
    sound_local = sound_fx.sound_local,
    sound_loop_start = sound_fx.sound_loop_start,
    sound_loop_stop = sound_fx.sound_loop_stop,
    
    -- Weather
    set_weather = weather.set_weather,
    get_weather = weather.get_weather,
    apply_weather = weather.apply_weather,
    
    -- Presets
    play = play,
    register_preset = register_preset,
    get_preset = get_preset,
    start_loop = start_loop,
    stop_loop = stop_loop,
}