-- core_combat/internal/parry.lua

local function parry(actor, weapon_id)
    local _ = weapon_id
    local success = core_stats.check_skill(actor, "melee_weapon", 0)
    return success
end

local function block(actor, weapon_id)
    local _ = weapon_id
    local success = core_stats.check_attribute(actor, "DX", -1)
    return success
end

return {
    parry = parry,
    block = block,
}