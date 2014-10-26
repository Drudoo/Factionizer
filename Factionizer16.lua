------5.04.00.7.2 14.4.27------------------
-- _16_ FSS // RDF_IS // RDF
-----------------------------------
-- ^ rfl 2.7 v ptr
function FIZ_StandingSort()
-- del	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus;
	local standings = {}
	local numFactions = GetNumFactions();

	for i=1,numFactions do
		local name, description, standingID, _, barMax, barValue, _, _, isHeader, _, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus= GetFactionInfo(i);

		--if (not isHeader) then only list factions, not faction groups headers
		if (not isHeader or hasRep) then
			if not standings[standingID] then
				standings[standingID] = {}
			end
			local size = FIZ_TableSize(standings[standingID])
			local entry = {}
			local inserted = false
			entry.missing = barMax-barValue
			entry.i = i
			if (size) then
				for j=1,size do
					if (not inserted) then
						if (standings[standingID][j].missing > entry.missing) then
							table.insert(standings[standingID], j, entry);
							inserted = true
						end
					end
				end
				if (not inserted) then
					table.insert(standings[standingID], entry)
				end
			else
				table.insert(standings[standingID], entry)
			end
		end
	end

	-- find Number of elements to display
	local numFactions = 0
	FIZ_Entries = {}
	if (not FIZ_Collapsed) then
		FIZ_Collapsed = {}
	end
	for i=8,1, -1 do
	--for i In pairs(standings) do
		if FIZ_TableSize(standings[i]) then
			if (standings[i]) then
				numFactions = numFactions + 1 -- count standing as header
				FIZ_Entries[numFactions] = {}
				FIZ_Entries[numFactions].header = true
				FIZ_Entries[numFactions].i = i	-- this is the standingID
				FIZ_Entries[numFactions].size = FIZ_TableSize(standings[i]) -- this is the number of factions with this standing
				if (not FIZ_Collapsed[i]) then
					for j in pairs(standings[i]) do
						numFactions = numFactions + 1 -- count each faction in the current standing
						FIZ_Entries[numFactions] = {}
						FIZ_Entries[numFactions].header = false
						FIZ_Entries[numFactions].i = standings[i][j].i -- this is the index into the faction table
						FIZ_Entries[numFactions].size = 0
					end
				end
			end
		end
	end
	FIZ_OBS_numFactions = numFactions
end
-- ^ 2 rfl ptr v R_D_F_IS
function FIZ_ReputationDetailFrame_IsShown(faction,flag,flag2,i)
	local name, description = GetFactionInfo(faction);
-- v rfl _16_
	ReputationDetailFactionName:SetText(name);
	ReputationDetailFactionDescription:SetText(description);
	if ( atWarWith ) then
		ReputationDetailAtWarCheckBox:SetChecked(1);
	else
		ReputationDetailAtWarCheckBox:SetChecked(nil);
	end
-- v rfl _16_ 1
	if flag then
-- ^ rfl _16_ 1
		ReputationDetailAtWarCheckBox:Enable();
		ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
	else
		ReputationDetailAtWarCheckBox:Disable();
		ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end

	if flag2==2 then

		if ( not isHeader ) then
			ReputationDetailInactiveCheckBox:Enable();
			ReputationDetailInactiveCheckBoxText:SetTextColor(ReputationDetailInactiveCheckBoxText:GetFontObject():GetTextColor());
		else
			ReputationDetailInactiveCheckBox:Disable();
			ReputationDetailInactiveCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		end
-- v rfl _16_ 3
		_G["ReputationBar"..i.."ReputationBarHighlight1"]:Show();
		_G["ReputationBar"..i.."ReputationBarHighlight2"]:Show();
	end
-- ^ rfl _16_ 3
-- v rfl _16_ 2
	if ( IsFactionInactive(faction) ) then
		ReputationDetailInactiveCheckBox:SetChecked(1);
	else
		ReputationDetailInactiveCheckBox:SetChecked(nil);
	end
	if ( isWatched ) then
		ReputationDetailMainScreenCheckBox:SetChecked(1);
	else
		ReputationDetailMainScreenCheckBox:SetChecked(nil);
	end
