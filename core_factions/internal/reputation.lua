-- core_factions/internal/reputation.lua

local reputation_data = {}

local function get_reputation(actor, faction_id)
    if type(actor) ~= "table" or not faction_id then
        return 0
    end
    reputation_data[actor.id or tostring(actor)] = reputation_data[actor.id or tostring(actor)] or {}
    return reputation_data[actor.id or tostring(actor)][tostring(faction_id)] or 0
end

local function set_reputation(actor, faction_id, value)
    if type(actor) ~= "table" or not faction_id or type(value) ~= "number" then
        return false
    end
    reputation_data[actor.id or tostring(actor)] = reputation_data[actor.id or tostring(actor)] or {}
    reputation_data[actor.id or tostring(actor)][tostring(faction_id)] = value
    return true
end

local function modify_reputation(actor, faction_id, delta)
    if type(actor) ~= "table" or not faction_id or type(delta) ~= "number" then
        return false
    end
    local current = get_reputation(actor, faction_id)
    return set_reputation(actor, faction_id, current + delta)
end

local function get_reputation_stance(actor, faction_id)
    local score = get_reputation(actor, faction_id)
    if score >= 75 then
        return "ally"
    elseif score >= 25 then
        return "friendly"
    elseif score > -25 then
        return "neutral"
    elseif score > -75 then
        return "unfriendly"
    end
    return "hostile"
end

return {
    get_reputation = get_reputation,
    set_reputation = set_reputation,
    modify_reputation = modify_reputation,
    get_reputation_stance = get_reputation_stance,
}
