----------------------------------------------------------
-- Factionizer, a reputation management tool 5.04.00.7.2 14.4.27 41756.9846395833 --
-------------------------------------------------------
---------------------------
-- _00_ Variables Set up --
---------------------------

FIZ_ToExalted = {}
FIZ_ToExalted[0] = 84000;
FIZ_ToExalted[1] = 48000;	-- working on Hated -> Hostile, base offset 21k+12k+6k+3k+3k+3k
FIZ_ToExalted[2] = 45000;	-- working on Hostile -> Unfriendly, base offset 21k+12k+6k+3k+3k
FIZ_ToExalted[3] = 42000;	-- working on Unfriendly -> Neutral, base offset 21k+12k+6k+3k
FIZ_ToExalted[4] = 39000;	-- working on Neutral -> Friendly, base offset 21k+12k+6k
FIZ_ToExalted[5] = 33000;	-- working on Friendly -> Honored, base offset 21k+12k
FIZ_ToExalted[6] = 21000;	-- working on honoured -> revered, base offset 21k
FIZ_ToExalted[7] = 0;	-- working on revered -> exalted, so no base offset
FIZ_ToExalted[8] = 0;	-- already at exalted -> no offset

FIZ_ToBFF = {}	--> Friendship levels:
FIZ_ToBFF[0] = 42999;	--> 1 - Stranger: 0-8400
FIZ_ToBFF[1] = 42000;	--> 2 - Acquaintance: 8400-16800
FIZ_ToBFF[2] = 33600;	--> 3 - Buddy: 16800-25200
FIZ_ToBFF[3] = 25200;	--> 4 - Friend: 25200-33600
FIZ_ToBFF[4] = 16800;	--> 5 - Good Friend: 33600-42000
FIZ_ToBFF[5] = 8400;	--> 6 - Best Friend: 42000-42999

-- Addon constants
FIZ_NAME = "Factionizer"
FIZ_VNMBR = 504007.2	-- Number code for this version

-- Colours
FIZ_HELP_COLOUR = "|cFFFFFF7F"
FIZ_NEW_REP_COLOUR = "|cFF7F7FFF"
FIZ_NEW_STANDING_COLOUR = "|cFF6060C0"
FIZ_BAG_COLOUR = "|cFFC0FFC0"
FIZ_BAG_BANK_COLOUR = "|cFFFFFF7F"
FIZ_QUEST_COLOUR = "|cFFC0FFC0"
FIZ_HIGHLIGHT_COLOUR = "|cFF00FF00"
FIZ_QUEST_ACTIVE_COLOUR = "|cFFFF7F7F"
FIZ_LOWLIGHT_COLOUR = "|cFFFF3F3F"
FIZ_SUPPRESS_COLOUR = "|cFF7F7F7F"
--Profestions ggg
FIZ_LIMIT_TYPE_Herb = 1
FIZ_LIMIT_TYPE_Skin = 2
FIZ_LIMIT_TYPE_Mine = 3
FIZ_LIMIT_TYPE_Gather = 4
FIZ_LIMIT_TYPE_Engi = 5
FIZ_LIMIT_TYPE_Alch = 6
FIZ_LIMIT_TYPE_Blac = 7
FIZ_LIMIT_TYPE_Tail = 8
FIZ_LIMIT_TYPE_Leat = 9
FIZ_LIMIT_TYPE_Ench = 10
FIZ_LIMIT_TYPE_Jewe = 11
FIZ_LIMIT_TYPE_Incr = 12
FIZ_LIMIT_TYPE_Aid = 13
FIZ_LIMIT_TYPE_Arch = 14
FIZ_LIMIT_TYPE_Cook = 15
FIZ_LIMIT_TYPE_Fish = 16

FIZ_GUILD_CAP_BASE = 4375
FIZ_FLAG_GUILD_CAP = 1000


--------------------------
-- _01_ Addon Variables --
--------------------------

-- Stored data
FIZ_Data = {}   -- Data saved between sessions
-- Initialization
FIZ_Main = nil   -- Main program window
FIZ_InitComplete = nil
FIZ_VarsLoaded = nil
FIZ_InitStages = 0
FIZ_InitCount = 0
FIZ_difficultyID = 0
FIZ_UpdateRequest = nil
FIZ_UPDATE_INTERVAL = 5
-- Faction information
FIZ_FactionMapping = {}
FIZ_FactionGain = {}

-- Tracking data
FIZ_Entries = {}
-- Skill Tracking ggg
FIZ_Herb = false
FIZ_Skin = false
FIZ_Mine = false
FIZ_Jewel = false
FIZ_Cook = false
FIZ_Arch = false
FIZ_Fish = false
FIZ_Aid = false
FIZ_Black = false
FIZ_Tailor = false
FIZ_Leath = false
FIZ_Enchan = false
FIZ_Engin = false
FIZ_Incrip = false
FIZ_Alche = false
--- Race/Side/Dificulty
FIZ_IsHuman = false
FIZ_IsDeathKnight = false
FIZ_IsAlliance = false
FIZ_IsHorde = false
FIZ_IsHeroic=false
-- Guild Tracking
FIZ_GuildPerk = 0
FIZ_GuildName = nil
-- Guild rep cap
FIZ_CapIndex = nil
FIZ_Tuesday = nil

------------------------
-- _02_ Addon Startup --
------------------------
------------------------------------------------------------
function FIZ_OnLoad(self)
	-- Events monitored by Event Handler
	FIZ_Main = self
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("GUILD_PERK_UPDATE")

	-- Slash commands for CLI
	SLASH_FIZ1 = "/factionizer"
	SLASH_FIZ2 = "/fz"
	SlashCmdList.FIZ = FIZ_SlashHandler

	FIZ_Orig_GetFactionInfo = GetFactionInfo;  -- api function
	GetFactionInfo = FIZ_GetFactionInfo;  -- api function

	FIZ_Orig_ReputationFrame_Update = ReputationFrame_Update -- rfl function
	ReputationFrame_Update = FIZ_ReputationFrame_Update -- rfl function

	FIZ_Orig_ReputationBar_OnClick = ReputationBar_OnClick -- rfl function
	ReputationBar_OnClick = FIZ_ReputationBar_OnClick -- rfl function

	FIZ_Orig_ExpandFactionHeader = ExpandFactionHeader
	ExpandFactionHeader = FIZ_ExpandFactionHeader

	FIZ_Orig_CollapseFactionHeader = CollapseFactionHeader
	CollapseFactionHeader = FIZ_CollapseFactionHeader

	--FIZ_Orig_ChatFrame_OnEvent = ChatFrame_OnEvent
	--ChatFrame_OnEvent = FIZ_ChatFrame_OnEvent

	FIZ_Orig_StandingText = ReputationFrameStandingLabel:GetText()
