-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- MasterLooterIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name MasterLooterIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.MasterLooterIcon", version) then
	return
end

class "MasterLooterIcon"
	inherit "Texture"
	extend "IFGroupLoot"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function MasterLooterIcon(...)
		local icon = Super(...)

		icon.Height = 16
		icon.Width = 16

		return icon
	end
endclass "MasterLooterIcon"