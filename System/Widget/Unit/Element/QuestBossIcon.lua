-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.QuestBossIcon", version) then
	return
end

class "QuestBossIcon"
	inherit "Texture"
	extend "IFClassification"

	doc [======[
		@name QuestBossIcon
		@type class
		@desc The quest boss indicator
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function QuestBossIcon(self)
		self.Height = 32
		self.Width = 32
	end
endclass "QuestBossIcon"