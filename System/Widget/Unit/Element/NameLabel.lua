-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- NameLabel
-- <br><br>inherit <a href="..\Base\FontString.html">Texture</a> For all methods, properties and scriptTypes
-- @name NameLabel
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.NameLabel", version) then
	return
end

class "NameLabel"
	inherit "FontString"
	extend "IFUnitName"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function NameLabel(...)
		local label = Super(...)

		label.DrawLayer = "BORDER"

		return label
	end
endclass "NameLabel"