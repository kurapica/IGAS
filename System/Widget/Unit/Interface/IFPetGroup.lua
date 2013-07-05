-- Author      : Kurapica
-- Create Date : 2013/02/03
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFPetGroup", version) then
	return
end

_All = "all"
_IFPetGroupUnitList = _IFPetGroupUnitList or UnitList(_Name)

function _IFPetGroupUnitList:OnUnitListChanged()
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self.OnUnitListChanged = nil
end

function _IFPetGroupUnitList:ParseEvent(event)
	IFNoCombatTaskHandler._RegisterNoCombatTask(RefreshAll)
end

function RefreshAll()
	_IFPetGroupUnitList:EachK(_All, "Refresh")
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
				local raidMax = 0

				local raid_difficulty = GetRaidDifficultyID()
				if raid_difficulty == 1 or raid_difficulty == 3 then
					raidMax = 10
				elseif raid_difficulty == 2 or raid_difficulty == 4 then
					raidMax = 25
				end

				if stop > raidMax then
					if stop	> 25 then
						stop = 40
					elseif stop > 10 then
						stop = 25
					else
						stop = 10
					end
				else
					stop = raidMax
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
	if ( kind == "RAID" ) then
		return "raid"..index
	else
		if ( index > 0 ) then
			return "party"..index
		else
			return "player"
		end
	end
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
	extend "IFElementPanel"

	doc [======[
		@name IFPetGroup
		@type interface
		@desc IFPetGroup is used to handle the pet group's updating
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
		if self:IsInterface(IFElementPanel) then
			local kind, start, stop	 = GetGroupType()
			local index = 1
			local unit

			if kind ~= "RAID" or not self.DeactivateInRaid then
				for i = start, stop do
					unit = GetPetUnit(kind, i)

					if UnitExists(unit) then
						self.Element[index].Unit = unit

						index = index + 1
					end
				end
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
	doc [======[
		@name DeactivateInRaid
		@type property
		@desc Whether should deactivate in the raid if using the defalut Refresh method
	]======]
	property "DeactivateInRaid" {
		Get = function(self)
			return self.__DeactivateInRaid or false
		end,
		Set = function(self, value)
			self.__DeactivateInRaid = value
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFPetGroupUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFPetGroup(self)
		_IFPetGroupUnitList[self] = _All
	end
endinterface "IFPetGroup"