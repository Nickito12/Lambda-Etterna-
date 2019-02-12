function offsetplot(pn)
	local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
	local steps = GAMESTATE:GetCurrentSteps(pn)
	local song = GAMESTATE:GetCurrentSong(pn)

	if pss == nil or steps == nil or song == nil then
		return nil
	end
	local judge = GetTimingDifficulty()
	local tst = {1.50, 1.33, 1.16, 1.00, 0.84, 0.66, 0.50, 0.33, 0.20}
	local plotX, plotY
	local plotWidth, plotHeight = 400, 120
	if pn == PLAYER_1 then
		plotX, plotY = 9 + plotWidth / 2, SCREEN_HEIGHT - 56 - plotHeight / 2
	else
		plotX, plotY = SCREEN_WIDTH - 9 - plotWidth / 2, SCREEN_HEIGHT - 56 - plotHeight / 2
	end
	local dotDims, plotMargin = 2, 4
	local maxOffset = 180 * tst[judge]
	local dvt = pss:GetOffsetVector()
	local nrt = pss:GetNoteRowVector()
	local td = steps:GetTimingData()
	local finalSecond = song:GetLastSecond()

	local bg = color("0,0,0,0")
	local bgalpha = 0.6
	local judgment = {
		-- Colors of each Judgment types
		TapNoteScore_W1 = JudgmentLineToColor("JudgmentLine_W1"),
		--"#99ccff",
		TapNoteScore_W2 = JudgmentLineToColor("JudgmentLine_W2"),
		--"#f2cb30",
		TapNoteScore_W3 = JudgmentLineToColor("JudgmentLine_W3"),
		--"#14cc8f",
		TapNoteScore_W4 = JudgmentLineToColor("JudgmentLine_W4"),
		--"#1ab2ff",
		TapNoteScore_W5 = JudgmentLineToColor("JudgmentLine_W5"),
		--"#ff1ab3",
		TapNoteScore_Miss = JudgmentLineToColor("JudgmentLine_Miss"),
		--"#cc2929",
		HoldNoteScore_Held = JudgmentLineToColor("JudgmentLine_Held"),
		--"#f2cb30",
		HoldNoteScore_LetGo = color("#cc2929")
	}

	local function fitX(x) -- Scale time values to fit within plot width.
		return x / finalSecond * plotWidth - plotWidth / 2
	end

	local function fitY(y) -- Scale offset values to fit within plot height
		return -1 * y / maxOffset * plotHeight / 2
	end

	function byJudgment(judge)
		return judgment[judge]
	end

	function offsetToJudgeColor(offset, scale)
		local offset = math.abs(offset)
		if not scale then
			scale = PREFSMAN:GetPreference("TimingWindowScale")
		end
		if offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW1") then
			return judgment["TapNoteScore_W1"]
		elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW2") then
			return judgment["TapNoteScore_W2"]
		elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW3") then
			return judgment["TapNoteScore_W3"]
		elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW4") then
			return judgment["TapNoteScore_W4"]
		elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW5") then
			return judgment["TapNoteScore_W5"]
		else
			return judgment["TapNoteScore_Miss"]
		end
	end

	--local function plotOffset(nr,dv)
	--	if dv == 1000 then 	-- 1000 denotes a miss for which we use a different marker
	--		return Def.Quad{InitCommand=cmd(xy,fitX(nr),fitY(tst[judge]*184);zoomto,dotDims,dotDims;diffuse,offsetToJudgeColor(dv/1000);valign,0)}
	--	end
	--	return Def.Quad{
	--		InitCommand=cmd(xy,fitX(nr),fitY(dv);zoomto,dotDims,dotDims;diffuse,offsetToJudgeColor(dv/1000)),
	--		JudgeDisplayChangedMessageCommand=function(self)
	--			local pos = fitY(dv)
	--			if math.abs(pos) > plotHeight/2 then
	--				self:y(fitY(tst[judge]*184))
	--			else
	--				self:y(pos)
	--			end
	--			self:diffuse(offsetToJudgeColor(dv/1000, tst[judge]))
	--		end
	--	}
	--end

	local o =
		Def.ActorFrame {
		InitCommand = function(self)
			self:xy(plotX, plotY)
		end,
		CodeMessageCommand = function(self, params)
			if params.Name == "PrevJudge" and judge > 1 then
				judge = judge - 1
			elseif params.Name == "NextJudge" and judge < 9 then
				judge = judge + 1
			end
			maxOffset = 180 * tst[judge]
			MESSAGEMAN:Broadcast("JudgeDisplayChanged")
		end
	}
	-- Center Bar

	o[#o + 1] =
		Def.Quad {
		InitCommand = function(self)
			self:zoomto(plotWidth + plotMargin, 1):diffuse(byJudgment("TapNoteScore_W1"))
		end
	}
	local fantabars = {22.5, 45, 90, 135}
	local bantafars = {"TapNoteScore_W2", "TapNoteScore_W3", "TapNoteScore_W4", "TapNoteScore_W5"}
	for i = 1, #fantabars do
		o[#o + 1] =
			Def.Quad {
			InitCommand = function(self)
				self:y(fitY(tst[judge] * fantabars[i])):zoomto(plotWidth + plotMargin, 1):diffuse(byJudgment(bantafars[i]))
			end
		}

		o[#o + 1] =
			Def.Quad {
			InitCommand = function(self)
				self:y(fitY(-tst[judge] * fantabars[i])):zoomto(plotWidth + plotMargin, 1):diffuse(byJudgment(bantafars[i]))
			end
		}
	end
	-- Background

	o[#o + 1] =
		Def.Quad {
		InitCommand = function(self)
			self:zoomto(plotWidth + plotMargin, plotHeight + plotMargin):diffuse(bg):diffusealpha(bgalpha)
		end
	}
	-- Convert noterows to timestamps and plot dots
	local wuab = {}
	for i = 1, #nrt do
		wuab[i] = td:GetElapsedTimeFromNoteRow(nrt[i])
	end

	local dotWidth = dotDims / 2
	o[#o + 1] =
		Def.ActorMultiVertex {
		Name = "AMV_Quads",
		InitCommand = function(self)
			self:visible(true)
			self:xy(0, 0)
			local verts = {}
			for i = 1, #nrt do
				local color = offsetToJudgeColor(dvt[i] / 1000)
				local x = fitX(wuab[i])
				local y = fitY(dvt[i])
				if math.abs(y) > plotHeight / 2 then
					y = fitY(tst[judge] * 183)
				end
				verts[#verts + 1] = {{x - dotWidth, y + dotWidth, 0}, color}
				verts[#verts + 1] = {{x + dotWidth, y + dotWidth, 0}, color}
				verts[#verts + 1] = {{x + dotWidth, y - dotWidth, 0}, color}
				verts[#verts + 1] = {{x - dotWidth, y - dotWidth, 0}, color}
			end
			self:SetVertices(verts)
			self:SetDrawState {Mode = "DrawMode_Quads", First = 1, Num = #verts}
		end,
		JudgeDisplayChangedMessageCommand = function(self)
			local verts = {}
			for i = 1, #nrt do
				local x = fitX(wuab[i])
				local y = fitY(dvt[i])
				local color = offsetToJudgeColor(dvt[i] / 1000, tst[judge])
				if math.abs(y) > plotHeight / 2 then
					y = fitY(tst[judge] * 183)
				end
				verts[#verts + 1] = {{x - dotWidth, y + dotWidth, 0}, color}
				verts[#verts + 1] = {{x + dotWidth, y + dotWidth, 0}, color}
				verts[#verts + 1] = {{x + dotWidth, y - dotWidth, 0}, color}
				verts[#verts + 1] = {{x - dotWidth, y - dotWidth, 0}, color}
			end
			self:SetVertices(verts)
		end
	}

	-- Early/Late markers
	o[#o + 1] =
		LoadFont("Common Normal") ..
		{
			InitCommand = function(self)
				self:xy(-plotWidth / 2, -plotHeight / 2 + 2):settextf("Late (+%ims)", maxOffset):zoom(0.35):halign(0):valign(0)
			end,
			JudgeDisplayChangedMessageCommand = function(self)
				self:settextf("Late (+%ims)", maxOffset)
			end
		}
	o[#o + 1] =
		LoadFont("Common Normal") ..
		{
			InitCommand = function(self)
				self:xy(-plotWidth / 2, plotHeight / 2 - 2):settextf("Early (-%ims)", maxOffset):zoom(0.35):halign(0):valign(1)
			end,
			JudgeDisplayChangedMessageCommand = function(self)
				self:settextf("Early (-%ims)", maxOffset)
			end
		}

	return o
end

local t = Def.ActorFrame {}

t[#t + 1] = offsetplot(PLAYER_1)
if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	t[#t + 1] = offsetplot(PLAYER_2)
end
return t
