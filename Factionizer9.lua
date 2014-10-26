------5.04.00.7.2 14.4.27------------------
-- _9_ Rep Main Window   --
-----------------------------------
function FIZ_SortByStanding(i,factionIndex,factionRow,factionBar,factionBarPreview,factionTitle,factionButton,factionStanding,factionBackground)
-- v rfl SBS

	local OBS_fi = FIZ_Entries[factionIndex]
	local OBS_fi_i = OBS_fi.i

	if (OBS_fi.header) then
		FIZ_ReputationFrame_SetRowType(factionRow, isChild, OBS_fi.header, hasRep);
		factionRow.LFGBonusRepButton:SetShown(false);
		-- display the standingID as Header
		if (OBS_fi_i == 8) then
			factionTitle:SetText(GetText("FACTION_STANDING_LABEL"..OBS_fi_i, gender).." ("..tostring(OBS_fi.size)..")");
		else
			factionTitle:SetText(GetText("FACTION_STANDING_LABEL"..OBS_fi_i, gender).." -> "..GetText("FACTION_STANDING_LABEL"..OBS_fi_i+1, gender).." ("..tostring(OBS_fi.size)..")");
		end
-- v rfl SBS 2
-- v rfl SBS 2.1
		if ( FIZ_Collapsed[OBS_fi_i] ) then
-- ^ rfl SBS 2.1
			factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
		else
			factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
		end
		factionRow.index = factionIndex
-- v rfl 2.2.2
		factionRow.isCollapsed = FIZ_Collapsed[OBS_fi_i];
-- ^ rfl SBS 2.2
-- ^ rfl SBS 2
	else
-- v rfl SBS 1
		-- get the info for this Faction
		local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(OBS_fi_i);
		factionTitle:SetText(name);
-- ^ rfl SBS 1
-- v rfl _16_
	local colorIndex, isCappedFriendship, factionStandingtext  = FIZ_Friend_Detail(factionID, standingID, factionRow);
-- ^ rfl  _16_
-- v rfl SBS 4
		-- Normalize Values

		local origBarValue = barValue

		barMax = barMax - barMin;
		barValue = barValue - barMin;
		barMin = 0;
-- ^ rfl SBS 4
-- v rfl SBS 3
-- v rfl SBS 3.1
		local toExalted = 0
		if (standingID <8) then
			toExalted = FIZ_ToExalted[standingID] + barMax - barValue;
		end

		factionRow.index = OBS_fi_i;

		if (FIZ_Data.ShowMissing) then
			factionRow.standingText = factionStandingtext.." ("..barMax - barValue..")";
		else
-- ^ rfl SBS 3.1
			factionRow.standingText = factionStandingtext;
-- v rfl SBS 3.2
		end
-- ^ rfl SBS 3.2
-- ^ rfl SBS 3
-- v rfl SBS 5
-- v rfl SBS 5.1
		factionStanding:SetText(factionRow.standingText);
-- ^ rfl SBS 5.1
		if ( isCappedFriendship ) then
			factionRow.tooltip = nil;
		else
			factionRow.tooltip = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE;
		end
		factionBar:SetMinMaxValues(0, barMax);
		factionBar:SetValue(barValue);
		local color = FACTION_BAR_COLORS[standingID];
		factionBar:SetStatusBarColor(color.r, color.g, color.b);
		factionBar.BonusIcon:SetShown(hasBonusRepGain);
		factionRow.LFGBonusRepButton.factionID = factionID;
		factionRow.LFGBonusRepButton:SetShown(canBeLFGBonus);
		factionRow.LFGBonusRepButton:SetChecked(lfgBonusFactionID == factionID);
		factionRow.LFGBonusRepButton:SetEnabled(lfgBonusFactionID ~= factionID);
-- ^ rfl SBS 5
		local previewValue = 0
		if (FIZ_Data.ShowPreviewRep) then
			previewValue = FIZ_GetReadyReputation(OBS_fi_i)
		end
		if ((previewValue > 0) and not ((standingID==8) and (barMax-barValue == 1) ) ) then
			factionBarPreview:Show()
			factionBarPreview:SetMinMaxValues(0, barMax)
			previewValue = previewValue + barValue
			if (previewValue > barMax) then previewValue = barMax end
			factionBarPreview:SetValue(previewValue)
			factionBarPreview:SetID(factionIndex)
			factionBarPreview:SetStatusBarColor(0.8, 0.8, 0.8, 0.5)
		else
			factionBarPreview:Hide()
		end
-- v rfl SBS 6
-- v rfl SBS 6.1
		FIZ_ReputationFrame_SetRowType(factionRow, isChild, OBS_fi.header, hasRep);
-- ^ rfl SBS 6.1
		factionRow:Show();
		-- Update details if this is the selected Faction
		if ( atWarWith ) then
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:Show();
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:Show();
		else
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:Hide();
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:Hide();
		end
		-- Update details if this is the selected faction
-- v rfl SBS 6
-- v rfl SBS 6.1
		if ( OBS_fi_i == GetSelectedFaction() ) then
-- ^ rfl SBS 6.1
			if ( ReputationDetailFrame:IsShown() ) then
-- ^ rfl SBS 6
				if ( canToggleAtWar ) then local flag = 1 end
-- v rfl _16_
				FIZ_ReputationDetailFrame_IsShown(OBS_fi_I,flag,1,i)
