-- 安慰之心 / Afflatus Solace — the lily is consumed server-side.
POTENCY = 800

function doAction(player, in_combo)
    local POTENCY = player:get_level() >= 85 and 800 or 700
    effects = EffectsBuilder()
    effects:heal(player.parameters:calc_heal_amount(POTENCY))

    return effects
end
