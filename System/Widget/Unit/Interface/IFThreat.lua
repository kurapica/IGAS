-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFThreat
-- @type Interface
-- @name IFThreat
-- @need property Number : ThreatLevel
----------------------------------------------------------------------------------------------------------------------------------------

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

	_IFThreatUnitList = _IFThreatUnitList

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFThreatUnitList[self] = nil
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- ThreatLevel
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
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFThreatUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFThreat(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
	end
endinterface "IFThreat"