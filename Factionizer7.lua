------5.04.00.7.2 14.4.27------------------
-- _07_ information
-----------------------------------
------------------------------------------------------------
function FIZ_Help() --xxx
	FIZ_Print(" ", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.help, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz help "..FIZ_HELP_COLOUR..FIZ_TXT.helphelp, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz about "..FIZ_HELP_COLOUR..FIZ_TXT.helpabout, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz status "..FIZ_HELP_COLOUR..FIZ_TXT.helpstatus, true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz enable { mobs | quests | instances | items | all }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz disable { mobs | quests | instances | items | all }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz toggle { mobs | quests | instances | items | all }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz enable { missing | details | chat | suppress }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz disable { missing | details | chat | suppress }", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_TXT.usage..":|r /fz toggle { missing | details | chat | suppress }" , true)
end
------------------------------------------------------------
function FIZ_About()
	local ver = GetAddOnMetadata("Factionizer", "Version");
	local date = GetAddOnMetadata("Factionizer", "X-Date");
	local author = GetAddOnMetadata("Factionizer", "Author");
	local web = GetAddOnMetadata("Factionizer", "X-Website");

	if (author ~= nil) then
		FIZ_Print(FIZ_NAME.." "..FIZ_TXT.by.." "..FIZ_HELP_COLOUR..author.."|r", true);
	end
	if (ver ~= nil) then
		FIZ_Print("  "..FIZ_TXT.version..": "..FIZ_HELP_COLOUR..ver.."|r", true);
	end
	if (date ~= nil) then
		FIZ_Print("  "..FIZ_TXT.date..": "..FIZ_HELP_COLOUR..date.."|r", true);
	end
	if (web ~= nil) then
		FIZ_Print("  "..FIZ_TXT.web..": "..FIZ_HELP_COLOUR..web.."|r", true);
	end

end
------------------------------------------------------------
function FIZ_Status()
	FIZ_Print(" ", true)
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_TXT.status, true)
	FIZ_Print("   "..FIZ_TXT.statMobs..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowMobs).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statQuests..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowQuests).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statInstances..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowInstances).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statItems..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowItems).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statGeneral..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowGeneral).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statMissing..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowMissing).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statDetails..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ExtendDetails).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statChat..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.WriteChatMessage).."|r", true)

	FIZ_Print("   "..FIZ_TXT.statNoGuildChat..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.NoGuildGain).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statSuppress..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.SuppressOriginalChat).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statPreview..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.ShowPreviewRep).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statSwitch..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.SwitchFactionBar).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statNoGuildSwitch..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.NoGuildSwitch).."|r", true)
	FIZ_Print("   "..FIZ_TXT.statSilentSwitch..": "..FIZ_HELP_COLOUR..FIZ_BoolToEnabled(FIZ_Data.SilentSwitch).."|r", true)
end
------------------------------------------------------------
-----------------------------------
-- _16_ Listing by standing
-----------------------------------
function FIZ_ListByStanding(standing)
	local numFactions = GetNumFactions();
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, hasRep, isCollapsed, isWatched;
	local list = {}

	-- get factions by standing
	for i=1, numFactions do
		name, description, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep = GetFactionInfo(i)
		--if (not isHeader) then
		if (not isHeader or hasRep) then
			if ((standing == nil) or (standing==standingID)) then
				if (not list[standingID]) then
					list[standingID] = {}
				end
				list[standingID][name]={}
				list[standingID][name].max = barMax-barMin
				list[standingID][name].value = barValue-barMin
			end
		end
	end

	-- output
	for i=1, 8 do
		if (list[i]) then
			FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r "..FIZ_RGBToColour_perc(1, FACTION_BAR_COLORS[i].r, FACTION_BAR_COLORS[i].g, FACTION_BAR_COLORS[i].b).."--- "..FIZ_TXT_STAND_LV[i].." ("..i..") ---|r")
			for p in pairs(list[i]) do
				--FIZ_Print("    "..p..": "..list[i][p].value.."/"..list[i][p].max.." ("..FIZ_TXT.missing2..": "..list[i][p].max-list[i][p].value..")")
				FIZ_Print("    "..p..": "..FIZ_TXT.missing2..": "..list[i][p].max-list[i][p].value)
			end
			if (not standing) then
				FIZ_Print(" ")
			end
		end
	end
end

-----------------------------------
-- _17_ list German names
-----------------------------------

function FIZ_ShowGerman(standing)

	local en,de,color,min,max
	min=1
	max=8
	if ((standing ~= nil) and (standing<=8)) then
		min=standing
		max=standing
	end
	FIZ_Print(FIZ_HELP_COLOUR..FIZ_NAME..":|r German standing names:")
	for i=min,max do
		en = _G["FACTION_STANDING_LABEL"..i]
		de = FIZ_TXT_STAND_LV[i]
		color = FACTION_BAR_COLORS[i]
		FIZ_Print("  "..FIZ_RGBToColour_perc(1,color.r,color.g,color.b)..i..": "..en.." = "..de)
	end
end