end

------------------------
-- _03_ Event Handler --
------------------------

function FIZ_OnEvent(self, event, ...)
	--- fpt	FIZ_Printtest("Event Handler ",tostring(Event),"")
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...
	if (event == "ADDON_LOADED") and (arg1 == FIZ_NAME) then
		FIZ_Main:UnregisterEvent("ADDON_LOADED")
		FIZ_InitStages = FIZ_InitStages + 1
		FIZ_Init()
	elseif (event == "VARIABLES_LOADED") then
		FIZ_OnShowOptionFrame()
		FIZ_VarsLoaded = true
		FIZ_InitStages = FIZ_InitStages + 2
		FIZ_Init()
	elseif (event == "PLAYER_LOGIN") then
		FIZ_Main:UnregisterEvent("PLAYER_LOGIN")
		--FIZ_DoInitialCollapse()
		FIZ_InitStages = FIZ_InitStages + 4
		FIZ_Init()
	elseif (event == "PLAYER_ENTERING_WORLD") then
		FIZ_InitStages = FIZ_InitStages + 8
		FIZ_Init()
		FIZ_Main:UnregisterEvent("PLAYER_ENTERING_WORLD")
		FIZ_Main:RegisterEvent("UPDATE_FACTION") --rfl
		FIZ_Main:RegisterEvent("LFG_BONUS_FACTION_ID_UPDATED") --rfl
		-- to keep item list up to date
		FIZ_Main:RegisterEvent("BAG_UPDATE")
		FIZ_Main:RegisterEvent("BANKFRAME_OPENED")
		FIZ_Main:RegisterEvent("BANKFRAME_CLOSED")
		-- to keep dungeon difficulty up to date
		FIZ_Main:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
		-- to keep list of known skills up to date
		FIZ_Main:RegisterEvent("CHAT_MSG_SKILL")
		FIZ_Main:RegisterEvent("CHAT_MSG_SPELL_TRADESKILLS")
		FIZ_Main:RegisterEvent("SKILL_LINES_CHANGED")
		FIZ_Main:RegisterEvent("UPDATE_TRADESKILL_RECAST")
		FIZ_Main:RegisterEvent("QUEST_COMPLETE")
		FIZ_Main:RegisterEvent("QUEST_WATCH_UPDATE")

		-- new chat hook system
		ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", FIZ_ChatFilter)
		ChatFrame_AddMessageEventFilter("COMBAT_TEXT_UPDATE", FIZ_ChatFilter)

	elseif (event == "UPDATE_FACTION" or
	      	event == "QUEST_COMPLETE" or
	      	event == "QUEST_WATCH_UPDATE") then
-- rfl Event v
		if ( ReputationFrame:IsVisible() ) then
			ReputationFrame_Update(); -- rfl Event
		end
-- rfl event ^
		if ( FIZ_ReputationDetailFrame:IsVisible()) then
			FIZ_BuildUpdateList()
			FIZ_UpdateList_Update()
		end
		FIZ_DumpReputationChangesToChat()

	elseif ( event == "BAG_UPDATE") then
		if (FIZ_ReputationDetailFrame:IsVisible()) then
			-- Update rep frame (implicitely updates detail frame which In turn implicitely reparses bag contents)
			ReputationFrame_Update()
		end 

	elseif ( event == "BANKFRAME_OPENED") then
		FIZ_BankOpen = true

	elseif ( event == "BANKFRAME_CLOSED") then
		-- this is fired twice when closing the bank window, bank contents only available at the first Event
		if (FIZ_BankOpen) then
			-- this is the first call
			FIZ_ParseBankContent()
			FIZ_BankOpen = nil

			if (FIZ_ReputationDetailFrame:IsVisible()) then
				-- Update rep frame (implicitely updates detail frame which In turn implicitely reparses bag contents)
				ReputationFrame_Update()
			end
		end

	elseif ( event == "PLAYER_DIFFICULTY_CHANGED") then -- ccc
			FIZ_Print("PLAYER_DIFFICULTY_CHANGED", nil) 

	elseif ( event == "CHAT_MSG_SKILL") or
		( event == "CHAT_MSG_SPELL_TRADESKILLS") or
		( event == "SKILL_LINES_CHANGED") or
		( event == "UPDATE_TRADESKILL_RECAST") then
		FIZ_ExtractSkills()
		if ( ReputationFrame:IsVisible() ) then
			ReputationFrame_Update(); -- rfl Event
		end
		if ( FIZ_ReputationDetailFrame:IsVisible()) then
			FIZ_BuildUpdateList()
			FIZ_UpdateList_Update()
		end

	elseif ( event == "GUILD_PERK_UPDATE") then
		FIZ_UpdateGuildPerk()
	end

end

-------------------------------
function FIZ_OnUpdate(self)
	if not FIZ_UpdateRequest then return end
	if FIZ_InitComplete and FIZ_InitCount > 5 then return end
	if (GetTime() < FIZ_UpdateRequest) then return end

	if (FIZ_InitCount <= 5) then
		-- Guild level seems to only return a proper value a little later
		--FIZ_Print("update number "..tostring(FIZ_InitCount))
		FIZ_InitCount = FIZ_InitCount + 1
		FIZ_UpdateRequest = GetTime() + FIZ_UPDATE_INTERVAL
		if (FIZ_InitCount > 5) then
			FIZ_UpdateRequest = nil
			--FIZ_Print("Stopping updates")
		end
		FIZ_UpdateGuildPerk()
	end
end


-------------------------------
-- _04_ Addon Initialization --
-------------------------------
function FIZ_InitVariable(var, value)
	local result = 0
	if var == nil then return result end

	if (not FIZ_Data[var]) and (not FIZ_Data[var.."_inited"]) then
		-- this option is not Set, and has never been Set by default, do so and let the user know
		FIZ_Data[var] = value
		FIZ_Data[var.."_inited"] = true
		result = 1
	elseif (not FIZ_Data[var.."_inited"]) then
		-- the option is enabled, but not marked as inited, do so silently
		FIZ_Data[var.."_inited"] = true
	end

	return result
