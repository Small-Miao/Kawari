-- 浴血：吸血结算由公共直接物理伤害入口负责。
function doAction(player, in_combo)
    local effects = EffectsBuilder()
    effects:gain_effect_self(84, 0, 20.0)
    return effects
end
