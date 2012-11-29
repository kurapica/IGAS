-- Author      : Kurapica
-- Create Date : 2012/07/14
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFRange
-- @type Interface
-- @name IFRange
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFRange", version) then
	return
end

_All = "all"
_IFRangeUnitList = _IFRangeUnitList or UnitList(_Name)

_IFRangeTimer = Timer("IGAS_IFRange_Timer")
_IFRangeTimer.Enabled = false
_IFRangeTimer.Interval = 0.2

function RefreshAlive(self)
	if self.IsConnected then
		return self:Refresh()
	end
end

function _IFRangeTimer:OnTimer()
	_IFRangeUnitList:EachK(_All, RefreshAlive)
end

interface "IFRange"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFRangeUnitList[self] = nil
		if not _IFRangeUnitList[_All] then
			_IFRangeTimer.Enabled = false
		end
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self.InRange then
			self.Alpha = 1
		else
			self.Alpha = 0.5
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFRange(self)
		_IFRangeUnitList[self] = _All
		_IFRangeTimer.Enabled = true
	end
endinterface "IFRange"