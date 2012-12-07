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

		_Border = {
		    edgeFile = [[Interface\ChatFrame\CHATFRAMEBACKGROUND]],
		    edgeSize = 2,
		}

		_BorderColor = ColorType(0, 0, 0)

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		-- Icon
		property "Icon" {
			Get = function(self)
				return self:GetChild("Icon").TexturePath
			end,
			Set = function(self, value)
				self:GetChild("Icon").TexturePath = value
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
			obj:SetSize(36, 36)

			obj:RegisterForClicks("RightButtonUp")

			local icon = Texture("Icon", obj, "BACKGROUND")
			icon:SetPoint("TOPLEFT", 1, -1)
			icon:SetPoint("BOTTOMRIGHT", -1, 1)

			obj.Backdrop = _Border
			obj.BackdropBorderColor = _G.RAID_CLASS_COLORS[select(2, UnitClass("player"))]

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
		panel:SetSize(108, 24)

		local btnTotem

		for i = 1, MAX_TOTEMS do
			btnTotem = Totem("Totem"..i, panel)
			btnTotem.ID = i

			panel:AddWidget(btnTotem)

			panel:SetWidgetLeftWidth(btnTotem, margin + (i-1)*pct, "pct", pct-1, "pct")

			panel[i] = btnTotem
		end

		return panel
	end
endclass "TotemBar"