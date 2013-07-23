-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :
--               2013/07/05 IFGroup now extend from IFElementPanel
--               2013/07/22 ShadowGroupHeader added to refresh the unit panel
--               2013/07/23 IFSecurePanel instead of IFElementPanel to do the resize job
--                          IFGroup is now a prototype interface

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFGroup", version) then
	return
end

interface "IFGroup"
	extend "IFSecurePanel"

	doc [======[
		@name IFGroup
		@type interface
		@desc Common features for unit group and pet group
	]======]

	enum "GroupType" {
		"NONE",
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

	DEFAULT_CLASS_SORT_ORDER = _G.CLASS_SORT_ORDER or {
		"WARRIOR",
		"DEATHKNIGHT",
		"PALADIN",
		"MONK",
		"PRIEST",
		"SHAMAN",
		"DRUID",
		"ROGUE",
		"MAGE",
		"WARLOCK",
		"HUNTER",
	}
	DEFAULT_ROLE_SORT_ORDER = {"MAINTANK", "MAINASSIST", "TANK", "HEALER", "DAMAGER", "NONE"}
	DEFAULT_GROUP_SORT_ORDER = {1, 2, 3, 4, 5, 6, 7, 8}

	-------------------------------------
	-- Shadow SecureGroupHeader
	-- A shadow refresh system based on the SecureGroupHeaderTemplate
	-------------------------------------
	class "ShadowGroupHeader"
		inherit "Frame"
		extend "IFSecureHandler"

		doc [======[
			@name ShadowGroupHeader
			@type class
			@desc Used to handle the refresh in shadow
		]======]

		_InitHeader = [=[
			Manager = self
			UnitPanel = Manager:GetFrameRef("UnitPanel")

			UnitFrames = newtable()
			ShadowFrames = newtable()

			refreshUnitChange = [[
				local unit = self:GetAttribute("unit")
				local frame = self:GetAttribute("UnitFrame")

				if frame then
					frame:SetAttribute("unit", unit)
				end
			]]
		]=]

		_Onattributechanged = [[
			if name == "unit" then
				if type(value) == "string" then
					value = strlower(value)
				else
					value = nil
				end

				local frame = self:GetAttribute("UnitFrame")

				if frame then
					frame:SetAttribute("unit", value)
				end
			end
		]]

		_InitialConfigFunction = [=[
			tinsert(ShadowFrames, self)

			self:SetWidth(0)
			self:SetHeight(0)

			-- Binding
			local frame = UnitFrames[#ShadowFrames]

			if frame then
				self:SetAttribute("UnitFrame", frame)
			end

			-- Only for the entering game combat
			-- refreshUnitChange won't fire when the unit is set to nil
			self:SetAttribute("refreshUnitChange", refreshUnitChange)

			Manager:CallMethod("ShadowGroupHeader_UpdateUnitCount", #ShadowFrames)
		]=]

		_RegisterUnitFrame = [=[
			local frame = Manager:GetFrameRef("UnitFrame")

			if frame then
				tinsert(UnitFrames, frame)

				-- Binding
				local shadow = ShadowFrames[#UnitFrames]

				if shadow then
					shadow:SetAttribute("UnitFrame", frame)
					frame:SetAttribute("unit", shadow:GetAttribute("unit"))
				end
			end
		]=]

		_ClearAll = [=[
			for i = 1, #ShadowFrames do
				ShadowFrames[i]:SetAttribute("unit", nil)
			end
		]=]

		local function GenerateUnitFrames(self, count)
			-- Init the child
			local child = self:GetAttribute("child"..count)

			if child then
				child:SetAttribute("refreshUnitChange", nil)	-- only used for the entering game combat
				child:SetAttribute("_onattributechanged", _Onattributechanged)
			end

			-- Init the panel
			self = IGAS:GetWrapper(self).Parent

			if self and count and self.Count < count then
				self.Count = count

				--[[for i = 1, self.Count do
					if not self.Element[i]:GetAttribute("unit") then
						self.Element[i]:Hide()
					end
				end--]]
				return self:UpdatePanelSize()
			end
		end

		local function TGenerateUnitFrames(self, count)
			Threading.Sleep(0.1) -- Wait the SecureGroupHeader finished the init

			IFNoCombatTaskHandler._RegisterNoCombatTask(GenerateUnitFrames, self, count)
		end

		local function UpdateUnitCount(self, count)
			if InCombatLockdown() then
				IFNoCombatTaskHandler._RegisterNoCombatTask(GenerateUnitFrames, self, count)
			else
				IGAS:GetWrapper(self):ThreadCall(TGenerateUnitFrames, count)
			end
		end

		------------------------------------------------------
		-- Event
		------------------------------------------------------

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		doc [======[
			@name Refresh
			@type method
			@desc The default refresh method
			@return nil
		]======]
		function Refresh(self)
			if self.Visible then
				-- Well, it's ugly
				self:Hide()
				self:Show()
			end
		end

		doc [======[
			@name RegisterUnitFrame
			@type method
			@desc Register an unit frame
			@return nil
		]======]
		function RegisterUnitFrame(self, frame)
			self:SetFrameRef("UnitFrame", frame)
			self:Execute(_RegisterUnitFrame)
		end

		doc [======[
			@name Activate
			@type method
			@desc Activate the unit panel
			@return nil
		]======]
		function Activate(self)
			if not self.Visible then
				IFNoCombatTaskHandler._RegisterNoCombatTask(function()
					self.Visible = true
				end)
			end
		end

		doc [======[
			@name Deactivate
			@type method
			@desc Deactivate the unit panel
			@return nil
		]======]
		function Deactivate(self)
			if self.Visible then
				IFNoCombatTaskHandler._RegisterNoCombatTask(function()
					self.Visible = false

					self:Execute(_ClearAll)
				end)
			end
		end

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		doc [======[
			@name Activated
			@type property
			@desc Whether the unit panel is activated
		]======]
		property "Activated" {
			Get = function(self)
				return self.Visible
			end,
			Set = function(self, value)
				if value then
					self:Activate()
				else
					self:Deactivate()
				end
			end,
			Type = Boolean,
		}

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
		function Constructor(self, name, parent)
			return CreateFrame("Frame", nil, parent, "SecureGroupHeaderTemplate")
		end

	    function ShadowGroupHeader(self, name, parent)
			IGAS:GetUI(self).ShadowGroupHeader_UpdateUnitCount = UpdateUnitCount

			self:SetAttribute("_ignore", "ShadowGroupHeader")

			self:SetFrameRef("UnitPanel", parent)
    		self:Execute(_InitHeader)

    		self:SetAttribute("template", "SecureHandlerAttributeTemplate")
    		self:SetAttribute("initialConfigFunction", _InitialConfigFunction)
    		self:SetAttribute("strictFiltering", true)
    		self:SetAttribute("groupingOrder", "")

			self:SetAttribute("_ignore", nil)

    		-- Throw out of the screen
    		self:SetPoint("TOPRIGHT", WorldFrame, "TOPLEFT")
    		self.Visible = true
    		self.Alpha = 0
	    end
	endclass "ShadowGroupHeader"

	------------------------------------------------------
	-- Helper functions
	------------------------------------------------------
	_Cache = {}

	local function SecureSetAttribute(self, attr, value)
		IFNoCombatTaskHandler._RegisterNoCombatTask(self.SetAttribute, self, attr, value)
	end

	local function SetupGroupFilter(self)
		local groupFilter = self.GroupFilter or DEFAULT_GROUP_SORT_ORDER
		local classFilter = self.ClassFilter or DEFAULT_CLASS_SORT_ORDER

		wipe(_Cache)

		for _, v in ipairs(groupFilter) do
			tinsert(_Cache, v)
		end

		for _, v in ipairs(classFilter) do
			tinsert(_Cache, v)
		end

		SecureSetAttribute(self.GroupHeader, "groupFilter", table.concat(_Cache, ","))

		wipe(_Cache)
	end

	local function SetupRoleFilter(self)
		local roleFilter = self.RoleFilter or DEFAULT_ROLE_SORT_ORDER

		wipe(_Cache)

		for _, v in ipairs(roleFilter) do
			tinsert(_Cache, v)
		end

		SecureSetAttribute(self.GroupHeader, "roleFilter", table.concat(_Cache, ","))

		wipe(_Cache)
	end

	local function SetupGroupingOrder(self)
		local groupBy = self.GroupBy
		local filter

		if grouBy == "GROUP" then
			filter = self.GroupFilter or DEFAULT_GROUP_SORT_ORDER
		elseif grouBy == "CLASS" then
			filter = self.ClassFilter or DEFAULT_CLASS_SORT_ORDER
		elseif grouBy == "ROLE" or grouBy == "ASSIGNEDROLE" then
			filter = self.RoleFilter or DEFAULT_ROLE_SORT_ORDER
		end

		wipe(_Cache)

		if filter then
			for _, v in ipairs(filter) do
				tinsert(_Cache, v)
			end
		end

		SecureSetAttribute(self.GroupHeader, "groupingOrder", table.concat(_Cache, ","))

		wipe(_Cache)
	end

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Refresh
		@type method
		@desc The default refresh method
		@return nil
	]======]
	function Refresh(self)
		if InCombatLockdown() then return end

		self.GroupHeader:Refresh()

		return self:UpdatePanelSize()
	end

	doc [======[
		@name InitWithCount
		@type method
		@desc Init the unit panel with a unit count
		@param count number, the units count
		@return nil
	]======]
	function InitWithCount(self, count)
		IFNoCombatTaskHandler._RegisterNoCombatTask(function()
			self.Count = count

			self:Each("SetAttribute", "unit", nil)

			self:Refresh()
		end)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Activated
		@type property
		@desc Whether the unit panel is activated
	]======]
	property "Activated" {
		Get = function(self)
			return self.GroupHeader.Activated
		end,
		Set = function(self, value)
			self.GroupHeader.Activated = value
		end,
		Type = Boolean,
	}

	doc [======[
		@name ShowRaid
		@type property
		@desc Whether the panel should be shown while in a raid
	]======]
	property "ShowRaid" {
		Get = function(self)
			return self.GroupHeader:GetAttribute("showRaid") or false
		end,
		Set = function(self, value)
			SecureSetAttribute(self.GroupHeader, "showRaid", value)
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
			return self.GroupHeader:GetAttribute("showParty") or false
		end,
		Set = function(self, value)
			SecureSetAttribute(self.GroupHeader, "showParty", value)
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
			return self.GroupHeader:GetAttribute("showPlayer") or false
		end,
		Set = function(self, value)
			SecureSetAttribute(self.GroupHeader, "showPlayer", value)
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
			return self.GroupHeader:GetAttribute("showSolo") or false
		end,
		Set = function(self, value)
			SecureSetAttribute(self.GroupHeader, "showSolo", value)
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
			if value and not next(value) then value = nil end

			self.__GroupFilter = value

			SetupGroupFilter(self)

			if self.GroupBy == "GROUP" then
				SetupGroupingOrder(self)
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
			if value and not next(value) then value = nil end

			self.__ClassFilter = value

			SetupGroupFilter(self)

			if self.GroupBy == "CLASS" then
				SetupGroupingOrder(self)
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
			if value and not next(value) then value = nil end

			self.__RoleFilter = value

			SetupRoleFilter(self)

			if self.GroupBy == "ROLE" or self.GroupBy == "ASSIGNEDROLE" then
				SetupGroupingOrder(self)
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
			return self.__GroupBy or "NONE"
		end,
		Set = function(self, value)
			self.__GroupBy = value

			SecureSetAttribute(self.GroupHeader, "groupBy", value)

			SetupGroupingOrder(self)
		end,
		Type = GroupType,
	}

	doc [======[
		@name SortBy
		@type property
		@desc Defines how the group is sorted (Default: "INDEX")
	]======]
	property "SortBy" {
		Get = function(self)
			return self.GroupHeader:GetAttribute("sortMethod") or "INDEX"
		end,
		Set = function(self, value)
			SecureSetAttribute(self.GroupHeader, "sortMethod", value)
		end,
		Type = SortType,
	}

	doc [======[
		@name GroupHeader
		@type property
		@desc The group header based on the blizzard's SecureGroupHeader
	]======]
	property "GroupHeader" {
		Get = function(self)
			return self:GetChild("ShadowGroupHeader") or ShadowGroupHeader("ShadowGroupHeader", self)
		end,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnElementAdd(self, element)
		self.GroupHeader:RegisterUnitFrame(element)
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFGroup(self)
		self.OnElementAdd = self.OnElementAdd + OnElementAdd

		SetupGroupFilter(self)
	end
endinterface "IFGroup"