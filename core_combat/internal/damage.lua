-- core_combat/internal/damage.lua

local function apply_damage(target, amount, damage_type, hitzone)
    if not target or not target.set_hp or not target.get_hp then
        return 0
    end
    -- Simplified hitzone multiplier
    local mult = 1.0
    if hitzone == "head" then mult = 2.0
    elseif hitzone == "arms" or hitzone == "legs" then mult = 0.75
    end
    local final_damage = amount * mult
    -- Simplified armor calculation
    local armor_value = 0
    if type(target) == "table" and type(target.armor) == "table" then
        armor_value = target.armor[hitzone] or target.armor.all or 0
    end
    if damage_type ~= "fire" then -- fire ignores armor
        final_damage = math.max(0, final_damage - armor_value)
    end
    target:set_hp(target:get_hp() - final_damage)
    return final_damage
end

local function calculate_damage(actor, weapon_id, hitzone)
    local _ = actor
    local weapon = core_items.get(weapon_id)
    local base = (weapon and weapon.damage) or 10
    local mult = 1.0
    if hitzone == "head" then mult = 2.0
    elseif hitzone == "arms" or hitzone == "legs" then mult = 0.75
    end
    return base * mult
end

return {
    apply_damage = apply_damage,
    calculate_damage = calculate_damage,
}