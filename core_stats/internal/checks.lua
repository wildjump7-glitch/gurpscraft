-- core_stats/internal/checks.lua
-- GURPS-style 3d6 roll-under checks, contests, and opposed rolls.

--[[
Roll 3d6 (three six-sided dice).
Returns a value from 3 to 18.
]]
local function roll_3d6()
    return math.random(1, 6) + math.random(1, 6) + math.random(1, 6)
end

--[[
Perform a 3d6 roll-under check against a target value.
roll = 3d6
target = value + modifier
success = roll <= target
margin = target - roll (positive margin = better success)

Returns: success (bool), roll (number), target (number), margin (number)
]]
local function check_value(value, modifier)
    assert(type(value) == "number" or type(tonumber(value)) == "number", "check_value: value must be numeric")
    local roll = roll_3d6()
    local target = (tonumber(value) or 0) + (tonumber(modifier) or 0)
    local success = roll <= target
    local margin = target - roll
    return success, roll, target, margin
end

--[[
Perform a 3d6 check against an actor attribute.
Looks up the attribute value and performs a check.
Inherits margin-based resolution from check_value.
]]
local function check_attribute(actor, attr_id, modifier)
    assert(type(actor) == "table", "check_attribute: actor must be a table")
    assert(type(attr_id) == "string", "check_attribute: attr_id must be a string")
    local value = core_stats.get_attribute(actor, attr_id)
    return check_value(value, modifier)
end

--[[
Perform a 3d6 check against an actor skill.
Looks up the skill value and performs a check.
]]
local function check_skill(actor, skill_id, modifier)
    assert(type(actor) == "table", "check_skill: actor must be a table")
    assert(type(skill_id) == "string", "check_skill: skill_id must be a string")
    local value = core_stats.get_skill(actor, skill_id)
    return check_value(value, modifier)
end

--[[
Standard contest between two actors.
Both actors roll against a skill (or attribute).
Winner is determined by:
1. If only one succeeds: that one wins
2. If both succeed or both fail: winner is the one with the larger margin
3. If margins are equal: tie

Returns:
  winner: "A", "B", or "tie"
  details: table with roll and margin information for debugging
]]
local function contest(actorA, actorB, skill_id)
    assert(type(actorA) == "table", "contest: actorA must be a table")
    assert(type(actorB) == "table", "contest: actorB must be a table")
    assert(type(skill_id) == "string", "contest: skill_id must be a string")
    
    local success_a, roll_a, target_a, margin_a = check_skill(actorA, skill_id)
    local success_b, roll_b, target_b, margin_b = check_skill(actorB, skill_id)
    
    -- Only A succeeds
    if success_a and not success_b then
        return "A", { roll_a = roll_a, roll_b = roll_b, target_a = target_a, target_b = target_b }
    end
    
    -- Only B succeeds
    if success_b and not success_a then
        return "B", { roll_a = roll_a, roll_b = roll_b, target_a = target_a, target_b = target_b }
    end
    
    -- Both succeed or both fail: compare margins
    if margin_a > margin_b then
        return "A", { margin_a = margin_a, margin_b = margin_b, roll_a = roll_a, roll_b = roll_b }
    end
    if margin_b > margin_a then
        return "B", { margin_a = margin_a, margin_b = margin_b, roll_a = roll_a, roll_b = roll_b }
    end
    
    -- Margins are equal
    return "tie", { margin_a = margin_a, margin_b = margin_b, roll_a = roll_a, roll_b = roll_b }
end

--[[
Quick contest between two actors.
In current implementation, identical to standard contest.
May be differentiated in future rule variants.
]]
local function quick_contest(actorA, actorB, skill_id)
    return contest(actorA, actorB, skill_id)
end

return {
    check_value = check_value,
    check_attribute = check_attribute,
    check_skill = check_skill,
    contest = contest,
    quick_contest = quick_contest,
}