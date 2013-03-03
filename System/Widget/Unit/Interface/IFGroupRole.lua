-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFGroupRole", version) then
	return
end

_All = "all"
_IFGroupRoleUnitList = _IFGroupRoleUnitList or UnitList(_Name)

function _IFGroupRoleUnitList:OnUnitListChanged()
	self:RegisterEvent("PLAYER_ROLES_ASSIGNED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	self.OnUnitListChanged = nil
end

function _IFGroupRoleUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFGroupRole"
	extend "IFUnitElement"

	doc [======[
		@name IFResting
		@type interface
		@desc IFResting is used to handle group role's updating
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

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
		_IFGroupRoleUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFGroupRole(self)
		_IFGroupRoleUnitList[self] = _All
	end
endinterface "IFGroupRole"