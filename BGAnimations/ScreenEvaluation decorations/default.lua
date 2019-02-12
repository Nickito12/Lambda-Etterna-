-- ...So I realize that I completely ignored almost each and every
-- metrics-bound element this screen could use, but it's okay, right?
-- todo: make a more metrics-bound version of this screen anyways for beginner accessibility.
-- todo: accommodate EvaluationSummary too

local t = LoadFallbackB()

-- A very useful table...
local eval_lines = {
	"W1",
	"W2",
	"W3",
	"W4",
	"W5",
	"Miss",
	"Held",
	"MaxCombo"
}

-- And a function to make even better use out of the table.
local function GetJLineValue(line, pl)
	if line == "Held" then
		return STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetHoldNoteScores("HoldNoteScore_Held")
	elseif line == "MaxCombo" then
		return STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):MaxCombo()
	else
		return STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetTapNoteScores("TapNoteScore_" .. line)
	end
	return "???"
end

-- You know what, we'll deal with getting the overall scores with a function too.
local function GetPlScore(pl, scoretype)
	local primary_score = STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetScore()
	local secondary_score = FormatPercentScore(STATSMAN:GetCurStageStats():GetPlayerStageStats(pl):GetPercentDancePoints())

	--if PREFSMAN:GetPreference("PercentageScoring") then
	primary_score, secondary_score = secondary_score, primary_score
	--end

	if scoretype == "primary" then
		return primary_score
	else
		return secondary_score
	end
end

-- #################################################
-- That's enough functions; let's get this done.

-- Shared portion.
local mid_pane =
	Def.ActorFrame {
	OnCommand = function(self)
		self:diffusealpha(0):sleep(0.3):decelerate(0.4):diffusealpha(1)
	end,
	OffCommand = function(self)
		self:decelerate(0.3):diffusealpha(0)
	end,
	-- Song/course banner.
	Def.Sprite {
		InitCommand = function(self)
			local target = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
			if target and target:HasBanner() then
				self:Load(target:GetBannerPath())
			else
				self:Load(THEME:GetPathG("Common fallback", "banner"))
			end
			self:scaletoclipped(468, 146):x(_screen.cx):y(_screen.cy - 173):zoom(0.8)
		end
	},
	-- Banner frame.
	LoadActor("_bannerframe") ..
		{
			InitCommand = function(self)
				self:x(_screen.cx):y(_screen.cy - 172):zoom(0.8)
			end
		}
}

-- Each line's text, and associated decorations.
for i, v in ipairs(eval_lines) do
	local spacing = 38 * i
	local cur_line = "JudgmentLine_" .. v

	mid_pane[#mid_pane + 1] =
		Def.ActorFrame {
		InitCommand = function(self)
			self:x(_screen.cx):y((_screen.cy / 1.4) + (spacing))
		end,
		OffCommand = function(self)
			self:sleep(0.1 * i):decelerate(0.3):diffusealpha(0)
		end,
		Def.Quad {
			InitCommand = function(self)
				self:zoomto(400, 36):diffuse(JudgmentLineToColor(cur_line)):fadeleft(0.5):faderight(0.5)
			end,
			OnCommand = function(self)
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.9):diffusealpha(1)
			end
		},
		Def.BitmapText {
			Font = "_roboto condensed Bold 48px",
			InitCommand = function(self)
				self:zoom(0.6):diffuse(color("#000000")):settext(string.upper(v))
			end,
			OnCommand = function(self)
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.9):diffusealpha(0.6)
			end
		}
	}
end

