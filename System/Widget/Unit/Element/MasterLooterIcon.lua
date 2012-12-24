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
	function MasterLooterIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "MasterLooterIcon"