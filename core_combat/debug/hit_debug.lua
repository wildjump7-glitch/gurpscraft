-- core_combat/debug/hit_debug.lua

local function debug_hit()
    return {
        hitzones = core_combat.hitzones,
        damage_types = core_combat.damage_types,
    }
end

return {
    debug_hit = debug_hit,
}