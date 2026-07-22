-- 神速咏唱 / Presence of Mind — Glare IV stacks (闪飒预备) are granted server-side.
DURATION = 15.0

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_effect_self(EFFECT_PRESENCE_OF_MIND, 0, DURATION)

    return effects
end
