-- core_simulation/api.lua
-- Public API for world-state simulation, region management, squads, POIs, and event callbacks.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local simulation = {}
simulation.data = {}

local state = {
    registry = {},
}

simulation._state = state

--- Converts world coordinates into a region coordinate.
-- @param x number
-- @param z number
-- @return table|nil: { rx = number, rz = number }
function simulation.world_to_region(x, z)
    if state.registry and state.registry["world_to_region"] then
        return state.registry["world_to_region"](x, z)
    end
    return nil
end

--- Returns world bounds for a region coordinate.
-- @param rx number
-- @param rz number
-- @return table|nil: { minx, maxx, minz, maxz }
function simulation.region_to_world_bounds(rx, rz)
    if state.registry and state.registry["region_to_world_bounds"] then
        return state.registry["region_to_world_bounds"](rx, rz)
    end
    return nil
end

--- Retrieves the owner faction of a region.
-- @param rx number
-- @param rz number
-- @return string|nil
function simulation.get_region_owner(rx, rz)
    if state.registry and state.registry["get_region_owner"] then
        return state.registry["get_region_owner"](rx, rz)
    end
    return nil
end

--- Retrieves influence values for a region.
-- @param rx number
-- @param rz number
-- @return table
function simulation.get_region_influence(rx, rz)
    if state.registry and state.registry["get_region_influence"] then
        return state.registry["get_region_influence"](rx, rz)
    end
    return {}
end

--- Adds influence to a region for a faction.
-- @param rx number
-- @param rz number
-- @param faction_id string
-- @param delta number
-- @return boolean
function simulation.add_region_influence(rx, rz, faction_id, delta)
    if state.registry and state.registry["add_region_influence"] then
        return state.registry["add_region_influence"](rx, rz, faction_id, delta)
    end
    return false
end

--- Registers a callback for simulation events.
-- @param event_name string
-- @param fn function
-- @return boolean
function simulation.register_callback(event_name, fn)
    if state.registry and state.registry["register_callback"] then
        return state.registry["register_callback"](event_name, fn)
    end
    return false
end

--- Unregisters a previously registered callback.
-- @param event_name string
-- @param fn function
-- @return boolean
function simulation.unregister_callback(event_name, fn)
    if state.registry and state.registry["unregister_callback"] then
        return state.registry["unregister_callback"](event_name, fn)
    end
    return false
end

--- Registers a new POI in the simulation.
-- @param def table
-- @return table|nil
function simulation.register_poi(def)
    if state.registry and state.registry["register_poi"] then
        return state.registry["register_poi"](def)
    end
    return nil
end

--- Gets a POI by ID.
-- @param id string
-- @return table|nil
function simulation.get_poi(id)
    if state.registry and state.registry["get_poi"] then
        return state.registry["get_poi"](id)
    end
    return nil
end

--- Gets POIs in a region.
-- @param rx number
-- @param rz number
-- @return table
function simulation.get_pois_in_region(rx, rz)
    if state.registry and state.registry["get_pois_in_region"] then
        return state.registry["get_pois_in_region"](rx, rz)
    end
    return {}
end

--- Assigns a faction to a POI.
-- @param id string
-- @param faction_id string
-- @return boolean
function simulation.set_poi_faction(id, faction_id)
    if state.registry and state.registry["set_poi_faction"] then
        return state.registry["set_poi_faction"](id, faction_id)
    end
    return false
end

--- Updates the state of a POI.
-- @param id string
-- @param state table
-- @return boolean
function simulation.update_poi_state(id, state)
    if state.registry and state.registry["update_poi_state"] then
        return state.registry["update_poi_state"](id, state)
    end
    return false
end

--- Creates a new squad.
-- @param def table
-- @return table|nil
function simulation.create_squad(def)
    if state.registry and state.registry["create_squad"] then
        return state.registry["create_squad"](def)
    end
    return nil
end

--- Retrieves a squad by ID.
-- @param id string
-- @return table|nil
function simulation.get_squad(id)
    if state.registry and state.registry["get_squad"] then
        return state.registry["get_squad"](id)
    end
    return nil
end

--- Returns squads currently in a region.
-- @param rx number
-- @param rz number
-- @return table
function simulation.get_squads_in_region(rx, rz)
    if state.registry and state.registry["get_squads_in_region"] then
        return state.registry["get_squads_in_region"](rx, rz)
    end
    return {}
end

--- Redirects a squad to a new target region.
-- @param id string
-- @param target_region table
-- @return boolean
function simulation.set_squad_target(id, target_region)
    if state.registry and state.registry["set_squad_target"] then
        return state.registry["set_squad_target"](id, target_region)
    end
    return false
end

--- Destroys a squad.
-- @param id string
-- @return boolean
function simulation.destroy_squad(id)
    if state.registry and state.registry["destroy_squad"] then
        return state.registry["destroy_squad"](id)
    end
    return false
end

--- Returns the current world tick.
-- @return number
function simulation.get_tick()
    if state.registry and state.registry["get_tick"] then
        return state.registry["get_tick"]()
    end
    return 0
end

--- Registers a callback to run on each simulation tick.
-- @param callback function
-- @return boolean
function simulation.on_tick(callback)
    if state.registry and state.registry["on_tick"] then
        return state.registry["on_tick"](callback)
    end
    return false
end

--- Advances the simulation by one tick.
-- @return boolean
function simulation.force_step()
    if state.registry and state.registry["force_step"] then
        return state.registry["force_step"]()
    end
    return false
end

--- Registers an actor for region membership tracking.
-- @param actor_id string
-- @param faction_id string
-- @param pos table
-- @return boolean
function simulation.register_actor(actor_id, faction_id, pos)
    if state.registry and state.registry["register_actor"] then
        return state.registry["register_actor"](actor_id, faction_id, pos)
    end
    return false
end

--- Updates an actor's position within the simulation grid.
-- @param actor_id string
-- @param pos table
-- @return boolean
function simulation.update_actor_position(actor_id, pos)
    if state.registry and state.registry["update_actor_position"] then
        return state.registry["update_actor_position"](actor_id, pos)
    end
    return false
end

--- Unregisters an actor from simulation tracking.
-- @param actor_id string
-- @return boolean
function simulation.unregister_actor(actor_id)
    if state.registry and state.registry["unregister_actor"] then
        return state.registry["unregister_actor"](actor_id)
    end
    return false
end

return simulation
