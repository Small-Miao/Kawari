-- 耀星 / Flare Star (AoE)
-- The server fans the effect out to all targets in range; Astral Soul handling done in servers/world/src/server/jobs/blm.rs.
POTENCY = 500

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))

    return effects
end
