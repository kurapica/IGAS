-- Author      : Kurapica
-- Create Date : 2012/11/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFPetGroup
-- @type Interface
-- @name IFPetGroup
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFPetGroup", version) then
	return
end

_All = "all"
_IFPetGroupUnitList = _IFPetGroupUnitList or UnitList(_Name)

function _IFPetGroupUnitList:OnUnitListChanged()
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("UNIT_PET")

	self.OnUnitListChanged = nil
end

function _IFPetGroupUnitList:ParseEvent(event)
	IFNoCombatTaskHandler._RegisterNoCombatTask(self.EachK, self, _All, "Refresh")
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

function GetPetUnit(kind, index)
	if ( kind == "RAID" ) then
		return "raidpet"..index
	elseif ( index > 0 ) then
		return "partypet"..index
	else
		return "pet"
	end
end

interface "IFPetGroup"
	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFPetGroupUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		local kind, start, stop	 = GetGroupType()


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
	function IFPetGroup(self)
		_IFPetGroupUnitList[self] = _All
	end
endinterface "IFPetGroup"