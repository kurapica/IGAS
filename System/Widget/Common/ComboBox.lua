--	Widget name	  	ComboBox
--	Author     	 	  	Kurapica
--	Create Date	 	   	8/01/2008 23:46
--	Change Log
--				11/25/2008	Combine List and ComboBox Widgets.
--				10/16/2009	Only one List will be used for all ComboBoxs
--				12/10/2009	Remove List widget, it's public now.
--				2010.01.10	Add icons and frames settings
--				2010.01.13	Change the List's Parent to WorldFrame
--				2010/02/08  Make the list FrameStrata to TOOLTIP\
--				2010/02/23  Add some properties
--				2010/06/21   Use # to instead of getn, make proxy can be used as keys, items, icons or frames
--				2011/03/13	Recode as class
--              2011/11/02  remove _List:Refresh, so it will refresh when onshow

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- ComboBox is using for choosing one item from a list
-- <br><br>inherit <a href="..\Base\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name ComboBox
-- @class table
-- @field AutoFocus true if the ComboBox automatically acquires keyboard input focus
-- @field DisplayItemCount the count of items to be displayed in the dropdown list of the comboBox
-- @field Value the choosed item's value
-- @field Text the text displayed on the combobox
-- @field Editable true if the combobox's text can be edited, false if the combobox is only selectable
-- @field HideDropDownButton true to hide the drop down button, make it just look like a textbox
-- @field Keys a table that contains keys of the items
-- @field Items a table that contains Text of the items
-- @field Icons a table that contains icons of the items
-- @field Frames a table that contains frames of the items
-- @field ItemCount the item's count
-- @field Style the combobox's style: CLASSIC, LIGHT
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 14
if not IGAS:NewAddon("IGAS.Widget.ComboBox", version) then
	return
end

