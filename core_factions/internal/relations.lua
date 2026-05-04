-- core_factions/internal/relations.lua

local relation_data = {}

local stance_value = {
    allied = 100,
    friendly = 50,
    neutral = 0,
    cautious = -10,
    unfriendly = -50,
    hostile = -80,
    enemy = -100,
}

local function normalize_pair(a, b)
    return tostring(a), tostring(b)
end

local function normalize_relation(value)
    if type(value) == "number" then
        return math.max(-100, math.min(100, value))
    end
    if type(value) == "string" then
        local normalized = value:lower()
        return stance_value[normalized] or 0
    end
    return 0
end

local function set_relation(faction_a, faction_b, relation_value)
    if not faction_a or not faction_b then
        return false
    end
    local value = normalize_relation(relation_value)
    local a, b = normalize_pair(faction_a, faction_b)
    relation_data[a] = relation_data[a] or {}
    relation_data[a][b] = value
    return true
end

local function get_relation(faction_a, faction_b)
    if not faction_a or not faction_b then
        return 0
    end
    local a, b = normalize_pair(faction_a, faction_b)
    return relation_data[a] and relation_data[a][b] or 0
end

local function modify_relation(faction_a, faction_b, delta)
    if not faction_a or not faction_b or type(delta) ~= "number" then
        return false
    end
    local current = get_relation(faction_a, faction_b)
    return set_relation(faction_a, faction_b, current + delta)
end

local function get_stance(faction_a, faction_b)
    local relation = get_relation(faction_a, faction_b)
    if relation >= 75 then
        return "allied"
    elseif relation >= 25 then
        return "friendly"
    elseif relation > -25 then
        return "neutral"
    elseif relation > -75 then
        return "hostile"
    end
    return "enemy"
end

local function all()
    local copy = {}
    for faction_a, targets in pairs(relation_data) do
        copy[faction_a] = {}
        for faction_b, relation in pairs(targets) do
            copy[faction_a][faction_b] = relation
        end
    end
    return copy
end

return {
    set_relation = set_relation,
    get_relation = get_relation,
    modify_relation = modify_relation,
    get_stance = get_stance,
    all = all,
}
