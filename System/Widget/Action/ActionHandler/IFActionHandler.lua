-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.IFActionHandler", version) then
	return
end

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
	_FlashInterval = 0.4
	_UpdateRangeInterval = 0.2

	_IFActionTypeHandler = {}

	_ActionTypeMap = {}
	_ActionTargetMap = {}
	_ActionTargetMap2 = {}

	_GlobalGroup = "Global"

	function GetGroup(group)
		return tostring(type(group) == "string" and strtrim(group) ~= "" and strtrim(group) or _GlobalGroup):upper()
	end

	function GetFormatString(param)
		return type(param) == "string" and ("%q"):format(param) or tostring(param)
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

	_RegisterSnippetTemplate = "%s[%q] = %q"

	enum "HandleStyle" {
		"Keep",
		"Clear",
		"Block",
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
		@desc Refresh all action buttons of the same action type
		@return nil
	]======]
	function Refresh(self, button, mode)
		if not type(button) == "table" then
			return _IFActionHandler_Buttons:EachK(self.Name, button or UpdateActionButton)
		else
			if mode then
				return mode(button)
			else
				return UpdateActionButton(button)
			end
		end
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
		@name PickupAction
		@type method
		@desc Custom pick up action
		@param target
		@param detail
		@return nil
	]======]
	function PickupAction(self, target, detail)
	end

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
		@name Manager
		@type property
		@desc The manager of the action system
	]======]
	property "Manager" {
		Get = function(self)
			return _IFActionHandler_ManagerFrame
		end,
	}

	doc [======[
		@name Name
		@type property
		@desc The action's name
	]======]
	property "Name" { Type = String }

	doc [======[
		@name Type
		@type property
		@desc The action type's type
	]======]
	property "Type" { Type = String + nil }

	doc [======[
		@name Target
		@type property
		@desc The target attribute name
	]======]
	property "Target" { Type = String + nil }

	doc [======[
		@name Target2
		@type property
		@desc The 2nd target attribute name
	]======]
	property "Target2" { Type = String + nil }

	doc [======[
		@name DragStyle
		@type property
		@desc The drag style of the action type
	]======]
	property "DragStyle" { Type = HandleStyle, Default = HandleStyle.Clear }

	doc [======[
		@name ReceiveStyle
		@type property
		@desc The receive style of the action type
	]======]
	property "ReceiveStyle" { Type = HandleStyle, Default = HandleStyle.Clear }

	doc [======[
		@name ReceiveMap
		@type property
		@desc The receive map
	]======]
	property "ReceiveMap" { Type = String + nil }

	doc [======[
		@name PickupMap
		@type property
		@desc The pickup map
	]======]
	property "PickupMap" { Type = String + nil }

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

	doc [======[
		@name ClearSnippet
		@type property
		@desc The snippet used to clear action
	]======]
	property "ClearSnippet" { Type = String + nil }

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFActionTypeHandler(self)
    	-- No repeat definition for action types
    	if _IFActionTypeHandler[self.Name] then return end

    	-- Register the action type handler
    	_IFActionTypeHandler[self.Name] = self

    	-- Default map
    	if self.Type == nil then self.Type = self.Name end
    	if self.Target == nil then self.Target = self.Type end
    	if self.ReceiveMap == nil and self.ReceiveStyle == "Clear" then self.ReceiveMap = self.Type end
    	if self.PickupMap == nil and self.DragStyle ~= "Block" then self.PickupMap = self.Type end


		-- Register action type map
		_ActionTypeMap[self.Name] = self.Type
		_ActionTargetMap[self.Name] = self.Target
		_ActionTargetMap2[self.Name]  = self.Target2
		self:RunSnippet( _RegisterSnippetTemplate:format("_ActionTypeMap", self.Name, self.Type) )
		self:RunSnippet( _RegisterSnippetTemplate:format("_ActionTargetMap", self.Name, self.Target) )
		self:RunSnippet( _RegisterSnippetTemplate:format("_ActionTargetMap2", self.Name, self.Target2) )

		-- Init the environment
		if self.InitSnippet then self:RunSnippet( self.InitSnippet ) end

		-- Register PickupSnippet
		if self.PickupSnippet then self:RunSnippet( _RegisterSnippetTemplate:format("_PickupSnippet", self.Name, self.PickupSnippet) ) end

		-- Register UpdateSnippet
		if self.UpdateSnippet then self:RunSnippet( _RegisterSnippetTemplate:format("_UpdateSnippet", self.Name, self.UpdateSnippet) ) end

		-- Register ReceiveSnippet
		if self.ReceiveSnippet then self:RunSnippet( _RegisterSnippetTemplate:format("_ReceiveSnippet", self.Name, self.ReceiveSnippet) ) end

		-- Register ClearSnippet
		if self.ClearSnippet then self:RunSnippet( _RegisterSnippetTemplate:format("_ClearSnippet", self.Name, self.ClearSnippet) ) end

		-- Register DragStyle
		self:RunSnippet( _RegisterSnippetTemplate:format("_DragStyle", self.Name, self.DragStyle) )

		-- Register ReceiveStyle
		self:RunSnippet( _RegisterSnippetTemplate:format("_ReceiveStyle", self.Name, self.ReceiveStyle) )

		-- Register ReceiveMap
		if self.ReceiveMap then self:RunSnippet( _RegisterSnippetTemplate:format("_ReceiveMap", self.ReceiveMap, self.Name) )

		-- Register PickupMap
		if self.PickupMap then self:RunSnippet( _RegisterSnippetTemplate:format("_PickupMap", self.Name, self.PickupMap) )
    end
