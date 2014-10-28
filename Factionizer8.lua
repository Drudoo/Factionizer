------5.04.00.7.2 14.4.27------------------
-- _08_ Faction map --
-----------------------------------
function FIZ_Initmapname(fimap)
	--- fpt f_imn	FIZ_Printtest(fimap,"","map 1")
	local map
	if fimap == 1 then
		map = FIZ_TXT.srfd
	elseif fimap== 2 then
		map = FIZ_TXT.tbd
	elseif fimap== 3 then
		map = FIZ_TXT.mnd
	elseif fimap== 5 then
		map = FIZ_TXT.nci
	elseif fimap == 6 then
		map = FIZ_TXT.hci
	elseif not fimap then
		map = " "
	else
		local mapName = GetMapNameByID(fimap);
		map = mapName
	end
	--- fpt f_imn	FIZ_Printtest(fimap,"","map 2")
	if not map then
		map = fimap
	end
	mark_map = map
end

function FIZ_Initmobname(fimob)
	--- fpt f_ion	FIZ_Printtest(fimob,"","mob 1")
	local mob
	if fimob == 1 then
		mob = FIZ_TXT.tmob
	elseif fimob== 2 then
		mob = FIZ_TXT.oboss
	elseif fimob== 3 then
		mob = FIZ_TXT.aboss
	elseif fimob == 4 then
		mob = FIZ_TXT.pboss
	elseif fimob == 5 then
		mob = FIZ_TXT.fclear
	elseif fimob == 11 then
		mob = (FIZ_TXT.AU.." "..FIZ_TXT.BB)
	elseif fimob== 12 then
		mob = (FIZ_TXT.AU.." "..FIZ_TXT.SSP)
	elseif fimob== 13 then
		mob = (FIZ_TXT.AU.." "..FIZ_TXT.Wa)
	elseif fimob == 14 then
		mob = FIZ_TXT.VCm
	elseif fimob == 15 then
		mob = (FIZ_TXT.AN.." "..FIZ_TXT.BB)
	elseif fimob== 16 then
		mob = (FIZ_TXT.AN.." "..FIZ_TXT.SSP)
	elseif fimob== 17 then
		mob = (FIZ_TXT.AN.." "..FIZ_TXT.Wa)
	else
	--[[--	local mobName = GetmobNameByID(fimob);
		mob = mobName	--]]--
	end
	--- fpt f_ion	FIZ_Printtest(fimob,mob,"mob 2")
	if not mob then
		mob = fimob
	end
	mark_mob = mob
end

function FIZ_Inititemname(fiitem,amt)
	--- fpt f_iin	FIZ_Printtest(fiitem,amt,"item 1")
	if fiitem==1 then
		item_name = FIZ_TXT.cdq
	elseif fiitem==2 then
		item_name = FIZ_TXT.fdq
	elseif fiitem==3 then
		item_name = FIZ_TXT.ndq
	elseif fiitem == 4 then
		item_name = FIZ_TXT.cbadge
	elseif fiitem == 5 then
		item_name = FIZ_TXT.deleted
	else
		item_name = GetItemInfo(fiitem)
	end
	mark_I={}
	if not item_name then
		item_name=fiitem
	end
	mark_I[item_name]=amt
	--- fpt f_iin	FIZ_Printtest(item_name,mark_I[item_name],"item 2")
end

local quest_names = setmetatable({}, {
	__index = function(t, id_num)
		GameTooltip:SetOwner(UIParent, ANCHOR_NONE)
		GameTooltip:SetHyperlink(format("quest:%d", id_num))

		local quest_name = GameTooltipTextLeft1:GetText()
		GameTooltip:Hide()

		if id_num == 1 then
			quest_name = FIZ_TXT.cdq
		elseif id_num == 2 then
			quest_name = FIZ_TXT.coq
		elseif id_num == 3 then
			quest_name = FIZ_TXT.fdq
		elseif id_num == 4 then
			quest_name = FIZ_TXT.foq
		elseif id_num == 5 then
			quest_name = FIZ_TXT.ndq
		elseif id_num == 6 then
			quest_name = FIZ_TXT.deleted
		elseif id_num == 7 then
			quest_name = FIZ_TXT.Championing
		elseif id_num == 8 then
			quest_name = FIZ_TXT.bpqfg
		elseif id_num== 99 then
			quest_name = FIZ_TXT.tbd
		else
			if not quest_name then
				return id_num
			end
			t[id_num] = quest_name
		end
		return quest_name
	end
})

