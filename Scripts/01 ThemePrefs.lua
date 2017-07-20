-- StepMania 5 Default Theme Preferences Handler
local function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

-- Example usage of new system (absolutely fully implemented and completely usable)
local Prefs =
{
	AutoSetStyle =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayShowStepsDisplay = 
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayShowScore =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ShowLotsaOptions =
	{
		Default = true,
		Choices = { OptionNameString('Many'), OptionNameString('Few') },
		Values = { true, false }
	},
	LongFail =
	{
		Default = false,
		Choices = { OptionNameString('Short'), OptionNameString('Long') },
		Values = { false, true }
	},
	NotePosition =
	{
		Default = true,
		Choices = { OptionNameString('Normal'), OptionNameString('Lower') },
		Values = { true, false }
	},
	ComboOnRolls =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	FlashyCombo =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ComboUnderField =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	FancyUIBG =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	TimingDisplay =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayFooter =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	PreferredMeter =
	{
		Default = "old",
		Choices = { OptionNameString('MeterClassic'), OptionNameString('MeterX'), OptionNameString('MeterPump') },
		Values = { "old", "X", "pump" }
	},
	CustomComboContinue =
	{
		Default = "default",
		Choices = { OptionNameString('Default'), OptionNameString('TNS_W1'), OptionNameString('TNS_W2'), OptionNameString('TNS_W3'), OptionNameString('TNS_W4')  },
		Values = { "default", "TapNoteScore_W1", "TapNoteScore_W2", "TapNoteScore_W3", "TapNoteScore_W4" }
	},
	CustomComboMaintain =
	{
		Default = "default",
		Choices = { OptionNameString('Default'), OptionNameString('TNS_W1'), OptionNameString('TNS_W2'), OptionNameString('TNS_W3'), OptionNameString('TNS_W4')  },
		Values = { "default", "TapNoteScore_W1", "TapNoteScore_W2", "TapNoteScore_W3", "TapNoteScore_W4" }
	},
	ForcedExtraMods =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	}
}

ThemePrefs.InitAll(Prefs)

function InitUserPrefs()
	local Prefs = {
		UserPrefScoringMode = 'DDR Extreme',
        UserPrefSoundPack   = 'default',
		UserPrefProtimingP1 = false,
		UserPrefProtimingP2 = false,
	}
	for k, v in pairs(Prefs) do
		-- kind of xxx
		local GetPref = type(v) == "boolean" and GetUserPrefB or GetUserPref
		if GetPref(k) == nil then
			SetUserPref(k, v)
		end
	end

	-- screen filter
	--setenv("ScreenFilterP1",0)
	--setenv("ScreenFilterP2",0)
end

function GetProTiming(pn)
	local pname = ToEnumShortString(pn)
	if GetUserPref("ProTiming"..pname) then
		return GetUserPrefB("ProTiming"..pname)
	else
		SetUserPref("ProTiming"..pname,false)
		return false
	end
end


local RSChoices = {}
for i=1,250  do
	RSChoices[i] = tostring(i).."%"
end
function ReceptorSize()
	local t = {
		Name = "ReceptorSize",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = RSChoices,
		LoadSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local size = playerConfig:get_data(pn_to_profile_slot(pn)).ReceptorSize--tonumber(GetUserPref("ReceptorSize"..pName))--getenv("ReceptorSize"..pName) or 100--playerConfig:get_data(pn_to_profile_slot(pn)).ReceptorSize
			list[size] = true
		end,
		SaveSelections = function(self, list, pn)
			for i=1,#list do
				if list[i] == true then
					--setenv("ReceptorSize"..pName, i)
					local ps = pn_to_profile_slot(pn)
					playerConfig:get_data(ps).ReceptorSize = i
					playerConfig:set_dirty(ps)
					playerConfig:save(ps)
					--SetUserPref("ReceptorSize" .. ToEnumShortString(pn), tostring(i))
					--playerConfig:get_data(pn_to_profile_slot(pn)).ReceptorSize = value
					break
				end
			end
			--playerConfig:set_dirty(pn_to_profile_slot(pn))
			--playerConfig:save(pn_to_profile_slot(pn))
		end,
	}
	--setmetatable( t, t )
	return t
end
--[[ option rows ]]

