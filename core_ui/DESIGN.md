### **core_ui / DESIGN.md**

---

# **1. Purpose**

`core_ui` provides the **unified user interface framework** for the GURPScraft engine.  
It defines the systems needed to display:

- HUD elements  
- Status effects  
- Notifications  
- Icon rendering  
- Modular UI components  
- Contextual overlays (combat, survival, anomalies, etc.)  

This module contains **no gameplay logic** and **no game‑specific UI**.  
It defines *how UI is drawn*, not *what the UI looks like* for any specific game.

---

# **2. Responsibilities**

### **2.1 HUD Framework**
Provides a modular HUD system that supports:
- Health  
- Stamina  
- Mana (if `core_magic` is present)  
- Ammo  
- Status effects  
- Compass / direction  
- Encumbrance indicators  
- Suppression indicators  

HUD elements are:
- Data‑driven  
- Toggleable  
- Layered  
- Scalable  

### **2.2 Status Effect Display**
Handles:
- Buff/debuff icons  
- Duration bars  
- Stacking effects  
- Priority sorting  
- Tooltip text  

Integrates with:
- `core_stats` (traits, modifiers)  
- `core_effects` (visual cues)  
- `core_survival` (temperature, hunger, thirst)  

### **2.3 Notifications**
Provides:
- On‑screen text notifications  
- Timed fade‑out  
- Priority levels  
- Sound cues (via `core_effects`)  

Examples:
- “You are encumbered”  
- “Weapon jammed”  
- “You feel cold”  
- “Faction reputation increased”  

### **2.4 Icon Registry**
Centralized icon management:
- Loads icons from textures  
- Provides icon lookup by ID  
- Ensures consistent sizing and scaling  
- Supports sprite sheets  

### **2.5 Contextual Overlays**
Supports overlays for:
- Combat hit markers  
- Damage direction indicators  
- Suppression blur  
- Magic charge indicators  
- Anomaly proximity warnings  
- Environmental hazards  

### **2.6 UI Component System**
Provides reusable UI components:
- Bars (health, stamina, mana)  
- Icons  
- Text blocks  
- Radial meters  
- Crosshairs  
- Hotbars  

These components are used by:
- HUD  
- Notifications  
- Debug tools  

### **2.7 Integration with Other Modules**
- `core_stats` → health, stamina, mana, derived stats  
- `core_inventory` → quickslots, equipment icons  
- `core_combat` → hit markers, suppression  
- `core_survival` → hunger, thirst, temperature  
- `core_effects` → screen overlays  
- `core_magic` → spell charge indicators  

---

# **3. Non‑Responsibilities**

- No gameplay logic  
- No combat logic  
- No inventory logic  
- No actor logic  
- No worldgen  
- No faction logic  
- No survival logic  

UI only *displays* information; it does not compute it.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `player:hud_add`
  - `player:hud_change`
  - `player:hud_remove`
  - `minetest.after`
  - `minetest.sound_play`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (icon definitions)
- `core_stats` (stat values)
- `core_inventory` (quickslots)
- `core_effects` (screen overlays)
- `core_survival` (needs)
- `core_combat` (combat indicators)

---

# **5. Public API Surface**

All public functions are exposed via `core_ui/api.lua`.

### **5.1 HUD Management**
- `ui.init_hud(player)`
- `ui.update_hud(player)`
- `ui.clear_hud(player)`
- `ui.set_hud_element(player, id, value)`
- `ui.get_hud_element(player, id)`

### **5.2 Status Effects**
- `ui.add_status_effect(player, effect_id, duration)`
- `ui.remove_status_effect(player, effect_id)`
- `ui.update_status_effects(player)`

### **5.3 Notifications**
- `ui.notify(player, message, level)`
- `ui.notify_icon(player, icon_id, message)`
- `ui.clear_notifications(player)`

### **5.4 Icons**
- `ui.register_icon(id, texture)`
- `ui.get_icon(id)`
- `ui.get_icon_texture(id)`

### **5.5 Overlays**
- `ui.show_overlay(player, overlay_id, params)`
- `ui.hide_overlay(player, overlay_id)`
- `ui.flash_overlay(player, overlay_id, duration)`

### **5.6 Components**
- `ui.create_bar(player, params)`
- `ui.update_bar(player, bar_id, value)`
- `ui.remove_bar(player, bar_id)`

---

# **6. Internal Structure**

`core_ui/internal/` contains implementation details:

### **hud.lua**
- HUD initialization  
- HUD element updates  
- Positioning & scaling  

### **status_effects.lua**
- Effect timers  
- Icon stacking  
- Tooltip text  

### **notifications.lua**
- Notification queue  
- Fade‑out logic  
- Priority sorting  

### **icons.lua**
- Icon registry  
- Texture lookup  
- Sprite sheet support  

### **overlays.lua**
- Screen overlays  
- Flash effects  
- Damage direction indicators  

These files are not exposed directly.

---

# **7. Data Structure**

`core_ui/data/` contains:

### **icons/**
A directory of icon textures.

### **hud_layout.lua**
Defines HUD layout positions.

Example:
```lua
return {
  health_bar = { x = 0.05, y = 0.9 },
  stamina_bar = { x = 0.05, y = 0.95 },
  quickslots = { x = 0.5, y = 0.95 },
}
```

### **status_effect_icons.lua**
Maps effect IDs to icons.

Example:
```lua
return {
  poisoned = "icon_poison.png",
  bleeding = "icon_bleed.png",
}
```

---

# **8. Debug Tools**

`core_ui/debug/` may include:

- `ui_test.lua`
  - Spawns test HUD elements  
  - Shows notifications  
  - Displays overlays  
  - Tests icon rendering  

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses `player:hud_add` for all HUD elements.
- Uses HUD flags for overlays.
- Uses `minetest.sound_play` for notification sounds.
- Must avoid excessive HUD updates (performance).
- Must handle player join/leave events gracefully.

---

# **10. Success Criteria**

`core_ui` is correct when:

- HUD elements update smoothly and consistently.
- Status effects display correctly with durations.
- Notifications appear and fade properly.
- Icons load reliably from data files.
- Overlays integrate with combat, survival, and magic.
- No gameplay logic exists in this module.

---
