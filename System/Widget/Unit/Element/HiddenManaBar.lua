-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- HiddenManaBar
-- <br><br>inherit <a href="..\Base\StatusBar.html">StatusBar</a> For all methods, properties and scriptTypes
-- @name HiddenManaBar
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.HiddenManaBar", version) then
	return
end

class "HiddenManaBar"
	inherit "StatusBar"
	extend "IFMana"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function HiddenManaBar(self)
		self.FrameStrata = "LOW"
	end
endclass "HiddenManaBar"
