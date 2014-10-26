-----------------------------------
-- _12_ reputation Changes to chat
-----------------------------------
function FIZ_DumpReputationChangesToChat(initOnly)
	if not FIZ_StoredRep then FIZ_StoredRep = {} end

	local numFactions = GetNumFactions();
	local factionIndex, watchIndex, watchedIndex, watchName
	local name, standingID, barMin, barMax, barValue, isHeader, hasRep
	local RepRemains

	watchIndex = 0
	watchedIndex = 0
	watchName = nil
	for factionIndex=1, numFactions, 1 do
		name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, isWatched = GetFactionInfo(factionIndex)

		--if (not isHeader) then
		if (not isHeader or hasRep) then
			if (isWatched) then
				watchedIndex = factionIndex
			end
			if FIZ_StoredRep[name] and not initOnly then
				if (FIZ_Data.WriteChatMessage) then
					if (not FIZ_Data.NoGuildGain or name ~= FIZ_GuildName) then
						local sign=""
						if ((barValue-FIZ_StoredRep[name].origRep)>0) then
							sign = "+"
						end
						if (barValue > FIZ_StoredRep[name].rep) then
							-- increased rep
							FIZ_Print(FIZ_NEW_REP_COLOUR..string.format(FACTION_STANDING_INCREASED..FIZ_TXT.stats, name, barValue-FIZ_StoredRep[name].rep, sign, barValue-FIZ_StoredRep[name].origRep, barMax-barValue))
						elseif (barValue < FIZ_StoredRep[name].rep) then
							FIZ_Print(FIZ_NEW_REP_COLOUR..string.format(FACTION_STANDING_DECREASED..FIZ_TXT.stats, name, FIZ_StoredRep[name].rep-barValue, sign, barValue-FIZ_StoredRep[name].origRep, barMax-barValue))
							-- decreased rep
						end
						if (FIZ_StoredRep[name].standingID ~= standingID) then
							FIZ_Print(FIZ_NEW_STANDING_COLOUR..string.format(FACTION_STANDING_CHANGED, _G["FACTION_STANDING_LABEL"..standingID], name))
						end
					end
				end
				if (FIZ_Data.SwitchFactionBar) then
					if (not FIZ_Data.NoGuildSwitch or name ~= FIZ_GuildName) then
						if (barValue > FIZ_StoredRep[name].rep) then
							--FIZ_Print("Marking faction ["..tostring(name).."] index ["..tostring(factionIndex).."] for rep watch bar")
							watchIndex = factionIndex
							watchName = name
						--elseif (barValue ~= FIZ_StoredRep[name].rep) then
							--FIZ_Print("Faction ["..tostring(name).."] lost rep")
						end
					end
				end
			else
				FIZ_StoredRep[name] = {}
				FIZ_StoredRep[name].origRep = barValue
			end
			FIZ_StoredRep[name].standingID = standingID
			FIZ_StoredRep[name].rep = barValue
		end
	end
	if (watchIndex > 0) then
		if (watchIndex ~= watchedIndex) then
			if (not FIZ_Data.SilentSwitch) then
				FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.switchBar.." ["..tostring(watchName).."|r]")
			end
		end
		-- choose Faction to show
		SetWatchedFactionIndex(watchIndex)
		ReputationWatchBar_Update(); -- rfl functions
	end
end

function FIZ_ClearSessionGain()
	local factionIndex = GetSelectedFaction()
	local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, isWatched = GetFactionInfo(factionIndex)

	if (name) then
		FIZ_StoredRep[name] = {}
		FIZ_StoredRep[name].origRep = barValue
		FIZ_StoredRep[name].standingID = standingID
		FIZ_StoredRep[name].rep = barValue
	end
	FIZ_ReputationFrame_Update()
end

-----------------------------------
-- _13_ chat filtering
-----------------------------------
--function FIZ_ChatFrame_OnEvent(self, event, ...)
function FIZ_ChatFilter(chatFrame, event, ...) -- chatFrame = self
	--[[
	CHAT_MSG_COMBAT_FACTION_CHANGE
		Fires when player's faction changes. ie: "Your reputation with Timbermaw Hold has very slightly increased." -- NEW 1.9
		arg1
			The message to display

	COMBAT_TEXT_UPDATE
		arg1
			Combat message type.
			Known values include "HONOR_GAINED", and "FACTION".
		arg2
			for faction gain, this is the faction name.
		arg3
			for faction gain, the amount of reputation gained.
	]]--

	local msg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...;
	local skip = false
	if (FIZ_Data.SuppressOriginalChat and event) then

		if (event == "CHAT_MSG_COMBAT_FACTION_CHANGE") then
			skip = true
		end
		if ((event == "COMBAT_TEXT_UPDATE") and (msg=="FACTION")) then
			skip = true
		end

	end
	return skip, msg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13
end