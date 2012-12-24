-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFCombat
-- @type Interface
-- @name IFCombat
-- @need property Boolean :	Visible
----------------------------------------------------------------------------------------------------------------------------------------

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

	_IFCombatUnitList = _IFCombatUnitList

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFCombatUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
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