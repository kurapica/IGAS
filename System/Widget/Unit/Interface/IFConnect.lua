-- Author      : Kurapica
-- Create Date : 2012/11/09
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFConnect", version) then
	return
end

_IFConnectUnitList = _IFConnectUnitList or UnitList(_Name)

_IFConnectTimer = Timer("IGAS_IFConnect_Timer")
_IFConnectTimer.Enabled = false
_IFConnectTimer.Interval = 3

function _IFConnectUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_CONNECTION")
	_IFConnectTimer.Enabled = true

	self.OnUnitListChanged = nil
end

function _IFConnectUnitList:ParseEvent(event, unit)
	if not _IFConnectUnitList:HasUnit(unit) then
		return
	end

	if event == "UNIT_CONNECTION" then
		return UpdateConnectState(unit)
	end
end

function _IFConnectTimer:OnTimer()
	for unit in pairs(_IFConnectUnitList) do
		UpdateConnectState(unit)
	end
end

function UpdateConnectState(unit)
	if UnitExists(unit) then
		_IFConnectUnitList:EachK(unit, "Connected", UnitIsConnected(unit) or false)
	end
end

interface "IFConnect"
	extend "IFUnitElement"

	doc [======[
		@name IFConnect
		@type interface
		@desc IFConnect is used to check whether the unit is connected
		@overridable Connected property, boolean, which used to receive the check result for whether the unit is connected
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	doc [======[
		@name OnStateChanged
		@type script
		@desc Fired when the unit's connecting state is changed
	]======]
	script "OnStateChanged"

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
		if self.Unit then
			self.Connected = UnitIsConnected(self.Unit)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFConnectUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFConnectUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFConnect(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
	end
endinterface "IFConnect"