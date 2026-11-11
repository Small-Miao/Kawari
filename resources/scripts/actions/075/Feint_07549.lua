EFFECT_FEINT = 1195

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_effect(EFFECT_FEINT, 0, player:get_level() >= 98 and 15.0 or 10.0)

    return effects
end
