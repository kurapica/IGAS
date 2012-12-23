-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- ResurrectIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name ResurrectIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.ResurrectIcon", version) then
	return
end

class "ResurrectIcon"
	inherit "Texture"
	extend "IFResurrect"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ResurrectIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "ResurrectIcon"