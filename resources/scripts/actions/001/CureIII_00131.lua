-- 愈疗 / Cure III — AoE heal centred on the target; the server fans the heal out.
POTENCY = 600

function doAction(player, in_combo)
    local POTENCY = player:get_level() >= 85 and 600 or 550
    effects = EffectsBuilder()
    effects:heal(player.parameters:calc_heal_amount(POTENCY))

    return effects
end
