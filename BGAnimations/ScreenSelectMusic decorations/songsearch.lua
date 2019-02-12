local searchstring = ""
local englishes = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	";"
}
local active = false
local whee
local lastsearchstring = ""
local pressingctrl = false

local function searchInput(event)
	if event.DeviceInput.button == "DeviceButton_left ctrl" or event.DeviceInput.button == "DeviceButton_right ctrl" then
		if event.type == "InputEventType_FirstPress" then
			pressingctrl = true
		elseif event.type == "InputEventType_Release" then
			pressingctrl = false
		end
	elseif event.type ~= "InputEventType_Release" then
		if active == false and pressingctrl == true and event.DeviceInput.button == "DeviceButton_s" then
			active = true
			MESSAGEMAN:Broadcast("UpdateString")
		elseif active == true then
			if event.button == "Back" then
				searchstring = ""
				whee:SongSearch(searchstring)
				active = false
				MESSAGEMAN:Broadcast("UpdateString")
			elseif event.button == "Start" then
				active = false
				MESSAGEMAN:Broadcast("UpdateString")
			elseif event.DeviceInput.button == "DeviceButton_space" then -- add space to the string
				searchstring = searchstring .. " "
			elseif event.DeviceInput.button == "DeviceButton_backspace" then
				searchstring = searchstring:sub(1, -2) -- remove the last element of the string
			elseif event.DeviceInput.button == "DeviceButton_delete" then
				searchstring = ""
			elseif event.DeviceInput.button == "DeviceButton_=" then
				searchstring = searchstring .. "="
			else
				for i = 1, #englishes do -- add standard characters to string
					if event.DeviceInput.button == "DeviceButton_" .. englishes[i] then
						searchstring = searchstring .. englishes[i]
					end
				end
			end
			if lastsearchstring ~= searchstring then
				MESSAGEMAN:Broadcast("UpdateString")
				whee:SongSearch(searchstring)
				lastsearchstring = searchstring
			end
		end
	end
end
local xpos = 150
local ypos = SCREEN_HEIGHT * 7 / 12
t =
	Def.ActorFrame {
	BeginCommand = function(self)
		whee = SCREENMAN:GetTopScreen():GetMusicWheel()
		SCREENMAN:GetTopScreen():AddInputCallback(searchInput)
		self:visible(true)
		self:draworder(1)
	end,
	SetCommand = function(self)
		self:finishtweening()
		if active == true then
			whee:Move(0)
			SCREENMAN:set_input_redirected(PLAYER_1, true)
			SCREENMAN:set_input_redirected(PLAYER_2, true)
		else
			SCREENMAN:set_input_redirected(PLAYER_1, false)
			SCREENMAN:set_input_redirected(PLAYER_2, false)
		end
	end,
	UpdateStringMessageCommand = function(self)
		self:queuecommand("Set")
	end,
	Def.BPMDisplay {
		File = THEME:GetPathF("BPMDisplay", "bpm"),
		Name = "BPMDisplay",
		SetCommand = function(self)
			self:SetFromGameState()
		end,
		CurrentSongChangedMessageCommand = function(self)
			self:playcommand("Set")
		end,
		CurrentCourseChangedMessageCommand = function(self)
			self:playcommand("Set")
		end
	},
	Def.Quad {
		InitCommand = function(self)
			self:xy(xpos + 200, ypos):zoomto(SCREEN_WIDTH * 8 / 20, 200):visible(false)
		end,
		SetCommand = function(self)
			self:diffuse(ColorMidTone(ScreenColor(SCREENMAN:GetTopScreen():GetName())))
			self:diffusetopedge(ColorDarkTone(ScreenColor(SCREENMAN:GetTopScreen():GetName()))):diffusealpha(0.8)
			if active then
				self:visible(true)
			else
				self:visible(false)
			end
		end,
		UpdateStringMessageCommand = function(self)
			self:queuecommand("Set")
		end
	},
	Def.Quad {
		InitCommand = function(self)
			self:xy(xpos + 200, ypos)
		end,
		OnCommand = function(self)
			self:diffuse(color("#AA7711")):zoomto(SCREEN_WIDTH / 3, 45):visible(false):diffusealpha(0.75)
		end,
		SetCommand = function(self)
			if active then
				self:visible(true)
			else
				self:visible(false)
			end
		end,
		UpdateStringMessageCommand = function(self)
			self:queuecommand("Set")
		end
	},
	LoadFont("Common Large") ..
		{
			InitCommand = function(self)
				self:xy(xpos + SCREEN_WIDTH / 6, ypos - 60):zoom(0.7):halign(0.5):maxwidth(SCREEN_WIDTH / 3):shadowlength(1)
			end,
			SetCommand = function(self)
				if active then
					self:settext("Search")
				else
					self:settext("")
				end
			end,
			UpdateStringMessageCommand = function(self)
				self:queuecommand("Set")
			end
		},
	LoadFont("Common Large") ..
		{
			InitCommand = function(self)
				self:xy(xpos + 200, ypos):zoom(0.6):halign(0.5):maxwidth(550):shadowlength(1)
			end,
			SetCommand = function(self)
				if active then
					self:settext(searchstring)
				else
					self:settext("")
				end
			end,
			UpdateStringMessageCommand = function(self)
				self:queuecommand("Set")
			end
		}

	--LoadFont("Common Large")..{
	--Text="ctr+s to search";
	--	InitCommand=cmd(xy,xpos+40,SCREEN_WIDTH-20;zoom,0.7;halign,0;shadowlength,1;),
	--},
}

return t
