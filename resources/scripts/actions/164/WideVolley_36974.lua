-- Wide Volley (BRD, ClassJob 23) - Level 25 weaponskill (circle AoE)
-- Potency: 140 (all targets in range; fan-out is server-side)
-- Retail Hawk's Eye proc raises this to 220; that bonus is deferred, base 140 here.
POTENCY = 140

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_PIERCING, player.parameters:calc_physical_damage(POTENCY))

    return effects
end
