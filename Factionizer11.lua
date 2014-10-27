-----------------------------------
-- _11_ Prepare update entries	 --
-----------------------------------
function FIZ_ParseBagContent()
	--fpt hed f_pbc	FIZ_Printtest("","","f_pbc 1")
	FIZ_ItemsCarried = {}

	for i = 0, NUM_BAG_SLOTS do
		local num = GetContainerNumSlots(i)
		for j = 1, num do
			local link = GetContainerItemLink(i, j)
			-- |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0|h[Broken Fang]|h|r
			if link then
				local count = GetItemCount(link)
				local _, _, itemString, itemName = string.find(link, "^|c%x+|H(.+)|h%[(.+)%]")
				if count and itemName then
					if (not FIZ_ItemsCarried[itemName]) then
						FIZ_ItemsCarried[itemName] = count
					end
				end
			end
		end
	end
end

function FIZ_ParseBankContent()
	--fpt hed f_pBc	FIZ_Printtest("","","f_pBc 1")
	if (not FIZ_Data.Bank) then FIZ_Data.Bank = {} end
	FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] = {}

	local i = BANK_CONTAINER
	local num = GetContainerNumSlots(i)
	for j = 1, num do
		local link = GetContainerItemLink(i, j)
		-- |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0|h[Broken Fang]|h|r
		if link then
			local count = GetItemCount(link)
			local _, count = GetContainerItemInfo(i, j);
			local _, _, itemString, itemName = string.find(link, "^|c%x+|H(.+)|h%[(.+)%]")
			if count and itemName then
				if (FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName]) then
					FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] + count
				else
					FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] = count
				end
			end
		end
	end

	for i = NUM_BAG_SLOTS+NUM_BAG_SLOTS + NUM_BANKBAGSLOTS, NUM_BAG_SLOTS do
		local num = GetContainerNumSlots(i)
		for j = 1, num do
			local link = GetContainerItemLink(i, j)
			-- |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0|h[Broken Fang]|h|r
			if link then
				local count = GetItemCount(link)
				local _, count = GetContainerItemInfo(i, j);
				local _, _, itemString, itemName = string.find(link, "^|c%x+|H(.+)|h%[(.+)%]")
				if count and itemName then
					if (FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName]) then
						FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] + count
					else
						FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][itemName] = count
					end
				end
			end
		end
	end
end

function FIZ_Update_Tooltip(FIZ_Set,FIZ_Detail_1,FIZ_Detail_2)
	--- fpt hed f_u_t	FIZ_Printtest("","","f_u_t 1")
	--- fpt ddd	fiz_printtest(FIZ_Set,FIZ_Detail_1,FIZ_Detail_2)
	FIZ_UpdateList[index].tooltipDetails[FIZ_Set] = {}
	FIZ_UpdateList[index].tooltipDetails[FIZ_Set].l = FIZ_Detail_1
	FIZ_UpdateList[index].tooltipDetails[FIZ_Set].r = FIZ_Detail_2
end

function FIZ_BuildUpdateList() --xxx
	--- fpt hed f_bul	FIZ_Printtest("","","f_bul 1")
	FIZ_UpdateList = {}
	FIZ_CurrentRepInBag = 0
	FIZ_CurrentRepInBagBank = 0
	FIZ_CurrentRepInQuest = 0
	local index = 1

	if (not FIZ_ReputationDetailFrame:IsVisible()) then
		return
	end

