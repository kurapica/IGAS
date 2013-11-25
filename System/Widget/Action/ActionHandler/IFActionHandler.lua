-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.IFActionHandler", version) then
	return
end

_FlashInterval = 0.4
_UpdateRangeInterval = 0.2

enum "ActionType" {
	"action",
	--"bag",
	--"bagslot",
	--"inventory",
	"item",
	"macro",
	"macrotext",
	--"merchant",
	"pet",
	"petaction",
	--"money",
	"spell",
	"flyout",
	"companion",
	"equipmentset",
	"battlepet",
	"worldmarker",
	"custom",
}

------------------------------------------------------
-- Module
--
-- DB :
--		_DBCharNoDrag
--		_DBCharUseDown
--
-- Function List :
--		GetGroup(group) : True Group name
------------------------------------------------------
do
	_GlobalGroup = "Global"

	function GetGroup(group)
		return tostring(type(group) == "string" and strtrim(group) ~= "" and strtrim(group) or _GlobalGroup):upper()
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	function OnLoad(self)
		-- DB
		IGAS_DB_Char.Action_IFActionHandler_DB = IGAS_DB_Char.Action_IFActionHandler_DB or {}
		IGAS_DB_Char.Action_IFActionHandler_DB.NoDragGroup = IGAS_DB_Char.Action_IFActionHandler_DB.NoDragGroup or {}
		IGAS_DB_Char.Action_IFActionHandler_DB.UseDownGroup = IGAS_DB_Char.Action_IFActionHandler_DB.UseDownGroup or {}

		_DBCharNoDrag = IGAS_DB_Char.Action_IFActionHandler_DB.NoDragGroup
		_DBCharUseDown = IGAS_DB_Char.Action_IFActionHandler_DB.UseDownGroup
	end

	function OnEnable(self)
		for grp in pairs(_DBCharNoDrag) do
			IFNoCombatTaskHandler._RegisterNoCombatTask(DisableDrag, grp)
		end
	end
end

------------------------------------------------------
-- IFActionTypeHandler
--
------------------------------------------------------
interface "IFActionTypeHandler"

	doc [======[
		@name IFActionTypeHandler
		@type interface
		@desc Interface for action type handlers
	]======]

	_IFActionTypeHandler = {}

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Refresh
		@type method
		@desc Refresh all action buttons of the same action type
		@return nil
	]======]
	function Refresh(self)
		_IFActionHandler_Buttons:EachK(self.Type, UpdateActionButton)
	end

	doc [======[
		@name RunSnippet
		@type method
		@desc Run the snippet in the global environment
		@param code the snippet
		@return nil
	]======]
	function RunSnippet(self, code)
		IFNoCombatTaskHandler._RegisterNoCombatTask(
			SecureFrame.Execute, _IFActionHandler_ManagerFrame, code
		end)
	end

	------------------------------------------------------
	-- Overridable Method
	------------------------------------------------------
	doc [======[
		@name HasAction
		@type method
		@desc Whether the action button has an action
		@return boolean
	]======]
	function HasAction(self)
		return true
	end

	doc [======[
		@name GetActionText
		@type method
		@desc Get the action's text
		@return string
	]======]
	function GetActionText(self)
		return ""
	end

	doc [======[
		@name GetActionTexture
		@type method
		@desc Get the action's texture
		@return string
	]======]
	function GetActionTexture(self)
	end

	doc [======[
		@name GetActionCharges
		@type method
		@desc Get the action's charges
		@return number
	]======]
	function GetActionCharges(self)
	end

	doc [======[
		@name GetActionCount
		@type method
		@desc Get the action's count
		@return number
	]======]
	function GetActionCount(self)
		return 0
	end

	doc [======[
		@name GetActionCooldown
		@type method
		@desc Get the action's cooldown
		@return start, duration, enable
	]======]
	function GetActionCooldown(self)
		return 0, 0, 0
	end

	doc [======[
		@name IsAttackAction
		@type method
		@desc Whether the action is attackable
		@return boolean
	]======]
	function IsAttackAction(self)
		return false
	end

	doc [======[
		@name IsEquippedItem
		@type method
		@desc Whether the action is an item and can be equipped
		@return boolean
	]======]
	function IsEquippedItem(self)
		return false
	end

	doc [======[
		@name IsActivedAction
		@type method
		@desc Whether the action is actived
		@return boolean
	]======]
	function IsActivedAction(self)
		return false
	end

	doc [======[
		@name IsAutoRepeatAction
		@type method
		@desc Whether the action is auto-repeat
		@return boolean
	]======]
	function IsAutoRepeatAction(self)
		return false
	end

	doc [======[
		@name IsUsableAction
		@type method
		@desc Whether the action is usable
		@return boolean
	]======]
	function IsUsableAction(self)
		return true
	end

	doc [======[
		@name IsConsumableAction
		@type method
		@desc Whether the action is consumable
		@return boolean
	]======]
	function IsConsumableAction(self)
		return false
	end

	doc [======[
		@name IsInRange
		@type method
		@desc Whether the action is in range of the target
		@return boolean
	]======]
	function IsInRange(self)
		return false
	end

	doc [======[
		@name IsAutoCastAction
		@type method
		@desc Whether the action is auto-castable
		@return boolean
	]======]
	function IsAutoCastAction(self)
		return false
	end

	doc [======[
		@name IsAutoCasting
		@type method
		@desc Whether the action is auto-casting now
		@return boolean
	]======]
	function IsAutoCasting(self)
		return false
	end

	doc [======[
		@name SetTooltip
		@type method
		@desc Show the tooltip for the action
		@param GameTooltip
		@return boolean
	]======]
	function SetTooltip(self, GameTooltip)
	end

	doc [======[
		@name GetSpellId
		@type method
		@desc Get the spell id of the action
		@return number
	]======]
	function GetSpellId(self)
	end

	doc [======[
		@name IsFlyout
		@type method
		@desc Whether the action is a flyout spell
		@return boolean
	]======]
	function IsFlyout(self)
		return false
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Type
		@type property
		@desc The action type's name
	]======]
	property "Type" { Type = String }

	doc [======[
		@name Action
		@type property
		@desc The action attribute value
	]======]
	property "Action" { Type = String }

	doc [======[
		@name InitSnippet
		@type property
		@desc The snippet to setup environment for the action type
	]======]
	property "InitSnippet" { Type = String + nil }

	doc [======[
		@name PickupSnippet
		@type property
		@desc The snippet used when pick up action
	]======]
	property "PickupSnippet" { Type = String + nil }

	doc [======[
		@name UpdateSnippet
		@type property
		@desc The snippet used to update for new action settings
	]======]
	property "UpdateSnippet" { Type = String + nil }

	doc [======[
		@name ReceiveSnippet
		@type property
		@desc The snippet used to receive action
	]======]
	property "ReceiveSnippet" { Type = String + nil }

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFActionTypeHandler(self)
    	-- Register the action type handler
    	_IFActionTypeHandler[self.Type] = self

		-- Init the environment
		if self.InitSnippet then self:RunSnippet( self.InitSnippet ) end
    end
endinterface "IFActionTypeHandler"

------------------------------------------------------
-- ActionTypeHandler
--
------------------------------------------------------
class "ActionTypeHandler"
	extend "IFActionTypeHandler"

	doc [======[
		@name ActionTypeHandler
		@type class
		@desc The handler for each action types
	]======]

	------------------------------------------------------
	-- Meta-methods
	------------------------------------------------------
	function __call(self)
		return _IFActionHandler_Buttons(self.Type)
	end
endclass "ActionTypeHandler"

------------------------------------------------------
-- ActionList
--
------------------------------------------------------
class "ActionList"
	extend "IFIterator"

	local function nextLink(data, kind)
		if type(kind) ~= "table" then
			return data[kind], data[kind]
		else
			return kind.__ActionList_Next, kind.__ActionList_Next
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Insert action button to the list
	-- @name Insert
	-- @type function
	-- @param frame
	------------------------------------
	function Insert(self, frame)
		tinsert(self, frame)
	end

	------------------------------------
	--- Remove action button from the list
	-- @name Remove
	-- @type function
	-- @param frame
	------------------------------------
	function Remove(self, frame)
		for i, v in ipairs(self) do
			if v == frame then
				self[v] = nil
				tremove(self, i)
				break
			end
		end
	end

	------------------------------------
	--- Get the next element, Overridable
	-- @name Next
	-- @class function
	-- @param kind
	-- @return nextFunc
	-- @return self
	-- @return firstKey
	------------------------------------
	function Next(self, kind)
		if type(kind) == "string" then
			return nextLink, self, type(kind) == "string" and kind:lower()
		else
			return ipairs(self)
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------

	------------------------------------------------------
	-- MetaMethod
	------------------------------------------------------
	function __index(self, kind)
		if type(kind) == "string" then
			return rawget(self, kind:lower())
		end
	end

	function __newindex(self, frame, kind)
		if type(frame) == "string" and type(kind) == "function" then
			rawset(self, frame, kind)
			return
		end

		if type(frame) ~= "table" then
			error("key must be a table.", 2)
		end

		if kind ~= nil and ( type(kind) ~= "string" or kind:match("^__") ) then
			error("value not supported.", 2)
		end

		kind = kind and kind:lower()

		local preKey = "__ActionList_Prev"
		local nxtKey = "__ActionList_Next"

		local prev = frame[preKey]
		local next = frame[nxtKey]
		local header = prev

		while type(header) == "table" do
			header = header[preKey]
		end

		-- no change
		if header == kind then
			return
		end

		-- Remove link
		if header then
			if prev == header then
				rawset(self, header, next)
				if next then next[preKey] = prev end
			else
				prev[nxtKey] = next
				if next then next[preKey] = prev end
			end

			frame[preKey] = nil
			frame[nxtKey] = nil
		end

		-- Add link
		if kind then
			local tail = self[kind]

			rawset(self, kind, frame)
			frame[preKey] = kind

			if tail then
				tail[preKey] = frame
				frame[nxtKey] = tail
			end
		end
	end

	function __call(self, kind)
		if type(kind) == "string" then
			return nextLink, self, type(kind) == "string" and kind:lower()
		else
			return ipairs(self)
		end
	end
endclass "ActionList"

