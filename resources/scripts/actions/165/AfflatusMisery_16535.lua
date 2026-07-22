-- 苦难之心 / Afflatus Misery — AoE damage; the 50% falloff on secondary targets and the
-- Blood Lily consumption are handled server-side.
POTENCY = 1400

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))

    return effects
end
