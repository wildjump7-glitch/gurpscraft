-- core_worldgen/internal/biome_selector.lua

local biomes = {}

local function register_biome(id, def)
    if type(id) ~= "string" or id == "" or type(def) ~= "table" then
        return false
    end
    biomes[id] = def
    return true
end

local function get_biome(id)
    return biomes[id]
end

local function get_biome_at(pos)
    if type(pos) ~= "table" or type(pos.x) ~= "number" or type(pos.z) ~= "number" then
        return nil
    end
    local keys = {}
    for biome_id in pairs(biomes) do
        table.insert(keys, biome_id)
    end
    if #keys == 0 then
        return nil
    end
    table.sort(keys)
    local hash = math.abs(math.floor((pos.x * 31 + pos.z * 17) % #keys)) + 1
    return keys[hash]
end

local function get_biomes()
    local copy = {}
    for id, def in pairs(biomes) do
        copy[id] = def
    end
    return copy
end

return {
    register_biome = register_biome,
    get_biome = get_biome,
    get_biome_at = get_biome_at,
    get_biomes = get_biomes,
}
