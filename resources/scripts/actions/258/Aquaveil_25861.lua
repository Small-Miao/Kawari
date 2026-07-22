-- 水流幕 / Aquaveil — 15% mitigation on the target.
DURATION = 8.0

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_effect(EFFECT_AQUAVEIL, 0, DURATION)

    return effects
end