t[#t + 1] = mid_pane

-- #################################################
-- Time to deal with all of the player stats. ALL OF THEM.

local eval_parts = Def.ActorFrame {}

for ip, p in ipairs(GAMESTATE:GetHumanPlayers()) do
	-- Some things to help positioning
	local step_count_offs = string.find(p, "P1") and -150 or 150
	local grade_parts_offs = string.find(p, "P1") and -320 or 320
	local p_grade = STATSMAN:GetCurStageStats():GetPlayerStageStats(p):GetGrade()

	-- Step counts.
	for i, v in ipairs(eval_lines) do
		local spacing = 38 * i
		eval_parts[#eval_parts + 1] =
			Def.BitmapText {
			Font = "_overpass 36px",
			InitCommand = function(self)
				self:x(_screen.cx + step_count_offs):y((_screen.cy / 1.4) + (spacing)):diffuse(ColorDarkTone(PlayerColor(p))):zoom(
					0.75
				):diffusealpha(1.0):shadowlength(1)
			end,
			OnCommand = function(self)
				self:settext(GetJLineValue(v, p))
				if string.find(p, "P1") then
					self:horizalign(right)
				else
					self:horizalign(left)
				end
				self:diffusealpha(0):sleep(0.1 * i):decelerate(0.9):diffusealpha(1)
			end,
			OffCommand = function(self)
				self:sleep(0.1 * i):decelerate(0.3):diffusealpha(0)
			end
		}
	end

	-- Primary score.
	eval_parts[#eval_parts + 1] =
		Def.BitmapText {
		Font = "_overpass 36px",
		InitCommand = function(self)
			self:horizalign(center):x(_screen.cx + (grade_parts_offs)):y((_screen.cy - 65)):diffuse(ColorMidTone(PlayerColor(p))):zoom(
				0.75
			):shadowlength(1)
		end,
		OnCommand = function(self)
			self:settextf(
				"%05.2f%% (%s)",
				STATSMAN:GetCurStageStats():GetPlayerStageStats(ip):GetWifeScore() * 10000 / 100,
				"Wife"
			):diffusealpha(0):sleep(0.5):decelerate(0.3):diffusealpha(1)
		end,
		OffCommand = function(self)
			self:decelerate(0.3):diffusealpha(0)
		end
	}
	-- Secondary score.
	--eval_parts[#eval_parts+1] = Def.BitmapText {
	--	Font = "_overpass 36px",
	--	InitCommand=cmd(horizalign,center;x,_screen.cx + (grade_parts_offs);y,(_screen.cy-65)+30;diffuse,ColorDarkTone(PlayerColor(p));zoom,0.75;shadowlength,1),
	--	OnCommand=function(self)
	--		self:settext(GetPlScore(p, "secondary")):diffusealpha(0):sleep(0.6):decelerate(0.3):diffusealpha(1)
	--	end;
	--	OffCommand=function(self)
	--		self:sleep(0.1):decelerate(0.3):diffusealpha(0)
	--	end;
	--}

	-- Letter grade and associated parts.
	eval_parts[#eval_parts + 1] =
		Def.ActorFrame {
		InitCommand = function(self)
			self:x(_screen.cx + grade_parts_offs):y(_screen.cy / 1.91)
		end,
		--Containers. todo: replace with, erm... not quads
		Def.Quad {
			InitCommand = function(self)
				self:zoomto(190, 115):diffuse(ColorMidTone(PlayerColor(p)))
			end,
			OnCommand = function(self)
				self:diffusealpha(0):decelerate(0.4):diffusealpha(0.5)
			end,
			OffCommand = function(self)
				self:decelerate(0.3):diffusealpha(0)
			end
		},
		Def.Quad {
			InitCommand = function(self)
				self:y(110):zoomto(190, 150):diffuse(color("#fce1a1"))
			end,
			OnCommand = function(self)
				self:diffusealpha(0):decelerate(0.4):diffusealpha(0.3)
			end,
			OffCommand = function(self)
				self:decelerate(0.3):diffusealpha(0)
			end
		},
		LoadActor(THEME:GetPathG("GradeDisplay", "Grade " .. p_grade)) ..
			{
				InitCommand = function(self)
					self:zoom(0.75)
				end,
				OnCommand = function(self)
					self:diffusealpha(0):zoom(1):sleep(0.63):decelerate(0.4):zoom(0.75):diffusealpha(1)
				end,
				OffCommand = function(self)
					self:decelerate(0.3):diffusealpha(0)
				end
			},
		Def.BitmapText {
			Font = "_roboto condensed 24px",
			InitCommand = function(self)
				self:diffuse(Color.White):zoom(1):addy(38):maxwidth(160):uppercase(true):diffuse(ColorLightTone(PlayerColor(p))):strokecolor(
					ColorDarkTone(PlayerColor(p))
				):diffusetopedge(Color.White)
			end,
			OffCommand = function(self)
				self:decelerate(0.3):diffusealpha(0)
			end
		}
	}
	-- Primary score.
	eval_parts[#eval_parts + 1] =
		Def.BitmapText {
		Font = "_overpass 36px",
		InitCommand = function(self)
			self:horizalign(center):x(_screen.cx + (grade_parts_offs)):y((_screen.cy - 5)):diffuse(ColorMidTone(PlayerColor(p))):zoom(
				1
			):shadowlength(1)
		end,
		OnCommand = function(self)
			local score = SCOREMAN:GetMostRecentScore()
			local meter = score:GetSkillsetSSR("Overall")
			self:settextf("%5.2f", meter)
		end
	}
end

t[#t + 1] = eval_parts

-- todo: replace.
if GAMESTATE:IsHumanPlayer(PLAYER_1) == true then
	if GAMESTATE:IsCourseMode() == false then
		-- Difficulty banner
		local grade_parts_offs = -320
		t[#t + 1] =
			Def.ActorFrame {
			InitCommand = function(self)
				self:horizalign(center):x(_screen.cx + grade_parts_offs):y(_screen.cy - 98):visible(not GAMESTATE:IsCourseMode())
			end,
			OnCommand = function(self)
				self:zoomx(0.3):diffusealpha(0):sleep(0.5):decelerate(0.4):zoomx(1):diffusealpha(1)
			end,
			OffCommand = function(self)
				self:decelerate(0.4):diffusealpha(0)
			end,
			LoadFont("Common Fallback") ..
				{
					InitCommand = function(self)
						self:zoom(1):horizalign(center):shadowlength(1)
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
								local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil
								local cdp1 = GetCustomDifficulty(st, diff, courseType)
								self:settext(
									string.upper(THEME:GetString("CustomDifficulty", ToEnumShortString(diff))) .. "  " .. stepsP1:GetMeter()
								)
								self:diffuse(ColorDarkTone(CustomDifficultyToColor(cdp1)))
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
end

if GAMESTATE:IsHumanPlayer(PLAYER_2) == true then
	if GAMESTATE:IsCourseMode() == false then
		local grade_parts_offs = 320
		t[#t + 1] =
			Def.ActorFrame {
			InitCommand = function(self)
				self:horizalign(center):x(_screen.cx + grade_parts_offs):y(_screen.cy - 98):visible(not GAMESTATE:IsCourseMode())
			end,
			OnCommand = function(self)
				self:zoomx(0.3):diffusealpha(0):sleep(0.5):decelerate(0.4):zoomx(1):diffusealpha(1)
			end,
			OffCommand = function(self)
				self:decelerate(0.4):diffusealpha(0)
			end,
			LoadFont("Common Fallback") ..
				{
					InitCommand = function(self)
						self:zoom(1):horizalign(center):shadowlength(1)
					end,
					OnCommand = function(self)
						self:playcommand("Set")
					end,
					CurrentStepsP2ChangedMessageCommand = function(self)
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
								local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil
								local cdp2 = GetCustomDifficulty(st, diff, courseType)
								self:settext(
									string.upper(THEME:GetString("CustomDifficulty", ToEnumShortString(diff))) .. "  " .. stepsP2:GetMeter()
								)
								self:diffuse(ColorDarkTone(CustomDifficultyToColor(cdp2)))
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
end

t[#t + 1] = StandardDecorationFromFileOptional("LifeDifficulty", "LifeDifficulty")
t[#t + 1] = StandardDecorationFromFileOptional("TimingDifficulty", "TimingDifficulty")

t[#t + 1] = LoadActor("offsetplot")

return t
