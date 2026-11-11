-- 昏乱 / Addle
EFFECT_ADDLE = 1203

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_effect(EFFECT_ADDLE, 0, player:get_level() >= 98 and 15.0 or 10.0)

    return effects
end
