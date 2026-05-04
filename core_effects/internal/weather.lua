-- core_effects/internal/weather.lua

local weather_state = {}

local function set_weather(dimension_id, weather_id)
    weather_state[dimension_id] = weather_id
end

local function get_weather(dimension_id)
    return weather_state[dimension_id]
end

local function apply_weather(player, weather_id)
    if not player or not player:get_player_name() then
        return false
    end

    core_effects._state.weather[player:get_player_name()] = weather_id
    local profile = core_effects.weather_profiles[weather_id]
    if not profile then
        return false
    end

    if profile.particles then
        minetest.add_particlespawner({
            amount = profile.particle_amount or 100,
            time = profile.duration or 5,
            minpos = vector.subtract(player:get_pos(), 5),
            maxpos = vector.add(player:get_pos(), 5),
            minvel = {x = 0, y = -1, z = 0},
            maxvel = {x = 0, y = -2, z = 0},
            texture = profile.particles,
        })
    end

    return true
end

return {
    set_weather = set_weather,
    get_weather = get_weather,
    apply_weather = apply_weather,
}