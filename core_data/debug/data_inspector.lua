-- core_data/debug/data_inspector.lua

local function dump_registry(name)
    if not core_data or type(core_data.new_registry) ~= "function" then
        return {}
    end
    if core_foundation and core_foundation.log and core_foundation.log.info then
        core_foundation.log.info("core_data debug requested registry dump for '" .. tostring(name) .. "'", "core_data")
    end
    return {}
end

local function list_missing_keys(schema, defs)
    local missing = {}
    if type(schema) ~= "table" or type(defs) ~= "table" then
        return missing
    end

    for def_id, def in pairs(defs) do
        if type(def) == "table" then
            for key, rule in pairs(schema) do
                local optional = type(rule) == "table" and rule.optional == true
                if def[key] == nil and not optional then
                    missing[def_id] = missing[def_id] or {}
                    table.insert(missing[def_id], key)
                end
            end
        end
    end

    return missing
end

return {
    dump_registry = dump_registry,
    list_missing_keys = list_missing_keys,
}