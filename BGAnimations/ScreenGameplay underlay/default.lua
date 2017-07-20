local t = Def.ActorFrame {};
	t[#t+1] = LoadActor("ScreenFilter");
local modslevel = topscreen  == "ScreenEditOptions" and "ModsLevel_Stage" or "ModsLevel_Preferred"
local playeroptions = GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptions(modslevel)
playeroptions:Mini( 2 - playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).ReceptorSize/50 )
if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	local playeroptions = GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptions(modslevel)
	playeroptions:Mini( 2 - playerConfig:get_data(pn_to_profile_slot(PLAYER_2)).ReceptorSize/50 )
end
return t