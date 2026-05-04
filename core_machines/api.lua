-- core_machines/api.lua
-- Public API for machine definitions, power, automation, and multiblock systems.

local modpath = minetest.get_modpath(minetest.get_current_modname())

local machines = {}
machines.data = {}

local state = {
    registry = {},
    actor_state = {},
}

machines._state = state

machines.machine_logic = dofile(modpath .. "/internal/machine_logic.lua")
machines.power = dofile(modpath .. "/internal/power.lua")
machines.automation = dofile(modpath .. "/internal/automation.lua")
machines.multiblock = dofile(modpath .. "/internal/multiblock.lua")
machines.machine_fx = dofile(modpath .. "/internal/machine_fx.lua")

--- Registers a new machine definition.
-- @param machine_id string: Unique identifier for the machine
-- @param machine_data table: Machine configuration data
-- @return boolean: True if registration successful
function machines.register(machine_id, machine_data)
    assert(type(machine_id) == "string", "machine_id must be a string")
    assert(type(machine_data) == "table", "machine_data must be a table")
    if state.registry and state.registry["register"] then
        return state.registry["register"](machine_id, machine_data)
    end
    return false
end

--- Retrieves a machine definition by ID.
-- @param machine_id string: The machine identifier
-- @return table|nil: Machine data table if found, nil otherwise
function machines.get(machine_id)
    assert(type(machine_id) == "string", "machine_id must be a string")
    if state.registry and state.registry["get"] then
        return state.registry["get"](machine_id)
    end
    return nil
end

--- Returns all registered machines.
-- @return table: Table of all machine data keyed by machine_id
function machines.all()
    if state.registry and state.registry["all"] then
        return state.registry["all"]()
    end
    return {}
end

--- Processes a machine tick.
-- @param machine ObjectRef: The machine entity or node to process
-- @param dt number: Delta time in seconds
-- @return boolean: True if processing occurred successfully
function machines.process(machine, dt)
    assert(machine, "machine must be provided")
    assert(type(dt) == "number", "dt must be a number")
    if state.registry and state.registry["process"] then
        return state.registry["process"](machine, dt)
    end
    return false
end

--- Checks if a machine can begin processing.
-- @param machine ObjectRef: The machine entity or node
-- @return boolean: True if the machine can process
function machines.can_process(machine)
    assert(machine, "machine must be provided")
    if state.registry and state.registry["can_process"] then
        return state.registry["can_process"](machine)
    end
    return false
end

--- Starts a machine process.
-- @param machine ObjectRef: The machine entity or node
-- @param process_id string: The process identifier
-- @return boolean: True if process started successfully
function machines.start_process(machine, process_id)
    assert(machine, "machine must be provided")
    assert(type(process_id) == "string", "process_id must be a string")
    if state.registry and state.registry["start_process"] then
        return state.registry["start_process"](machine, process_id)
    end
    return false
end

--- Finishes a machine process.
-- @param machine ObjectRef: The machine entity or node
-- @param process_id string: The process identifier
-- @return boolean: True if process finished successfully
function machines.finish_process(machine, process_id)
    assert(machine, "machine must be provided")
    assert(type(process_id) == "string", "process_id must be a string")
    if state.registry and state.registry["finish_process"] then
        return state.registry["finish_process"](machine, process_id)
    end
    return false
end

--- Gets the current power state of a machine.
-- @param machine ObjectRef: The machine entity or node
-- @return number: Current power available
function machines.get_power(machine)
    assert(machine, "machine must be provided")
    if state.registry and state.registry["get_power"] then
        return state.registry["get_power"](machine)
    end
    return 0
end

--- Adds power to a machine.
-- @param machine ObjectRef: The machine entity or node
-- @param amount number: Power amount to add
-- @return boolean: True if power added successfully
function machines.add_power(machine, amount)
    assert(machine, "machine must be provided")
    assert(type(amount) == "number", "amount must be a number")
    if state.registry and state.registry["add_power"] then
        return state.registry["add_power"](machine, amount)
    end
    return false
end

--- Consumes power from a machine.
-- @param machine ObjectRef: The machine entity or node
-- @param amount number: Power amount to consume
-- @return boolean: True if power consumed successfully
function machines.consume_power(machine, amount)
    assert(machine, "machine must be provided")
    assert(type(amount) == "number", "amount must be a number")
    if state.registry and state.registry["consume_power"] then
        return state.registry["consume_power"](machine, amount)
    end
    return false