function FIZ_GetTabardFaction()
	for i = 1, 40 do
		local _, _, _, _, _, _, _, _, _, _, id = UnitBuff("player", i)
		if not id then
			break
		end
		local data = championFactions[id]
		if data then
			local faction, level = data[2], data[1]
			if DEBUG then self:Debug("GetChampionedFaction:", tostring(faction), tostring(level)) end
			return faction, level
		end
	end
	if DEBUG then self:Debug("GetChampionedFaction:", "none") end
end

function FIZ_InitFactor(FIZ_IsHuman,faction)
--- Thanks Gwalkmaur for the heads up
	local factor=1.0
	-- race check
		if FIZ_IsHuman then factor = factor + 0.1 end
	-- bonus repgain check
		local numFactions = GetNumFactions();
		local factionOffset=0;
		local factionIndex;
		local factor_h=0
	---	FIZ_Printtest(numFactions,factionOffset,factionIndex)
	--- f_if	FIZ_Printtest(faction,name)
		for i=1,numFactions do
			local factionIndex = factionOffset + i;
			if (factionIndex <= numFactions) then
				local name, hasBonusRepGain;
				local name, _, _, _, _, _, _, _, _, _, _, _, _, _, hasBonusRepGain, _ = GetFactionInfo(factionIndex);
				if (faction==name) then
				--- f_if	FIZ_Printtest(faction,name,"test")
					if (hasBonusRepGain) then
					--- f_if	FIZ_Printtest(faction,name,"Gain")
						factor=factor+1
					end
				end
			end
		end
	--- f_if	FIZ_Printtest(faction,factor,"fact")
	FIZ_factor = factor

end

function FIZ_InitFaction(guildName,faction)
	if faction=="guildName" or faction==FIZ_GuildName then
	--- f_ifa	FIZ_Printtest(faction,guildName,"1")
		FIZ_faction = faction
	else
	--- f_ifa	FIZ_Printtest(faction,FIZ_faction,"2")
		FIZ_faction = GetFactionInfoByID(faction)
	end
end

function FIZ_InitFactionMap(locale, guildName)
	FIZ_FactionMapping = {}
	FIZ_InitEnFactions()
	if (guildName) then
		FIZ_AddMapping(guildName, guildName)
	end
end

function FIZ_AddMapping(english, localised)
--- f_am	FIZ_Printtest(english, localised,"map")
	if (not FIZ_FactionMapping) then
		FIZ_FactionMapping = {}
	end
	FIZ_InitFaction(FIZ_GuildName,localised)
	if (FIZ_faction) then
		FIZ_FactionMapping[string.lower(FIZ_faction)] = string.lower(english)
	end
end

------------------------------------
-- _09_ Faction Lists --
------------------------------------

function FIZ_AddSpell(faction, from, to, name, rep, zone, limit)

	if not faction then return end
	if not from then return end
	if not to then return end
	if not name then return end
	if not rep then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end
	faction = string.lower(faction)

