-- 真北：身位判定读取状态 1250；充能使用 Action 表中的两层。
function doAction(player, in_combo)
    local effects = EffectsBuilder()
    effects:gain_effect_self(1250, 0, 10.0)
    return effects
end
