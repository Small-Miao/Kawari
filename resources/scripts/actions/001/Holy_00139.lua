-- 神圣 / Holy — AoE damage (server fans out) + stun on the target.
POTENCY = 140
STUN_DURATION = 4.0

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))
    effects:gain_effect(EFFECT_STUN, 0, STUN_DURATION)

    return effects
end
