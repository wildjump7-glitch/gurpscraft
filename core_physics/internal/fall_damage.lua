-- core_physics/internal/fall_damage.lua

local get_fall_damage

local function apply_fall_damage(actor, fall_height)
    local damage = get_fall_damage(fall_height, actor)
    if damage > 0 then
        actor:set_hp(actor:get_hp() - damage)
    end
end

get_fall_damage = function(fall_height, actor)
    local _ = actor
    if fall_height > 3 then
        return (fall_height - 3) * 5
    end
    return 0
end

return {
    apply_fall_damage = apply_fall_damage,
    get_fall_damage = get_fall_damage,
}