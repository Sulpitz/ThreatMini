

print("ThreatMini loaded")

local LibThreatClassic=LibStub and LibStub("LibThreatClassic2",true);
if not LibThreatClassic then
  message("Please istall / activate LibThreatClassic2 to make ThreatMini work")
  return
end

local function CreateFontstring()

  ThreatMiniPctText = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMiniPctText:SetText("-")
  ThreatMiniPctText:SetTextColor(1, 1, 1, 1)

  ThreatMiniAbsText = ThreatMiniUiWindow:CreateFontString(nil, nil, "ThreatMiniUiWindowListNameFontstring")
  ThreatMiniAbsText:SetPoint('TOPLEFT', ThreatMiniUiWindow, 'TOPLEFT', 0, -20)
  ThreatMiniAbsText:SetText("")
  ThreatMiniAbsText:SetTextColor(1, 1, 1, 1)

end

--credit to SDPhantom from Modern TargetFrame
local function UnitThreatPercentageOfLead(unit,mob)--	Hack to implement UnitThreatPercentageOfLead()
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
	local percent, unitThreat, maxThreat = UnitThreatPercentageOfLead("player","target")
	percent = math.floor(percent)
	if percent >= 100 then 
		ThreatMiniPctText:SetTextColor(1, 0, 0, 1)
	else
		ThreatMiniPctText:SetTextColor(1, 1, 1, 1)
	end
	if percent > 0 then
		ThreatMiniPctText:SetText(percent .. "%")
	else
		ThreatMiniPctText:SetText("-")
	end
	ThreatMiniAbsText:SetText("")
	if maxThreat == nil or percent == 0 then return end
	local threatDelta = unitThreat - maxThreat
	if threatDelta > 0 then
		ThreatMiniAbsText:SetTextColor(1, 0.6, 0.6, 1)
	else
		ThreatMiniAbsText:SetTextColor(0.6, 1, 1, 1)
	end
	ThreatMiniAbsText:SetText(threatDelta .. " (".. unitThreat .. " / " .. maxThreat .. ")")
end

--	LibThreatClassic Registration
local LTCIdentifier={};--	CallbackHandler-1.0 can take any value as an identifier, same identifiers overwrite each other on the same events
LibThreatClassic.RegisterCallback(LTCIdentifier,"Activate",TargetFrame_UpdateThreat);
LibThreatClassic.RegisterCallback(LTCIdentifier,"ThreatUpdated",function(event,unitguid,targetguid)
	if targetguid==UnitGUID("target") then TargetFrame_UpdateThreat(); end
end);
LibThreatClassic:RequestActiveOnSolo();

function ThreatMini_OnLoad()
  ThreatMini:RegisterEvent('ADDON_LOADED')
  ThreatMini:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function ThreatMini_OnEvent(self, event, ...)
  if select(1, ...) == "ThreatMini" then
    print("ThreatMini loaded fired")
    CreateFontstring()
  elseif event == "PLAYER_TARGET_CHANGED" then
    TargetFrame_UpdateThreat()
  end
end