end

-------------------------------
function FIZ_Init()
	if FIZ_InitComplete then return end
	--FIZ_Print("FIZ_InitStages ["..tostring(FIZ_InitStages).."]")
	if (FIZ_InitStages ~= 15) then return end

	local version = GetAddOnMetadata("Factionizer", "Version");
	if (version == nil) then
		version = "unknown";
	end

	-- create data structures
	if not FIZ_Data then FIZ_Data = {} end
	if not FIZ_Data.OriginalCollapsed then FIZ_Data.OriginalCollapsed = {} end

	if FIZ_Data.ChatFrame == nil then FIZ_Data.ChatFrame = 0 end
	local changed = 0
	changed = changed + FIZ_InitVariable("ShowMobs", true)
	changed = changed + FIZ_InitVariable("ShowQuests", true)
	changed = changed + FIZ_InitVariable("ShowInstances", true)
	changed = changed + FIZ_InitVariable("ShowItems", true)
	changed = changed + FIZ_InitVariable("ShowGeneral", true)

	changed = changed + FIZ_InitVariable("ShowMissing", true)
	changed = changed + FIZ_InitVariable("ExtendDetails", true)
	changed = changed + FIZ_InitVariable("WriteChatMessage", true)
	changed = changed + FIZ_InitVariable("NoGuildGain", true)
	changed = changed + FIZ_InitVariable("SuppressOriginalChat", true)
	changed = changed + FIZ_InitVariable("ShowPreviewRep", true)
	changed = changed + FIZ_InitVariable("SwitchFactionBar", true)
	changed = changed + FIZ_InitVariable("SilentSwitch", true)
	changed = changed + FIZ_InitVariable("NoGuildSwitch", true)
	if (changed > 0) then
		StaticPopupDialogs["FIZ_CONFIG_CHANGED"] = {
			text = FIZ_TXT.configQuestion,
			button1 = FIZ_TXT.showConfig,
			button2 = FIZ_TXT.later,
			OnAccept = function()
					FIZ_ToggleConfigWindow();				--- f_tcw
				end,
			--OnCancel = function()
			--	FIZ_Print(GLDG_Data.colours.help..GLDG_NAME..":|cFFFF0000 "..GLDG_TXT.reload)
			--	end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
			sound = "igQuestFailed",
		};
		StaticPopup_Show("FIZ_CONFIG_CHANGED");
	end

	-- keep version In configuration file
	FIZ_Data.Version = FIZ_VNMBR

	-- Set up UI
	FIZ_OptionsButtonText:SetText(FIZ_TXT.options)
	FIZ_OptionsFrameTitle:SetText(FIZ_NAME.." "..FIZ_TXT.options)

	FIZ_EnableMissingBoxText:SetText(FIZ_TXT.showMissing)
	FIZ_ExtendDetailsBoxText:SetText(FIZ_TXT.extendDetails)
	FIZ_GainToChatBoxText:SetText(FIZ_TXT.gainToChat)
	FIZ_NoGuildGainBoxText:SetText(FIZ_TXT.noGuildGain)
	FIZ_SupressOriginalGainBoxText:SetText(FIZ_TXT.suppressOriginalGain)
	FIZ_ShowPreviewRepBoxText:SetText(FIZ_TXT.showPreviewRep)
	FIZ_SwitchFactionBarBoxText:SetText(FIZ_TXT.switchFactionBar)
	FIZ_NoGuildSwitchBoxText:SetText(FIZ_TXT.noGuildSwitch)
	FIZ_SilentSwitchBoxText:SetText(FIZ_TXT.silentSwitch)
	FIZ_OrderByStandingCheckBoxText:SetText(FIZ_TXT.orderByStanding)

	---	FIZ_OnShowOptionFrame()
	FIZ_ExtractSkills()

	local _, race = UnitRace("player")
	local faction, locFaction = UnitFactionGroup("player")
	local class, enClass = UnitClass("player")
	FIZ_Player = UnitName("player")
	FIZ_Realm = GetRealmName()	--	FIZ_Realm = GetCVar("realmName")
	-- gci	FIZ_CapIndex = FIZ_Realm.." - "..FIZ_Player

	if (IsInGuild()) then
		if (FIZ_GuildName == nil or FIZ_GuildName == "") then FIZ_GuildName = GetGuildInfo("player") end
		local guildLevel = GetGuildLevel();
		if (guildLevel >= 12) then
			FIZ_GuildPerk = 2 -- 10% bonus to rep
		elseif (guildLevel >= 4) then
			FIZ_GuildPerk = 1 -- 5% bonus to rep
		end
	end

	if (race and faction and locFaction and FIZ_Player and FIZ_Realm) then
		if (race == "Human") then
			FIZ_IsHuman = true
		end

		if enClass and enClass == "DEATHKNIGHT" then
			FIZ_IsDeathKnight = true
		end

		if (faction == FACTION_ALLIANCE) or (locFaction == FACTION_ALLIANCE) then
			FIZ_IsAlliance = true
		end

		if (faction == FACTION_HORDE) or (locFaction == FACTION_HORDE) then
			FIZ_IsHorde = true
		end

		FIZ_InitFactor(FIZ_IsHuman,FIZ_GuildPerk)

		-- Initialize Faction information
		local locale = GetLocale()
		FIZ_InitFactionMap(locale, FIZ_GuildName)
		-- Changed by Bagdad for easy reputation content moderation
		FIZ_FactionGain = {}
		FIZ_InitEnFactionGains(FIZ_GuildName, FIZ_GUILD_CAP_BASE)
		FIZ_DumpReputationChangesToChat(true)

		FIZ_InitComplete = true
		if (FIZ_InitCount <= 5) then
			FIZ_UpdateRequest = GetTime() + FIZ_UPDATE_INTERVAL
			--FIZ_Print("Init complete, setting up updates ("..tostring(FIZ_InitCount).." already done)")
		--else
			--FIZ_Print("Init complete, not starting updates")
		end

	end
end

------------------------
-- _05_ Slash Handler --
------------------------

function FIZ_SlashHandler(msg)
	if not msg then
		return
	else
		FIZ_SlashHandler1(msg)
	end
end
-----------------------------------
-- _06_ General Helper Functions --
-----------------------------------

