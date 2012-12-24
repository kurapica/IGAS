-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- ThreatIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name ThreatIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.ThreatIcon", version) then
	return
end

class "ThreatIcon"
	inherit "Texture"
	extend "IFThreat"

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
	function ThreatIcon(self)
		self.TexturePath = [[Interface\Minimap\ObjectIcons]]
		self:SetTexCoord(1/4, 3/8, 0, 1/4)

		self.Height = 16
		self.Width = 16
	end
endclass "ThreatIcon"