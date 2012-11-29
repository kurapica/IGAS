-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- ComboPointsPanel
-- <br><br>inherit <a href="..\Common\LayoutPanel.html">LayoutPanel</a> For all methods, properties and scriptTypes
-- @name ComboPointsPanel
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.ComboPointsPanel", version) then
	return
end

class "ComboPointsPanel"
	inherit "LayoutPanel"
	extend "IFComboPoint"

	MAX_COMBO_POINTS = _G.MAX_COMBO_POINTS

	-----------------------------------------------
	--- ComboPoint
	-- @type class
	-- @name ComboPoint
	-----------------------------------------------
	class "ComboPoint"
		inherit "System.Object"

		------------------------------------------------------
		-- Script
		------------------------------------------------------

		------------------------------------------------------
		-- Method
		------------------------------------------------------

		------------------------------------------------------
		-- Property
		------------------------------------------------------

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function ComboPoint(...)
			local obj = Super(...)

			return obj
	    end
	endclass "ComboPoint"

	------------------------------------------------------
	-- Script
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
	function ComboPointsPanel(name, parent)
		local panel = Super(name, parent)
		local pct = floor(10000 / MAX_COMBO_POINTS)

		for i = 1, MAX_COMBO_POINTS do
			local point = Texture("ComboPoint_"..i, panel)

			panel:AddWidget(point)

			if i < MAX_COMBO_POINTS then
				panel:SetWidgetLeftWidth(point, (i-1)*pct, "pct", pct, "pct")
			else
				panel:SetWidgetLeftWidth(point, 100 - (MAX_COMBO_POINTS - 1) * pct, "pct", pct, "pct")
			end

			point.TexturePath = [[Interface\ComboFrame\ComboPoint]]
			point:SetTexCoord(0, 0.375, 0, 1)
		end

		return panel
	end
endclass "ComboPointsPanel"