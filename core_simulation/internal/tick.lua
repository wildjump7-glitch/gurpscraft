-- core_simulation/internal/tick.lua

local events = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/events.lua")
local poi = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/poi.lua")
local squads = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/squads.lua")
local territory = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/territory.lua")
local grid = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/grid.lua")
local config = dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/internal/config.lua")

local current_tick = 0
local tick_callbacks = {}

local function get_tick()
    return current_tick
end

local function on_tick(callback)
    if type(callback) ~= "function" then
        return false
    end
    tick_callbacks[#tick_callbacks + 1] = callback
    return true
end

local function notify_tick()
    for _, callback in ipairs(tick_callbacks) do
        pcall(callback, current_tick)
    end
end

local function force_step()
    current_tick = current_tick + 1
    notify_tick()
    squads.move_squads()
    squads.resolve_region_conflicts()
    poi.tick_poi_alerts(current_tick)
    events.dispatch_event("ontick", { tick = current_tick })
    return true
end

local function step(dt)
    if type(dt) ~= "number" or dt <= 0 then
        return force_step()
    end
    return force_step()
end

return {
    get_tick = get_tick,
    on_tick = on_tick,
    force_step = force_step,
    step = step,
}
