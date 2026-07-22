-- 无中生有 / Thin Air — MP cost removal is handled server-side.
DURATION = 12.0

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_effect_self(EFFECT_THIN_AIR, 0, DURATION)

    return effects
end
