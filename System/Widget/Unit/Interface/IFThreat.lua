-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFThreat", version) then
	return
end

_IFThreatUnitList = _IFThreatUnitList or UnitList(_Name)

function _IFThreatUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")

	self.OnUnitListChanged = nil
end

function _IFThreatUnitList:ParseEvent(event, unit)
	if self:HasUnit(unit) then
		self:EachK(unit, "ThreatLevel", UnitThreatSituation(unit) or 0)
	end
end

interface "IFThreat"
	extend "IFUnitElement"

	doc [======[
		@name IFThreat
		@type interface
		@desc IFThreat is used to handle the unit threat level's update
		@overridable ThreatLevel property, number, which used to receive the unit's threat level
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
		self.ThreatLevel = self.Unit and UnitThreatSituation(self.Unit) or 0
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name ThreatLevel
		@type property
		@desc The unit's threat level
	]======]
	property "ThreatLevel" {
		Set = function(self, value)
			if self:IsClass(LayeredRegion) then
				if value > 0 then
					self:SetVertexColor(GetThreatStatusColor(value))
					self.Visible = true
				else
					self.Visible = false
				end
			end
		end,
		Type = System.Number,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFThreatUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFThreatUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFThreat(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
	end
endinterface "IFThreat"