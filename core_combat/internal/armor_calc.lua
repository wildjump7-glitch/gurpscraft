-- core_combat/internal/armor_calc.lua

local damage_types = {
    ballistic = { armor = "pierce" },
    slash = { armor = "cut" },
    blunt = { armor = "impact" },
    fire = { armor = "none" },
}

local function apply_armor(target, damage, damage_type, hitzone)
    local damage_def = damage_types[damage_type] or {}
    local armor_value = 0
    if type(target) == "table" and type(target.armor) == "table" then
        armor_value = target.armor[hitzone] or target.armor.all or 0
    end
    if damage_def.armor == "none" then
        return damage
    end
    return math.max(0, damage - armor_value)
end

return {
    apply_armor = apply_armor,
}