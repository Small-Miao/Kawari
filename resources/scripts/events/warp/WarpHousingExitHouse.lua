-- 个人住宅共用的离开事件。

-- Scenes
SCENE_EXIT_PROMPT = 00000 -- "Leave the estate hall?" prompt

function onTalk(target, player)
    player:play_scene(SCENE_EXIT_PROMPT, HIDE_HOTBAR, {})
end

function onReturn(scene, results, player)
    local LEAVE_HOUSE <const> = 1
    if results[1] == LEAVE_HOUSE then
        player:finish_event()
        if player:leave_estate() then
            return
        end
        -- 无住宅地址的旧预览室内使用城市入口。
        local INTERIORS_TO_TOWN <const> = {
            -- Mist cottage, house, mansion to Limsa Lominsa Lower Decks
            [282] = 8,
            [283] = 8,
            [284] = 8,

            -- The Lavender Beds cottage, house, mansion to New Gridania
            [342] = 2,
            [343] = 2,
            [344] = 2,

            -- The Goblet cottage, house, mansion to Ul'dah - Steps of Nald
            [345] = 9,
            [346] = 9,
            [347] = 9,

            -- Shirogane cottage, house, mansion to Kugane
            [649] = 111,
            [650] = 111,
            [651] = 111,

            -- Empyreum cottage, house, mansion to Foundation - Ishgard
            [980] = 70,
            [981] = 70,
            [982] = 70,
        }

        -- Finish the event and decide where to go
        player:send_message("当前室内没有关联地块，将返回城市水晶。")

        local destination = INTERIORS_TO_TOWN[player.zone.id]
        if destination ~= nil then
            player:warp_aetheryte(destination)
            return
        else
            player:warp_aetheryte(2) -- Fallback to New Gridania if something went wrong
            return
        end
    end

    player:finish_event()
end
