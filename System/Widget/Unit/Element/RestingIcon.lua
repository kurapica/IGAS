-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- RestingIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name RestingIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.RestingIcon", version) then
	return
end

class "RestingIcon"
	inherit "Texture"
	extend "IFResting"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function RestingIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "RestingIcon"