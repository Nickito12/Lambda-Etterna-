local t = LoadFallbackB()

function gradestring(tier) --to be moved
	if tier == "Grade_Tier01" then
		return "AAAA"
	elseif tier == "Grade_Tier02" then
		return "AAA"
	elseif tier == "Grade_Tier03" then
		return "AA"
	elseif tier == "Grade_Tier04" then
		return "A"
	elseif tier == "Grade_Tier05" then
		return "B"
	elseif tier == "Grade_Tier06" then
		return "C"
	elseif tier == "Grade_Tier07" then
		return "D"
	else
		return "F"
	end
end
local function GetBestScoreByFilter(perc, CurRate)
	local rtTable = getRateTable()
	if not rtTable then
		return nil
	end

	local rates = tableKeys(rtTable)
	local scores, score

	if CurRate then
		local tmp = getCurRateString()
		if tmp == "1x" then
			tmp = "1.0x"
		end
		rates = {tmp}
		if not rtTable[rates[1]] then
			return nil
		end
	end

	table.sort(rates)
	for i = #rates, 1, -1 do
		scores = rtTable[rates[i]]
		local bestscore = 0
		local index

		for ii = 1, #scores do
			score = scores[ii]
			if score:ConvertDpToWife() > bestscore then
				index = ii
				bestscore = score:ConvertDpToWife()
			end
		end

		if index and scores[index]:GetWifeScore() == 0 and GetPercentDP(scores[index]) > perc * 100 then
			return scores[index]
		end

		if bestscore > perc then
			return scores[index]
		end
	end
end

local function GetDisplayScore()
	local score
	score = GetBestScoreByFilter(0, true)

	if not score then
		score = GetBestScoreByFilter(0.9, false)
	end
	if not score then
		score = GetBestScoreByFilter(0.5, false)
	end
	if not score then
		score = GetBestScoreByFilter(0, false)
	end
	return score
end

-- Banner underlay
-- t[#t+1] = Def.ActorFrame {
-- InitCommand=cmd(x,SCREEN_CENTER_X-230;draworder,125);
-- OffCommand=cmd(smooth,0.2;diffusealpha,0;);
-- Def.Quad {
-- InitCommand=cmd(zoomto,468,196;diffuse,color("#fce1a1");diffusealpha,0.4;vertalign,top;y,SCREEN_CENTER_Y-230;);
-- };
-- };

-- Banner

