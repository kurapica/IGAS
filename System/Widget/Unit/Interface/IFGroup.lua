-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :
--               2013/07/05 IFGroup now extend from IFElementPanel

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

-------------------------------------
-- Init manager
-- Used to handle refresh in the beginning of the game with combat
-- too bad to do this
-------------------------------------
do
	-- Manager Frame
	_IFGroup_ManagerFrame = _IFGroup_ManagerFrame or SecureFrame("IGAS_IFGroup_Manager", IGAS.UIParent, "SecureHandlerStateTemplate")
	_IFGroup_ManagerFrame.Visible = true

	IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
		_IFGroup_ManagerFrame:Execute[[
			Manager = self

			IFGroup_Panels = newtable()
		]]

		_IFGroup_ManagerFrame:SetAttribute("_onstate-group", [=[

		]=])

		_IFGroup_ManagerFrame:RegisterStateDriver("group", "")
	end)

	-------------------------------
	-- UnitPanel and UnitFrame cache
	-------------------------------
	_IFGroup_RegisterPanel = [=[
		local panel = Manager:GetFrameRef("GroupPanel")

		if panel then
			IFGroup_Panels[panel] = IFGroup_Panels[panel] or newtable()
		end
	]=]

	_IFGroup_UnregisterPanel = [=[
		local panel = Manager:GetFrameRef("GroupPanel")

		if panel then
			IFGroup_Panels[panel] = nil
		end
	]=]

	_IFGroup_RegisterFrame = [=[
		local panel = Manager:GetFrameRef("GroupPanel")
		local frame = Manager:GetFrameRef("UnitFrame")

		if panel and frame then
			IFGroup_Panels[panel] = IFGroup_Panels[panel] or newtable()
			tinsert(IFGroup_Panels[panel], frame)
		end
	]=]

	_IFGroup_UnregisterFrame = [=[
		local panel = Manager:GetFrameRef("GroupPanel")
		local frame = Manager:GetFrameRef("UnitFrame")

		if panel and frame then
			IFGroup_Panels[panel] = IFGroup_Panels[panel] or newtable()

			for k, v in ipairs(IFGroup_Panels[panel]) do
				if v == frame then
					return tremove(IFGroup_Panels[panel], k)
				end
			end
		end
	]=]


	function RegisterPanel(self)
		_IFGroup_ManagerFrame:SetFrameRef("GroupPanel", self)
		_IFGroup_ManagerFrame:Execute(_IFGroup_RegisterPanel)
	end

	function UnregisterPanel(self)
		_IFGroup_ManagerFrame:SetFrameRef("GroupPanel", self)
		_IFGroup_ManagerFrame:Execute(_IFGroup_UnregisterPanel)
	end

	function RegisterFrame(self, frame)
		_IFGroup_ManagerFrame:SetFrameRef("GroupPanel", self)
		_IFGroup_ManagerFrame:SetFrameRef("UnitFrame", frame)
		_IFGroup_ManagerFrame:Execute(_IFGroup_RegisterFrame)
	end

	function UnregisterFrame(self, frame)
		_IFGroup_ManagerFrame:SetFrameRef("GroupPanel", self)
		_IFGroup_ManagerFrame:SetFrameRef("UnitFrame", frame)
		_IFGroup_ManagerFrame:Execute(_IFGroup_UnregisterFrame)
	end
end

