-- 冰封 / Blizzard III
-- Elemental stance is handled server-side (servers/world/src/server/jobs/blm.rs).
POTENCY = 290

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_MAGIC, player.parameters:calc_magical_damage(POTENCY))

    return effects
end
