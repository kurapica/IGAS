-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- LeaderIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name LeaderIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.LeaderIcon", version) then
	return
end

class "LeaderIcon"
	inherit "Texture"
	extend "IFLeader"
	
	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function LeaderIcon(...)
		local icon = Super(...)

		icon.Height = 16
		icon.Width = 16

		return icon
	end
endclass "LeaderIcon"