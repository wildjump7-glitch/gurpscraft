-- core_crafting/internal/quality.lua

local function calculate_quality(item, actor)
    if type(item) ~= "table" then
        return 0
    end
    return item.quality or 1
end

local function apply_quality(item, quality)
    if type(item) ~= "table" or type(quality) ~= "number" then
        return false
    end
    item.quality = quality
    return true
end

return {
    calculate_quality = calculate_quality,
    apply_quality = apply_quality,
}
