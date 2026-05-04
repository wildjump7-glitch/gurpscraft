### **core_inventory / DESIGN.md**

---

# **1. Purpose**

`core_inventory` provides the **equipment, encumbrance, and item‑handling systems** for the GURPScraft engine.  
It extends Luanti’s built‑in inventory system with **RPG‑grade mechanics**:

- Equipment slots  
- Encumbrance & weight  
- Quickslots  
- Loadout management  
- Item validation  
- Integration with stats, combat, and survival  

This module contains **no item definitions** and **no combat logic**.  
It defines *how actors carry and equip items*, not what those items are.

---

# **2. Responsibilities**

### **2.1 Equipment Slot System**
Defines and manages equipment slots such as:
- `head`
- `torso`
- `legs`
- `feet`
- `hands`
- `weapon_primary`
- `weapon_secondary`
- `back`
- `accessory_1`, `accessory_2`

Slots are:
- Defined in data files  
- Fully customizable  
- Validated against item categories and tags  

### **2.2 Equipping & Unequipping**
Provides:
- Validation (can this item go in this slot?)  
- Automatic stat recalculation (via `core_stats`)  
- Attachment handling (via `core_items`)  
- Event hooks for other modules  

### **2.3 Weight & Encumbrance**
Tracks:
- Total carried weight  
- Equipped weight  
- Quickslot weight  
- Encumbrance thresholds (from `core_stats`)

Encumbrance affects:
- Movement speed (via `core_physics`)  
- Stamina drain (via `core_physics`)  
- Combat penalties (via `core_combat`)  

### **2.4 Quickslots**
Supports:
- Hotbar‑style quick access  
- Configurable number of slots  
- Weight and size restrictions  
- Item validation  

### **2.5 Inventory Validation**
Ensures:
- No invalid items in slots  
- No oversized items in quickslots  
- No equipping items without required traits/skills  
- No equipping multiple items in exclusive slots  

### **2.6 Loadout Management**
Supports:
- Saving loadouts  
- Loading loadouts  
- Validating loadouts  
- Applying loadouts to actors  

### **2.7 Integration with Other Modules**
- `core_stats` → stat modifiers from equipped items  
- `core_items` → item definitions & effects  
- `core_physics` → encumbrance effects  
- `core_combat` → weapon readiness  
- `core_actor` → actor equipment state  

---

# **3. Non‑Responsibilities**

- No item definitions (weapons, armor, etc.)  
- No crafting logic  
- No combat logic  
- No UI rendering  
- No worldgen item spawning  
- No faction or AI logic  

Those belong to other modules.

---

# **4. Dependencies**

### **External**
- Luanti API:
  - `player:get_inventory()`
  - `inv:set_stack()`
  - `inv:get_stack()`
  - `inv:add_item()`
  - `inv:remove_item()`

### **Internal**
- `core_foundation` (logging, utilities)
- `core_data` (slot definitions)
- `core_items` (item metadata)
- `core_stats` (stat modifiers)
- `core_physics` (encumbrance effects)

---

# **5. Public API Surface**

All public functions are exposed via `core_inventory/api.lua`.

### **5.1 Slot Management**
- `inventory.get_slots(actor)`
- `inventory.get_slot(actor, slot_id)`
- `inventory.set_slot(actor, slot_id, itemstack)`
- `inventory.clear_slot(actor, slot_id)`
- `inventory.is_valid_slot(slot_id)`

### **5.2 Equipping**
- `inventory.equip(actor, itemstack, slot_id)`
- `inventory.unequip(actor, slot_id)`
- `inventory.can_equip(actor, itemstack, slot_id)`
- `inventory.get_equipped(actor)`

### **5.3 Weight & Encumbrance**
- `inventory.get_total_weight(actor)`
- `inventory.get_equipped_weight(actor)`
- `inventory.get_encumbrance_level(actor)`
- `inventory.get_encumbrance_penalty(actor)`

### **5.4 Quickslots**
- `inventory.get_quickslots(actor)`
- `inventory.set_quickslot(actor, index, itemstack)`
- `inventory.clear_quickslot(actor, index)`
- `inventory.can_quickslot(actor, itemstack)`

### **5.5 Loadouts**
- `inventory.save_loadout(actor, id)`
- `inventory.load_loadout(actor, id)`
- `inventory.validate_loadout(actor, loadout_table)`

### **5.6 Validation**
- `inventory.validate_item_for_slot(item_id, slot_id)`
- `inventory.validate_actor_equipment(actor)`

---

# **6. Internal Structure**

`core_inventory/internal/` contains implementation details:

### **equipment_slots.lua**
- Slot definitions  
- Slot validation  
- Slot compatibility rules  

### **encumbrance.lua**
- Weight calculation  
- Encumbrance thresholds  
- Penalty calculation  

### **quickslots.lua**
- Quickslot validation  
- Quickslot indexing  

### **weight.lua**
- Weight lookup  
- Item weight caching  
- Actor weight aggregation  

These files are not exposed directly.

---

# **7. Data Structure**

`core_inventory/data/` contains:

### **slots.lua**
Defines equipment slots.

Example:
```lua
return {
  head = { type = "armor", tags = { "helmet" } },
  torso = { type = "armor", tags = { "vest", "robe" } },
  weapon_primary = { type = "weapon", two_handed = false },
  weapon_secondary = { type = "weapon" },
}
```

### **encumbrance.lua**
Defines thresholds.

Example:
```lua
return {
  light = 0.25,
  medium = 0.5,
  heavy = 0.75,
  max = 1.0,
}
```

---

# **8. Debug Tools**

`core_inventory/debug/` may include:

- `inventory_viewer.lua`
  - Chat command to inspect actor equipment
  - Shows weight, encumbrance, slot contents

- `slot_test.lua`
  - Validates slot definitions

---

# **9. Integration Notes (Luanti Compatibility)**

- Uses Luanti’s built‑in inventory system for storage.
- Equipment slots are stored in:
  - Player metadata  
  - Entity metadata  
  - Or a dedicated detached inventory  
- Weight and encumbrance calculations run on:
  - Equip/unequip  
  - Inventory changes  
  - Actor initialization  

---

# **10. Success Criteria**

`core_inventory` is correct when:

- Actors can equip and unequip items safely.
- Weight and encumbrance update automatically.
- Quickslots behave consistently.
- Loadouts can be saved and restored.
- No game‑specific content exists in this module.
- Other modules (combat, physics, stats) can rely on inventory data without modification.

---
