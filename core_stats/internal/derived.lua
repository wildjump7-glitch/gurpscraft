-- core_stats/internal/derived.lua

local function get(actor, id)
    if not actor or not actor.stats or not actor.stats.derived then
        return nil
    end
    return actor.stats.derived[id]
end

local function get_attr(actor, attr)
    local attrs = actor.stats.attributes or {}
    return tonumber(attrs[attr]) or 10
end

local function evaluate(def, actor)
    if type(def) ~= "table" then
        return tonumber(def) or 0
    end
    local mode = def.mode
    if mode == "attribute" then
        return get_attr(actor, def.attribute)
    end
    if mode == "sum" then
        local total = 0
        for _, attr in ipairs(def.attributes or {}) do
            total = total + get_attr(actor, attr)
        end
        return total + (def.offset or 0)
    end
    if mode == "average" then
        local total = evaluate({ mode = "sum", attributes = def.attributes }, actor)
        local count = #(def.attributes or {})
        if count <= 0 then
            return def.offset or 0
        end
        return (total / count) + (def.offset or 0)
    end
    return tonumber(def.value) or 0
end

local function recalculate(actor)
    if not actor or not actor.stats then
        return
    end
    actor.stats.derived = {}
    for id, definition in pairs(core_stats.derived_definitions or {}) do
        local value = evaluate(definition, actor)
        if definition.round == "floor" then
            value = math.floor(value)
        elseif definition.round == "ceil" then
            value = math.ceil(value)
        elseif definition.round == "nearest" then
            value = math.floor(value + 0.5)
        end
        actor.stats.derived[id] = value
    end
end

return {
    get = get,
    recalculate = recalculate,
}