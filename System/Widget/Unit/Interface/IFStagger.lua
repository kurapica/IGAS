-- Author      : Kurapica
-- Create Date : 2013/03/09
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFStagger", version) then
	return
end

_IFStaggerUnitList = _IFStaggerUnitList or UnitList(_Name)

_MinMax = MinMax(0, 1)

SPEC_MONK_BREWMASTER = _G.SPEC_MONK_BREWMASTER

function _IFStaggerUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_DISPLAYPOWER")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

	self.OnUnitListChanged = nil
end

function _IFStaggerUnitList:ParseEvent(event, unit, type)
	if unit and unit ~= "player" then return end

	if event == "UNIT_POWER" then
		self:EachK("player", "Value", UnitPower(unit, SPELL_POWER_MANA))
	elseif event == "UNIT_MAXPOWER" then
		_MinMax.max = UnitPowerMax("player", SPELL_POWER_MANA)
		self:EachK("player", "MinMaxValue", _MinMax)
		self:EachK("player", "Value", UnitPower(unit, SPELL_POWER_MANA))
	else
		self:EachK("player", "Refresh")
	end
end

interface "IFStagger"
	extend "IFUnitElement"

	doc [======[
		@name IFStagger
		@type interface
		@desc IFStagger is used to handle the unit's stagger
		@overridable MinMaxValue property, System.Widget.MinMax, used to receive the min and max value of the mana
		@overridable Value property, number, used to receive the mana's value
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
		if not _M._UseStagger or not self.Existed then return end

		if UnitPowerType('player') == SPELL_POWER_MANA or (select(2, UnitClass('player')) == 'MONK' and GetSpecialization() ~= 2) then
			return self:Hide()
		else
			self:Show()
		end

		local min, max = UnitPower(self.Unit, SPELL_POWER_MANA), UnitPowerMax(self.Unit, SPELL_POWER_MANA)

		_MinMax.max = max
		self.MinMaxValue = _MinMax

		self.Value = min
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFStaggerUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFStaggerUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFStagger(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
		self.MouseEnabled = false
	end
endinterface "IFStagger"