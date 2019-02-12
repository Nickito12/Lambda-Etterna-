local t = Def.ActorFrame {}

t[#t + 1] =
	Def.ActorFrame {
	InitCommand = function(self)
		self:Center()
	end,
	Def.Quad {
		InitCommand = function(self)
			self:scaletoclipped(SCREEN_WIDTH, SCREEN_HEIGHT)
		end,
		OnCommand = function(self)
			self:diffuse(color("#947B7E")):diffusebottomedge(color("#D698A0"))
		end
	}
}

t[#t + 1] =
	Def.ActorFrame {
	Def.Quad {
		InitCommand = function(self)
			self:horizalign(left):zoomto(SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.78):x(SCREEN_LEFT):y(SCREEN_CENTER_Y + 21)
		end,
		OnCommand = function(self)
			self:diffuse(color("#FFFFFF")):diffusealpha(0.15)
		end
	}
}

return t
