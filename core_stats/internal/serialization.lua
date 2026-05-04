-- core_stats/internal/serialization.lua

local function serialize(actor)
    if not actor or type(actor) ~= "table" then
        return {}
    end
    if not actor.stats then
        return {}
    end
    return core_foundation.util.deepcopy(actor.stats)
end

local function deserialize(actor, data)
    if not actor or type(actor) ~= "table" then
        return false
    end
    if type(data) ~= "table" then
        return false
    end
    actor.stats = core_foundation.util.deepcopy(data)
    actor.stats.attributes = actor.stats.attributes or {}
    actor.stats.skills = actor.stats.skills or {}
    actor.stats.traits = actor.stats.traits or {}
    actor.stats.derived = actor.stats.derived or {}
    actor.stats.points = actor.stats.points or 0
    core_stats.recalculate_derived(actor)
    return true
end

return {
    serialize = serialize,
    deserialize = deserialize,
}