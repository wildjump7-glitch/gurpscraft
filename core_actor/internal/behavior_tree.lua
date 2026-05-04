-- core_actor/internal/behavior_tree.lua

local function get_behavior(actor)
    if type(actor) ~= "table" then
        return nil
    end
    return actor.behavior or "passive"
end

local function run_behavior(actor, dtime)
    if type(actor) ~= "table" or actor.state == "dead" then
        return false
    end

    local behavior = get_behavior(actor)
    actor.last_behavior = behavior

    local aggression = 0
    if core_actor and core_actor.data and core_actor.data.behaviors then
        local def = core_actor.data.behaviors[behavior]
        aggression = (def and def.aggression) or 0
    end

    actor.alertness = math.min((actor.alertness or 0) + aggression * 0.005 * (dtime or 0), 1)
    if actor.alertness >= 0.8 and actor.state == "idle" then
        actor.state = "alert"
    end

    return behavior
end

local function should_flee(actor)
    if type(actor) ~= "table" then
        return false
    end
    local hp = type(actor.hp) == "number" and actor.hp or 0
    local max_hp = type(actor.max_hp) == "number" and actor.max_hp or 100
    local low_health = hp < max_hp * 0.25
    local suppressed = (actor.suppression or 0) >= 0.5
    return low_health or suppressed
end

return {
    get_behavior = get_behavior,
    run_behavior = run_behavior,
    should_flee = should_flee,
}