--- fpt pbc	FIZ_ParseBagContent()

	local factionIndex = GetSelectedFaction()
	local faction, description, standingId, barMin, barMax, barValue = GetFactionInfo(factionIndex)

	if (faction) then
		origFaction = faction
		oFaction = string.lower(faction)
		faction = string.lower(faction)
		if (FIZ_FactionMapping[faction]) then
			faction = FIZ_FactionMapping[faction]
		end
		-- Normalize Values
		local normMax = barMax - barMin
		local normCurrent = barValue - barMin
		local repToNext = barMax - barValue
		if (FIZ_FactionGain[oFaction]) then
			local fg_sid=FIZ_FactionGain[oFaction][standingId]
			if (fg_sid) then
				-- instances
				if (fg_sid.instance and FIZ_Data.ShowInstances) then
					local fg_sid_x=fg_sid.instance
					for i = 0, fg_sid.instance.count do
						local fg_sid_x_d=fg_sid_x.data[i]
						if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
							local toDo = string.format("%.2f", repToNext / fg_sid_x_d.rep)
							if (fg_sid_x_d.limit) then
								toDo = string.format("%.2f", (fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
							end --zzz
							FIZ_UpdateList[index] = {}
							local FUL_I = FIZ_UpdateList[index]
							FUL_I.type = FIZ_TXT.instanceShort
							FUL_I.times = toDo.."x"
							FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
							FUL_I.hasList = false
							FUL_I.listShown = nil
							FUL_I.index = index
							FUL_I.belongsTo = nil
							FUL_I.isShown = true
							FUL_I.name = fg_sid_x_d.name.." ("..fg_sid_x_d.level..")"

							FUL_I.tooltipHead = FIZ_TXT.instanceHead
							FUL_I.tooltipTip = FIZ_TXT.instanceTip

							FUL_I.tooltipDetails = {}
							local FUL_I_TD = FUL_I.tooltipDetails
							local x = 0
--- ddd							FIZ_Update_Tooltip(x, FIZ_TXT.instance2, fg_sid_x_d.name)
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.instance2
							FUL_I_TD[x].r = fg_sid_x_d.name

							x = x+1
--- ddd							FIZ_Update_Tooltip(x, FIZ_TXT.mode, fg_sid_x_d.level)
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.mode
							FUL_I_TD[x].r = fg_sid_x_d.level
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.reputation
							FUL_I_TD[x].r = FUL_I.rep
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.timesToRun
							FUL_I_TD[x].r = FUL_I.times
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = " "
							FUL_I_TD[x].r = " "
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.maxStanding
							FUL_I_TD[x].r = _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding]
							FUL_I_TD.count = x
							FUL_I.tooltipDetails = FUL_I_TD
							FIZ_UpdateList[index] = FUL_I
							index = index + 1
						end
					end
				end

				-- mobs
				if (fg_sid.mobs and FIZ_Data.ShowMobs) then
					local fg_sid_x=fg_sid.mobs
					for i = 0, fg_sid_x.count do
					local fg_sid_x_d=fg_sid_x.data[i]
						if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
							local toDo = ceil(repToNext / fg_sid_x_d.rep)
							if (fg_sid_x_d.limit) then
								toDo = ceil((fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
							end
							FIZ_UpdateList[index] = {}
							local FUL_I = FIZ_UpdateList[index]
							FUL_I.type = FIZ_TXT.mobShort
							FUL_I.times = toDo.."x"
							FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
							FUL_I.hasList = false
							FUL_I.listShown = nil
							FUL_I.index = index
							FUL_I.belongsTo = nil
							FUL_I.isShown = true
							FUL_I.tooltipHead = FIZ_TXT.mobHead
							FUL_I.tooltipTip = FIZ_TXT.mobTip
							if (fg_sid_x_d.zone) then
								FUL_I.name = fg_sid_x_d.name.." ("..fg_sid_x_d.zone..")"
								FUL_I.tooltipDetails = {}
								local FUL_I_TD = FUL_I.tooltipDetails
								local x = 0
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.mob2
								FUL_I_TD[x].r = fg_sid_x_d.name
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.location
								FUL_I_TD[x].r = fg_sid_x_d.zone
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.reputation
								FUL_I_TD[x].r = FUL_I.rep
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.toDo
								FUL_I_TD[x].r = FUL_I.times
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = " "
								FUL_I_TD[x].r = " "
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.maxStanding
								FUL_I_TD[x].r = _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding]
								FUL_I_TD.count = x
							else
								FUL_I.name = fg_sid_x_d.name
								FUL_I_TD = {}
								local x = 0
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.mob2
								FUL_I_TD[x].r = fg_sid_x_d.name
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.reputation
								FUL_I_TD[x].r = FUL_I.rep
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.toDo
								FUL_I_TD[x].r = FUL_I.times
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = " "
								FUL_I_TD[x].r = " "
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.maxStanding
								FUL_I_TD[x].r = _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding]
								FUL_I_TD.count = x
								FUL_I.tooltipDetails = FUL_I_TD
							end
							FIZ_UpdateList[index] = FUL_I
							index = index + 1
						end
					end
				end

				-- quests (may have items)
				local sum = 0
				local count = 0
				if (fg_sid.quests and FIZ_Data.ShowQuests) then
					local fg_sid_x=fg_sid.quests
					for i = 0, fg_sid_x.count do
					local fg_sid_x_d=fg_sid_x.data[i]
					local showQuest = true
					if (fg_sid_x_d.profession) then
						local fg_sid_x_d_p=fg_sid_x_d.profession
						if ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Herb) and not FIZ_Herb) then
							-- if list of known professions does not contain Herbology
							showQuest = false
							--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because you do not know Herbalism")
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Skin) and not FIZ_Skin) then
							-- if list of known professions does not contain Herbology
							showQuest = false
							--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because you do not know Skinning")
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Mine) and not FIZ_Mine) then
							-- if list of known professions does not contain Herbology
							showQuest = false
							--FIZ_Print("Not showing quest ["..FIZ_FactionGain[faction][standingId].quests.data[i].name.."] because you do not know mining")
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Gather) and not (FIZ_Herb or FIZ_Skin or FIZ_Mine)) then
							-- no gathering profession
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Jewe) and not FIZ_Jewel) then
							-- if list of known professions does not contain jewelcrafting
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Cook) and not FIZ_Cook) then
							-- if list of known professions does not contain jewelcrafting
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Arch) and not FIZ_Arch) then
							-- if list of known professions does not contain jewelcrafting
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Fish) and not FIZ_Fish) then
							-- if list of known professions does not contain jewelcrafting
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Aid) and not FIZ_Aid) then
							-- if list of known professions does not contain jewelcrafting
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Blac) and not FIZ_Black) then
							-- if list of known professions does not contain BLACKsmith
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Tail) and not FIZ_Tailor) then
							-- if list of known professions does not contain tailor
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Leat) and not FIZ_Leath) then
							-- if list of known professions does not contain leather
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Ench) and not FIZ_Enchan) then
							-- if list of known professions does not contain enchanter
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Engi) and not FIZ_Engin) then
							-- if list of known professions does not contain BLACKsmith
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Incr) and not FIZ_Incrip) then
							-- if list of known professions does not contain leather
							showQuest = false
						elseif ((fg_sid_x_d_p == FIZ_LIMIT_TYPE_Alch) and not FIZ_Alche) then
							-- if list of known professions does not contain enchanter
							showQuest = false
						else
							-- unexpected limit -> ignore this and still show quest ggg
						end
					end

					if (showQuest) then
						if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
							local toDo = ceil(repToNext / fg_sid_x_d.rep)
							if (fg_sid_x_d.limit) then
								toDo = ceil((fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
							end
							FIZ_UpdateList[index] = {}
							local FUL_I = FIZ_UpdateList[index]
							FUL_I.type = FIZ_TXT.questShort
							FUL_I.times = toDo.."x"
							FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
							FUL_I.index = index
							FUL_I.belongsTo = nil
							FUL_I.isShown = true
							FUL_I.name = fg_sid_x_d.name
							FUL_I.originalName = FUL_I.name
							FUL_I.faction = faction
							FUL_I.canSuppress = true
							FUL_I.suppress = nil
							if (FIZ_Suppressed and FIZ_Suppressed[oFaction] and FIZ_Suppressed[oFaction][FUL_I.originalName]) then
								FUL_I.suppress = true
							end
							FUL_I.tooltipHead = FIZ_TXT.questHead
							FUL_I.tooltipTip = FIZ_TXT.questTip

							FUL_I.tooltipDetails = {}
							local FUL_I_TD = FUL_I.tooltipDetails
							local x = 0
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.quest2
							FUL_I_TD[x].r = FUL_I.name
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.reputation
							FUL_I_TD[x].r = FUL_I.rep
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.timesToDo
							FUL_I_TD[x].r = FUL_I.times
							x = x+1

							if (not FUL_I.suppress) then
								sum = sum + fg_sid_x_d.rep
								count = count + 1
							end

							if (fg_sid_x_d.items) then
								FUL_I.hasList = true
								FUL_I.listShown = false

								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = " "
								FUL_I_TD[x].r = " "
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.itemsRequired
								FUL_I_TD[x].r = " "
								x = x+1

								-- quest In log?
								FUL_I.lowlight = nil

								-- check if this quest is known
								local entries, quests = GetNumQuestLogEntries()
								for z=1,entries do
									local title,level,tag,group,header,collapsed,complete,daily = GetQuestLogTitle(z)
									if (title and not header) then
										if string.find(string.lower(fg_sid_x_d.name), string.lower(title)) then
											-- this quest matches
											FUL_I.lowlight = true
											FUL_I.name = FUL_I.name..FIZ_QUEST_ACTIVE_COLOUR.." ("..FIZ_TXT.active..")|r"
										end
									end
								end

								-- add items
								local itemIndex = index+1

								local currentQuestTimesBag = -1
								local currentQuestTimesBagBank = -1
								for item in pairs(fg_sid_x_d.items) do
									FIZ_UpdateList[itemIndex] = {}
									local FUL_II = FIZ_UpdateList[itemIndex]
									FUL_II.type = ""
									FUL_II.times = (fg_sid_x_d.items[item] * toDo).."x"
									FUL_II.rep = nil
									FUL_II.index = itemIndex
									FUL_II.belongsTo = index
									FUL_II.hasList = nil
									FUL_II.listShown = nil
									FUL_II.isShown = FUL_I.listShown
									FUL_II.name = item.." ("..fg_sid_x_d.items[item].."x)"

									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = fg_sid_x_d.items[item].."x"
									FUL_I_TD[x].r = item
									x = x+1

									if (FIZ_ItemsCarried and FIZ_ItemsCarried[item]) then
										if ((FIZ_ItemsCarried[item] >= fg_sid_x_d.items[item]) and (fg_sid_x_d.items[item] > 0)) then
											FUL_II.name = FUL_II.name..FIZ_BAG_COLOUR.." ["..FIZ_ItemsCarried[item].."x]|r"
											FUL_II.currentTimesBag = floor(FIZ_ItemsCarried[item] / fg_sid_x_d.items[item])
											if (currentQuestTimesBag == -1) then
												-- first items for this quest --> take value
												currentQuestTimesBag = FUL_II.currentTimesBag
											else
												-- some items already Set
												if (FUL_II.currentTimesBag < currentQuestTimesBag) then
													-- fewer of this item than of others, reduce quest count
													currentQuestTimesBag = FUL_II.currentTimesBag
												end
											end
										else
											-- not enough of this item for quest -> set to 0
											currentQuestTimesBag = 0
											FUL_II.name = FUL_II.name.." ["..FIZ_ItemsCarried[item].."x]"
										end
										if (FIZ_Data.Bank and
											FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] and
											FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item]) then
											local total = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item] + FIZ_ItemsCarried[item]
											if ((total >= fg_sid_x_d.items[item]) and (fg_sid_x_d.items[item] > 0)) then
												FUL_II.name = FUL_II.name..FIZ_BAG_BANK_COLOUR.." ["..total.."x]|r"
												FUL_II.currentTimesBagBank = floor(total / fg_sid_x_d.items[item])
												if (currentQuestTimesBagBank == -1) then
													-- first items for this quest --> take value
													currentQuestTimesBagBank = FUL_II.currentTimesBagBank
												else
													-- some items already Set
													if (FUL_II.currentTimesBagBank < currentQuestTimesBagBank) then
														-- fewer of this item than of others, reduce quest count
														currentQuestTimesBagBank = FUL_II.currentTimesBagBank
													end
												end
											else
												-- not enough of this item for quest -> set to 0
												currentQuestTimesBagBank = 0
												FUL_II.name = FUL_II.name.." ["..total.."x]"
											end
										else
											-- none of this carried In bank
										end
									else
										-- not enough of this item for quest -> set to 0
										currentQuestTimesBag = 0
									end
									FIZ_UpdateList[itemIndex] = FUL_II
									itemIndex = itemIndex + 1
								end
								if (currentQuestTimesBag > 0) then
									FUL_I.name = FUL_I.name..FIZ_BAG_COLOUR.." ["..currentQuestTimesBag.."x]|r"
									FUL_I.currentTimesBag = currentQuestTimesBag
									FUL_I.currentRepBag = currentQuestTimesBag * FUL_I.rep
									FUL_I.highlight = true
									FUL_I.name = FUL_I.originalName
									FUL_I.lowlight = nil
									FIZ_CurrentRepInBag = FIZ_CurrentRepInBag + FUL_I.currentRepBag

									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = " "
									FUL_I_TD[x].r = " "
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = FIZ_TXT.inBag
									FUL_I_TD[x].r = " "
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = FIZ_TXT.turnIns
									FUL_I_TD[x].r = string.format("%d", FUL_I.currentTimesBag)
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = FIZ_TXT.reputation
									FUL_I_TD[x].r = string.format("%d", FUL_I.currentRepBag)
									x = x+1
								else
									FUL_I.currentTimesBag = nil
									FUL_I.currentRepBag = nil
								end
								if (currentQuestTimesBagBank > 0) then
									FUL_I.name = FUL_I.name..FIZ_BAG_BANK_COLOUR.." ["..currentQuestTimesBagBank.."x]|r"
									FUL_I.currentTimesBagBank = currentQuestTimesBagBank
									FUL_I.currentRepBagBank = currentQuestTimesBagBank * FUL_I.rep
									FUL_I.highlight = true
									FUL_I.name = FUL_I.originalName
									FUL_I.lowlight = nil
									FIZ_CurrentRepInBagBank = FIZ_CurrentRepInBagBank + FUL_I.currentRepBagBank

									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = " "
									FUL_I_TD[x].r = " "
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = FIZ_TXT.inBagBank
									FUL_I_TD[x].r = " "
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = FIZ_TXT.turnIns
									FUL_I_TD[x].r = string.format("%d", FUL_I.currentTimesBagBank)
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = FIZ_TXT.reputation
									FUL_I_TD[x].r = string.format("%d", FUL_I.currentRepBagBank)
									x = x+1
								else
									FUL_I.currentTimesBagBank = nil
									FUL_I.currentRepBagBank = nil
								end
								if ((currentQuestTimesBag == 0) and (currentQuestTimesBagBank)) then
									FUL_I.highlight = nil
								end

								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = " "
								FUL_I_TD[x].r = " "
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.maxStanding
								FUL_I_TD[x].r = _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding]
								x = x+1

								FUL_I_TD.count = x-1
								index = itemIndex
							else
								-- no items to add
								FUL_I.hasList = false
								FUL_I.listShown = nil
								FUL_I.highlight = nil	-- will be Changed below if needed
								FUL_I.lowlight = nil

								-- check if this quest is known and/or completed
								local entries, quests = GetNumQuestLogEntries()
								for z=1,entries do
									local title,level,tag,group,header,collapsed,complete,daily = GetQuestLogTitle(z)
									if (title and not header) then
										if string.find(string.lower(fg_sid_x_d.name), string.lower(title)) then
											-- this quest matches
											if (complete) then
												FUL_I.highlight = true
												FUL_I.name = FUL_I.name..FIZ_QUEST_COLOUR.." ("..FIZ_TXT.complete..")|r"
												FUL_I.currentTimesQuest = 1
												FUL_I.currentRepQuest = FUL_I.rep

												FIZ_CurrentRepInQuest = FIZ_CurrentRepInQuest + fg_sid_x_d.rep

												FUL_I_TD[x] = {}
												FUL_I_TD[x].l = " "
												FUL_I_TD[x].r = " "
												x = x+1
												FUL_I_TD[x] = {}
												FUL_I_TD[x].l = FIZ_TXT.questCompleted
												FUL_I_TD[x].r = " "
												x = x+1
												FUL_I_TD[x] = {}
												FUL_I_TD[x].l = FIZ_TXT.reputation
												FUL_I_TD[x].r = string.format("%d", FUL_I.currentRepQuest)
												x = x+1
											else
												FUL_I.lowlight = true
												FUL_I.name = FUL_I.name..FIZ_QUEST_ACTIVE_COLOUR.." ("..FIZ_TXT.active..")|r"
											end
										end
									end
								end

								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = " "
								FUL_I_TD[x].r = " "
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.maxStanding
								FUL_I_TD[x].r = _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding]
								x = x+1

								FUL_I_TD.count = x-1
								FIZ_UpdateList[index] = FUL_I
								index = index + 1
							end
						end
					end
				end
				if ((sum > 0) and (count > 1)) then
					-- add virtual quest to show summary of all quests:
					local toDo = ceil(repToNext / sum)
					FIZ_UpdateList[index] = {}
					local FUL_I = FIZ_UpdateList[index]
					FUL_I.type = FIZ_TXT.questShort
					FUL_I.times = toDo.."x"
					FUL_I.rep = string.format("%d", sum)
					FUL_I.index = index
					FUL_I.belongsTo = nil
					FUL_I.isShown = true
					FUL_I.name = string.format(FIZ_TXT.allOfTheAbove, count)
					FUL_I.tooltipHead = string.format(FIZ_TXT.questSummaryHead, count)
					FUL_I.tooltipTip = FIZ_TXT.questSummaryTip

					FUL_I_TD = {}
					local x = 0
					FUL_I_TD[x] = {}
					FUL_I_TD[x].l = FIZ_TXT.reputation
					FUL_I_TD[x].r = FUL_I.rep
					x = x+1
					FUL_I_TD[x] = {}
					FUL_I_TD[x].l = FIZ_TXT.timesToDo
					FUL_I_TD[x].r = FUL_I.times
					FUL_I_TD.count = x
					FUL_I.tooltipDetails = FUL_I_TD
					FIZ_UpdateList[index] = FUL_I
					index = index + 1
				end
			end

			-- items
			if (fg_sid.items and FIZ_Data.ShowItems) then
				local fg_sid_x=fg_sid.items
				for i = 0, fg_sid_x.count do
				local fg_sid_x_d=fg_sid_x.data[i]
					if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
						local toDo = ceil(repToNext / fg_sid_x_d.rep)
						if (fg_sid_x_d.limit) then
							toDo = ceil((fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
						end
						if (fg_sid_x_d.items) then
							FIZ_UpdateList[index] = {}
							local FUL_I = FIZ_UpdateList[index]
							FUL_I.type = FIZ_TXT.itemsShort
							FUL_I.times = toDo.."x"
							FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
							FUL_I.index = index
							FUL_I.belongsTo = nil
							FUL_I.isShown = true
							FUL_I.name = FIZ_TXT.itemsName
							FUL_I.hasList = true
							FUL_I.listShown = false
							FUL_I.tooltipHead = FIZ_TXT.itemsHead
							FUL_I.tooltipTip = FIZ_TXT.itemsTip

							FUL_I.tooltipDetails = {}
							local FUL_I_TD = FUL_I.tooltipDetails
							local x = 0
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FUL_I.name
							FUL_I_TD[x].r = " "
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = " "
							FUL_I_TD[x].r = " "
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.itemsRequired
							FUL_I_TD[x].r = " "
							x = x+1

							-- add items
							local itemIndex = index+1

							local currentQuestTimesBag = -1
							local currentQuestTimesBagBank = -1
							for item in pairs(fg_sid_x_d.items) do
								FIZ_UpdateList[itemIndex] = {}
								local FUL_II = FIZ_UpdateList[itemIndex]
								FUL_II.type = ""
								FUL_II.times = (fg_sid_x_d.items[item] * toDo).."x"
								FUL_II.rep = nil
								FUL_II.index = itemIndex
								FUL_II.belongsTo = index
								FUL_II.hasList = nil
								FUL_II.listShown = nil
								FUL_II.isShown = FUL_I.listShown
								FUL_II.name = item.." ("..fg_sid_x_d.items[item].."x)"

								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = fg_sid_x_d.items[item].."x"
								FUL_I_TD[x].r = item
								x = x+1

								if (FIZ_ItemsCarried and FIZ_ItemsCarried[item]) then
									if ((FIZ_ItemsCarried[item] >= fg_sid_x_d.items[item]) and (fg_sid_x_d.items[item] > 0)) then
										FUL_II.currentTimesBag = floor(FIZ_ItemsCarried[item] / fg_sid_x_d.items[item])
										FUL_II.name = FUL_II.name..FIZ_BAG_COLOUR.." ["..FIZ_ItemsCarried[item].."x]|r"
										if (currentQuestTimesBag == -1) then
											-- first items for this quest --> take value
											currentQuestTimesBag = FUL_II.currentTimesBag
										else
											-- some items already Set
											if (FUL_II.currentTimesBag < currentQuestTimesBag) then
												-- fewer of this item than of others, reduce quest count
												currentQuestTimesBag = FUL_II.currentTimesBag
											end
										end
									else
										-- not enough of this item for quest -> set to 0
										currentQuestTimesBag = 0
										FUL_II.name = FUL_II.name.." ["..FIZ_ItemsCarried[item].."x]"
									end
									if (FIZ_Data.Bank and
										FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] and
										FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item]) then
										local total = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item] + FIZ_ItemsCarried[item]
										if ((total >= fg_sid_x_d.items[item]) and (fg_sid_x_d.items[item] > 0)) then
											FUL_II.name = FUL_II.name..FIZ_BAG_BANK_COLOUR.." ["..total.."x]|r"
											FUL_II.currentTimesBagBank = floor(total / fg_sid_x_d.items[item])
											if (currentQuestTimesBagBank == -1) then
												-- first items for this quest --> take value
												currentQuestTimesBagBank = FUL_II.currentTimesBagBank
											else
												-- some items already Set
												if (FUL_II.currentTimesBagBank < currentQuestTimesBagBank) then
													-- fewer of this item than of others, reduce quest count
													currentQuestTimesBagBank = FUL_II.currentTimesBagBank
												end
											end
										else
											-- not enough of this item for quest -> set to 0
											currentQuestTimesBagBank = 0
											FUL_II.name = FUL_II.name.." ["..total.."x]"
										end
									else
										-- none of this carried In bank
									end
								else
									-- not enough of this item for quest -> set to 0
									currentQuestTimesBag = 0
								end
								FIZ_UpdateList[itemIndex] = FUL_II
								itemIndex = itemIndex + 1
							end
							if (currentQuestTimesBag > 0) then
								FUL_I.highlight = true
								FUL_I.lowlight = nil
								FUL_I.name = FUL_I.name..FIZ_BAG_COLOUR.." ["..currentQuestTimesBag.."x]|r"
								FUL_I.currentTimesBag = currentQuestTimesBag
								FUL_I.currentRepBag = currentQuestTimesBag * FUL_I.rep
								FIZ_CurrentRepInBag = FIZ_CurrentRepInBag + FUL_I.currentRepBag

								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = " "
								FUL_I_TD[x].r = " "
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.inBag
								FUL_I_TD[x].r = " "
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.turnIns

								FUL_I_TD[x].r = string.format("%d", FUL_I.currentTimesBag)
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.reputation
								FUL_I_TD[x].r = string.format("%d", FUL_I.currentRepBag)
								x = x+1
							else
								FUL_I.currentTimesBag = nil
								FUL_I.currentRepBag = nil
								FUL_I.highlight = nil
							end
							if (currentQuestTimesBagBank > 0) then
								FUL_I.highlight = true
								FUL_I.lowlight = nil
								FUL_I.name = FUL_I.name..FIZ_BAG_BANK_COLOUR.." ["..currentQuestTimesBagBank.."]|r"
								FUL_I.currentTimesBagBank = currentQuestTimesBagBank

								FUL_I.currentRepBagBank = currentQuestTimesBagBank * FUL_I.rep
								FIZ_CurrentRepInBagBank = FIZ_CurrentRepInBagBank + FUL_I.currentRepBagBank

								FUL_I_TD[x] = {}
								if (not FIZ_UpdateList[index].hasList) then return end	-- not a list Header entry
									FUL_I_TD[x].l = " "
									FUL_I_TD[x].r = " "
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = FIZ_TXT.inBagBank
									FUL_I_TD[x].r = " "
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = FIZ_TXT.turnIns
									FUL_I_TD[x].r = string.format("%d", FUL_I.currentTimesBagBank)
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = FIZ_TXT.reputation
									FUL_I_TD[x].r = string.format("%d", FUL_I.currentRepBagBank)
									x = x+1
								else
									FUL_I.currentTimesBagBank = nil
									FUL_I.currentRepBagBank = nil
									FUL_I.highlight = nil
								end
								if ((currentQuestTimesBag == 0) and (currentQuestTimesBagBank)) then
									FUL_I.highlight = nil
								end

								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = " "
								FUL_I_TD[x].r = " "
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.maxStanding
								FUL_I_TD[x].r = _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding]
								x = x+1

								FUL_I_TD.count = x-1
								FUL_I.tooltipDetails = FUL_I_TD
								FIZ_UpdateList[index] = FUL_I
								index = itemIndex
							end
						end
					end
				end

				-- General
				if (fg_sid.general and FIZ_Data.ShowGeneral) then
					local fg_sid_x=fg_sid.general
					for i = 0, fg_sid_x.count do
						local fg_sid_x_d=fg_sid_x.data[i]
						if (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
							local toDo = string.format("%.2f", repToNext / fg_sid_x_d.rep)
							if (fg_sid_x_d.limit) then
								toDo = string.format("%.2f", (fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
							end
							-- calculate Number of times to do differently for Guild cap
						--[[--	if (fg_sid_x_d.flag == FIZ_FLAG_GUILD_CAP) then
								toDo = string.format("%.2f", (barMax - FIZ_Data.cap[FIZ_CapIndex].base) / fg_sid_x_d.rep)
							end	--]]--
							FIZ_UpdateList[index] = {}
							local FUL_I = FIZ_UpdateList[index]
							FUL_I.type = FIZ_TXT.generalShort
							FUL_I.times = toDo.."x"
							FUL_I.rep = string.format("%d", fg_sid_x_d.rep)
							FUL_I.hasList = false
							FUL_I.listShown = nil
							FUL_I.index = index
							FUL_I.belongsTo = nil
							FUL_I.isShown = true
							FUL_I.name = fg_sid_x_d.name

							if (fg_sid_x_d.head and fg_sid_x_d.head ~= "") then
								FUL_I.tooltipHead = fg_sid_x_d.head
							else
								FUL_I.tooltipHead = FIZ_TXT.generalHead
							end
							if (fg_sid_x_d.tip and fg_sid_x_d.tip ~= "") then
								FUL_I.tooltipTip = fg_sid_x_d.tip
							else
								FUL_I.tooltipTip = FIZ_TXT.generalTip
							end

							FUL_I.tooltipDetails = {}
							local FUL_I_TD = FUL_I.tooltipDetails
							local x = 0
						--[[--	if (fg_sid_x_d.flag == FIZ_FLAG_GUILD_CAP) then
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.reputationCap
								FUL_I_TD[x].r = FUL_I.rep
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.reputationCapCurrent
								FUL_I_TD[x].r = FIZ_Data.cap[FIZ_CapIndex].rep
							else	--]]--
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.general2
								FUL_I_TD[x].r = fg_sid_x_d.name
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = FIZ_TXT.reputation
								FUL_I_TD[x].r = FUL_I.rep
						--	end
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.timesToRun
							FUL_I_TD[x].r = FUL_I.times
							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = " "
							FUL_I_TD[x].r = " "

							if (fg_sid_x_d.tipList) then
								for tip in pairs(fg_sid_x_d.tipList) do
									x = x+1
									FUL_I_TD[x] = {}
									FUL_I_TD[x].l = tip
									FUL_I_TD[x].r = fg_sid_x_d.tipList[tip]
								end
								x = x+1
								FUL_I_TD[x] = {}
								FUL_I_TD[x].l = " "
								FUL_I_TD[x].r = " "
							end

							x = x+1
							FUL_I_TD[x] = {}
							FUL_I_TD[x].l = FIZ_TXT.maxStanding
							FUL_I_TD[x].r = _G["FACTION_STANDING_LABEL"..fg_sid_x_d.maxStanding]
							FUL_I_TD.count = x
							local FUL_I_TD = FUL_I.tooltipDetails
							FIZ_UpdateList[index] = FUL_I
							index = index + 1
						end
					end
				end
			end
		end
	end

	--FIZ_Print("Added "..(index-1).." entries for ["..faction.."] at standing "..standingId)

	FIZ_UpdateList_Update()
end

function FIZ_GetUpdateListSize()
	-- sub function of	FIZ_UpdateList_Update()
	--fpt hed f_guls	FIZ_Printtest("","","f_guls 1")
	local count = 0
	local highest = 0
	for i in pairs(FIZ_UpdateList) do
		if (FIZ_UpdateList[i].isShown) then
			count = count + 1
			if (i > highest) then
				highest = i
			end
		end
	end

	return count, highest
end

function FIZ_ShowUpdateEntry(index, show)
	--fpt hed f_sue	FIZ_Printtest("","","f_sue 1")
	if (not FIZ_UpdateList[index]) then return end		-- invalid index
	if (not FIZ_UpdateList[index].hasList) then return end	-- not a list Header entry
	if (type(show)~="boolean") then return end		-- wrong data type

	FIZ_UpdateList[index].listShown = show
	for i in pairs(FIZ_UpdateList) do
		if (FIZ_UpdateList[i].belongsTo == index) then
			FIZ_UpdateList[i].isShown = show
		end
	end

	FIZ_UpdateList_Update()
end

function FIZ_ShowUpdateEntries(show)
	if (type(show)~="boolean") then return end		-- wrong data type

	for i in pairs(FIZ_UpdateList) do
		if (FIZ_UpdateList[i].belongsTo == nil) then
			-- always show parent entries, show or Hide their children
			FIZ_UpdateList[i].isShown = true
			FIZ_UpdateList[i].listShown = show
		else
			-- show or Hide child entries
			FIZ_UpdateList[i].isShown = show
		end
	end

	FIZ_UpdateList_Update()
end

function FIZ_ShowLineToolTip(self)
	if not self then return end

	if (self.tooltipHead) then
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		GameTooltip:SetText(self.tooltipHead, 1, 1, 0.5, 1)
		if (self.tooltipTip) then
			GameTooltip:AddLine(self.tooltipTip, 1, 1, 1, 1)
		end
		if (self.tooltipDetails and type(self.tooltipDetails) == "table") then
			GameTooltip:AddLine(" ", 1, 1, 1, 1)
			for i = 0, self.tooltipDetails.count do
				if (self.tooltipDetails[i].l and self.tooltipDetails[i].r) then
					if (self.tooltipDetails[i].r == " " or self.tooltipDetails[i].r=="") then
						GameTooltip:AddDoubleLine(self.tooltipDetails[i].l, self.tooltipDetails[i].r, 1, 1, 0, 1, 1, 1)
					else
						GameTooltip:AddDoubleLine(self.tooltipDetails[i].l, self.tooltipDetails[i].r, 1, 1, 0.5, 1, 1, 1)
					end
				end
			end
		end
		GameTooltip:Show()
	end
end

function FIZ_ShowHelpToolTip(self, element)
	if not element then return end

	local name = ""

	-- cut off leading frame name
	--if (string.find(element, GLDG_GUI)) then
	--	name = string.sub(element, string.len(GLDG_GUI)+1)
	--elseif (string.find(element, GLDG_COLOUR)) then
	--	name = string.sub(element, string.len(GLDG_COLOUR)+1)
	--elseif (string.find(element, GLDG_LIST)) then
		name = element
	--end

	-- cut off trailing Number In case of line and collect
	--local s,e = string.find(name, "Line");
	--if (s and e) then
	--	name = string.sub(name, 0, e)
	--end
	--s,e = string.find(name, "Collect");
	--if (s and e) then
	--	name = string.sub(name, 0, e)
	--end

	-- cut off colour button/texture
	--if (string.find(name, "Colour") == 1) then
	--	-- ["ColourGuildNewButton"] = true,
	--	s,e = string.find(name, "Button");
	--	if (s and e) then
	--		name = string.sub(name, 0, s-1)
	--	end
	--	-- ["ColourGuildNewColour"] = true,
	--	s,e = string.find(name, "Colour", 2);	-- start at 2 to skip the initial Colour
	--	if (s and e) then
	--		name = string.sub(name, 0, s-1)
	--	end
	--end

	local tip = ""
	local head = ""
	if (FIZ_TXT.elements and
		FIZ_TXT.elements.name and
		FIZ_TXT.elements.tip and
		FIZ_TXT.elements.name[name] and
		FIZ_TXT.elements.tip[name]) then
		tip = FIZ_TXT.elements.tip[name]
		head = FIZ_TXT.elements.name[name]

		if (FIZ_Data.needsTip and FIZ_Data.needsTip[name]) then
			FIZ_Data.needsTip[name] = nil
		end
	else
		if (not FIZ_Data.needsTip) then
			FIZ_Data.needsTip = {}
		end
		FIZ_Data.needsTip[name] = true
	end

	--GameTooltip_SetDefaultAnchor(GameTooltip, self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	if (head ~= "") then
		GameTooltip:SetText(head, 1, 1, 0.5, 1.0, 1)
--		GameTooltip:AddLine(name, 1, 0, 0, 1.0, 1)
		GameTooltip:AddLine(tip, 1, 1, 1, 1.0, 1)
--	else
--		GameTooltip:SetText(element, 1, 1, 0.5, 1.0, 1)
--		GameTooltip:AddLine(name, 1, 1, 1, 1.0, 1)
	end

	GameTooltip:Show()
end