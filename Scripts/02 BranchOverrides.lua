Branch.PlayerOptions= function()
	local pm = GAMESTATE:GetPlayMode()
	local restricted = { PlayMode_Oni= true, PlayMode_Rave= true,
		--"PlayMode_Battle" -- ??
	}
	-- this is just here in case the nesty menus ever get adapted to 5.0.
	-- I'm sorry for not just doing it in the first place
	local nesty = false
	
	local optionsScreen = "ScreenPlayerOptions"
	
	if nesty then
		optionsScreen = "ScreenNestyPlayerOptions"
	end
	if restricted[pm] then
		optionsScreen = "ScreenPlayerOptionsRestricted"
	end
	if SCREENMAN:GetTopScreen():GetGoToOptions() then
		return optionsScreen
	else
		return "ScreenStageInformation"
	end
end

Branch.OptionsEdit = function()
	if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
		return "ScreenHowToInstallSongs"
	end
	return "ScreenEditMenu"
end

Branch.AfterEvaluation = function()
	return "ScreenProfileSave"
	--[[]
	if GAMESTATE:IsEventMode() or stagesLeft >= 1 then
		return "ScreenProfileSave"
	elseif song:IsLong() and maxStages <= 2 and stagesLeft < 1 and allFailed then
		return "ScreenProfileSaveSummary"
	elseif song:IsMarathon() and maxStages <= 3 and stagesLeft < 1 and allFailed then
		return "ScreenProfileSaveSummary"
	elseif maxStages >= 2 and stagesLeft < 1 and allFailed then
		return "ScreenProfileSaveSummary"
	elseif allFailed then
		return "ScreenProfileSaveSummary"
	else
		return "ScreenProfileSave"
	end
	]]
end


Branch.AfterSelectProfile = function()
	if ( THEME:GetMetric("Common","AutoSetStyle") == true ) then
		-- use SelectStyle in online...
		return IsNetConnected() and "ScreenSelectStyle" or "ScreenSelectMusic"
	else
		return "ScreenSelectStyle"
	end
end

Branch.AfterProfileLoad = function()
	return "ScreenSelectMusic"
end
