POTENCY = 800

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:heal(player.parameters:calc_heal_amount(player:get_level() >= 94 and POTENCY or 500))

    return effects
end