-- screen filter
function OptionRowScreenFilter()
	return {
		Name="ScreenFilter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { THEME:GetString('OptionNames','Off'),'0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1.0', },
		LoadSelections = function(self, list, pn)
			local filterValue = playerConfig:get_data(pn_to_profile_slot(pn)).ScreenFilter--tonumber(GetUserPref("ScreenFilter"..pName))--getenv("ScreenFilter"..pName)
			if filterValue ~= nil then
				local val = scale(tonumber(filterValue),0,1,1,#list )
				list[val] = true
			else
				local ps = pn_to_profile_slot(pn)
				playerConfig:get_data(ps).ScreenFilter = 0
				playerConfig:set_dirty(ps)
				playerConfig:save(ps)
				--setenv("ScreenFilter"..pName,0)
				--SetUserPref("ScreenFilter" .. pName), "0")
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			for i=1,#list do
				if list[i] == true then
					local val = scale(i,1,#list,0,1)
					local ps = pn_to_profile_slot(pn)
					playerConfig:get_data(ps).ScreenFilter = value
					playerConfig:set_dirty(ps)
					playerConfig:save(ps)
					--SetUserPref("ScreenFilter" .. ToEnumShortString(pn), tostring(val))
					--setenv("ScreenFilter"..pName,val)
					break
				end
			end
		end,
	}
end

-- protiming
function OptionRowProTiming()
	return {
		Name = "ProTiming",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = {
			THEME:GetString('OptionNames','Off'),
			THEME:GetString('OptionNames','On')
		},
		LoadSelections = function(self, list, pn)
			if GetUserPrefB("UserPrefProtiming" .. ToEnumShortString(pn)) then
				local bShow = GetUserPrefB("UserPrefProtiming" .. ToEnumShortString(pn))
				if bShow then
					list[2] = true
				else
					list[1] = true
				end
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local bSave = list[2] and true or false
			SetUserPref("UserPrefProtiming" .. ToEnumShortString(pn), bSave)
		end
	}
end


function JudgmentText()
	local t = {
		Name = "JudgmentText",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Hide'),'Show'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).JudgmentText
			if pref then
				list[2] = true
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			value = list[2]
			playerConfig:get_data(pn_to_profile_slot(pn)).JudgmentText = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end	

function DisplayPercent()
	local t = {
		Name = "DisplayPercent",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),'On'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).DisplayPercent
			if pref then
				list[2] = true
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			value = list[2]
			playerConfig:get_data(pn_to_profile_slot(pn)).DisplayPercent = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end	

function TargetTracker()
	local t = {
		Name = "TargetTracker",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),'On'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).TargetTracker
			if pref then
				list[2] = true
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			value = list[2]
			playerConfig:get_data(pn_to_profile_slot(pn)).TargetTracker = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end	

local tChoices = {}
for i=1,99 do
	tChoices[i] = tostring(i)..'%'
end
for i=1,3 do
	tChoices[99+i] = tostring(99+i*0.25)..'%'
end
for i=1,4 do
	tChoices[#tChoices+1] = tostring(99.96 + i*0.01)..'%'
end
function TargetGoal()
	local t = {
		Name = "TargetGoal",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = tChoices,
		LoadSelections = function(self, list, pn)
			local prefsval = playerConfig:get_data(pn_to_profile_slot(pn)).TargetGoal
			local index = IndexOf(tChoices, prefsval.."%")
			list[index] = true
		end,
		SaveSelections = function(self, list, pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						local value = i
						playerConfig:get_data(pn_to_profile_slot(pn)).TargetGoal = tonumber(string.sub(tChoices[value],1,#tChoices[value]-1))
						found = true
					end
				end
			end
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end

function TargetTrackerMode()
	local t = {
		Name = "TargetTrackerMode",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = {'Set Percent','Personal Best'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).TargetTrackerMode
			list[pref+1] = true
		end,
		SaveSelections = function(self, list, pn)
			local value
			if list[2] then
				value = 1
			else
				value = 0
			end
			playerConfig:get_data(pn_to_profile_slot(pn)).TargetTrackerMode = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end	

function JudgeCounter()
	local t = {
		Name = "JudgeCounter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),'On'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).JudgeCounter
			if pref then
				list[2] = true
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			value = list[2]
			playerConfig:get_data(pn_to_profile_slot(pn)).JudgeCounter = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end	

function PlayerInfo()
	local t = {
		Name = "PlayerInfo",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),'On'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).PlayerInfo
			if pref then
				list[2] = true
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			value = list[2]
			playerConfig:get_data(pn_to_profile_slot(pn)).PlayerInfo = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end,
	}
	setmetatable( t, t )
	return t
end	

function CustomizeGameplay()
	local t = {
		Name = "CustomizeGameplay",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),'On'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).CustomizeGameplay
			if pref then
				list[2] = true
			else
				list[1] = true
			end
			PREFSMAN:SetPreference("AutoPlay", (list[2] and 1 or 0))
		end,
		SaveSelections = function(self, list, pn)
			local value
			value = list[2]
			PREFSMAN:SetPreference("AutoPlay", (list[2] and 1 or 0))
			playerConfig:get_data(pn_to_profile_slot(pn)).CustomizeGameplay = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end,
	}
	setmetatable( t, t )
	return t
end

function ErrorBar()
	local t = {
		Name = "ErrorBar",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),'On'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).ErrorBar
			if pref then
				list[2] = true
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			value = list[2]
			playerConfig:get_data(pn_to_profile_slot(pn)).ErrorBar = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end	

function FullProgressBar()
	local t = {
		Name = "FullProgressBar",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),'On'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).FullProgressBar
			if pref then
				list[2] = true
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			value = list[2]
			playerConfig:get_data(pn_to_profile_slot(pn)).FullProgressBar = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end	

function MiniProgressBar()
	local t = {
		Name = "MiniProgressBar",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),'On'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).MiniProgressBar
			if pref then
				list[2] = true
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			value = list[2]
			playerConfig:get_data(pn_to_profile_slot(pn)).MiniProgressBar = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end	

