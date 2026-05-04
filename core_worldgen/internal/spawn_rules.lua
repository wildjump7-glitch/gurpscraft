-- core_worldgen/internal/spawn_rules.lua

local function apply_dimension_rules(chunk_pos, dimension_id)
    if type(chunk_pos) ~= "table" or type(chunk_pos.x) ~= "number" or type(chunk_pos.z) ~= "number" or type(dimension_id) ~= "string" then
        return false
    end
    return true
end

local function get_spawn_point(dimension_id)
    if type(dimension_id) ~= "string" then
        return { x = 0, y = 10, z = 0 }
    end
    if core_dimension and core_dimension.get then
        local def = core_dimension.get(dimension_id)
        if def and def.spawn then
            return def.spawn
        end
    end
    return { x = 0, y = 10, z = 0 }
end

local function spawn_npcs_in_chunk(chunk_pos, dimension_id)
    if type(chunk_pos) ~= "table" or type(chunk_pos.x) ~= "number" or type(chunk_pos.z) ~= "number" then
        return 0
    end
    return 0
end

return {
    apply_dimension_rules = apply_dimension_rules,
    get_spawn_point = get_spawn_point,
    spawn_npcs_in_chunk = spawn_npcs_in_chunk,
}
