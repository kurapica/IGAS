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
				local raidMax = 0

				local raid_difficulty = GetRaidDifficulty()
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
	_DefaultRole = {
		'TANK',
		'HEALER',
		'DAMAGER',
	}

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

			if kind == "RAID" and self.SortByRole then
				self.__SortRoleCache = self.__SortRoleCache or {}

				-- Build up cache
				for _, role in ipairs(self.SortRole) do
					self.__SortRoleCache[role] = self.__SortRoleCache[role] or {}
					wipe(self.__SortRoleCache[role])
				end
				self.__SortRoleCache["ELSE"] = self.__SortRoleCache["ELSE"] or {}
				wipe(self.__SortRoleCache["ELSE"])

				-- Sort
				local cache
				for i = start, stop do
					unit = GetGroupRosterUnit(kind, i)
					cache = self.__SortRoleCache[UnitGroupRolesAssigned(unit)] or self.__SortRoleCache["ELSE"]
					tinsert(cache, unit)
				end

				for _, role in ipairs(self.SortRole) do
					cache = self.__SortRoleCache[role]
					for _, unit in ipairs(cache) do
						self.Element[index].Unit = unit

						index = index + 1
					end
				end
				cache = self.__SortRoleCache["ELSE"]
				for _, unit in ipairs(cache) do
					self.Element[index].Unit = unit

					index = index + 1
				end
			else
				for i = start, stop do
					self.Element[index].Unit = GetGroupRosterUnit(kind, i)

					index = index + 1
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
	-- SortByRole
	property "SortByRole" {
		Get = function(self)
			return self.__SortByRole
		end,
		Set = function(self, value)
			self.__SortByRole = value
			if value then
				self.__SortRoleCache = self.__SortRoleCache or {}
			else
				self.__SortRoleCache = nil
			end
		end,
		Type = System.Boolean,
	}
	-- SortRole
	property "SortRole" {
		Get = function(self)
			return self.__SortRole or _DefaultRole
		end,
		Set = function(self, value)
			self.__SortRole = value
			self.__SortRoleCache = self.__SortRoleCache or {}
			wipe(self.__SortRoleCache)
		end,
		Type = System.Table + nil,
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