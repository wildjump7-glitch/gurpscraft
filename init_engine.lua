-- gurpscraft/init_engine.lua
-- Bootstrap and integrate all engine modules in the correct order
-- This file wires together the entire GURPScraft engine

-- Load order follows PROMPT.md exactly
local function safe_load_module(modname)
    local result = minetest.load_mod(modname)
    if result then
        core_foundation.log("engine", "✓ Loaded " .. modname)
    else
        core_foundation.warn("engine", "✗ Failed to load " .. modname)
    end
    return result
end

-- Foundational modules (must load first)
core_foundation = minetest.load_mod("core_foundation")
core_data = minetest.load_mod("core_data")
core_stats = minetest.load_mod("core_stats")

-- Item and inventory
core_items = minetest.load_mod("core_items")
core_inventory = minetest.load_mod("core_inventory")

-- Combat and physics
core_combat = minetest.load_mod("core_combat")
core_physics = minetest.load_mod("core_physics")
core_effects = minetest.load_mod("core_effects")

-- UI
core_ui = minetest.load_mod("core_ui")

-- World and simulation
core_worldgen = minetest.load_mod("core_worldgen")
core_dimension = minetest.load_mod("core_dimension")
core_anomalies = minetest.load_mod("core_anomalies")
core_simulation = minetest.load_mod("core_simulation")

-- Actors and social
core_factions = minetest.load_mod("core_factions")
core_actor = minetest.load_mod("core_actor")
core_quests = minetest.load_mod("core_quests")

-- Advanced systems
core_survival = minetest.load_mod("core_survival")
core_machines = minetest.load_mod("core_machines")
core_magic = minetest.load_mod("core_magic")
core_crafting = minetest.load_mod("core_crafting")
core_vehicles = minetest.load_mod("core_vehicles")

-- Destruction (late-stage)
core_destruction = minetest.load_mod("core_destruction")

-- Game-specific content
game_wasteland = minetest.load_mod("game_wasteland")

-- Hook up game initialization if available
if game_wasteland and game_wasteland.init then
    game_wasteland.init()
end

core_foundation.log("engine", "===== GURPScraft Engine Initialized =====")
