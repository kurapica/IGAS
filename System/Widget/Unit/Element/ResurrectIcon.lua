-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.ResurrectIcon", version) then
	return
end

class "ResurrectIcon"
	inherit "Texture"
	extend "IFResurrect"

	doc [======[
		@name ResurrectIcon
		@type class
		@desc The resurrect indicator
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ResurrectIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "ResurrectIcon"