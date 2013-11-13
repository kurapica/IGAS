-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.ComboPointsPanel", version) then
	return
end

class "ComboPointsPanel"
	inherit "LayoutPanel"
	extend "IFComboPoint"

	doc [======[
		@name ComboPointsPanel
		@type class
		@desc The panel to show the combo points on the target, abandoned
	]======]

	MAX_COMBO_POINTS = _G.MAX_COMBO_POINTS

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- ComboPoints
	property "ComboPoints" {
		Set = function(self, value)
			for i=1, MAX_COMBO_POINTS do
				self["ComboPoint_"..i].Visible = ( i <= value )
			end
		end,
		Type = System.Number,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ComboPointsPanel(self, name, parent, ...)
		Super(self, name, parent, ...)

		local pct = floor(10000 / MAX_COMBO_POINTS)

		for i = 1, MAX_COMBO_POINTS do
			local point = Texture("ComboPoint_"..i, self)

			self:AddWidget(point)

			if i < MAX_COMBO_POINTS then
				self:SetWidgetLeftWidth(point, (i-1)*pct, "pct", pct, "pct")
			else
				self:SetWidgetLeftWidth(point, 100 - (MAX_COMBO_POINTS - 1) * pct, "pct", pct, "pct")
			end

			point.TexturePath = [[Interface\ComboFrame\ComboPoint]]
			point:SetTexCoord(0, 0.375, 0, 1)
		end
	end
endclass "ComboPointsPanel"