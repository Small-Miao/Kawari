-- 礼仪之铃（引爆） / Liturgy of the Bell (detonate)
-- Sent by the CN 7.51 client when the bell button is pressed while a bell is active.
-- The Action sheet row for 28507 is an unrelated name; the client sends this id regardless.
-- Detonation (heal 200 potency x remaining stacks, status removal, bell NPC despawn) is
-- handled server-side (servers/world/src/server/jobs/white_mage.rs).

function doAction(player, in_combo)
    effects = EffectsBuilder()

    return effects
end