------------------------------------------------------------
function FIZ_Print(msg, forceDefault) --zzz
	if not (msg) then return end

	if ((FIZ_Data==nil) or forceDefault) then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	else
		for i = 1, NUM_CHAT_WINDOWS do
			local chatTab = _G["ChatFrame"..i.."Tab"]
			if chatTab:IsShown() then
				local chatFrame = _G["ChatFrame"..i]
				local messageTypes = chatFrame.messageTypeList
				for j = 1, #messageTypes do
					if messageTypes[j] == "COMBAT_FACTION_CHANGE" then
						_G["ChatFrame"..i]:AddMessage(msg)
					end
				end
			end
		end

	end
end
------------------------------------------------------------
function FIZ_Printtest(msg,msg1,msg2) --fpt
	FIZ_Print(""..tostring(msg).." "..tostring(msg1).."  "..tostring(msg2), nil)
end
------------------------------------------------------------
function FIZ_PrintSlash(msg,msg1) --zzz
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..msg.." ["..FIZ_HELP_COLOUR..msg1.."|r]", true)
	FIZ_Help()
end
------------------------------------------------------------
function FIZ_Debug(msg)
	if not (msg) then return end
	--FIZ_Print(msg)
end
------------------------------------------------------------
function FIZ_TableSize(info)
	local result = 0
	if info then
		for item in pairs(info) do result = result + 1 end
	end
	return result
end

------------------------------------------------------------
function FIZ_GetWords(str)
	local ret = {};
	local pos=0;
	local index=0
	while(true) do
		local word;
		_,pos,word=string.find(str, "^ *([^%s]+) *", pos+1);
		if(not word) then
			return ret;
		end
		ret[index]=word
		index = index+1
	end
end

------------------------------------------------------------
function FIZ_Concat(list, start, stop)
	local ret = "";

	if (start == nil) then start = 0 end
	if (stop == nil) then stop = FIZ_TableSize(list) end

	for i = start,stop do
		if list[i] then
			if (ret ~= "") then ret = ret.." " end
			ret = ret..list[i]
		end
	end
	return ret
end

------------------------------------------------------------
function FIZ_BoolToEnabled(b)
	local result = FIZ_TXT.disabled
	if b then result = FIZ_TXT.enabled end
	return result
end

------------------------------------------------------------
function FIZ_RGBToColour_perc(a, r, g, b)
	return string.format("|c%02X%02X%02X%02X", a*255, r*255, g*255, b*255)
end

-----------------------------------
-- _10_ New Hook Functions --
-----------------------------------
function FIZ_GetFactionInfo(factionIndex)

	-- get original information
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = FIZ_Orig_GetFactionInfo(factionIndex)

	-- Normalize Values to within standing
	local normMax = barMax-barMin
	local normCurrent = barValue-barMin

	-- add missing reputation
	if (FIZ_Data.ShowMissing and isHeader and not hasRep and ((normMax-normCurrent)>0)) then
		name = name.." ("..normMax-normCurrent..")"
	end

	-- return Values
	return name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus;
end

--- v rfl 1
function FIZ_ReputationFrame_Update() --rfl
-- v rfl 1.1
	local numFactions
	if FIZ_Data.SortByStanding then
		FIZ_StandingSort()
		numFactions = FIZ_OBS_numFactions
	else
-- ^ rfl 1.1
		numFactions = GetNumFactions();
-- v rfl 1.2
	end
-- ^ rfl 1.2
	-- Update scroll frame
	if ( not FauxScrollFrame_Update(ReputationListScrollFrame, numFactions, NUM_FACTIONS_DISPLAYED, REPUTATIONFRAME_FACTIONHEIGHT ) ) then
		ReputationListScrollFrameScrollBar:SetValue(0);
	end
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame);
-- v rfl 1.3
	if (FIZ_Data.ShowMissing) then
		ReputationFrameStandingLabel:SetText(FIZ_Orig_StandingText.." "..FIZ_TXT.missing)
	else
		ReputationFrameStandingLabel:SetText(FIZ_Orig_StandingText)
	end

	if (FIZ_Data.ShowPreviewRep) then
		FIZ_ParseBagContent()
	end
-- ^ rfl 1.3
	local gender = UnitSex("player");
	local lfgBonusFactionID = GetLFGBonusFactionID();

	local i;
	for i=1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i;
		local factionRow = _G["ReputationBar"..i];
		local factionBar = _G["ReputationBar"..i.."ReputationBar"];
		local factionTitle = _G["ReputationBar"..i.."FactionName"];
		local factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"];
		local factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"];
		local factionBackground = _G["ReputationBar"..i.."Background"];
-- v rfl 1.4
		local factionBarPreview = _G["FIZ_StatusBar"..i];
-- ^ rfl 1.4
		if ( factionIndex <= numFactions ) then
-- v rfl _9_ Rep Main Window
			if FIZ_Data.SortByStanding then
				FIZ_SortByStanding(i,factionIndex,factionRow,factionBar,factionBarPreview,factionTitle,factionButton,factionStanding,factionBackground)
			else
				FIZ_OriginalRepOrder(i,factionIndex,factionRow,factionBar,factionBarPreview,factionTitle,factionButton,factionStanding,factionBackground)
			end
-- ^ rfl _9_ Rep Main Window
		else
			factionRow:Hide();
		end
	end
	if ( GetSelectedFaction() == 0 ) then
		ReputationDetailFrame:Hide();
-- v rfl 1.5
		FIZ_ReputationDetailFrame:Hide();
-- ^ rfl 1.5
	end
end
-- ^ rfl 1

function FIZ_ExpandFactionHeader(index)
	-- replaces ExpandFactionHeader
	---fpt f_efh	FIZ_Printtest(index,"","f_efh_1")							---fpt f_efh
	if not FIZ_Entries then return end
	if FIZ_Data.SortByStanding then
		if not FIZ_Entries[index] then return end
		FIZ_Collapsed[FIZ_Entries[index].i] = nil
		FIZ_ReputationFrame_Update()
	else
		FIZ_Orig_ExpandFactionHeader(index)
		--[[
		local name = FIZ_Orig_GetFactionInfo(index);
		FIZ_Data.OriginalCollapsed[name] = nil
		--FIZ_Print("Expanding original index "..tostring(index).." which is ["..tostring(name).."]")
		FIZ_ShowCollapsedList()
		]]--
	end
end

