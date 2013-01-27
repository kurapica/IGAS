-- Author      : Kurapica
-- Create Date : 2012/09/13
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Action.IFKeyBinding", version) then
	return
end

------------------------------------------------------
-- Module
--
-- DB :
--		_DBChar
--		Action_IFKeyBinding_DB
------------------------------------------------------
do
	_IFKeyBinding_Loaded = _IFKeyBinding_Loaded or false
	_M._IFKeyBinding_InBindingMode = _M._IFKeyBinding_InBindingMode or false
	_IFKeyBinding_ButtonList = _IFKeyBinding_ButtonList or Array()
	_IFKeyBinding_KeyMap = _IFKeyBinding_KeyMap or {}

	_M:ActiveThread("OnLoad")

	_IFKeyBinding_MsgBox = PopupDialog("IGAS_Action_IFKeyBinding_MSGBOX")
	_IFKeyBinding_MsgBox.Style = "LIGHT"
	_IFKeyBinding_MsgBox.OkayButtonText = L"Okay"
	_IFKeyBinding_MsgBox.NoButtonText = L"No"
	_IFKeyBinding_MsgBox.CancelButtonText = L"Cancel"
	_IFKeyBinding_MsgBox.Message = L"Move cursor over the button to binding key."
	_IFKeyBinding_MsgBox.ShowNoButton = false
	_IFKeyBinding_MsgBox.ShowCancelButton = false
	_IFKeyBinding_MsgBox.ShowInputBox = false

	_IFKeyBinding_MaskFrame = Button("IGAS_IFKeyBinding_Mask")
	_IFKeyBinding_MaskFrame.Visible = false
	_IFKeyBinding_MaskFrame.TopLevel = true
	_IFKeyBinding_MaskFrame.FrameStrata = "TOOLTIP"
	_IFKeyBinding_MaskFrame.MouseWheelEnabled = true
	_IFKeyBinding_MaskFrame.KeyboardEnabled = true
	_IFKeyBinding_MaskFrame:RegisterForClicks("anyUp")

	_IFKeyBinding_MaskFrame.Backdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 8,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}
	_IFKeyBinding_MaskFrame.BackdropColor = ColorType(0, 1, 0, 0.4)
	_IFKeyBinding_MaskFrame:ActiveThread("OnShow")

	_IFKeyBinding_KeyFilter = setmetatable(
		{
			["ESCAPE"] = false,
			["PRINTSCREEN"] = false,
			["LSHIFT"] = false,
			["RSHIFT"] = false,
			["LCTRL"] = false,
			["LALT"] = false,
			["RALT"] = false,
			["RCTRL"] = false,
			["UNKNOWN"] = false,
		},{
			__index = function (self, key)
				if type(key) == "string" then
					return true
				end
			end
		}
	)

	GameTooltip = _G.GameTooltip

	function ParseBindKey(key)
		local ret

		if type(key) == "string" and strtrim(key) ~= "" then
			key = strtrim(key):upper()

			-- Check the tail key is "-"
			if key:sub(-1) == "-" then
				 ret = "-"
			else
				ret = key:match("[^-]+$")
			end

			if not ret or ret == "" or not _IFKeyBinding_KeyFilter[ret] then
				return
			end

			-- Remap mouse key
			if ret == "LEFTBUTTON" then
				ret = "BUTTON1"
			elseif ret == "RIGHTBUTTON" then
				ret = "BUTTON2"
			elseif ret == "MIDDLEBUTTON" then
				ret = "BUTTON3"
			end

			-- Remap option key
			if key:find("SHIFT-") then
				ret = "SHIFT-" .. ret
			end

			if key:find("CTRL-") then
				ret = "CTRL-" .. ret
			end

			if key:find("ALT-") then
				ret = "ALT-" .. ret
			end
		end

		return ret
	end

	function OnLoad(self)
		-- DB
		IGAS_DB_Char.Action_IFKeyBinding_DB = IGAS_DB_Char.Action_IFKeyBinding_DB or {}
		_DBChar = IGAS_DB_Char.Action_IFKeyBinding_DB

		if InCombatLockdown() then
			System.Threading.WaitEvent "PLAYER_REGEN_ENABLED"
		end

		for _, frm in ipairs(_IFKeyBinding_ButtonList) do
			frm:UpdateBindingKey()
		end

		_IFKeyBinding_Loaded = true

		self:RegisterEvent"PLAYER_REGEN_DISABLED"
		self:RegisterEvent"PET_BATTLE_OPENING_START"
		self:RegisterEvent"PET_BATTLE_CLOSE"
		self.OnLoad = nil
	end

	_Addon.OnSlashCmd = _Addon.OnSlashCmd + function(self, option, info)
		if option and (option:lower() == "kb" or option:lower() == "keybinding") then
			if InCombatLockdown() then return end

			_M._IFKeyBinding_InBindingMode = true
			_IFKeyBinding_MsgBox.Visible = true

			return true
		end
	end

	function PLAYER_REGEN_DISABLED(self)
		_IFKeyBinding_MsgBox.Visible = false
	end

	function PET_BATTLE_OPENING_START(self)
		-- Remove 1-6 binding
		local key, btn
		for i = 1, 6 do
			key = tostring(i)
			btn = _IFKeyBinding_KeyMap[key]
			if btn then
				ClearOverrideBindings(IGAS:GetUI(btn))
			end
		end
	end

	function PET_BATTLE_CLOSE(self)
		-- Rebinding for 1-6
		local key, btn
		for i = 1, 6 do
			key = tostring(i)
			btn = _IFKeyBinding_KeyMap[key]
			if btn then
				SetOverrideBindingClick(IGAS:GetUI(btn), false, key, btn:GetName(), "LeftButton")
			end
		end
	end

	function _IFKeyBinding_MsgBox:OnHide()
		_M._IFKeyBinding_InBindingMode = false
		_IFKeyBinding_MaskFrame.Visible = false
	end

	function _IFKeyBinding_MaskFrame:OnClick(button)
		BindingKey2Button(button)
	end

	function _IFKeyBinding_MaskFrame:OnKeyDown(key)
		BindingKey2Button(key)
	end

	function _IFKeyBinding_MaskFrame:OnMouseWheel(wheel)
		if wheel > 0 then
			BindingKey2Button("MOUSEWHEELUP")
		else
			BindingKey2Button("MOUSEWHEELDOWN")
		end
	end

	function _IFKeyBinding_MaskFrame:OnShow()
		Threading.Sleep(0.1)	-- Can't show GameTooltip when first show, so we just wait.
		if self.BindingButton then
			local text = self.BindingButton:GetBindingKey()
			if text and text ~= "" then
				if self:GetRight() >= (GetScreenWidth() / 2) then
					GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
				else
					GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
				end

				GameTooltip:SetText(text, 0, 1, 0)
				GameTooltip:Show()
			end
		end
	end

	function _IFKeyBinding_MaskFrame:OnLeave()
		GameTooltip:Hide()
		_IFKeyBinding_MaskFrame.Visible = false
	end

	function _IFKeyBinding_MaskFrame:OnHide()
		_IFKeyBinding_MaskFrame:ClearAllPoints()
		_IFKeyBinding_MaskFrame.BindingButton = nil
	end

	function BindingKey2Button(key)
		if _IFKeyBinding_MaskFrame.BindingButton and key then
			key = key:upper()

			if key == "UNKNOWN" or
				key == "LSHIFT" or
				key == "RSHIFT" or
				key == "LCTRL" or
				key == "RCTRL" or
				key == "LALT" or
				key == "RALT" then
				return
			end

			if key == GetBindingKey("SCREENSHOT") then
				return Screenshot()
			end

			if key == GetBindingKey("OPENCHAT") then
				return ChatFrameEditBox:Show()
			end

			if key == "ESCAPE" then
				return _IFKeyBinding_MaskFrame.BindingButton:ClearBindingKey()
			end

			-- Remap mouse key
			if key == "LEFTBUTTON" then
				key = "BUTTON1"
			elseif key == "RIGHTBUTTON" then
				key = "BUTTON2"
			elseif key == "MIDDLEBUTTON" then
				key = "BUTTON3"
			end

			if IsShiftKeyDown() then
				key = "SHIFT-" .. key
			end
			if IsControlKeyDown() then
				key = "CTRL-" .. key
			end
			if IsAltKeyDown() then
				key = "ALT-" .. key
			end

			_IFKeyBinding_MaskFrame.BindingButton:SetBindingKey(key)

			return _IFKeyBinding_MaskFrame.Visible and _IFKeyBinding_MaskFrame:OnShow()
		end
	end

	function ToShortKey(key)
		if key then
			key = key:upper()
			key = key:gsub(' ', '')
			key = key:gsub('ALT%-', 'A')
			key = key:gsub('CTRL%-', 'C')
			key = key:gsub('SHIFT%-', 'S')
			key = key:gsub('NUMPAD', 'N')

			key = key:gsub('PLUS', '%+')
			key = key:gsub('MINUS', '%-')
			key = key:gsub('MULTIPLY', '%*')
			key = key:gsub('DIVIDE', '%/')

			key = key:gsub('BACKSPACE', 'BS')

			for i = 1, 31 do
				key = key:gsub('BUTTON' .. i, 'B'..i)
			end

			key = key:gsub('CAPSLOCK', 'CP')
			key = key:gsub('CLEAR', 'CL')
			key = key:gsub('DELETE', 'DL')
			key = key:gsub('END', 'EN')
			key = key:gsub('HOME', 'HM')
			key = key:gsub('INSERT', 'IN')
			key = key:gsub('MOUSEWHEELDOWN', 'MD')
			key = key:gsub('MOUSEWHEELUP', 'MU')
			key = key:gsub('NUMLOCK', 'NL')
			key = key:gsub('PAGEDOWN', 'PD')
			key = key:gsub('PAGEUP', 'PU')
			key = key:gsub('SCROLLLOCK', 'SL')
			key = key:gsub('SPACEBAR', 'SP')
			key = key:gsub('SPACE', 'SP')
			key = key:gsub('TAB', 'TB')

			key = key:gsub('DOWNARROW', 'DN')
			key = key:gsub('LEFTARROW', 'LF')
			key = key:gsub('RIGHTARROW', 'RT')
			key = key:gsub('UPARROW', 'UP')

			return key
		end
	end
