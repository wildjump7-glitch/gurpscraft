-- core_ui/data/status_effect_icons.lua
-- Status effect icon and color definitions

return {
    poisoned = {
        id = 'poisoned',
        icon = 'poison.png',
        color = '#00AA00',
        name = 'Poisoned',
        priority = 5,
    },
    bleeding = {
        id = 'bleeding',
        icon = 'blood.png',
        color = '#AA0000',
        name = 'Bleeding',
        priority = 8,
    },
    stunned = {
        id = 'stunned',
        icon = 'stun.png',
        color = '#FFFF00',
        name = 'Stunned',
        priority = 10,
    },
    frozen = {
        id = 'frozen',
        icon = 'frost.png',
        color = '#00FFFF',
        name = 'Frozen',
        priority = 9,
    },
    burning = {
        id = 'burning',
        icon = 'fire.png',
        color = '#FF6600',
        name = 'Burning',
        priority = 9,
    },
    blessed = {
        id = 'blessed',
        icon = 'blessing.png',
        color = '#FFFF99',
        name = 'Blessed',
        priority = 3,
    },
    cursed = {
        id = 'cursed',
        icon = 'curse.png',
        color = '#663366',
        name = 'Cursed',
        priority = 7,
    },
    haste = {
        id = 'haste',
        icon = 'haste.png',
        color = '#0099FF',
        name = 'Haste',
        priority = 3,
    },
    slow = {
        id = 'slow',
        icon = 'slow.png',
        color = '#666699',
        name = 'Slowed',
        priority = 6,
    },
}
