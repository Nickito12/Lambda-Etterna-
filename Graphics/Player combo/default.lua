local c
local player = Var "Player"
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")
local Pulse = THEME:GetMetric("Combo", "PulseCommand")
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand")

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom")
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom")
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt")

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom")
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom")

local t =
	Def.ActorFrame {
	InitCommand = function(self)
		self:vertalign(bottom)
	end,
	LoadFont("Combo", "numbers") ..
		{
			Name = "Number",
			OnCommand = THEME:GetMetric("Combo", "NumberOnCommand")
		},
	LoadFont("_roboto condensed Bold italic 24px") ..
		{
			Name = "Label",
			OnCommand = THEME:GetMetric("Combo", "LabelOnCommand")
		},
	InitCommand = function(self)
		-- We'll have to deal with this later
		--self:draworder(notefield_draw_order.over_field)
		c = self:GetChildren()
		c.Number:visible(false)
		c.Label:visible(false)
	end,
	-- Milestones:
	-- 25,50,100,250,600 Multiples;
	--[[ 		if (iCombo % 100) == 0 then
			c.OneHundredMilestone:playcommand("Milestone");
		elseif (iCombo % 250) == 0 then
			-- It should really be 1000 but thats slightly unattainable, since
			-- combo doesnt save over now.
			c.OneThousandMilestone:playcommand("Milestone");
		else
			return
		end; --]]
	TwentyFiveMilestoneCommand = function(self, parent)
		self:skewy(-0.125):decelerate(0.325):skewy(0)
	end,
	ToastyAchievedMessageCommand = function(self, params)
		if params.PlayerNumber == player then
			self:thump(2):effectclock("beat")
		end
	end,
	ComboCommand = function(self, param)
		local iCombo = param.Misses or param.Combo
		if not iCombo or iCombo < ShowComboAt then
			c.Number:visible(false)
			c.Label:visible(false)
			return
		end

		local labeltext = ""
		if param.Combo then
			-- 			c.Number:playcommand("Reset");
			labeltext = "COMBO"
		else
			-- 			c.Number:playcommand("Miss");
			labeltext = "MISSES"
		end
		c.Label:settext(labeltext)
		c.Label:visible(false)

		param.Zoom = scale(iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom)
		param.Zoom = clamp(param.Zoom, NumberMinZoom, NumberMaxZoom)

		param.LabelZoom = scale(iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom)
		param.LabelZoom = clamp(param.LabelZoom, LabelMinZoom, LabelMaxZoom)

		c.Number:visible(true)
		c.Label:visible(true)
		c.Number:settext(string.format("%i", iCombo))
		-- FullCombo Rewards
		if param.FullComboW1 then
			c.Number:diffuse(color("#00aeef"))
			c.Number:glowshift()
		elseif param.FullComboW2 then
			c.Number:diffuse(color("#F3D58D"))
			c.Number:glowshift()
		elseif param.FullComboW3 then
			c.Number:diffuse(color("#94D658"))
			c.Number:stopeffect()
		elseif param.Combo then
			c.Number:diffuse(color("#FBE9DD"))
			-- 			c.Number:diffuse(PlayerColor(player));
			c.Number:stopeffect()
			c.Label:diffuse(color("#F5CB92")):diffusebottomedge(color("#EFA97A")):strokecolor(color("#965A47"))
		else
			c.Number:diffuse(color("#FBE9DD"))
			c.Number:stopeffect()
			c.Label:diffuse(color("#F5CB92")):diffusebottomedge(color("#EFA97A")):strokecolor(color("#965A47"))
		end
		-- Pulse
		Pulse(c.Number, param)
		PulseLabel(c.Label, param)
		-- Milestone Logic
	end
	--[[ 	ScoreChangedMessageCommand=function(self,param)
		local iToastyCombo = param.ToastyCombo;
		if iToastyCombo and (iToastyCombo > 0) then
-- 			(cmd(thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number)
-- 			(cmd(thump;effectmagnitude,1,1.2,1;effectclock,'beat'))(c.Number)
		else
-- 			c.Number:stopeffect();
		end;
	end; --]]
}

return t
