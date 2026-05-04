### **core_magic / DESIGN.md**

---

# **1. Purpose**

`core_magic` is the **unified supernatural, arcane, psionic, and ritual system** for the GURPScraft engine.  
It provides a **data‑driven, modular, extensible** framework for:

- Spell definitions  
- Spellcasting mechanics  
- Mana / energy systems  
- Rituals & long‑form magic  
- Magical schools & disciplines  
- Spell effects & interactions  
- Enchantments  
- Magical crafting  
- Psionics, miracles, chi, ki, anima, etc.  

This module contains **no game‑specific spells**, **no item definitions**, and **no lore**.  
It defines *how magic works*, not *what magic exists*.

---

# **2. Responsibilities**

### **2.1 Spell Registry**
Defines and manages spell types:
- Unique spell IDs  
- School/discipline  
- Casting time  
- Cost (mana, fatigue, materials, HP, sanity, etc.)  
- Range & area  
- Effects (via `core_effects`)  
- Skill requirements (via `core_stats`)  
- Ritual requirements (optional)  

Spells are fully data‑driven via:
```
core_magic/data/spells.lua
```

### **2.2 Mana / Energy System**
Supports multiple energy models:
- Mana pool  
- Fatigue‑based casting  
- Vancian slots  
- Psionic points  
- Divine favor  
- Anomalous charge  
- Hybrid systems  

Energy systems define:
- Max pool  
- Regen rate  
- Overload rules  
- Burnout / backlash  

### **2.3 Spellcasting Mechanics**
Implements:
- Instant spells  
- Channeled spells  
- Charged spells  
- Ritual spells  
- Area spells  
- Projectile spells  
- Touch spells  
- Summoning spells  
- Buffs / debuffs  
- Illusions  
- Teleportation (via `core_dimension`)  

Casting includes:
- Skill checks  
- Fumbles / miscasts  
- Concentration checks  
- Interruption rules  
- Line‑of‑sight checks  

### **2.4 Ritual Magic**
Supports:
- Long‑form rituals  
- Multi‑caster rituals  
- Material components  
- Circles, runes, glyphs  
- Environmental requirements  
- Time‑based casting  
- Risk tables  
- Backlash events  

Ritual definitions live in:
```
core_magic/data/rituals.lua
```

### **2.5 Magical Effects**
Integrates with:
- `core_effects` → particles, sounds, screen FX  
- `core_combat` → damage types  
- `core_stats` → stat modifiers  
- `core_survival` → temperature, radiation, diseases  
- `core_anomalies` → anomaly interactions  
- `core_physics` → movement, gravity, knockback  

### **2.6 Enchantments**
Supports:
- Permanent enchantments  
- Temporary enchantments  
- Item infusions  
- Rune slots  
- Magical durability  
- Curses  

Enchantments integrate with:
- `core_items` (item metadata)  
- `core_inventory` (equipment slots)  

### **2.7 Magical Crafting**
Implements:
- Spell scroll creation  
- Potion brewing  
- Rune carving  
- Artifact stabilization  
- Enchanted item crafting  

Crafting integrates with:
- `core_machines` (alchemical stations, forges)  
- `core_items` (materials)  

### **2.8 Integration with Other Modules**
- `core_stats` → skill checks, traits, resistances  
- `core_effects` → spell visuals  
- `core_combat` → magical damage  
- `core_survival` → magical hazards  
- `core_dimension` → teleportation, planar magic  
- `core_anomalies` → anomaly interactions  
- `core_machines` → magical crafting stations  

---

# **3. Non‑Responsibilities**

- No spell content  
- No lore  
- No item definitions  
- No worldgen  
- No UI  
- No actor AI  
- No faction logic  

This module only defines the mechanics of magic.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `minetest.add_particlespawner`
  - `minetest.sound_play`
  - `minetest.raycast`
  - `minetest.after`
  - `minetest.get_objects_inside_radius`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (spell definitions)
