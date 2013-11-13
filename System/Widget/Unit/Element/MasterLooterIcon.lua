-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.MasterLooterIcon", version) then
	return
end

class "MasterLooterIcon"
	inherit "Texture"
	extend "IFGroupLoot"

	doc [======[
		@name MasterLooterIcon
		@type class
		@desc The master looter indicator
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function MasterLooterIcon(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Height = 16
		self.Width = 16
	end
endclass "MasterLooterIcon"