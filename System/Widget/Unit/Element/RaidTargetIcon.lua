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
	function RaidTargetIcon(...)
		local icon = Super(...)

		icon.Height = 16
		icon.Width = 16

		return icon
	end
endclass "RaidTargetIcon"