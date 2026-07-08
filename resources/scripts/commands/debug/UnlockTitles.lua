required_rank = GM_RANK_DEBUG
command_sender = "[unlocktitles] "

function onCommand(player, args, name)
    player:unlock_all_titles()
    printf(player, "All titles unlocked.")
end
