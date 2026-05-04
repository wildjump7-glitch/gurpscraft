-- core_magic/data/spells.lua

return {
    fireball = {
        id = 'fireball',
        name = 'Fireball',
        mana_cost = 25,
        effect_id = 'fire_explosion',
        area = true,
        damage = 30,
        range = 15,
        radius = 3,
        power = 1,
    },
    heal = {
        id = 'heal',
        name = 'Heal',
        mana_cost = 15,
        effect_id = 'healing_wave',
        heal_amount = 20,
        range = 5,
        power = 1,
    },
}
