POTENCY = 450

function doAction(player, in_combo)
    local POTENCY = player:get_level() >= 85 and 500 or 450
    effects = EffectsBuilder()
    effects:heal(player.parameters:calc_heal_amount(POTENCY))

    return effects
end
