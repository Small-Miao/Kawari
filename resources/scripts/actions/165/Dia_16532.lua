-- 天辉 / Dia — unaspected damage + DoT (status 1871, CN 7.51 Status sheet).
POTENCY = 85
DOT_DURATION = 30.0
DOT_POTENCY = 85
EFFECT_DIA_DOT = 1871 -- 天辉

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))
    effects:gain_dot(EFFECT_DIA_DOT, 0, DOT_DURATION, DOT_POTENCY)

    return effects
end
