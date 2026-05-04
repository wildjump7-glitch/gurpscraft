-- core_worldgen/internal/noise.lua

local noise_profiles = {}

local function register_noise(id, params)
    if type(id) ~= "string" or id == "" or type(params) ~= "table" then
        return false
    end
    noise_profiles[id] = params
    return true
end

local function get_noise(id, pos)
    if type(id) ~= "string" or id == "" or type(pos) ~= "table" then
        return nil
    end
    local params = noise_profiles[id]
    if type(params) ~= "table" then
        return nil
    end
    local value = math.sin(pos.x * (params.scale or 1.0) + pos.z * ((params.scale or 1.0) * 1.3) + (params.octaves or 1) * 7) * 0.5 + 0.5
    return value
end

local function get_noise_profile(id)
    return noise_profiles[id]
end

return {
    register_noise = register_noise,
    get_noise = get_noise,
    get_noise_profile = get_noise_profile,
}