endinterface "IFActionTypeHandler"

------------------------------------------------------
-- ActionTypeHandler
--
------------------------------------------------------
__Cache__() class "ActionTypeHandler"
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

	IGAS:GetUI(_IFActionHandler_ManagerFrame).OnPickUp = function (self, kind, target, target2)
		if not InCombatLockdown() then
			return PickupAny("clear", kind, target, target2)
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

	------------------------------------------------------
	-- Snippet Definition
	------------------------------------------------------
	-- Init manger frame's enviroment
	IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
		_IFActionHandler_ManagerFrame:Execute[[
			-- to fix blz error, use Manager not control
			Manager = self

			_NoDraggable = newtable()

			_ActionTypeMap = newtable()
			_ActionTargetMap = newtable()
			_ActionTargetMap2 = newtable()

			_ReceiveMap = newtable()
			_PickupMap = newtable()

			_ClearSnippet = newtable()
			_UpdateSnippet = newtable()
			_PickupSnippet = newtable()
			_ReceiveSnippet = newtable()

			_DragStyle = newtable()
			_ReceiveStyle = newtable()

			ClearAction = [=[
				local name = self:GetAttribute("actiontype")

				if name then
					self:SetAttribute("actiontype", "empty")

					self:SetAttribute("type", nil)
					self:SetAttribute(_ActionTargetMap[name], nil)
					if _ActionTargetMap2[name] then
						self:SetAttribute(_ActionTargetMap2[name], nil)
					end

					-- Custom clear
					if _ClearSnippet[name] then
						Manager:RunFor(self, _ClearSnippet[name])
					end
				end
			]=]

			UpdateAction = [=[
				local name = self:GetAttribute("actiontype")

				-- Custom update
				if _UpdateSnippet[name] then
					Manager:RunFor(
						self, _UpdateSnippet[name],
						self:GetAttribute(_ActionTargetMap[name]),
						_ActionTargetMap2[name] and self:GetAttribute(_ActionTargetMap2[name])
					)
				end

				self:CallMethod("IFActionHandler_UpdateAction")
			]=]

			DragStart = [=[
				local name = self:GetAttribute("actiontype")

				if not _DragStyle[name] or _DragStyle[name] == "Block" then return false end

				local target = self:GetAttribute(_ActionTargetMap[name])
				local target2 = _ActionTargetMap2[name] and self:GetAttribute(_ActionTargetMap2[name])

				-- Clear and refresh
				if _DragStyle[name] == "Clear" then
					Manager:RunFor(self, ClearAction)
					Manager:RunFor(self, UpdateAction)
				end

				-- Pickup the target
				if _PickupSnippet[name] == "Custom" then
					Manager:CallMethod("OnPickUp", name, target, target2)
					return false
				elseif _PickupSnippet[name] then
					return Manager:RunFor(self, _PickupSnippet[name], target, target2)
				else
					return "clear", _PickupMap[name], target, target2
				end
			]=]

			ReceiveDrag = [=[
				local kind, value, detail, extra = ...

				if not kind or not value then return false end

				local oldName = self:GetAttribute("actiontype")

				if _ReceiveStyle[oldName] == "Block" then return false end

				local oldTarget = oldName and self:GetAttribute(_ActionTargetMap[oldName])
				local oldTarget2 = oldName and _ActionTargetMap2[oldName] and self:GetAttribute(_ActionTargetMap2[oldName])

				if _ReceiveStyle[oldName] == "Clear" then
					Manager:RunFor(self, ClearAction)

					local name = _ReceiveMap[kind]
					local target, target2

					if name then
						if _ReceiveSnippet[name] then
							target, target2 = Manager:RunFor(self, _ReceiveSnippet[name], value, detail, extra)
						else
							target, target2 = value, detail
						end

						if target then
							self:SetAttribute("actiontype", name)

							self:SetAttribute("type", _ActionTypeMap[name])
							self:SetAttribute(_ActionTargetMap[name], target)

							if target2 ~= nil and _ActionTargetMap2[name] then
								self:SetAttribute(_ActionTargetMap2[name], target2)
							end
						end
					end
				end

				Manager:RunFor(self, UpdateAction)

				-- Pickup the target
				if _PickupSnippet[oldName] == "Custom" then
					Manager:CallMethod("OnPickUp", oldName, oldTarget, oldTarget2)
					return false
				elseif _PickupSnippet[oldName] then
					return Manager:RunFor(self, _PickupSnippet[oldName], oldTarget, oldTarget2)
				else
					return "clear", _PickupMap[oldName], oldTarget, oldTarget2
				end
			]=]

			UpdateActionAttribute = [=[
				local name, target, target2 = ...

				-- Clear
				Manager:RunFor(self, ClearAction)

				if name == nil or target == nil then
					name = "empty"
					target = nil
					target2 = nil
				end

				self:SetAttribute("actiontype", name)

				self:SetAttribute("type", _ActionTypeMap[name])
				self:SetAttribute(_ActionTargetMap[name], target)

				if target2 ~= nil and _ActionTargetMap2[name] then
					self:SetAttribute(_ActionTargetMap2[name], target2)
				end

				return Manager:RunFor(self, UpdateAction)
			]=]
		]]
	end)

	_IFActionHandler_OnDragStartSnippet = [[
		if (IsModifierKeyDown() or _NoDraggable[self:GetAttribute("IFActionHandlerGroup")]) and not IsModifiedClick("PICKUPACTION") then return false end

		return Manager:RunFor(self, DragStart)
	]]

	_IFActionHandler_OnReceiveDragSnippet = [[
		return Manager:RunFor(self, ReceiveDrag, kind, value, ...)
	]]

	_IFActionHandler_PostReceiveSnippet = [[
		return Manager:RunFor(Manager:GetFrameRef("UpdatingButton"), ReceiveDrag, %s, %s, %s, %s)
	]]

	_IFActionHandler_UpdateActionSnippet = [[
		return Manager:RunFor(Manager:GetFrameRef("UpdatingButton"), UpdateActionAttribute, %s, %s, %s)
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
			Manager:RunFor(self, UpdateAction)
		end
	]]

	_IFActionHandler_WrapDragPrev = [[
		return "message", "update"
	]]

	_IFActionHandler_WrapDragPost = [[
		Manager:RunFor(self, UpdateAction)
	]]

	------------------------------------------------------
	-- Action Script Hanlder
	------------------------------------------------------
	function PickupAny(kind, target, detail, ...)
		if (kind == "clear") then
			ClearCursor()
			kind, target, detail = target, detail, ...
		end

		if _IFActionTypeHandler[kind] then
			return _IFActionTypeHandler[kind]:PickupAction(target, detail)
		end
	end

	function PreClick(self)
		local oldKind = self:GetAttribute("actiontype")

		if InCombatLockdown() or _IFActionTypeHandler[oldKind].ReceiveStyle ~= "Clear" then
			return
		end

		local kind, value = GetCursorInfo()
		if not kind or not value then return end

		self.__IFActionHandler_PreType = oldKind
		self.__IFActionHandler_PreMsg = true
		self:SetAttribute("type", nil)
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
				local oldTarget = oldKind and self:GetAttribute(_ActionTypeMap[oldKind] or oldKind)

				_IFActionHandler_ManagerFrame:SetFrameRef("UpdatingButton", self)
				_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_PostReceiveSnippet:format(GetFormatString(kind), GetFormatString(value), GetFormatString(subtype), GetFormatString(detail)))

				PickupAny("clear", oldKind, oldTarget)
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
		_IFActionHandler_ManagerFrame:Execute( ("_NoDraggable[%q] = nil"):format(group) )
	end

	function DisableDrag(group)
		group = GetGroup(group)

		_DBCharNoDrag[group] = true
		_IFActionHandler_ManagerFrame:Execute( ("_NoDraggable[%q] = true"):format(group) )
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
    	self:SetFrameRef("IFActionHandler_Manager", _IFActionHandler_ManagerFrame)
    	self:SetAttribute("UpdateAction", [[ return self:GetFrameRef("IFActionHandler_Manager"):RunFor(self, "Manager:RunFor(self, UpdateActionAttribute, ...)", ...) ]])

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

		-- No harm
		target = tonumber(target) or target

		if kind == "action" then
			target = ActionButton_CalculateAction(self)
			desc = GetActionDesc(target)
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

	function SaveAction(self, kind, target, target2)
		_IFActionHandler_ManagerFrame:SetFrameRef("UpdatingButton", self)
		_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_UpdateActionSnippet:format(GetFormatString(kind), GetFormatString(target), GetFormatString(target2)))
	end

	function RegisterMainPage(self)
		_IFActionHandler_ManagerFrame:SetFrameRef("MainPageButton", self)
		_IFActionHandler_ManagerFrame:Execute([[
			local btn = Manager:GetFrameRef("MainPageButton")
			if btn then
				_MainPage[btn] = true
				btn:SetAttribute("actionpage", MainPage[0] or 1)
			end
		]])
		SaveAction(self, "action", self.ID or 1)
	end

	function UnregisterMainPage(self)
		_IFActionHandler_ManagerFrame:SetFrameRef("MainPageButton", self)
		_IFActionHandler_ManagerFrame:Execute([[
			local btn = Manager:GetFrameRef("MainPageButton")
			if btn then
				_MainPage[btn] = nil
				btn:SetAttribute("actionpage", nil)
			end
		]])
		SaveAction(self)
	end

	------------------------------------------------------
	-- Update Handler
	------------------------------------------------------
	_IFActionHandler_GridCounter = _IFActionHandler_GridCounter or 0

	function UpdateGrid(self)
		local kind = self.ActionType

		if kind ~= "pet" and kind ~= "petaction" then
			if _IFActionHandler_GridCounter > 0 or self.ShowGrid or _IFActionTypeHandler[kind].HasAction(self) then
				self.Alpha = 1
			else
				self.Alpha = 0
			end
		end
	end

	_IFActionHandler_PetGridCounter = _IFActionHandler_PetGridCounter or 0

	function UpdatePetGrid(self)
		local kind = self.ActionType

		if kind == "pet" or kind == "petaction" then
			if _IFActionHandler_PetGridCounter > 0 or self.ShowGrid or _IFActionTypeHandler[kind].HasAction(self) then
				self.Alpha = 1
			else
				self.Alpha = 0
			end
		end
	end

	function ForceUpdateAction(self)
		return self:UpdateAction(self.ActionType, self.ActionTarget)
	end

	function UpdateButtonState(self)
		local kind = self.ActionType

		self.Checked = _IFActionTypeHandler[kind].IsActivedAction(self) or _IFActionTypeHandler[kind].IsAutoRepeatAction(self)
	end

	function UpdateUsable(self)
		self.Usable = _IFActionTypeHandler[self.ActionType].IsUsableAction(self)
	end

	function UpdateCount(self)
		local kind = self.ActionType

		if _IFActionTypeHandler[kind].IsConsumableAction(self) then
			local count = _IFActionTypeHandler[kind].GetActionCount(self)

			if count > self.MaxDisplayCount then
				self.Count = "*"
			else
				self.Count = tostring(count)
			end
		else
			local charges, maxCharges = _IFActionTypeHandler[kind].GetActionCharges(self)

			if maxCharges and maxCharges > 1 then
				self.Count = tostring(charges)
			else
				self.Count = ""
			end
		end
	end

	function UpdateCooldown(self)
		self:Fire("OnCooldownUpdate", _IFActionTypeHandler[self.ActionType].GetActionCooldown(self))
	end

	function UpdateFlash(self)
		local kind = self.ActionType

		if (_IFActionTypeHandler[kind].IsAttackAction(self) and _IFActionTypeHandler[kind].IsActivedAction(self)) or _IFActionTypeHandler[kind].IsAutoRepeatAction(self) then
			StartFlash(self)
		else
			StopFlash(self)
		end
	end

	function StartFlash(self)
		self.Flashing = true
		_IFActionHandler_FlashingList[self] = self.Flashing or nil
		if next(_IFActionHandler_FlashingList) then
			_IFActionHandler_FlashingTimer.Enabled = true
		end
		self.FlashVisible = true
		UpdateButtonState(self)
	end

	function StopFlash(self)
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
		_IFActionTypeHandler[self.ActionType].SetTooltip(self, _GameTooltip)
		_IFActionHandler_OnTooltip =self

		IGAS:GetUI(self).UpdateTooltip = UpdateTooltip

		_GameTooltip:Show()
	end

	function UpdateOverlayGlow(self)
		local spellId = _IFActionTypeHandler[self.ActionType].GetSpellId(self)

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
		local inRange = _IFActionTypeHandler[self.ActionType].IsInRange(self)
		self.InRange = inRange == 1 and true or inRange == 0 and false or inRange == nil and nil
	end

	function UpdateFlyout(self)
		self.FlyoutVisible = self.ShowFlyOut or _IFActionTypeHandler[self.ActionType].IsFlyout(self)
	end

	function UpdateAutoCastable(self)
		self.AutoCastable = _IFActionTypeHandler[self.ActionType].IsAutoCastAction(self)
	end

	function UpdateAutoCasting(self)
		self.AutoCasting = _IFActionTypeHandler[self.ActionType].IsAutoCasting(self)
	end

	function UpdateActionButton(self)
		local kind = self.ActionType

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
		if _IFActionTypeHandler[kind].IsEquippedItem(self) and self.Border then
			self.Border:SetVertexColor(0, 1.0, 0, 0.35)
			self.Border.Visible = true
		else
			self.Border.Visible = false
		end

		-- Update Action Text
		if not _IFActionTypeHandler[kind].IsConsumableAction(self) then
			self.Text = _GetActionText(self)
		else
			self.Text = ""
		end

		-- Update icon
		self.Icon = _IFActionTypeHandler[kind].GetActionTexture(self)

		UpdateCount(self)
		UpdateOverlayGlow(self)

		if _IFActionHandler_OnTooltip == self then
			UpdateTooltip(self)
		end

		ForceUpdateAction(self)
	end

	function RefreshTooltip()
		if _IFActionHandler_OnTooltip then
			UpdateTooltip(_IFActionHandler_OnTooltip)
		end
	end

	-- Special definition
	__Final__() __NonInheritable__() __NonExpandable__()
	interface "ActionRefreshMode"
		RefreshGrid = UpdateGrid,
		RefreshPetGrid = UpdatePetGrid,
		RefreshButtonState = UpdateButtonState,
		RefreshUsable = UpdateUsable,
		RefreshCooldown = UpdateCooldown,
		RefreshFlash = UpdateFlash,
		RefreshFlyout = UpdateFlyout,
		RefreshAutoCastable = UpdateAutoCastable,
		RefreshAutoCasting = UpdateAutoCasting,
		RefreshActionButton = UpdateActionButton,
		RefreshCount = UpdateCount,
		RefreshOverlayGlow = UpdateOverlayGlow,
		RefreshTooltip = RefreshTooltip,
	endinterface "ActionRefreshMode"

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

	function _IFActionHandler_ManagerFrame:ARCHAEOLOGY_CLOSED()
		_IFActionHandler_Buttons:Each(UpdateButtonState)
	end

	function _IFActionHandler_ManagerFrame:PET_BAR_SHOWGRID()
		_IFActionHandler_PetGridCounter = _IFActionHandler_PetGridCounter + 1
		if _IFActionHandler_PetGridCounter == 1 then
			_IFActionHandler_Buttons:EachK("pet", UpdatePetGrid)
		end
	end

	function _IFActionHandler_ManagerFrame:PET_BAR_HIDEGRID()
		if _IFActionHandler_PetGridCounter > 0 then
			_IFActionHandler_PetGridCounter = _IFActionHandler_PetGridCounter - 1
			if _IFActionHandler_PetGridCounter == 0 then
				_IFActionHandler_Buttons:EachK("pet", UpdatePetGrid)
			end
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
		if unit == "player" then
			return RefreshTooltip()
		end
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
	require "CheckButton"

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
		return _IFActionTypeHandler[kind].HasAction(self)
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
		Set = function (self, group)
			group = GetGroup(group)

			self:SetAttribute("IFActionHandlerGroup", group)

	    	if _DBCharUseDown[group] then
	    		self:RegisterForClicks("AnyDown")
			else
				self:RegisterForClicks("AnyUp")
			end
		end,
		Get = function (self)
			return self:GetAttribute("IFActionHandlerGroup")
		end
		Default = _GlobalGroup,
		Type = String + nil,
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
		Default = "empty",
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

	doc [======[
		@name MaxDisplayCount
		@type property
		@desc The max count to display
	]======]
	property "MaxDisplayCount" { Type = Number, Default = 9999 }

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
    	_IFActionHandler_UpdateRangeTimer.Enabled = true
    	InitEventHandler()

    	-- Don't know how authors would treat the property, so make sure all done here.
    	local group = GetGroup(self.IFActionHandlerGroup)

    	self:SetAttribute("IFActionHandlerGroup", group)

    	if _DBCharUseDown[group] then
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
