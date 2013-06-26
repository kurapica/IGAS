-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFFaction", version) then
	return
end

_IFFactionUnitList = _IFFactionUnitList or UnitList(_Name)

function _IFFactionUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_FACTION")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	self.OnUnitListChanged = nil
end

function _IFFactionUnitList:ParseEvent(event, unit)
	if event == "GROUP_ROSTER_UPDATE" or unit == "player" then
		-- Update all
		for unit in pairs(self) do
			self:EachK(unit, "Refresh")
		end
	else
		self:EachK(unit, "Refresh")
	end
end

interface "IFFaction"
	extend "IFUnitElement"

	doc [======[
		@name IFFaction
		@type interface
		@desc IFFaction is used to handle the unit faction state's updating
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFFactionUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFFactionUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFFaction(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
	end
endinterface "IFFaction"