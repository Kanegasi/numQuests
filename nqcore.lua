 -- THE FOLLOWING "LOCAL" LINES ARE THE OPTIONS
 -- true MEANS ENABLED AND false MEANS DISABLED
 -- IF YOU EDITED THIS WHILE INGAME USE /reload


local QuestsHeader = true

local ObjectivesHeader = true

local WorldMapTitle = true


 -- ======================================================
 -- ======== DO NOT EDIT ANYTHING BELOW THIS LINE ========
 -- ======================================================

local InCombat,a,t=false,...
local f=CreateFrame("frame",a)
local function p(m,r,g,b) ChatFrame1:AddMessage(m,r or 1,g or 1,b or 1,"temp") end
SLASH_NUMQUESTS1="/numquests" SLASH_NUMQUESTS2="/numquest" SLASH_NUMQUESTS3="/numq"
SlashCmdList["NUMQUESTS"]=function()
	local other,counted,visible={},{},{}
	for i=1,t.allmax do
		local title,_,_,header,_,_,_,id,_,_,_,_,task,bounty,_,hidden=GetQuestLogTitle(i)
		if title and not header then
			local entry=(GetQuestLink(id) or title).." - ID: "..id
			if hidden and (task or bounty) then tinsert(other,entry)
			elseif hidden then tinsert(counted,entry)
			else tinsert(visible,entry) end
		end
	end
	if #other>0 then
		p("== Hidden quests that do not count ==",0,1,0)
		for k,v in ipairs(other) do p("  -  "..v) end
		p("================================",0,1,0)
	end
	if #counted>0 then
		p("== Hidden quests that DO count ==",1,0,0)
		for k,v in ipairs(counted) do p("  "..k..". "..v) end
		p("================================",1,0,0)
	end
	p("====== Visible quests in log ======")
	for k,v in ipairs(visible) do p("  "..(k+#counted)..". "..v) end
	p("================================")
	p("=== Total: "..(#other+#counted+#visible).." - Overall max: "..t.allmax.." ===",1,.5,0)
end
function t.PLAYER_REGEN_DISABLED() InCombat=true end function t.PLAYER_REGEN_ENABLED() InCombat=false end
function t.QUEST_LOG_UPDATE()
	local _,current=GetNumQuestLogEntries()
	local playermax=C_QuestLog.GetMaxNumQuestsCanAccept()
	t.allmax=C_QuestLog.GetMaxNumQuests()
	if current and playermax and not InCombat and not InCombatLockdown() then
		local curmax=current.."/"..playermax
		if QuestsHeader then ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(curmax.." "..TRACKER_HEADER_QUESTS) end
		if ObjectivesHeader then ObjectiveTrackerFrame.HeaderMenu.Title:SetText(curmax.." "..OBJECTIVES_TRACKER_LABEL) end
		if WorldMapTitle then WorldMapFrame.BorderFrame.TitleText:SetText(MAP_AND_QUEST_LOG.." ("..curmax..")") end
	end
end
f:RegisterEvent("PLAYER_REGEN_DISABLED") f:RegisterEvent("PLAYER_REGEN_ENABLED") f:RegisterEvent("QUEST_LOG_UPDATE")
f:SetScript("OnEvent",function(_,event,...)t[event](...)end)
