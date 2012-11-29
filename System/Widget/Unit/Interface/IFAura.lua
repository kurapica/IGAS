-- Author      : Kurapica
-- Create Date : 2012/08/03
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFAura
-- @type Interface
-- @name IFAura
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFAura", version) then
	return
end

_IFAuraUnitList = _IFAuraUnitList or UnitList(_Name)

function _IFAuraUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_AURA")

	self.OnUnitListChanged = nil
end

interface "IFAura"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFAuraUnitList[self] = nil
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFAuraUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFAura(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
	end
endinterface "IFAura"