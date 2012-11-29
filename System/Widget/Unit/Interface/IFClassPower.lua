-- Author      : Kurapica
-- Create Date : 2012/11/14
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFClassPower
-- @type Interface
-- @name IFClassPower
-- @need property Number+nil : ClassPowerType
-- @need property MinMax : MinMaxValue
-- @need property Number : Value
-- @need property Boolean : Visible
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFClassPower", version) then
	return
end

_IFClassPowerUnitList = _IFClassPowerUnitList or UnitList(_Name)

_PlayerClass = select(2, UnitClass("player"))
_PlayerActivePower = nil

_MinMax = MinMax(0, 1)
SPEC_ALL = 0

_ClassMap = {
	MONK = {
		[SPEC_ALL] = {
			PowerType = _G.SPELL_POWER_LIGHT_FORCE,
			PowerToken = {
				LIGHT_FORCE = true,
				DARK_FORCE = true,
			},
		},
	},
	PRIEST = {
		[SPEC_PRIEST_SHADOW] = {
			PowerType = _G.SPELL_POWER_SHADOW_ORBS,
			PowerToken = {
				SHADOW_ORBS = true,
			},
		},
	},
	PALADIN = {
		[SPEC_ALL] = {
			ShowLevel = _G.PALADINPOWERBAR_SHOW_LEVEL,
			PowerType = _G.SPELL_POWER_HOLY_POWER,
			PowerToken = {
				HOLY_POWER = true,
			},
		},
	},
	WARLOCK = {
		[SPEC_WARLOCK_AFFLICTION] = {
			RequireSpell = _G.WARLOCK_SOULBURN,
			PowerType = _G.SPELL_POWER_SOUL_SHARDS,
			PowerToken = {
				SOUL_SHARDS = true,
			},
		},
		[SPEC_WARLOCK_DEMONOLOGY] = {
			RequireBuff = _G.WARLOCK_METAMORPHOSIS,
			PowerType = _G.SPELL_POWER_DEMONIC_FURY,
			PowerToken = {
				DEMONIC_FURY = true,
			},
		},
		[SPEC_WARLOCK_DESTRUCTION] = {
			RequireSpell = _G.WARLOCK_BURNING_EMBERS,
			PowerType = _G.SPELL_POWER_BURNING_EMBERS,
			RealPower = true,
			PowerToken = {
				BURNING_EMBERS = true,
			},
		},
	},
}

_PlayerClassMap = _ClassMap[_PlayerClass]

function _IFClassPowerUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_POWER_FREQUENT")
	self:RegisterEvent("UNIT_MAXPOWER")
	self:RegisterEvent("UNIT_DISPLAYPOWER")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Check require
	if not _PlayerClassMap[SPEC_ALL] then
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
	elseif _PlayerClassMap[SPEC_ALL].ShowLevel and UnitLevel("player") < _PlayerClassMap[0].ShowLevel then
		self:RegisterEvent("PLAYER_LEVEL_UP")
	end

	self.OnUnitListChanged = nil
end

function _IFClassPowerUnitList:ParseEvent(event, unit, powerToken)
	if unit and unit ~= "player" then return end

	if event == "UNIT_MAXPOWER" then
		if _PlayerActivePower and _PlayerActivePower.Max ~= UnitPowerMax("player", _PlayerActivePower.PowerType, _PlayerActivePower.RealPower) then
			_PlayerActivePower.Max = UnitPowerMax("player", _PlayerActivePower.PowerType, _PlayerActivePower.RealPower)

			_MinMax.max = map.Max
			self:EachK("player", "MinMaxValue", _MinMax)
		end
	elseif event == "UNIT_POWER_FREQUENT" then
		if _PlayerActivePower and _PlayerActivePower.PowerToken[powerToken] then
			self:EachK("player", "Value", UnitPower("player", _PlayerActivePower.PowerType, _PlayerActivePower.RealPower))
		end
	else
		RefreshActivePower()
	end
end

function RefreshActivePower()
	local spec = GetSpecialization() or 1
	local map = _PlayerClassMap[spec] or _PlayerClassMap[SPEC_ALL]

	_IFClassPowerUnitList:UnregisterEvent("SPELLS_CHANGED")

	if map then
		_PlayerActivePower = nil

		if map.ShowLevel then
			if UnitLevel("player") >= map.ShowLevel then
				_PlayerActivePower = map
				_IFClassPowerUnitList:UnregisterEvent("PLAYER_LEVEL_UP")
			end
		elseif map.RequireSpell then
			if IsPlayerSpell(map.RequireSpell) then
				_PlayerActivePower = map
			else
				_IFClassPowerUnitList:RegisterEvent("SPELLS_CHANGED")
			end
		else
			_PlayerActivePower = map
		end

		if _PlayerActivePower then
			_IFClassPowerUnitList:EachK("player", "Visible", true)
			_IFClassPowerUnitList:EachK("player", "ClassPowerType", _PlayerActivePower.PowerType)
			_IFClassPowerUnitList:EachK("player", "Value", UnitPower("player", _PlayerActivePower.PowerType, _PlayerActivePower.RealPower))
			_PlayerActivePower.Max = UnitPowerMax("player", _PlayerActivePower.PowerType, _PlayerActivePower.RealPower)
			_MinMax.max = _PlayerActivePower.Max
			_IFClassPowerUnitList:EachK("player", "MinMaxValue", _MinMax)
		else
			_IFClassPowerUnitList:EachK("player", "Visible", false)
			_IFClassPowerUnitList:EachK("player", "ClassPowerType", nil)
			_IFClassPowerUnitList:EachK("player", "Value", 0)
			_MinMax.max = 0
			_IFClassPowerUnitList:EachK("player", "MinMaxValue", _MinMax)
		end
	else
		_PlayerActivePower = nil
		_IFClassPowerUnitList:EachK("player", "Visible", false)
		_IFClassPowerUnitList:EachK("player", "ClassPowerType", nil)
		_IFClassPowerUnitList:EachK("player", "Value", 0)
		_MinMax.max = 0
		_IFClassPowerUnitList:EachK("player", "MinMaxValue", _MinMax)
	end
end

interface "IFClassPower"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFClassPowerUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		return RefreshActivePower()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		if self.Unit == "player" then
			_IFClassPowerUnitList[self] = self.Unit
			self.Visible = true
		else
			_IFClassPowerUnitList[self] = nil
			self.Visible = false
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFClassPower(self)
		if not _PlayerClassMap then
			self.Visible = false
			return
		end

		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		self.MouseEnabled = false
	end
endinterface "IFClassPower"