t[#t + 1] = LoadActor("songsearch")
t[#t + 1] =
	LoadActor("_bannerframe") ..
	{
		InitCommand = function(self)
			self:zoom(1):x(SCREEN_CENTER_X - 228):y(SCREEN_CENTER_Y - 165 - 11):draworder(47)
		end,
		OnCommand = function(self)
			self:zoomy(0):decelerate(0.3):zoomy(1)
		end,
		OffCommand = function(self)
			self:decelerate(0.15):zoomx(0)
		end
	}

-- Genre/Artist data
t[#t + 1] =
	LoadActor("_bpmbg") ..
	{
		InitCommand = function(self)
			self:horizalign(center):x(SCREEN_CENTER_X - 228):y(SCREEN_CENTER_Y - 75):zoom(1)
		end,
		OnCommand = function(self)
			self:zoomx(0):diffusealpha(0):decelerate(0.3):zoomx(1):diffusealpha(1)
		end,
		OffCommand = function(self)
			self:sleep(0.3):decelerate(0.15):zoomx(0):diffusealpha(0)
		end
	}

t[#t + 1] =
	Def.ActorFrame {
	InitCommand = function(self)
		self:x(SCREEN_CENTER_X - 330 + 6 - 138):draworder(126)
	end,
	OnCommand = function(self)
		self:diffusealpha(0):smooth(0.3):diffusealpha(1)
	end,
	OffCommand = function(self)
		self:smooth(0.3):diffusealpha(0)
	end,
	-- Length
	StandardDecorationFromFileOptional("SongTime", "SongTime") ..
		{
			SetCommand = function(self)
				local curSelection = nil
				local length = 0.0
				if GAMESTATE:IsCourseMode() then
					curSelection = GAMESTATE:GetCurrentCourse()
					self:queuecommand("Reset")
					if curSelection then
						local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
						if trail then
							length = TrailUtil.GetTotalSeconds(trail)
						else
							length = 0.0
						end
					else
						length = 0.0
					end
				else
					curSelection = GAMESTATE:GetCurrentSong()
					self:queuecommand("Reset")
					if curSelection then
						length = curSelection:MusicLengthSeconds()
						if curSelection:IsLong() then
							self:queuecommand("Long")
						elseif curSelection:IsMarathon() then
							self:queuecommand("Marathon")
						else
							self:queuecommand("Reset")
						end
					else
						length = 0.0
						self:queuecommand("Reset")
					end
				end
				self:settext(SecondsToMSS(length))
			end,
			CurrentSongChangedMessageCommand = function(self)
				self:queuecommand("Set")
			end,
			CurrentCourseChangedMessageCommand = function(self)
				self:queuecommand("Set")
			end,
			CurrentTrailP1ChangedMessageCommand = function(self)
				self:queuecommand("Set")
			end,
			CurrentTrailP2ChangedMessageCommand = function(self)
				self:queuecommand("Set")
			end
		}
}

t[#t + 1] = StandardDecorationFromFileOptional("CourseContentsList", "CourseContentsList")

if not GAMESTATE:IsCourseMode() then
	-- P1 Difficulty Pane
	t[#t + 1] =
		Def.ActorFrame {
		InitCommand = function(self)
			self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1)):horizalign(center):x(SCREEN_CENTER_X - 210):y(SCREEN_CENTER_Y + 210)
		end,
		OnCommand = function(self)
			self:zoomy(0.8):diffusealpha(0):smooth(0.4):diffusealpha(1):zoomy(1)
		end,
		PlayerJoinedMessageCommand = function(self, param)
			if param.Player == PLAYER_1 then
				self:visible(true):diffusealpha(0):linear(0.3):diffusealpha(1)
			end
		end,
		OffCommand = function(self)
			self:decelerate(0.3):zoomy(0.8):diffusealpha(0)
		end,
		LoadActor("_diffnum") ..
			{
				InitCommand = function(self)
					self:zoomy(1.25):addy(20)
				end,
				CurrentStepsP1ChangedMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				PlayerJoinedMessageCommand = function(self)
					self:queuecommand("Set"):diffusealpha(0):decelerate(0.3):diffusealpha(1)
				end,
				ChangedLanguageDisplayMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				SetCommand = function(self)
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					local song = GAMESTATE:GetCurrentSong()
					if song then
						if stepsP1 ~= nil then
							local st = stepsP1:GetStepsType()
							local diff = stepsP1:GetDifficulty()
							local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil
							local cd = GetCustomDifficulty(st, diff, courseType)
							self:finishtweening():linear(0.2):diffuse(ColorLightTone(CustomDifficultyToColor(cd)))
						else
							self:diffuse(color("#666666"))
						end
					else
						self:diffuse(color("#666666"))
					end
				end
			},
		LoadFont("StepsDisplay meter") ..
			{
				InitCommand = function(self)
					self:zoom(1):diffuse(color("#000000")):addx(-143):addy(13)
				end,
				OnCommand = function(self)
					self:diffusealpha(0):smooth(0.2):diffusealpha(0.75)
				end,
				OffCommand = function(self)
					self:linear(0.3):diffusealpha(0)
				end,
				CurrentStepsP1ChangedMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				PlayerJoinedMessageCommand = function(self)
					self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75)
				end,
				ChangedLanguageDisplayMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				SetCommand = function(self)
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					local song = GAMESTATE:GetCurrentSong()
					if song then
						if stepsP1 ~= nil then
							self:settextf("%05.2f", stepsP1:GetMSD(getCurRateValue(), 1))
						else
							self:settext("")
						end
					else
						self:settext("")
					end
				end
			},
		LoadFont("Common Italic Condensed") ..
			{
				InitCommand = function(self)
					self:uppercase(true):zoom(1):addy(-40):addx(-143):diffuse(color("#000000")):maxwidth(115)
				end,
				OnCommand = function(self)
					self:diffusealpha(0):smooth(0.2):diffusealpha(0.75)
				end,
				OffCommand = function(self)
					self:linear(0.3):diffusealpha(0)
				end,
				CurrentStepsP1ChangedMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				PlayerJoinedMessageCommand = function(self)
					self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75)
				end,
				ChangedLanguageDisplayMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				SetCommand = function(self)
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					local song = GAMESTATE:GetCurrentSong()
					if song then
						if stepsP1 ~= nil then
							local st = stepsP1:GetStepsType()
							local diff = stepsP1:GetDifficulty()
							local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil
							local cd = GetCustomDifficulty(st, diff, courseType)
							self:settext(THEME:GetString("CustomDifficulty", ToEnumShortString(diff)))
						else
							self:settext("")
						end
					else
						self:settext("")
					end
				end
			},
		LoadFont("Common Normal") ..
			{
				InitCommand = function(self)
					self:uppercase(true):zoom(0.75):addy(-20):addx(-143):diffuse(color("#000000"))
				end,
				OnCommand = function(self)
					self:diffusealpha(0):smooth(0.2):diffusealpha(0.75)
				end,
				OffCommand = function(self)
					self:linear(0.3):diffusealpha(0)
				end,
				CurrentStepsP1ChangedMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				PlayerJoinedMessageCommand = function(self)
					self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75)
				end,
				ChangedLanguageDisplayMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				SetCommand = function(self)
					stepsP1 = GAMESTATE:GetCurrentSteps(PLAYER_1)
					local song = GAMESTATE:GetCurrentSong()
					if song then
						if stepsP1 ~= nil then
							local st = stepsP1:GetStepsType()
							local diff = stepsP1:GetDifficulty()
							local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil
							local cd = GetCustomDifficulty(st, diff, courseType)
							self:settext(THEME:GetString("StepsType", ToEnumShortString(st)))
						else
							self:settext("")
						end
					else
						self:settext("")
					end
				end
			},
		LoadFont("Common Normal") ..
			{
				InitCommand = function(self)
					self:uppercase(true):zoom(1):addy(70):addx(-143):diffuse(color("#000000"))
				end,
				OnCommand = function(self)
					self:diffusealpha(0):smooth(0.2):diffusealpha(0.75)
				end,
				OffCommand = function(self)
					self:linear(0.3):diffusealpha(0)
				end,
				CurrentStepsP1ChangedMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				CurrentSongChangedMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				PlayerJoinedMessageCommand = function(self)
					self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75)
				end,
				ChangedLanguageDisplayMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				SetCommand = function(self)
					local score = GetDisplayScore()
					local song = GAMESTATE:GetCurrentSong()
					if song and score then
						self:settextf("%05.2f%%", notShit.floor(score:GetWifeScore() * 10000) / 100)
					else
						self:settext("")
					end
				end
			},
		LoadFont("StepsDisplay meter") ..
			{
				InitCommand = function(self)
					self:zoom(1):diffuse(color("#000000")):addx(-143):addy(45)
				end,
				OnCommand = function(self)
					self:diffusealpha(0):smooth(0.2):diffusealpha(0.75)
				end,
				OffCommand = function(self)
					self:linear(0.3):diffusealpha(0)
				end,
				CurrentStepsP1ChangedMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				PlayerJoinedMessageCommand = function(self)
					self:queuecommand("Set"):diffusealpha(0):linear(0.3):diffusealpha(0.75)
				end,
				ChangedLanguageDisplayMessageCommand = function(self)
					self:queuecommand("Set")
				end,
				SetCommand = function(self)
					local song = GAMESTATE:GetCurrentSong()
					local score = GetDisplayScore()
					if song and score then
						self:settext(gradestring(score:GetWifeGrade()))
					else
						self:settext("")
					end
				end
			}
	}

	t[#t + 1] = StandardDecorationFromFileOptional("PaneDisplayTextP1", "PaneDisplayTextP1")
end

-- BPMDisplay
t[#t + 1] =
	Def.ActorFrame {
	InitCommand = function(self)
		self:draworder(126):visible(not GAMESTATE:IsCourseMode())
	end,
	OnCommand = function(self)
		self:diffusealpha(0):smooth(0.3):diffusealpha(1)
	end,
	OffCommand = function(self)
		self:linear(0.3):diffusealpha(0)
	end,
	LoadFont("Common Condensed") ..
		{
			InitCommand = function(self)
				self:horizalign(right):x(SCREEN_CENTER_X - 198 + 69 - 66):y(SCREEN_CENTER_Y - 78 + 2):diffuse(color("#512232")):horizalign(
					right
				):visible(not GAMESTATE:IsCourseMode())
			end,
			OnCommand = function(self)
				self:queuecommand("Set")
			end,
			ChangedLanguageDisplayMessageCommand = function(self)
				self:queuecommand("Set")
			end,
			SetCommand = function(self)
				self:settext("BPM")
			end
		},
	StandardDecorationFromFileOptional("BPMDisplay", "BPMDisplay")
}

t[#t + 1] = StandardDecorationFromFileOptional("DifficultyList", "DifficultyList")
t[#t + 1] =
	StandardDecorationFromFileOptional("SongOptions", "SongOptionsText") ..
	{
		ShowPressStartForOptionsCommand = THEME:GetMetric(Var "LoadingScreen", "SongOptionsShowCommand"),
		ShowEnteringOptionsCommand = THEME:GetMetric(Var "LoadingScreen", "SongOptionsEnterCommand"),
		HidePressStartForOptionsCommand = THEME:GetMetric(Var "LoadingScreen", "SongOptionsHideCommand")
	}

t[#t + 1] =
	Def.ActorFrame {
	Def.Quad {
		InitCommand = function(self)
			self:draworder(160):FullScreen():diffuse(color("0,0,0,1")):diffusealpha(0)
		end,
		ShowPressStartForOptionsCommand = function(self)
			self:sleep(0.2):decelerate(0.5):diffusealpha(1)
		end
	}
}

--t[#t+1] = StandardDecorationFromFileOptional("AlternateHelpDisplay","AlternateHelpDisplay");

-- Change rates with effect up/down
function roundme(x, y)
	y = 10 ^ (y or 0)
	return math.floor(x * y + 0.5) / y
end
function getCurRateValue()
	return roundme(GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate(), 3)
end
function ChangeMusicRate(rate, params)
	if params.Name == "PrevScore" and rate < 2.95 then
		GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate(rate + 0.1)
		GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate(rate + 0.1)
		GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate(rate + 0.1)
		MESSAGEMAN:Broadcast("CurrentRateChanged")
	elseif params.Name == "NextScore" and rate > 0.75 then
		GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate(rate - 0.1)
		GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate(rate - 0.1)
		GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate(rate - 0.1)
		MESSAGEMAN:Broadcast("CurrentRateChanged")
	end

	if params.Name == "PrevRate" and rate < 3 then
		GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate(rate + 0.05)
		GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate(rate + 0.05)
		GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate(rate + 0.05)
		MESSAGEMAN:Broadcast("CurrentRateChanged")
	elseif params.Name == "NextRate" and rate > 0.7 then
		GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate(rate - 0.05)
		GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate(rate - 0.05)
		GAMESTATE:GetSongOptionsObject("ModsLevel_Current"):MusicRate(rate - 0.05)
		MESSAGEMAN:Broadcast("CurrentRateChanged")
	end
end
t[#t + 1] =
	LoadFont("Common Large") ..
	{
		InitCommand = function(self)
			self:visible(false)
		end,
		CodeMessageCommand = function(self, params)
			local rate = getCurRateValue()
			ChangeMusicRate(rate, params)
		end
	}
return t
