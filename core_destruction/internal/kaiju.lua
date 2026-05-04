-- core_destruction/internal/kaiju.lua

local function apply_kaiju_impact(pos, mass, velocity)
    local amount = math.max(0, (mass or 0) * (velocity or 0) * 0.01)
    return core_destruction.apply_damage(pos, amount, "kaiju")
end

return {
    apply_kaiju_impact = apply_kaiju_impact,
}
