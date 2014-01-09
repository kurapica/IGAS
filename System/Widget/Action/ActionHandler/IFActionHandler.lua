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
	_ActionTargetDetail = {}
	_ReceiveMap = {}

	_AutoAttackButtons = setmetatable({}, {__mode = "k"})
	_AutoRepeatButtons = setmetatable({}, getmetatable(_AutoAttackButtons))
	_Spell4Buttons = setmetatable({}, getmetatable(_AutoAttackButtons))

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
	doc [======[
		@name OnEnableChanged
		@type event
		@desc Fired when the handler is enabled or disabled
	]======]
	event "OnEnableChanged"

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
		if type(button) ~= "table" then
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
		return IFNoCombatTaskHandler._RegisterNoCombatTask( SecureFrame.Execute, _IFActionHandler_ManagerFrame, code )
	end

	------------------------------------------------------
	-- Overridable Method
	------------------------------------------------------
	doc [======[
		@name GetActionDetail
		@type method
		@desc Get the actions's kind, target & detail
		@return kind
		@return target
		@return detail
	]======]
	function GetActionDetail(self)
		local name = self:GetAttribute("actiontype")
		return self:GetAttribute(_ActionTargetMap[name]), _ActionTargetDetail[name] and self:GetAttribute(_ActionTargetDetail[name])
	end

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
		return
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
		@name Enabled
		@type property
		@desc Whether the handler is enabled(has buttons)
	]======]
	property "Enabled" { Type = Boolean, Event = "OnEnableChanged" }

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
		@name Detail
		@type property
		@desc The detail attribute name
	]======]
	property "Detail" { Type = String + nil }

	doc [======[
		@name IsPlayerAction
		@type property
		@desc Whether the action is player action
	]======]
	property "IsPlayerAction" { Type = Boolean, Default = true }

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
    	if self.PickupMap == nil then self.PickupMap = self.Type end

		-- Register action type map
		_ActionTypeMap[self.Name] = self.Type
		_ActionTargetMap[self.Name] = self.Target
		_ActionTargetDetail[self.Name]  = self.Detail
		self:RunSnippet( _RegisterSnippetTemplate:format("_ActionTypeMap", self.Name, self.Type) )
		self:RunSnippet( _RegisterSnippetTemplate:format("_ActionTargetMap", self.Name, self.Target) )
		if self.Detail then self:RunSnippet( _RegisterSnippetTemplate:format("_ActionTargetDetail", self.Name, self.Detail) ) end

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
		if self.ReceiveMap then
			self:RunSnippet( _RegisterSnippetTemplate:format("_ReceiveMap", self.ReceiveMap, self.Name) )
			_ReceiveMap[self.ReceiveMap] = self
		end

		-- Register PickupMap
		if self.PickupMap then self:RunSnippet( _RegisterSnippetTemplate:format("_PickupMap", self.Name, self.PickupMap) ) end

		-- Clear
		self.InitSnippet = nil
		self.PickupSnippet = nil
		self.UpdateSnippet = nil
		self.ReceiveSnippet = nil
		self.ClearSnippet = nil
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

		if kind ~= nil and not _IFActionTypeHandler[kind] then
			error("value not supported.", 2)
		end

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
				if next then
					next[preKey] = prev
				else
					_IFActionTypeHandler[kind].Enabled = false
				end
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

			_IFActionTypeHandler[kind].Enabled = true
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

	-- Custom pick up handler
	IGAS:GetUI(_IFActionHandler_ManagerFrame).OnPickUp = function (self, kind, target, detail)
		if not InCombatLockdown() then
			return PickupAny("clear", kind, target, detail)
		end
	end

	-- Spell activation alert recycle manager
	_RecycleAlert = Recycle(SpellActivationAlert, "SpellActivationAlert%d", _IFActionHandler_ManagerFrame)

	-- Timer
	_IFActionHandler_UpdateRangeTimer = Timer("RangeTimer", _IFActionHandler_ManagerFrame)
	_IFActionHandler_UpdateRangeTimer.Enabled = false
	_IFActionHandler_UpdateRangeTimer.Interval = _UpdateRangeInterval

	_IFActionHandler_FlashingTimer = Timer("FlashingTimer", _IFActionHandler_ManagerFrame)
	_IFActionHandler_FlashingTimer.Enabled = false
	_IFActionHandler_FlashingTimer.Interval = _FlashInterval

	_IFActionHandler_FlashingList = setmetatable({}, getmetatable(_AutoAttackButtons))

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
			_ActionTargetDetail = newtable()

			_ReceiveMap = newtable()
			_PickupMap = newtable()

			_ClearSnippet = newtable()
			_UpdateSnippet = newtable()
			_PickupSnippet = newtable()
			_ReceiveSnippet = newtable()

			_DragStyle = newtable()
			_ReceiveStyle = newtable()

			UpdateAction = [=[
				local name = self:GetAttribute("actiontype")

				-- Custom update
				if _UpdateSnippet[name] then
					Manager:RunFor(
						self, _UpdateSnippet[name],
						self:GetAttribute(_ActionTargetMap[name]),
						_ActionTargetDetail[name] and self:GetAttribute(_ActionTargetDetail[name])
					)
				end

				self:CallMethod("IFActionHandler_UpdateAction")
			]=]

			ClearAction = [=[
				local name = self:GetAttribute("actiontype")

				if name and name ~= "empty" then
					self:SetAttribute("actiontype", "empty")

					self:SetAttribute("type", nil)
					self:SetAttribute(_ActionTargetMap[name], nil)
					if _ActionTargetDetail[name] then
						self:SetAttribute(_ActionTargetDetail[name], nil)
					end

					-- Custom clear
					if _ClearSnippet[name] then
						Manager:RunFor(self, _ClearSnippet[name])
					end
				end
			]=]

			CopyAction = [=[
				local source = ...
				local name = source:GetAttribute("actiontype")
				local target = source:GetAttribute(_ActionTargetMap[name])
				local detail = _ActionTargetDetail[name] and source:GetAttribute(_ActionTargetDetail[name])

				Manager:RunFor(self, ClearAction)

				self:SetAttribute("actiontype", name)

				self:SetAttribute("type", _ActionTypeMap[name])
				self:SetAttribute(_ActionTargetMap[name], target)

				if detail ~= nil and _ActionTargetDetail[name] then
					self:SetAttribute(_ActionTargetDetail[name], detail)
				end

				Manager:RunFor(self, UpdateAction)
			]=]

			SwapAction = [=[
				local source = ...

				local name = source:GetAttribute("actiontype")
				local target = source:GetAttribute(_ActionTargetMap[name])
				local detail = _ActionTargetDetail[name] and source:GetAttribute(_ActionTargetDetail[name])

				local sname = self:GetAttribute("actiontype")
				local starget = self:GetAttribute(_ActionTargetMap[sname])
				local sdetail = _ActionTargetDetail[sname] and self:GetAttribute(_ActionTargetDetail[sname])

				Manager:RunFor(source, ClearAction)
				Manager:RunFor(self, ClearAction)

				-- Set for source
				source:SetAttribute("actiontype", sname)

				source:SetAttribute("type", _ActionTypeMap[sname])
				source:SetAttribute(_ActionTargetMap[sname], starget)

				if sdetail ~= nil and _ActionTargetDetail[sname] then
					source:SetAttribute(_ActionTargetDetail[sname], sdetail)
				end

				-- Set for self
				self:SetAttribute("actiontype", name)

				self:SetAttribute("type", _ActionTypeMap[name])
				self:SetAttribute(_ActionTargetMap[name], target)

				if detail ~= nil and _ActionTargetDetail[name] then
					self:SetAttribute(_ActionTargetDetail[name], detail)
				end

				Manager:RunFor(source, UpdateAction)
				Manager:RunFor(self, UpdateAction)
			]=]

			DragStart = [=[
				local name = self:GetAttribute("actiontype")

				if _DragStyle[name] == "Block" then return false end

				local target = self:GetAttribute(_ActionTargetMap[name])
				local detail = _ActionTargetDetail[name] and self:GetAttribute(_ActionTargetDetail[name])

				-- Clear and refresh
				if _DragStyle[name] == "Clear" then
					Manager:RunFor(self, ClearAction)
					Manager:RunFor(self, UpdateAction)
				end

				-- Pickup the target
				if _PickupSnippet[name] == "Custom" then
					Manager:CallMethod("OnPickUp", name, target, detail)
					return false
				elseif _PickupSnippet[name] then
					return Manager:RunFor(self, _PickupSnippet[name], target, detail)
				else
					return "clear", _PickupMap[name], target, detail
				end
			]=]

			ReceiveDrag = [=[
				local kind, value, extra, extra2 = ...

				if not kind or not value then return false end

				local oldName = self:GetAttribute("actiontype")

				if _ReceiveStyle[oldName] == "Block" then return false end

				local oldTarget = oldName and self:GetAttribute(_ActionTargetMap[oldName])
				local oldDetail = oldName and _ActionTargetDetail[oldName] and self:GetAttribute(_ActionTargetDetail[oldName])

				if _ReceiveStyle[oldName] == "Clear" then
					Manager:RunFor(self, ClearAction)

					local name = _ReceiveMap[kind]
					local target, detail

					if name then
						if _ReceiveSnippet[name] then
							target, detail = Manager:RunFor(self, _ReceiveSnippet[name], value, extra, extra2)
						else
							target, detail = value, detail
						end

						if target then
							self:SetAttribute("actiontype", name)

							self:SetAttribute("type", _ActionTypeMap[name])
							self:SetAttribute(_ActionTargetMap[name], target)

							if detail ~= nil and _ActionTargetDetail[name] then
								self:SetAttribute(_ActionTargetDetail[name], detail)
							end
						end
					end
				end

				Manager:RunFor(self, UpdateAction)

				-- Pickup the target
				if _PickupSnippet[oldName] == "Custom" then
					Manager:CallMethod("OnPickUp", oldName, oldTarget, oldDetail)
					return false
				elseif _PickupSnippet[oldName] then
					return Manager:RunFor(self, _PickupSnippet[oldName], oldTarget, oldDetail)
				else
					return "clear", _PickupMap[oldName], oldTarget, oldDetail
				end
			]=]

			UpdateActionAttribute = [=[
				local name, target, detail = ...

				-- Clear
				Manager:RunFor(self, ClearAction)

				if name and _ActionTypeMap[name] and target then
					self:SetAttribute("actiontype", name)

					self:SetAttribute("type", _ActionTypeMap[name])
					self:SetAttribute(_ActionTargetMap[name], target)

					if detail ~= nil and _ActionTargetDetail[name] then
						self:SetAttribute(_ActionTargetDetail[name], detail)
					end
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
			return Manager:RunFor(self, UpdateAction)
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

		if InCombatLockdown() or (oldKind and _IFActionTypeHandler[oldKind].ReceiveStyle ~= "Clear") then
			return
		end

		local kind, value = GetCursorInfo()
		if not kind or not value then return end

		self.__IFActionHandler_PreType = self:GetAttribute("type")
		self.__IFActionHandler_PreMsg = true

		-- Make sure no action used
		self:SetAttribute("type", nil)
	end

	function PostClick(self)
		UpdateButtonState(self)

		-- Restore the action
		if self.__IFActionHandler_PreMsg then
			if not InCombatLockdown() then
				if self.__IFActionHandler_PreType then
					self:SetAttribute("type", self.__IFActionHandler_PreType)
				end

				local kind, value, subtype, detail = GetCursorInfo()

				if kind and value and _ReceiveMap[kind] then
					local oldName = self.__IFActionHandler_Kind
					local oldTarget = self.__IFActionHandler_Target
					local oldDetail = self.__IFActionHandler_Detail

					_IFActionHandler_ManagerFrame:SetFrameRef("UpdatingButton", self)
					_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_PostReceiveSnippet:format(GetFormatString(kind), GetFormatString(value), GetFormatString(subtype), GetFormatString(detail)))

					if oldName and oldTarget then
						PickupAny("clear", oldName, oldTarget, oldDetail)
					end
				end
			elseif self.__IFActionHandler_PreType then
				-- Keep safe
				IFNoCombatTaskHandler._RegisterNoCombatTask(self.SetAttribute, self, "type", self.__IFActionHandler_PreType)
			end

			self.__IFActionHandler_PreType = nil
			self.__IFActionHandler_PreMsg = nil
		end
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
				if GetGroup(self.IFActionHandlerGroup) == group then
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
				if GetGroup(self.IFActionHandlerGroup) == group then
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
		_IFActionHandler_ManagerFrame:WrapScript(self, "OnDragStart", _IFActionHandler_OnDragStartSnippet)
		_IFActionHandler_ManagerFrame:WrapScript(self, "OnReceiveDrag", _IFActionHandler_OnReceiveDragSnippet)

    	_IFActionHandler_ManagerFrame:WrapScript(self, "OnClick", _IFActionHandler_WrapClickPrev, _IFActionHandler_WrapClickPost)
    	_IFActionHandler_ManagerFrame:WrapScript(self, "OnDragStart", _IFActionHandler_WrapDragPrev, _IFActionHandler_WrapDragPost)
    	_IFActionHandler_ManagerFrame:WrapScript(self, "OnReceiveDrag", _IFActionHandler_WrapDragPrev, _IFActionHandler_WrapDragPost)

    	-- Button UpdateAction method added to secure part
    	self:SetFrameRef("IFActionHandler_Manager", _IFActionHandler_ManagerFrame)
    	self:SetAttribute("UpdateAction", [[ return self:GetFrameRef("IFActionHandler_Manager"):RunFor(self, "Manager:RunFor(self, UpdateActionAttribute, ...)", ...) ]])
    	self:SetAttribute("ClearAction", [[ return self:GetFrameRef("IFActionHandler_Manager"):RunFor(self, "Manager:RunFor(self, ClearAction, ...)", ...) ]])
    	self:SetAttribute("CopyAction", [[ return self:GetFrameRef("IFActionHandler_Manager"):RunFor(self, "Manager:RunFor(self, CopyAction, ...)", ...) ]])
    	self:SetAttribute("SwapAction", [[ return self:GetFrameRef("IFActionHandler_Manager"):RunFor(self, "Manager:RunFor(self, SwapAction, ...)", ...) ]])

    	if not self:GetAttribute("actiontype") then
    		self:SetAttribute("actiontype", "empty")
    	end

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

	function UI_UpdateActionButton(self)
		self = IGAS:GetWrapper(self)

		local name = self:GetAttribute("actiontype")
		local target, detail = _IFActionTypeHandler[name].GetActionDetail(self)

		-- Some problem with battlepet
		-- target = tonumber(target) or target
		-- detail = tonumber(detail) or detail

		if self.__IFActionHandler_Kind ~= name
			or self.__IFActionHandler_Target ~= target
			or self.__IFActionHandler_Detail ~= detail then

			self.__IFActionHandler_Kind = name
			self.__IFActionHandler_Target = target
			self.__IFActionHandler_Detail = detail

			_IFActionHandler_Buttons[self] = name 	-- keep button in kind's link list

			return UpdateActionButton(self)
		end
	end

	function SaveAction(self, kind, target, detail)
		_IFActionHandler_ManagerFrame:SetFrameRef("UpdatingButton", self)
		_IFActionHandler_ManagerFrame:Execute(_IFActionHandler_UpdateActionSnippet:format(GetFormatString(kind), GetFormatString(target), GetFormatString(detail)))
	end

	------------------------------------------------------
	-- Display functions
	------------------------------------------------------
	_IFActionHandler_GridCounter = 0
	_IFActionHandler_PetGridCounter = 0

	function UpdateGrid(self)
		local kind = self.ActionType

		if _IFActionHandler_GridCounter > 0 or self.ShowGrid or _IFActionTypeHandler[kind].HasAction(self) then
			self.Alpha = 1
		else
			self.Alpha = 0
		end
	end

	function UpdatePetGrid(self)
		local kind = self.ActionType

		if _IFActionHandler_PetGridCounter > 0 or self.ShowGrid or _IFActionTypeHandler[kind].HasAction(self) then
			self.Alpha = 1
		else
			self.Alpha = 0
		end
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
		_IFActionHandler_FlashingTimer.Enabled = true
		self.FlashVisible = true
		UpdateButtonState(self)
	end

	function StopFlash(self)
		self.Flashing = false
		_IFActionHandler_FlashingList[self] = nil
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
		local handler = _IFActionTypeHandler[kind]

		if handler.IsAttackAction(self) then
			_AutoAttackButtons[self] = true
		elseif _AutoAttackButtons[self] then
			_AutoAttackButtons[self] = nil
		end

		if handler.IsAutoRepeatAction(self) then
			_AutoRepeatButtons[self] = true
		elseif _AutoRepeatButtons[self] then
			_AutoRepeatButtons[self] = nil
		end

		_Spell4Buttons[self] = handler.GetSpellId(self)

		if handler.IsPlayerAction and handler.ReceiveStyle ~= "Block" then
			UpdateGrid(self)
		end

		if not handler.IsPlayerAction and handler.ReceiveStyle ~= "Block" then
			UpdatePetGrid(self)
		end

		UpdateButtonState(self)
		UpdateUsable(self)
		UpdateCooldown(self)
		UpdateFlyout(self)
		UpdateAutoCastable(self)
		UpdateAutoCasting(self)

		-- Whether the action is an equipped item
		self.EquippedItemIndicator = handler.IsEquippedItem(self)

		-- Update Action Text
		if not handler.IsConsumableAction(self) then
			self.Text = handler.GetActionText(self)
		else
			self.Text = ""
		end

		-- Update icon
		self.Icon = handler.GetActionTexture(self)

		UpdateCount(self)
		UpdateOverlayGlow(self)

		if _IFActionHandler_OnTooltip == self then
			UpdateTooltip(self)
		end

		return self:UpdateAction()
	end

	function RefreshTooltip()
		if _IFActionHandler_OnTooltip then
			return UpdateTooltip(_IFActionHandler_OnTooltip)
		end
	end

	-- Special definition
	__Final__() __NonInheritable__() __NonExpandable__()
	interface "ActionRefreshMode"
		RefreshGrid = UpdateGrid
		RefreshPetGrid = UpdatePetGrid
		RefreshButtonState = UpdateButtonState
		RefreshUsable = UpdateUsable
		RefreshCooldown = UpdateCooldown
		RefreshFlash = UpdateFlash
		RefreshFlyout = UpdateFlyout
		RefreshAutoCastable = UpdateAutoCastable
		RefreshAutoCasting = UpdateAutoCasting
		RefreshActionButton = UpdateActionButton
		RefreshCount = UpdateCount
		RefreshOverlayGlow = UpdateOverlayGlow
		RefreshTooltip = RefreshTooltip
	endinterface "ActionRefreshMode"

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	_IFActionHandler_InitEvent = false

	function InitEventHandler()
		if _IFActionHandler_InitEvent then return end
		_IFActionHandler_InitEvent = true

		-- Smart event register
		for evt, func in pairs(_IFActionHandler_ManagerFrame) do
			if type(func) == "function" and type(evt) == "string" and evt == strupper(evt) then
				_IFActionHandler_ManagerFrame:RegisterEvent(evt)
			end
		end
	end

	function UninstallEventHandler()
		_IFActionHandler_ManagerFrame:UnregisterAllEvents()
		_IFActionHandler_InitEvent = false
	end

	function _IFActionHandler_ManagerFrame:ACTIONBAR_SHOWGRID()
		_IFActionHandler_GridCounter = _IFActionHandler_GridCounter + 1
		if _IFActionHandler_GridCounter == 1 then
			for kind, handler in pairs(_IFActionTypeHandler) do
				if handler.IsPlayerAction and handler.ReceiveStyle ~= "Block" then
					_IFActionHandler_Buttons:EachK(kind, UpdateGrid)
				end
			end
		end
	end

	function _IFActionHandler_ManagerFrame:ACTIONBAR_HIDEGRID()
		if _IFActionHandler_GridCounter > 0 then
			_IFActionHandler_GridCounter = _IFActionHandler_GridCounter - 1
			if _IFActionHandler_GridCounter == 0 then
				for kind, handler in pairs(_IFActionTypeHandler) do
					if handler.IsPlayerAction and handler.ReceiveStyle ~= "Block" then
						_IFActionHandler_Buttons:EachK(kind, UpdateGrid)
					end
				end
			end
		end
	end

	function _IFActionHandler_ManagerFrame:ARCHAEOLOGY_CLOSED()
		_IFActionHandler_Buttons:Each(UpdateButtonState)
	end

	function _IFActionHandler_ManagerFrame:PET_BAR_SHOWGRID()
		_IFActionHandler_PetGridCounter = _IFActionHandler_PetGridCounter + 1
		if _IFActionHandler_PetGridCounter == 1 then
			for kind, handler in pairs(_IFActionTypeHandler) do
				if not handler.IsPlayerAction and handler.ReceiveStyle ~= "Block" then
					_IFActionHandler_Buttons:EachK(kind, UpdatePetGrid)
				end
			end
		end
	end

	function _IFActionHandler_ManagerFrame:PET_BAR_HIDEGRID()
		if _IFActionHandler_PetGridCounter > 0 then
			_IFActionHandler_PetGridCounter = _IFActionHandler_PetGridCounter - 1
			if _IFActionHandler_PetGridCounter == 0 then
				for kind, handler in pairs(_IFActionTypeHandler) do
					if not handler.IsPlayerAction and handler.ReceiveStyle ~= "Block" then
						_IFActionHandler_Buttons:EachK(kind, UpdatePetGrid)
					end
				end
			end
		end
	end

	function _IFActionHandler_ManagerFrame:PLAYER_ENTER_COMBAT()
		for button in pairs(_AutoAttackButtons) do
			StartFlash(button)
		end
	end

	function _IFActionHandler_ManagerFrame:PLAYER_LEAVE_COMBAT()
		for button in pairs(_AutoAttackButtons) do
			StopFlash(button)
		end
	end

	function _IFActionHandler_ManagerFrame:PLAYER_TARGET_CHANGED()
		_IFActionHandler_UpdateRangeTimer:OnTimer()
	end

	function _IFActionHandler_ManagerFrame:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(spellId)
		for button, id in pairs(_Spell4Buttons) do
			if id == spellId then
				ShowOverlayGlow(button)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(spellId)
		for button, id in pairs(_Spell4Buttons) do
			if id == spellId then
				HideOverlayGlow(button, true)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:SPELL_UPDATE_CHARGES()
		for button in pairs(_Spell4Buttons) do
			UpdateCount(button)
		end
	end

	function _IFActionHandler_ManagerFrame:START_AUTOREPEAT_SPELL()
		for button in paris(_AutoRepeatButtons) do
			if not _AutoAttackButtons[button] then
				StartFlash(button)
			end
		end
	end

	function _IFActionHandler_ManagerFrame:STOP_AUTOREPEAT_SPELL()
		for button in paris(_AutoRepeatButtons) do
			if button.Flashing and not _AutoAttackButtons[button] then
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

			return _RecycleAlert(self)
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
		@desc Used to customize action button when it's content is changed
		@return nil
	]======]
	__Optional__() function UpdateAction(self) end

	doc [======[
		@name SetAction
		@type method
		@desc Set action for the actionbutton
		@param kind System.Widget.Action.IFActionHandler.ActionType, the action type
		@param target the action't target
		@param detail the action's detail
		@return nil
	]======]
	function SetAction(self, kind, target, detail)
		if kind and not _ActionTypeMap[kind] then
			error("IFActionHandler:SetAction(kind, target, detail) - no such action kind", 2)
		end

		if not kind or not target then
			kind, target, detail = nil, nil, nil
		end

		IFNoCombatTaskHandler._RegisterNoCombatTask(SaveAction, self, kind, target, detail)
	end

	doc [======[
		@name GetAction
		@type method
		@desc Get action for the actionbutton
		@return kind System.Widget.Action.IFActionHandler.ActionType, the action type
		@return target any, the action's target
		@return detail any, the action's detail
	]======]
	function GetAction(self)
		return self.__IFActionHandler_Kind, self.__IFActionHandler_Target, self.__IFActionHandler_Detail
	end

	doc [======[
		@name HasAction
		@type method
		@desc Whether the action button has action content
		@return boolean true if the button has action
	]======]
	function HasAction(self)
		return _IFActionTypeHandler[self.ActionType].HasAction(self)
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
	__Optional__() property "IFActionHandlerGroup" {
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
		end,
		Default = _GlobalGroup,
		Type = String + nil,
	}

	------------------------------------------------------
	-- Action Property
	------------------------------------------------------
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
			return self.__IFActionHandler_Target
		end,
	}

	doc [======[
		@name ActionDetail
		@type property
		@desc The action button's detail
	]======]
	property "ActionDetail" {
		Get = function(self)
			return self.__IFActionHandler_Detail
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
			return self.__ShowGrid
		end,
		Set = function(self, value)
			if self.ShowGrid ~= value then
				self.__ShowGrid = value

				if _IFActionTypeHandler[self.ActionType].IsPlayerAction then
					UpdateGrid(self)
				else
					UpdatePetGrid(self)
				end
			end
		end,
		Type = Boolean,
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
		Type = Boolean,
	}

	doc [======[
		@name Usable
		@type property
		@desc Whether the action is usable, used to refresh the action button as a trigger
	]======]
	__Optional__() property "Usable" { Type = Boolean }

	doc [======[
		@name Count
		@type property
		@desc The action's count, used to refresh the action count as a trigger
	]======]
	__Optional__() property "Count" { Type = String }

	doc [======[
		@name Flashing
		@type property
		@desc Whether need flash the action, used to refresh the action count as a trigger
	]======]
	__Optional__() property "Flashing" { Type = Boolean }

	doc [======[
		@name FlashVisible
		@type property
		@desc The action button's flash texture's visible, used to refresh the action count as a trigger
	]======]
	__Optional__() property "FlashVisible" { Type = Boolean }

	doc [======[
		@name FlyoutVisible
		@type property
		@desc The action button's flyout's visible, used to refresh the action count as a trigger
	]======]
	__Optional__() property "FlyoutVisible" { Type = Boolean }

	doc [======[
		@name Text
		@type property
		@desc The action't text, used to refresh the action count as a trigger
	]======]
	__Optional__() property "Text" { Type = String }

	doc [======[
		@name Icon
		@type property
		@desc The action's icon path, used to refresh the action count as a trigger
	]======]
	__Optional__() property "Icon" { Type = String }

	doc [======[
		@name InRange
		@type property
		@desc Whether the action is in range, used to refresh the action count as a trigger
	]======]
	__Optional__() property "InRange" { Type = Boolean+nil }

	doc [======[
		@name FlyoutDirection
		@type property
		@desc The action button's flyout direction, used to refresh the action count as a trigger
	]======]
	property "FlyoutDirection" { Type = FlyoutDirection }

	doc [======[
		@name AutoCastable
		@type property
		@desc Whether the action is auto-castable, used to refresh the action count as a trigger
	]======]
	__Optional__() property "AutoCastable" { Type = Boolean }

	doc [======[
		@name AutoCasting
		@type property
		@desc Whether the action is now auto-casting, used to refresh the action count as a trigger
	]======]
	__Optional__() property "AutoCasting" { Type = Boolean }

	doc [======[
		@name MaxDisplayCount
		@type property
		@desc The max count to display
	]======]
	__Optional__() property "MaxDisplayCount" { Type = Number, Default = 9999 }

	doc [======[
		@name EquippedItemIndicator
		@type property
		@desc Whether an indicator should be shown for equipped item
	]======]
	__Optional__() property "EquippedItemIndicator" { Type = Boolean }

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
