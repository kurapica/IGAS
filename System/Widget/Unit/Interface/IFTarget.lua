-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFTarget", version) then
	return
end

_All = "all"
_IFTargetUnitList = _IFTargetUnitList or UnitList(_Name)

function _IFTargetUnitList:OnUnitListChanged()
	self:RegisterEvent("PLAYER_TARGET_CHANGED")

	self.OnUnitListChanged = nil
end

function _IFTargetUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFTarget"
	extend "IFUnitElement"

	doc [======[
		@name IFTarget
		@type interface
		@desc IFTarget is used to check whether the unit is the target
		@overridable IsTarget property, boolean, which used to receive the check result
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
		self.IsTarget = self.Unit and UnitExists('target') and UnitIsUnit(self.Unit, 'target')
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFTargetUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFTarget(self)
		_IFTargetUnitList[self] = _All
	end
endinterface "IFTarget"