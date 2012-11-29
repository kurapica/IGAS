-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- PvpIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name PvpIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.PvpIcon", version) then
	return
end

class "PvpIcon"
	inherit "Texture"
	extend "IFFaction"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function PvpIcon(...)
		local icon = Super(...)

		icon.Height = 16
		icon.Width = 16

		return icon
	end
endclass "PvpIcon"