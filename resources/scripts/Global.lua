-- This file should only be used for globally useful constants and functions.
-- Please put new events, actions, items, etc. in their respective 'main' Lua files.

-- Job-gauge resource indices for EffectsBuilder:modify_gauge(index, amount).
GAUGE_AETHERFLOW = 0 -- Summoner Aetherflow stacks (0-2)

function split(input, separator)
    if separator == nil then
        separator = '%s'
    end

    local t = {}
    for str in string.gmatch(input, '([^'..separator..']+)') do
        table.insert(t, str)
    end

    return t
end

function getTableSize(tbl)
    local count = 0

    for _, _ in pairs(tbl) do
        count = count + 1
    end

    return count
end

function printf(player, fmt_str, ...)
    -- Sender would be defined elsewhere, if at all
    if command_sender == nil then
        command_sender = ""
    end

    if ... ~= nil then
        player:send_message(command_sender..fmt_str:format(...))
    else
        player:send_message(command_sender..fmt_str)
    end
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- Constants, if two or more scripts share the same global they should be placed here
EFFECT_TRANSFIGURATION = 565
EFFECT_SILKEN_SYMMETRY = 2693
EFFECT_SILKEN_FLOW = 2694

-- Black Mage statuses (CN 7.51 Status sheet)
EFFECT_FIRESTARTER = 165 -- 火苗: next Fire III is instant and free
EFFECT_THUNDERHEAD = 3870 -- 云砧: allows casting thunder magic
EFFECT_TRIPLECAST = 1211 -- 三连咏唱
EFFECT_LEY_LINES = 737 -- 黑魔纹 (standing inside)
EFFECT_MANAWARD = 168 -- 魔罩
EFFECT_SLEEP = 3 -- 睡眠
EFFECT_THUNDER_DOT = 161 -- 闪雷
EFFECT_THUNDER_II_DOT = 162 -- 震雷
EFFECT_THUNDER_III_DOT = 163 -- 暴雷
EFFECT_THUNDER_IV_DOT = 1210 -- 霹雷
EFFECT_HIGH_THUNDER_DOT = 3871 -- 高闪雷
EFFECT_HIGH_THUNDER_II_DOT = 3872 -- 高震雷

-- White Mage statuses (CN 7.51 Status sheet)
EFFECT_FREECURE = 155 -- 救疗效果提高
EFFECT_PRESENCE_OF_MIND = 157 -- 神速咏唱
EFFECT_REGEN = 158 -- 再生
EFFECT_MEDICA_II_HOT = 150 -- 医济
EFFECT_MEDICA_III_HOT = 3880 -- 医养
EFFECT_THIN_AIR = 1217 -- 无中生有
EFFECT_CONFESSION = 1219 -- 告解
EFFECT_TEMPERANCE_SELF = 1872 -- 节制（自身治疗量提高）
EFFECT_TEMPERANCE_PARTY = 1873 -- 节制（队员减伤）
EFFECT_AQUAVEIL = 2708 -- 水流幕
EFFECT_LITURGY_OF_THE_BELL = 2709 -- 礼仪之铃
EFFECT_GLARE_IV_READY = 3879 -- 闪飒预备
EFFECT_DIVINE_CARESS_READY = 3881 -- 神爱抚预备
EFFECT_DIVINE_CARESS_BARRIER = 3903 -- 神爱抚防护罩
EFFECT_DIVINE_CARESSED = 3904 -- 神爱环
EFFECT_ASYLUM_INSIDE = 1912 -- 庇护所区域内
EFFECT_STUN = 2 -- 眩晕
EFFECT_WEAKNESS = 43 -- 衰弱

-- As seen on retail
INITIAL_CUTSCENE_FLAGS = NO_DEFAULT_CAMERA | INVIS_ENPC | CONDITION_CUTSCENE | HIDE_UI | HIDE_HOTBAR | SILENT_ENTER_TERRI_ENV | SILENT_ENTER_TERRI_BGM | SILENT_ENTER_TERRI_SE | DISABLE_SKIP | DISABLE_STEALTH

-- For housing
TERRITORY_S1T2 = 129 -- Limsa Lominsa Lower Decks
TERRITORY_W1T1 = 130 -- Ul'dah - Steps of Nald
TERRITORY_F1T1 = 132 -- New Gridania
TERRITORY_S1H1 = 339 -- Mist
TERRITORY_F1H1 = 340 -- The Lavender Beds
TERRITORY_W1H1 = 341 -- The Goblet
TERRITORY_R2T1 = 418 -- Foundation
TERRITORY_E3T1 = 628 -- Kugane
TERRITORY_E1H1 = 641 -- Shirogane
TERRITORY_R1H1 = 979 -- Empyreum

-- As seen in the client
OPENING_SEQ_0 = 0 -- Hasn't seen the cutscene
OPENING_SEQ_1 = 1 -- Seen the cutscene
OPENING_SEQ_2 = 2 -- Accepted first quest from questgiver

-- Opening quests for the check below
OPENING_QUEST_GRIDANIA = 39 -- Coming to Gridania
OPENING_QUEST_LIMSA = 107 -- Coming to Limsa Lominsa
OPENING_QUEST_ULDAH = 594 -- Coming to Ul'dah

-- Determine the opening sequence of this player
function determineSequence(player, cutscene)
    if not player:has_seen_cutscene(cutscene) then
        return OPENING_SEQ_0
    end

    local quest
    if player.city_state == 1 then
        quest = OPENING_QUEST_LIMSA
    elseif player.city_state == 2 then
        quest = OPENING_QUEST_GRIDANIA
    elseif player.city_state == 3 then
        quest = OPENING_QUEST_ULDAH
    end

    if not player:has_quest(quest) then
       return OPENING_SEQ_1
    end

    return OPENING_SEQ_2
end
