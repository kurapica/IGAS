-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFMana
-- @type Interface
-- @name IFMana
-- @need property Boolean : UsePowerColor
-- @need property MinMax : MinMaxValue
-- @need property Number : Value
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFMana", version) then
	return
end

_IFManaUnitList = _IFManaUnitList or UnitList(_Name)

SPELL_POWER_MANA = _G.SPELL_POWER_MANA

_MinMax = MinMax(0, 1)

if select(2, UnitClass('player')) == 'DRUID' or select(2, UnitClass('player')) == 'MONK' then
	_UseHiddenMana = true
else
	_UseHiddenMana = false
end

function _IFManaUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_POWER")
	self:RegisterEvent("UNIT_MAXPOWER")
	self:RegisterEvent("UNIT_POWER_BAR_SHOW")
	self:RegisterEvent("UNIT_POWER_BAR_HIDE")
	self:RegisterEvent("UNIT_DISPLAYPOWER")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

	self.OnUnitListChanged = nil
end

function _IFManaUnitList:ParseEvent(event, unit, type)
	if (unit and unit ~= "player") or (type and type ~= "MANA") then return end

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

interface "IFMana"
	extend "IFUnitElement"

	SPELL_POWER_MANA = SPELL_POWER_MANA

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFManaUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if not _M._UseHiddenMana or not self.Existed then return end

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
		if self.Unit == "player" then
			_IFManaUnitList[self] = self.Unit
		else
			_IFManaUnitList[self] = nil
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFMana(self)
		if _M._UseHiddenMana then
			self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

			-- Default Texture
			if self:IsClass(StatusBar) then
				if not self.StatusBarTexturePath then
					self.StatusBarTexturePath = [[Interface\TargetingFrame\UI-StatusBar]]
				end
			end

			local info = PowerBarColor['MANA']

			if self:IsClass(StatusBar) then
				self:SetStatusBarColor(info.r, info.g, info.b)
			elseif self:IsClass(LayeredRegion) then
				self:SetVertexColor(info.r, info.g, info.b, 1)
			end

			self.MouseEnabled = false
		else
			self.Visible = false
		end
	end
endinterface "IFMana"