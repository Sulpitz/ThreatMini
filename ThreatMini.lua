SLASH_TM1 = '/tm'
function SlashCmdList.TM(msg, editbox) 
	if msg == "delta" then
		if ThreatMini.delta == false or ThreatMini.delta == nil then
			ThreatMini.delta = true
			print("ThreatMini: Threat delta is shown")			
			ThreatMiniUiWindow:SetWidth(80)
		else
			ThreatMini.delta = false
			print("ThreatMini: Threat delta is now off")			
			ThreatMiniUiWindow:SetWidth(40)
		end
	elseif msg == "debug" then
		if ThreatMini.debug == false or ThreatMini.debug == nil then
			ThreatMini.debug = true
			print("ThreatMini: Debug mode on")
		else
			ThreatMini.debug = false
			print("ThreatMini: Debug mode off")
		end
	elseif msg == "" or "help" then
		print("ThreatMini Commands:")
		print("   /tm help - shows this Help")
		print("   /tm delta - show/hide delta Threat display")
	end
end

local function InitSettings()
	if ThreatMini == nil or ThreatMini.setup ~= true then 
		ThreatMini = {}
		ThreatMini.setup = true
		ThreatMini.delta = true
		ThreatMini.debug = false
	end
end

local function GetTankThreat()
	
	if select(1, UnitDetailedThreatSituation("targettarget", "target")) then
		return select(5, UnitDetailedThreatSituation("targettarget", "target"))
	end

	if ThreatMini.debug then message("ThreatMini: target search exceeded 'targettarget'") end

	if select(1, UnitDetailedThreatSituation("player", "target")) then
		return select(5, UnitDetailedThreatSituation("player", "target"))
	end
	
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do			
			if select(1, UnitDetailedThreatSituation("raid" .. i, "target")) then
				return select(5, UnitDetailedThreatSituation("raid"..i, "target"))		 
			end
			if UnitExists("raidpet"..i) then 						
				if select(1, UnitDetailedThreatSituation("raidpet"..i, "target")) then
					return select(5, UnitDetailedThreatSituation("raidpet"..i, "target"))		 
				end
			end
		end
	elseif IsInGroup() then
		for i = 1, GetNumGroupMembers() do			
			if select(1, UnitDetailedThreatSituation("party"..i, "target")) then
				return select(5, UnitDetailedThreatSituation("raid"..i, "target"))
			end
			if UnitExists(partypet..i) then 						
				if select(1, UnitDetailedThreatSituation("partypet"..i, "target")) then
					return select(5, UnitDetailedThreatSituation("partypet"..i, "target"))		 
				end
			end
		end	
	elseif UnitExists("pet") then					
		if select(1, UnitDetailedThreatSituation("pet", "target")) then
			return select(5, UnitDetailedThreatSituation("pet", "target"))
		end
	end	

	return -1

end


local function CreateFontstring()

  ThreatMiniPctText = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMiniPctText:SetPoint('LEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, 0)
  ThreatMiniPctText:SetText("")
  ThreatMiniPctText:SetTextColor(1, 1, 1, 1)
  
  ThreatMiniThreatDelta = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMiniThreatDelta:SetPoint('RIGHT', ThreatMiniUiWindow, 'TOPLEFT', 75, 0)
  ThreatMiniThreatDelta:SetText("")
  ThreatMiniThreatDelta:SetJustifyH("RIGHT")
  ThreatMiniThreatDelta:SetTextColor(1, 1, 1, 1)
  
	if ThreatMini.delta then
		ThreatMiniUiWindow:SetWidth(80)
	else			
		ThreatMiniUiWindow:SetWidth(40)
	end

end

local function TargetFrame_UpdateThreat()
	isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")
	if (threatpct == nil) then 		
		ThreatMiniPctText:SetText("")
		ThreatMiniThreatDelta:SetText("")
		return
	end	
	threatpct = math.floor(threatpct)
	threatvalue = math.floor(threatvalue/100)
	threatDelta = 0

	if ThreatMini.delta then
		tankThreat = GetTankThreat()
		tankThreat = math.floor(tankThreat/100)
		threatDelta = threatvalue - tankThreat
	end

	if status > 1 then 
		ThreatMiniPctText:SetTextColor(1, 0, 0, 1)
	elseif status == 1 then 
		ThreatMiniPctText:SetTextColor(216/255, 75/255, 32/255, 1)
	else
		ThreatMiniPctText:SetTextColor(1, 1, 1, 1)
	end	

	if ThreatMini.delta then
		ThreatMiniPctText:SetText(threatpct .. "%")
		if threatDelta < -9999 then
			threatDelta = math.floor(threatDelta/1000)
			threatDelta = threatDelta .. "k"
		end
		ThreatMiniThreatDelta:SetText(threatDelta)
	else			
		ThreatMiniPctText:SetText(threatpct .. "%")
		ThreatMiniThreatDelta:SetText("")
	end
end

function ThreatMini_OnLoad()
	ThreatMini:RegisterEvent('ADDON_LOADED')
	ThreatMini:RegisterEvent("PLAYER_TARGET_CHANGED")
	ThreatMini:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
end

function ThreatMini_OnEvent(self, event, ...)
	if select(1, ...) == "ThreatMini" then
		InitSettings()
		CreateFontstring()
	elseif event == "PLAYER_TARGET_CHANGED" then
		TargetFrame_UpdateThreat()
	elseif event == "UNIT_THREAT_LIST_UPDATE" then
		TargetFrame_UpdateThreat()
	end
end

