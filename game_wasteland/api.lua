-- game_wasteland/api.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local biomes = dofile(modpath .. "/world/biomes.lua")
local structures = dofile(modpath .. "/world/structures.lua")
local pois = dofile(modpath .. "/world/pois.lua")
local loot_tables = dofile(modpath .. "/world/loot_tables.lua")
local spawn_tables = dofile(modpath .. "/world/spawn_tables.lua")

local factions = dofile(modpath .. "/factions/factions.lua")
local territories = dofile(modpath .. "/factions/territories.lua")

local weapons = dofile(modpath .. "/items/weapons.lua")
local ammo = dofile(modpath .. "/items/ammo.lua")
local armor = dofile(modpath .. "/items/armor.lua")
local consumables = dofile(modpath .. "/items/consumables.lua")
local artifacts = dofile(modpath .. "/items/artifacts.lua")
local recipes = dofile(modpath .. "/items/recipes.lua")

local anomalies = dofile(modpath .. "/anomalies/anomalies.lua")
local fields = dofile(modpath .. "/anomalies/fields.lua")

local levels = dofile(modpath .. "/backrooms/levels.lua")
local rooms = dofile(modpath .. "/backrooms/rooms.lua")
local transitions = dofile(modpath .. "/backrooms/transitions.lua")

local npc_types = dofile(modpath .. "/npc/types.lua")
local npc_behaviors = dofile(modpath .. "/npc/behaviors.lua")
local npc_loadouts = dofile(modpath .. "/npc/loadouts.lua")

local survival_tuning = dofile(modpath .. "/survival/tuning.lua")
local survival_hazards = dofile(modpath .. "/survival/hazards.lua")

local ui_hud = dofile(modpath .. "/ui/hud.lua")
local ui_crosshair = dofile(modpath .. "/ui/crosshair.lua")
local ui_effects = dofile(modpath .. "/ui/effects.lua")

local audio_sounds = dofile(modpath .. "/audio/sounds.lua")
local audio_ambience = dofile(modpath .. "/audio/ambience.lua")

local function get_table_item(table, id)
    return table and table[id]
end

return {
    get_biome = function(id) return get_table_item(biomes, id) end,
    get_structure = function(id) return get_table_item(structures, id) end,
    get_poi = function(id) return get_table_item(pois, id) end,
    get_loot_table = function(id) return get_table_item(loot_tables, id) end,
    get_spawn_table = function(id) return get_table_item(spawn_tables, id) end,

    get_faction = function(id) return get_table_item(factions, id) end,
    get_territory = function(id) return get_table_item(territories, id) end,

    get_weapon = function(id) return get_table_item(weapons, id) end,
    get_ammo = function(id) return get_table_item(ammo, id) end,
    get_armor = function(id) return get_table_item(armor, id) end,
    get_consumable = function(id) return get_table_item(consumables, id) end,
    get_artifact = function(id) return get_table_item(artifacts, id) end,
    get_recipe = function(id) return get_table_item(recipes, id) end,

    get_anomaly = function(id) return get_table_item(anomalies, id) end,
    get_field = function(id) return get_table_item(fields, id) end,

    get_backroom_level = function(id) return get_table_item(levels, id) end,
    get_backroom_room = function(id) return get_table_item(rooms, id) end,
    get_backroom_transition = function(id) return get_table_item(transitions, id) end,

    get_npc_type = function(id) return get_table_item(npc_types, id) end,
    get_npc_behavior = function(id) return get_table_item(npc_behaviors, id) end,
    get_npc_loadout = function(id) return get_table_item(npc_loadouts, id) end,

    get_survival_tuning = function() return survival_tuning end,
    get_survival_hazard = function(id) return get_table_item(survival_hazards, id) end,

    get_ui_hud = function(id) return get_table_item(ui_hud, id) end,
    get_ui_crosshair = function(id) return get_table_item(ui_crosshair, id) end,
    get_ui_effect = function(id) return get_table_item(ui_effects, id) end,

    get_audio_sound = function(id) return get_table_item(audio_sounds, id) end,
    get_audio_ambience = function(id) return get_table_item(audio_ambience, id) end,
}