-- ^ rfl _16_
			end

			if ( FIZ_ReputationDetailFrame:IsVisible() ) then FIZ_Rep_Detail_Frame(OBS_fi_i,standingID,barValue,barMax,origBarValue,standingID,toExalted,factionStandingtext) end
			_G["ReputationBar"..i.."ReputationBarHighlight1"]:Show();
			_G["ReputationBar"..i.."ReputationBarHighlight2"]:Show();


-- v rfl SBS 7
		else
			_G["ReputationBar"..i.."ReputationBarHighlight1"]:Hide();
			_G["ReputationBar"..i.."ReputationBarHighlight2"]:Hide();
		end
-- ^ rfl SBS 7
	end

end
function FIZ_OriginalRepOrder(i,factionIndex,factionRow,factionBar,factionBarPreview,factionTitle,factionButton,factionStanding,factionBackground)
-- v rfl ORO


-- v rfl ORO 1
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex);
	factionTitle:SetText(name);
-- ^ rfl ORO 1
-- v rfl ORO 2



	if ( isCollapsed ) then

		factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
	else
		factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
	end
	factionRow.index = factionIndex;

	factionRow.isCollapsed = isCollapsed;

-- ^ rfl ORO 2






-- v rfl _16_
	local colorIndex, isCappedFriendship, factionStandingtext  = FIZ_Friend_Detail(factionID, standingID, factionRow);
-- ^ rfl  _16_
	-- Normalize Values

	local origBarValue = barValue

	barMax = barMax - barMin;
	barValue = barValue - barMin;
	barMin = 0;
-- ^ rfl ORO 4
-- v rfl ORO 3
-- v rfl ORO 3.1
	local toExalted = 0
	if (standingID <8) then
		toExalted = FIZ_ToExalted[standingID] + barMax - barValue;
	end



	if (FIZ_Data.ShowMissing) then
		factionRow.standingText = factionStandingtext.." ("..barMax - barValue..")";
	else
-- ^ rfl ORO 3.1
		factionRow.standingText = factionStandingtext;
-- v rfl ORO 3.2
	end
-- ^ rfl ORO 3.2
-- ^ rfl ORO 3
-- v rfl ORO 5
-- v rfl ORO 5.1
	factionStanding:SetText(factionRow.standingText);
-- ^ rfl ORO 5.1
	if ( isCappedFriendship ) then
		factionRow.tooltip = nil;
	else
		factionRow.tooltip = HIGHLIGHT_FONT_COLOR_CODE.." "..barValue.." / "..barMax..FONT_COLOR_CODE_CLOSE;
	end
	factionBar:SetMinMaxValues(0, barMax);
	factionBar:SetValue(barValue);
	local color = FACTION_BAR_COLORS[colorIndex];
	factionBar:SetStatusBarColor(color.r, color.g, color.b);
	factionBar.BonusIcon:SetShown(hasBonusRepGain);
	factionRow.LFGBonusRepButton.factionID = factionID;
	factionRow.LFGBonusRepButton:SetShown(canBeLFGBonus);
	factionRow.LFGBonusRepButton:SetChecked(lfgBonusFactionID == factionID);
	factionRow.LFGBonusRepButton:SetEnabled(lfgBonusFactionID ~= factionID);
-- ^ rfl ORO 5
	local previewValue = 0
	if (FIZ_Data.ShowPreviewRep) then
		previewValue = FIZ_GetReadyReputation(factionIndex)
	end
	if ((previewValue > 0) and not ((standingID==8) and (barMax-barValue == 1) ) ) then
		factionBarPreview:Show()
		factionBarPreview:SetMinMaxValues(0, barMax)
		previewValue = previewValue + barValue
		if (previewValue > barMax) then previewValue = barMax end
		factionBarPreview:SetValue(previewValue)
		factionBarPreview:SetID(factionIndex)
		factionBarPreview:SetStatusBarColor(0.8, 0.8, 0.8, 0.5)
	else
	---	factionBarPreview:Hide()
	end
-- v rfl ORO 6

	ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep);

	factionRow:Show();
	-- Update details if this is the selected Faction
	if ( atWarWith ) then
		_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:Show();
		_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:Show();
	else
		_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:Hide();
		_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:Hide();
	end

	if ( factionIndex == GetSelectedFaction() ) then

		if ( ReputationDetailFrame:IsShown() ) then
-- ^ rfl ORO 6
			if ( canToggleAtWar and (not isHeader)) then local flag = 1 end
-- v rfl _16_
			FIZ_ReputationDetailFrame_IsShown(factionIndex,flag,2,i)
-- ^ rfl _16_
		end
-- ^ rfl 1.5
		if ( FIZ_ReputationDetailFrame:IsVisible() ) then 
			FIZ_Rep_Detail_Frame(factionIndex,colorIndex,barValue,barMax,origBarValue,standingID,toExalted,factionStandingtext) 
			_G["ReputationBar"..i.."ReputationBarHighlight1"]:Show();
			_G["ReputationBar"..i.."ReputationBarHighlight2"]:Show();
		end
	else
		_G["ReputationBar"..i.."ReputationBarHighlight1"]:Hide();
		_G["ReputationBar"..i.."ReputationBarHighlight2"]:Hide();
	end
-- v rfl 1.6.1
end