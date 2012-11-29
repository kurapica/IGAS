-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFPower
-- @type Interface
-- @name IFPower
-- @need property Boolean : UsePowerColor
-- @need property MinMax : MinMaxValue
-- @need property Number : Value
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFPower", version) then
	return
end

PowerBarColor = CopyTable(_G.PowerBarColor)

_IFPowerUnitList = _IFPowerUnitList or UnitList(_Name)
_IFPowerUnitPowerType = _IFPowerUnitPowerType or {}

_MinMax = MinMax(0, 1)

function _IFPowerUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_POWER")
	self:RegisterEvent("UNIT_MAXPOWER")
	self:RegisterEvent("UNIT_POWER_BAR_SHOW")
	self:RegisterEvent("UNIT_POWER_BAR_HIDE")
	self:RegisterEvent("UNIT_DISPLAYPOWER")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self.OnUnitListChanged = nil
end

function _IFPowerUnitList:ParseEvent(event, unit, type)
	if not self:HasUnit(unit) and event ~= "PLAYER_ENTERING_WORLD" then return end

	local powerType = unit and UnitPowerType(unit)

	if unit and powerType ~= _IFPowerUnitPowerType[unit] then
		_IFPowerUnitPowerType[unit] = powerType
		self:EachK(unit, "Refresh")
	elseif event == "UNIT_POWER" then
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

interface "IFPower"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFPowerUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
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

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFPowerUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFPower(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		-- Default Texture
		if self:IsClass(StatusBar) then
			if not self.StatusBarTexturePath then
				self.StatusBarTexturePath = [[Interface\TargetingFrame\UI-StatusBar]]
			end
		end

		self.MouseEnabled = false
	end
endinterface "IFPower"