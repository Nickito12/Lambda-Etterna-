local t = Def.ActorFrame {}

t[#t + 1] = LoadActor("_cursor")
t[#t + 1] = LoadActor("_mousewheelscroll")
t[#t + 1] = LoadActor("_mouseselect")
-- Sort order
t[#t + 1] =
    Def.ActorFrame {
    InitCommand = function(self)
        self:x(SCREEN_RIGHT - 290):y(SCREEN_TOP + 49)
    end,
    OffCommand = function(self)
        self:linear(0.3):diffusealpha(0)
    end,
    LoadActor(THEME:GetPathG("", "_sortFrame")) ..
        {
            InitCommand = function(self)
                self:diffusealpha(0.9):zoom(1.5)
            end,
            OnCommand = function(self)
                self:diffuse(ScreenColor(SCREENMAN:GetTopScreen():GetName()))
            end
        },
    LoadFont("Common Condensed") ..
        {
            InitCommand = function(self)
                self:zoom(1):diffuse(color("#FFFFFF")):diffusealpha(0.85):horizalign(left):addx(-115)
            end,
            OnCommand = function(self)
                self:queuecommand("Set")
            end,
            ChangedLanguageDisplayMessageCommand = function(self)
                self:queuecommand("Set")
            end,
            SetCommand = function(self)
                self:settext("SORT:")
                self:queuecommand("Refresh")
            end
        },
    LoadFont("Common Condensed") ..
        {
            InitCommand = function(self)
                self:zoom(1):maxwidth(SCREEN_WIDTH):addx(115):diffuse(color("#FFFFFF")):uppercase(true):horizalign(
                    right
                )
            end,
            OnCommand = function(self)
                self:queuecommand("Set")
            end,
            SortOrderChangedMessageCommand = function(self)
                self:queuecommand("Set")
            end,
            ChangedLanguageDisplayMessageCommand = function(self)
                self:queuecommand("Set")
            end,
            SetCommand = function(self)
                local sortorder = GAMESTATE:GetSortOrder()
                if sortorder then
                    self:finishtweening()
                    self:smooth(0.4)
                    self:diffusealpha(0)
                    self:settext(SortOrderToLocalizedString(sortorder))
                    self:queuecommand("Refresh"):stoptweening():diffusealpha(0):smooth(0.3):diffusealpha(1)
                else
                    self:settext("")
                    self:queuecommand("Refresh")
                end
            end
        },
    LoadFont("Common Condensed") ..
        {
            InitCommand = function(self)
                self:zoom(1):maxwidth(SCREEN_WIDTH):addx(-750):addy(SCREEN_HEIGHT - 70):diffuse(color("#FFFFFF"))
            end,
            OnCommand = function(self)
                self:queuecommand("Set")
            end,
            SortOrderChangedMessageCommand = function(self)
                self:queuecommand("Set")
            end,
            ChangedLanguageDisplayMessageCommand = function(self)
                self:queuecommand("Set")
            end,
            SetCommand = function(self)
                profile = GetPlayerOrMachineProfile(PLAYER_1)
                playerRating = profile:GetPlayerRating()
                self:settextf("Rating: %5.2f", playerRating)
            end
        },
    LoadFont("Common Condensed") ..
        {
            InitCommand = function(self)
                self:addx(-500):addy(SCREEN_HEIGHT - 70):halign(0.5):zoom(1):shadowlength(1)
            end,
            OnCommand = function(self)
                self:queuecommand("Set")
            end,
            SetCommand = function(self)
                self:settext("Ctrl+S to search")
            end
        }
}

return t
