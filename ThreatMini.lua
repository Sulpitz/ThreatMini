SLASH_TM1 = '/tm'
function SlashCmdList.TM(msg, editbox) 
	if msg == "delta" then
		if ThreatMini.delta == false or ThreatMini.delta == nil then
			ThreatMini.delta = true
			print("ThreatMini: Threat delta is shown")			
			ThreatMiniUiWindow:SetWidth(40)
		else
			ThreatMini.delta = true
			print("ThreatMini: Threat delta is now off")			
			ThreatMiniUiWindow:SetWidth(80)
		end
	elseif msg == "" or "help" then
		print("ThreatMini Commands:")
		print("   /tm help - shows this Help")
		print("   /tm delta - show/hide delta Threat display")
	end
end
print("ERR0")

local function GetTankThreat()
	
	if select(1, UnitDetailedThreatSituation("targettarget", "target")) then
		print("threat by target tartget found")
	end

	if select(1, UnitDetailedThreatSituation("player", "target")) then
		return select(5, UnitDetailedThreatSituation("player", "target"))
	end
	
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do			
			if select(1, UnitDetailedThreatSituation(raid..i, "target")) then
				return select(5, UnitDetailedThreatSituation(raid..i, "target"))		 
			end
			if UnitExists(raidpet..i) then 						
				if select(1, UnitDetailedThreatSituation(raidpet..i, "target")) then
					return select(5, UnitDetailedThreatSituation(raidpet..i, "target"))		 
				end
			end
		end
	elseif IsInGroup() then
		for i = 1, GetNumGroupMembers() do			
			if select(1, UnitDetailedThreatSituation(party..i, "target")) then
				return select(5, UnitDetailedThreatSituation(raid..i, "target"))
			end
			if UnitExists(partypet..i) then 						
				if select(1, UnitDetailedThreatSituation(partypet..i, "target")) then
					return select(5, UnitDetailedThreatSituation(partypet..i, "target"))		 
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

  ThreatMiniDeltaThreat = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMiniDeltaThreat:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -20)
  ThreatMiniDeltaThreat:SetText("")
  ThreatMiniDeltaThreat:SetTextColor(1, 1, 1, 1)

  ThreatMiniIsTanking = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMiniIsTanking:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -20)
  ThreatMiniIsTanking:SetText("")
  ThreatMiniIsTanking:SetTextColor(1, 1, 1, 1)

  ThreatMinistatus = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMinistatus:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -40)
  ThreatMinistatus:SetText("")
  ThreatMinistatus:SetTextColor(1, 1, 1, 1)

  ThreatMinirawthreatpct = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMinirawthreatpct:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -60)
  ThreatMinirawthreatpct:SetText("")
  ThreatMinirawthreatpct:SetTextColor(1, 1, 1, 1)

  ThreatMinithreatvalue = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMinithreatvalue:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -80)
  ThreatMinithreatvalue:SetText("")
  ThreatMinithreatvalue:SetTextColor(1, 1, 1, 1)

  ThreatMiniTankThreat = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMiniTankThreat:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -100)
  ThreatMiniTankThreat:SetText("")
  ThreatMiniTankThreat:SetTextColor(1, 1, 1, 1)
  
	if ThreatMini.delta then
		ThreatMiniUiWindow:SetWidth(80)
	else			
		ThreatMiniUiWindow:SetWidth(40)
	end

end

local function TargetFrame_UpdateThreat()
	isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")
	if (threatpct == nil) then 		
		ThreatMiniIsTanking:SetText("")
		ThreatMinistatus:SetText("")
		ThreatMinirawthreatpct:SetText("")
		ThreatMinithreatvalue:SetText("")		
		ThreatMiniPctText:SetText("-")	
		ThreatMiniTankThreat:SetText("")
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
		ThreatMiniUiWindow:SetWidth(80)
		ThreatMiniPctText:SetText(threatpct .. "%")
		if threatDelta < -9999 then
			threatDelta = math.floor(threatDelta/1000)
			threatDelta = threatDelta .. "k"
		end
		ThreatMiniThreatDelta:SetText(threatDelta)
	else			
		ThreatMiniUiWindow:SetWidth(40)
		ThreatMiniPctText:SetText(threatpct .. "%")
		ThreatMiniThreatDelta:SetText("")
	end

	--if isTanking then ThreatMiniIsTanking:SetText("Tanking!") else ThreatMiniIsTanking:SetText("not Tanking") end
	--ThreatMinistatus:SetText("Status: " .. status)
	--ThreatMinirawthreatpct:SetText("Rawthreatpct: " .. rawthreatpct)
	--ThreatMinithreatvalue:SetText("Threat: " .. threatvalue)
	--ThreatMiniTankThreat:SetText("TankThreat: " .. tankThreat)

end

function ThreatMini_OnLoad()
	print("ERR1")
	ThreatMini:RegisterEvent('ADDON_LOADED')
	ThreatMini:RegisterEvent("PLAYER_TARGET_CHANGED")
	ThreatMini:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
	print("ERR2")
end

function ThreatMini_OnEvent(self, event, ...)
	if select(1, ...) == "ThreatMini" then
		print("ThreatMini loaded fired")
		CreateFontstring()
	elseif event == "PLAYER_TARGET_CHANGED" then
		TargetFrame_UpdateThreat()
	elseif event == "UNIT_THREAT_LIST_UPDATE" then
		TargetFrame_UpdateThreat()
	end
end