function FIZ_ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep)
	--rowType is a binary table of type isHeader, isChild
	local factionRowName = factionRow:GetName()
	local factionBar = _G[factionRowName.."ReputationBar"];
	local factionTitle = _G[factionRowName.."FactionName"];
	local factionButton = _G[factionRowName.."ExpandOrCollapseButton"];
	local factionStanding = _G[factionRowName.."ReputationBarFactionStanding"];
	local factionBackground = _G[factionRowName.."Background"];
	local factionLeftTexture = _G[factionRowName.."ReputationBarLeftTexture"];
	local factionRightTexture = _G[factionRowName.."ReputationBarRightTexture"];
	factionLeftTexture:SetWidth(62);
	factionRightTexture:SetWidth(42);
	factionBar:SetPoint("RIGHT", factionRow, "RIGHT", 0, 0);
	if ( isHeader ) then
		factionRow:SetPoint("LEFT", ReputationFrame, "LEFT", 10, 0);
		factionTitle:SetWidth(145);
		factionButton:SetPoint("LEFT", factionRow, "LEFT", 3, 0);
		factionButton:Show();
		factionTitle:SetPoint("LEFT",factionButton,"RIGHT",10,0);
		factionTitle:SetFontObject(GameFontNormalLeft);
		factionBackground:Hide()
		factionLeftTexture:SetHeight(15);
		factionLeftTexture:SetWidth(60);
		factionRightTexture:SetHeight(15);
		factionRightTexture:SetWidth(39);
		factionLeftTexture:SetTexCoord(0.765625, 1.0, 0.046875, 0.28125);
		factionRightTexture:SetTexCoord(0.0, 0.15234375, 0.390625, 0.625);
		factionBar:SetWidth(99);
		factionRow.LFGBonusRepButton:SetPoint("RIGHT", factionButton, "LEFT", 0, 1);
	else
		factionRow:SetPoint("LEFT", ReputationFrame, "LEFT", 29, 0);
		factionTitle:SetWidth(160);
		factionButton:Hide();
		factionTitle:SetPoint("LEFT", factionRow, "LEFT", 10, 0);
		factionTitle:SetFontObject(GameFontHighlightSmall);
		factionBackground:Show();
		factionLeftTexture:SetHeight(21);
		factionRightTexture:SetHeight(21);
		factionLeftTexture:SetTexCoord(0.7578125, 1.0, 0.0, 0.328125);
		factionRightTexture:SetTexCoord(0.0, 0.1640625, 0.34375, 0.671875);
		factionBar:SetWidth(101)
		factionRow.LFGBonusRepButton:SetPoint("RIGHT", factionBackground, "LEFT", -2, 0);
	end
	if ( (hasRep) or (not isHeader) ) then
		factionStanding:Show();
		factionBar:Show();
		factionBar:GetParent().hasRep = true;
	else
		factionStanding:Hide();
		factionBar:Hide();
		factionBar:GetParent().hasRep = false;
	end
end
function FIZ_CollapseFactionHeader(index)
	-- replaces CollapseFactionHeader
	---fpt f_efh	FIZ_Printtest(index,"","f_cfh_1")							---fpt f_efh
	if not FIZ_Entries then return end

	if FIZ_Data.SortByStanding then
		if not FIZ_Entries[index] then return end
		FIZ_Collapsed[FIZ_Entries[index].i] = true
		FIZ_ReputationFrame_Update()
	else
		FIZ_Orig_CollapseFactionHeader(index)
		--[[
		local name = FIZ_Orig_GetFactionInfo(index);
		FIZ_Data.OriginalCollapsed[name] = true
		--FIZ_Print("Collapsing original index "..tostring(index).." which is ["..tostring(name).."]")
		FIZ_ShowCollapsedList()
		]]--
	end
end

function FIZ_ReputationBar_OnClick(self)
	--fpt hed frb_oc	FIZ_Printtest("","","frb_oc 1")
	if ((ReputationDetailFrame:IsVisible() or FIZ_ReputationDetailFrame:IsVisible()) and (GetSelectedFaction() == self.index) ) then
		ReputationDetailFrame:Hide();
		FIZ_ReputationDetailFrame:Hide();
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		if (self.hasRep) then
			SetSelectedFaction(self.index);
			if (FIZ_Data.ExtendDetails) then
				FIZ_ReputationDetailFrame:Show();
				ReputationDetailFrame:Hide();
				FIZ_OptionsFrame:Hide()

				FIZ_BuildUpdateList()
				FIZ_UpdateList_Update()
			else
				ReputationDetailFrame:Show();
				FIZ_ReputationDetailFrame:Hide();
				FIZ_OptionsFrame:Hide()
			end
			PlaySound("igMainMenuOptionCheckBoxOn");
			ReputationFrame_Update(); -- rfl Event
		end
	end
end

FIZ_UPDATE_LIST_HEIGHT = 13

