-- Author      : Kurapica
-- Create Date : 2012/08/06
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFMyHealPrediction
-- @type Interface
-- @name IFMyHealPrediction
-- @need property Number : Value
-- @need property MinMax : MinMaxValue
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------
--- IFAllHealPrediction
-- @type Interface
-- @name IFAllHealPrediction
-- @need property Number : Value
-- @need property MinMax : MinMaxValue
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFHealPrediction", version) then
	return
end

_IFMyHealPredictionUnitList = _IFMyHealPredictionUnitList or UnitList(_Name.."My")
_IFAllHealPredictionUnitList = _IFAllHealPredictionUnitList or UnitList(_Name.."All")
_IFHealPredictionUnitMaxHealthCache = _IFHealPredictionUnitMaxHealthCache or {}

_MinMax = MinMax(0, 1)

function _IFMyHealPredictionUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_HEAL_PREDICTION")
	self:RegisterEvent("UNIT_MAXHEALTH")
	self:RegisterEvent("UNIT_HEALTH")

	self.OnUnitListChanged = nil
end

function _IFAllHealPredictionUnitList:OnUnitListChanged()
	_IFMyHealPredictionUnitList:RegisterEvent("UNIT_HEAL_PREDICTION")
	_IFMyHealPredictionUnitList:RegisterEvent("UNIT_MAXHEALTH")
	_IFMyHealPredictionUnitList:RegisterEvent("UNIT_HEALTH")

	self.OnUnitListChanged = nil
end

MAX_INCOMING_HEAL_OVERFLOW = 1

function _IFMyHealPredictionUnitList:ParseEvent(event, unit)
	if _IFMyHealPredictionUnitList:HasUnit(unit) or _IFAllHealPredictionUnitList:HasUnit(unit) then
		if event == "UNIT_HEAL_PREDICTION" or event == "UNIT_HEALTH" then
			local myIncomingHeal = UnitGetIncomingHeals(unit, "player") or 0
			local allIncomingHeal = UnitGetIncomingHeals(unit) or 0

			local health = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)

			if _IFHealPredictionUnitMaxHealthCache[unit] ~= maxHealth then
				_MinMax.max = maxHealth
				_IFHealPredictionUnitMaxHealthCache[unit] = maxHealth
				_IFMyHealPredictionUnitList:EachK(unit, "MinMaxValue", _MinMax)
				_IFAllHealPredictionUnitList:EachK(unit, "MinMaxValue", _MinMax)
			end

			--See how far we're going over.
			if ( health + allIncomingHeal > maxHealth * MAX_INCOMING_HEAL_OVERFLOW ) then
				allIncomingHeal = maxHealth * MAX_INCOMING_HEAL_OVERFLOW - health
			end

			--Transfer my incoming heals out of the allIncomingHeal
			if ( allIncomingHeal < myIncomingHeal ) then
				myIncomingHeal = allIncomingHeal
				allIncomingHeal = 0
			else
				allIncomingHeal = allIncomingHeal - myIncomingHeal
			end

			_IFMyHealPredictionUnitList:EachK(unit, "Value", myIncomingHeal)
			_IFAllHealPredictionUnitList:EachK(unit, "Value", allIncomingHeal)
		elseif event == "UNIT_MAXHEALTH" then
			_MinMax.max = UnitHealthMax(unit)
			_IFHealPredictionUnitMaxHealthCache[unit] = _MinMax.max
			_IFMyHealPredictionUnitList:EachK(unit, "MinMaxValue", _MinMax)
			_IFAllHealPredictionUnitList:EachK(unit, "MinMaxValue", _MinMax)
		end
	end
end

interface "IFMyHealPrediction"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFMyHealPredictionUnitList[self] = nil
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
			self.Value = 0
		else
			_MinMax.max = 100
			self.MinMaxValue = _MinMax
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
		_IFMyHealPredictionUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFMyHealPrediction(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		-- Default Texture
		if self:IsClass(StatusBar) and not self.StatusBarTexture then
			self.StatusBarTexturePath = [[Interface\TargetingFrame\UI-StatusBar]]
			self.StatusBarColor = ColorType(0, 0.827, 0.765)
		end

		self.MouseEnabled = false
	end
endinterface "IFMyHealPrediction"


interface "IFAllHealPrediction"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFAllHealPredictionUnitList[self] = nil
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
			self.Value = 0
		else
			_MinMax.max = 100
			self.MinMaxValue = _MinMax
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
		_IFAllHealPredictionUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFAllHealPrediction(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		-- Default Texture
		if self:IsClass(StatusBar) and not self.StatusBarTexture then
			self.StatusBarTexturePath = [[Interface\TargetingFrame\UI-StatusBar]]
			self.StatusBarColor = ColorType(0, 0.631, 0.557)
		end

		self.MouseEnabled = false
	end
endinterface "IFAllHealPrediction"