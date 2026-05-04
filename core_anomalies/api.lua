-- core_anomalies/api.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local anomalies = {}
anomalies.data = {}

local state = {
    registry = {},
    actor_state = {},
}

anomalies._state = state

anomalies.anomaly_logic = dofile(modpath .. "/internal/anomaly_logic.lua")
anomalies.artifact_spawner = dofile(modpath .. "/internal/artifact_spawner.lua")
anomalies.hazard_effects = dofile(modpath .. "/internal/hazard_effects.lua")

--- Public API: register.
function anomalies.register(...)
    if state.registry and state.registry["register"] then
        return state.registry["register"](...)
    end
    return nil
end

--- Public API: get.
function anomalies.get(...)
    if state.registry and state.registry["get"] then
        return state.registry["get"](...)
    end
    return nil
end

--- Public API: all.
function anomalies.all(...)
    if state.registry and state.registry["all"] then
        return state.registry["all"](...)
    end
    return nil
end

--- Public API: spawn.
function anomalies.spawn(...)
    if state.registry and state.registry["spawn"] then
        return state.registry["spawn"](...)
    end
    return nil
end

--- Public API: despawn.
function anomalies.despawn(...)
    if state.registry and state.registry["despawn"] then
        return state.registry["despawn"](...)
    end
    return nil
end

--- Public API: spawn_random.
function anomalies.spawn_random(...)
    if state.registry and state.registry["spawn_random"] then
        return state.registry["spawn_random"](...)
    end
    return nil
end

--- Public API: apply_hazard.
function anomalies.apply_hazard(...)
    if state.registry and state.registry["apply_hazard"] then
        return state.registry["apply_hazard"](...)
    end
    return nil
end

--- Public API: get_hazard_intensity.
function anomalies.get_hazard_intensity(...)
    if state.registry and state.registry["get_hazard_intensity"] then
        return state.registry["get_hazard_intensity"](...)
    end
    return nil
end

--- Public API: get_hazard_type.
function anomalies.get_hazard_type(...)
    if state.registry and state.registry["get_hazard_type"] then
        return state.registry["get_hazard_type"](...)
    end
    return nil
end

--- Public API: generate_artifact.
function anomalies.generate_artifact(...)
    if state.registry and state.registry["generate_artifact"] then
        return state.registry["generate_artifact"](...)
    end
    return nil
end

--- Public API: get_artifact_table.
function anomalies.get_artifact_table(...)
    if state.registry and state.registry["get_artifact_table"] then
        return state.registry["get_artifact_table"](...)
    end
    return nil
end

--- Public API: check_trigger.
function anomalies.check_trigger(...)
    if state.registry and state.registry["check_trigger"] then
        return state.registry["check_trigger"](...)
    end
    return nil
end

--- Public API: run_trigger.
function anomalies.run_trigger(...)
    if state.registry and state.registry["run_trigger"] then
        return state.registry["run_trigger"](...)
    end
    return nil
end

--- Public API: update.
function anomalies.update(...)
    if state.registry and state.registry["update"] then
        return state.registry["update"](...)
    end
    return nil
end

--- Public API: run_behavior.
function anomalies.run_behavior(...)
    if state.registry and state.registry["run_behavior"] then
        return state.registry["run_behavior"](...)
    end
    return nil
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    anomalies.anomaly_visualizer = dofile(modpath .. "/debug/anomaly_visualizer.lua")
    anomalies.spawn_anomaly = dofile(modpath .. "/debug/spawn_anomaly.lua")
end

return anomalies
