-- core_magic/debug/cast_spell.lua

if not minetest.settings:get_bool("gurpscraft_enable_debug_tools", false) then
    return { enabled = false }
end

return { enabled = true }
