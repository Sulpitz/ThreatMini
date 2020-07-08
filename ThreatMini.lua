

print("ThreatMini loaded")

local LibThreatClassic=LibStub and LibStub("LibThreatClassic2",true);
if not LibThreatClassic then
  message("Please istall / activate LibThreatClassic2 to make ThreatMini work")
  return
end


SLASH_HCSPY1 = '/tm'
function SlashCmdList.HCSPY(msg, editbox) 
  if msg == "reset" then
    pPrint("HCSpy is now reset!")
  elseif msg == "list" then
	print("list")
  elseif msg == "prefix" then
    print("Prefix:")
  else
	isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")
	print("isTanking",isTanking, status, "status", threatpct, rawthreatpct, threatvalue)
  end
end



local function CreateFontstring()

  ThreatMiniPctText = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMiniPctText:SetText("-")
  ThreatMiniPctText:SetTextColor(1, 1, 1, 1)

  ThreatMiniIsTanking = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMiniIsTanking:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -20)
  ThreatMiniIsTanking:SetText("ThreatMiniIsTanking")
  ThreatMiniIsTanking:SetTextColor(1, 1, 1, 1)

  ThreatMinistatus = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMinistatus:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -40)
  ThreatMinistatus:SetText("ThreatMinistatus")
  ThreatMinistatus:SetTextColor(1, 1, 1, 1)

  ThreatMinirawthreatpct = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMinirawthreatpct:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -60)
  ThreatMinirawthreatpct:SetText("ThreatMinirawthreatpct")
  ThreatMinirawthreatpct:SetTextColor(1, 1, 1, 1)

  ThreatMinithreatvalue = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMinithreatvalue:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -80)
  ThreatMinithreatvalue:SetText("ThreatMinithreatvalue")
  ThreatMinithreatvalue:SetTextColor(1, 1, 1, 1)

end

--credit to SDPhantom from Modern TargetFrame
local function UnitThreatthreatpctageOfLead(unit,mob)--	Hack to implement UnitThreatthreatpctageOfLead()
	local unitguid,mobguid=UnitGUID(unit),UnitGUID(mob);
	if not (unitguid and unitguid) then return 0; end

	local unitval=LibThreatClassic:GetThreat(unitguid,mobguid);
	if unitval>0 then
		local maxval=0;
		for otherguid in next,LibThreatClassic.threatTargets do
			if otherguid~=unitguid then
				local val=LibThreatClassic:GetThreat(otherguid,mobguid);
				if val>maxval then maxval=val; end
			end
		end
		return maxval>0 and 100*unitval/maxval or 0, unitval, maxval;
	else return 0; end
end

local function TargetFrame_UpdateThreat()
	--local threatpct, unitThreat, maxThreat = UnitThreatthreatpctageOfLead("player","target") old threat api
	isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")
	if (threatpct == nil) then return end
	print(isTanking, status, threatpct, rawthreatpct, threatvalue)
	threatpct = math.floor(threatpct)
	if threatpct >= 100 then 
		ThreatMiniPctText:SetTextColor(1, 0, 0, 1)
	else
		ThreatMiniPctText:SetTextColor(1, 1, 1, 1)
	end
	if threatpct > 0 then
		ThreatMiniPctText:SetText(threatpct .. "%")
	else
		ThreatMiniPctText:SetText("-")
	end	
	if isTanking then ThreatMiniIsTanking:SetText("Tanking!") else ThreatMiniIsTanking:SetText("not Tanking") end
	ThreatMinistatus:SetText("Status: " .. status)
	ThreatMinirawthreatpct:SetText("Rawthreatpct: " .. rawthreatpct)
	ThreatMinithreatvalue:SetText("Threat: " .. threatvalue)

	do return end

	ThreatMinithreatvalue:SetText("")
	local threatDelta = unitThreat - maxThreat
	if threatDelta > 0 then
		ThreatMinithreatvalue:SetTextColor(1, 0.6, 0.6, 1)
	else
		ThreatMinithreatvalue:SetTextColor(0.6, 1, 1, 1)
	end
end

--	LibThreatClassic Registration
--local LTCIdentifier={};--	CallbackHandler-1.0 can take any value as an identifier, same identifiers overwrite each other on the same events
--LibThreatClassic.RegisterCallback(LTCIdentifier,"Activate",TargetFrame_UpdateThreat);
--LibThreatClassic.RegisterCallback(LTCIdentifier,"ThreatUpdated",function(event,unitguid,targetguid)
--	if targetguid==UnitGUID("target") then TargetFrame_UpdateThreat(); end
--end);
--LibThreatClassic:RequestActiveOnSolo();

function ThreatMini_OnLoad()
  ThreatMini:RegisterEvent('ADDON_LOADED')
  ThreatMini:RegisterEvent("PLAYER_TARGET_CHANGED")
  ThreatMini:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
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

