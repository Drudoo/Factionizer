------5.04.00.7.2 14.4.27------------------
-- _15_ Getting reputation ready to hand In
-----------------------------------
function FIZ_GetReadyReputation(factionIndex)

	local result = 0
	if not factionIndex then return result end

	if (not ReputationFrame:IsVisible()) then return result end

	local maxFactionIndex = GetNumFactions()
	if (factionIndex > maxFactionIndex) then return result end

	local faction, description, standingId, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = FIZ_Orig_GetFactionInfo(factionIndex)
	if (isHeader) then return result end

	if (faction) then
		origFaction = faction
		faction = string.lower(faction)
	--- fpt grr	FIZ_Printtest(faction, FIZ_FactionMapping[faction],"1 grr")
		if (FIZ_FactionMapping[faction]) then
	--- fpt grr	FIZ_Printtest(faction, FIZ_FactionMapping[faction],"2 grr")
			faction = FIZ_FactionMapping[faction]
		end

		-- Normalize Values
		local normMax = barMax - barMin
		local normCurrent = barValue - barMin
		local repToNext = barMax - barValue

		local FIZ_FG_f=FIZ_FactionGain[faction]
		if (FIZ_FG_f) then
		local FIZ_FG_fs=FIZ_FG_f[standingId]
			if (FIZ_FG_fs) then

				-- quests (may have items)
				local FIZ_FG_fs_h=FIZ_FG_fs.quests
				if (FIZ_FG_fs_h) then
					for i = 0, FIZ_FG_fs_h.count do
					local FIZ_FG_fs_h_d=FIZ_FG_fs_h.data[i]
						if (not FIZ_FG_fs_h_d.limit or (normCurrent < FIZ_FG_fs_h_d.limit)) then
							local toDo = ceil(repToNext / FIZ_FG_fs_h_d.rep)
							if (FIZ_FG_fs_h_d.limit) then
								toDo = ceil((FIZ_FG_fs_h_d.limit - normCurrent) / FIZ_FG_fs_h_d.rep)
							end

							if (FIZ_FG_fs_h_d.items) then
								local currentQuestTimesBag = -1
								local currentQuestTimesBagBank = -1
								for item in pairs(FIZ_FG_fs_h_d.items) do
									if (FIZ_ItemsCarried and FIZ_ItemsCarried[item]) then
										if ((FIZ_ItemsCarried[item] >= FIZ_FG_fs_h_d.items[item]) and (FIZ_FG_fs_h_d.items[item] > 0)) then
											local localCurrentTimesBag = floor(FIZ_ItemsCarried[item] / FIZ_FG_fs_h_d.items[item])
											if (currentQuestTimesBag == -1) then
												-- first items for this quest --> take value
												currentQuestTimesBag = localCurrentTimesBag
											else
												-- some items already Set
												if (localCurrentTimesBag < currentQuestTimesBag) then
													-- fewer of this item than of others, reduce quest count
													currentQuestTimesBag = localCurrentTimesBag
												end
											end
										else
											-- not enough of this item for quest -> set to 0
											currentQuestTimesBag = 0
										end
										if (FIZ_Data.Bank and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item]) then
											local total = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item] + FIZ_ItemsCarried[item]
											if ((total >= FIZ_FG_fs_h_d.items[item]) and (FIZ_FG_fs_h_d.items[item] > 0)) then
												local localCurrentTimesBagBank = floor(total / FIZ_FG_fs_h_d.items[item])
												if (currentQuestTimesBagBank == -1) then
													-- first items for this quest --> take value
													currentQuestTimesBagBank = localCurrentTimesBagBank
												else
													-- some items already Set
													if (localCurrentTimesBagBank < currentQuestTimesBagBank) then
														-- fewer of this item than of others, reduce quest count
														currentQuestTimesBagBank = localCurrentTimesBagBank
													end
												end
											else
												-- not enough of this item for quest -> set to 0
												currentQuestTimesBagBank = 0
											end
										else
											-- none of this carried In bank
										end
									else
										-- not enough of this item for quest -> set to 0
										currentQuestTimesBag = 0
									end
								end
								if (currentQuestTimesBag > toDo) then
									currentQuestTimesBag = toDo
								end
								if (currentQuestTimesBagBank > toDo) then
									currentQuestTimesBagBank = toDo
								end
								if (currentQuestTimesBagBank > 0) then
									result = result + currentQuestTimesBagBank * FIZ_FG_fs_h_d.rep
								elseif (currentQuestTimesBag > 0) then
									result = result + currentQuestTimesBag * FIZ_FG_fs_h_d.rep
								else
									-- nothing to add
								end
							else
								-- no items, check if this quest is completed
								local entries, quests = GetNumQuestLogEntries()
								for z=1,entries do
									local title,level,tag,group,header,collapsed,complete,daily = GetQuestLogTitle(z)
									if (title and not header and complete) then
										if string.find(string.lower(FIZ_FG_fs_h_d.name), string.lower(title)) then
											-- this quest matches
											result = result + FIZ_FG_fs_h_d.rep
										end
									end
								end
							end
						end
					end
				end

				-- items
				local FIZ_FG_fs_h=FIZ_FG_fs.items
				if (FIZ_FG_fs_h and FIZ_Data.ShowItems) then
					for i = 0, FIZ_FG_fs_h.count do
					local FIZ_FG_fs_h_d=FIZ_FG_fs_h.data[i]
						if (not FIZ_FG_fs_h_d.limit or (normCurrent < FIZ_FG_fs_h_d.limit)) then
							local toDo = ceil(repToNext / FIZ_FG_fs_h_d.rep)
							if (FIZ_FG_fs_h_d.limit) then
								toDo = ceil((FIZ_FG_fs_h_d.limit - normCurrent) / FIZ_FG_fs_h_d.rep)
							end
							if (FIZ_FG_fs_h_d.items) then
								local currentQuestTimesBag = -1
								local currentQuestTimesBagBank = -1
								for item in pairs(FIZ_FG_fs_h_d.items) do
									if (FIZ_ItemsCarried and FIZ_ItemsCarried[item]) then
										if ((FIZ_ItemsCarried[item] >= FIZ_FG_fs_h_d.items[item]) and (FIZ_FG_fs_h_d.items[item] > 0)) then
											local localCurrentTimesBag = floor(FIZ_ItemsCarried[item] / FIZ_FG_fs_h_d.items[item])
											if (currentQuestTimesBag == -1) then
												-- first items for this quest --> take value
												currentQuestTimesBag = localCurrentTimesBag
											else
												-- some items already Set
												if (localCurrentTimesBag < currentQuestTimesBag) then
													-- fewer of this item than of others, reduce quest count
													currentQuestTimesBag = localCurrentTimesBag
												end
											end
										else
											-- not enough of this item for quest -> set to 0
											currentQuestTimesBag = 0
										end
										if (FIZ_Data.Bank and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player] and
										    FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item]) then
											local total = FIZ_Data.Bank[FIZ_Realm.." - "..FIZ_Player][item] + FIZ_ItemsCarried[item]
											if ((total >= FIZ_FG_fs_h_d.items[item]) and (FIZ_FG_fs_h_d.items[item] > 0)) then
												local localCurrentTimesBagBank = floor(total / FIZ_FG_fs_h_d.items[item])
												if (currentQuestTimesBagBank == -1) then
													-- first items for this quest --> take value
													currentQuestTimesBagBank = localCurrentTimesBagBank
												else
													-- some items already Set
													if (localCurrentTimesBagBank < currentQuestTimesBagBank) then
														-- fewer of this item than of others, reduce quest count
														currentQuestTimesBagBank = localCurrentTimesBagBank
													end
												end
											else
												-- not enough of this item for quest -> set to 0
												currentQuestTimesBagBank = 0
												FIZ_UpdateList[itemIndex].name = FIZ_UpdateList[itemIndex].name.." ["..total.."x]"
											end
										else
											-- none of this carried In bank
										end
									else
										-- not enough of this item for quest -> set to 0
										currentQuestTimesBag = 0
									end
								end
								if (currentQuestTimesBag > toDo) then
									currentQuestTimesBag = toDo
								end
								if (currentQuestTimesBagBank > toDo) then
									currentQuestTimesBagBank = toDo
								end
								if (currentQuestTimesBagBank > 0) then
									result = result + currentQuestTimesBagBank * FIZ_FG_fs_h_d.rep
								elseif (currentQuestTimesBag > 0) then
									result = result + currentQuestTimesBag * FIZ_FG_fs_h_d.rep
								end
							end
						end
					end
				end
			end
		end
	end

	return result;
end