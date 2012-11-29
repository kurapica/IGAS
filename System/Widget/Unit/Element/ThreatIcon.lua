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
	function ThreatIcon(name, parent)
		local icon = Super(name, parent)

		icon.TexturePath = [[Interface\Minimap\ObjectIcons]]
		icon:SetTexCoord(1/4, 3/8, 0, 1/4)

		icon.Height = 16
		icon.Width = 16

		return icon
	end
endclass "ThreatIcon"