function FIZ_UpdateList_Update()
	-- usually called in conjuction with FIZ_BuildUpdateList
	--fpt hed ful_u	FIZ_Printtest("","","ful_u 1")
	if (not FIZ_ReputationDetailFrame:IsVisible()) then return end

	FIZ_UpdateListScrollFrame:Show()
	FIZ_ShowQuestButton:SetChecked(FIZ_Data.ShowQuests)
	FIZ_ShowItemsButton:SetChecked(FIZ_Data.ShowItems)
	FIZ_ShowMobsButton:SetChecked(FIZ_Data.ShowMobs)
	FIZ_ShowInstancesButton:SetChecked(FIZ_Data.ShowInstances)
	FIZ_ShowGeneralButton:SetChecked(FIZ_Data.ShowGeneral)

	FIZ_ShowQuestButtonText:SetText(FIZ_TXT.showQuests)
	FIZ_ShowItemsButtonText:SetText(FIZ_TXT.showItems)
	FIZ_ShowMobsButtonText:SetText(FIZ_TXT.showMobs)
	FIZ_ShowInstancesButtonText:SetText(FIZ_TXT.showInstances)
	FIZ_ShowGeneralButtonText:SetText(FIZ_TXT.showGeneral)

	FIZ_ShowAllButton:SetText(FIZ_TXT.showAll)
	FIZ_ShowNoneButton:SetText(FIZ_TXT.showNone)
	FIZ_ExpandButton:SetText(FIZ_TXT.expand)
	FIZ_CollapseButton:SetText(FIZ_TXT.collapse)

	FIZ_SupressNoneFactionButton:SetText(FIZ_TXT.supressNoneFaction)
	FIZ_SupressNoneGlobalButton:SetText(FIZ_TXT.supressNoneGlobal)
	FIZ_ReputationDetailSuppressHint:SetText(FIZ_TXT.suppressHint)
	FIZ_ClearSessionGainButton:SetText(FIZ_TXT.clearSessionGain)

	local numEntries, highestVisible = FIZ_GetUpdateListSize()

	-- Update scroll frame
	if ( not FauxScrollFrame_Update(FIZ_UpdateListScrollFrame, numEntries, FIZ_UPDATE_LIST_HEIGHT, 16 ) ) then
		FIZ_UpdateListScrollFrameScrollBar:SetValue(0);
	end
	local entryOffset = FauxScrollFrame_GetOffset(FIZ_UpdateListScrollFrame);

	local entryIndex
	local entryFrameName, entryFrame, entryTexture
	local entryLabel, entryName, entryRep, entryTimes
	local entryItemTimes, entryItemName, entryItemTotal
	local postfix

	local haveInfo = false;
	entryIndex = 1
	local i = 0
	local max = FIZ_TableSize(FIZ_UpdateList)
	while(i<entryOffset and entryIndex<max) do
		if FIZ_UpdateList[entryIndex].isShown then
			i = i + 1
		end
		entryIndex = entryIndex + 1
	end
	for i=1, FIZ_UPDATE_LIST_HEIGHT, 1 do
		while ((entryIndex <= highestVisible) and not FIZ_UpdateList[entryIndex].isShown) do
			entryIndex = entryIndex + 1
		end
		if (entryIndex <= highestVisible) then
			haveInfo = true

			entryFrameName = "FIZ_UpdateEntry"..i
			entryFrame = _G[entryFrameName]
			entryTexture = _G[entryFrameName.."Texture"]

			entryLabel = _G[entryFrameName.."Label"]
			entryName = _G[entryFrameName.."Name"]
			entryRep = _G[entryFrameName.."Rep"]
			entryTimes = _G[entryFrameName.."Times"]

			entryItemTimes = _G[entryFrameName.."ItemTimes"]
			entryItemName = _G[entryFrameName.."ItemName"]
			entryItemTotal = _G[entryFrameName.."TotalTimes"]
			local F_UL_ei = FIZ_UpdateList[entryIndex]

			if (entryFrame) then
				entryFrame:Show()
				entryFrame.id = F_UL_ei.index
				entryFrame.tooltipHead = F_UL_ei.tooltipHead
				entryFrame.tooltipTip = F_UL_ei.tooltipTip
				entryFrame.tooltipDetails = F_UL_ei.tooltipDetails
			end

			local color = ""
			if (F_UL_ei.highlight) then
				color = FIZ_HIGHLIGHT_COLOUR
			elseif (F_UL_ei.suppress) then
				color = FIZ_SUPPRESS_COLOUR
			elseif (F_UL_ei.lowlight) then
				color = FIZ_LOWLIGHT_COLOUR
			end

			if (F_UL_ei.type ~= "") then
				-- normal entry
				if (F_UL_ei.suppress) then
					postfix = ""
				else
					postfix = "-Green"
				end
				if (F_UL_ei.hasList) then
					if (F_UL_ei.listShown) then
						entryTexture:SetTexture("Interface\\Addons\\Factionizer\\Textures\\UI-MinusButton-Up"..postfix..".tga")
					else
						entryTexture:SetTexture("Interface\\Addons\\Factionizer\\Textures\\UI-PlusButton-Up"..postfix..".tga")
					end
				else
					entryTexture:SetTexture("Interface\\Addons\\Factionizer\\Textures\\UI-EmptyButton-Up"..postfix..".tga")
				end
				if (F_UL_ei.canSuppress) then
					entryTexture:Show()
				else
					entryTexture:Hide()
				end

				entryLabel:Show()
				entryName:Show()
				entryRep:Show()
				entryTimes:Show()

				entryLabel:SetText(color..F_UL_ei.type)
				entryName:SetText(color..F_UL_ei.name)
				entryRep:SetText(color..F_UL_ei.rep)
				entryTimes:SetText(color..F_UL_ei.times)

				entryItemTimes:Hide()
				entryItemName:Hide()
				entryItemTotal:Hide()
			else
				-- item entry
				entryTexture:Hide()
				entryLabel:Hide()
				entryName:Hide()
				entryRep:Hide()
				entryTimes:Hide()

				entryItemTimes:Show()
				entryItemName:Show()

				entryItemTimes:SetText(color..F_UL_ei.times)
				entryItemName:SetText(color..F_UL_ei.name)
			end
			entryIndex = entryIndex + 1
		else
			_G["FIZ_UpdateEntry"..i]:Hide()
		end
		if haveInfo then
			FIZ_NoInformationText:Hide()
		else
			FIZ_NoInformationText:SetText(FIZ_TXT.noInfo)
			FIZ_NoInformationText:Show()
		end
	end
end

function FIZ_MouseButtonUp(self, button)
	-- unkown call
	--fpt hed mbu	FIZ_Printtest("","","1 f_mbu")
	if (button and button == "LeftButton") then
		FIZ_UpdateEntryClick(self)
	elseif (button and button == "RightButton") then
		FIZ_UpdateEntrySuppress(self)
	end
end

function FIZ_UpdateEntryClick(self)
	-- sub function of FIZ_MouseButtonUp
	if (FIZ_UpdateList[self.id] and FIZ_UpdateList[self.id].hasList) then
		if (FIZ_UpdateList[self.id].listShown) then
			FIZ_ShowUpdateEntry(self.id, false)
		else
			FIZ_ShowUpdateEntry(self.id, true)
		end
	end
end

function FIZ_UpdateEntrySuppress(self)
	-- sub function of FIZ_UpdateEntryClick
	--fpt hed f_ues	FIZ_Printtest("","","f_ues 1")
	if (FIZ_UpdateList[self.id]) then
		if (FIZ_UpdateList[self.id].type ~= "") then
			if (FIZ_UpdateList[self.id].faction and FIZ_UpdateList[self.id].originalName) then
				if (not FIZ_Suppressed) then
					FIZ_Suppressed = {}
				end
				if (not FIZ_Suppressed[FIZ_UpdateList[self.id].faction]) then
					FIZ_Suppressed[FIZ_UpdateList[self.id].faction] = {}
				end
				if (FIZ_Suppressed[FIZ_UpdateList[self.id].faction][FIZ_UpdateList[self.id].originalName]) then
					--FIZ_Print("No longer suppressing ["..FIZ_UpdateList[self.id].faction.."]["..FIZ_UpdateList[self.id].originalName.."]");
					FIZ_Suppressed[FIZ_UpdateList[self.id].faction][FIZ_UpdateList[self.id].originalName] = nil
				else
					--FIZ_Print("Suppressing ["..FIZ_UpdateList[self.id].faction.."]["..FIZ_UpdateList[self.id].originalName.."]");
					FIZ_Suppressed[FIZ_UpdateList[self.id].faction][FIZ_UpdateList[self.id].originalName] = true
				end
				FIZ_BuildUpdateList()
			end
		end
	end