function LaneCover()
	local t = {
		Name = "LaneCover",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),'Sudden','Hidden'},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).LaneCover
			list[pref+1] = true
		end,
		SaveSelections = function(self, list, pn)
			local value
			if list[1] == true then
				value = 0
			elseif list[2] == true then
				value = 1
			else
				value = 2
			end
			playerConfig:get_data(pn_to_profile_slot(pn)).LaneCover = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end	

function NPSDisplay()
	local t = {
		Name = "NPSDisplay",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = {"NPS Display","NPS Graph"},
		LoadSelections = function(self, list, pn)
			local npsDisplay = playerConfig:get_data(pn_to_profile_slot(pn)).NPSDisplay
			local npsGraph = playerConfig:get_data(pn_to_profile_slot(pn)).NPSGraph
			if npsDisplay then
				list[1] = true
			end
			if npsGraph then 
				list[2] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			playerConfig:get_data(pn_to_profile_slot(pn)).NPSDisplay = list[1]
			playerConfig:get_data(pn_to_profile_slot(pn)).NPSGraph = list[2]
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end

function BackgroundType()
	local t = {
		Name = "BackgroundType";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Default","Static Background", "Random Background"};
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).BackgroundType
			list[pref] = true
		end,
		SaveSelections = function(self, list, pn)
			local value
			if list[1] then
				value = 1
			elseif list[2] then
				value = 2
			else
				value = 3
			end
			playerConfig:get_data(pn_to_profile_slot(pn)).BackgroundType = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end

function DefaultScoreType()
	local t = {
		Name = "DefaultScoreType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = true,
		Choices = { "DP","PS","MIGS", "Wife", "Waifu"},
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().global.DefaultScoreType
			if pref == 1 then
				list[1] = true
			elseif pref == 2 then
				list[2] = true
			elseif pref == 3 then
				list[3] = true
			elseif pref == 4 then
				list[4] = true
			else
				list[5] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			if list[1] == true then
				value = 1
			elseif list[2] == true then
				value = 2
			elseif list[3] == true then
				value = 3
			elseif list[4] == true then
				value = 4
			else
				value = 5
			end
			themeConfig:get_data().global.DefaultScoreType = value
			themeConfig:set_dirty()
			themeConfig:save()
		end
	}
	setmetatable( t, t )
	return t
end	

function TipType()
	local t = {
		Name = "TipType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = true,
		Choices = { "Off","Tips","Random Phrases"},
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().global.TipType
			if pref == 1 then
				list[1] = true
			elseif pref == 2 then
				list[2] = true
			else 
				list[3] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			if list[1] == true then
				value = 1
			elseif list[2] == true then
				value = 2
			else
				value = 3
			end;
			themeConfig:get_data().global.TipType = value
			themeConfig:set_dirty()
			themeConfig:save()
		end
	}
	setmetatable( t, t )
	return t
end	

function SongBGEnabled()
	local t = {
		Name = "SongBGEnabled";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Off","On"};
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().global.SongBGEnabled
			if pref then
				list[2] = true
			else 
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			if list[1] then
				value = false
			else
				value = true
			end
			themeConfig:get_data().global.SongBGEnabled = value
			themeConfig:set_dirty()
			themeConfig:save()
		end
	}
	setmetatable( t, t )
	return t
end

function FadeIn()
	local t = {
		Name = "FadeIn";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Off","On"};
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().global.FadeIn
			if pref then
				list[2] = true
			else 
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			if list[1] then
				value = false
			else
				value = true
			end
			themeConfig:get_data().global.FadeIn = value
			themeConfig:set_dirty()
			themeConfig:save()
		end
	}
	setmetatable( t, t )
	return t
end

function SongBGMouseEnabled()
	local t = {
		Name = "SongBGMouseEnabled";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Off","On"};
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().global.SongBGMouseEnabled
			if pref then
				list[2] = true
			else 
				list[1] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			local value
			if list[1] then
				value = false
			else
				value = true
			end;
			themeConfig:get_data().global.SongBGMouseEnabled = value
			themeConfig:set_dirty()
			themeConfig:save()
		end;
	};
	setmetatable( t, t );
	return t;
end	

function EvalBGType()
	local t = {
		Name = "EvalBGType";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Song Background","Clear+Grade Background","Grade Background only"};
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().eval.SongBGType
			if pref == 1 then
				list[1] = true
			elseif pref == 2 then
				list[2] = true
			else 
				list[3] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			local value
			if list[1] == true then
				value = 1
			elseif list[2] == true then
				value = 2
			else
				value = 3
			end;
			themeConfig:get_data().eval.SongBGType = value
			themeConfig:set_dirty()
			themeConfig:save()
		end;
	};
	setmetatable( t, t );
	return t;
end	

function Particles()
	local t = {
		Name = "Particles";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Off","On"};
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().global.Particles
			if pref then
				list[2] = true
			else 
				list[1] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			local value
			if list[1] then
				value = false
			else
				value = true
			end;
			themeConfig:get_data().global.Particles = value
			themeConfig:set_dirty()
			themeConfig:save()
		end;
	};
	setmetatable( t, t );
	return t;
end	


function RateSort()
	local t = {
		Name = "RateSort";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Off","On"};
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().global.RateSort
			if pref then
				list[2] = true
			else 
				list[1] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			local value
			if list[1] then
				value = false
			else
				value = true
			end;
			themeConfig:get_data().global.RateSort = value
			themeConfig:set_dirty()
			themeConfig:save()
		end;
	};
	setmetatable( t, t );
	return t;
end	

function HelpMenu()
	local t = {
		Name = "HelpMenu";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Off","On"};
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().global.HelpMenu
			if pref then
				list[2] = true
			else 
				list[1] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			local value
			if list[1] then
				value = false
			else
				value = true
			end;
			themeConfig:get_data().global.HelpMenu = value
			themeConfig:set_dirty()
			themeConfig:save()
		end;
	};
	setmetatable( t, t );
	return t;
end	

function MeasureLines()
	local t = {
		Name = "MeasureLines";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Off","On"};
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().global.MeasureLines
			if pref then
				list[2] = true
			else 
				list[1] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			local value
			if list[1] then
				value = false
			else
				value = true
			end;
			themeConfig:get_data().global.MeasureLines = value
			themeConfig:set_dirty()
			themeConfig:save()
			THEME:ReloadMetrics()
		end;
	};
	setmetatable( t, t );
	return t;
end

function ProgressBar()
	local t = {
		Name = "ProgressBar",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = true,
		Choices = {"Bottom", "Top"},
		LoadSelections = function(self, list, pn)
			local pref = playerConfig:get_data(pn_to_profile_slot(pn)).ProgressBarPos
			if pref then
				list[pref+1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local value
			if list[1] == true then
				value = 0
				playerConfig:get_data(pn_to_profile_slot(pn)).GameplayXYCoordinates.FullProgressBarY = SCREEN_BOTTOM - 30
			else
				value = 1
				playerConfig:get_data(pn_to_profile_slot(pn)).GameplayXYCoordinates.FullProgressBarY = 20
			end
			playerConfig:get_data(pn_to_profile_slot(pn)).ProgressBarPos = value
			playerConfig:set_dirty(pn_to_profile_slot(pn))
			playerConfig:save(pn_to_profile_slot(pn))
		end
	}
	setmetatable( t, t )
	return t
end



function NPSWindow()
	local t = {
		Name = "NPSWindow";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = {"1","2","3","4","5"};
		LoadSelections = function(self, list, pn)
			local pref = themeConfig:get_data().NPSDisplay.MaxWindow
			if pref then
				list[pref] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			local value
			for k,v in ipairs(list) do
				if v then
					value = k
				end;
			end;
			themeConfig:get_data().NPSDisplay.MaxWindow = value
			themeConfig:set_dirty()
			themeConfig:save()
		end;
	};
	setmetatable( t, t );
	return t;
end


--[[ end option rows ]]
