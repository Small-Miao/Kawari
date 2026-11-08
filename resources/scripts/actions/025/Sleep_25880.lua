-- 催眠 / Sleep (target debuff, no damage)
-- Status constants are defined in Global.lua (EFFECT_SLEEP).
DURATION = 30.0

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_effect(EFFECT_SLEEP, 0, DURATION)

    return effects
end
