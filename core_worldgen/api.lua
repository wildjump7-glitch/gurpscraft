-- core_worldgen/api.lua
-- Public API for world generation, biomes, structures, and procedural content.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local worldgen = {}
worldgen.data = {}

local state = {
    registry = {},
    actor_state = {},
}

worldgen._state = state

worldgen.mapgen = dofile(modpath .. "/internal/mapgen.lua")
worldgen.biome_selector = dofile(modpath .. "/internal/biome_selector.lua")
worldgen.structure_placer = dofile(modpath .. "/internal/structure_placer.lua")
worldgen.noise = dofile(modpath .. "/internal/noise.lua")
worldgen.spawn_rules = dofile(modpath .. "/internal/spawn_rules.lua")

--- Registers a new biome in the world generation system.
-- @param biome_id string: Unique identifier for the biome
-- @param biome_data table: Biome configuration data containing temperature, humidity, blocks, etc.
-- @return boolean: True if registration successful, false if biome already exists
function worldgen.register_biome(biome_id, biome_data)
    assert(type(biome_id) == "string", "biome_id must be a string")
    assert(type(biome_data) == "table", "biome_data must be a table")
    if state.registry and state.registry["register_biome"] then
        return state.registry["register_biome"](biome_id, biome_data)
    end
    return false
end

--- Retrieves biome data by ID.
-- @param biome_id string: The biome identifier to look up
-- @return table|nil: Biome data table if found, nil otherwise
function worldgen.get_biome(biome_id)
    assert(type(biome_id) == "string", "biome_id must be a string")
    if state.registry and state.registry["get_biome"] then
        return state.registry["get_biome"](biome_id)
    end
    return nil
end

