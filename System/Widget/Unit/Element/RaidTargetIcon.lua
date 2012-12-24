-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- RaidTargetIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name RaidTargetIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.RaidTargetIcon", version) then
	return
end

class "RaidTargetIcon"
	inherit "Texture"
	extend "IFRaidTarget"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function RaidTargetIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "RaidTargetIcon"