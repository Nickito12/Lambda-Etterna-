return Def.ActorFrame {
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong(); 
		if song then
-- 			self:setaux(0);
			self:finishtweening();
			self:decelerate(0.3):zoomx(1):diffusealpha(1)
		elseif not song and self:GetZoomX() == 1 then
-- 			self:setaux(1);
			self:finishtweening();
			self:decelerate(0.3):zoomx(0):diffusealpha(0)
		end;
	end;
	Def.StepsDisplayList {
		Name="StepsDisplayListRow";
		OnCommand=function(self)
		self:diffusealpha(0):zoomx(0):decelerate(0.4):zoomx(1):diffusealpha(1)
		end;
		OffCommand=function(self)
		self:decelerate(0.3):zoomx(0):diffusealpha(0)
		end;
		CursorP1 = Def.ActorFrame {
			InitCommand=function(self)
				self:x(-170):player(PLAYER_1)
			end;
			PlayerJoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_1 then
					self:visible(true);
					self:zoom(0):bounceend(1):zoom(1);
				end;
			end;
			PlayerUnjoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_1 then
					self:visible(true);
					self:bouncebegin(1):zoom(0);
				end;
			end;
			LoadActor(THEME:GetPathG("_StepsDisplayListRow","Cursor")) .. {
				InitCommand=function(self)
					self:diffuse(ColorLightTone(PlayerColor(PLAYER_1))):x(8):zoom(0.75)
				end;
			};
		};
		CursorP2 = Def.ActorFrame {
			InitCommand=function(self)
				self:x(170):player(PLAYER_2)
			end;
			PlayerJoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_2 then
					self:visible(true);
					self:zoom(0):bounceend(1):zoom(1);
				end;
			end;
			PlayerUnjoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_2 then
					self:visible(true);
					self:bouncebegin(1):zoom(0);
				end;
			end;
			LoadActor(THEME:GetPathG("_StepsDisplayListRow","Cursor")) .. {
				InitCommand=function(self)
					self:diffuse(ColorLightTone(PlayerColor(PLAYER_2))):x(-8):zoom(0.75):zoomx(-0.75)
				end;
			};
		};
		CursorP1Frame = Def.Actor{
			ChangeCommand=function(self)
				self:stoptweening():decelerate(0.05)
			end;
		};
		CursorP2Frame = Def.Actor{
			ChangeCommand=function(self)
				self:stoptweening():decelerate(0.05)
			end;
		};
	};
};