--[[--	FIZ_Initspellname(name)
---	FIZ_Initmapname(zone)
	FIZ_InitFaction(FIZ_GuildName,faction)
	FIZ_InitFactor(FIZ_IsHuman,FIZ_faction)
	rep = rep * FIZ_factor
	faction = string.lower(FIZ_faction)
	---	FIZ_Printtest(faction,FIZ_faction,"spell")--fpt

	for standing = from,to do
		local faction_info = FIZ_FactionGain[faction]
		if not faction_info then
			faction_info = {}
			FIZ_FactionGain[faction] = faction_info
		end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.spells
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = {}
			add_info.data = {}
			add_info.count = 0
			standing_info.spells = add_info
		end
		local count = add_info.count
		add_info.data[count] = {}
		local add_count=add_info.data[count]
		add_count.name = mark_spell --- name
		add_count.rep = rep
		add_count.zone = zone --- mark_map
		add_count.maxStanding = to
		if ((standing == to) and limit) then
			add_count.limit = limit
		end
		FIZ_Debug("Added spell ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
	end	--]]--
end

function FIZ_AddMob(faction, from, to, name, rep, zone, limit)

	if not faction then return end
	if not from then return end
	if not to then return end
	if not name then return end
	if not rep then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end

	FIZ_Initmobname(name)
	FIZ_Initmapname(zone)
	FIZ_InitFaction(FIZ_GuildName,faction)
	FIZ_InitFactor(FIZ_IsHuman,FIZ_faction)
	rep = rep * FIZ_factor
	faction = string.lower(FIZ_faction)
	--- f_amo	FIZ_Printtest(faction,FIZ_faction,"mob")

	for standing = from,to do
		local faction_info = FIZ_FactionGain[faction]
		if not faction_info then
			faction_info = {}
			FIZ_FactionGain[faction] = faction_info
		end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.mobs
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = {}
			add_info.data = {}
			add_info.count = 0
			standing_info.mobs = add_info
		end
		local count = add_info.count
		add_info.data[count] = {}
		local add_count=add_info.data[count]
		add_count.name = mark_mob --- name
		add_count.rep = rep
		add_count.zone = mark_map ---zone 
		add_count.maxStanding = to
		if ((standing == to) and limit) then
			add_count.limit = limit
		end
		FIZ_Debug("Added mob ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
	end
end

function FIZ_AddQuest(faction, from, to, name, rep, itemList, limitType)

	if not faction then return end
	if not from then return end
	if not to then return end
	if not name then return end
	if not rep then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end

	FIZ_InitFaction(FIZ_GuildName,faction)
	FIZ_InitFactor(FIZ_IsHuman,FIZ_faction)
	rep = rep * FIZ_factor
	faction = string.lower(FIZ_faction)
	--- f_aq	FIZ_Printtest(faction,FIZ_faction,"quest")

	for standing = from,to do
		local mark_quest = quest_names[name] 
		local faction_info = FIZ_FactionGain[faction]
		if not faction_info then
			faction_info = {}
			FIZ_FactionGain[faction] = faction_info
		end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.quests
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = {}
			add_info.data = {}
			add_info.count = 0
			standing_info.quests = add_info
		end
		local count=add_info.count
		add_info.data[count] = {}
		local add_count=add_info.data[count]
		add_count.name = mark_quest
		add_count.rep = rep
		add_count.maxStanding = to
		if (itemList) then
			if (itemList == "nil") then
				add_count.profession = limitType
			else
				add_count.items = {}
				for item in pairs(itemList) do
		FIZ_Inititemname(item,itemList[item])
					--- f_aq	FIZ_Printtest(item_name,mark_I[item_name],"item 3")
					add_count.items[item_name] = mark_I[item_name]
					--- f_aq	FIZ_Printtest(add_count.items[item_name],mark_I[item_name],"item 4")
				end
			end
		end
		if ((standing == to) and limit) then
			add_count.limit = limit
		end

		FIZ_Debug("Added quest ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
	end
end

function FIZ_AddInstance(faction, from, to, name, rep, heroic)
	if not faction then return end
	if not from then return end
	if not to then return end
	if not name then return end
	if not rep then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end
	faction = string.lower(faction)

	FIZ_Initmapname(name)
	FIZ_InitFaction(FIZ_GuildName,faction)
	FIZ_InitFactor(FIZ_IsHuman,FIZ_faction)
	rep = rep * FIZ_factor
	faction = string.lower(FIZ_faction)
	--- f_ain	FIZ_Printtest(faction,FIZ_faction,"inst")

	for standing = from,to do
		local faction_info = FIZ_FactionGain[faction]
		if not faction_info then
			faction_info = {}
			FIZ_FactionGain[faction] = faction_info
		end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.instance
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = {}
			add_info.data = {}
			add_info.count = 0
			standing_info.instance = add_info
		end
		local count = add_info.count
		add_info.data[count] = {}
		local add_count=add_info.data[count]
		add_count.name = mark_map
		add_count.rep = rep
		add_count.maxStanding = to
		if (heroic) then --ggg
			add_count.level = FIZ_TXT.heroic
		else
			add_count.level = FIZ_TXT.normal
		end
		if ((standing == to) and limit) then
			add_count.limit = limit
		end

		FIZ_Debug("Added instance ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
	end
end

function FIZ_AddItems(faction, from, to, rep, itemList)
	if not faction then return end
	if not from then return end
	if not to then return end
	if not rep then return end
	if not itemList then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end
	faction = string.lower(faction)

	FIZ_InitFaction(FIZ_GuildName,faction)
	FIZ_InitFactor(FIZ_IsHuman,FIZ_faction)
	rep = rep * FIZ_factor
	faction = string.lower(FIZ_faction)
	--- f_ait	FIZ_Printtest(faction,FIZ_faction,"item")

	local itemString = ""
	for standing = from,to do
		local faction_info = FIZ_FactionGain[faction]
		if not faction_info then
			faction_info = {}
			FIZ_FactionGain[faction] = faction_info
		end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.items
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = {}
			add_info.data = {}
			add_info.count = 0
			standing_info.items = add_info
		end
		local count=add_info.count

		add_info.data[count] = {}
		local add_count=add_info.data[count]
		add_count.rep = rep
		add_count.maxStanding = to
		if (itemList) then
			add_count.items = {}
			for item in pairs(itemList) do
				FIZ_Inititemname(item,itemList[item])
				if itemString ~= "" then itemString = itemString..", " end
				itemString = itemString..mark_I[item_name].."x "..item_name
			--- f_ait	FIZ_Printtest(item_name,mark_I[item_name],"item")
				add_count.items[item_name] = mark_I[item_name]
			end
		end
		if ((standing == to) and limit) then
			add_count.limit = limit
		end

		FIZ_Debug("AddItem: Added items ["..itemString.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."]")
	end
end

function FIZ_AddGeneral(faction, from, to, name, rep, head, tip, tipList, flag)
	if not faction then return end
	if not from then return end
	if not to then return end
	if not rep then return end
	if not name then return end
	if (type(rep) ~= "number") then return end
	if ((from<1) or (from>8)) then return end
	if ((to<1) or (to>8)) then return end
	if (from > to) then return end
	faction = string.lower(faction)

	if name == "1" then
		name = FIZ_TXT.tfr
		head = FIZ_TXT.tfr
		tip = FIZ_TXT.nswts
	else
	end

	FIZ_InitFaction(FIZ_GuildName,faction)
	FIZ_InitFactor(FIZ_IsHuman,FIZ_faction)
	rep = rep * FIZ_factor
	faction = string.lower(FIZ_faction)
	--- f_ag	FIZ_Printtest(faction,FIZ_faction,"gen") 

	local tipString = ""
	for standing = from,to do
		local faction_info = FIZ_FactionGain[faction]
		if not faction_info then
			faction_info = {}
			FIZ_FactionGain[faction] = faction_info
		end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.general
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = {}
			add_info.data = {}
			add_info.count = 0
			standing_info.general = add_info
		end
		local count = add_info.count
		add_info.data[count] = {}
		local add_count=add_info.data[count]
		add_count.name = name
		add_count.flag = flag
		add_count.head = head
		add_count.tip = tip
		add_count.rep = rep
		add_count.maxStanding = to
		if (tipList) then
			add_count.tipList = {}
			for tip in pairs(tipList) do
				if tipString ~= "" then tipString = tipString..", " end
				tipString = tipString..tipList[tip]..": "..tip
				add_count.tipList[tip] = tipList[tip]
			end
		end
		if ((standing == to) and limit) then
			add_count.limit = limit
		end
		FIZ_Debug("AddGeneral: Added general rep gain ["..name.."] for faction ["..faction.."] and standing [".._G["FACTION_STANDING_LABEL"..standing].."] with tooltip ["..tipString.."]")
	end
end