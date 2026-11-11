required_rank = GM_RANK_DEBUG

function onCommand(player, args)
    if #args ~= 0 then
        printf(player, "用法：!init")
        return
    end

    for _, id in ipairs(player:get_levelable_classjobs()) do
        player:unlock_classjob(id, true)
        player:set_classjob_level(id, 100)
    end

    player:unlock_all()
    for _, id in ipairs({4, 14, 15}) do
        player:unlock(id)
    end

    -- 单独完成美容师任务，先走正常任务完成流程，再应用 skipintro 的全任务标记。
    player:finish_quest(65536 + 1210)
    player:finish_quest(65535)
    player:modify_currency(CURRENCY_GIL, 10000000)

    printf(player, "角色初始化完成，获得 1000 万金币。抵达利姆萨·罗敏萨后请重新登录。")
    player:change_territory(128, { x = 0.0, y = 40.0, z = 0.0 })
end
