-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFGroup
-- @type Interface
-- @name IFGroup
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFGroup", version) then
	return
end

_All = "all"
_IFGroupUnitList = _IFGroupUnitList or UnitList(_Name)

function _IFGroupUnitList:OnUnitListChanged()
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self.OnUnitListChanged = nil
end

function _IFGroupUnitList:ParseEvent(event)
	IFNoCombatTaskHandler._RegisterNoCombatTask(RefreshAll)
end

function RefreshAll()
	_IFGroupUnitList:EachK(_All, "Refresh")
end

function GetGroupType(chkMax)
	local kind, start, stop

	local nRaid = GetNumGroupMembers()
	local nParty = GetNumSubgroupMembers()

	if IsInRaid() then
		kind = "RAID"
	elseif IsInGroup() then
		kind = "PARTY"
	else
		kind = "SOLO"
	end

	if kind == "RAID" then
		start = 1
		stop = nRaid

		if chkMax then
			local _, instanceType = IsInInstance()

			if instanceType == "raid" then
				local _, _, _, _, max_players = GetInstanceInfo()
				stop = max_players or stop
			else
				local raid_difficulty = GetRaidDifficulty()
				if raid_difficulty == 1 or raid_difficulty == 3 then
					stop = 10
				elseif raid_difficulty == 2 or raid_difficulty == 4 then
					stop = 25
				end
			end
		end
	else
		start = 0
		stop = nParty

		if chkMax and kind == "PARTY" then stop = 4 end
	end

	return kind, start, stop
end

function GetGroupRosterUnit(kind, index)
	local unit
	if ( kind == "RAID" ) then
		unit = "raid"..index
	else
		if ( index > 0 ) then
			unit = "party"..index
		else
			unit = "player"
		end
	end
	return unit
end

interface "IFGroup"
	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFGroupUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self:IsInterface(IFElementPanel) then
			local kind, start, stop	 = GetGroupType(self.KeepMaxPlayer)
			local index = 1
			local unit

			for i = start, stop do
				self.Element[index].Unit = GetGroupRosterUnit(kind, i)

				index = index + 1
			end

			for i = index, self.Count do
				self.Element[i].Unit = nil
			end

			self:UpdatePanelSize()
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- KeepMaxPlayer
	property "KeepMaxPlayer" {
		Get = function(self)
			return self.__KeepMaxPlayer or false
		end,
		Set = function(self, value)
			self.__KeepMaxPlayer = value
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFGroup(self)
		_IFGroupUnitList[self] = _All
	end
endinterface "IFGroup"