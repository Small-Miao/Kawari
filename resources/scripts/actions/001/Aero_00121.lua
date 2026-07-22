-- 疾风 / Aero — wind damage + wind DoT (status 143, CN 7.51 Status sheet).
POTENCY = 50
DOT_DURATION = 30.0
DOT_POTENCY = 30
EFFECT_AERO_DOT = 143 -- 疾风

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))
    effects:gain_dot(EFFECT_AERO_DOT, 0, DOT_DURATION, DOT_POTENCY)

    return effects
end
