-- core_stats/internal/progression.lua

local function award_points(actor, points)
    if not actor or not actor.stats then
        return 0
    end
    actor.stats.points = math.max(0, (actor.stats.points or 0) + (points or 0))
    return actor.stats.points
end

local function spend_points(actor, points)
    if not actor or not actor.stats then
        return false
    end
    local cost = math.max(0, points or 0)
    local available = actor.stats.points or 0
    if available < cost then
        return false
    end
    actor.stats.points = available - cost
    return true
end

return {
    award_points = award_points,
    spend_points = spend_points,
}