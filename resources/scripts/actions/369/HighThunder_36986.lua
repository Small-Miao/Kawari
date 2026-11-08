-- 高闪雷 / High Thunder
-- Status constants are defined in Global.lua (EFFECT_HIGH_THUNDER_DOT etc.).
-- DoT exclusivity and Thunderhead (云砧) consumption are handled server-side (servers/world/src/server/jobs/blm.rs).
POTENCY = 150
DOT_DURATION = 30.0
DOT_POTENCY = 60

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))
    effects:gain_dot(EFFECT_HIGH_THUNDER_DOT, 0, DOT_DURATION, DOT_POTENCY)

    return effects
end
