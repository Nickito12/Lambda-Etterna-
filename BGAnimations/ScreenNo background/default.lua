local t = Def.ActorFrame {}

t[#t + 1] =
	Def.ActorFrame {
	FOV = 90,
	InitCommand = function(self)
		self:Center()
	end,
	Def.Quad {
		InitCommand = function(self)
			self:scaletoclipped(SCREEN_WIDTH, SCREEN_HEIGHT)
		end,
		OnCommand = function(self)
			self:diffuse(color("#fdbe28")):diffusebottomedge(color("#f67849"))
		end
	},
	Def.ActorFrame {
		InitCommand = function(self)
			self:diffusealpha(0.2)
		end,
		LoadActor("_checkerboard") ..
			{
				InitCommand = function(self)
					self:rotationy(0):rotationz(0):rotationx(-90 / 4 * 3.5):zoomto(SCREEN_WIDTH * 2, SCREEN_HEIGHT * 2):customtexturerect(
						0,
						0,
						SCREEN_WIDTH * 4 / 256,
						SCREEN_HEIGHT * 4 / 256
					)
				end,
				OnCommand = function(self)
					self:texcoordvelocity(0, 0.25):diffuse(color("#ffffff")):fadetop(1)
				end
			}
	}
}

return t