- `core_stats` (skill checks, traits)
- `core_effects` (visual/audio effects)
- `core_combat` (damage types)
- `core_survival` (hazards)
- `core_dimension` (teleportation)
- `core_anomalies` (interactions)
- `core_machines` (crafting)

---

# **5. Public API Surface**

All public functions are exposed via `core_magic/api.lua`.

### **5.1 Spell Registry**
- `magic.register_spell(id, def)`
- `magic.get_spell(id)`
- `magic.all_spells()`

### **5.2 Casting**
- `magic.cast(actor, spell_id, params)`
- `magic.can_cast(actor, spell_id)`
- `magic.get_cast_cost(actor, spell_id)`
- `magic.interrupt(actor)`

### **5.3 Mana / Energy**
- `magic.get_mana(actor)`
- `magic.set_mana(actor, value)`
- `magic.modify_mana(actor, delta)`
- `magic.get_mana_regen(actor)`
- `magic.apply_mana_regen(actor, dtime)`

### **5.4 Rituals**
- `magic.start_ritual(actor, ritual_id)`
- `magic.update_ritual(actor, dtime)`
- `magic.finish_ritual(actor)`
- `magic.abort_ritual(actor)`

### **5.5 Enchantments**
- `magic.apply_enchantment(itemstack, enchant_id)`
- `magic.remove_enchantment(itemstack, enchant_id)`
- `magic.get_enchantments(itemstack)`

### **5.6 Effects**
- `magic.apply_spell_effect(actor, spell_id, context)`
- `magic.apply_area_effect(pos, radius, spell_id, context)`

---

# **6. Internal Structure**

`core_magic/internal/` contains implementation details:

### **casting.lua**
- Casting flow  
- Skill checks  
- Interruptions  
- Miscasts  

### **mana.lua**
- Mana pool  
- Regen  
- Overload  
- Burnout  

### **rituals.lua**
- Ritual state machine  
- Multi‑caster logic  
- Backlash events  

### **effects.lua**
- Spell effect execution  
- Area effects  
- Projectile spells  

### **enchantments.lua**
- Enchantment application  
- Rune slots  
- Curses  

These files are not exposed directly.

---

# **7. Data Structure**

`core_magic/data/` contains:

### **spells.lua**
Example:
```lua
return {
  firebolt = {
    school = "pyromancy",
    cost = { mana = 10 },
    cast_time = 0.5,
    range = 20,
    effect = "firebolt_effect",
    damage = { amount = 15, type = "fire" },
  }
}
```

### **rituals.lua**
Example:
```lua
return {
  summon_spirit = {
    time = 60,
    components = { "spirit_candle", "silver_dust" },
    circle = "summoning_circle",
    effect = "summon_spirit_effect",
  }
}
```

### **enchantments.lua**
Example:
```lua
return {
  flaming = {
    effect = { damage_bonus = { fire = 5 } },
    glow = "orange",
  }
}
```

---

# **8. Debug Tools**

`core_magic/debug/` may include:

- `cast_spell.lua`
  - Cast any spell for testing  

- `ritual_test.lua`
  - Runs ritual sequences  

- `enchant_test.lua`
  - Applies enchantments to items  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses `minetest.raycast` for projectile spells.
- Uses `minetest.add_particlespawner` for visuals.
- Uses `minetest.sound_play` for spell audio.
- Uses globalstep for mana regen and ritual updates.
- Teleportation uses `core_dimension`.

---

# **10. Success Criteria**

`core_magic` is correct when:

- Spells are fully data‑driven.  
- Casting integrates cleanly with stats, effects, and combat.  
- Rituals work reliably and support multi‑caster logic.  
- Enchantments apply consistently to items.  
- Mana/energy systems are flexible and extensible.  
- No game‑specific content exists in this module.  

---

If you want to continue, say **continue** and I’ll generate the next module’s DESIGN.md (`core_crafting`).