-- Author      : Kurapica
-- Create Date : 2012/11/07
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFPowerFrequent", version) then
	return
end

_IFPowerFrequentUnitList = _IFPowerFrequentUnitList or UnitList(_Name)
_IFPowerFrequentUnitPowerType = _IFPowerFrequentUnitPowerType or {}

_MinMax = MinMax(0, 1)

function _IFPowerFrequentUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_POWER_FREQUENT")
	self:RegisterEvent("UNIT_MAXPOWER")
	self:RegisterEvent("UNIT_POWER_BAR_SHOW")
	self:RegisterEvent("UNIT_POWER_BAR_HIDE")
	self:RegisterEvent("UNIT_DISPLAYPOWER")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self.OnUnitListChanged = nil
end

function _IFPowerFrequentUnitList:ParseEvent(event, unit, type)
	if not self:HasUnit(unit) and event ~= "PLAYER_ENTERING_WORLD" then return end

	local powerType = unit and UnitPowerType(unit)

	if unit and powerType ~= _IFPowerFrequentUnitPowerType[unit] then
		_IFPowerFrequentUnitPowerType[unit] = powerType
		self:EachK(unit, "Refresh")
	elseif event == "UNIT_POWER_FREQUENT" then
		if powerType and _ClassPowerMap[powerType] ~= type then return end

		self:EachK(unit, "Value", UnitPower(unit, powerType))
	elseif event == "UNIT_MAXPOWER" then
		_MinMax.max = UnitPowerMax(unit, powerType)
		self:EachK(unit, "MinMaxValue", _MinMax)
		self:EachK(unit, "Value", UnitPower(unit, powerType))
	elseif event == "PLAYER_ENTERING_WORLD" then
		for unit in pairs(self) do
			self:EachK(unit, "Refresh")
		end
	end
end

interface "IFPowerFrequent"
	extend "IFUnitElement"

	doc [======[
		@name IFPowerFrequent
		@type interface
		@desc IFPowerFrequent is used to handle the unit frequent power updating
		@overridable MinMaxValue property, System.Widget.MinMax, used to receive the min and max value of the power
		@overridable Value property, number, used to receive the power's value
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
		if not self.Existed then return end

		local powerType, powerToken, altR, altG, altB = UnitPowerType(self.Unit)

		if self.UsePowerColor then
			local info = PowerBarColor[powerToken]

			info = info or (not altR and (PowerBarColor[powerType] or PowerBarColor["MANA"]))

			if ( info ) then
				if self:IsClass(StatusBar) then
					self:SetStatusBarColor(info.r, info.g, info.b)
				elseif self:IsClass(LayeredRegion) then
					self:SetVertexColor(info.r, info.g, info.b, 1)
				end
			else
				if self:IsClass(StatusBar) then
					self:SetStatusBarColor(altR, altG, altB)
				elseif self:IsClass(LayeredRegion) then
					self:SetVertexColor(altR, altG, altB, 1)
				end
			end
		end

		local min, max = UnitPower(self.Unit, powerType), UnitPowerMax(self.Unit, powerType)

		_MinMax.max = max
		self.MinMaxValue = _MinMax

		if UnitIsConnected(self.Unit) then
			self.Value = min
		else
			self.Value = max
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name UsePowerColor
		@type property
		@desc Whether the object use auto power color, the object should be a fontstring or texture
	]======]
	property "UsePowerColor" {
		Get = function(self)
			return self.__UsePowerColor
		end,
		Set = function(self, value)
			self.__UsePowerColor = value
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFPowerFrequentUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFPowerFrequentUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFPowerFrequent(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		-- Default Texture
		if self:IsClass(StatusBar) then
			if not self.StatusBarTexturePath then
				self.StatusBarTexturePath = [[Interface\TargetingFrame\UI-StatusBar]]
			end
		end

		self.MouseEnabled = false
	end
endinterface "IFPowerFrequent"