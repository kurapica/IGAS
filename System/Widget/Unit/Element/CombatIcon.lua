-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- CombatIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name CombatIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.CombatIcon", version) then
	return
end

class "CombatIcon"
	inherit "Texture"
	extend "IFCombat"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function CombatIcon(...)
		local icon = Super(...)

		icon.Height = 32
		icon.Width = 32

		return icon
	end
endclass "CombatIcon"