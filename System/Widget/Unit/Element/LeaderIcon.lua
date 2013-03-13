-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.LeaderIcon", version) then
	return
end

class "LeaderIcon"
	inherit "Texture"
	extend "IFLeader"

	doc [======[
		@name LeaderIcon
		@type class
		@desc The leader indicator
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function LeaderIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "LeaderIcon"