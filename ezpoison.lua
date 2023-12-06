local venomWarning = 0
local elixirWarning = 0

local function ezpoisonScanDebuffs()
	for i=0, 48 do
		local buffIndex = GetPlayerBuff(i, "HARMFUL");
		local buffTexture = GetPlayerBuffTexture(buffIndex);
		if buffTexture == "Interface\\Icons\\Spell_Nature_CorrosiveBreath" then
			ezpoisonTooltip:ClearLines()
			ezpoisonTooltip:SetPlayerBuff(buffIndex)
			local tooltipScan = getglobal("ezpoisonTooltipTextLeft1")
			if tooltipScan then
				local DebuffName = tooltipScan:GetText()
				if DebuffName == "Poison Charge" then
					return true
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------

local function Antivenom()
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local bagitemLink = GetContainerItemLink(bag, slot)
			if bagitemLink then
				local _, _, bagitemName = string.find(string.lower(bagitemLink), "%[(.+)%]")
				if bagitemName == "anti-venom" then
					local startTime, _, _ = GetContainerItemCooldown(bag, slot)
					if startTime == 0 then
						UseContainerItem(bag, slot, 1)
						return true
					else
						return false
					end
				end
			end
		end
	end
	if venomWarning == 0 then
		venomWarning = 1
		SendChatMessage("I ran out of Anti-venoms!", "WHISPER", nil, GetUnitName("PLAYER"))
	end
	return false
end

-----------------------------------------------------------

local function Elixir()
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local bagitemLink = GetContainerItemLink(bag, slot)
			if bagitemLink then
				local _, _, bagitemName = string.find(string.lower(bagitemLink), "%[(.+)%]")
				if bagitemName == "elixir of poison resistance" then
					UseContainerItem(bag, slot, 1)
					return true
				end
			end
		end
	end
	if elixirWarning == 0 then
		elixirWarning = 1
		SendChatMessage("I ran out of Elixirs of Poison Resistance!", "WHISPER", nil, GetUnitName("PLAYER"))
	end
	return false
end

-----------------------------------------------------------

function ezpoisonFunction(cmd)
	local zone= GetRealZoneText()
	if zone ~= "Naxxramas" then
		return
	end
	if ezpoisonScanDebuffs() then
		if not Antivenom() then Elixir() end
	end
end

-----------------------------------------------------------

SLASH_EZPOISON1 = '/ezpoison'
SlashCmdList.EZPOISON = ezpoisonFunction