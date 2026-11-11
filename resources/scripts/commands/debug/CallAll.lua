required_rank = GM_RANK_DEBUG

function onCommand(player, args)
    if #args ~= 0 then
        printf(player, "用法：!callall")
        return
    end

    player:call_all()
    printf(player, "已提交全服玩家传送请求。")
end
