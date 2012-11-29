-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFLeader
-- @type Interface
-- @name IFLeader
-- @need property Boolean : Visible
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFLeader", version) then
	return
end

_All = "all"
_IFLeaderUnitList = _IFLeaderUnitList or UnitList(_Name)

function _IFLeaderUnitList:OnUnitListChanged()
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	self.OnUnitListChanged = nil
end

function _IFLeaderUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFLeader"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFLeaderUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		self.Visible = (self.InParty or self.InRaid) and self.IsGroupLeader
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
	function IFLeader(self)
		_IFLeaderUnitList[self] = _All

		-- Default Texture
		if self:IsClass(Texture) then
			if not self.TexturePath and not self.Color then
				self.TexturePath = [[Interface\GroupFrame\UI-Group-LeaderIcon]]
			end
		end
	end
endinterface "IFLeader"