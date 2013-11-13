-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.RestingIcon", version) then
	return
end

class "RestingIcon"
	inherit "Texture"
	extend "IFResting"

	doc [======[
		@name RestingIcon
		@type class
		@desc The resting indicator
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function RestingIcon(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.Height = 16
		self.Width = 16
	end
endclass "RestingIcon"