-- 医济 / Medica II — AoE heal (server fans out) + HoT on the primary target.
-- 范围持续恢复由服务器按实际队伍与半径传播。
HEAL_POTENCY = 250
HOT_DURATION = 15.0
HOT_POTENCY = 150

function doAction(player, in_combo)
    local HEAL_POTENCY = player:get_level() >= 85 and 250 or 200
    local HOT_POTENCY = player:get_level() >= 85 and 150 or 100
    effects = EffectsBuilder()
    effects:heal(player.parameters:calc_heal_amount(HEAL_POTENCY))
    effects:gain_hot_target(EFFECT_MEDICA_II_HOT, 0, HOT_DURATION, HOT_POTENCY)

    return effects
end
