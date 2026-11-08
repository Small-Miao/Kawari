-- 秽浊 / Foul (AoE)
-- The server fans the effect out to all targets in range; Polyglot consumption handled in servers/world/src/server/jobs/blm.rs.
POTENCY = 600

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))

    return effects
end
