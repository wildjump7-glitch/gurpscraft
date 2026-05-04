-- tests/core_effects_api_test.lua

local function run()
    assert(type(core_effects) == "table", "core_effects should be loaded")
    assert(type(core_effects.play) == "function", "play should exist")
    assert(type(core_effects.register_preset) == "function", "register_preset should exist")
    assert(type(core_effects.get_preset) == "function", "get_preset should exist")
    assert(type(core_effects.start_loop) == "function", "start_loop should exist")
    assert(type(core_effects.stop_loop) == "function", "stop_loop should exist")
    assert(type(core_effects.particle) == "function", "particle should exist")
    assert(type(core_effects.particles) == "function", "particles should exist")
    assert(type(core_effects.preset_particles) == "function", "preset_particles should exist")
    assert(type(core_effects.screen_shake) == "function", "screen_shake should exist")
    assert(type(core_effects.screen_flash) == "function", "screen_flash should exist")
    assert(type(core_effects.sound) == "function", "sound should exist")
    assert(type(core_effects.sound_local) == "function", "sound_local should exist")
    assert(type(core_effects.set_weather) == "function", "set_weather should exist")
    assert(type(core_effects.get_weather) == "function", "get_weather should exist")
    assert(type(core_effects.apply_weather) == "function", "apply_weather should exist")
    return true
end

return {
    run = run,
}
