------5.04.00.7.2 14.4.27------------------
-- _05_ Slash Handler --
------------------------

function FIZ_SlashHandler(msg)
	if not msg then
		return
	else
		local msgLower = string.lower(msg)
		local words = FIZ_GetWords(msg)
		local wordsLower = FIZ_GetWords(msgLower)
		local size = FIZ_TableSize(wordsLower)
		local FD_SH = FIZ_Data

		if (size>0) then
			if (wordsLower[0]=="enable") then
				if (size>1) then
					if (wordsLower[1]=="mobs") then
						FD_SH.ShowMobs = true
					elseif (wordsLower[1]=="quests") then
						FD_SH.ShowQuests = true
					elseif (wordsLower[1]=="dungeons" or wordsLower[1]=="instances") then
						FD_SH.ShowInstances = true
					elseif (wordsLower[1]=="items") then
						FD_SH.ShowItems = true
					elseif (wordsLower[1]=="general") then
						FD_SH.ShowGeneral = true
					elseif (wordsLower[1]=="missing") then
						FD_SH.ShowMissing = true
					elseif (wordsLower[1]=="details") then
						FD_SH.ExtendDetails = true
					elseif (wordsLower[1]=="chat") then
						FD_SH.WriteChatMessage = true
						FD_SH.NoGuildGain = false
					elseif (wordsLower[1]=="suppress") then
						FD_SH.SuppressOriginalChat = true
					elseif (wordsLower[1]=="preview") then
						FD_SH.ShowPreviewRep = true
					elseif (wordsLower[1]=="bar") then
						FD_SH.SwitchFactionBar = true
						FD_SH.NoGuildSwitch = false
						FD_SH.SilentSwitch = false
					elseif (wordsLower[1]=="all") then
						FD_SH.ShowMobs = true
						FD_SH.ShowQuests = true
						FD_SH.ShowInstances = true
						FD_SH.ShowItems = true
						FD_SH.ShowGeneral = true
						FD_SH.ShowMissing = true
						FD_SH.ExtendDetails = true
						FD_SH.WriteChatMessage = true
						FD_SH.NoGuildGain = false
						FD_SH.SuppressOriginalChat = true
						FD_SH.ShowPreviewRep = true
						FD_SH.SwitchFactionBar = true
						FD_SH.NoGuildSwitch = false
						FD_SH.SilentSwitch = false
					else
						FIZ_PrintSlash(FIZ_TXT.command,msgLower)
					end

					if ( ReputationFrame:IsVisible() ) then
						ReputationFrame_Update(); -- rfl Event
					end
					if ( FIZ_ReputationDetailFrame:IsVisible()) then
						FIZ_BuildUpdateList()
						FIZ_UpdateList_Update()
					end
				else
						FIZ_PrintSlash(FIZ_TXT.command,msgLower)
				end
			elseif (wordsLower[0]=="disable") then
				if (size>1) then
					if (wordsLower[1]=="mobs") then
						FD_SH.ShowMobs = false
					elseif (wordsLower[1]=="quests") then
						FD_SH.ShowQuests = false
					elseif (wordsLower[1]=="dungeons" or wordsLower[1]=="instances") then
						FD_SH.ShowInstances = false
					elseif (wordsLower[1]=="items") then
						FD_SH.ShowItems = false
					elseif (wordsLower[1]=="general") then
						FD_SH.ShowGeneral = false
					elseif (wordsLower[1]=="missing") then
						FD_SH.ShowMissing = false
					elseif (wordsLower[1]=="details") then
						FD_SH.ExtendDetails = false
					elseif (wordsLower[1]=="chat") then
						FD_SH.WriteChatMessage = false
						FD_SH.NoGuildGain = false
					elseif (wordsLower[1]=="suppress") then
						FD_SH.SuppressOriginalChat = false
					elseif (wordsLower[1]=="preview") then
						FD_SH.ShowPreviewRep = false
					elseif (wordsLower[1]=="bar") then
						FD_SH.SwitchFactionBar = false
						FD_SH.NoGuildSwitch = false
						FD_SH.SilentSwitch = false
					elseif (wordsLower[1]=="all") then
						FD_SH.ShowMobs = false
						FD_SH.ShowQuests = false
						FD_SH.ShowInstances = false
						FD_SH.ShowItems = false
						FD_SH.ShowGeneral = false
						FD_SH.ShowMissing = false
						FD_SH.ExtendDetails = false
						FD_SH.WriteChatMessage = false
						FD_SH.NoGuildGain = false
						FD_SH.SuppressOriginalChat = false
						FD_SH.ShowPreviewRep = false
						FD_SH.SwitchFactionBar = false
						FD_SH.NoGuildSwitch = false
						FD_SH.SilentSwitch = false
					else
						FIZ_PrintSlash(FIZ_TXT.command,msgLower)
					end

					if ( ReputationFrame:IsVisible() ) then
						ReputationFrame_Update(); -- rfl Event
					end
					if ( FIZ_ReputationDetailFrame:IsVisible()) then
						FIZ_BuildUpdateList()
						FIZ_UpdateList_Update()
					end
				else
						FIZ_PrintSlash(FIZ_TXT.command,msgLower)
				end
			elseif (wordsLower[0]=="toggle") then
				if (size>1) then
					if (wordsLower[1]=="mobs") then
						FD_SH.ShowMobs = not FD_SH.ShowMobs
					elseif (wordsLower[1]=="quests") then
						FD_SH.ShowQuests = not FD_SH.ShowQuests
					elseif (wordsLower[1]=="dungeons" or wordsLower[1]=="instances") then
						FD_SH.ShowInstances = not FD_SH.ShowInstances
					elseif (wordsLower[1]=="items") then
						FD_SH.ShowItems = not FD_SH.ShowItems
					elseif (wordsLower[1]=="general") then
						FD_SH.ShowGeneral = not FD_SH.ShowGeneral
					elseif (wordsLower[1]=="missing") then
						FD_SH.ShowMissing = not FD_SH.ShowMissing
					elseif (wordsLower[1]=="details") then
						FD_SH.ExtendDetails = not FD_SH.ExtendDetails
					elseif (wordsLower[1]=="chat") then
						FD_SH.WriteChatMessage = not FD_SH.WriteChatMessage
						FD_SH.NoGuildGain = false
					elseif (wordsLower[1]=="suppress") then
						FD_SH.SuppressOriginalChat = not FD_SH.SuppressOriginalChat
					elseif (wordsLower[1]=="preview") then
						FD_SH.ShowPreviewRep = not FD_SH.ShowPreviewRep
					elseif (wordsLower[1]=="preview") then
						FD_SH.SwitchFactionBar = not FD_SH.SwitchFactionBar
						FD_SH.NoGuildSwitch = false
						FD_SH.SilentSwitch = false
					elseif (wordsLower[1]=="all") then
						FD_SH.ShowMobs = not FD_SH.ShowMobs
						FD_SH.ShowQuests = not FD_SH.ShowQuests
						FD_SH.ShowInstances = not FD_SH.ShowInstances
						FD_SH.ShowItems = not FD_SH.ShowItems
						FD_SH.ShowGeneral = not FD_SH.ShowGeneral
						FD_SH.ShowMissing = not FD_SH.ShowMissing
						FD_SH.ExtendDetails = not FD_SH.ExtendDetails
						FD_SH.WriteChatMessage = not FD_SH.WriteChatMessage
						FD_SH.NoGuildGain = false
						FD_SH.SuppressOriginalChat = not FD_SH.SuppressOriginalChat
						FD_SH.ShowPreviewRep = not FD_SH.ShowPreviewRep
						FD_SH.SwitchFactionBar = not FD_SH.SwitchFactionBar
						FD_SH.NoGuildSwitch = false
						FD_SH.SilentSwitch = false
					else
						FIZ_PrintSlash(FIZ_TXT.command,msgLower)
					end

					if ( ReputationFrame:IsVisible() ) then
						ReputationFrame_Update(); -- rfl Event
					end
					if ( FIZ_ReputationDetailFrame:IsVisible()) then
						FIZ_BuildUpdateList()
						FIZ_UpdateList_Update()
					end
				else
						FIZ_PrintSlash(FIZ_TXT.command,msgLower)
				end
			elseif (wordsLower[0]=="list") then
				if (size>1) then
					if (wordsLower[1]=="1" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL1"])) then
						FIZ_ListByStanding(1)
					elseif (wordsLower[1]=="2" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL2"])) then
						FIZ_ListByStanding(2)
					elseif (wordsLower[1]=="3" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL3"])) then
						FIZ_ListByStanding(3)
					elseif (wordsLower[1]=="4" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL4"])) then
						FIZ_ListByStanding(4)
					elseif (wordsLower[1]=="5" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL5"])) then
						FIZ_ListByStanding(5)
					elseif (wordsLower[1]=="6" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL6"])) then
						FIZ_ListByStanding(6)
					elseif (wordsLower[1]=="7" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL7"])) then
						FIZ_ListByStanding(7)
					elseif (wordsLower[1]=="8" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL8"])) then
						FIZ_ListByStanding(8)
					else
						FIZ_PrintSlash(FIZ_TXT.command,msgLower)
					end
				else
					FIZ_ListByStanding()
				end
			elseif (wordsLower[0]=="loc") then
				if (size>1) then
					if (wordsLower[1]=="1" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL1"])) then
						FIZ_ShowGerman(1)
					elseif (wordsLower[1]=="2" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL2"])) then
						FIZ_ShowGerman(2)
					elseif (wordsLower[1]=="3" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL3"])) then
						FIZ_ShowGerman(3)
					elseif (wordsLower[1]=="4" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL4"])) then
						FIZ_ShowGerman(4)
					elseif (wordsLower[1]=="5" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL5"])) then
						FIZ_ShowGerman(5)
					elseif (wordsLower[1]=="6" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL6"])) then
						FIZ_ShowGerman(6)
					elseif (wordsLower[1]=="7" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL7"])) then
						FIZ_ShowGerman(7)
					elseif (wordsLower[1]=="8" or wordsLower[1]==string.lower(_G["FACTION_STANDING_LABEL8"])) then
						FIZ_ShowGerman(8)
					else
						FIZ_PrintSlash(FIZ_TXT.command,msgLower)
					end
				else
					FIZ_ShowGerman()
				end
			elseif (wordsLower[0]=="test") then
				FIZ_Test()
			elseif (wordsLower[0]=="status") then
				FIZ_Status()
			elseif (wordsLower[0]=="help") then
				FIZ_Help()
			elseif (wordsLower[0]=="about") then
				FIZ_About()
			else
				FIZ_PrintSlash(FIZ_TXT.command,msgLower)
			end
		else
			-- do nothing
		end
	end
end