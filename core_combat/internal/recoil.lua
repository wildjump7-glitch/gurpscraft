-- core_combat/internal/recoil.lua

local function apply_recoil(actor, weapon_id)
    local weapon = core_items.get(weapon_id) or {}
    local recoil_amount = weapon.recoil or 0.1
    if type(actor) == "table" then
        actor.combat_recoil = (actor.combat_recoil or 0) + recoil_amount
        return actor.combat_recoil
    end
    return recoil_amount
end

local function get_spread(actor, weapon_id)
    local weapon = core_items.get(weapon_id) or {}
    local base = weapon.spread or 0.01
    local suppression = actor.combat_suppression or 0
    return base + (suppression * 0.001)
end

return {
    apply_recoil = apply_recoil,
    get_spread = get_spread,
}