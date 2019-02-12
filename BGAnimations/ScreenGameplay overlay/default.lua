local t = Def.ActorFrame {}
--P1
if GAMESTATE:GetPlayMode() ~= "PlayMode_Rave" then
	if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
		t[#t + 1] =
			LoadActor("_lifep1") ..
			{
				InitCommand = function(self)
					self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1)):x(SCREEN_LEFT + 40):y(SCREEN_CENTER_Y):rotationz(-90)
				end,
				OnCommand = function(self)
					self:addx(-100):sleep(1):decelerate(0.9):addx(100)
				end,
				OffCommand = function(self)
					self:sleep(1):decelerate(0.9):addx(-100)
				end
			}
	end

	if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
		t[#t + 1] =
			LoadActor("_lifep2") ..
			{
				InitCommand = function(self)
					self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2)):x(SCREEN_RIGHT - 40):y(SCREEN_CENTER_Y):rotationz(-90)
				end,
				OnCommand = function(self)
					self:addx(100):sleep(1):decelerate(0.9):addx(-100)
				end,
				OffCommand = function(self)
					self:sleep(1):decelerate(0.9):addx(100)
				end
			}
	end
end

-- Move diamonds on battle
if GAMESTATE:GetPlayMode() == "PlayMode_Rave" then
	-- P1
	t[#t + 1] =
		Def.ActorFrame {
		InitCommand = function(self)
			self:x(SCREEN_CENTER_X - 110):y(SCREEN_BOTTOM - 55)
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
					self:zoom(0.75):horizalign(center)
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
	-- P2
	t[#t + 1] =
		Def.ActorFrame {
		InitCommand = function(self)
			self:x(SCREEN_CENTER_X + 110):y(SCREEN_BOTTOM - 55)
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
					self:zoom(0.75):horizalign(center)
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
end

t[#t + 1] = StandardDecorationFromFileOptional("StageDisplay", "StageDisplay")
t[#t + 1] = LoadActor("WifeJudgmentSpotting")
t[#t + 1] = LoadActor("titlesplash")
return t
