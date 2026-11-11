-- 一次解锁当前数据表中的全部可升级职业并设为 100 级。
required_rank = GM_RANK_DEBUG

function onCommand(player, args)
    if #args ~= 0 then
        printf(player, "用法：!job100")
        return
    end

    local jobs = player:get_levelable_classjobs()
    for _, id in ipairs(jobs) do
        player:unlock_classjob(id, true)
        player:set_classjob_level(id, 100)
    end
    printf(player, "已解锁 %d 项职业，并设置为 100 级。", #jobs)
end