-------------------------------------
-- Helper functions
-------------------------------------
do
	-- Recycle the cache table
	_IFGroup_CacheTable = _IFGroup_CacheTable or setmetatable({}, {
		__call = function(self, key)
			if key then
				if type(key) == "table" and self[key] then
					wipe(key)
					tinsert(self, key)
				end
			else
				if #self > 0 then
					return tremove(self, #self)
				else
					local ret = {}

					-- Mark it as recycle table
					self[ret] = true

					return ret
				end
			end
		end,
	})

	function GetGroupType(self)
		local kind, start, stop

		local nRaid = GetNumGroupMembers()
		local nParty = GetNumSubgroupMembers()

		if IsInRaid() and self.ShowRaid then
			kind = "RAID"
		elseif IsInGroup() and self.ShowParty then
			kind = "PARTY"
		elseif self.ShowSolo then
			kind = "SOLO"
		end

		if kind then
			if kind == "RAID" then
				start = 1
				stop = nRaid

				if self.KeepMaxPlayer then
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
				if kind	== "SOLO" or self.ShowPlayer then
					start = 0
				else
					start = 1
				end
				stop = nParty

				if self.KeepMaxPlayer and kind == "PARTY" then
					stop = 4
				end
			end
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

	function GetGroupRosterInfo(kind, index)
	    local _, unit, name, subgroup, className, role, server, assignedRole
	    
	    if ( kind == "RAID" ) then
	        unit = "raid"..index
	        name, _, subgroup, _, _, className, _, _, _, role = GetRaidRosterInfo(index)
	    	
	    	assignedRole = UnitGroupRolesAssigned(unit)
	    else
	        if ( index > 0 ) then
	            unit = "party"..index
	        else
	            unit = "player"
	        end
	        if ( UnitExists(unit) ) then
	            name, server = UnitName(unit)
	            if (server and server ~= "") then
	                name = name.."-"..server
	            end
	            _, className = UnitClass(unit)
	            if ( GetPartyAssignment("MAINTANK", unit) ) then
	                role = "MAINTANK"
	            elseif ( GetPartyAssignment("MAINASSIST", unit) ) then
	                role = "MAINASSIST"
	            end
	            assignedRole = UnitGroupRolesAssigned(unit)
	        end
	        subgroup = 1
	    end
	    return unit, name, subgroup, className, role, assignedRole
	end

	function GetUnitList(self)
		local kind, start, stop	 = GetGroupType(self)
		local unit

		local lst = _IFGroup_CacheTable()

		if kind == "RAID" then
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
				tinsert(lst, unit)
			end
		elseif start and stop then
			for i = start, stop do
				tinsert(lst, GetGroupRosterUnit(kind, i))
			end
		end

		return lst
	end

	function RefreshElementPanel(self)
		local lst = GetUnitList(self)
		local index = 1

		for _, unit in ipairs(lst) do
			self.Element[index].Unit = unit

			index = index + 1
		end

		_IFGroup_CacheTable(lst)

		for i = index, self.Count do
			self.Element[i].Unit = nil
		end

		self:UpdatePanelSize()
	end
end

interface "IFGroup"
	extend "IFElementPanel"

	doc [======[
		@name IFGroup
		@type interface
		@desc IFGroup is used to handle the group's updating
	]======]

	_DefaultRole = {
		'TANK',
		'HEALER',
		'DAMAGER'
	}

	enum "GroupType" {
		"GROUP",
		"CLASS",
		"ROLE",
		"ASSIGNEDROLE"
	}

	enum "SortType" {
		"INDEX",
		"NAME"
	}

	enum "RoleType" {
		"MAINTANK",
		"MAINASSIST",
		"TANK",
		"HEALER",
		"DAMAGER",
		"NONE"
	}

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
			local kind, start, stop	 = GetGroupType(self)
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
			elseif start and stop then
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
	doc [======[
		@name ShowRaid
		@type property
		@desc Whether the panel should be shown while in a raid
	]======]
	property "ShowRaid" {
		Get = function(self)
			return self:GetAttribute("showRaid") or false
		end,
		Set = function(self, value)
			self:SetAttribute("showRaid", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name ShowParty
		@type property
		@desc Whether the panel should be shown while in a party and not in a raid
	]======]
	property "ShowParty" {
		Get = function(self)
			return self:GetAttribute("showParty") or false
		end,
		Set = function(self, value)
			self:SetAttribute("showParty", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name ShowPlayer
		@type property
		@desc Whether the panel should show the player while not in a raid
	]======]
	property "ShowPlayer" {
		Get = function(self)
			return self:GetAttribute("showPlayer") or false
		end,
		Set = function(self, value)
			self:SetAttribute("showPlayer", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name ShowSolo
		@type property
		@desc Whether the panel should be shown while not in a group
	]======]
	property "ShowSolo" {
		Get = function(self)
			return self:GetAttribute("showSolo") or false
		end,
		Set = function(self, value)
			self:SetAttribute("showSolo", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name GroupFilter
		@type property
		@desc A comma seperated list of raid group numbers and/or uppercase class names and/or uppercase roles
	]======]
	property "GroupFilter" {
		Get = function(self)
			return self:GetAttribute("groupFilter")
		end,
		Set = function(self, value)
			self.:SetAttribute("groupFilter", value)
		end,
		Type = System.String + nil,
	}

	doc [======[
		@name RoleFilter
		@type property
		@desc A comma seperated list of MT/MA/Tank/Healer/DPS role strings
	]======]
	property "RoleFilter" {
		Get = function(self)
			return self:GetAttribute("roleFilter")
		end,
		Set = function(self, value)
			self:SetAttribute("roleFilter", value)
		end,
		Type = System.String + nil,
	}

	doc [======[
		@name GroupBy
		@type property
		@desc Specifies a "grouping" type to apply before regular sorting (Default: nil)
	]======]
	property "GroupBy" {
		Get = function(self)
			return self:GetAttribute("groupBy")
		end,
		Set = function(self, value)
			self:SetAttribute("groupBy", value)
		end,
		Type = GroupType + nil,
	}


	doc [======[
		@name SortBy
		@type property
		@desc Defines how the group is sorted (Default: "INDEX")
	]======]
	property "SortBy" {
		Get = function(self)
			return self:GetAttribute("sortBy")
		end,
		Set = function(self, value)
			self:SetAttribute("sortBy", value)
		end,
		Type = System.SortType + nil,
	}

	doc [======[
		@name KeepMaxPlayer
		@type property
		@desc Whether the element panel should contains the max count elements
	]======]
	property "KeepMaxPlayer" {
		Get = function(self)
			return self:GetAttribute("keepMaxPlayer") or false
		end,
		Set = function(self, value)
			self:SetAttribute("keepMaxPlayer", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name SortByRole
		@type property
		@desc Whether the players should be sorted by rules
	]======]
	property "SortByRole" {
		Get = function(self)
			return self:GetAttribute("sortByRole") or false
		end,
		Set = function(self, value)
			self:SetAttribute("sortByRole", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name SortRole
		@type property
		@desc The sort rule
	]======]
	property "SortRole" {
		Get = function(self)
			return self.__SortRole or _DefaultRole
		end,
		Set = function(self, value)
			self.__SortRole = value
		end,
		Type = System.Table + nil,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnElementAdd(self, element)
		IFNoCombatTaskHandler._RegisterNoCombatTask(RegisterFrame, self, element)
	end

	local function OnElementRemove(self, element)
		IFNoCombatTaskHandler._RegisterNoCombatTask(UnregisterFrame, self, IGAS:GetUI(element))
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFGroupUnitList[self] = nil

		IFNoCombatTaskHandler._RegisterNoCombatTask(UnregisterPanel, self)
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFGroup(self)
		_IFGroupUnitList[self] = _All

		IFNoCombatTaskHandler._RegisterNoCombatTask(RegisterPanel, self)

		self.OnElementAdd = self.OnElementAdd + OnElementAdd
		self.OnElementRemove = self.OnElementRemove + OnElementRemove
	end
endinterface "IFGroup"