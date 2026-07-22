-- 神祝祷 / Divine Benison — barrier worth 500 cure potency on the target.
BARRIER_POTENCY = 500
DURATION = 15.0

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_barrier(EFFECT_DIVINE_BENISON, 0, DURATION, player.parameters:calc_heal_amount(BARRIER_POTENCY))

    return effects
end
