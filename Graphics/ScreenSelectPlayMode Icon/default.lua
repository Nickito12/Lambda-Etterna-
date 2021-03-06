local gc = Var("GameCommand")

--local string_expl = THEME:GetString(Var "LoadingScreen", gc:GetName().."Explanation")
local icon_color = ModeIconColors[gc:GetName()]
local icon_size = 192

local t = Def.ActorFrame {}
t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
		self:diffusealpha(0):linear(0.4):diffusealpha(1)
	end,
	GainFocusCommand=function(self)
		self:stoptweening():bob():effectmagnitude(0,0,3):decelerate(0.1):zoom(0.95)
	end,
	LoseFocusCommand=function(self)
		self:stoptweening():stopeffect():decelerate(0.1):zoom(0.9)
	end,
	OffCommand=function(self)
		self:decelerate(0.2):zoom(0.7):diffusealpha(0)
	end,
	
	LoadActor("_background base") .. {
		LoseFocusCommand=function(self)
			self:diffuse(ColorMidTone(icon_color))
		end,
		GainFocusCommand=function(self)
			self:diffuse(icon_color)
		end
	},
	
	LoadActor( gc:GetName() ) .. {
		InitCommand=function(self)
			self:addy(-20):diffuse(Color.Black)
		end,
		GainFocusCommand=function(self)
			self:diffusealpha(1.0)
		end,
		LoseFocusCommand=function(self)
			self:diffusealpha(0.7)
		end
	},

	-- todo: generate a better font for these.
	LoadFont("_overpass 48px")..{
		Text=string.upper(gc:GetText()),
		InitCommand=function(self)
			self:horizalign(center):y(icon_size/3.4):zoom(0.5):maxwidth(icon_size*1.3):diffusecolor(color("#000000"))
		end,
		GainFocusCommand=function(self)
			self:diffusealpha(0.8)
		end,
		LoseFocusCommand=function(self)
			self:diffusealpha(0.6)
		end
	},
	
	-- Will this ever actually be used?
	-- LoadFont("Common Normal")..{
		-- Text=string.upper(string_expl),
		-- InitCommand=cmd(y,27.5;maxwidth,232)
	-- },
	
	LoadActor("_highlight") .. {
		LoseFocusCommand=function(self)
			self:stopeffect():decelerate(0.1):diffuse(Color.Invisible)
		end,
		GainFocusCommand=function(self)
			self:decelerate(0.2):diffuse(Color.White):diffuseshift():effectcolor1(Color.White):effectcolor2(color("#FFFFFF99"))
		end
	}
}
return t