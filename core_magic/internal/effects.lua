-- core_magic/internal/effects.lua

local function apply_spell_effect(effect_id, target, caster, power)
    if type(effect_id) ~= "string" or type(target) ~= "table" or type(caster) ~= "table" or type(power) ~= "number" then
        return false
    end
    target.magic_effects = target.magic_effects or {}
    table.insert(target.magic_effects, {
        effect_id = effect_id,
        caster = caster,
        power = power,
        position = target.position,
    })
    return true
end

local function apply_area_effect(effect_id, position, radius, caster, power)
    if type(effect_id) ~= "string" or type(position) ~= "table" or type(radius) ~= "number" or type(caster) ~= "table" or type(power) ~= "number" then
        return false
    end
    caster.magic = caster.magic or {}
    caster.magic.area_effect = {
        effect_id = effect_id,
        position = position,
        radius = radius,
        power = power,
    }
    return true
end

return {
    apply_spell_effect = apply_spell_effect,
    apply_area_effect = apply_area_effect,
}
