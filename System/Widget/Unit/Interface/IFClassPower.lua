-- Author      : Kurapica
-- Create Date : 2012/11/14
-- Change Log  :
--               2012/12/01 Update for PLAYER_LEVEL_UP, UnitLevel("player") need +1
--               2013/10/15 _PlayerActivePower can't be nil, so stop look the parent environment

-- Check Version
local version = 4
if not IGAS:NewAddon("IGAS.Widget.Unit.IFClassPower", version) then
	return
end

_IFClassPowerUnitList = _IFClassPowerUnitList or UnitList(_Name)

_PlayerClass = select(2, UnitClass("player"))
_PlayerActivePower = false

_MinMax = MinMax(0, 1)
SPEC_ALL = 0

_ClassMap = {
	MONK = {
		[SPEC_ALL] = {
			PowerType = _G.SPELL_POWER_CHI,
			PowerToken = {
				CHI = true,
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

_PlayerClassMap = _ClassMap[_PlayerClass] or false

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
	if event == "UNIT_MAXPOWER" then
		if unit ~= "player" then return end

		if _PlayerActivePower and _PlayerActivePower.Max ~= UnitPowerMax("player", _PlayerActivePower.PowerType, _PlayerActivePower.RealPower) then
			_PlayerActivePower.Max = UnitPowerMax("player", _PlayerActivePower.PowerType, _PlayerActivePower.RealPower)

			_MinMax.max = _PlayerActivePower.Max
			self:EachK("player", "MinMaxValue", _MinMax)
		end
	elseif event == "UNIT_POWER_FREQUENT" then
		if unit ~= "player" then return end

		if _PlayerActivePower and _PlayerActivePower.PowerToken[powerToken] then
			self:EachK("player", "Value", UnitPower("player", _PlayerActivePower.PowerType, _PlayerActivePower.RealPower))
		end
	else
		RefreshActivePower(event=="PLAYER_LEVEL_UP" and unit or nil)
	end
end

function RefreshActivePower(trueLevel)
	local spec = GetSpecialization() or 1
	local map = _PlayerClassMap[spec] or _PlayerClassMap[SPEC_ALL]

	_IFClassPowerUnitList:UnregisterEvent("SPELLS_CHANGED")

	if map then
		_PlayerActivePower = false

		if map.ShowLevel then
			trueLevel = trueLevel or UnitLevel("player")
			if trueLevel >= map.ShowLevel then
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
		_PlayerActivePower = false
		_IFClassPowerUnitList:EachK("player", "Visible", false)
		_IFClassPowerUnitList:EachK("player", "ClassPowerType", nil)
		_IFClassPowerUnitList:EachK("player", "Value", 0)
		_MinMax.max = 0
		_IFClassPowerUnitList:EachK("player", "MinMaxValue", _MinMax)
	end
end

interface "IFClassPower"
	extend "IFUnitElement"

	doc [======[
		@name IFClassPower
		@type interface
		@desc IFClassPower is used to handle the unit's class power, for monk's chi, priest's shadow orb, paladin's holy power, warlock's sould shard, demonic fury, burning ember.
		@overridable Visible property, boolean, which used to receive the check value for whether the class power need to be shown
		@overridable MinMaxValue property, System.Widget.MinMax, which used to receive the unit's class power's min and max value
		@overridable Value property, number, which is used to receive the unit's class power's value
		@overridable ClassPowerType property, number | nil, which is used to receive the unit's class power's type
	]======]

	------------------------------------------------------
	-- Event
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
		if _M._PlayerClassMap then
			return RefreshActivePower()
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
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
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFClassPowerUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFClassPower(self)
		if not _M._PlayerClassMap then
			self.Visible = false
			return
		end

		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		self.MouseEnabled = false
	end
endinterface "IFClassPower"