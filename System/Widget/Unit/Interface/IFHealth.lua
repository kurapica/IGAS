-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFHealth
-- @type Interface
-- @name IFHealth
-- @need property MinMax : 	MinMaxValue
-- @need property Number : 	Value
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFHealth", version) then
	return
end

_IFHealthUnitList = _IFHealthUnitList or UnitList(_Name)

_MinMax = MinMax(0, 1)

function _IFHealthUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_MAXHEALTH")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self.OnUnitListChanged = nil
end

function _IFHealthUnitList:ParseEvent(event, unit)
	if not self:HasUnit(unit) and event ~= "PLAYER_ENTERING_WORLD" then return end

	if event == "UNIT_HEALTH" then
		if UnitIsConnected(unit) then
			self:EachK(unit, "Value", UnitHealth(unit))
		else
			self:EachK(unit, "Value", UnitHealthMax(unit))
		end
	elseif event == "UNIT_MAXHEALTH" then
		_MinMax.max = UnitHealthMax(unit)
		self:EachK(unit, "MinMaxValue", _MinMax)
		self:EachK(unit, "Value", UnitHealth(unit))
	elseif event == "PLAYER_ENTERING_WORLD" then
		for unit in pairs(self) do
			self:EachK(unit, "Refresh")
		end
	end
end

interface "IFHealth"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFHealthUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self.Unit then
			_MinMax.max = UnitHealthMax(self.Unit)
			self.MinMaxValue = _MinMax
			self.Value = UnitHealth(self.Unit)
		else
			self.Value = 0
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFHealthUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFHealth(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		-- Default Texture
		if self:IsClass(StatusBar) and not self.StatusBarTexture then
			self.StatusBarTexturePath = [[Interface\TargetingFrame\UI-StatusBar]]
			self.StatusBarColor = ColorType(0, 1, 0)
		end

		self.MouseEnabled = false
	end
endinterface "IFHealth"