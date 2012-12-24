-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- QuestBossIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name QuestBossIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.QuestBossIcon", version) then
	return
end

class "QuestBossIcon"
	inherit "Texture"
	extend "IFClassification"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function QuestBossIcon(self)
		self.Height = 32
		self.Width = 32
	end
endclass "QuestBossIcon"