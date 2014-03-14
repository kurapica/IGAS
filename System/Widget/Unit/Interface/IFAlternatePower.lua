-- Author      : Kurapica
-- Create Date : 2012/08/06
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFAlternatePower", version) then
	return
end

ALTERNATE_POWER_INDEX = _G.ALTERNATE_POWER_INDEX
ALT_POWER_TYPE_COUNTER = _G.ALT_POWER_TYPE_COUNTER

_IFAlternatePowerUnitList = _IFAlternatePowerUnitList or UnitList(_Name)

function _IFAlternatePowerUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_MAXPOWER")
	self:RegisterEvent("UNIT_POWER")
	self:RegisterEvent("UNIT_POWER_BAR_SHOW")
	self:RegisterEvent("UNIT_POWER_BAR_HIDE")
	self.OnUnitListChanged = nil
end

function _IFAlternatePowerUnitList:ParseEvent(event, unit, powerType)
	if event == "UNIT_POWER_BAR_SHOW" or event == "UNIT_POWER_BAR_HIDE" then
		self:EachK(unit, UpdateBar)
	elseif event == "UNIT_MAXPOWER" and powerType == "ALTERNATE" then
		self:EachK(unit, "MinMaxValue", MinMax(select(2, UnitAlternatePowerInfo(unit)), UnitPowerMax(unit, ALTERNATE_POWER_INDEX)))
	elseif event == "UNIT_POWER" and powerType == "ALTERNATE" then
		self:EachK(unit, "Value", UnitPower(unit, ALTERNATE_POWER_INDEX))
	end
end

function UpdateBar(self)
	local barType, minPower, _, _, _, hideFromOthers = self.Unit and UnitAlternatePowerInfo(self.Unit)
	if ( barType and (not hideFromOthers or self.Unit == "player") ) then
		local currentPower = UnitPower(self.Unit, ALTERNATE_POWER_INDEX)
		local maxPower = UnitPowerMax(self.Unit, ALTERNATE_POWER_INDEX)

		self.BarType = barType
		self.MinMaxValue = Minmax(minPower, maxPower)
		self.Value = currentPower
		self.Visible = true
	else
		self.Visible = false
	end
end

__Doc__[[
	<desc>IFAlternatePower is used to handle the unit alternate power's update</desc>
	<optional name="BarType" type="property" valuetype="string">the alternate power bar's type</optional>
	<optional name="MinMaxValue" type="property" valuetype="MinMax">the min and max power value</optional>
	<optional name="Value" type="property" valuetype="number">the alternate power's value</optional>
	<optional name="Visible" type="property" valuetype="boolean">the alternate power bar's visible</optional>
]]
interface "IFAlternatePower"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	__Doc__[[The default refresh method, overridable]]
	function Refresh(self)
		return UpdateBar(self)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFAlternatePowerUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFAlternatePowerUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFAlternatePower(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
	end
endinterface "IFAlternatePower"