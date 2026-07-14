-- Straight Shot (BRD, ClassJob 23) - Level 2 weaponskill
-- Potency: 200 (single target)
-- Retail gate "requires Hawk Eye or Barrage status" is deferred; damage is unconditional here.
POTENCY = 200

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:damage(DAMAGE_KIND_NORMAL, DAMAGE_TYPE_PIERCING, player.parameters:calc_physical_damage(POTENCY))

    return effects
end
