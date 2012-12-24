-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- ReadyCheckIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name ReadyCheckIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.ReadyCheckIcon", version) then
	return
end

class "ReadyCheckIcon"
	inherit "Texture"
	extend "IFReadyCheck"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ReadyCheckIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "ReadyCheckIcon"