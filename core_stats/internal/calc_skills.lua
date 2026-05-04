-- core_stats/internal/calc_skills.lua

local function set_skill(actor, skill_id, level)
    if not actor or not actor.stats or not actor.stats.skills then
        return
    end
    actor.stats.skills[skill_id] = math.max(0, tonumber(level) or 0)
end

local function modify_skill(actor, skill_id, delta)
    if not actor or not actor.stats or not actor.stats.skills then
        return
    end
    actor.stats.skills[skill_id] = math.max(0, (actor.stats.skills[skill_id] or 0) + (delta or 0))
end

return {
    set_skill = set_skill,
    modify_skill = modify_skill,
}