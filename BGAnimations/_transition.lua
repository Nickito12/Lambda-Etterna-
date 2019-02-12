-- To save on intense copy/pasting, this file was made to be loaded by actual in/out bganim files,
-- whose only real jobs are to pass in the transition type (in or out), and in certain cases, the
-- color (as is the case in ScreenEditMenu in, ScreenSelectMusic in, etc).
-- Other than that, there isn't really too much to say.
local t = Def.ActorFrame {}
local params = ...

local startAlpha = params.transition_type == "in" and 1 or 0
local endAlpha = math.abs(startAlpha - 1)

for i = 1, 6 do
	local sleep_time = 0.1 * i
	t[#t + 1] =
		LoadActor(THEME:GetPathG("", "_pt" .. i)) ..
		{
			InitCommand = function(self)
				self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center():diffuse(params.color)
			end,
			OnCommand = function(self)
				self:diffusealpha(startAlpha):sleep(sleep_time):linear(0.14):diffusealpha(endAlpha)
			end
		}
end

t[#t + 1] =
	Def.Quad {
	InitCommand = function(self)
		self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center():diffuse(params.color)
	end,
	OnCommand = function(self)
		self:diffusealpha(startAlpha):linear(0.7):diffusealpha(endAlpha)
	end
}

return t
