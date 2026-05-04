-- core_combat/internal/hitzones.lua

local hitzones = {
    head = { multiplier = 2.0, armor_slot = "helmet" },
    torso = { multiplier = 1.0, armor_slot = "torso" },
    arms = { multiplier = 0.75 },
    legs = { multiplier = 0.75 },
}

local function get_hitzone(target, hit_position)
    local _ = target
    if not hit_position then
        return "torso"
    end
    if hit_position.y >= 1.5 then
        return "head"
    end
    if hit_position.y <= 0.8 then
        return "legs"
    end
    return "torso"
end

local function get_hitzone_multiplier(hitzone)
    local hz = hitzones[hitzone]
    return hz and hz.multiplier or 1.0
end

return {
    get_hitzone = get_hitzone,
    get_hitzone_multiplier = get_hitzone_multiplier,
}