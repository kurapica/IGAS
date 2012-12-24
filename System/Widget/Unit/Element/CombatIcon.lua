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
	function CombatIcon(self)
		self.Height = 32
		self.Width = 32
	end
endclass "CombatIcon"