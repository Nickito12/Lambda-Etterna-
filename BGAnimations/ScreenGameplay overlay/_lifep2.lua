local t = Def.ActorFrame {}
-- Bar
t[#t + 1] = LoadActor(THEME:GetPathG("LifeMeter", "p1 bar")) .. {}

-- Difficulty

t[#t + 1] =
	Def.ActorFrame {
	InitCommand = function(self)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2)):x(-207):y(0)
	end,
	LoadActor("_diffdia") ..
		{
			OnCommand = function(self)
				self:playcommand("Set")
			end,
			CurrentstepsP2ChangedMessageCommand = function(self)
				self:playcommand("Set")
			end,
			SetCommand = function(self)
				stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					if stepsP2 ~= nil then
						local st = stepsP2:GetStepsType()
						local diff = stepsP2:GetDifficulty()
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
			CurrentstepsP2ChangedMessageCommand = function(self)
				self:playcommand("Set")
			end,
			ChangedLanguageDisplayMessageCommand = function(self)
				self:playcommand("Set")
			end,
			SetCommand = function(self)
				stepsP2 = GAMESTATE:GetCurrentSteps(PLAYER_2)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					if stepsP2 ~= nil then
						local st = stepsP2:GetStepsType()
						local diff = stepsP2:GetDifficulty()
						local cd = GetCustomDifficulty(st, diff)
						self:settext(stepsP2:GetMeter()):diffuse(color("#000000")):diffusealpha(0.8)
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
