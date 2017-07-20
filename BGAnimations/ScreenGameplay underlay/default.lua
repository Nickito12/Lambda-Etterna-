local t = Def.ActorFrame {};
	t[#t+1] = LoadActor("ScreenFilter");
local modslevel = topscreen  == "ScreenEditOptions" and "ModsLevel_Stage" or "ModsLevel_Preferred"
local playeroptions = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions(modslevel)
playeroptions:Mini( 2 - getenv("ReceptorSize"..ToEnumShortString(PLAYER_1))/50 )
if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local playeroptions = GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions(modslevel)
	playeroptions:Mini( 2 - getenv("ReceptorSize"..ToEnumShortString(PLAYER_2))/50 )
end
return t