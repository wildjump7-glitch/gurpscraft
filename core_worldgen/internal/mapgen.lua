-- core_worldgen/internal/mapgen.lua

local function generate_chunk(chunk_pos, dimension_id)
    if type(chunk_pos) ~= "table" or type(chunk_pos.x) ~= "number" or type(chunk_pos.z) ~= "number" then
        return false
    end
    local biome = core_worldgen.biome_selector.get_biome_at(chunk_pos)
    local terrain_noise = core_worldgen.noise.get_noise("default_terrain", { x = chunk_pos.x * 16, y = 0, z = chunk_pos.z * 16 })
    return {
        chunk = chunk_pos,
        dimension = dimension_id or "overworld",
        biome = biome,
        noise = terrain_noise,
    }
end

return {
    generate_chunk = generate_chunk,
}