end

function FIZ_SupressNone(allFactions)
	-- unkown call
	--fpt hed sn	FIZ_Printtest("","","1 sn")
	if (allFactions == true) then
		FIZ_Suppressed = {}
		FIZ_BuildUpdateList()
	else
		local factionIndex = GetSelectedFaction()
		local faction = GetFactionInfo(factionIndex)

		if (faction) then
			faction = string.lower(faction)
	--- fpt sn	FIZ_Printtest(faction,FIZ_faction,"1 sn")
			if (FIZ_FactionMapping[faction]) then
	--- fpt sn	FIZ_Printtest(faction,FIZ_faction,"2 sn")
				faction = FIZ_FactionMapping[faction]
			end

			if (not FIZ_Suppressed) then
				FIZ_Suppressed = {}
			end
			FIZ_Suppressed[faction] = {}
		end
		FIZ_BuildUpdateList()
	end
end

-----------------------------------
-- _13_ show option window
-----------------------------------
function FIZ_ToggleConfigWindow()
	--- fpt f_tcw	FIZ_Printtest("f_tcw","","")
	if ReputationFrame:IsVisible() then
		if FIZ_OptionsFrame:IsVisible() then
			-- both windows shown -> hide them both
			FIZ_OptionsFrame:Hide()
			HideUIPanel(CharacterFrame)
		else
			-- options window not shown -> show, hide any detail window
			FIZ_OptionsFrame:Show()
			FIZ_ReputationDetailFrame:Hide();
			ReputationDetailFrame:Hide();
		end
	else
		-- window not shown -> show both
		ToggleCharacter("ReputationFrame")
		FIZ_ReputationDetailFrame:Hide();
		ReputationDetailFrame:Hide();
		FIZ_OptionsFrame:Show()
	end
end

function FIZ_ToggleDetailWindow()
	--- fpt f_tdw	FIZ_Printtest("f_tdw","","")
	if ReputationFrame:IsVisible() then
		if (FIZ_Data.ExtendDetails) then
			if FIZ_ReputationDetailFrame:IsVisible() then
				-- both windows shown -> hide them both
				FIZ_ReputationDetailFrame:Hide()
				HideUIPanel(CharacterFrame)
			else
				-- detail window not shown -> show it, hide any others
				FIZ_ReputationDetailFrame:Show()
				ReputationDetailFrame:Hide();
				FIZ_OptionsFrame:Hide();
				ReputationFrame_Update(); -- rfl Event
			end
		else
			if ReputationDetailFrame:IsVisible() then
				-- both windows shown -> hide them both
				ReputationDetailFrame:Hide()
				HideUIPanel(CharacterFrame)
			else
				-- detail window not shown -> show it, hide any others
				FIZ_ReputationDetailFrame:Hide()
				ReputationDetailFrame:Show();
				FIZ_OptionsFrame:Hide();
				ReputationFrame_Update(); -- rfl Event
			end
		end
	else
		-- window not shown -> show both
		ToggleCharacter("ReputationFrame")
		if (FIZ_Data.ExtendDetails) then
			FIZ_ReputationDetailFrame:Show();
		else
			ReputationDetailFrame:Show();
		end
		FIZ_OptionsFrame:Hide()
		ReputationFrame_Update(); -- rfl Event
	end
end



-----------------------------------
-- _14_ Testing
-----------------------------------


function FIZ_Test()

	if (FIZ_GuildFactionBar:GetParent()) then
		FIZ_Print("FIZ_GuildFactionBar parent: "..tostring(FIZ_GuildFactionBar:GetParent():GetName()))
	else
		FIZ_Print("FIZ_GuildFactionBar has no parent")
	end

	if (FIZ_GuildFactionBarCapHeader:GetParent()) then
		FIZ_Print("FIZ_GuildFactionBarCapHeader parent: "..tostring(FIZ_GuildFactionBarCapHeader:GetParent():GetName()))
	else
		FIZ_Print("FIZ_GuildFactionBarCapHeader has no parent")
	end
	if (FIZ_GuildFactionBarCapText:GetParent()) then
		FIZ_Print("FIZ_GuildFactionBarCapText parent: "..tostring(FIZ_GuildFactionBarCapText:GetParent():GetName()))
	else
		FIZ_Print("FIZ_GuildFactionBarCapText has no parent")
	end
	if (FIZ_GuildFactionBarCapMarker:GetParent()) then
		FIZ_Print("FIZ_GuildFactionBarCapMarker parent: "..tostring(FIZ_GuildFactionBarCapMarker:GetParent():GetName()))
	else
		FIZ_Print("FIZ_GuildFactionBarCapMarker has no parent")
	end
	if (FIZ_GuildFactionBarBaseMarker:GetParent()) then
		FIZ_Print("FIZ_GuildFactionBarBaseMarker parent: "..tostring(FIZ_GuildFactionBarBaseMarker:GetParent():GetName()))
	else
		FIZ_Print("FIZ_GuildFactionBarBaseMarker has no parent")
	end
end


--------------------------
-- _20_ classic options
--------------------------
function FIZ_OnShowOptionFrame()
	FIZ_EnableMissingBox:SetChecked(FIZ_Data.ShowMissing)
	FIZ_ExtendDetailsBox:SetChecked(FIZ_Data.ExtendDetails)
	FIZ_GainToChatBox:SetChecked(FIZ_Data.WriteChatMessage)
	FIZ_NoGuildGainBox:SetChecked(FIZ_Data.NoGuildGain)
	FIZ_SupressOriginalGainBox:SetChecked(FIZ_Data.SuppressOriginalChat)
	FIZ_ShowPreviewRepBox:SetChecked(FIZ_Data.ShowPreviewRep)
	FIZ_SwitchFactionBarBox:SetChecked(FIZ_Data.SwitchFactionBar)
	FIZ_NoGuildSwitchBox:SetChecked(FIZ_Data.NoGuildSwitch)
	FIZ_SilentSwitchBox:SetChecked(FIZ_Data.SilentSwitch)
	FIZ_OrderByStandingCheckBox:SetChecked(FIZ_Data.SortByStanding)

