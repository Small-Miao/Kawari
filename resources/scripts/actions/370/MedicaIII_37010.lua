-- 医养 / Medica III — AoE heal (server fans out) + HoT on the primary target.
-- TODO: the server does not fan the HoT out to the other heal targets yet.
HEAL_POTENCY = 250
HOT_DURATION = 15.0
HOT_POTENCY = 175

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:heal(player.parameters:calc_heal_amount(HEAL_POTENCY))
    effects:gain_hot_target(EFFECT_MEDICA_III_HOT, 0, HOT_DURATION, HOT_POTENCY)

    return effects
end
