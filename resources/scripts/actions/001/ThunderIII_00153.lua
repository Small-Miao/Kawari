-- 暴雷 / Thunder III
-- Status constants are defined in Global.lua (EFFECT_THUNDER_III_DOT etc.).
-- DoT exclusivity and Thunderhead (云砧) consumption are handled server-side (servers/world/src/server/jobs/blm.rs).
POTENCY = 120
DOT_DURATION = 27.0
DOT_POTENCY = 50

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))
    effects:gain_dot(EFFECT_THUNDER_III_DOT, 0, DOT_DURATION, DOT_POTENCY)

    return effects
end
