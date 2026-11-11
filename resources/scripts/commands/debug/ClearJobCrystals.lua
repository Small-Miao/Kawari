required_rank = GM_RANK_DEBUG

function onCommand(player, args)
    if #args ~= 0 then
        printf(player, "用法：!clearjobcrystals")
        return
    end

    player:clear_job_crystals()
end
