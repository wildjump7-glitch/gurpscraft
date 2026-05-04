-- game_wasteland/anomalies/fields.lua

return {
    radiation = {
        id = 'radiation',
        effect = 'damage_over_time',
        magnitude = 0.3,
    },
    static = {
        id = 'static',
        effect = 'electrical_disruption',
        magnitude = 0.4,
    },
    toxic_gas = {
        id = 'toxic_gas',
        effect = 'poison',
        magnitude = 0.2,
    },
}
