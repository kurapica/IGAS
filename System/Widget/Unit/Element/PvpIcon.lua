-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.PvpIcon", version) then
	return
end

class "PvpIcon"
	inherit "Texture"
	extend "IFFaction"

	doc [======[
		@name PvpIcon
		@type class
		@desc The pvp indicator
	]======]

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		local unit = self.Unit
		if unit and UnitIsPVPFreeForAll(unit) then
			self.TexturePath = [[Interface\TargetingFrame\UI-PVP-FFA]]
			self.Visible = true
		elseif unit and UnitIsPVP(unit) and (select(1, UnitFactionGroup(self.Unit))) then
			self.TexturePath = [[Interface\TargetingFrame\UI-PVP-]]..(select(1, UnitFactionGroup(self.Unit)))
			self.Visible = true
		else
			self.Visible = false
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function PvpIcon(self)
		self.Height = 64
		self.Width = 64
	end
endclass "PvpIcon"