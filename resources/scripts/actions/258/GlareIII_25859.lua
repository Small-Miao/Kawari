POTENCY = 350

function doAction(player, in_combo)
    local POTENCY = player:get_level() >= 94 and 350 or 310
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))

    return effects
end
