-- core_destruction/internal/corrosion.lua

local function apply_corrosion(pos, intensity)
    local amount = math.max(0, intensity or 0)
    return core_destruction.apply_damage(pos, amount, "corrosion")
end

return {
    apply_corrosion = apply_corrosion,
}