end

--- Checks if a machine is powered.
-- @param machine ObjectRef: The machine entity or node
-- @return boolean: True if powered
function machines.is_powered(machine)
    assert(machine, "machine must be provided")
    if state.registry and state.registry["is_powered"] then
        return state.registry["is_powered"](machine)
    end
    return false
end

--- Pushes items from a machine to adjacent inventories.
-- @param machine ObjectRef: The machine entity or node
-- @param itemstack ItemStack: The item stack to push
-- @return boolean: True if push succeeded
function machines.push_items(machine, itemstack)
    assert(machine, "machine must be provided")
    assert(type(itemstack) == "userdata", "itemstack must be an ItemStack")
    if state.registry and state.registry["push_items"] then
        return state.registry["push_items"](machine, itemstack)
    end
    return false
end

--- Pulls items into a machine from adjacent inventories.
-- @param machine ObjectRef: The machine entity or node
-- @param itemstack ItemStack: The item stack to pull
-- @return boolean: True if pull succeeded
function machines.pull_items(machine, itemstack)
    assert(machine, "machine must be provided")
    assert(type(itemstack) == "userdata", "itemstack must be an ItemStack")
    if state.registry and state.registry["pull_items"] then
        return state.registry["pull_items"](machine, itemstack)
    end
    return false
end

--- Sorts items within a machine or inventory.
-- @param machine ObjectRef: The machine entity or node
-- @return boolean: True if items sorted successfully
function machines.sort_items(machine)
    assert(machine, "machine must be provided")
    if state.registry and state.registry["sort_items"] then
        return state.registry["sort_items"](machine)
    end
    return false
end

--- Validates a multiblock machine structure.
-- @param structure table: Multiblock structure definition
-- @return boolean: True if multiblock structure is valid
function machines.validate_multiblock(structure)
    assert(type(structure) == "table", "structure must be a table")
    if state.registry and state.registry["validate_multiblock"] then
        return state.registry["validate_multiblock"](structure)
    end
    return false
end

--- Gets the center position of a multiblock structure.
-- @param structure table: Multiblock structure definition
-- @return table|nil: Center position {x, y, z} if valid, nil otherwise
function machines.get_multiblock_center(structure)
    assert(type(structure) == "table", "structure must be a table")
    if state.registry and state.registry["get_multiblock_center"] then
        return state.registry["get_multiblock_center"](structure)
    end
    return nil
end

--- Builds a multiblock structure in the world.
-- @param structure table: Multiblock structure definition
-- @param origin table: Origin position {x, y, z}
-- @return boolean: True if build succeeded
function machines.build_multiblock(structure, origin)
    assert(type(structure) == "table", "structure must be a table")
    assert(type(origin) == "table", "origin must be a table")
    if state.registry and state.registry["build_multiblock"] then
        return state.registry["build_multiblock"](structure, origin)
    end
    return false
end

--- Sets the runtime state for a machine.
-- @param machine ObjectRef: The machine entity or node
-- @param state_id string: State identifier
-- @return boolean: True if state set successfully
function machines.set_state(machine, state_id)
    assert(machine, "machine must be provided")
    assert(type(state_id) == "string", "state_id must be a string")
    if state.registry and state.registry["set_state"] then
        return state.registry["set_state"](machine, state_id)
    end
    return false
end

--- Gets the runtime state for a machine.
-- @param machine ObjectRef: The machine entity or node
-- @return string|nil: Current state identifier
function machines.get_state(machine)
    assert(machine, "machine must be provided")
    if state.registry and state.registry["get_state"] then
        return state.registry["get_state"](machine)
    end
    return nil
end

--- Updates a machine state on a tick.
-- @param machine ObjectRef: The machine entity or node
-- @param dt number: Delta time in seconds
-- @return boolean: True if state updated successfully
function machines.update_state(machine, dt)
    assert(machine, "machine must be provided")
    assert(type(dt) == "number", "dt must be a number")
    if state.registry and state.registry["update_state"] then
        return state.registry["update_state"](machine, dt)
    end
    return false
end

if minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    machines.machine_inspector = dofile(modpath .. "/debug/machine_inspector.lua")
    machines.spawn_machine = dofile(modpath .. "/debug/spawn_machine.lua")
end

return machines
