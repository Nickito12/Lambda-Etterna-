local t = Def.ActorFrame {}
-- Bar
t[#t + 1] = LoadActor(THEME:GetPathG("LifeMeter", "p1 bar")) .. {}

-- Difficulty

t[#t + 1] =
	Def.ActorFrame {
	InitCommand = function(self)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1)):x(-207):y(0)
	end,
	LoadActor("_diffdia") ..
		{
			OnCommand = function(self)
				self:playcommand("Set")
			end,
			CurrentStepsP1ChangedMessageCommand = function(self)
				self:playcommand("Set")
			end,
			SetCommand = function(self)
				stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					if stepsP1 ~= nil then
						local st = stepsP1:GetStepsType()
						local diff = stepsP1:GetDifficulty()
						local cd = GetCustomDifficulty(st, diff)
						self:diffuse(CustomDifficultyToColor(cd))
					end
				end
			end
		},
	LoadFont("StepsDisplay description") ..
		{
			InitCommand = function(self)
				self:zoom(0.75):horizalign(center):rotationz(90)
			end,
			OnCommand = function(self)
				self:playcommand("Set")
			end,
			CurrentStepsP1ChangedMessageCommand = function(self)
				self:playcommand("Set")
			end,
			ChangedLanguageDisplayMessageCommand = function(self)
				self:playcommand("Set")
			end,
			SetCommand = function(self)
				stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					if stepsP1 ~= nil then
						local st = stepsP1:GetStepsType()
						local diff = stepsP1:GetDifficulty()
						local cd = GetCustomDifficulty(st, diff)
						self:settext(stepsP1:GetMeter()):diffuse(color("#000000")):diffusealpha(0.8)
					else
						self:settext("")
					end
				else
					self:settext("")
				end
			end
		}
}

return t
