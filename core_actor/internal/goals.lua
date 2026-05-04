-- core_actor/internal/goals.lua

local function contains_tag(list, value)
    if type(list) ~= "table" or type(value) ~= "string" then
        return false
    end
    for _, item in ipairs(list) do
        if item == value then
            return true
        end
    end
    return false
end

local function convert_objective_to_goal(objective)
    if type(objective) ~= "table" or type(objective.id) ~= "string" or type(objective.type) ~= "string" then
        return nil
    end
    return {
        id = objective.id,
        type = objective.type,
        target = objective.target,
        radius = type(objective.radius) == "number" and objective.radius or 4,
        priority = type(objective.priority) == "number" and objective.priority or 0,
        status = "pending",
        created_at = objective.created_at_tick,
        faction_tags = type(objective.faction_tags) == "table" and objective.faction_tags or {},
    }
end

local function evaluate_objective(actor, objective)
    if type(actor) ~= "table" or type(objective) ~= "table" or actor.state == "dead" then
        return false
    end
    if objective.faction_tags and next(objective.faction_tags) then
        if not contains_tag(objective.faction_tags, actor.faction) then
            return false
        end
    end
    if type(objective.priority) ~= "number" then
        objective.priority = 0
    end
    if type(core_factions) == "table" and type(core_factions.get_objective_priority_modifier) == "function" then
        objective.effective_priority = objective.priority + core_factions.get_objective_priority_modifier(actor.faction, objective)
    else
        objective.effective_priority = objective.priority
    end
    if objective.effective_priority < 0 then
        return false
    end
    return true
end

local function assign_objective(actor, objective)
    if type(actor) ~= "table" or type(objective) ~= "table" then
        return false
    end
    if not evaluate_objective(actor, objective) then
        return false
    end
    actor.current_objective = objective
    actor.current_goal = convert_objective_to_goal(objective)
    actor.state = "evaluatingobjective"
    return true
end

local function join_squad(actor, squad_id)
    if type(actor) ~= "table" or type(squad_id) ~= "string" then
        return false
    end
    actor.squad_id = squad_id
    return true
end

local function leave_squad(actor)
    if type(actor) ~= "table" then
        return false
    end
    actor.squad_id = nil
    return true
end

local function get_all_actors()
    if type(core_actor) ~= "table" or type(core_actor.actor_state) ~= "table" or type(core_actor.actor_state.list_actors) ~= "function" then
        return {}
    end
    return core_actor.actor_state.list_actors()
end

local function broadcast_objective(faction_id, objective)
    if type(objective) ~= "table" then
        return 0
    end
    local count = 0
    for _, candidate in ipairs(get_all_actors()) do
        if type(candidate.region) == "table" and type(objective.region) == "table" then
            if candidate.region.rx == objective.region.rx and candidate.region.rz == objective.region.rz then
                if objective.faction_tags and next(objective.faction_tags) and not contains_tag(objective.faction_tags, candidate.faction) then
                    goto skip_actor
                end
                if faction_id and faction_id ~= "" and type(candidate.faction) == "string" and candidate.faction ~= faction_id then
                    goto skip_actor
                end
                if assign_objective(candidate, objective) then
                    count = count + 1
                end
            end
        end
        ::skip_actor::
    end
    return count
end

local function report_progress(actor, objective_id, status)
    if type(actor) ~= "table" or type(objective_id) ~= "string" or type(status) ~= "string" then
        return false
    end
    if actor.current_objective and actor.current_objective.id == objective_id then
        actor.current_goal = actor.current_goal or {}
        actor.current_goal.status = status
    end
    if type(core_quests) == "table" and type(core_quests.report_progress) == "function" then
        core_quests.report_progress(actor.id, objective_id, status)
    end
    return true
end

local function mark_goal_complete(actor)
    if type(actor) ~= "table" then
        return false
    end
    if actor.current_goal then
        actor.current_goal.status = "completed"
    end
    if actor.current_objective then
        actor.current_objective.status = "completed"
    end
    actor.state = "idle"
    actor.current_goal = nil
    actor.current_objective = nil
    return true
end

local function get_target_position(goal)
    if type(goal) ~= "table" or type(goal.target) ~= "table" then
        return nil
    end
    return goal.target.pos
end

local function process_goals(actor, dtime)
    if type(actor) ~= "table" then
        return false
    end
    if actor.state == "dead" then
        return false
    end
    if not actor.current_goal then
        if actor.state ~= "idle" then
            actor.state = "idle"
        end
        return true
    end

    local goal = actor.current_goal
    if actor.state == "evaluatingobjective" then
        local target = get_target_position(goal)
        if target then
            if type(core_actor) == "table" and type(core_actor.pathfind) == "function" then
                core_actor.pathfind(actor, target)
            end
            actor.state = "movingtoobjective"
            goal.status = "in_progress"
        end
        return true
    end

    if actor.state == "movingtoobjective" then
        local target = get_target_position(goal)
        if target and type(core_actor) == "table" and type(core_actor.move_towards) == "function" then
            core_actor.move_towards(actor, target)
            if type(actor.position) == "table" and type(goal.radius) == "number" then
                local dx = (actor.position.x or 0) - (target.x or 0)
                local dz = (actor.position.z or 0) - (target.z or 0)
                if math.sqrt(dx * dx + dz * dz) <= goal.radius then
                    actor.state = "executingobjective"
                end
            end
        end
        return true
    end

    if actor.state == "executingobjective" then
        if goal.type == "patrol" then
            actor.state = "patrol"
            return true
        end
        mark_goal_complete(actor)
        return true
    end

    if actor.state == "patrol" then
        actor.alertness = math.min((actor.alertness or 0) + 0.01 * (dtime or 0), 1)
        return true
    end

    if actor.state == "flee" then
        local target = get_target_position(goal)
        if target and type(core_actor) == "table" and type(core_actor.move_away) == "function" then
            core_actor.move_away(actor, target)
        end
        return true
    end

    return true
end

return {
    evaluate_objective = evaluate_objective,
    assign_objective = assign_objective,
    report_progress = report_progress,
    process_goals = process_goals,
    join_squad = join_squad,
    leave_squad = leave_squad,
    broadcast_objective = broadcast_objective,
}
