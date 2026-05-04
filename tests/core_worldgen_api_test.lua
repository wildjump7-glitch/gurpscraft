-- tests/core_worldgen_api_test.lua

local api = dofile("../core_worldgen/api.lua")

return {
    module = "core_worldgen",
    has_api = type(api) == "table",
    checks = {
        register_biome = type(api.register_biome) == "function",
        get_biome = type(api.get_biome) == "function",
        get_biome_at = type(api.get_biome_at) == "function",
        get_biomes = type(api.get_biomes) == "function",
        get_noise = type(api.get_noise) == "function",
        register_noise = type(api.register_noise) == "function",
        get_noise_profile = type(api.get_noise_profile) == "function",
        register_structure = type(api.register_structure) == "function",
        place_structure = type(api.place_structure) == "function",
        get_structure = type(api.get_structure) == "function",
        generate_chunk = type(api.generate_chunk) == "function",
        apply_dimension_rules = type(api.apply_dimension_rules) == "function",
        get_spawn_point = type(api.get_spawn_point) == "function",
        spawn_npcs_in_chunk = type(api.spawn_npcs_in_chunk) == "function",
    },
}
