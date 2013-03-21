-- Author      : Kurapica
-- Create Date : 2012/08/06
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFHealPrediction", version) then
	return
end

_IFMyHealPredictionUnitList = _IFMyHealPredictionUnitList or UnitList(_Name.."My")
_IFAllHealPredictionUnitList = _IFAllHealPredictionUnitList or UnitList(_Name.."All")
_IFAbsorbUnitList = _IFAbsorbUnitList or UnitList(_Name.."Absorb")

_IFHealPredictionUnitMaxHealthCache = _IFHealPredictionUnitMaxHealthCache or {}

_MinMax = MinMax(0, 1)

function _IFMyHealPredictionUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_HEAL_PREDICTION")
	self:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
	self:RegisterEvent("UNIT_MAXHEALTH")
	self:RegisterEvent("UNIT_HEALTH")

	self.OnUnitListChanged = nil
end

function _IFAllHealPredictionUnitList:OnUnitListChanged()
	_IFMyHealPredictionUnitList:RegisterEvent("UNIT_HEAL_PREDICTION")
	_IFMyHealPredictionUnitList:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
	_IFMyHealPredictionUnitList:RegisterEvent("UNIT_MAXHEALTH")
	_IFMyHealPredictionUnitList:RegisterEvent("UNIT_HEALTH")

	self.OnUnitListChanged = nil
end

MAX_INCOMING_HEAL_OVERFLOW = 1

function _IFMyHealPredictionUnitList:ParseEvent(event, unit)
	if _IFMyHealPredictionUnitList:HasUnit(unit) or _IFAllHealPredictionUnitList:HasUnit(unit) or _IFAbsorbUnitList:HasUnit(unit) then
		if event == "UNIT_MAXHEALTH" then
			_MinMax.max = UnitHealthMax(unit)
			_IFHealPredictionUnitMaxHealthCache[unit] = _MinMax.max
			_IFMyHealPredictionUnitList:EachK(unit, "MinMaxValue", _MinMax)
			_IFAllHealPredictionUnitList:EachK(unit, "MinMaxValue", _MinMax)
			_IFAbsorbUnitList:EachK(unit, "MinMaxValue", _MinMax)
		else
			local myIncomingHeal = UnitGetIncomingHeals(unit, "player") or 0
			local allIncomingHeal = UnitGetIncomingHeals(unit) or 0
			local totalAbsorb = UnitGetTotalAbsorbs(unit) or 0

			local health = UnitHealth(unit)
			local maxHealth = UnitHealthMax(unit)

			-- Update max health
			if _IFHealPredictionUnitMaxHealthCache[unit] ~= maxHealth then
				_MinMax.max = maxHealth
				_IFHealPredictionUnitMaxHealthCache[unit] = maxHealth
				_IFMyHealPredictionUnitList:EachK(unit, "MinMaxValue", _MinMax)
				_IFAllHealPredictionUnitList:EachK(unit, "MinMaxValue", _MinMax)
				_IFAbsorbUnitList:EachK(unit, "MinMaxValue", _MinMax)
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

			local overAbsorb = false;
			--We don't overfill the absorb bar
			if ( health + myIncomingHeal + allIncomingHeal + totalAbsorb >= maxHealth ) then
				if ( totalAbsorb > 0 ) then
					overAbsorb = true;
				end
				totalAbsorb = max(0,maxHealth - (health + myIncomingHeal + allIncomingHeal));
			end

			_IFMyHealPredictionUnitList:EachK(unit, "Value", myIncomingHeal)
			_IFAllHealPredictionUnitList:EachK(unit, "Value", allIncomingHeal)
			_IFAbsorbUnitList:EachK(unit, "Value", totalAbsorb)
			_IFAbsorbUnitList:EachK(unit, "OverAbsorb", overAbsorb)
		end
	end
end

interface "IFMyHealPrediction"
	extend "IFUnitElement"

	doc [======[
		@name IFMyHealPrediction
		@type interface
		@desc IFMyHealPrediction is used to handle the unit's prediction health by the player
		@overridable MinMaxValue property, System.Widget.MinMax, used to receive the min and max value of the unit's health
		@overridable Value property, number, used to receive the prediction health's value
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
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
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFMyHealPredictionUnitList[self] = nil
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

	doc [======[
		@name IFMyHealPrediction
		@type interface
		@desc IFMyHealPrediction is used to handle the unit's prediction health by all player
		@overridable MinMaxValue property, System.Widget.MinMax, used to receive the min and max value of the unit's health
		@overridable Value property, number, used to receive the prediction health's value
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
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
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFAllHealPredictionUnitList[self] = nil
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

interface "IFAbsorb"
	extend "IFUnitElement"

	doc [======[
		@name IFAbsorb
		@type interface
		@desc IFAbsorb is used to handle the unit's total absorb value
		@overridable MinMaxValue property, System.Widget.MinMax, used to receive the min and max value of the unit's health
		@overridable Value property, number, used to receive the total absorb value
		@overridable OverAbsorb Property, boolean, used to receive the result whether the unit's absorb effect is overdose
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Refresh(self)
		if self.Unit then
			_MinMax.max = UnitHealthMax(self.Unit)
			self.MinMaxValue = _MinMax
			self.Value = 0
			self.OverAbsorb = false
		else
			_MinMax.max = 100
			self.MinMaxValue = _MinMax
			self.Value = 0
			self.OverAbsorb = false
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFAbsorbUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFAbsorbUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFAbsorb(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		-- Default Texture
		if self:IsClass(StatusBar) and not self.StatusBarTexture then
			self.StatusBarTexturePath = [[Interface\RaidFrame\Shield-Fill]]
		end

		self.MouseEnabled = false
	end
endinterface "IFAbsorb"