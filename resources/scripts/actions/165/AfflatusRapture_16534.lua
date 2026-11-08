-- 狂喜之心 / Afflatus Rapture — AoE heal; the lily is consumed and the heal fanned out server-side.
POTENCY = 400

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:heal(player.parameters:calc_heal_amount(POTENCY))

    return effects
end
