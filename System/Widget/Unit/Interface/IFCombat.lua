-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFCombat", version) then
	return
end

_IFCombatUnitList = _IFCombatUnitList or UnitList(_Name)

function _IFCombatUnitList:OnUnitListChanged()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	self.OnUnitListChanged = nil
end

function _IFCombatUnitList:ParseEvent(event, unit)
	self:EachK("player", "Refresh")
end

interface "IFCombat"
	extend "IFUnitElement"

	doc [======[
		@name IFCombat
		@type interface
		@desc IFCombat is used to check whether the player is in the combat
		@overridable Visible property, boolean, which used to receive the check result
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Refresh
		@type method
		@desc The default refresh method, overridable
		@return nil
	]======]
	function Refresh(self)
		self.Visible = self.Unit == 'player' and UnitAffectingCombat('player')
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFCombatUnitList[self] = self.Unit
		Refresh(self)
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFCombatUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFCombat(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		-- Default Texture
		if self:IsClass(Texture) then
			if not self.TexturePath and not self.Color then
				self.TexturePath = [[Interface\CharacterFrame\UI-StateIcon]]
				self:SetTexCoord(.5, 1, 0, .49)
			end
		end
	end
endinterface "IFCombat"