class "ComboBox"
	inherit "Frame"

	WorldFrame = IGAS.WorldFrame

    ------------------------------------------------------
	---------------------  List   ----------------------
	------------------------------------------------------
	_List = _List

	if not _List then
        local _ComboBoxListContainer = Frame("IGAS_GUI_ListContainer", WorldFrame)
        _ComboBoxListContainer.__ShowList = _ComboBoxListContainer.__ShowList or nil
		if not _ComboBoxListContainer.__Timer then
			local timer = Timer("Timer", _ComboBoxListContainer)
			timer.Interval = 0
			timer.OnTimer = function(self)
				self.Interval = 0
				if self.Parent.__ShowList then
					self.Parent.__ShowList.Visible = false
				end
			end
			_ComboBoxListContainer.__Timer = timer
		end

		-- Create List
		_List = List(nil, _ComboBoxListContainer)
		_List.FrameStrata = "TOOLTIP"
		_List.Visible = false

		-- Scripts
        function _List:OnShow()
            if _ComboBoxListContainer.__ShowList and _ComboBoxListContainer.__ShowList ~= self then
                _ComboBoxListContainer.__ShowList.Visible = false
            end

			_ComboBoxListContainer.__Timer.Interval = 2

            _ComboBoxListContainer.__ShowList = self
        end

        function _List:OnHide()
            if _ComboBoxListContainer.__ShowList and _ComboBoxListContainer.__ShowList == self then
                _ComboBoxListContainer.__ShowList = nil
            end
			_ComboBoxListContainer.__Timer.Interval = 0
        end

		function _List:OnEnter()
			_ComboBoxListContainer.__Timer.Interval = 0
		end

		function _List:OnLeave(self)
			_ComboBoxListContainer.__Timer.Interval = 2
		end

		function _List:OnItemChoosed(key, text, icon, frame)
			local parent = self.__ComboBox

			if not parent then return end

			if not self.Visible then return end

			if parent.__Value ~= key then
				parent.__Value = key
				parent:GetChild("Text"):SetText(text or "")
				if icon then
					parent:GetChild("Icon"):SetTexture(icon)
					parent:GetChild("Icon").Width = 18
				else
					parent:GetChild("Icon"):SetTexture(nil)
					parent:GetChild("Icon").Width = 1
				end

				parent:Fire("OnValueChanged", key)
				parent:Fire("OnTextChanged", text)
			end
			self.Visible = false
		end

		_List.__ComboBox = nil
    end

    ------------------------------------------------------
	---------------------   ComboBox   ---------------
	------------------------------------------------------

    -- Style
    TEMPLATE_CLASSIC = "CLASSIC"
    TEMPLATE_LIGHT = "LIGHT"

    -- Define Block
	enum "ComboBoxStyle" {
        TEMPLATE_CLASSIC,
		TEMPLATE_LIGHT,
    }

	-- Script
	_FrameBackdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 9,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}
	_FrameBackdropCommon = {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 9 }
	}

    local function OnClick(self)
		if self.Parent.InDesignMode then
			return
		end
		if _List.Visible and _List.__ComboBox == self.Parent then
			_List.Visible = false
		else
			_List.__ComboBox = self.Parent
			_List:ClearAllPoints()
			if self.Parent:GetBottom() - _List.Height > 0 then
				_List:SetPoint("TOPLEFT", self.Parent, "BOTTOMLEFT")
				_List:SetPoint("TOPRIGHT", self.Parent, "BOTTOMRIGHT")
			else
				_List:SetPoint("BOTTOMLEFT", self.Parent, "TOPLEFT")
				_List:SetPoint("BOTTOMRIGHT", self.Parent, "TOPRIGHT")
			end
			_List.Keys = self.Parent.Keys
			_List.Items = self.Parent.Items
			_List.Icons = self.Parent.Icons
			_List.Frames = self.Parent.Frames
			_List.DisplayItemCount = self.Parent.__DisplayItemCount
			_List.Style = self.Parent.Style
			_List:SelectItemByValue(self.Parent.__Value)
			_List.Visible = true
		end
    end

    local function OnHide(self, ...)
		if _List.__ComboBox == self then
			_List.Visible = false
		end
    end

	local function OnCharComposition(self, char)
	    local value
		local parent = self.Parent
	    local list = parent.Items or {}
	    local text = self:GetText();
		local textlen = strlen(text);
		local i, name;

		if self.Parent.HideDropDownButton then
			return
		end

		if not text or text == "" then
			return
		end

		for i = 1, #list do
			name = list[i]

			if strfind(strupper(name), strupper(text), 1, 1) == 1 then
				self:SetText(name);
				if (self:IsInIMECompositionMode() ) then
					self:HighlightText(textlen - strlen(char), -1);
				else
					self:HighlightText(textlen, -1);
				end

				value = parent.Keys[i]

	            if value then
	                if value ~= parent.__Value then
	                    parent.__Value = value
						if parent.Icons[i] then
							parent:GetChild("Icon"):SetTexture(parent.Icons[i])
							parent:GetChild("Icon").Width = 18
						else
							parent:GetChild("Icon"):SetTexture(nil)
							parent:GetChild("Icon").Width = 1
						end
						if _List.Visible and _List.__ComboBox == parent then
							_List:SelectItemByIndex(i)
						end
	                    parent:Fire("OnValueChanged", value)
	                    parent:Fire("OnTextChanged", text)
	                end
	            else
	                parent.__Value = nil
					parent:GetChild("Icon"):SetTexture(nil)
					parent:GetChild("Icon").Width = 1
	                parent:Fire("OnTextChanged", text)
	            end
				return;
			end
		end
	end

	local function OnChar(self)
		if (not self:IsInIMECompositionMode() ) then
			OnCharComposition(self)
		end
	end

	local function OnEditFocusGained(self)
        self:HighlightText()
		self.Parent:Fire("OnEditFocusGained")
	end

	local function OnEditFocusLost(self)
        self:HighlightText(0, 0)
		self.Parent:Fire("OnEditFocusLost")
	end

	local function OnEnterPressed(self)
		self:ClearFocus()
		self.Parent:Fire("OnEnterPressed")
	end

	local function OnTabPressed(self)
		self:ClearFocus()
		self.Parent:Fire("OnTabPressed")
	end

	local function OnEscapePressed(self)
		self:ClearFocus()
		self.Parent:Fire("OnEscapePressed")
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the choosed item is changed
	-- @name ComboBox:OnValueChanged
	-- @class function
	-- @param value the choosed item's value
	-- @usage function ComboBox:OnValueChanged(value)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnValueChanged"

	------------------------------------
	--- ScriptType, Run when the comboBox's text is changed
	-- @name EditBox:OnTextChanged
	-- @class function
	-- @param text the text displayed on the combobox
	-- @usage function EditBox:OnTextChanged(text)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTextChanged"

	------------------------------------
	--- ScriptType, Run when the comboBox becomes focused for keyboard input
	-- @name ComboBox:OnEditFocusGained
	-- @class function
	-- @usage function ComboBox:OnEditFocusGained()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEditFocusGained"

	------------------------------------
	--- ScriptType, Run when the comboBox loses keyboard input focus
	-- @name ComboBox:OnEditFocusLost
	-- @class function
	-- @usage function ComboBox:OnEditFocusLost()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEditFocusLost"

	------------------------------------
	--- ScriptType, Run when the Enter (or Return) key is pressed while the comboBox has keyboard focus
	-- @name ComboBox:OnEnterPressed
	-- @class function
	-- @usage function ComboBox:OnEnterPressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEnterPressed"

	------------------------------------
	--- ScriptType, Run when the Escape key is pressed while the comboBox has keyboard focus
	-- @name ComboBox:OnEscapePressed
	-- @class function
	-- @usage function ComboBox:OnEscapePressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEscapePressed"

	------------------------------------
	--- ScriptType, Run when the Tab key is pressed while the comboBox has keyboard focus
	-- @name ComboBox:OnTabPressed
	-- @class function
	-- @usage function ComboBox:OnTabPressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTabPressed"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Sets the ComboBox's style
	-- @name ComboBox:SetStyle
	-- @class function
	-- @param style the style of the ComboBox : CLASSIC, LIGHT
	-- @usage ComboBox:SetStyle("LIGHT")
	------------------------------------
	function SetStyle(self, style)
		local t

		-- Check Style
		if not style or type(style) ~= "string" then
			return
		end

		-- Change Style
		if style == TEMPLATE_CLASSIC then
			self:SetBackdrop(nil)

			local btnDropdown = Button("DropdownBtn", self)
			btnDropdown:SetWidth(32)
			btnDropdown:SetHeight(32)
			btnDropdown:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
			btnDropdown:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
			btnDropdown:SetDisabledTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]])
			btnDropdown:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]], "ADD")
			btnDropdown:SetHitRectInsets(6, 7, 7, 8)

			if btnDropdown.Visible then
				local left = Texture("LeftTexture", self, "ARTWORK")
				left.TexturePath = [[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]
				left:SetPoint("TOPLEFT", self, "TOPLEFT", -24, 16)
				left:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -24, -16)
				left.Width = 32
				left:SetTexCoord(0, 0.19, 0, 1)
				left.Visible = true

				local right = Texture("RightTexture", self, "ARTWORK")
				right.TexturePath = [[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]
				right:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 16)
				right:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, -16)
				right.Width = 32
				right:SetTexCoord(0.81, 1, 0, 1)
				right.Visible = true

				local middle = Texture("MiddleTexture", self, "ARTWORK")
				middle.TexturePath = [[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]
				middle:SetPoint("TOPLEFT", left, "TOPRIGHT")
				middle:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT")
				middle:SetTexCoord(0.19, 0.81, 0, 1)
				middle.Visible = true
			else
				local left = Texture("LeftTexture", self, "BACKGROUND")
				left.Width = 8
				left:SetTexture("Interface\\Common\\Common-Input-Border")
				left:SetTexCoord(0, 0.0625, 0, 0.625)
				left:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 0)
				left:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -5, 0)
				left.Visible = true

				local right = Texture("RightTexture", self, "BACKGROUND")
				right.Width = 8
				right:SetTexture("Interface\\Common\\Common-Input-Border")
				right:SetTexCoord(0.9375, 1.0, 0, 0.625)
				right:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
				right:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
				right.Visible = true

				local middle = Texture("MiddleTexture", self, "BACKGROUND")
				middle.Width = 10
				middle:SetTexture("Interface\\Common\\Common-Input-Border")
				middle:SetTexCoord(0.0625, 0.9375, 0, 0.625)
				middle:SetPoint("TOPLEFT", left, "TOPRIGHT", 0, 0)
				middle:SetPoint("TOPRIGHT", right, "TOPLEFT", 0, 0)
				middle:SetPoint("BOTTOMLEFT", left, "BOTTOMRIGHT", 0, 0)
				middle:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT", 0, 0)
				middle.Visible = true
			end

		elseif style == TEMPLATE_LIGHT then
			local btnDropdown = Button("DropdownBtn", self)
			btnDropdown:SetWidth(32)
			btnDropdown:SetHeight(32)
			btnDropdown:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up.blp")
			btnDropdown:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down.blp")
			btnDropdown:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled.blp")
			btnDropdown:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight.blp", "ADD")
			btnDropdown:SetHitRectInsets(6, 7, 7, 8)

			if self.MiddleTexture then
				self.MiddleTexture.Visible = false
			end
			if self.LeftTexture then
				self.LeftTexture.Visible = false
			end
			if self.RightTexture then
				self.RightTexture.Visible = false
			end

			self:SetBackdrop(_FrameBackdrop)
			self:SetBackdropColor(0,0,0,1)
		end

		self.__Style = style
	end

	------------------------------------
	--- Gets the ComboBox's style
	-- @name ComboBox:GetStyle
	-- @class function
	-- @return the style of the ComboBox : CLASSIC, LIGHT
	-- @usage ComboBox:GetStyle()
	------------------------------------
	function GetStyle(self)
		return self.__Style or TEMPLATE_LIGHT
	end

	-- Dispose, release resource
	function Dispose(self)
		if _List.__ComboBox == self then
			_List.Visible = false
			_List:ClearAllPoints()
			_List.__ComboBox = nil
		end
	end

	------------------------------------
	--- Clear item list
	-- @name ComboBox:Clear
	-- @class function
	-- @usage ComboBox:Clear()
	------------------------------------
	function Clear(self)
		for i = #self.Keys, 1, -1 do
			self.Keys[i] = nil
			self.Items[i] = nil
			self.Icons[i] = nil
			self.Frames[i] = nil
		end
		self.__Value = nil
		self:GetChild("Icon"):SetTexture(nil)
		self:GetChild("Icon").Width = 1

		if _List.Visible and _List.__ComboBox == self then
			_List:SelectItemByValue(self.__Value)
			_List:Refresh()
		end
	end

	------------------------------------
	--- Add an item to the comboBox
	-- @name ComboBox:AddItem
	-- @class function
	-- @param key the key of the item
	-- @param text the text of the item, to be displayed for informations
	-- @param icon Optional,the icon of the item, will be shown at the left of the text if setted
	-- @param frame Optional,the frame of the item, for some special need
	-- @usage ComboBox:AddItem(true, "True")
	------------------------------------
	function AddItem(self, key, text, icon, frame)
		if key ~= nil then
			self.Keys[#self.Keys + 1] = key
			if text and type(text) == "string" then
				self.Items[#self.Items + 1] = text
			else
				self.Items[#self.Items + 1] = tostring(key)
			end
			self.Icons[#self.Keys] = icon
			self.Frames[#self.Keys] = frame
		end

		if _List.Visible and _List.__ComboBox == self then
			_List:Refresh()
		end
	end

	------------------------------------
	--- Modify or add an item in the item list
	-- @name ComboBox:SetItem
	-- @class function
	-- @param key the key of the item
	-- @param text the text of the item, to be displayed for informations
	-- @param icon Optional,the icon of the item, will be shown at the left of the text if setted
	-- @param frame Optional,the frame of the item, for some special need
	-- @usage ComboBox:SetItem(true, "True")
	------------------------------------
	function SetItem(self, key, text, icon, frame)
		local idx = 1
		if key == nil then
			return
		end
		while self.Keys[idx] and self.Keys[idx] ~= key do
			idx = idx + 1
		end
		self.Keys[idx] = key
		self.Items[idx] = text
		self.Icons[idx] = icon
		self.Frames[idx] = frame

		if self.__Value == key then
			self:GetChild("Text"):SetText(text)
		end

		if _List.Visible and _List.__ComboBox == self then
			_List:Refresh()
		end
	end

	------------------------------------
	--- Get an item's info from the item list by key
	-- @name ComboBox:GetItem
	-- @class function
	-- @param key the key of the item
	-- @return key - the key of the item
	-- @return text - the text of the item, to be displayed for informations
	-- @return icon - the icon of the item, will be shown at the left of the text if setted
	-- @return frame - the frame of the item, for some special need
	-- @usage ComboBox:GetItem(true)
	------------------------------------
	function GetItem(self, key)
		local idx = 1
		if key == nil then
			return
		end
		while self.Keys[idx] and self.Keys[idx] ~= key do
			idx = idx + 1
		end
		if self.Keys[idx] then
			return self.Keys[idx], self.Items[idx], self.Icons[idx], self.Frames[idx]
		end
	end

	------------------------------------
	--- Get an item's info from the item list by index
	-- @name ComboBox:GetItemByIndex
	-- @class function
	-- @param index the index of the item
	-- @return key - the key of the item
	-- @return text - the text of the item, to be displayed for informations
	-- @return icon - the icon of the item, will be shown at the left of the text if setted
	-- @return frame - the frame of the item, for some special need
	-- @usage ComboBox:GetItemByIndex(1)
	------------------------------------
	function GetItemByIndex(self, idx)
		if self.Keys[idx] then
			return self.Keys[idx], self.Items[idx], self.Icons[idx], self.Frames[idx]
		end
	end

	------------------------------------
	--- Remove an item from the item list by key
	-- @name ComboBox:RemoveItem
	-- @class function
	-- @param key the key of the item
	-- @usage ComboBox:RemoveItem(true)
	------------------------------------
	function RemoveItem(self, key)
		local idx = 1
		if key == nil then
			return
		end
		while self.Keys[idx] and self.Keys[idx] ~= key do
			idx = idx + 1
		end

		if self.Keys[idx] and self.Keys[idx] == key then
			for i = idx, #self.Keys do
				self.Keys[i] = self.Keys[i+ 1]
				self.Items[i] = self.Items[i + 1]
				self.Icons[i] = self.Icons[i + 1]
				self.Frames[i] = self.Frames[i + 1]
			end

			if self.__Value == key then
				self:SetValue(nil)
			elseif _List.Visible and _List.__ComboBox == self then
				_List:Refresh()
			end
		end
	end

	------------------------------------
	--- Build item list from a table
	-- @name ComboBox:SetList
	-- @class function
	-- @param list a table contains key-value pairs
	-- @usage ComboBox:SetList{[true] = "True", [false] = "False"}
	------------------------------------
	function SetList(self, list)
		self:Clear()
		if type(list) == "table" then
			for k, v in pairs(list) do
				self:AddItem(k, v)
			end
		else
			error("The parameter must be a table")
		end
	end

	------------------------------------
	--- Gets the display item count of the comboBox
	-- @name ComboBox:GetDisplayItemCount
	-- @class function
	-- @usage ComboBox:GetDisplayItemCount()
	------------------------------------
	function GetDisplayItemCount(self)
		return self.__DisplayItemCount
	end

	------------------------------------
	--- Sets the display item count of the comboBox
	-- @name ComboBox:SetDisplayItemCount
	-- @class function
	-- @usage ComboBox:SetDisplayItemCount(6)
	------------------------------------
	function SetDisplayItemCount(self, cnt)
		self.__DisplayItemCount = cnt
		if _List.Visible and _List.__ComboBox == self then
			_List:Refresh()
		end
	end

	------------------------------------
	--- Gets the choosed item's value of the comboBox
	-- @name ComboBox:GetValue
	-- @class function
	-- @usage ComboBox:GetValue()
	------------------------------------
	function GetValue(self)
		return self.__Value
	end

	------------------------------------
	--- Sets a value to the comboBox, make it select the match item
	-- @name ComboBox:SetValue
	-- @class function
	-- @param value the item's value that need to be choosed
	-- @usage ComboBox:SetValue(true)
	------------------------------------
	function SetValue(self, value)
		local text, icon
		if self.__Value == value then
			return
		end
		if value then
			for i = 1, #self.Keys do
				if self.Keys[i] == value then
					text = self.Items[i]
					icon = self.Icons[i]
					break
				end
			end

			if text then
				self.__Value = value
				self:GetChild("Text"):SetText(text)
				if icon then
					self:GetChild("Icon"):SetTexture(icon)
					self:GetChild("Icon").Width = 18
				else
					self:GetChild("Icon"):SetTexture(nil)
					self:GetChild("Icon").Width = 1
				end

				self:Fire("OnValueChanged", value)
				self:Fire("OnTextChanged", text)
				if _List.Visible and _List.__ComboBox == self then
					_List:SelectItemByValue(self.__Value)
				end
			end
		else
			self.__Value = nil
			self:GetChild("Text"):SetText("")
			self:GetChild("Icon"):SetTexture(nil)
			self:GetChild("Icon").Width = 1

			self:Fire("OnValueChanged", nil)
			self:Fire("OnTextChanged", "")
			if _List.Visible and _List.__ComboBox == self then
				_List:SelectItemByValue(nil)
			end
		end
	end

	------------------------------------
	--- Gets the text of the comboBox
	-- @name ComboBox:GetText
	-- @class function
	-- @usage ComboBox:GetText()
	------------------------------------
	function GetText(self)
		return self:GetChild("Text"):GetText()
	end

	------------------------------------
	--- Sets the text of the comboBox, if a item is match for that text, would be selected
	-- @name ComboBox:SetText
	-- @class function
	-- @param text the text to be displayed
	-- @usage ComboBox:SetText("True")
	------------------------------------
	function SetText(self, text)
		local value, icon
		if text and type(text) == "string" and self:GetChild("Text").Text ~= text then
			for i =1, #self.Items do
				if self.Items[i] == text then
					value = self.Keys[i]
					icon = self.Icons[i]
					break
				end
			end
			if value then
				self.__Value = value
				self:GetChild("Text"):SetText(text)
				if icon then
					self:GetChild("Icon"):SetTexture(icon)
					self:GetChild("Icon").Width = 18
				else
					self:GetChild("Icon"):SetTexture(nil)
					self:GetChild("Icon").Width = 1
				end

				self:Fire("OnValueChanged", value)
				self:Fire("OnTextChanged", text)
				if _List.Visible and _List.__ComboBox == self then
					_List:SelectItemByValue(self.__Value)
				end
			else
				self:GetChild("Text"):SetText(text)
				self:GetChild("Icon"):SetTexture(nil)
				self:GetChild("Icon").Width = 1

				if self.__Value ~= nil then
					self.__Value = nil
					self:Fire("OnValueChanged", nil)
				end
				self:Fire("OnTextChanged", text)
				if _List.Visible and _List.__ComboBox == self then
					_List:SelectItemByValue(nil)
				end
			end
		end
	end

	------------------------------------
	--- Return whether the comboBox is editable
	-- @name ComboBox:GetEditable
	-- @class function
	-- @usage ComboBox:GetEditable()
	------------------------------------
	function GetEditable(self)
		return self:GetChild("Text").MouseEnabled
	end

	------------------------------------
	--- Set the comboBox's editable
	-- @name ComboBox:SetEditable
	-- @class function
	-- @param enable true if the comboBox is ediatable
	-- @usage ComboBox:SetEditable(false)
	------------------------------------
	function SetEditable(self, flag)
		self:GetChild("Text").MouseEnabled = flag
		if not flag then
			self:GetChild("Text").AutoFocus = false
			if self:GetChild("Text"):HasFocus() then
				self:GetChild("Text"):ClearFocus()
			end
		end
	end

	------------------------------------
	--- Return the text object of the comboBox, using for special needs
	-- @name ComboBox:GetTextObject
	-- @class function
	-- @usage ComboBox:GetTextObject()
	------------------------------------
	function GetTextObject(self)
		return self:GetChild("Text")
	end

	------------------------------------
	--- Set whether or not the comboBox will attempt to get input focus when it gets shown
	-- @name ComboBox:SetAutoFocus
	-- @class function
	-- @param enable True to enable the comboBox to automatically acquire keyboard input focus; false to disable
	-- @usage ComboBox:SetAutoFocus()
	------------------------------------
	function SetAutoFocus(self, flag)
		if flag and self:GetChild("Text").MouseEnabled then
			self:GetChild("Text").AutoFocus = true
		else
			self:GetChild("Text").AutoFocus = false
		end
	end

	------------------------------------
	--- Determine if the ComboBox has autofocus enabled
	-- @name ComboBox:IsAutoFocus
	-- @class function
	-- @return true if the ComboBox has autofocus enabled
	-- @usage ComboBox:IsAutoFocus()
	------------------------------------
	function IsAutoFocus(self)
		return self:GetChild("Text").AutoFocus
	end

	------------------------------------
	--- Releases keyboard input focus from the ComboBox
	-- @name ComboBox:ClearFocus
	-- @class function
	-- @usage ComboBox:ClearFocus()
	------------------------------------
	function ClearFocus(self)
		self:GetChild("Text"):ClearFocus()
	end

	------------------------------------
	--- Returns whether the ComboBox is currently focused for keyboard input
	-- @name ComboBox:HasFocus
	-- @class function
	-- @return True if the ComboBox is currently focused for keyboard input
	-- @usage ComboBox:HasFocus()
	------------------------------------
	function HasFocus(self)
		return self:GetChild("Text"):HasFocus()
	end

	------------------------------------
	--- Move input focus (the cursor) to this ComboBox
	-- @name ComboBox:SetFocus
	-- @class function
	-- @usage ComboBox:SetFocus()
	------------------------------------
	function SetFocus(self)
		if self:GetChild("Text").MouseEnabled then
			self:GetChild("Text"):SetFocus()
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- AutoFocus
	property "AutoFocus" {
		Set = function(self, state)
			self:SetAutoFocus(state)
		end,

		Get = function(self)
			return (self:IsAutoFocus() and true) or false
		end,

		Type = Boolean,
	}
	-- Focus
	property "Focused" {
		Set = function(self, focus)
			if focus then
				self:SetFocus()
			else
				self:ClearFocus()
			end
		end,

		Get = function(self)
			return (self:HasFocus() and true) or false
		end,

		Type = Boolean,
	}
	-- DisplayItemCount
	property "DisplayItemCount" {
		Set = function(self, cnt)
			self:SetDisplayItemCount(cnt)
		end,

		Get = function(self)
			return self:GetDisplayItemCount()
		end,

		Type = Number,
	}
	-- Value
	property "Value" {
		Set = function(self, value)
			self:SetValue(value)
		end,

		Get = function(self)
			return self:GetValue()
		end,

		Type = Any,
	}
	-- Value
	property "Text" {
		Set = function(self, text)
			self:SetText(text)
		end,

		Get = function(self)
			return self:GetText()
		end,

		Type = LocaleString,
	}
	-- Editable
	property "Editable" {
		Set = function(self, flag)
			self:SetEditable(flag)
		end,

		Get = function(self)
			return (self:GetEditable() and true) or false
		end,

		Type = Boolean,
	}
	-- HideDropDownButton
	property "HideDropDownButton" {
		Set = function(self, flag)
			self:GetChild("DropdownBtn").Visible = not flag
			self.Style = self.Style
		end,

		Get = function(self)
			return not self:GetChild("DropdownBtn").Visible
		end,

		Type = Boolean,
	}
	-- Keys
	property "Keys" {
		Set = function(self, keys)
			if keys then
				self.__Keys = keys
			else
				self.__Keys = {}
			end
		end,
		Get = function(self)
			self.__Keys = self.__Keys or {}
			return self.__Keys
		end,
		Type = Table + Userdata + nil,
	}
	-- Items
	property "Items" {
		Set = function(self, items)
			if items then
				self.__Items = items
			else
				self.__Items = {}
			end
		end,
		Get = function(self)
			self.__Items = self.__Items or {}
			return self.__Items
		end,
		Type = Table + Userdata + nil,
	}
	-- Icons
	property "Icons" {
		Set = function(self, icons)
			if icons then
				self.__Icons = icons
			else
				self.__Icons = {}
			end
		end,
		Get = function(self)
			self.__Icons = self.__Icons or {}
			return self.__Icons
		end,
		Type = Table + Userdata + nil,
	}
	-- Frames
	property "Frames" {
		Set = function(self, frames)
			if frames then
				self.__Frames = frames
			else
				self.__Frames = {}
			end
		end,
		Get = function(self)
			self.__Frames = self.__Frames or {}
			return self.__Frames
		end,
		Type = Table + Userdata + nil,
	}
	-- ItemCount
	property "ItemCount" {
		Get = function(self)
			return #self.Keys
		end,

		Type = Number,
	}
	-- Style
	property "Style" {
		Set = function(self, style)
			self:SetStyle(style)
		end,

		Get = function(self)
			return self:GetStyle()
		end,

		Type = ComboBoxStyle,
	}
	-- JustifyH
	property "JustifyH" {
		Set = function(self, justifyH)
			self:GetChild("Text").JustifyH = justifyH
		end,

		Get = function(self)
			return self:GetChild("Text").JustifyH
		end,

		Type = JustifyHType,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ComboBox(self, name, parent)
        self:SetWidth(180)
        self:SetHeight(26)
		self:SetBackdrop(_FrameBackdrop)
		self:SetBackdropColor(0,0,0,1)
		self.__DisplayItemCount = 6

        local btnDropdown = Button("DropdownBtn", self)
        btnDropdown:SetWidth(32)
        btnDropdown:SetHeight(32)
		btnDropdown:SetPoint("TOPRIGHT", self, "TOPRIGHT", 3, 3)
		btnDropdown:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 3, -3)
        btnDropdown:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up.blp")
        btnDropdown:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down.blp")
        btnDropdown:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled.blp")
        btnDropdown:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight.blp", "ADD")
        btnDropdown:SetHitRectInsets(6, 7, 7, 8)

		local icon = Texture("Icon", self, "OVERLAY")
		icon:SetWidth(18)
		icon:SetHeight(18)
		icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
		icon:SetPoint("LEFT", self, "LEFT", 4, 0)

        local edit = EditBox("Text", self)
        edit:SetPoint("TOP", self, "TOP", 0, -4)
        edit:SetPoint("LEFT", icon, "RIGHT")
        edit:SetPoint("RIGHT", btnDropdown, "LEFT", 6, 0)
        edit:SetPoint("BOTTOM", self, "BOTTOM", 0, 4)
        edit:SetAutoFocus(false)
        edit:SetJustifyH("CENTER")
        edit:SetJustifyV("MIDDLE")
        edit:SetFontObject("GameFontNormalSmall")
		edit.MouseEnabled = false
        edit.AutoFocus = false

        -- Event Handle
        btnDropdown.OnClick = OnClick

        edit.OnTabPressed = OnTabPressed
        edit.OnEnterPressed = OnEnterPressed
        edit.OnEscapePressed = OnEscapePressed
        edit.OnEditFocusLost = OnEditFocusLost
        edit.OnEditFocusGained = OnEditFocusGained
		edit.OnCharComposition = OnCharComposition
		edit.OnChar = OnChar

		self.OnHide = self.OnHide + OnHide
    end
endclass "ComboBox"