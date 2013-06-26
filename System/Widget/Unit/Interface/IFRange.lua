-- Author      : Kurapica
-- Create Date : 2012/07/14
-- Change Log  :

-- Check Version
local version = 4
if not IGAS:NewAddon("IGAS.Widget.Unit.IFRange", version) then
	return
end

_IFRangeUnitList = _IFRangeUnitList or UnitList(_Name)

_IFRangeTimer = Timer("IGAS_IFRange_Timer")
_IFRangeTimer.Enabled = false
_IFRangeTimer.Interval = 0.2

_IFRangeCache = _IFRangeCache or {}

function IsInRange(unit)
	local inRange, checkedRange = UnitInRange(unit)

	return inRange or not checkedRange
end

function RefreshUnit(unit)
	if UnitExists(unit) and UnitIsConnected(unit) then
		local inRange = IsInRange(unit)

		if _IFRangeCache[unit] ~= inRange then
			_IFRangeCache[unit] = inRange

			_IFRangeUnitList:EachK(unit, "InRange", inRange)
		end
	end
end

function _IFRangeTimer:OnTimer()
	for unit in pairs(_IFRangeUnitList) do
		RefreshUnit(unit)
	end
end

interface "IFRange"
	extend "IFUnitElement"

	doc [======[
		@name IFRange
		@type interface
		@desc IFRange is used to check whether the unit is in the spell range of the player
		@overridable InRange property, boolean, used to receive the result, whether the unit is in the spell range of the player
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
		self.InRange = _IFRangeCache[self.Unit]
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFRangeUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFRangeUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFRange(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
		_IFRangeTimer.Enabled = true
	end
endinterface "IFRange"