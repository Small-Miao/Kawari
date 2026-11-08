-- 沉静 / Repose — sleep on the target.
DURATION = 30.0

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_effect(EFFECT_SLEEP, 0, DURATION)

    return effects
end
