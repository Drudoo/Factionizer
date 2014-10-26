------5.04.00.7.2 14.4.27------------------
-- _18_ extracting Skill information now 6
------------------------
function FIZ_ExtractSkills() --- ggg
	FIZ_Herb = false
	FIZ_Skin = false
	FIZ_Mine = false
	FIZ_Alche = false
	FIZ_Black = false
	FIZ_Enchan = false
	FIZ_Engin = false
	FIZ_Jewel = false
	FIZ_Incrip = false
	FIZ_Leath = false
	FIZ_Tailor = false
	FIZ_Aid = false
	FIZ_Arch = false
	FIZ_Cook = false
	FIZ_Fish = false

	local professions = {}
	local name, skillLine
	local prof1, prof2, archaeology, fishing, cooking, firstaid = GetProfessions();
	if (prof1) then
		name, _, _, _, _, _, skillLine = GetProfessionInfo(prof1);
		if name then professions[1] = name end
	end
	if (prof2) then
		name, _, _, _, _, _, skillLine = GetProfessionInfo(prof2);
		if name then professions[2] = name end
	end
	if (archaeology) then
		name, _, _, _, _, _, skillLine = GetProfessionInfo(archaeology);
		if name then professions[3] = name end
	end
	if (fishing) then
		name, _, _, _, _, _, skillLine = GetProfessionInfo(fishing);
		if name then professions[4] = name end
	end
	if (cooking) then
		name, _, _, _, _, _, skillLine = GetProfessionInfo(cooking);
		if name then professions[5] = name end
	end
	if (firstaid) then
		name, _, _, _, _, _, skillLine = GetProfessionInfo(firstaid);
		if name then professions[6] = name end
	end
	for skillIndex in pairs(professions) do
		skillName = professions[skillIndex] --- ggg zzz
		if (skillName == FIZ_TXT.skillHerb) then
			FIZ_Herb = true
		elseif (skillName == FIZ_TXT.skillSkin) then
			FIZ_Skin = true
		elseif (skillName == FIZ_TXT.skillMine) then
			FIZ_Mine = true
		elseif (skillName == FIZ_TXT.skillAlch) then
			FIZ_Alche = true
		elseif (skillName == FIZ_TXT.skillBlack) then
			FIZ_Black = true
		elseif (skillName == FIZ_TXT.skillEnch) then
			FIZ_Enchan = true
		elseif (skillName == FIZ_TXT.skillEngi) then
			FIZ_Engin = true
		elseif (skillName == FIZ_TXT.skillIncrip) then
			FIZ_Incrip = true
		elseif (skillName == FIZ_TXT.skillJewel) then
			FIZ_Jewel = true
		elseif (skillName == FIZ_TXT.skillLeath) then
			FIZ_Leath = true
		elseif (skillName == FIZ_TXT.skillTail) then
			FIZ_Tailor = true
		elseif (skillName == FIZ_TXT.skillAid) then
			FIZ_Aid = true
		elseif (skillName == FIZ_TXT.skillArch) then
			FIZ_Arch = true
		elseif (skillName == FIZ_TXT.skillCook) then
			FIZ_Cook = true
		elseif (skillName == FIZ_TXT.skillFish) then
			FIZ_Fish = true
		end
	end
--[[----------------------------------------------------------
	FIZ_Printtest(prof1, prof2, archaeology)--fpt --zzz
	FIZ_Printtest(fishing, cooking, firstaid)--fpt --zzz
	FIZ_Printtest("skillHerb",FIZ_TXT.skillHerb,FIZ_Herb)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillMine,FIZ_Mine)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillSkin,FIZ_Skin)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillAlch,FIZ_Alche)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillBlack,FIZ_Black)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillEnch,FIZ_Enchan)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillEngi,FIZ_Engin)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillIncrip,FIZ_Incrip)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillJewel,FIZ_Jewel)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillLeath,FIZ_Leath)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillAid,FIZ_Aid)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillArch,FIZ_Arch)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillCook,FIZ_Cook)
	FIZ_Printtest("skillHerb",FIZ_TXT.skillFish,FIZ_Fish)--]]--
end