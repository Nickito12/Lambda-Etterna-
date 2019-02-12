return Def.ActorFrame{
	-- "header"
	Def.Quad {
		InitCommand=function(self)
			self:vertalign(top):x(_screen.cx):zoomto(_screen.w,96)
		end,
		OnCommand=function(self)
			self:diffuse(ScreenColor("Default")):diffusetopedge(ColorDarkTone(ScreenColor("Default"))):diffusealpha(0.8)
		end
	},
	-- The "header's" "shadow"
	Def.Quad {
		InitCommand=function(self)
			self:vertalign(top):x(_screen.cx):zoomto(SCREEN_WIDTH,8):y(96)
		end,
		OnCommand=function(self)
			self:diffuse(Color("Black")):fadebottom(1):diffusealpha(0.6)
		end
	},
	-- "footer"
	Def.Quad {
		InitCommand=function(self)
			self:vertalign(bottom):x(_screen.cx):y(_screen.h):zoomto(_screen.w,96)
		end,
		OnCommand=function(self)
			self:diffuse(ScreenColor("Default")):diffusebottomedge(ColorDarkTone(ScreenColor("Default"))):diffusealpha(0.8)
		end
	},
	-- The "footer's" "shadow"
	Def.Quad {
		InitCommand=function(self)
			self:vertalign(bottom):x(_screen.cx):y(_screen.h-96):zoomto(_screen.w,8)
		end,
		OnCommand=function(self)
			self:diffuse(Color("Black")):fadetop(1):diffusealpha(0.6)
		end
	},
	
	-- A temporary frame for the jacket.
	Def.Quad {
			diffuse,ColorDarkTone(ScreenColor("Default"));diffusealpha,0.9)
	},
	-- Jacket (real or not) of the currently playing song.
	-- todo: make getting the jacket a bit more of a... global function?
	Def.Sprite {
		InitCommand=function(self)
			self:horizalign(right):vertalign(bottom):x(_screen.w-49):y(_screen.h-24)
		end,
		OnCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song and song:HasJacket() then
				-- ...The jacket on ScreenEditMenu overlay uses LoadBanner instead of just Load.
				-- Will it make any difference? ... I mean, probably not, but we'll see.
				self:LoadBanner(song:GetJacketPath())
			elseif song and song:HasBackground() then
				self:LoadBanner(song:GetBackgroundPath())
			else
				self:LoadBanner(THEME:GetPathG("Common","fallback background"))
			end
			self:scaletoclipped(172,172)
		end
	},
	-- Song title.
	Def.BitmapText {
		Font = "Common Fallback Font",
		InitCommand=function(self)
			self:horizalign(right):x(_screen.w-250):y(_screen.h-64):strokecolor(color("#42292E"))
		end,
		OnCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song then
				self:settext(song:GetDisplayFullTitle())
			else
				self:settext("")
			end
		end
	},
	-- Song artist.
	Def.BitmapText {
		Font = "Common Fallback Font",
		InitCommand=function(self)
			self:horizalign(right):x(_screen.w-250):y(_screen.h-40):zoom(0.7):strokecolor(color("#42292E"))
		end,
		OnCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			if song then
				self:settext(song:GetDisplayArtist())
			else
				self:settext("")
			end
		end
	},
	
	-- Demo-only playaround "gimmick" things, for very bored passerbys.
	-- todo: enable the ability to disable it?
	LoadActor(THEME:GetPathB("","_Demo effects"))
}