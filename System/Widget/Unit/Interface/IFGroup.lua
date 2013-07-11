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

_IFGroup_Need_Secure_Refresh = true

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
-- Init secure manager
-- Used to handle refresh in the beginning of the game with combat
-- too bad to do this
-------------------------------------
do
	-- Manager Frame
	_IFGroup_ManagerFrame = _IFGroup_ManagerFrame or SecureFrame("IGAS_IFGroup_Manager", IGAS.UIParent, "SecureHandlerStateTemplate")
	_IFGroup_ManagerFrame.Visible = true

	_IFGroup_ManagerFrame:Execute[[
		Manager = self

		IFGroup_Panels = newtable()

		IFGroup_UnitList = newtable()

		RefreshPanel = [=[
			local kind, start, stop = ...
			local unit

			-- Skip special filter panel
			if self:GetAttribute("groupFilter") or self:GetAttribute("classFilter") or self:GetAttribute("roleFilter") then
				return
			end

			-- Generate unit list
			wipe(IFGroup_UnitList)

			if kind == "raid" and self:GetAttribute("showRaid") then
				for i = start, stop do
					unit = "raid" .. i

					tinsert(IFGroup_UnitList, unit)
					IFGroup_UnitList[unit] = true
				end
			elseif kind == "party" and self:GetAttribute("showParty") then
				if self:GetAttribute("ShowPlayer") then
					tinsert(IFGroup_UnitList, "player")
					IFGroup_UnitList["player"] = true
				end

				for i = 1, 4 do
					unit = "party" .. i

					tinsert(IFGroup_UnitList, unit)
					IFGroup_UnitList[unit] = true
				end
			elseif self:GetAttribute("ShowSolo") then
				tinsert(IFGroup_UnitList, "player")
				IFGroup_UnitList["player"] = true
			end

			-- Scan the elements of the panel
			local elements = IFGroup_Panels[self]

			for _, ele in ipairs(elements) do
				unit = ele:GetAttribute("unit")

				if unit and IFGroup_UnitList[unit] then
					IFGroup_UnitList[unit] = false
				end
			end

			-- Refresh the elements
			local index = 0

			for _, ele in ipairs(elements) do
				unit = ele:GetAttribute("unit")

				if not unit or IFGroup_UnitList[unit] == nil then
					while true do
						index = index + 1
						unit = IFGroup_UnitList[index]

						if not unit or IFGroup_UnitList[unit] then
							ele:SetAttribute("unit", unit)

							break
						end
					end
				end
			end

			wipe(IFGroup_UnitList)
		]=]
	]]

	_IFGroup_ManagerFrame:SetAttribute("_onstate-group", [=[
		local kind, start, stop

		if newstate == "raid40" then
			kind, start, stop = "raid", 1, 40
		elseif newstate == "raid25" then
			kind, start, stop = "raid", 1, 25
		elseif newstate == "raid10" then
			kind, start, stop = "raid", 1, 10
		elseif newstate == "party" then
			kind, start, stop = "party", 0, 4
		else
			kind, start, stop = "solo", 0, 0
		end

		for panel in pairs(IFGroup_Panels) do
			Manager:RunFor(panel, RefreshPanel, kind, start, stop)
		end
	]=])

	_IFGroup_ManagerFrame:RegisterStateDriver("group", "[@raid26,exists]raid40;[@raid11,exists]raid25;[raid]raid10;[party]party;solo")

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
		if not _IFGroup_Need_Secure_Refresh then return end

		_IFGroup_ManagerFrame:SetFrameRef("GroupPanel", self)
		_IFGroup_ManagerFrame:Execute(_IFGroup_RegisterPanel)
	end

	function UnregisterPanel(self)
		if not _IFGroup_Need_Secure_Refresh then return end
		
		_IFGroup_ManagerFrame:SetFrameRef("GroupPanel", self)
		_IFGroup_ManagerFrame:Execute(_IFGroup_UnregisterPanel)
	end

	function RegisterFrame(self, frame)
		if not _IFGroup_Need_Secure_Refresh then return end
		
		_IFGroup_ManagerFrame:SetFrameRef("GroupPanel", self)
		_IFGroup_ManagerFrame:SetFrameRef("UnitFrame", frame)
		_IFGroup_ManagerFrame:Execute(_IFGroup_RegisterFrame)
	end

	function UnregisterFrame(self, frame)
		if not _IFGroup_Need_Secure_Refresh then return end
		
		_IFGroup_ManagerFrame:SetFrameRef("GroupPanel", self)
		_IFGroup_ManagerFrame:SetFrameRef("UnitFrame", frame)
		_IFGroup_ManagerFrame:Execute(_IFGroup_UnregisterFrame)
	end

	-------------------------------------
	-- Module Event Handler
	-------------------------------------
	function OnEnable(self)
		self:ThreadCall(function()
			-- Keep safe
			System.Threading.Sleep(3)

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				-- Clear all
				_IFGroup_ManagerFrame:UnregisterStateDriver("group")

				_IFGroup_ManagerFrame:SetAttribute("_onstate-group", nil)

				_IFGroup_ManagerFrame:Execute[[
					for _, tbl in pairs(IFGroup_Panels) do
						wipe(tbl)
					end

					wipe(IFGroup_Panels)
				]]
			end)

			_IFGroup_Need_Secure_Refresh = false
		end)
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

	_NameList = nil

	-- Default order settings
	_DefaultGroupOrder = {1,2,3,4,5,6,7,8,}

	_DefaultClassOrder = {
		"DEATHKNIGHT",
		"DRUID",
		"HUNTER",
		"MAGE",
		"MONK",
		"PALADIN",
		"PRIEST",
		"ROGUE",
		"SHAMAN",
		"WARLOCK",
		"WARRIOR",
	}

	_DefaultRoleOrder = {
		"MAINTANK",
		"MAINASSIST",
		"TANK",
		"HEALER",
		"DAMAGER",
		"NONE",
	}

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

	function GetFilterCache(filter)
		if filter then
			local ret = _IFGroup_CacheTable()

			for i, v in ipairs(filter) do
				ret[v] = i
			end

			return ret
		end
	end

	function ConcatList(self, src)
		for _, unit in ipairs(src) do
			tinsert(self, unit)
		end
	end

	function CompareByName(a, b)
		local na = _NameList[a] or a
		local nb = _NameList[b] or b

		return a < b
	end

	function GetUnitList(self)
		local kind, start, stop	 = GetGroupType(self)
		local unit, name, subgroup, className, role, assignedRole

		local unitlist = _IFGroup_CacheTable()
		local namelist = _IFGroup_CacheTable()
		local grouplist = _IFGroup_CacheTable()

		local groupFilter, classFilter, roleFilter
		local passed
		local orderlist

		-- Fill the filters
		groupFilter = GetFilterCache(self.GroupFilter)
		classFilter = GetFilterCache(self.ClassFilter)
		roleFilter = GetFilterCache(self.RoleFilter)

		-- Init the group
		grouplist["ELSE"] = _IFGroup_CacheTable()
		
		if self.GroupBy == "GROUP" then
			orderlist = self.GroupFilter or _DefaultGroupOrder
		elseif self.GroupBy == "CLASS" then
			orderlist = self.ClassFilter or _DefaultClassOrder
		elseif self.GroupBy == "ROLE" then
			orderlist = self.RoleFilter or _DefaultRoleOrder
		end

		if orderlist then
			for k, v in ipairs(orderlist) do
				grouplist[v] = _IFGroup_CacheTable()
			end
		end

		-- Generate the unit list
		if kind and start and stop then
			-- Scan the units
			for i = start, stop do
				unit, name, subgroup, className, role, assignedRole = GetRaidRosterInfo(kind, i)

				passed = true

				-- Check group & class & role
				if passed and groupFilter and not groupFilter[subgroup] then passed = false end
				if passed and classFilter and not classFilter[className] then passed = false end
				if passed and roleFilter and not classFilter[role] and not classFilter[assignedRole] then passed = false end

				-- Add to list
				if passed then
					namelist[unit] = name

					if self.GroupBy == "GROUP" then
						tinsert(grouplist[subgroup], unit)
					elseif self.GroupBy == "CLASS" then
						tinsert(grouplist[className], unit)
					elseif self.GroupBy == "ROLE" then
						if role and classFilter[role] then
							tinsert(grouplist[className], unit)
						else
							tinsert(grouplist[assignedRole], unit)
						end
					else
						tinsert(grouplist["ELSE"], unit)
					end
				end
			end

			-- Sorting
			if self.SortBy == "NAME" then
				_NameList = namelist

				for k, v in pairs(grouplist) do
					Array.Sort(v, CompareByName)
				end

				_NameList = nil
			end

			-- Generate unit list
			if orderlist then
				for k, v in ipairs(orderlist) do
					ConcatList(unitlist, grouplist[v])
				end
			end

			ConcatList(unitlist, grouplist["ELSE"])
		end

		-- Recycle the tables
		if groupFilter then _IFGroup_CacheTable(groupFilter) end
		if classFilter then _IFGroup_CacheTable(classFilter) end
		if roleFilter then _IFGroup_CacheTable(roleFilter) end

		for k, v in pairs(grouplist) do
			_IFGroup_CacheTable(v)
		end

		_IFGroup_CacheTable(namelist)
		_IFGroup_CacheTable(grouplist)

		return unitlist
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

	enum "GroupType" {
		"GROUP",
		"CLASS",
		"ROLE",
		--"ASSIGNEDROLE"
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

	enum "PlayerClass" {
		"WARRIOR",
		"PALADIN",
		"HUNTER",
		"ROGUE",
		"PRIEST",
		"DEATHKNIGHT",
		"SHAMAN",
		"MAGE",
		"WARLOCK",
		"MONK",
		"DRUID",
	}

	struct "GroupFilter"
		structtype "Array"

		element = System.Number
	endstruct "GroupFilter"

	struct "ClassFilter"
		structtype "Array"

		element = PlayerClass
	endstruct "ClassFilter"

	struct "RoleFilter"
		structtype "Array"

		element = RoleType
	endstruct "RoleFilter"

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
		RefreshElementPanel(self)
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
		@desc A list of raid group numbers, used as the filter settings and order settings(if GroupBy is "GROUP")
	]======]
	property "GroupFilter" {
		Get = function(self)
			return self.__GroupFilter
		end,
		Set = function(self, value)
			self.__GroupFilter = value
			if value then
				self:SetAttribute("groupFilter", true)
			else
				self:SetAttribute("groupFilter", false)
			end
		end,
		Type = GroupFilter + nil,
	}

	doc [======[
		@name ClassFilter
		@type property
		@desc A list of uppercase class names, used as the filter settings and order settings(if GroupBy is "CLASS")
	]======]
	property "ClassFilter" {
		Get = function(self)
			return self.__ClassFilter
		end,
		Set = function(self, value)
			self.__ClassFilter = value
			if value then
				self:SetAttribute("classFilter", true)
			else
				self:SetAttribute("classFilter", false)
			end
		end,
		Type = ClassFilter + nil,
	}

	doc [======[
		@name RoleFilter
		@type property
		@desc A list of uppercase role names, used as the filter settings and order settings(if GroupBy is "ROLE")
	]======]
	property "RoleFilter" {
		Get = function(self)
			return self.__RoleFilter
		end,
		Set = function(self, value)
			self.__RoleFilter = value
			if value then
				self:SetAttribute("roleFilter", true)
			else
				self:SetAttribute("roleFilter", false)
			end
		end,
		Type = RoleFilter + nil,
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