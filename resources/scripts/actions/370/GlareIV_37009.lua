-- 闪飒 / Glare IV — AoE damage; the 40% falloff on secondary targets and the
-- 闪飒预备 stack consumption are handled server-side.
POTENCY = 640

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))

    return effects
end
