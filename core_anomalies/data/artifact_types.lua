-- core_anomalies/data/artifact_types.lua
-- Artifact definitions: effects, rarity, stability

return {
    crystal = {
        id = 'crystal',
        name = 'Crystal',
        rarity = 'common',
        effect = 'light',
        stability = 100,
        description = 'Glows with inner light',
    },
    core = {
        id = 'core',
        name = 'Core',
        rarity = 'rare',
        effect = 'power',
        stability = 80,
        description = 'Contains unstable energy',
    },
    void_crystal = {
        id = 'void_crystal',
        name = 'Void Crystal',
        rarity = 'epic',
        effect = 'teleportation',
        stability = 60,
        description = 'Pulses with void energy',
    },
    gravity_orb = {
        id = 'gravity_orb',
        name = 'Gravity Orb',
        rarity = 'rare',
        effect = 'levitation',
        stability = 70,
        description = 'Defies gravity',
    },
    mind_shard = {
        id = 'mind_shard',
        name = 'Mind Shard',
        rarity = 'legendary',
        effect = 'psychic_boost',
        stability = 50,
        description = 'Whispers secrets',
    },
    dimensional_fragment = {
        id = 'dimensional_fragment',
        name = 'Dimensional Fragment',
        rarity = 'mythic',
        effect = 'phase_shift',
        stability = 40,
        description = 'Reality bends around it',
    },
}
