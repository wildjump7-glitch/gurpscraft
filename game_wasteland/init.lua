
-- game_wasteland/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local game = dofile(modpath .. "/api.lua")

game.world = {
    biomes = dofile(modpath .. "/world/biomes.lua"),
    structures = dofile(modpath .. "/world/structures.lua"),
    pois = dofile(modpath .. "/world/pois.lua"),
    loot_tables = dofile(modpath .. "/world/loot_tables.lua"),
    spawn_tables = dofile(modpath .. "/world/spawn_tables.lua"),
}

game.factions = {
    factions = dofile(modpath .. "/factions/factions.lua"),
    territories = dofile(modpath .. "/factions/territories.lua"),
}

game.items = {
    weapons = dofile(modpath .. "/items/weapons.lua"),
    ammo = dofile(modpath .. "/items/ammo.lua"),
    armor = dofile(modpath .. "/items/armor.lua"),
    consumables = dofile(modpath .. "/items/consumables.lua"),
    artifacts = dofile(modpath .. "/items/artifacts.lua"),
    recipes = dofile(modpath .. "/items/recipes.lua"),
}

game.anomalies = {
    anomalies = dofile(modpath .. "/anomalies/anomalies.lua"),
    fields = dofile(modpath .. "/anomalies/fields.lua"),
}

game.backrooms = {
    levels = dofile(modpath .. "/backrooms/levels.lua"),
    rooms = dofile(modpath .. "/backrooms/rooms.lua"),
    transitions = dofile(modpath .. "/backrooms/transitions.lua"),
}

game.npc = {
    types = dofile(modpath .. "/npc/types.lua"),
    behaviors = dofile(modpath .. "/npc/behaviors.lua"),
    loadouts = dofile(modpath .. "/npc/loadouts.lua"),
}

game.survival = {
    tuning = dofile(modpath .. "/survival/tuning.lua"),
    hazards = dofile(modpath .. "/survival/hazards.lua"),
}

game.ui = {
    hud = dofile(modpath .. "/ui/hud.lua"),
    crosshair = dofile(modpath .. "/ui/crosshair.lua"),
    effects = dofile(modpath .. "/ui/effects.lua"),
}

game.audio = {
    sounds = dofile(modpath .. "/audio/sounds.lua"),
    ambience = dofile(modpath .. "/audio/ambience.lua"),
}

game_wasteland = game

return game_wasteland
