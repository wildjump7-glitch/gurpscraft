-- core_worldgen/debug/regen_chunk.lua

if not minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    return { enabled = false }
end

return { enabled = true }
