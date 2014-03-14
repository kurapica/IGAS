-- Author      : Kurapica
-- Create Date : 2012/07/14
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFRune", version) then
	return
end

_All = "all"
_IFRuneUnitList = _IFRuneUnitList or UnitList(_Name)

MAX_RUNES = 6
_RuneIndexMap = {}

function _IFRuneUnitList:OnUnitListChanged()
	self:RegisterEvent("RUNE_POWER_UPDATE")
	self:RegisterEvent("RUNE_TYPE_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self.OnUnitListChanged = nil
end

function _IFRuneUnitList:ParseEvent(event, runeIndex, isEnergize)
	if event == "PLAYER_ENTERING_WORLD" then
		for i = 1, MAX_RUNES do
			_RuneIndexMap[i] = GetRuneType(i)

			self:EachK(_All, UpdatePowerType, i)
			self:EachK(_All, UpdatePower, i)
		end
	elseif event == "RUNE_TYPE_UPDATE" and runeIndex then
		if GetRuneType(runeIndex) ~= _RuneIndexMap[runeIndex] then
			_RuneIndexMap[runeIndex] = GetRuneType(runeIndex)

			self:EachK(_All, UpdatePowerType, runeIndex)
		end
	elseif event == "RUNE_POWER_UPDATE" and  runeIndex then
		self:EachK(_All, UpdatePower, runeIndex, isEnergize)
	end
end

function UpdatePowerType(self, index)
	if self[index] then
		self[index].RuneType = _RuneIndexMap[index] or GetRuneType(index)
	else
		self:Refresh(index)
	end
end

function UpdatePower(self, index, isEnergize)
	if self[index] and self[index]:IsInterface(IFCooldown) then
		local start, duration, runeReady = GetRuneCooldown(index)

		if not runeReady then
			if start then
				self[index]:OnCooldownUpdate(start, duration)
			end
			self[index].Ready = false
		else
			self[index].Ready = true
		end

		self[index].Energize = isEnergize
	else
		self:Refresh(index)
	end
end

__Doc__[[
	<desc>IFRune is used to handle the unit's rune power's updating</desc>
	<optional name="Visible" type="property" valuetype="boolean">used to receive the check result that whether the rune power should be shown</optional>
	<usage>
		For default, the object should has MAX_RUNES elements, each elements should extend System.Widget.IFCooldown and with several properties :
			RuneType property, number, the rune's type
			Ready property, boolean, whether the rune is Ready
			Energize property, boolean, whether the rune is energized
	</usage>
]]
interface "IFRune"
	extend "IFUnitElement"

	MAX_RUNES = MAX_RUNES

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	__Doc__[[The default refresh method, overridable]]
	function Refresh(self)
		for i = 1, MAX_RUNES do
			UpdatePowerType(self, i)
			UpdatePower(self, i)
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
			_IFRuneUnitList[self] = _All
		else
			_IFRuneUnitList[self] = nil
		end
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFRuneUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFRune(self)
		if select(2, UnitClass("player")) == "DEATHKNIGHT" then
			self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
		else
			self.Visible = false
		end
	end
endinterface "IFRune"