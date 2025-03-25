local mod = get_mod("Teammate Loadouts")

local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")

local teammate_loadouts = {}

local function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local function get_last_char_from_string(str)
    return string.sub(str, #str)
end

local function remove_last_two_char_from_string(str)
    return string.sub(str, 0, #str - 2)
end

local function get_player_name(profile)
    return profile.name
end

local function get_archetype(profile)
    local archetype_name = firstToUpper(profile.archetype.name)
    local archetype_symbol = profile.archetype.string_symbol
	local symbols = {
		Veteran = "",
		Zealot = "",
		Psyker = "",
		Ogryn = "",
	}
	local symbol = profile.archetype.string_symbol or symbols[archetype_name] or "?"

    return archetype_name .. " " .. symbol
end

local function get_feat_at_tier_level(talents, tier_level)
    local tier = "tier_" .. tier_level

    for k,v in pairs(talents) do
        if string.find(k, tier) then
            return get_last_char_from_string(k)
        end
    end
end

local function get_feats(profile)
    local feat_info = ""
    local talents = profile.talents

    for i=1,6 do
        local feat = get_feat_at_tier_level(talents, i)

        if not feat then
            if i == 1 then
                feat_info = feat_info .. "None  "
            end

            break
        end

        feat_info = feat_info .. feat .. ", "
    end

    return remove_last_two_char_from_string(feat_info)
end

local function get_item_display_name(item)
    return ItemUtils.display_name(item)
end

local function get_trait_display_name(trait)
    local trait_item = MasterItems.get_item(trait.id)
    local trait_display_name = ItemUtils.display_name(trait_item)

    return trait_display_name
end

local function get_item_blessings(item)
    local item_traits = item.traits
    local item_blessings = "None"

    if not item_traits then
        return item_blessings
    end

    if item_traits[1] then
        item_blessings = get_trait_display_name(item_traits[1])
    end

    if item_traits[2] then
        item_blessings = item_blessings .. " + " .. get_trait_display_name(item_traits[2])
    end

    return item_blessings
end

local function get_player_loadout(player)
    local player_loadout = {}
    local profile = player._profile
    local primary_item = profile.loadout["slot_primary"]
    local secondary_item = profile.loadout["slot_secondary"]
    
    player_loadout[0] = "\nPlayer: " .. get_player_name(profile)
    player_loadout[1] = "Class: " .. get_archetype(profile)
    player_loadout[2] = "Feats: " .. get_feats(profile)
    player_loadout[3] = "Melee: " .. get_item_display_name(primary_item)
    player_loadout[4] = "       Blessings: " .. get_item_blessings(primary_item)
    player_loadout[5] = "Ranged: " .. get_item_display_name(secondary_item)
    player_loadout[6] = "       Blessings: " .. get_item_blessings(secondary_item)

    return player_loadout
end

local function init_teammate_loadouts()
    teammate_loadouts = {}

    local player_manager = Managers.player
    if not player_manager then
        return
    end

    local players = player_manager:players()
    local local_player = player_manager:local_player(1)

    for k,player in pairs(players) do
        if player ~= local_player then
            teammate_loadouts[player] = get_player_loadout(player)
        end
    end
end

local function echo_teammate_loadouts()
    for player,player_loadout in pairs(teammate_loadouts) do
        local player_loadout_string = ""

        for index,loadout_item in pairs(player_loadout) do
            player_loadout_string = player_loadout_string .. loadout_item .. "\n"
        end

        mod:echo(player_loadout_string)
    end
end

mod:command("loadouts", "Teammate Loadouts", function ()
    init_teammate_loadouts()
    echo_teammate_loadouts()
end)

mod:hook_safe(CLASS.EndView, "on_enter", function(self)
    init_teammate_loadouts()
end)

mod:hook_safe(CLASS.EndView, "on_exit", function(self)
    echo_teammate_loadouts()
end)
