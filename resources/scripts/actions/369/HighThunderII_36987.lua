-- 高震雷 / High Thunder II (AoE)
-- Status constants are defined in Global.lua (EFFECT_HIGH_THUNDER_II_DOT etc.).
-- DoT exclusivity and Thunderhead (云砧) consumption are handled server-side (servers/world/src/server/jobs/blm.rs).
POTENCY = 100
DOT_DURATION = 24.0
DOT_POTENCY = 40

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))
    effects:gain_dot(EFFECT_HIGH_THUNDER_II_DOT, 0, DOT_DURATION, DOT_POTENCY)

    return effects
end
