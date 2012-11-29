-- Author      : Kurapica
-- Create Date : 2012/07/14
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFComboPoint
-- @type Interface
-- @name IFComboPoint
-- @need property Number : Value
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFComboPoint", version) then
	return
end

_All = "all"
_IFComboPointUnitList = _IFComboPointUnitList or UnitList(_Name)

function _IFComboPointUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_COMBO_POINTS")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")

	self.OnUnitListChanged = nil
end

function _IFComboPointUnitList:ParseEvent(event, unit)
	if unit == 'pet' then return end

	self:EachK(_All, "Value", GetComboPoint())
end

function GetComboPoint()
	if(UnitHasVehicleUI'player') then
		return GetComboPoints('vehicle', 'target')
	else
		return GetComboPoints('player', 'target')
	end

	return 0
end

interface "IFComboPoint"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFComboPointUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		self.Value = GetComboPoint()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFComboPoint(self)
		_IFComboPointUnitList[self] = _All
	end
endinterface "IFComboPoint"