------------------------------------------------------
-- Action Manager
--
------------------------------------------------------
do
	_GameTooltip = _G.GameTooltip

	-- Object Array
	_IFActionHandler_Buttons = ActionList()

	-- Manager Frame
	_IFActionHandler_ManagerFrame = SecureFrame("IGAS_IFActionHandler_Manager", IGAS.UIParent, "SecureHandlerStateTemplate")
	_IFActionHandler_ManagerFrame.Visible = false

	IGAS:GetUI(_IFActionHandler_ManagerFrame).OnPickUp = function (self, kind, target)
		if not InCombatLockdown() then
			return PickupAny("clear", kind, target)
		end
	end

	-- Recycle
	_RecycleAlert = Recycle(SpellActivationAlert, "SpellActivationAlert%d", _IFActionHandler_ManagerFrame)

	-- Timer
	_IFActionHandler_UpdateRangeTimer = Timer("RangeTimer", _IFActionHandler_ManagerFrame)
	_IFActionHandler_UpdateRangeTimer.Enabled = false
	_IFActionHandler_UpdateRangeTimer.Interval = _UpdateRangeInterval

	_IFActionHandler_FlashingTimer = Timer("FlashingTimer", _IFActionHandler_ManagerFrame)
	_IFActionHandler_FlashingTimer.Enabled = false
	_IFActionHandler_FlashingTimer.Interval = _FlashInterval

	_IFActionHandler_FlashingList = {}

	_IFActionHandler_EquipSetTemplate = "IFActionHandler_EquipSet[%q] = %d\n"
	_IFActionHandler_FlyoutSlotTemplate = "IFActionHandler_FlyoutSlot[%d] = %d\n"
	_IFActionHandler_StanceMapTemplate = "IFActionHandler_StanceMap[%d] = %d\n"
	_IFActionHandler_MountMapTemplate = "IFActionHandler_MountMap[%d] = %d\n"
	_IFActionHandler_MountCastTemplate = "/run if not InCombatLockdown() then if select(5, GetCompanionInfo('MOUNT', %d)) then DismissCompanion('MOUNT') else CallCompanion('MOUNT', %d) end end"

	_IFActionHandler_EquipSetMap = _IFActionHandler_EquipSetMap or {}
	_IFActionHandler_FlyoutSlot = _IFActionHandler_FlyoutSlot or {}
	_IFActionHandler_FlyoutTexture = _IFActionHandler_FlyoutTexture or {}
	_IFActionHandler_StanceMap = _IFActionHandler_StanceMap or {}
	_IFActionHandler_Profession = _IFActionHandler_Profession or {}
	_IFActionHandler_MountMap = _IFActionHandler_MountMap or {}

	------------------------------------------------------
	-- Snippet Definition
	------------------------------------------------------
	-- Init manger frame's enviroment
	IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
		_IFActionHandler_ManagerFrame:Execute[[
			IFActionHandler_NoDraggable = newtable()
			IFActionHandler_EquipSet = newtable()
			IFActionHandler_FlyoutSlot = newtable()
			IFActionHandler_MainPage = newtable()
			IFActionHandler_StanceMap = newtable()
			IFActionHandler_MountMap = newtable()

			IFActionHandler_MountCastTemplate = "/run if not InCombatLockdown() then if select(5, GetCompanionInfo('MOUNT', %d)) then DismissCompanion('MOUNT') else CallCompanion('MOUNT', %d) end end"

			NUM_ACTIONBAR_BUTTONS = 12

			-- to fix blz error, use Manager not control
			Manager = self

			MainPage = newtable()

			PickupAction = [=[
				local kind, target = ...
				if kind == "action" then
					return kind, target
				elseif kind == "pet" then
					return "petaction", target
				elseif kind == "companion" then
					return "clear", kind, "mount", IFActionHandler_MountMap[target]
				elseif kind == "spell" or kind == "item" or kind == "macro" or kind == "battlepet" or kind == "flyout" then
					return "clear", kind, target
				elseif kind == "equipmentset" then
					return "clear", kind, IFActionHandler_EquipSet[target]
				else
					return "clear"
				end
			]=]

			UpdateAction = [=[
				local kind, target = ...

				-- Clear prev settings
				self:SetAttribute("*type*", nil)
				self:SetAttribute("*macrotext*", nil)
				self:SetAttribute("type1", nil)
				self:SetAttribute("macrotext1", nil)
				self:SetAttribute("type2", nil)
				self:SetAttribute("macrotext2", nil)

				if kind == "spell" and IFActionHandler_StanceMap[target] then
					-- Need this to cancel stance, use spell to replace stance button
					self:SetAttribute("*type*", "macro")
					self:SetAttribute("*macrotext*", "/click StanceButton".. IFActionHandler_StanceMap[target])
				elseif kind == "battlepet" then
					-- just *type* to keep type to battlepet
					self:SetAttribute("*type*", "macro")
					self:SetAttribute("*macrotext*", "/summonpet "..target)
				elseif kind == "equipmentset" then
					self:SetAttribute("*type*", "macro")
					self:SetAttribute("*macrotext*", "/equipset "..target)
				elseif kind == "companion" then
					self:SetAttribute("*type*", "macro")
					local index = IFActionHandler_MountMap[target]
					self:SetAttribute("*macrotext*", IFActionHandler_MountCastTemplate:format(index, index))
				elseif (kind == "pet" or kind == "petaction") and tonumber(target) then
					-- Use macro to toggle auto cast
					self:SetAttribute("type2", "macro")
					self:SetAttribute("macrotext2", "/click PetActionButton".. target .. " RightButton")
				end

				self:CallMethod("IFActionHandler_UpdateAction", kind, target)
			]=]

			DragStart = [=[
				local kind = self:GetAttribute("type")

				if not kind or kind == "" or kind == "custom" or kind == "worldmarker" then return false end

				local type = kind == "pet" and "action" or kind == "flyout" and "spell" or kind
				local target = self:GetAttribute(type)

				if not target then return false end

				if kind ~= "action" and kind ~= "pet" then
					self:SetAttribute("type", nil)
					self:SetAttribute(type, nil)
					Manager:RunFor(self, UpdateAction, nil, nil)
				else
					Manager:RunFor(self, UpdateAction, kind, target)
				end

				if kind == "action" and self:GetAttribute("actionpage") and self:GetID() > 0 then
					target = self:GetID() + (tonumber(self:GetAttribute("actionpage"))-1) * NUM_ACTIONBAR_BUTTONS
				end

				if kind == "battlepet" or kind == "flyout" then
					Manager:CallMethod("OnPickUp", kind, target)
					return false
				end

				return Manager:Run(PickupAction, kind, target)
			]=]

			ReceiveDrag = [=[
				local kind, value, detail, extra = ...

				if not kind or not value then return false end

				local type = kind == "pet" and "action" or kind == "flyout" and "spell" or kind

				local oldKind = self:GetAttribute("type")
				local oldType = oldKind == "pet" and "action" or oldKind == "flyout" and "spell" or oldKind
				local oldTarget = oldType and self:GetAttribute(oldType)

				if oldKind == "custom" or oldKind == "worldmarker" then return false end

				if oldKind ~= "action" and oldKind ~= "pet" then
					if oldKind then
						self:SetAttribute("type", nil)
						self:SetAttribute(oldType, nil)
						if oldKind == "macro" then
							self:SetAttribute("macrotext", nil)
						end
					end

					if kind == "spell" then
						value = extra
					elseif kind == "item" and value then
						value = "item:"..value
					elseif kind == "companion" then
						local mount
						for spell, index in pairs(IFActionHandler_MountMap) do
							if value == index then
								mount = spell
								break
							end
						end
						value = mount
						if not value then
							kind = nil
						end
					end

					self:SetAttribute("type", kind)
					self:SetAttribute(type, value)

					Manager:RunFor(self, UpdateAction, kind, value)
				else
					Manager:RunFor(self, UpdateAction, oldKind, oldTarget)
				end

				if oldKind == "action" and self:GetAttribute("actionpage") and self:GetID() > 0 then
					oldTarget = self:GetID() + (tonumber(self:GetAttribute("actionpage"))-1) * NUM_ACTIONBAR_BUTTONS
				end

				if oldKind == "battlepet" or oldKind == "flyout" then
					Manager:CallMethod("OnPickUp", oldKind, oldTarget)
					return false
				end

				return Manager:Run(PickupAction, oldKind, oldTarget)
			]=]

			UpdateMainActionBar = [=[
				local page = ...
				if page == "tempshapeshift" then
					if HasTempShapeshiftActionBar() then
						page = GetTempShapeshiftBarIndex()
					else
						page = 1
					end
				elseif page == "possess" then
					page = Manager:GetFrameRef("MainMenuBarArtFrame"):GetAttribute("actionpage")
					if page <= 10 then
						page = Manager:GetFrameRef("OverrideActionBar"):GetAttribute("actionpage")
					end
					if page <= 10 then
						page = 12
					end
				end
				MainPage[0] = page
				for btn in pairs(IFActionHandler_MainPage) do
					btn:SetAttribute("actionpage", MainPage[0])
					Manager:RunFor(btn, UpdateAction, "action", btn:GetID() or 1)
				end
			]=]
		]]

		_IFActionHandler_ManagerFrame:SetFrameRef("MainMenuBarArtFrame", MainMenuBarArtFrame)
		_IFActionHandler_ManagerFrame:SetFrameRef("OverrideActionBar", OverrideActionBar)

		-- ActionBar swap register
		local state = {}

		-- special using
		tinsert(state, "[overridebar][possessbar]possess")

		-- action bar swap
		for i = 2, 6 do
			tinsert(state, ("[bar:%d]%d"):format(i, i))
		end

		-- stance
		local _, playerclass = UnitClass("player")

		if playerclass == "DRUID" then
			-- prowl first
			tinsert(state, "[bonusbar:1,stealth]8")
		elseif playerclass == "WARRIOR" then
			tinsert(state, "[stance:2]7")
			tinsert(state, "[stance:3]8")
		end

		-- bonusbar map
		for i = 1, 4 do
			tinsert(state, ("[bonusbar:%d]%d"):format(i, i+6))
		end

		-- Fix for temp shape shift bar
		tinsert(state, "[stance:1]tempshapeshift")

		tinsert(state, "1")

		state = table.concat(state, ";")

		local now = SecureCmdOptionParse(state)

		_IFActionHandler_ManagerFrame:Execute(("MainPage[0] = %s"):format(now))

		_IFActionHandler_ManagerFrame:RegisterStateDriver("page", state)

		_IFActionHandler_ManagerFrame:SetAttribute("_onstate-page", [=[
			Manager:Run(UpdateMainActionBar, newstate)
		]=])
	end)

	_IFActionHandler_InsertManager = [=[
		IFActionHandler_Manager = self:GetFrameRef("IFActionHandler_Manager")
	]=]

	_IFActionHandler_UpdateActionAttribute = [=[
		local kind, target = ...

		-- Clear
		local oldKind = self:GetAttribute("type")
		if oldKind then
			self:SetAttribute("type", nil)
			self:SetAttribute(oldKind == "pet" and "action" or oldKind == "flyout" and "spell" or oldKind == "worldmarker" and "marker" or oldKind, nil)
			if oldKind == "macro" then
				self:SetAttribute("macrotext", nil)
			end
			if oldKind == "worldmarker" then
				self:SetAttribute("action", nil)
			end
		end

		if not target then
			kind = nil
		end

		if kind then
			self:SetAttribute("type", kind == "macrotext" and "macro" or kind)
			if kind ~= "custom" then
				if kind == "item" then
					target = tonumber(target) and "item:"..tonumber(target) or target
				end
				self:SetAttribute(kind == "pet" and "action" or kind == "flyout" and "spell" or kind == "worldmarker" and "marker" or kind, target)
			end
		end

		if IFActionHandler_Manager then
			IFActionHandler_Manager:RunFor(self, "Manager:RunFor(self, UpdateAction, ...)", kind, target)
		end
	]=]

	_IFActionHandler_EnableSnippet = [[
		IFActionHandler_NoDraggable[%q] = nil
	]]

	_IFActionHandler_DisableSnippet = [[
		IFActionHandler_NoDraggable[%q] = true
	]]

	_IFActionHandler_RegisterMainPage = [[
		local btn = Manager:GetFrameRef("MainPageButton")
		if btn then
			IFActionHandler_MainPage[btn] = true
			btn:SetAttribute("actionpage", MainPage[0] or 1)
		end
	]]

	_IFActionHandler_UnregisterMainPage = [[
		local btn = Manager:GetFrameRef("MainPageButton")
		if btn then
			IFActionHandler_MainPage[btn] = nil
			btn:SetAttribute("actionpage", nil)
		end
	]]

	-- Skip macrotext since this is only for draggable item
	_IFActionHandler_OnDragStartSnippet = [[
		if (IsModifierKeyDown() or IFActionHandler_NoDraggable[%q]) and not IsModifiedClick("PICKUPACTION") then return false end

		return Manager:RunFor(self, DragStart)
	]]

	_IFActionHandler_OnReceiveDragSnippet = [[
		return Manager:RunFor(self, ReceiveDrag, kind, value, ...)
	]]

	_IFActionHandler_PostReceiveSnippet = [[
		return Manager:RunFor(Manager:GetFrameRef("UpdatingButton"), ReceiveDrag, %s, %s, %s, %s)
	]]

	_IFActionHandler_UpdateActionSnippet = [[
		return Manager:RunFor(Manager:GetFrameRef("UpdatingButton"), UpdateAction, %s, %s)
	]]

	_IFActionHandler_WrapClickPrev = [[
		if self:GetAttribute("type") == "action" or self:GetAttribute("type") == "pet" then
			local type, action = GetActionInfo(self:GetAttribute("action"))
			return nil, format("%s|%s", tostring(type), tostring(action))
		end
	]]

	_IFActionHandler_WrapClickPost = [[
		local type, action = GetActionInfo(self:GetAttribute("action"))
		if message ~= format("%s|%s", tostring(type), tostring(action)) then
			Manager:RunFor(self, UpdateAction, self:GetAttribute("type"), self:GetAttribute("action"))
		end
	]]

	_IFActionHandler_WrapDragPrev = [[
		return "message", "update"
	]]

	_IFActionHandler_WrapDragPost = [[
		local type = self:GetAttribute("type")
		local target = type and self:GetAttribute(type=="pet" and "action" or type=="flyout" and "spell" or type)
		Manager:RunFor(self, UpdateAction, type, target)
	]]

	------------------------------------------------------
	-- Action Info function
	------------------------------------------------------
	function _HasAction(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return HasAction(target)
		elseif kind == "pet" or kind == "petaction" then
			return GetPetActionInfo(target) and true
		elseif kind and kind ~= "" then
			return true
		end
	end

	function _GetActionText(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return GetActionText(target)
		elseif kind == "macro" then
			return (GetMacroInfo(target))
		elseif kind == "equipmentset" then
			return target
		else
			return ""
		end
	end

	function _GetActionTexture(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return GetActionTexture(target)
		elseif kind == "pet" or kind == "petaction" then
			local name, _, texture, isToken = GetPetActionInfo(target)
			if name then
				return isToken and _G[texture] or texture
			end
		elseif kind == "spell" then
			if _IFActionHandler_StanceMap[target] then
				return (GetShapeshiftFormInfo(_IFActionHandler_StanceMap[target]))
			else
				return GetSpellTexture(target)
			end
		elseif kind == "flyout" then
			return _IFActionHandler_FlyoutTexture[target]
		elseif kind == "item" then
			return GetItemIcon(target)
		elseif kind == "macro" then
			return (select(2, GetMacroInfo(target)))
		elseif kind == "companion" then
			if _IFActionHandler_MountMap[target] then
				return select(4, GetCompanionInfo("MOUNT", _IFActionHandler_MountMap[target]))
			end
		elseif kind == "equipmentset" then
			return _IFActionHandler_EquipSetMap[target] and select(2, GetEquipmentSetInfo(_IFActionHandler_EquipSetMap[target]))
		elseif kind == "battlepet" then
			return select(9, C_PetJournal.GetPetInfoByPetID(target))
		elseif kind == "worldmarker" then
			return _WorldMarker[tonumber(target)]
		else
			return self.__IFActionHandler_Texture
		end
	end

	function _GetActionCharges(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return GetActionCharges(target)
		elseif kind == "spell" then
			return GetSpellCharges(target)
		end
	end

	function _GetActionCount(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return GetActionCount(target)
		elseif kind == "spell" then
			return GetSpellCount(target)
		elseif kind == "item" then
			return GetItemCount(target)
		else
			return 0
		end
	end

	function _GetActionCooldown(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return GetActionCooldown(target)
		elseif kind == "pet" or kind == "petaction" then
			return GetPetActionCooldown(target)
		elseif kind == "spell" then
			if _IFActionHandler_StanceMap[target] then
				if select(2, GetSpellCooldown(target)) > 2 then
					return GetSpellCooldown(target)
				end
			else
				return GetSpellCooldown(target)
			end
		elseif kind == "item" then
			return GetItemCooldown(target)
		else
			return 0, 0, 0
		end
	end

	function _IsAttackAction(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return IsAttackAction(target)
		elseif kind == "spell" then
			return IsAttackSpell(GetSpellInfo(target))
		end
	end

	function _IsEquippedItem(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return IsEquippedAction(target)
		elseif kind == "item" then
			return IsEquippedItem(target)
		elseif kind == "equipmentset" then
			return true
		end
	end

	function _IsActivedAction(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return IsCurrentAction(target)
		elseif kind == "spell" then
			return IsCurrentSpell(target)
		elseif kind == "item" then
			return IsCurrentItem(target)
		elseif kind == "equipmentset" then
			return _IFActionHandler_EquipSetMap[target] and select(4, GetEquipmentSetInfo(_IFActionHandler_EquipSetMap[target]))
		elseif kind == "companion" then
			return _IFActionHandler_MountMap[target] and select(5, GetCompanionInfo("MOUNT", _IFActionHandler_MountMap[target]))
		elseif kind == "worldmarker" then
			target = tonumber(target)
			-- No event for world marker, disable it now
			return false and target and target >= 1 and target <= NUM_WORLD_RAID_MARKERS and IsRaidMarkerActive(target)
		end
	end

	function _IsAutoRepeatAction(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return IsAutoRepeatAction(target)
		elseif kind == "spell" then
			return IsAutoRepeatSpell(GetSpellInfo(target))
		end
	end

	function _IsUsableAction(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return IsUsableAction(target)
		elseif kind == "pet" or kind == "petaction" then
			return GetPetActionSlotUsable(target)
		elseif kind == "spell" then
			if _IFActionHandler_StanceMap[target] then
				return select(4, GetShapeshiftFormInfo(_IFActionHandler_StanceMap[target]))
			else
				return IsUsableSpell(target)
			end
		elseif kind == "item" then
			return IsUsableItem(target)
		elseif kind == "companion" then
			return IsUsableSpell(target)
		elseif kind and kind ~= "" then
			return true
		end
	end

	function _IsConsumableAction(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return IsConsumableAction(target) or IsStackableAction(target) or (not IsItemAction(target) and GetActionCount(target) > 0)
		elseif kind == "spell" then
			return IsConsumableSpell(target)
		elseif kind == "item" then
			-- return IsConsumableItem(target) blz sucks, wait until IsConsumableItem is fixed
			local _, _, _, _, _, _, _, maxStack = GetItemInfo(target)

			if IsUsableItem(target) and maxStack and maxStack > 1 then
				return true
			else
				return false
			end
		end
	end

	function _IsInRange(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			return IsActionInRange(target, self:GetAttribute("unit"))
		elseif kind == "spell" then
			return IsSpellInRange(GetSpellInfo(target), self:GetAttribute("unit"))
		elseif kind == "item" then
			return IsItemInRange(target, self:GetAttribute("unit"))
		end
	end

	function _IsAutoCastAction(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "pet" or kind == "petaction" then
			return select(6, GetPetActionInfo(target))
		else
			return false
		end
	end

	function _IsAutoCasting(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "pet" or kind == "petaction" then
			return select(7, GetPetActionInfo(target))
		else
			return false
		end
	end

	function _SetTooltip(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			_GameTooltip:SetAction(target)
		elseif kind == "pet" or kind == "petaction" then
			_GameTooltip:SetPetAction(target)
		elseif kind == "spell" then
			_GameTooltip:SetSpellByID(target)
		elseif kind == "flyout" then
			_GameTooltip:SetSpellBookItem(_IFActionHandler_FlyoutSlot[target], "spell")
		elseif kind == "item" then
			_GameTooltip:SetHyperlink(select(2, GetItemInfo(target)))
		elseif kind == "companion" then
			if _IFActionHandler_MountMap[target] then
				_GameTooltip:SetSpellByID(select(3, GetCompanionInfo("MOUNT", _IFActionHandler_MountMap[target])))
			end
		elseif kind == "equipmentset" then
			_GameTooltip:SetEquipmentSet(target)
		elseif kind == "battlepet" then
			local speciesID, _, _, _, _, _, _, name, _, _, _, sourceText, description, _, _, tradable, unique = C_PetJournal.GetPetInfoByPetID(target)

			if speciesID then
				_GameTooltip:SetText(name, 1, 1, 1)

				if sourceText and sourceText ~= "" then
					_GameTooltip:AddLine(sourceText, 1, 1, 1, true)
				end

				if description and description ~= "" then
					_GameTooltip:AddLine(" ")
					_GameTooltip:AddLine(description, nil, nil, nil, true)
				end
				_GameTooltip:Show()
			end
		elseif self.__IFActionHandler_Tooltip then
			_GameTooltip:SetText(self.__IFActionHandler_Tooltip)
		end
	end

	function _GetSpellId(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "action" then
			local type, id = GetActionInfo(target)
			if type == "spell" then
				return id
			elseif type == "macro" then
				return (select(3, GetMacroSpell(id)))
			end
		elseif kind == "spell" then
			return target
		end
	end

	function _IsFlyout(self)
		local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
		if kind == "flyout" then
			return true
		end
	end

	------------------------------------------------------
	-- Action Script Hanlder
	------------------------------------------------------
	function PreClick(self)
		if self:GetAttribute("type") == "action" or self:GetAttribute("type") == "pet" or self:GetAttribute("type") == "custom" or InCombatLockdown() then
			return
		end

		local kind, value = GetCursorInfo()
		if not kind or not value then return end

		self.__IFActionHandler_PreType = self:GetAttribute("type")
		self.__IFActionHandler_PreMsg = true
		self:SetAttribute("type", nil)
	end

	function GetFormatString(param)
		return type(param) == "string" and ("%q"):format(param) or tostring(param)
	end

	function PickupAny(kind, target, detail, ...)
		if (kind == "clear") then
			ClearCursor()
			kind, target, detail = target, detail, ...
		end

		if kind == 'action' then
			PickupAction(target)
		elseif kind == 'bag' then
			PickupBagFromSlot(target)
		elseif kind == 'bagslot' then
			PickupContainerItem(target, detail)
		elseif kind == 'inventory' then
			PickupInventoryItem(target)
		elseif kind == 'item' then
			PickupItem(target)
		elseif kind == 'macro' then
			PickupMacro(target)
		elseif kind == 'merchant' then
			PickupMerchantItem(target)
		elseif kind == 'petaction' then
			PickupPetAction(target)
		elseif kind == 'money' then
			PickupPlayerMoney(target)
		elseif kind == 'spell' then
			PickupSpell(target)
		elseif kind == "flyout" then
			PickupSpellBookItem(_IFActionHandler_FlyoutSlot[target], "spell")
		elseif kind == 'companion' then
			if _IFActionHandler_MountMap[target] then
				PickupCompanion('mount', _IFActionHandler_MountMap[target])
			end
		elseif kind == 'equipmentset' then
			local index = 1
			while GetEquipmentSetInfo(index) do
				if GetEquipmentSetInfo(index) == target then
					PickupEquipmentSet(index)
					break
				end
				index = index + 1
			end
		elseif kind == "battlepet" then
			C_PetJournal.PickupPet(target)
		end
	end

	function PostClick(self)
		UpdateButtonState(self)
		if self.__IFActionHandler_PreMsg and not InCombatLockdown() then
			if self.__IFActionHandler_PreType then
				self:SetAttribute("type", self.__IFActionHandler_PreType)
			end

			local kind, value, subtype, detail = GetCursorInfo()

			if kind and value then
				local oldKind = self:GetAttribute("type")
				local oldAction = oldKind and self:GetAttribute(oldKind=="flyout" and "spell" or oldKind)

				_IFActionHandler_ManagerFrame:SetFrameRef("UpdatingButton", self)
				_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_PostReceiveSnippet:format(GetFormatString(kind), GetFormatString(value), GetFormatString(subtype), GetFormatString(detail)))
				PickupAny("clear", oldKind, oldAction)
			end
		end
		self.__IFActionHandler_PreType = nil
		self.__IFActionHandler_PreMsg = nil
	end

	_IFActionHandler_OnTooltip = nil

	function OnEnter(self)
		UpdateTooltip(self)
	end

	function OnLeave(self)
		_IFActionHandler_OnTooltip = nil
		_GameTooltip:Hide()
	end

	function EnableDrag(group)
		group = GetGroup(group)

		_DBCharNoDrag[group] = nil
		_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_EnableSnippet:format(group))
	end

	function DisableDrag(group)
		group = GetGroup(group)

		_DBCharNoDrag[group] = true
		_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_DisableSnippet:format(group))
	end

	function IsDragEnabled(group)
		group = GetGroup(group)
		return not _DBCharNoDrag[group]
	end

	function EnableButtonDown(group)
		group = GetGroup(group)
		if not _DBCharUseDown[group] then
			_DBCharUseDown[group] = true
			_IFActionHandler_Buttons:Each(function(self)
				local bgroup = GetGroup(self.IFActionHandlerGroup)
				if bgroup == group then
					self:RegisterForClicks("AnyDown")
				end
			end)
		end
	end

	function DisableButtonDown(group)
		group = GetGroup(group)
		if _DBCharUseDown[group] then
			_DBCharUseDown[group] = nil
			_IFActionHandler_Buttons:Each(function(self)
				local bgroup = GetGroup(self.IFActionHandlerGroup)
				if bgroup == group then
					self:RegisterForClicks("AnyUp")
				end
			end)
		end
	end

	function IsButtonDownEnabled(group)
		group = GetGroup(group)
		return _DBCharUseDown[group]
	end

	function SetupActionButton(self)
		_IFActionHandler_ManagerFrame:WrapScript(self, "OnDragStart", _IFActionHandler_OnDragStartSnippet:format(GetGroup(self.IFActionHandlerGroup)))
		_IFActionHandler_ManagerFrame:WrapScript(self, "OnReceiveDrag", _IFActionHandler_OnReceiveDragSnippet:format(GetGroup(self.IFActionHandlerGroup)))

    	_IFActionHandler_ManagerFrame:WrapScript(self, "OnClick", _IFActionHandler_WrapClickPrev, _IFActionHandler_WrapClickPost)
    	_IFActionHandler_ManagerFrame:WrapScript(self, "OnDragStart", _IFActionHandler_WrapDragPrev, _IFActionHandler_WrapDragPost)
    	_IFActionHandler_ManagerFrame:WrapScript(self, "OnReceiveDrag", _IFActionHandler_WrapDragPrev, _IFActionHandler_WrapDragPost)

    	-- Button UpdateAction method added to secure part
    	self:SetAttribute("UpdateAction", _IFActionHandler_UpdateActionAttribute)
    	self:SetFrameRef("IFActionHandler_Manager", _IFActionHandler_ManagerFrame)
    	self:Execute(_IFActionHandler_InsertManager)

		self.PreClick = self.PreClick + PreClick
		self.PostClick = self.PostClick + PostClick
		self.OnEnter = self.OnEnter + OnEnter
		self.OnLeave = self.OnLeave + OnLeave
    end

    function UninstallActionButton(self)
    	_IFActionHandler_ManagerFrame:UnwrapScript(self, "OnClick")
    	_IFActionHandler_ManagerFrame:UnwrapScript(self, "OnDragStart")
		_IFActionHandler_ManagerFrame:UnwrapScript(self, "OnReceiveDrag")
    	_IFActionHandler_ManagerFrame:UnwrapScript(self, "OnDragStart")
		_IFActionHandler_ManagerFrame:UnwrapScript(self, "OnReceiveDrag")
	end

	function GetActionDesc(action)
		local type, id = GetActionInfo(action)

		if action then
			type, id = GetActionInfo(action)
		end

		if type and id then
			return ""..type.."_"..id
		else
			return nil
		end
	end

	function UI_UpdateActionButton(self, kind, target)
		local desc

		self = IGAS:GetWrapper(self)
		if kind ~= "battlepet" then
			target = tonumber(target) or target
		end
		if kind == "action" then
			target = ActionButton_CalculateAction(self)
			desc = GetActionDesc(target)
		elseif kind == "item" then
			target = tonumber(type(target) == "string" and target:match("%d+") or target)
		end

		if self.__IFActionHandler_Kind ~= kind or self.__IFActionHandler_Action ~= target or (kind == "action" and desc ~= self.__IFActionHandler_ActionDesc) then
			self.__IFActionHandler_Kind = kind
			self.__IFActionHandler_Action = target
			self.__IFActionHandler_ActionDesc = desc

			_IFActionHandler_Buttons[self] = kind 	-- keep button in kind's link list

			UpdateActionButton(self)

			return self:UpdateAction(kind, target)
		end
	end

	function SaveActionPage(self, page)
		self:SetAttribute("actionpage", page)
		if page then
			SaveAction(self, "action", self.ID or 1)
		else
			SaveAction(self)
		end
	end

	function SaveAction(self, kind, target)
		-- Clear
		local oldKind = self:GetAttribute("type")
		if oldKind then
			self:SetAttribute("type", nil)
			self:SetAttribute(oldKind == "pet" and "action" or oldKind == "flyout" and "spell" or oldKind == "worldmarker" and "marker" or oldKind, nil)
			if oldKind == "macro" then
				self:SetAttribute("macrotext", nil)
			end
			if oldKind == "worldmarker" then
				self:SetAttribute("action", nil)
			end
		end

		if kind == "spell" then
			-- Convert to spell id
			if tonumber(target) then
				target = tonumber(target)
			else
				target = GetSpellLink(target)
		   		target = tonumber(target and target:match("spell:(%d+)"))
			end
		end

		if not target then
			kind = nil
		end

		if kind then
			self:SetAttribute("type", kind == "macrotext" and "macro" or kind)
			if kind ~= "custom" then
				if kind == "item" then
					target = tonumber(target) and "item:"..tonumber(target)
							or select(2, GetItemInfo(target)) and select(2, GetItemInfo(target)):match("item:%d+")
				elseif kind == "spell" then
					if target and _IFActionHandler_Profession[GetSpellInfo(target)] then
						target = _IFActionHandler_Profession[GetSpellInfo(target)]
					end
				end
				self:SetAttribute(kind == "pet" and "action" or kind == "flyout" and "spell" or kind == "worldmarker" and "marker" or kind, target)
			else
				self.OnClick = type(target) == "function" and target or nil
				target = nil
			end
		end

		_IFActionHandler_ManagerFrame:SetFrameRef("UpdatingButton", self)
		_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_UpdateActionSnippet:format(GetFormatString(kind), GetFormatString(target)))
	end

	function RegisterMainPage(self)
		_IFActionHandler_ManagerFrame:SetFrameRef("MainPageButton", self)
		_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_RegisterMainPage)
		SaveAction(self, "action", self.ID or 1)
	end

	function UnregisterMainPage(self)
		_IFActionHandler_ManagerFrame:SetFrameRef("MainPageButton", self)
		_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_UnregisterMainPage)
		SaveAction(self)
	end

	------------------------------------------------------
	-- Update Handler
	------------------------------------------------------
	function UpdateEquipmentSet()
		local str = "for i in pairs(IFActionHandler_EquipSet) do IFActionHandler_EquipSet[i] = nil end\n"
		local index = 1

		wipe(_IFActionHandler_EquipSetMap)

		while GetEquipmentSetInfo(index) do
			str = str.._IFActionHandler_EquipSetTemplate:format(GetEquipmentSetInfo(index), index)
			_IFActionHandler_EquipSetMap[GetEquipmentSetInfo(index)] = index
			index = index + 1
		end

		if str ~= "" then
			IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
				_IFActionHandler_ManagerFrame:Execute(str)
			end)
		end
	end

	function UpdateFlyoutSlotMap()
		local str = "for i in pairs(IFActionHandler_FlyoutSlot) do IFActionHandler_FlyoutSlot[i] = nil end\n"
		local type, id
		local name, texture, offset, numEntries, isGuild, offspecID

		wipe(_IFActionHandler_FlyoutSlot)
		wipe(_IFActionHandler_FlyoutTexture)

		for i = 1, MAX_SKILLLINE_TABS do
			name, texture, offset, numEntries, isGuild, offspecID = GetSpellTabInfo(i)

			if not name then
				break
			end

			if not isGuild and offspecID == 0 then
				for index = offset + 1, offset + numEntries do
					type, id = GetSpellBookItemInfo(index, "spell")

					if type == "FLYOUT" then
						if not _IFActionHandler_FlyoutSlot[id] then
							str = str.._IFActionHandler_FlyoutSlotTemplate:format(id, index)
							_IFActionHandler_FlyoutSlot[id] = index
							_IFActionHandler_FlyoutTexture[id] = GetSpellBookItemTexture(index, "spell")
						end
					end
				end
			end
		end

		IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
			_IFActionHandler_ManagerFrame:Execute(str)
		end)
	end

	function UpdateProfession()
		local lst = {GetProfessions()}
		local offset, spell, name

		for i = 1, 6 do
		    if lst[i] then
		        offset = 1 + select(6, GetProfessionInfo(lst[i]))
		        spell = select(2, GetSpellBookItemInfo(offset, "spell"))
		        name = GetSpellBookItemName(offset, "spell")

		        if _IFActionHandler_Profession[name] ~= spell then
		        	_IFActionHandler_Profession[name] = spell
		        	IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
		        		for _, btn in _IFActionHandler_Buttons("spell") do
		        			if GetSpellInfo(btn.__IFActionHandler_Action) == name then
		        				btn:SetAction("spell", spell)
		        			end
		        		end
		        	end)
		        end
		    end
		end
	end

	function UpdateStanceMap()
		local str = "for i in pairs(IFActionHandler_StanceMap) do IFActionHandler_StanceMap[i] = nil end\n"

		wipe(_IFActionHandler_StanceMap)

		for i = 1, GetNumShapeshiftForms() do
		    local name = select(2, GetShapeshiftFormInfo(i))
		    name = GetSpellLink(name)
		    name = tonumber(name and name:match("spell:(%d+)"))
		    if name then
				str = str.._IFActionHandler_StanceMapTemplate:format(name, i)
		    	_IFActionHandler_StanceMap[name] = i
		    end
		end

		if str ~= "" then
			IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
				_IFActionHandler_ManagerFrame:Execute(str)

				for _, btn in _IFActionHandler_Buttons("spell") do
					if _IFActionHandler_StanceMap[btn.__IFActionHandler_Action] then
						btn:SetAttribute("*type*", "macro")
						btn:SetAttribute("*macrotext*", "/click StanceButton".._IFActionHandler_StanceMap[btn.__IFActionHandler_Action])
					end
				end
			end)
		end
	end

	function UpdateMount()
		local str = ""

		for i = 1, GetNumCompanions("MOUNT") do
		    local _, spellId = select(2, GetCompanionInfo("MOUNT", i))

		    if spellId and _IFActionHandler_MountMap[spellId] ~= i then
				str = str.._IFActionHandler_MountMapTemplate:format(spellId, i)
				_IFActionHandler_MountMap[spellId] = i
		    end
		end

		if str ~= "" then
			_IFActionHandler_Buttons:EachK("companion", UpdateActionButton)
			IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
				_IFActionHandler_ManagerFrame:Execute(str)

				for _, btn in _IFActionHandler_Buttons("companion") do
					local index = _IFActionHandler_MountMap[btn.__IFActionHandler_Action]
					if index then
						btn:SetAttribute("*type*", "macro")
						btn:SetAttribute("*macrotext*", _IFActionHandler_MountCastTemplate:format(index, index))
					end
				end
			end)
		end
	end

	_IFActionHandler_GridCounter = _IFActionHandler_GridCounter or 0

	function UpdateGrid(self)
		if self.__IFActionHandler_Kind ~= "pet" and self.__IFActionHandler_Kind ~= "petaction" then
			if _IFActionHandler_GridCounter > 0 or self.ShowGrid or _HasAction(self) then
				self.Alpha = 1
			else
				self.Alpha = 0
			end
		end
	end

	_IFActionHandler_PetGridCounter = _IFActionHandler_PetGridCounter or 0

	function UpdatePetGrid(self)
		if self.__IFActionHandler_Kind == "pet" or self.__IFActionHandler_Kind == "petaction" then
			if _IFActionHandler_PetGridCounter > 0 or self.ShowGrid or _HasAction(self) then
				self.Alpha = 1
			else
				self.Alpha = 0
			end
		end
	end

	function ForceUpdateAction(self)
		return self:UpdateAction(self.__IFActionHandler_Kind, self.__IFActionHandler_Action)
	end

	function UpdateButtonState(self)
		if self.__IFActionHandler_Kind == "spell" and _IFActionHandler_StanceMap[self.__IFActionHandler_Action] then
			self.Checked = select(3, GetShapeshiftFormInfo(_IFActionHandler_StanceMap[self.__IFActionHandler_Action]))
		elseif self.__IFActionHandler_Kind == "pet" or self.__IFActionHandler_Kind == "petaction" then
			self.Checked = select(5, GetPetActionInfo(self.__IFActionHandler_Action))
		else
			self.Checked = _IsActivedAction(self) or _IsAutoRepeatAction(self)
		end
	end

	function UpdateUsable(self)
		self.Usable = _IsUsableAction(self)
	end

	function UpdateCount(self)
		if _IsConsumableAction(self) then
			local count = _GetActionCount(self)
			if ( count > (self.MaxDisplayCount or 9999 ) ) then
				self.Count = "*"
			else
				self.Count = tostring(count)
			end
		else
			local charges, maxCharges = _GetActionCharges(self)
			if maxCharges and maxCharges > 1 then
				self.Count = tostring(charges)
			else
				self.Count = ""
			end
		end
	end

	function UpdateCooldown(self)
		self:Fire("OnCooldownUpdate", _GetActionCooldown(self))
	end

	function UpdateFlash (self)
		if (_IsAttackAction(self) and _IsActivedAction(self)) or _IsAutoRepeatAction(self) then
			StartFlash(self)
		else
			StopFlash(self)
		end
	end

	function StartFlash (self)
		self.Flashing = true
		_IFActionHandler_FlashingList[self] = self.Flashing or nil
		if next(_IFActionHandler_FlashingList) then
			_IFActionHandler_FlashingTimer.Enabled = true
		end
		self.FlashVisible = true
		UpdateButtonState(self)
	end

	function StopFlash (self)
		self.Flashing = false
		_IFActionHandler_FlashingList[self] = nil
		if next(_IFActionHandler_FlashingList) then
			_IFActionHandler_FlashingTimer.Enabled = true
		end
		self.FlashVisible = false
		UpdateButtonState(self)
	end

	function UpdateTooltip(self)
		self = IGAS:GetWrapper(self)

		if (GetCVar("UberTooltips") == "1") then
			GameTooltip_SetDefaultAnchor(_GameTooltip, self)
		else
			_GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
		_SetTooltip(self)
		_IFActionHandler_OnTooltip =self

		IGAS:GetUI(self).UpdateTooltip = UpdateTooltip

		_GameTooltip:Show()
	end

	function UpdateOverlayGlow(self)
		local spellId = _GetSpellId(self)
		if spellId and IsSpellOverlayed(spellId) then
			ShowOverlayGlow(self)
		else
			HideOverlayGlow(self)
		end
	end

	function ShowOverlayGlow(self)
		if not self._IFActionHandler_OverLay then
			local alert = _RecycleAlert()
			local width, height = self:GetSize()

			alert:ClearAllPoints()
			alert:SetSize(width*1.4, height*1.4)
			alert:SetPoint("CENTER", self, "CENTER")

			alert._ActionButton = self
			self._IFActionHandler_OverLay = alert
			self._IFActionHandler_OverLay.AnimInPlaying = true
		end
	end

	function HideOverlayGlow(self)
		if self._IFActionHandler_OverLay then
			if self.Visible then
				self._IFActionHandler_OverLay.AnimOutPlaying = true
			else
				SpellAlert_OnFinished(self._IFActionHandler_OverLay)
			end
		end
	end

	function UpdateRange(self)
		local inRange = _IsInRange(self)
		self.InRange = inRange == 1 and true or inRange == 0 and false or inRange == nil and nil
	end

	function UpdateFlyout(self)
		self.FlyoutVisible = self.ShowFlyOut or _IsFlyout(self)
	end

	function UpdateAutoCastable(self)
		self.AutoCastable = _IsAutoCastAction(self)
	end

	function UpdateAutoCasting(self)
		self.AutoCasting = _IsAutoCasting(self)
	end

	function UpdateActionButton(self)
		UpdateGrid(self)
		UpdatePetGrid(self)
		UpdateButtonState(self)
		UpdateUsable(self)
		UpdateCooldown(self)
		UpdateFlash(self)
		UpdateFlyout(self)
		UpdateAutoCastable(self)
		UpdateAutoCasting(self)

		-- Add a green border if button is an equipped item
		if _IsEquippedItem(self) and self.Border then
			self.Border:SetVertexColor(0, 1.0, 0, 0.35)
			self.Border.Visible = true
		else
			self.Border.Visible = false
		end

		-- Update Action Text
		if not _IsConsumableAction(self) then
			self.Text = _GetActionText(self)
		else
			self.Text = ""
		end

		-- Update icon
		self.Icon = _GetActionTexture(self)

		UpdateCount(self)
		UpdateOverlayGlow(self)

		if _IFActionHandler_OnTooltip == self then
			UpdateTooltip(self)
		end

		ForceUpdateAction(self)
	end

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	_IFActionHandler_InitEvent = false

	function InitEventHandler()
		if _IFActionHandler_InitEvent then return end
		_IFActionHandler_InitEvent = true

		for _, event in ipairs({
			"ACTIONBAR_SHOWGRID",
			"ACTIONBAR_HIDEGRID",
			"ACTIONBAR_SLOT_CHANGED",
			"ACTIONBAR_UPDATE_STATE",
			"ACTIONBAR_UPDATE_USABLE",
			"ACTIONBAR_UPDATE_COOLDOWN",
			"ARCHAEOLOGY_CLOSED",
			"BAG_UPDATE_COOLDOWN",
			"COMPANION_LEARNED",
			"COMPANION_UNLEARNED",
			"COMPANION_UPDATE",
			"EQUIPMENT_SETS_CHANGED",
			"LEARNED_SPELL_IN_TAB",
			"PET_STABLE_UPDATE",
			"PET_STABLE_SHOW",
			"PET_BAR_UPDATE_COOLDOWN",
			"PET_BAR_UPDATE_USABLE",
			"PLAYER_ENTERING_WORLD",
			"PLAYER_ENTER_COMBAT",
			"PLAYER_EQUIPMENT_CHANGED",
			"PLAYER_LEAVE_COMBAT",
			"PLAYER_TARGET_CHANGED",
			"PLAYER_REGEN_ENABLED",
			"PLAYER_REGEN_DISABLED",
			"SPELL_ACTIVATION_OVERLAY_GLOW_SHOW",
			"SPELL_ACTIVATION_OVERLAY_GLOW_HIDE",
			"SPELL_UPDATE_CHARGES",
			"SPELL_UPDATE_COOLDOWN",
			"SPELL_UPDATE_USABLE",
			"START_AUTOREPEAT_SPELL",
			"STOP_AUTOREPEAT_SPELL",
			"TRADE_SKILL_SHOW",
			"TRADE_SKILL_CLOSE",
			"UNIT_ENTERED_VEHICLE",
			"UNIT_EXITED_VEHICLE",
			"UNIT_INVENTORY_CHANGED",
			--"UPDATE_BINDINGS",
			--"UPDATE_INVENTORY_ALERTS",
			"UPDATE_SHAPESHIFT_FORM",
			"UPDATE_SHAPESHIFT_FORMS",
			"UPDATE_SUMMONPETS_ACTION",
			"SPELLS_CHANGED",
			"SKILL_LINES_CHANGED",
			"PLAYER_GUILD_UPDATE",
			"PLAYER_SPECIALIZATION_CHANGED",
			"BAG_UPDATE",	-- need this to update item count
			-- For Pet Action
			"PET_BAR_SHOWGRID",
			"PET_BAR_HIDEGRID",
			"PLAYER_CONTROL_LOST",
			"PLAYER_CONTROL_GAINED",
			"PLAYER_FARSIGHT_FOCUS_CHANGED",
			"UNIT_PET",
			"UNIT_FLAGS",
			"PET_BAR_UPDATE",
			"PET_UI_UPDATE",
			"UPDATE_VEHICLE_ACTIONBAR",
			"UNIT_AURA",
			-- For battle pet
			"PET_JOURNAL_LIST_UPDATE",
			}) do
			_IFActionHandler_ManagerFrame:RegisterEvent(event)
		end
	end

	function UninstallEventHandler()
		_IFActionHandler_ManagerFrame:UnregisterAllEvents()
		_IFActionHandler_InitEvent = false
	end

	function _IFActionHandler_ManagerFrame:ACTIONBAR_SHOWGRID()
		_IFActionHandler_GridCounter = _IFActionHandler_GridCounter + 1
		if _IFActionHandler_GridCounter == 1 then
			_IFActionHandler_Buttons:Each(UpdateGrid)
		end
	end

	function _IFActionHandler_ManagerFrame:ACTIONBAR_HIDEGRID()
		if _IFActionHandler_GridCounter > 0 then
			_IFActionHandler_GridCounter = _IFActionHandler_GridCounter - 1
			if _IFActionHandler_GridCounter == 0 then
				_IFActionHandler_Buttons:Each(UpdateGrid)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:ACTIONBAR_SLOT_CHANGED(slot)
		for _, button in _IFActionHandler_Buttons("action") do
			if slot == 0 or slot == button.__IFActionHandler_Action then
				UpdateActionButton(button)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:ACTIONBAR_UPDATE_STATE()
		_IFActionHandler_Buttons:Each(UpdateButtonState)
	end

	function _IFActionHandler_ManagerFrame:ACTIONBAR_UPDATE_USABLE()
		_IFActionHandler_Buttons:EachK("action", UpdateUsable)
	end

	function _IFActionHandler_ManagerFrame:ACTIONBAR_UPDATE_COOLDOWN()
		_IFActionHandler_Buttons:EachK("action", UpdateCooldown)
		if _IFActionHandler_OnTooltip then
			UpdateTooltip(_IFActionHandler_OnTooltip)
		end
	end

	function _IFActionHandler_ManagerFrame:ARCHAEOLOGY_CLOSED()
		_IFActionHandler_Buttons:Each(UpdateButtonState)
	end

	function _IFActionHandler_ManagerFrame:BAG_UPDATE()
		_IFActionHandler_Buttons:EachK("item", UpdateCount)
		_IFActionHandler_Buttons:EachK("item", UpdateUsable)
	end

	function _IFActionHandler_ManagerFrame:BAG_UPDATE_COOLDOWN()
		_IFActionHandler_Buttons:EachK("item", UpdateCooldown)
	end

	function _IFActionHandler_ManagerFrame:COMPANION_LEARNED()
		UpdateMount()
	end

	function _IFActionHandler_ManagerFrame:COMPANION_UNLEARNED()
		UpdateMount()
	end

	function _IFActionHandler_ManagerFrame:COMPANION_UPDATE(type)
		if type == "MOUNT" then
			UpdateMount()
			_IFActionHandler_Buttons:Each(UpdateButtonState)
		end
	end

	function _IFActionHandler_ManagerFrame:EQUIPMENT_SETS_CHANGED()
		UpdateEquipmentSet()
	end

	function _IFActionHandler_ManagerFrame:LEARNED_SPELL_IN_TAB()
		if _IFActionHandler_OnTooltip then
			UpdateTooltip(_IFActionHandler_OnTooltip)
		end
		UpdateFlyoutSlotMap()
		UpdateProfession()
	end

	function _IFActionHandler_ManagerFrame:SPELLS_CHANGED()
		UpdateFlyoutSlotMap()
		UpdateProfession()
	end

	function _IFActionHandler_ManagerFrame:SKILL_LINES_CHANGED()
		UpdateFlyoutSlotMap()
		UpdateProfession()
	end

	function _IFActionHandler_ManagerFrame:PLAYER_GUILD_UPDATE()
		UpdateFlyoutSlotMap()
		UpdateProfession()
	end

	function _IFActionHandler_ManagerFrame:PLAYER_SPECIALIZATION_CHANGED(unit)
		if unit == "player" then
			UpdateFlyoutSlotMap()
			UpdateProfession()
		end
	end

	function _IFActionHandler_ManagerFrame:PET_STABLE_UPDATE()
		_IFActionHandler_Buttons:Each(UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:PET_STABLE_SHOW()
		_IFActionHandler_Buttons:Each(UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:PET_BAR_SHOWGRID()
		_IFActionHandler_PetGridCounter = _IFActionHandler_PetGridCounter + 1
		if _IFActionHandler_PetGridCounter == 1 then
			_IFActionHandler_Buttons:EachK("pet", UpdateGrid)
			_IFActionHandler_Buttons:EachK("petaction", UpdateGrid)
		end
	end

	function _IFActionHandler_ManagerFrame:PET_BAR_HIDEGRID()
		if _IFActionHandler_PetGridCounter > 0 then
			_IFActionHandler_PetGridCounter = _IFActionHandler_PetGridCounter - 1
			if _IFActionHandler_PetGridCounter == 0 then
				_IFActionHandler_Buttons:EachK("pet", UpdateGrid)
				_IFActionHandler_Buttons:EachK("petaction", UpdateGrid)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:PLAYER_CONTROL_LOST()
		_IFActionHandler_Buttons:EachK("pet", UpdateActionButton)
		_IFActionHandler_Buttons:EachK("petaction", UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:PLAYER_CONTROL_GAINED()
		_IFActionHandler_Buttons:EachK("pet", UpdateActionButton)
		_IFActionHandler_Buttons:EachK("petaction", UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:PLAYER_FARSIGHT_FOCUS_CHANGED()
		_IFActionHandler_Buttons:EachK("pet", UpdateActionButton)
		_IFActionHandler_Buttons:EachK("petaction", UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:UNIT_PET(unit)
		if unit == "player" then
			_IFActionHandler_Buttons:EachK("pet", UpdateActionButton)
			_IFActionHandler_Buttons:EachK("petaction", UpdateActionButton)
		end
	end

	function _IFActionHandler_ManagerFrame:UNIT_FLAGS(unit)
		if unit == "pet" then
			_IFActionHandler_Buttons:EachK("pet", UpdateActionButton)
			_IFActionHandler_Buttons:EachK("petaction", UpdateActionButton)
		end
	end

	function _IFActionHandler_ManagerFrame:PET_BAR_UPDATE()
		_IFActionHandler_Buttons:EachK("pet", UpdateActionButton)
		_IFActionHandler_Buttons:EachK("petaction", UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:PET_UI_UPDATE()
		_IFActionHandler_Buttons:EachK("pet", UpdateActionButton)
		_IFActionHandler_Buttons:EachK("petaction", UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:UPDATE_VEHICLE_ACTIONBAR()
		_IFActionHandler_Buttons:EachK("pet", UpdateActionButton)
		_IFActionHandler_Buttons:EachK("petaction", UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:UNIT_AURA(unit)
		if unit == "pet" then
			_IFActionHandler_Buttons:EachK("pet", UpdateActionButton)
			_IFActionHandler_Buttons:EachK("petaction", UpdateActionButton)
		end
	end

	function _IFActionHandler_ManagerFrame:PET_BAR_UPDATE_COOLDOWN()
		_IFActionHandler_Buttons:EachK("pet", UpdateCooldown)
		_IFActionHandler_Buttons:EachK("petaction", UpdateCooldown)
	end

	function _IFActionHandler_ManagerFrame:PET_BAR_UPDATE_USABLE()
		_IFActionHandler_Buttons:EachK("pet", UpdateUsable)
		_IFActionHandler_Buttons:EachK("petaction", UpdateUsable)
	end

	function _IFActionHandler_ManagerFrame:PLAYER_ENTERING_WORLD()
		UpdateEquipmentSet()
		_IFActionHandler_Buttons:Each(UpdateActionButton)
		if not next(_IFActionHandler_MountMap) then
			UpdateMount()
		end
	end

	function _IFActionHandler_ManagerFrame:PLAYER_ENTER_COMBAT()
		for _, button in _IFActionHandler_Buttons("action") do
			if _IsAttackAction(button) then
				StartFlash(button)
			end
		end
		for _, button in _IFActionHandler_Buttons("spell") do
			if _IsAttackAction(button) then
				StartFlash(button)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:PLAYER_EQUIPMENT_CHANGED()
		_IFActionHandler_Buttons:EachK("item", UpdateActionButton)
		_IFActionHandler_Buttons:EachK("equipmentset", UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:PLAYER_LEAVE_COMBAT()
		for _, button in _IFActionHandler_Buttons("action") do
			if button.Flashing then
				StopFlash(button)
			end
		end
		for _, button in _IFActionHandler_Buttons("spell") do
			if button.Flashing then
				StopFlash(button)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:PLAYER_TARGET_CHANGED()
		_IFActionHandler_UpdateRangeTimer:OnTimer()
	end

	function _IFActionHandler_ManagerFrame:PLAYER_REGEN_ENABLED()
		_IFActionHandler_Buttons:EachK("item", UpdateCount)
		_IFActionHandler_Buttons:EachK("item", UpdateUsable)
	end

	function _IFActionHandler_ManagerFrame:PLAYER_REGEN_DISABLED()
		_IFActionHandler_Buttons:EachK("item", UpdateUsable)
	end

	function _IFActionHandler_ManagerFrame:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(spellId)
		for _, button in _IFActionHandler_Buttons("action") do
			if spellId == _GetSpellId(button) then
				ShowOverlayGlow(button)
			end
		end
		for _, button in _IFActionHandler_Buttons("spell") do
			if spellId == _GetSpellId(button) then
				ShowOverlayGlow(button)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(spellId)
		for _, button in _IFActionHandler_Buttons("action") do
			if spellId == _GetSpellId(button) then
				HideOverlayGlow(button, true)
			end
		end
		for _, button in _IFActionHandler_Buttons("spell") do
			if spellId == _GetSpellId(button) then
				HideOverlayGlow(button, true)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:SPELL_UPDATE_CHARGES()
		_IFActionHandler_Buttons:EachK("action", UpdateCount)
		_IFActionHandler_Buttons:EachK("spell", UpdateCount)
	end

	function _IFActionHandler_ManagerFrame:SPELL_UPDATE_COOLDOWN()
		_IFActionHandler_Buttons:EachK("spell", UpdateCooldown)
	end

	function _IFActionHandler_ManagerFrame:SPELL_UPDATE_USABLE()
		_IFActionHandler_Buttons:EachK("spell", UpdateUsable)
		_IFActionHandler_Buttons:EachK("companion", UpdateUsable)
	end

	function _IFActionHandler_ManagerFrame:START_AUTOREPEAT_SPELL()
		for _, button in _IFActionHandler_Buttons("action") do
			if _IsAutoRepeatAction(button) then
				StartFlash(button)
			end
		end
		for _, button in _IFActionHandler_Buttons("spell") do
			if _IsAutoRepeatAction(button) then
				StartFlash(button)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:STOP_AUTOREPEAT_SPELL()
		for _, button in _IFActionHandler_Buttons("action") do
			if button.Flashing and not _IsAttackAction(button) then
				StopFlash(button)
			end
		end
		for _, button in _IFActionHandler_Buttons("spell") do
			if button.Flashing and not _IsAttackAction(button) then
				StopFlash(button)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:TRADE_SKILL_SHOW()
		_IFActionHandler_Buttons:Each(UpdateButtonState)
	end

	function _IFActionHandler_ManagerFrame:TRADE_SKILL_CLOSE()
		_IFActionHandler_Buttons:Each(UpdateButtonState)
	end

	function _IFActionHandler_ManagerFrame:UNIT_ENTERED_VEHICLE(unit)
		if unit == "player" then
			_IFActionHandler_Buttons:Each(UpdateButtonState)
		end
	end

	function _IFActionHandler_ManagerFrame:UNIT_EXITED_VEHICLE(unit)
		if unit == "player" then
			_IFActionHandler_Buttons:Each(UpdateButtonState)
		end
	end

	function _IFActionHandler_ManagerFrame:UNIT_INVENTORY_CHANGED(unit)
		if unit == "player" and _IFActionHandler_OnTooltip then
			UpdateTooltip(_IFActionHandler_OnTooltip)
		end
	end

	function _IFActionHandler_ManagerFrame:UPDATE_SHAPESHIFT_FORM()
		_IFActionHandler_Buttons:EachK("action", UpdateActionButton)
		_IFActionHandler_Buttons:EachK("spell", UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:UPDATE_SHAPESHIFT_FORMS()
		UpdateStanceMap()
		_IFActionHandler_Buttons:EachK("action", UpdateActionButton)
		_IFActionHandler_Buttons:EachK("spell", UpdateActionButton)
	end

	function _IFActionHandler_ManagerFrame:UPDATE_SUMMONPETS_ACTION()
		for _, button in _IFActionHandler_Buttons("action") do
			local actionType, id = GetActionCount(button.__IFActionHandler_Action)
			if actionType == "summonpet" then
				button.Icon = GetActionTexture(button.__IFActionHandler_Action)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:PET_JOURNAL_LIST_UPDATE()
		_IFActionHandler_Buttons:EachK("battlepet", UpdateActionButton)
	end

	function _IFActionHandler_UpdateRangeTimer:OnTimer()
		_IFActionHandler_Buttons:Each(UpdateRange)
	end

	function _IFActionHandler_FlashingTimer:OnTimer()
		if not next(_IFActionHandler_FlashingList) then
			_IFActionHandler_FlashingTimer.Enabled = false
		end
		for button in pairs(_IFActionHandler_FlashingList) do
			button.FlashVisible = not button.FlashVisible
		end
	end

	function SpellAlert_OnFinished(self)
		if self._ActionButton then
			self._ActionButton._IFActionHandler_OverLay = nil
			self._ActionButton = nil
			self:StopAnimation()
			self:ClearAllPoints()
			self:Hide()

			_RecycleAlert(self)
		end
	end

	function _RecycleAlert:OnInit(alert)
		alert.OnFinished = SpellAlert_OnFinished
	end
end

interface "IFActionHandler"
	extend "IFSecureHandler" "IFCooldown"

	doc [======[
		@name IFActionHandler
		@type interface
		@desc IFActionHandler is used to manage action buttons
		@overridable UpdateAction method, used to customize action button when it's content is changed
		@overridable IFActionHandlerGroup property, return a group name, the name is used to mark the action button into a group
		@overridable Usable property, whether the action is usable, used to refresh the action button as a trigger
		@overridable Count property, the action's count, used to refresh the action count as a trigger
		@overridable Flashing property, whether need flash the action, used to refresh the action count as a trigger
		@overridable FlashVisible property, the action button's flash texture's visible, used to refresh the action count as a trigger
		@overridable FlyoutVisible property, the action button's flyout's visible, used to refresh the action count as a trigger
		@overridable Text property, the action't text, used to refresh the action count as a trigger
		@overridable Icon property, the action's icon path, used to refresh the action count as a trigger
		@overridable InRange property, whether the action is in range, used to refresh the action count as a trigger
		@overridable FlyoutDirection property, the action button's flyout direction, used to refresh the action count as a trigger
		@overridable AutoCastable property, whether the action is auto-castable, used to refresh the action count as a trigger
		@overridable AutoCasting property, whether the action is now auto-casting, used to refresh the action count as a trigger
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Object Method
	------------------------------------------------------
	doc [======[
		@name UpdateAction
		@type method
		@desc Update the action, Overridable
		@param kind System.Widget.Action.IFActionHandler.ActionType, the action's type, such like 'action', 'pet', 'spell', etc.
		@param content string|number, the action't content, such like 'Revive' for 'spell' type
		@return nil
	]======]
	function UpdateAction(self, kind, target)
	end

	doc [======[
		@name SetActionPage
		@type method
		@desc Set Action Page for actionbutton
		@param page number|nil, the action page for the action button
		@return nil
	]======]
	function SetActionPage(self, page)
		page = tonumber(page)
		page = page and floor(page)
		if page and page <= 0 then page = nil end

		if self.ID == nil then page = nil end

		if GetActionPage(self) ~= page then
			IFNoCombatTaskHandler._RegisterNoCombatTask(SaveActionPage, self, page)
		end
	end

	doc [======[
		@name GetActionPage
		@type method
		@desc Get Action Page of action button
		@return number the action button's action page if set, or nil
	]======]
	function GetActionPage(self)
		if not IsMainPage(self) then
			return tonumber(self:GetAttribute("actionpage"))
		end
	end

	doc [======[
		@name SetMainPage
		@type method
		@desc Set if this action button belongs to main page
		@param isMain boolean, true if the action button belongs to main page, so its content will be automatically changed under several conditions.
		@return nil
	]======]
	function SetMainPage(self, isMain)
		isMain = isMain and true or nil
		if self.__IFActionHandler_IsMain ~= isMain then
			self.__IFActionHandler_IsMain = isMain

			if isMain then
				IFNoCombatTaskHandler._RegisterNoCombatTask(RegisterMainPage, self)
			else
				IFNoCombatTaskHandler._RegisterNoCombatTask(UnregisterMainPage, self)
			end
		end
	end

	doc [======[
		@name function_name
		@type method
		@desc Whether if the action button is belong to main page
		@return boolean true if the action button is belong to main page
	]======]
	function IsMainPage(self)
		return self.__IFActionHandler_IsMain or false
	end

	doc [======[
		@name SetAction
		@type method
		@desc Set action for the actionbutton
		@param kind System.Widget.Action.IFActionHandler.ActionType, the action type
		@param content string|number, the action's content
		@return nil
	]======]
	function SetAction(self, kind, target, texture, tooltip)
		kind = kind and Reflector.Validate(ActionType, kind, "kind", "Usage: IFActionHandler:SetAction(kind, target) -")

		if not kind or not target then
			kind, target = nil, nil
		end

		if kind == ActionType.petaction then
			kind = "pet"
		end

		self.__IFActionHandler_Texture = texture
		self.__IFActionHandler_Tooltip = tooltip

		IFNoCombatTaskHandler._RegisterNoCombatTask(SaveAction, self, kind, target)
	end

	doc [======[
		@name GetAction
		@type method
		@desc Get action for the actionbutton
		@return kind System.Widget.Action.IFActionHandler.ActionType, the action type
		@return content string|number, the action's content
	]======]
	function GetAction(self)
		return self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	end

	doc [======[
		@name HasAction
		@type method
		@desc Whether the action button has action content
		@return boolean true if the button has action
	]======]
	function HasAction(self)
		return _HasAction(self)
	end

	doc [======[
		@name SetFlyoutDirection
		@type method
		@desc Set flyoutDirection for action button
		@param dir System.Widget.Action.IFActionHandler.FlyoutDirection
		@return nil
	]======]
	function SetFlyoutDirection(self, dir)
		dir = Reflector.Validate(FlyoutDirection, dir, "dir", "Usage: IFActionHandler:SetFlyoutDirection(dir) -")

		self:SetAttribute("flyoutDirection", dir)
	end

	doc [======[
		@name SetFlyoutDirection
		@type method
		@desc Get flyoutDirection for action button
		@return dir System.Widget.Action.IFActionHandler.FlyoutDirection
	]======]
	function GetFlyoutDirection(self)
		return self:GetAttribute("flyoutDirection") or FlyoutDirection.UP
	end

	------------------------------------------------------
	-- Interface Method
	------------------------------------------------------
	doc [======[
		@name _EnableGroupDrag
		@type method
		@desc Make the group's action buttons draggable
		@param group string|nil, the action button's group
		@return nil
	]======]
	function _EnableGroupDrag(group)
		IFNoCombatTaskHandler._RegisterNoCombatTask(EnableDrag, group)
	end

	doc [======[
		@name _IsGroupDragEnabled
		@type method
		@desc Whether if the action button group draggable
		@param group string|nil, the action button's group
		@return boolean true if the group's action buttons are draggable
	]======]
	function _IsGroupDragEnabled(group)
		return IsDragEnabled(group)
	end

	doc [======[
		@name _DisableGroupDrag
		@type method
		@desc Make the group's action buttons un-draggable
		@param group string|nil, the action button's group
		@return nil
	]======]
	function _DisableGroupDrag(group)
		IFNoCombatTaskHandler._RegisterNoCombatTask(DisableDrag, group)
	end

	doc [======[
		@name _EnableGroupUseButtonDown
		@type method
		@desc Make the group's action buttons using mouse down to trigger actions
		@param group string|nil, the action button's group
		@return nil
	]======]
	function _EnableGroupUseButtonDown(group)
		IFNoCombatTaskHandler._RegisterNoCombatTask(EnableButtonDown, group)
	end

	doc [======[
		@name function_name
		@type method
		@desc Whether if the action group buttons using mouse down
		@param boolean  string|nil, the action button's group
		@return boolean true if the group action buttons are using mouse down
	]======]
	function _IsGroupUseButtonDownEnabled(group)
		return IsButtonDownEnabled(group)
	end

	doc [======[
		@name _EnableGroupUseButtonDown
		@type method
		@desc Make the group's action buttons using mouse up to trigger actions
		@param group string|nil, the action button's group
		@return nil
	]======]
	function _DisableGroupUseButtonDown(group)
		IFNoCombatTaskHandler._RegisterNoCombatTask(DisableButtonDown, group)
	end

	------------------------------------------------------
	-- Group Property
	------------------------------------------------------
	doc [======[
		@name IFActionHandlerGroup
		@type property
		@desc Overridable, the action button's group name
	]======]
	property "IFActionHandlerGroup" {
		Get = function(self)
			return _GlobalGroup
		end,
	}

	------------------------------------------------------
	-- Action Property
	------------------------------------------------------
	doc [======[
		@name Action
		@type property
		@desc The action button's content if its type is 'action'
	]======]
	property "Action" {
		Get = function(self)
			return self:GetAttribute("type") == "action" and tonumber(self:GetAttribute("action")) or nil
		end,
		Set = function(self, value)
			self:SetAction("action", value)
		end,
		Type = System.Number + nil,
	}

	doc [======[
		@name PetAction
		@type property
		@desc The action button's content if its type is 'pet'
	]======]
	property "PetAction" {
		Get = function(self)
			return self:GetAttribute("type") == "pet" and tonumber(self:GetAttribute("action")) or nil
		end,
		Set = function(self, value)
			self:SetAction("pet", value)
		end,
		Type = System.Number + nil,
	}

	doc [======[
		@name Spell
		@type property
		@desc The action button's content if its type is 'spell'
	]======]
	property "Spell" {
		Get = function(self)
			return self:GetAttribute("type") == "spell" and self:GetAttribute("spell") or nil
		end,
		Set = function(self, value)
			self:SetAction("spell", value)
		end,
		Type = System.String + System.Number + nil,
	}

	doc [======[
		@name Item
		@type property
		@desc The action button's content if its type is 'item'
	]======]
	property "Item" {
		Get = function(self)
			return self:GetAttribute("type") == "item" and type(self:GetAttribute("item")) == "string" and self:GetAttribute("item"):match("%d+") or nil
		end,
		Set = function(self, value)
			self:SetAction("item", value and GetItemInfo(value) and select(2, GetItemInfo(value)):match("item:%d+") or nil)
		end,
		Type = System.String + System.Number + nil,
	}

	doc [======[
		@name Macro
		@type property
		@desc The action button's content if its type is 'macro'
	]======]
	property "Macro" {
		Get = function(self)
			return self:GetAttribute("type") == "macro" and self:GetAttribute("macro") or nil
		end,
		Set = function(self, value)
			self:SetAction("macro", value)
		end,
		Type = System.String + System.Number + nil,
	}

	doc [======[
		@name MacroText
		@type property
		@desc The action button's content if its type is 'macro'
	]======]
	property "MacroText" {
		Get = function(self)
			return self:GetAttribute("type") == "macro" and self:GetAttribute("macrotext") or nil
		end,
		Set = function(self, value)
			self:SetAction("macrotext", value)
		end,
		Type = System.String + nil,
	}

	doc [======[
		@name Mount
		@type property
		@desc The action button's content if its type is 'mount'
	]======]
	property "Mount" {
		Get = function(self)
			return self:GetAttribute("type") == "companion" and tonumber(self:GetAttribute("companion")) or nil
		end,
		Set = function(self, value)
			self:SetAction("companion", value)
		end,
		Type = System.Number + nil,
	}

	doc [======[
		@name EquipmentSet
		@type property
		@desc The action button's content if its type is 'equipmentset'
	]======]
	property "EquipmentSet" {
		Get = function(self)
			return self:GetAttribute("type") == "equipmentset" and self:GetAttribute("equipmentset") or nil
		end,
		Set = function(self, value)
			self:SetAction("equipmentset", value)
		end,
		Type = System.String + nil,
	}

	doc [======[
		@name BattlePet
		@type property
		@desc The action button's content if its type is 'battlepet'
	]======]
	property "BattlePet" {
		Get = function(self)
			return self:GetAttribute("type") == "battlepet" and tonumber(self:GetAttribute("battlepet")) or nil
		end,
		Set = function(self, value)
			self:SetAction("battlepet", value)
		end,
		Type = System.Number + nil,
	}

	doc [======[
		@name WorldMarker
		@type property
		@desc The action button's content if its type is 'worldmarker'
	]======]
	property "WorldMarker" {
		Get = function(self)
			return self:GetAttribute("type") == "worldmarker" and tonumber(self:GetAttribute("marker")) or nil
		end,
		Set = function(self, value)
			self:SetAction("worldmarker", value)
		end,
		Type = System.Number + nil,
	}

	doc [======[
		@name FlytoutID
		@type property
		@desc The action button's content if its type is 'flyout'
	]======]
	property "FlytoutID" {
		Get = function(self)
			return self:GetAttribute("type") == "flyout" and tonumber(self:GetAttribute("spell")) or nil
		end,
		Set = function(self, value)
			self:SetAction("flyout", value)
		end,
		Type = System.Number + nil,
	}

	doc [======[
		@name ActionPage
		@type property
		@desc The action page of the action button if type is 'action'
	]======]
	property "ActionPage" {
		Get = function(self)
			return self:GetActionPage()
		end,
		Set = function(self, value)
			self:SetActionPage(value)
		end,
		Type = System.Number + nil,
	}

	doc [======[
		@name MainPage
		@type property
		@desc Whether the action button is used in the main page
	]======]
	property "MainPage" {
		Get = function(self)
			return self:IsMainPage()
		end,
		Set = function(self, value)
			self:SetMainPage(value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name ActionType
		@type property
		@desc The action button's type
	]======]
	property "ActionType" {
		Get = function(self)
			return self.__IFActionHandler_Kind
		end,
	}

	doc [======[
		@name ActionTarget
		@type property
		@desc The action button's content
	]======]
	property "ActionTarget" {
		Get = function(self)
			return self.__IFActionHandler_Action
		end,
	}

	------------------------------------------------------
	-- Display Property
	------------------------------------------------------
	doc [======[
		@name ShowGrid
		@type property
		@desc Whether show the action button with no content, controlled by IFActionHandler
	]======]
	property "ShowGrid" {
		Get = function(self)
			return self.__ShowGrid or false
		end,
		Set = function(self, value)
			self.__ShowGrid = value
			UpdateGrid(self)
			UpdatePetGrid(self)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name ShowFlyOut
		@type property
		@desc Whether show the action button's flyout icon, controlled by IFActionHandler
	]======]
	property "ShowFlyOut" {
		Get = function(self)
			return self.__ShowFlyOut
		end,
		Set = function(self, value)
			self.__ShowFlyOut = value
			UpdateFlyout(self)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name Usable
		@type property
		@desc Whether the action button is usable, controlled by IFActionHandler
	]======]
	property "Usable" {
		Get = function(self)
			return self.__Usable or false
		end,
		Set = function(self, value)
			self.__Usable = value
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name Count
		@type property
		@desc The action's count, controlled by IFActionHandler
	]======]
	property "Count" {
		Get = function(self)
			return self.__Count
		end,
		Set = function(self, value)
			self.__Count = value
		end,
		Type = System.String,
	}

	doc [======[
		@name Flashing
		@type property
		@desc Whether the action is flashing, controlled by IFActionHandler
	]======]
	property "Flashing" {
		Get = function(self)
			return self.__Flashing or false
		end,
		Set = function(self, value)
			self.__Flashing = value
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name FlashVisible
		@type property
		@desc Whether the action's flashing texture should be shown, controlled by IFActionHandler
	]======]
	property "FlashVisible" {
		Get = function(self)
			return self.__FlashVisible
		end,
		Set = function(self, value)
			self.__FlashVisible = value
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name FlyoutVisible
		@type property
		@desc Whether the action's flyout icon should be shown, controlled by IFActionHandler
	]======]
	property "FlyoutVisible" {
		Get = function(self)
			return self.__FlyoutVisible
		end,
		Set = function(self, value)
			self.__FlyoutVisible = value
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name Text
		@type property
		@desc The action button's text, controlled by the IFActionHandler
	]======]
	property "Text" {
		Get = function(self)
			return self.__Text
		end,
		Set = function(self, value)
			self.__Text = value
		end,
		Type = System.String,
	}

	doc [======[
		@name Icon
		@type property
		@desc The action button's icon image path, controlled by IFActionHandler
	]======]
	property "Icon" {
		Get = function(self)
			return self.__Icon
		end,
		Set = function(self, value)
			self.__Icon = value
		end,
		Type = System.String,
	}

	doc [======[
		@name InRange
		@type property
		@desc Whether the target is in the range of the action, controlled by IFActionHandler
	]======]
	property "InRange" {
		Get = function(self)
			return self.__InRange
		end,
		Set = function(self, value)
			self.__InRange = value
		end,
		Type = System.Boolean+nil,
	}

	doc [======[
		@name FlyoutDirection
		@type property
		@desc The flyout's direction, controlled by IFActionHandler
	]======]
	property "FlyoutDirection" {
		Get = function(self)
			return self:GetFlyoutDirection()
		end,
		Set = function(self, dir)
			self:SetFlyoutDirection(dir)
		end,
		Type = FlyoutDirection,
	}

	doc [======[
		@name AutoCastable
		@type property
		@desc Whether the action is autocastable, controlled by IFActionHandler
	]======]
	property "AutoCastable" {
		Get = function(self)
			return self.__AutoCastable or false
		end,
		Set = function(self, value)
			self.__AutoCastable = value
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name AutoCasting
		@type property
		@desc Whether the action is now auto-casting, controlled by IFActionHandler
	]======]
	property "AutoCasting" {
		Get = function(self)
			return self.__AutoCasting or false
		end,
		Set = function(self, value)
			self.__AutoCasting = value
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFActionHandler_Buttons:Remove(self)
		if #_IFActionHandler_Buttons == 0 then
			_IFActionHandler_UpdateRangeTimer.Enabled = false
			UninstallEventHandler()
		end
		return IFNoCombatTaskHandler._RegisterNoCombatTask(UninstallActionButton, IGAS:GetUI(self))
	end

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFActionHandler(self)
    	if not Reflector.ObjectIsClass(self, CheckButton) then
    		error("Only System.Widget.CheckButton can extend IFActionHandler.", 2)
    	end

    	_IFActionHandler_UpdateRangeTimer.Enabled = true
    	InitEventHandler()

    	if _DBCharUseDown[GetGroup(self.IFActionHandlerGroup)] then
    		self:RegisterForClicks("AnyDown")
		else
			self:RegisterForClicks("AnyUp")
		end
		self:RegisterForDrag("LeftButton", "RightButton")
		_IFActionHandler_Buttons:Insert(self)

		-- Since secure code can only call method in the UI part
		IGAS:GetUI(self).IFActionHandler_UpdateAction = UI_UpdateActionButton
		IFNoCombatTaskHandler._RegisterNoCombatTask(SetupActionButton, self)
	end
endinterface "IFActionHandler"
