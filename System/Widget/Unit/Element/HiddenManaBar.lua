-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.HiddenManaBar", version) then
	return
end

class "HiddenManaBar"
	inherit "StatusBar"
	extend "IFMana"

	doc [======[
		@name HiddenManaBar
		@type class
		@desc The mana bar shown for druid and monk when the unit's power type is not mana
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function HiddenManaBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.FrameStrata = "LOW"
	end
endclass "HiddenManaBar"
