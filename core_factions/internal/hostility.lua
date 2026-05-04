-- core_factions/internal/hostility.lua

local function get_faction_id(actor_or_id)
    if type(actor_or_id) == "table" then
        return actor_or_id.faction or actor_or_id.faction_id or actor_or_id.id and tostring(actor_or_id.id)
    end
    return tostring(actor_or_id)
end

local function is_hostile(actor_a, actor_b)
    local faction_a = get_faction_id(actor_a)
    local faction_b = get_faction_id(actor_b)
    if not faction_a or not faction_b then
        return false
    end
    local relation = core_factions.relations.get_relation(faction_a, faction_b)
    return relation < -25
end

local function is_faction_hostile(faction_a, faction_b)
    if not faction_a or not faction_b then
        return false
    end
    local relation = core_factions.relations.get_relation(faction_a, faction_b)
    return relation < -25
end

local function get_hostility_reason(actor_a, actor_b)
    if is_hostile(actor_a, actor_b) then
        return "hostile relationship"
    end
    return "none"
end

local function reaction_roll(actor_a, actor_b)
    local modifier = get_reaction_modifier(actor_a, actor_b)
    local base = 50 + modifier
    return {
        roll = base + math.random(-10, 10),
        modifiers = { relation = modifier },
        reaction = modifier < 0 and "negative" or "positive",
    }
end

local function get_reaction_modifier(actor_a, actor_b)
    local faction_a = get_faction_id(actor_a)
    local faction_b = get_faction_id(actor_b)
    if not faction_a or not faction_b then
        return 0
    end
    local relation = core_factions.relations.get_relation(faction_a, faction_b)
    return relation
end

return {
    is_hostile = is_hostile,
    is_faction_hostile = is_faction_hostile,
    get_hostility_reason = get_hostility_reason,
    reaction_roll = reaction_roll,
    get_reaction_modifier = get_reaction_modifier,
}
