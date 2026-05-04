-- core_anomalies/init.lua

local modpath = minetest.get_modpath(minetest.get_current_modname())

local api = dofile(modpath .. "/api.lua")

api.data = api.data or {}
api.data.anomaly_types = dofile(modpath .. "/data/anomaly_types.lua")
api.data.artifact_types = dofile(modpath .. "/data/artifact_types.lua")

local function register_module_functions(module)
    if type(module) ~= "table" then
        return
    end
    for key, value in pairs(module) do
        if type(value) == "function" then
            api._state.registry[key] = value
        end
    end
end

-- Register anomaly definitions at init time
if type(api.data.anomaly_types) == "table" then
    for anomaly_id, anomaly_def in pairs(api.data.anomaly_types) do
        api.anomaly_logic.register_anomaly(anomaly_id, anomaly_def)
    end
end

-- Register artifact definitions at init time
if type(api.data.artifact_types) == "table" then
    for artifact_id, artifact_def in pairs(api.data.artifact_types) do
        api.artifact_spawner.register_artifact(artifact_id, artifact_def)
    end
end

-- Register internal function modules
register_module_functions(api.anomaly_logic)
register_module_functions(api.artifact_spawner)
register_module_functions(api.hazard_effects)

core_anomalies = api

return core_anomalies