-- ^ rfl _16_ 2
end
-- ^ R_D_F_IS v R_D_F
function FIZ_Rep_Detail_Frame(faction,colorID,barValue,barMax,origBarValue,standingID,toExalted,factionStandingtext)
	local name, description, _, _, _, _, atWarWith, canToggleAtWar, _, _, _, _, _, _, _, _ = GetFactionInfo(faction);
	local gender = UnitSex("player");
	FIZ_BuildUpdateList()

	FIZ_ReputationDetailFactionName:SetText(name);
	FIZ_ReputationDetailFactionDescription:SetText(description);

	FIZ_ReputationDetailStandingName:SetText(factionStandingtext)
	local color = FACTION_BAR_COLORS[colorID]
	FIZ_ReputationDetailStandingName:SetTextColor(color.r, color.g, color.b)

	FIZ_ReputationDetailStandingCurrent:SetText(FIZ_TXT.currentRep)
	FIZ_ReputationDetailStandingNeeded:SetText(FIZ_TXT.neededRep)
	FIZ_ReputationDetailStandingMissing:SetText(FIZ_TXT.missingRep)
	FIZ_ReputationDetailStandingBag:SetText(FIZ_TXT.repInBag)
	FIZ_ReputationDetailStandingBagBank:SetText(FIZ_TXT.repInBagBank)
	FIZ_ReputationDetailStandingQuests:SetText(FIZ_TXT.repInQuest)
	FIZ_ReputationDetailStandingGained:SetText(FIZ_TXT.factionGained)

	FIZ_ReputationDetailStandingCurrentValue:SetText(barValue)
	FIZ_ReputationDetailStandingNeededValue:SetText(barMax)
	FIZ_ReputationDetailStandingMissingValue:SetText(barMax-barValue)
	FIZ_ReputationDetailStandingBagValue:SetText(FIZ_CurrentRepInBag)
	FIZ_ReputationDetailStandingBagBankValue:SetText(FIZ_CurrentRepInBagBank)
	FIZ_ReputationDetailStandingQuestsValue:SetText(FIZ_CurrentRepInQuest)
	if (FIZ_StoredRep and FIZ_StoredRep[name] and FIZ_StoredRep[name].origRep) then
		FIZ_ReputationDetailStandingGainedValue:SetText(string.format("%d", origBarValue-FIZ_StoredRep[name].origRep))
	else
		FIZ_ReputationDetailStandingGainedValue:SetText("")
	end

	if (standingID <8) then
		color = FACTION_BAR_COLORS[standingID+1]
		--FIZ_ReputationDetailStandingNext:SetText(FIZ_TXT.nextLevel)
		FIZ_ReputationDetailStandingNextValue:SetText("(--> "..GetText("FACTION_STANDING_LABEL"..standingID+1, gender)..")")
		FIZ_ReputationDetailStandingNextValue:SetTextColor(color.r, color.g, color.b)
	else
		--FIZ_ReputationDetailStandingNext:SetText("")
		FIZ_ReputationDetailStandingNextValue:SetText("")
	end
	if (standingID <7) then
		FIZ_ReputationDetailStandingToExaltedHeader:SetText(FIZ_TXT.toExalted)
		FIZ_ReputationDetailStandingToExaltedValue:SetText(toExalted)
	else
		FIZ_ReputationDetailStandingToExaltedHeader:SetText("")
		FIZ_ReputationDetailStandingToExaltedValue:SetText("")
	end

	if ( atWarWith ) then
		FIZ_ReputationDetailAtWarCheckBox:SetChecked(1);
	else
		FIZ_ReputationDetailAtWarCheckBox:SetChecked(nil);
	end
	if ( canToggleAtWar ) then
		FIZ_ReputationDetailAtWarCheckBox:Enable();
		FIZ_ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
	else
		FIZ_ReputationDetailAtWarCheckBox:Disable();
		FIZ_ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end

	if ( IsFactionInactive(faction) ) then
		FIZ_ReputationDetailInactiveCheckBox:SetChecked(1);
	else
		FIZ_ReputationDetailInactiveCheckBox:SetChecked(nil);
	end
	if ( isWatched ) then
		FIZ_ReputationDetailMainScreenCheckBox:SetChecked(1);
	else
		FIZ_ReputationDetailMainScreenCheckBox:SetChecked(nil);
	end
end
-- ^ rfl R_D_F

function FIZ_Friend_Detail(factionID, standingID,factionRow)
	local colorIndex, factionStandingtext, isCappedFriendship;
	local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID);
	if (friendID ~= nil) then
		if ( nextFriendThreshold ) then
			barMin, barMax, barValue = friendThreshold, nextFriendThreshold, friendRep;
		else	-- max rank, make it look like a full bar
			barMin, barMax, barValue = 0, 1, 1;
			isCappedFriendship = true;
		end
		colorIndex = 5;	-- always color friendships green
		factionStandingtext = friendTextLevel;
		factionRow.friendshipID = friendID;
	else
		factionStandingtext = GetText("FACTION_STANDING_LABEL"..standingID, gender);
		factionRow.friendshipID = nil;
		colorIndex = standingID;
	end
	return colorIndex, isCappedFriendship, factionStandingtext
end