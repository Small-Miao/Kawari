-- 法令 / Assize — AoE damage + AoE heal; the server fans the heal out to nearby party members.
POTENCY = 400
CURE_POTENCY = 400

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))
    effects:heal(player.parameters:calc_heal_amount(CURE_POTENCY))

    return effects
end
