-- 魔罩 / Manaward (self shield)
-- Status constants are defined in Global.lua (EFFECT_MANAWARD).
-- gain_barrier_self(effect_id, param, duration, absolute_amount); shield = 30% of max HP, see RadiantAegis_025799.lua.
DURATION = 20.0
SHIELD_PERCENT = 30

function doAction(player, in_combo)
    effects = EffectsBuilder()
    effects:gain_barrier_self(EFFECT_MANAWARD, 0, DURATION, math.floor(player.parameters:max_hp() * SHIELD_PERCENT / 100))

    return effects
end
