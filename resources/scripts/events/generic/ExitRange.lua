function onReturn(scene, results, player)
    player:finish_event()

    -- 场景 0 确认移动后返回成功标记、从 0 开始的区号和住宅区 ID。
    local ward_index = results[2]
    if scene ~= 0 or results[1] ~= 1 or ward_index == nil or ward_index < 0 or ward_index >= 30 then
        return
    end

    local territory_id = results[3]
    if territory_id == nil then
        return
    end
    local pop_range_id

    if territory_id == TERRITORY_S1H1 then
        pop_range_id = HOUSING_POP_RANGE_S1H1
    elseif territory_id == TERRITORY_F1H1 then
        pop_range_id = HOUSING_POP_RANGE_F1H1
    elseif territory_id == TERRITORY_W1H1 then
        pop_range_id = HOUSING_POP_RANGE_W1H1
    elseif territory_id == TERRITORY_E1H1 then
        pop_range_id = HOUSING_POP_RANGE_E1H1
    elseif territory_id == TERRITORY_R1H1 then
        pop_range_id = HOUSING_POP_RANGE_R1H1
    end

    if pop_range_id ~= nil then
        player:enter_housing_ward(territory_id, ward_index, pop_range_id)
    end
end

function onYield(scene, id, results, player)
    onReturn(scene, results, player)
end