--- Gets the biome at a specific position.
-- @param pos table: Position table with x, y, z coordinates
-- @return string|nil: Biome ID at the position, or nil if not determined
function worldgen.get_biome_at(pos)
    assert(type(pos) == "table", "pos must be a table")
    assert(type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number", "pos must have x, y, z number fields")
    if state.registry and state.registry["get_biome_at"] then
        return state.registry["get_biome_at"](pos)
    end
    return nil
end

--- Returns all registered biomes.
-- @return table: Table of all biome data keyed by biome_id
function worldgen.get_biomes()
    if state.registry and state.registry["get_biomes"] then
        return state.registry["get_biomes"]()
    end
    return {}
end

--- Gets noise value at a position using a registered noise profile.
-- @param noise_id string: The noise profile identifier
-- @param pos table: Position table with x, y, z coordinates
-- @return number|nil: Noise value if noise profile exists, nil otherwise
function worldgen.get_noise(noise_id, pos)
    assert(type(noise_id) == "string", "noise_id must be a string")
    assert(type(pos) == "table", "pos must be a table")
    assert(type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number", "pos must have x, y, z number fields")
    if state.registry and state.registry["get_noise"] then
        return state.registry["get_noise"](noise_id, pos)
    end
    return nil
end

--- Registers a new noise profile for world generation.
-- @param noise_id string: Unique identifier for the noise profile
-- @param noise_params table: Noise parameters (scale, octaves, persistence, etc.)
-- @return boolean: True if registration successful, false if noise profile already exists
function worldgen.register_noise(noise_id, noise_params)
    assert(type(noise_id) == "string", "noise_id must be a string")
    assert(type(noise_params) == "table", "noise_params must be a table")
    if state.registry and state.registry["register_noise"] then
        return state.registry["register_noise"](noise_id, noise_params)
    end
    return false
end

--- Gets the parameters for a registered noise profile.
-- @param noise_id string: The noise profile identifier
-- @return table|nil: Noise parameters table if found, nil otherwise
function worldgen.get_noise_profile(noise_id)
    assert(type(noise_id) == "string", "noise_id must be a string")
    if state.registry and state.registry["get_noise_profile"] then
        return state.registry["get_noise_profile"](noise_id)
    end
    return nil
end

--- Registers a new structure for world generation.
-- @param structure_id string: Unique identifier for the structure
-- @param structure_data table: Structure configuration data containing schematic, spawn rules, etc.
-- @return boolean: True if registration successful, false if structure already exists
function worldgen.register_structure(structure_id, structure_data)
    assert(type(structure_id) == "string", "structure_id must be a string")
    assert(type(structure_data) == "table", "structure_data must be a table")
    if state.registry and state.registry["register_structure"] then
        return state.registry["register_structure"](structure_id, structure_data)
    end
    return false
end

--- Attempts to place a structure at a specific position.
-- @param structure_id string: The structure identifier to place
-- @param pos table: Position table with x, y, z coordinates
-- @param rotation number: Rotation in degrees (optional)
-- @return boolean: True if structure placed successfully
function worldgen.place_structure(structure_id, pos, rotation)
    assert(type(structure_id) == "string", "structure_id must be a string")
    assert(type(pos) == "table", "pos must be a table")
    assert(type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number", "pos must have x, y, z number fields")
    if rotation then assert(type(rotation) == "number", "rotation must be a number") end
    if state.registry and state.registry["place_structure"] then
        return state.registry["place_structure"](structure_id, pos, rotation)
    end
    return false
end

--- Retrieves structure data by ID.
-- @param structure_id string: The structure identifier to look up
-- @return table|nil: Structure data table if found, nil otherwise
function worldgen.get_structure(structure_id)
    assert(type(structure_id) == "string", "structure_id must be a string")
    if state.registry and state.registry["get_structure"] then
        return state.registry["get_structure"](structure_id)
    end
    return nil
end

--- Generates a chunk of world at the specified coordinates.
-- @param chunk_pos table: Chunk position {x, z} in chunk coordinates
-- @param dimension_id string: Dimension to generate in (optional, defaults to overworld)
-- @return boolean: True if chunk generated successfully
function worldgen.generate_chunk(chunk_pos, dimension_id)
    assert(type(chunk_pos) == "table", "chunk_pos must be a table")
    assert(type(chunk_pos.x) == "number" and type(chunk_pos.z) == "number", "chunk_pos must have x, z number fields")
    if dimension_id then assert(type(dimension_id) == "string", "dimension_id must be a string") end
    if state.registry and state.registry["generate_chunk"] then
        return state.registry["generate_chunk"](chunk_pos, dimension_id)
    end
    return false
end

--- Applies dimension-specific world generation rules.
-- @param dimension_id string: The dimension identifier
-- @param chunk_pos table: Chunk position {x, z} in chunk coordinates
-- @return boolean: True if rules applied successfully
function worldgen.apply_dimension_rules(dimension_id, chunk_pos)
    assert(type(dimension_id) == "string", "dimension_id must be a string")
    assert(type(chunk_pos) == "table", "chunk_pos must be a table")
    assert(type(chunk_pos.x) == "number" and type(chunk_pos.z) == "number", "chunk_pos must have x, z number fields")
    if state.registry and state.registry["apply_dimension_rules"] then
        return state.registry["apply_dimension_rules"](dimension_id, chunk_pos)
    end
    return false
end

--- Gets a suitable spawn point in a generated world.
-- @param dimension_id string: The dimension identifier (optional, defaults to overworld)
-- @return table|nil: Spawn position {x, y, z} if found, nil otherwise
function worldgen.get_spawn_point(dimension_id)
    if dimension_id then assert(type(dimension_id) == "string", "dimension_id must be a string") end
    if state.registry and state.registry["get_spawn_point"] then
        return state.registry["get_spawn_point"](dimension_id)
    end
    return nil
end

--- Spawns NPCs in a generated chunk based on spawn rules.
-- @param chunk_pos table: Chunk position {x, z} in chunk coordinates
-- @param dimension_id string: Dimension to spawn in (optional, defaults to overworld)
-- @return number: Number of NPCs spawned
function worldgen.spawn_npcs_in_chunk(chunk_pos, dimension_id)
    assert(type(chunk_pos) == "table", "chunk_pos must be a table")
    assert(type(chunk_pos.x) == "number" and type(chunk_pos.z) == "number", "chunk_pos must have x, z number fields")
    if dimension_id then assert(type(dimension_id) == "string", "dimension_id must be a string") end
    if state.registry and state.registry["spawn_npcs_in_chunk"] then
        return state.registry["spawn_npcs_in_chunk"](chunk_pos, dimension_id)
    end
    return 0
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    worldgen.worldgen_overlay = dofile(modpath .. "/debug/worldgen_overlay.lua")
    worldgen.regen_chunk = dofile(modpath .. "/debug/regen_chunk.lua")
end

return worldgen
