-- core_data/internal/templates.lua
-- Template inheritance and expansion for data-driven definitions.

local function deepcopy(value)
    if core_foundation and core_foundation.util and core_foundation.util.deepcopy then
        return core_foundation.util.deepcopy(value)
    end
    if type(value) ~= "table" then
        return value
    end
    local cloned = {}
    for k, v in pairs(value) do
        cloned[k] = deepcopy(v)
    end
    return cloned
end

local function log_warning(message)
    if core_foundation and core_foundation.log and core_foundation.log.warn then
        core_foundation.log.warn(message, "core_data")
    else
        minetest.log("warning", message)
    end
end

--[[
Merge array values from override into base array.
Returns a new array with base elements followed by override elements.
]]
local function merge_lists(base, override)
    local merged = deepcopy(base)
    for _, value in ipairs(override) do
        table.insert(merged, deepcopy(value))
    end
    return merged
end

--[[
Check if a table is an array (numeric keys only, contiguous).
]]
local function is_array(tbl)
    if type(tbl) ~= "table" then
        return false
    end
    local count = 0
    for k, _ in pairs(tbl) do
        if type(k) ~= "number" then
            return false
        end
        count = count + 1
    end
    return count == #tbl and count > 0
end

--[[
Deep merge a table override into a base table.
- Non-table values are replaced
- Tables are recursively merged
- Arrays are merged by appending override elements
- The 'template' key is ignored
]]
local function deep_merge(base, override)
    assert(type(base) == "table", "deep_merge: base must be a table")
    assert(type(override) == "table", "deep_merge: override must be a table")
    
    local result = deepcopy(base)
    for key, value in pairs(override) do
        if key ~= "template" and type(value) == "table" and type(result[key]) == "table" then
            if is_array(result[key]) and is_array(value) then
                result[key] = merge_lists(result[key], value)
            else
                result[key] = deep_merge(result[key], value)
            end
        elseif key ~= "template" then
            result[key] = deepcopy(value)
        end
    end
    return result
end

--[[
Apply a template to a definition.
The definition inherits from the template, with definition fields overriding template fields.
If either parameter is not a table, a copy of the template (or definition) is returned.
]]
local function apply_template(def, template)
    assert(type(def) == "table" or type(template) == "table", "apply_template: at least one parameter must be a table")
    
    if type(template) ~= "table" then
        return deepcopy(def)
    end
    if type(def) ~= "table" then
        return deepcopy(template)
    end
    return deep_merge(template, def)
end

--[[
Expand all template references in a set of definitions.
When an entry has a 'template' field, it is merged with the template from template_table.
Entries without templates are returned as-is.
]]
local function expand_templates(defs, template_table)
    assert(type(defs) == "table", "expand_templates: defs must be a table")
    if type(template_table) ~= "table" then
        return deepcopy(defs)
    end

    local expanded = {}
    for id, def in pairs(defs) do
        if type(def) == "table" and def.template then
            local template = template_table[def.template]
            if template then
                expanded[id] = apply_template(def, template)
            else
                log_warning("Template not found: '" .. tostring(def.template) .. "' for definition '" .. tostring(id) .. "'")
                expanded[id] = deepcopy(def)
            end
        else
            expanded[id] = deepcopy(def)
        end
    end
    return expanded
end

return {
    apply_template = apply_template,
    expand_templates = expand_templates,
}