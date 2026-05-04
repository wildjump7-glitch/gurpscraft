-- core_simulation/internal/events.lua

local callbacks = {}

local function normalize_event(event_name)
    if type(event_name) ~= "string" then
        return nil
    end
    return event_name:lower()
end

local function register_callback(event_name, fn)
    event_name = normalize_event(event_name)
    if not event_name or type(fn) ~= "function" then
        return false
    end
    callbacks[event_name] = callbacks[event_name] or {}
    callbacks[event_name][fn] = true
    return true
end

local function unregister_callback(event_name, fn)
    event_name = normalize_event(event_name)
    if not event_name or type(fn) ~= "function" or not callbacks[event_name] then
        return false
    end
    callbacks[event_name][fn] = nil
    return true
end

local function dispatch_event(event_name, payload)
    event_name = normalize_event(event_name)
    if not event_name then
        return false
    end
    local handlers = callbacks[event_name]
    if type(handlers) ~= "table" then
        return false
    end
    for fn in pairs(handlers) do
        pcall(fn, payload)
    end
    return true
end

return {
    register_callback = register_callback,
    unregister_callback = unregister_callback,
    dispatch_event = dispatch_event,
}
