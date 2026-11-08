-- 节制 / Temperance — self healing-potency buff; party mitigation and 神爱抚预备 fan out server-side.
DURATION = 20.0

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_effect_self(EFFECT_TEMPERANCE_SELF, 0, DURATION)

    return effects
end
