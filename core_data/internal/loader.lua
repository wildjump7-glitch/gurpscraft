-- core_data/internal/loader.lua
-- File loading and registry management for data-driven content.

local function get_logger()
    if core_foundation and core_foundation.log then
        return core_foundation.log
    end
    return {
        warn = function(msg) minetest.log("warning", msg) end,
        error = function(msg) minetest.log("error", msg) end,
    }
end

local function copy_table(value)
    if core_foundation and core_foundation.util and core_foundation.util.deepcopy then
        return core_foundation.util.deepcopy(value)
    end
    if type(value) ~= "table" then
        return value
    end
    local cloned = {}
    for k, v in pairs(value) do
        cloned[k] = copy_table(v)
    end
    return cloned
end

local function merge_table(dst, src)
    for key, value in pairs(src) do
        dst[key] = value
    end
end

--[[
Load a single Lua file and return its table result.
Logs warnings if the file fails to load or doesn't return a table.
Returns an empty table on error.
]]
local function load_file(path)
    assert(type(path) == "string", "load_file: path must be a string")
    local logger = get_logger()
    local chunk, chunk_error = loadfile(path)
    if not chunk then
        logger.warn("core_data.load_file failed to load '" .. path .. "': " .. tostring(chunk_error))
        return {}
    end
    local success, result = pcall(chunk)
    if success then
        if type(result) ~= "table" then
            logger.warn("core_data.load_file expected table from '" .. path .. "'")
            return {}
        end
        return result
    end
    logger.warn("core_data.load_file failed to execute '" .. path .. "': " .. tostring(result))
    return {}
end

--[[
Load all .lua files from a directory and merge their results.
Files are loaded in sorted order and merged together.
Returns a single merged table.
]]
local function load_dir(path)
    assert(type(path) == "string", "load_dir: path must be a string")
    local logger = get_logger()
    local files = minetest.get_dir_list(path, false)
    table.sort(files)

    local merged = {}
    for _, filename in ipairs(files) do
        if filename:sub(-4) == ".lua" then
            local full_path = path .. "/" .. filename
            local loaded = load_file(full_path)
            if type(loaded) ~= "table" then
                logger.warn("core_data.load_dir skipped non-table file '" .. full_path .. "'")
            else
                merge_table(merged, loaded)
            end
        end
    end
    return merged
end

--[[
Create a new registry with register/get/all/validate methods.
A registry stores named entries and provides methods for:
- Registering new entries
- Retrieving entries by ID
- Getting all entries
- Validating entries against schemas
]]
local function new_registry(name)
    assert(type(name) == "string" or name == nil, "new_registry: name must be a string or nil")
    local logger = get_logger()
    local registry = {}
    local registry_name = tostring(name or "unnamed_registry")

    --[[
    Register an entry in the registry.
    Returns true on success, false if duplicate or invalid.
    ]]
    local function register(id, def)
        assert(id ~= nil, "register: id cannot be nil")
        assert(type(def) == "table", "register: def must be a table")
        local entry_id = tostring(id)
        if entry_id == "" then
            logger.warn("Registry '" .. registry_name .. "' rejected empty id")
            return false
        end
        if registry[entry_id] then
            logger.warn("Registry '" .. registry_name .. "' duplicate id '" .. entry_id .. "'")
            return false
        end
        registry[entry_id] = copy_table(def)
        return true
    end

    --[[
    Get a single entry from the registry by ID.
    Returns a deep copy of the entry, or nil if not found.
    ]]
    local function get(id)
        if id == nil then
            return nil
        end
        local entry = registry[tostring(id)]
        if entry == nil then
            return nil
        end
        return copy_table(entry)
    end

    --[[
    Get all entries from the registry as a merged table.
    Returns a deep copy of the entire registry.
    ]]
    local function all()
        return copy_table(registry)
    end

    --[[
    Validate all entries in the registry against a schema.
    Returns true if all entries pass, false otherwise.
    Logs warnings for each validation failure.
    ]]
    local function validate(schema_def)
        assert(type(schema_def) == "table", "validate: schema_def must be a table")
        if not core_data or type(core_data.validate) ~= "function" then
            logger.warn("Registry '" .. registry_name .. "' validate skipped: core_data.validate unavailable")
            return false
        end
        local ok = true
        for id, def in pairs(registry) do
            local valid = core_data.validate(def, schema_def, registry_name .. ":" .. id)
            if not valid then
                ok = false
            end
        end
        return ok
    end

    return {
        register = register,
        get = get,
        all = all,
        validate = validate,
    }
end

return {
    load_file = load_file,
    load_dir = load_dir,
    new_registry = new_registry,
}