end

--------------------------
-- _21_ interface options
--------------------------
function FIZ_OnLoadOptions(panel)
	panel.name = FIZ_NAME
	panel.okay = FIZ_OptionsOk
	panel.cancel = FIZ_OptionsCancel
	panel.default = FIZ_OptionsDefault

	InterfaceOptions_AddCategory(panel);

	FIZ_OptionEnableMissingCBText:SetText(FIZ_TXT.showMissing)
	FIZ_OptionExtendDetailsCBText:SetText(FIZ_TXT.extendDetails)
	FIZ_OptionGainToChatCBText:SetText(FIZ_TXT.gainToChat)
	FIZ_OptionNoGuildGainCBText:SetText(FIZ_TXT.noGuildGain)
	FIZ_OptionSupressOriginalGainCBText:SetText(FIZ_TXT.suppressOriginalGain)
	FIZ_OptionShowPreviewRepCBText:SetText(FIZ_TXT.showPreviewRep)
	FIZ_OptionSwitchFactionBarCBText:SetText(FIZ_TXT.switchFactionBar)
	FIZ_OptionNoGuildSwitchCBText:SetText(FIZ_TXT.noGuildSwitch)
	FIZ_OptionSilentSwitchCBText:SetText(FIZ_TXT.silentSwitch)

end

------------------------------------------------------------
function FIZ_OnShowOptions(self)
	if (FIZ_Data and FIZ_VarsLoaded) then
		FIZ_OptionsShown = true
		FIZ_OptionEnableMissingCB:SetChecked(FIZ_Data.ShowMissing)
		FIZ_OptionExtendDetailsCB:SetChecked(FIZ_Data.ExtendDetails)
		FIZ_OptionGainToChatCB:SetChecked(FIZ_Data.WriteChatMessage)
		FIZ_OptionNoGuildGainCB:SetChecked(FIZ_Data.NoGuildGain)
		FIZ_OptionSupressOriginalGainCB:SetChecked(FIZ_Data.SuppressOriginalChat)
		FIZ_OptionShowPreviewRepCB:SetChecked(FIZ_Data.ShowPreviewRep)
		FIZ_OptionSwitchFactionBarCB:SetChecked(FIZ_Data.SwitchFactionBar)
		FIZ_OptionNoGuildSwitchCB:SetChecked(FIZ_Data.NoGuildSwitch)
		FIZ_OptionSilentSwitchCB:SetChecked(FIZ_Data.SilentSwitch)

	end
end

------------------------------------------------------------
function FIZ_OptionsOk()
	if (FIZ_OptionsShown) then
		FIZ_Data.ShowMissing = FIZ_OptionEnableMissingCB:GetChecked()
		FIZ_Data.ExtendDetails = FIZ_OptionExtendDetailsCB:GetChecked()
		FIZ_Data.WriteChatMessage = FIZ_OptionGainToChatCB:GetChecked()
		FIZ_Data.NoGuildGain = FIZ_OptionNoGuildGainCB:GetChecked()
		FIZ_Data.SuppressOriginalChat = FIZ_OptionSupressOriginalGainCB:GetChecked()
		FIZ_Data.ShowPreviewRep = FIZ_OptionShowPreviewRepCB:GetChecked()
		FIZ_Data.SwitchFactionBar = FIZ_OptionSwitchFactionBarCB:GetChecked()
		FIZ_Data.NoGuildSwitch = FIZ_OptionNoGuildSwitchCB:GetChecked()
		FIZ_Data.SilentSwitch = FIZ_OptionSilentSwitchCB:GetChecked()

		ReputationFrame_Update()
	end
	FIZ_OptionsShown = nil
end

------------------------------------------------------------
function FIZ_OptionsCancel()
	-- nothing to do
	FIZ_OptionsShown = nil
end

------------------------------------------------------------
function FIZ_OptionsDefault()
	-- nothing to do
end

--------------------------
-- _22_ Guild perk Update
--------------------------
function FIZ_UpdateGuildPerk()
	local warn = false
	if (IsInGuild()) then
		local guildName = GetGuildInfo("player")
		--FIZ_Print("Checking guild name ["..tostring(FIZ_GuildName).."] against ["..tostring(guildName).."]")
		if (FIZ_GuildName == nil or FIZ_GuildName == "" and guildName) then
			FIZ_GuildName = guildName
			warn = true
			--FIZ_Print("Updating guild name from ["..tostring(FIZ_GuildName).."] to ["..tostring(guildName).."]")
		end

		local guildLevel = GetGuildLevel();
		if (guildLevel >= 12) and (FIZ_GuildPerk < 2) then
			warn = true
		elseif (guildLevel >= 4) and (FIZ_GuildPerk < 1) then
			warn = true
		end
		--FIZ_Print("UpdatePerk: level "..tostring(guildLevel).." - perk "..tostring(FIZ_GuildPerk))
	--else
		--FIZ_Print("UpdatePerk: not in guild")
	end

	if (warn) then
		--FIZ_Print("Re-Initing after guild perk update")
		FIZ_InitComplete = nil
		FIZ_Init()
	end
end

--------------------------
-- _23_ Guild rep cap handling
--------------------------
------------------------------------------------------------
function FIZ_GuildFrame_OnLoad(...)
	-- to Guild frame is now loaded, we can now attach our elements
	--FIZ_Print("----- OnLoad called ---------------")
	if (GuildFactionBar) then
		FIZ_GuildFactionBar:SetParent("GuildFactionBar")
		FIZ_GuildFactionBarCapHeader:SetPoint("BOTTOMLEFT", "GuildFactionBar", "TOPLEFT", 0, 10)
		FIZ_GuildFactionBarCapText:SetPoint("LEFT", "FIZ_GuildFactionBarCapHeader", "RIGHT", 2, 0)
	end
end

------------------------------------------------------------
function FIZ_OnLoadGuildFactionBar(self)
	hooksecurefunc("GuildFrame_LoadUI", FIZ_GuildFrame_OnLoad)

	FIZ_GuildFactionBarCapHeader:SetText(FIZ_TXT.weeklyCap)
	FIZ_GuildFactionBarCapText:SetText("")
end	--- 5.04.00.7.2 14.4.27