-- The "boss song" threshold is controlled entirely by a theme preference.
function GetExtraColorThreshold()
	local ret = {
		["old"] = 10,
		["X"] = 15,
		["pump"] = 21
	}
	return 10
end

-- These judgment-related things are also controlled by theme preferences,
-- but allow using the default gametype-based setting just in case.

-- Lowest judgment allowed to increment a combo.
function ComboContinue()
	local Continue = {
		dance = GAMESTATE:GetPlayMode() == "PlayMode_Oni" and "TapNoteScore_W2" or "TapNoteScore_W3",
		pump = "TapNoteScore_W3",
		beat = "TapNoteScore_W3",
		kb7 = "TapNoteScore_W3",
		para = "TapNoteScore_W4"
	}
	return Continue[GAMESTATE:GetCurrentGame():GetName()] or "TapNoteScore_W3"
end

-- Lowest judgment allowed to maintain a combo; but not increment it.
function ComboMaintain()
	local Maintain = {
		dance = "TapNoteScore_W3",
		pump = "TapNoteScore_W4",
		beat = "TapNoteScore_W3",
		kb7 = "TapNoteScore_W3",
		para = "TapNoteScore_W4"
	}
	return Maintain[GAMESTATE:GetCurrentGame():GetName()] or "TapNoteScore_W3"
end

-- The name's misleading; this is used for SelectPlayMode.
function ScreenSelectStylePositions(count)
	local poses = {}
	local choice_size = 192

	for i = 1, count do
		local start_x = _screen.cx + ((choice_size / 1.5) * (i - math.ceil(count / 2)))
		-- The Y position depends on if the icon's index is even or odd.
		local start_y = i % 2 == 0 and _screen.cy / 0.8 or (_screen.cy / 0.8) - (choice_size / 1.5)
		poses[#poses + 1] = {start_x, start_y}
	end

	return poses
end
