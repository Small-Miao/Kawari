-- 医治 / Medica — AoE heal; the server fans the heal out to nearby party members.
POTENCY = 400

function doAction(player, in_combo)
    local POTENCY = player:get_level() >= 85 and 400 or 300
    effects = EffectsBuilder()
    effects:heal(player.parameters:calc_heal_amount(POTENCY))

    return effects
end
