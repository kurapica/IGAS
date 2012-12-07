-- Author      : Kurapica
-- Create Date : 2012/07/14
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFComboPoint
-- @type Interface
-- @name IFComboPoint
-- @need property Number : Value
-- @need property Boolean : Visible
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFComboPoint", version) then
	return
end

_All = "all"
_IFComboPointUnitList = _IFComboPointUnitList or UnitList(_Name)

CAT_FORM = _G.CAT_FORM

function _IFComboPointUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_COMBO_POINTS")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self.OnUnitListChanged = nil
end

function _IFComboPointUnitList:ParseEvent(event, unit)
	if event == "UNIT_COMBO_POINTS" or event == "PLAYER_TARGET_CHANGED" then
		if unit == 'pet' then return end

		self:EachK(_All, "Value", GetComboPoint())
	else
		self:EachK(_All, "Visible", CheckVisible())
		self:EachK(_All, "Value", GetComboPoint())
	end
end

function GetComboPoint()
	if(UnitHasVehicleUI'player') then
		return GetComboPoints('vehicle', 'target')
	else
		return GetComboPoints('player', 'target')
	end

	return 0
end

function CheckVisible()
	if select(2, UnitClass("player")) == "ROGUE" then
		return true
	elseif select(2, UnitClass("player")) == "DRUID" then
		return GetShapeshiftFormID() == CAT_FORM
	end
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
		self.Visible = CheckVisible()
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
		if select(2, UnitClass("player")) == "ROGUE" or select(2, UnitClass("player")) == "DRUID" then
			_IFComboPointUnitList[self] = _All
		end
	end
endinterface "IFComboPoint"