end

interface "IFKeyBinding"

	doc [======[
		@name IFKeyBinding
		@type interface
		@desc IFKeyBinding is used to manage key bindings
	]======]

	local function Clear4key(key)
		if not key then return end
		local btn = _IFKeyBinding_KeyMap[key]
		_IFKeyBinding_KeyMap[key] = nil
		if btn then
			ClearOverrideBindings(IGAS:GetUI(btn))
			_DBChar[btn:GetName()] = nil
			btn.HotKey = nil
		end
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Interface Method
	------------------------------------------------------
	doc [======[
		@name _Export
		@type method
		@desc Export key binding settings
		@return table the key binding settings
	]======]
	function _Export()
		local exp = {}

		for name, key in pairs(_DBChar) do
			exp[name] = key
		end

		return exp
	end

	doc [======[
		@name _Import
		@type method
		@desc Import key binding settings
		@param settings table, contains the key bindings
		@return nil
	]======]
	function _Import(setting)
		_Clear()

		if type(setting) == "table" then
			for name, key in pairs(setting) do
				if type(name) == "string" and type(key) == "string" then
					_DBChar[name] = key
				end
			end

			_IFKeyBinding_ButtonList:Each(UpdateBindingKey)
		end
	end

	doc [======[
		@name _Clear
		@type method
		@desc Clear all key bindings
		@return nil
	]======]
	function _Clear()
		wipe(_DBChar)
		wipe(_IFKeyBinding_KeyMap)
		_IFKeyBinding_ButtonList:Each(ClearBindingKey)
	end

	doc [======[
		@name _ModeOn
		@type method
		@desc Turn binding mode on
		@return nil
	]======]
	function _ModeOn()
		if not _IFKeyBinding_MsgBox.Visible and not InCombatLockdown() then
			_M._IFKeyBinding_InBindingMode = true
			_IFKeyBinding_MsgBox.Visible = true
		end
	end

	doc [======[
		@name _ModeOff
		@type method
		@desc Turn binding mode off
		@return nil
	]======]
	function _ModeOff()
		_IFKeyBinding_MsgBox.Visible = false
	end

	doc [======[
		@name _IsModeOn
		@type method
		@desc Whether if key binding mode is on
		@return boolean true if the key binding mode is on
	]======]
	function _IsModeOn()
		return _M._IFKeyBinding_InBindingMode
	end

	doc [======[
		@name _Toggle
		@type method
		@desc Toggle the key binding mode
		@return nil
	]======]
	function _Toggle()
		if _M._IFKeyBinding_InBindingMode then
			_ModeOff()
		else
			_ModeOn()
		end
	end

	------------------------------------------------------
	-- Object Method
	------------------------------------------------------
	doc [======[
		@name SetBindingKey
		@type method
		@desc Set the binding key
		@param key string, the binding key
		@return nil
	]======]
	function SetBindingKey(self, key)
		local name = self:GetName()
		key = ParseBindKey(key)

		if not key then
			return ClearBindingKey(self)
		end

		if _DBChar[name] == key and _IFKeyBinding_KeyMap[key] == self then
			return
		end

		ClearBindingKey(self)

		_DBChar[name] = key
		UpdateBindingKey(self)
	end

	doc [======[
		@name GetBindingKey
		@type method
		@desc Get the binding key
		@return string the binding key
	]======]
	function GetBindingKey(self)
		return _DBChar[self:GetName()]
	end

	doc [======[
		@name UpdateBindingKey
		@type method
		@desc Update the binding key
		@return nil
	]======]
	function UpdateBindingKey(self)
		local name = self:GetName()
		local key = _DBChar[name]

		if _IFKeyBinding_KeyMap[key] == self then
			return
		end

		Clear4key(key)

		ClearOverrideBindings(IGAS:GetUI(self))

		if key then
			_IFKeyBinding_KeyMap[key] = self
			SetOverrideBindingClick(IGAS:GetUI(self), false, _DBChar[name], name, "LeftButton")
			self.HotKey = ToShortKey(key)
		else
			self.HotKey = nil
		end
	end

	doc [======[
		@name ClearBindingKey
		@type method
		@desc Clear the binding key
		@return nil
	]======]
	function ClearBindingKey(self)
		local name = self:GetName()
		ClearOverrideBindings(IGAS:GetUI(self))
		if _DBChar[name] then _IFKeyBinding_KeyMap[_DBChar[name]] = nil end
		_DBChar[name] = nil
		self.HotKey = nil
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name HotKey
		@type property
		@desc the hotkey property, need override
	]======]
	property "HotKey" {
		Get = function(self)
			return self.__HotKey
		end,
		Set = function(self, value)
			self.__HotKey = value
		end,
		Type = System.String + nil,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnEnter(self)
		if _M._IFKeyBinding_InBindingMode then
			_IFKeyBinding_MaskFrame:ClearAllPoints()
			_IFKeyBinding_MaskFrame:SetAllPoints(self)
			_IFKeyBinding_MaskFrame.BindingButton = self
			_IFKeyBinding_MaskFrame:Show()
		end
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		ClearBindingKey(self)
		_IFKeyBinding_ButtonList:Remove(self)
	end

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
    function IFKeyBinding(self)
		if Reflector.ObjectIsClass(self, Button) then
			_IFKeyBinding_ButtonList:Insert(self)

			self.OnEnter = self.OnEnter + OnEnter

			if _IFKeyBinding_Loaded then
				IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateBindingKey, self)
			end
		end
    end
endinterface "IFKeyBinding"