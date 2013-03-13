-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.RaidTargetIcon", version) then
	return
end

class "RaidTargetIcon"
	inherit "Texture"
	extend "IFRaidTarget"

	doc [======[
		@name RaidTargetIcon
		@type class
		@desc The raid target indicator
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function RaidTargetIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "RaidTargetIcon"