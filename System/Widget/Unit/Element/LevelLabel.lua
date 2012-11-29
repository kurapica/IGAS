-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- LevelLabel
-- <br><br>inherit <a href="..\Base\FontString.html">Texture</a> For all methods, properties and scriptTypes
-- @name LevelLabel
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.LevelLabel", version) then
	return
end

class "LevelLabel"
	inherit "FontString"
	extend "IFUnitLevel"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function LevelLabel(...)
		local label = Super(...)

		label.DrawLayer = "BORDER"

		return label
	end
endclass "LevelLabel"