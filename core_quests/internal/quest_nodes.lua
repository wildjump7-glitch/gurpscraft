-- core_quests/internal/quest_nodes.lua

local quest_nodes = {}
local objectives = {}
local event_subscribed = false

local function normalize_table(value)
    if type(value) == "table" then
        return value
    end
    return {}
end

local function contains_value(list, value)
    if type(list) ~= "table" then
        return false
    end
    for _, item in ipairs(list) do
        if item == value then
            return true
        end
    end
    return false
end

local function make_objective_id(base)
    local suffix = tostring(math.floor(math.random() * 1000000))
    return string.format("%s_%s", base or "objective", suffix)
end

local function get_region_center(region)
    if type(region) ~= "table" or type(region.rx) ~= "number" or type(region.rz) ~= "number" then
        return nil
    end
    local bounds = core_simulation.region_to_world_bounds(region.rx, region.rz)
    if not bounds then
        return nil
    end
    return {
        x = bounds.minx + math.floor((bounds.maxx - bounds.minx) / 2),
        y = 0,
        z = bounds.minz + math.floor((bounds.maxz - bounds.minz) / 2),
    }
end

local function add_objective(node, objective)
    if type(objective) ~= "table" or type(objective.id) ~= "string" then
        return nil
    end
    objective.status = "active"
    objective.created_at_tick = core_simulation.get_tick()
    objective.last_updated_tick = objective.created_at_tick
    objective.region = objective.region or node.region
    objective.faction_tags = normalize_table(objective.faction_tags)
    objectives[objective.id] = objective
    if type(core_actor) == "table" and type(core_actor.broadcast_objective) == "function" then
        core_actor.broadcast_objective(objective.faction_id or "", objective)
    end
    return objective
end

local function get_objective(objective_id)
    if type(objective_id) ~= "string" then
        return nil
    end
    return objectives[objective_id]
end

local function get_objectives_for_region(rx, rz)
    local result = {}
    for _, objective in pairs(objectives) do
        if objective.region and objective.region.rx == rx and objective.region.rz == rz then
            result[#result + 1] = objective
        end
    end
    return result
end

local function expire_stale_objectives(tick)
    for _, objective in pairs(objectives) do
        if objective.status == "active" and type(objective.last_updated_tick) == "number" and tick - objective.last_updated_tick >= 10 then
            objective.status = "expired"
        end
    end
end

local function update_poi_alert(node)
    if not node.poi_id or type(core_simulation.update_poi_state) ~= "function" then
        return
    end
    local poi = core_simulation.get_poi(node.poi_id)
    if not poi then
        return
    end
    local alert_level = poi.state and poi.state.alert_level or 0
    alert_level = math.min(1, alert_level + 0.05)
    core_simulation.update_poi_state(node.poi_id, { alert_level = alert_level })
end

local function build_region_objective(node, event_type, payload)
    local objective = {
        id = make_objective_id(node.id),
        type = "investigate",
        target = { pos = node.region and get_region_center(node.region) or { x = 0, y = 0, z = 0 } },
        radius = 16,
        priority = 1,
        faction_tags = normalize_table(node.faction_tags),
    }

    if event_type == "onpoicaptured" and payload and payload.poi then
        objective.type = "interact"
        objective.target = { pos = payload.poi.pos }
        objective.priority = 3
    elseif event_type == "onterritorychanged" then
        objective.type = "patrol"
        objective.priority = 2
    elseif event_type == "onregionconflict" then
        objective.type = "goto"
        objective.target = { pos = get_region_center(payload.region) }
        objective.priority = 4
    elseif event_type == "onsquadcreated" then
        objective.type = "investigate"
        objective.priority = 2
    elseif event_type == "onsquaddestroyed" then
        objective.type = "flee"
        objective.priority = 1
    end

    return objective
end

local function handle_simulation_event(name, payload)
    for _, node in pairs(quest_nodes) do
        local matches = false
        if node.region and payload and type(payload.rx) == "number" and type(payload.rz) == "number" then
            matches = node.region.rx == payload.rx and node.region.rz == payload.rz
        end
        if not matches and node.poi_id and payload and payload.poi and payload.poi.id == node.poi_id then
            matches = true
        end
        if matches then
            local objective = build_region_objective(node, name, payload)
            if objective then
                objective.region = node.region
                add_objective(node, objective)
            end
        end
    end
end

local function register_event_handlers()
    if event_subscribed or type(core_simulation) ~= "table" then
        return
    end
    local events = {
        onterritorychanged = "onterritorychanged",
        onpoicaptured = "onpoicaptured",
        onregionconflict = "onregionconflict",
        onsquadcreated = "onsquadcreated",
        onsquaddestroyed = "onsquaddestroyed",
    }
    for event_name, normalized in pairs(events) do
        core_simulation.register_callback(event_name, function(payload)
            handle_simulation_event(normalized, payload)
        end)
    end
    if type(core_simulation.on_tick) == "function" then
        core_simulation.on_tick(function(tick)
            for _, node in pairs(quest_nodes) do
                update_poi_alert(node)
            end
            expire_stale_objectives(tick)
        end)
    end
    event_subscribed = true
end

local function register_quest_node(node_def)
    if type(node_def) ~= "table" or type(node_def.id) ~= "string" then
        return nil
    end
    if type(core_simulation) ~= "table" or type(core_simulation.register_callback) ~= "function" then
        return nil
    end

    local node = {
        id = node_def.id,
        poi_id = type(node_def.poi_id) == "string" and node_def.poi_id or nil,
        region = nil,
        faction_id = type(node_def.faction_id) == "string" and node_def.faction_id or nil,
        faction_tags = normalize_table(node_def.faction_tags),
        last_tick = 0,
    }

    if type(node_def.region) == "table" and type(node_def.region.rx) == "number" and type(node_def.region.rz) == "number" then
        node.region = { rx = node_def.region.rx, rz = node_def.region.rz }
    elseif type(node_def.pos) == "table" and type(node_def.pos.x) == "number" and type(node_def.pos.z) == "number" then
        node.region = core_simulation.world_to_region(node_def.pos.x, node_def.pos.z)
    end

    if node.poi_id and type(core_simulation.register_poi) == "function" then
        core_simulation.register_poi({
            id = node.poi_id,
            pos = type(node_def.pos) == "table" and node_def.pos or { x = 0, y = 0, z = 0 },
            faction_id = node.faction_id,
            tags = normalize_table(node_def.tags),
            strategic_value = type(node_def.strategic_value) == "number" and node_def.strategic_value or 0,
            metadata = type(node_def.metadata) == "table" and node_def.metadata or {},
        })
    end

    quest_nodes[node.id] = node
    register_event_handlers()
    return node
end

local function report_progress(actor_id, objective_id, status)
    if type(actor_id) ~= "string" or type(objective_id) ~= "string" or type(status) ~= "string" then
        return false
    end
    local objective = get_objective(objective_id)
    if not objective then
        return false
    end
    objective.status = status
    objective.last_updated_tick = core_simulation.get_tick()
    return true
end

return {
    register_quest_node = register_quest_node,
    report_progress = report_progress,
    get_objective = get_objective,
    get_objectives_for_region = get_objectives_for_region,
}
