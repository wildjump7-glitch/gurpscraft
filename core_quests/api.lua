-- core_quests/api.lua
-- Public API for quest node registration, objective management, and progress reporting.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local quests = {}
quests.data = {}

local state = {
    registry = {},
}

quests._state = state

--- Registers a quest node with the ALife system.
-- @param node_def table
-- @return table|nil
function quests.register_quest_node(node_def)
    if state.registry and state.registry["register_quest_node"] then
        return state.registry["register_quest_node"](node_def)
    end
    return nil
end

--- Reports objective progress from an actor.
-- @param actor_id string
-- @param objective_id string
-- @param status string
-- @return boolean
function quests.report_progress(actor_id, objective_id, status)
    if state.registry and state.registry["report_progress"] then
        return state.registry["report_progress"](actor_id, objective_id, status)
    end
    return false
end

--- Retrieves an objective by ID.
-- @param objective_id string
-- @return table|nil
function quests.get_objective(objective_id)
    if state.registry and state.registry["get_objective"] then
        return state.registry["get_objective"](objective_id)
    end
    return nil
end

--- Retrieves objectives for a region.
-- @param rx number
-- @param rz number
-- @return table
function quests.get_objectives_for_region(rx, rz)
    if state.registry and state.registry["get_objectives_for_region"] then
        return state.registry["get_objectives_for_region"](rx, rz)
    end
    return {}
end

return quests
