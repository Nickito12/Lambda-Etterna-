
local whee
local top

local whee
local top
local y = 310
local height = 68

local function mouseInput(event)
	if event.DeviceInput.button == "DeviceButton_left mouse button" and event.type == "InputEventType_FirstPress"then
		if INPUTFILTER:GetMouseX() > SCREEN_WIDTH/2 then
			local n=0
			local m=1
			if INPUTFILTER:GetMouseY() > y and INPUTFILTER:GetMouseY() < y+height then
				m=0
			elseif INPUTFILTER:GetMouseY() > y+height and INPUTFILTER:GetMouseY() < y+height*2 then
				m=1
				n=1
			elseif INPUTFILTER:GetMouseY() > y+height*2 and INPUTFILTER:GetMouseY() < y+height*3 then
				m=1
				n=2
			elseif INPUTFILTER:GetMouseY() > y+height*3 and INPUTFILTER:GetMouseY() < y+height*4 then
				m=1
				n=3
			elseif INPUTFILTER:GetMouseY() > y+height*4 and INPUTFILTER:GetMouseY() < y+height*5 then
				m=1
				n=4
			elseif INPUTFILTER:GetMouseY() > y+height*5 and INPUTFILTER:GetMouseY() < y+height*6 then
				m=1
				n=5
			elseif INPUTFILTER:GetMouseY() > y-height and INPUTFILTER:GetMouseY() < y then
				m=-1
				n=1
			elseif INPUTFILTER:GetMouseY() > y-height*2 and INPUTFILTER:GetMouseY() < y-height then
				m=-1
				n=2
			elseif INPUTFILTER:GetMouseY() > y-height*3 and INPUTFILTER:GetMouseY() < y-height*2 then
				m=-1
				n=3
			elseif INPUTFILTER:GetMouseY() > y-height*4 and INPUTFILTER:GetMouseY() < y-height*3 then
				m=-1
				n=4
			elseif INPUTFILTER:GetMouseY() > y-height*5 and INPUTFILTER:GetMouseY() < y-height*4 then
				m=-1
				n=5
			end
			
			local doot = whee:MoveAndCheckType(m*n)
			whee:Move(0)
			if m == 0 or doot == "WheelItemDataType_Section" then
				top:SelectCurrent(0)
			end
		end
	elseif event.DeviceInput.button == "DeviceButton_right mouse button" and event.type == "InputEventType_FirstPress"then
		if INPUTFILTER:GetMouseX() > capWideScale(370,500) then
			setTabIndex(7)
			MESSAGEMAN:Broadcast("TabChanged")
		end
	end
end


local t = Def.ActorFrame{
	BeginCommand=function(self)
		top = SCREENMAN:GetTopScreen()
		whee = top:GetMusicWheel()
		top:AddInputCallback(mouseInput)
	end,
}

return t