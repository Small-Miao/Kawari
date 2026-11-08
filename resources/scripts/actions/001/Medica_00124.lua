-- 医治 / Medica — AoE heal; the server fans the heal out to nearby party members.
POTENCY = 400

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:heal(player.parameters:calc_heal_amount(POTENCY))

    return effects
end
