-- Author      : Kurapica
-- Create Date : 2012/07/22
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- TotemBar
-- <br><br>inherit <a href="..\Common\LayoutPanel.html">LayoutPanel</a> For all methods, properties and scriptTypes
-- @name TotemBar
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.TotemBar", version) then
	return
end

class "TotemBar"
	inherit "LayoutPanel"
	extend "IFTotem"

	MAX_TOTEMS = _G.MAX_TOTEMS

	-----------------------------------------------
	--- Totem
	-- @type class
	-- @name Totem
	-----------------------------------------------
	class "Totem"
		inherit "Button"
		extend "IFCooldownIndicator"

		------------------------------------
		--- Custom the indicator
		-- @name SetUpCooldownIndicator
		-- @class function
		-- @param indicator the cooldown object
		------------------------------------
		function SetUpCooldownIndicator(self, indicator)
			indicator:SetPoint("CENTER")
			indicator:SetSize(22, 22)
			indicator.FrameLevel = self.BorderLayer.FrameLevel
		end

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		-- Icon
		property "Icon" {
			Get = function(self)
				return self.IconLayer.Icon.TexturePath
			end,
			Set = function(self, value)
				self.IconLayer.Icon.TexturePath = value
			end,
			Type = System.String + nil,
		}

		local function OnClick(self)
			if self.Slot then
				DestroyTotem(self.Slot)
			end
		end

		local function UpdateTooltip(self)
			self = IGAS:GetWrapper(self)
			if self.Slot then
				IGAS.GameTooltip:SetTotem(self.Slot)
			end
		end

		local function OnEnter(self)
			if self.Visible and self.Slot then
				IGAS.GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
				UpdateTooltip(self)
			end
		end

		local function OnLeave(self)
			IGAS.GameTooltip:Hide()
		end

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function Totem(...)
			local obj = Super(...)

			obj.Visible = false
			obj:SetSize(37, 37)

			obj:RegisterForClicks("RightButtonUp")

			local background = Texture("Background", obj, "BACKGROUND")
			background.TexturePath = [[Interface\Minimap\UI-Minimap-Background]]
			background:SetPoint("CENTER")
			background:SetSize(34, 34)
			background:SetVertexColor(1, 1, 1, 0.6)

			local duration = FontString("Duration", obj, "GameFontNormalSmall")
			duration:SetPoint("TOP", obj, "BOTTOM", 0, 5)

			local iconLayer = Frame("IconLayer", obj)
			iconLayer:SetPoint("CENTER")
			iconLayer:SetSize(22, 22)

			local icon = Texture("Icon", iconLayer, "OVERLAY")
			icon:SetAllPoints()

			local borderLayer = Frame("BorderLayer", obj)
			borderLayer.FrameLevel = borderLayer.FrameLevel + 1
			borderLayer:SetPoint("CENTER")
			borderLayer:SetSize(38, 38)

			local border = Texture("Border", borderLayer, "OVERLAY")
			border.TexturePath = [[Interface\CharacterFrame\TotemBorder]]
			border:SetAllPoints()

			obj.OnClick = obj.OnClick + OnClick

			obj.OnEnter = obj.OnEnter + OnEnter
			obj.OnLeave = obj.OnLeave + OnLeave
			IGAS:GetUI(obj).UpdateTooltip = UpdateTooltip

			return obj
	    end
	endclass "Totem"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function TotemBar(name, parent)
		local panel = Super(name, parent)
		local pct = floor(100 / MAX_TOTEMS)
		local margin = (100 - pct * MAX_TOTEMS) / 2

		panel.FrameStrata = "LOW"
		panel.Toplevel = true
		panel:SetSize(128, 53)

		local btnTotem

		for i = 1, MAX_TOTEMS do
			btnTotem = Totem("Totem"..i, panel)
			btnTotem.ID = i

			panel:AddWidget(btnTotem)

			panel:SetWidgetLeftWidth(btnTotem, margin + (i-1)*pct, "pct", pct, "pct")

			panel[i] = btnTotem
		end

		return panel
	end
endclass "TotemBar"