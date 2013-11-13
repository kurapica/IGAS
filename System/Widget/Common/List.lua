--	Author     	 	Kurapica
--	Create Date	 	12/07/2009
--	ChangeLog
--		2010.01.09	Add icons and frames settings
--		2010/02/08  remove the list FrameStrata settings
--		2010/02/12  Add OnSizeChanged script
--		2010/03/03	Add OnItemDoubleClick script
--		2010/06/21  Use # to instead of getn, make proxy can be used as keys, items, icons or frames
--		2010/10/19	Now can show tooltip to the listitem buy set ShowTootip to true
--		2011/03/13	Recode as class
--      2011/11/02  Remvoe visible check

-- Check Version
local version = 14
if not IGAS:NewAddon("IGAS.Widget.List", version) then
	return
end

class "List"
	inherit "Frame"

	doc [======[
		@name List
		@type class
		@desc List is a widget type using for show list of infomations
	]======]

    GameTooltip = IGAS.GameTooltip

	_Height = 26

    -- Style
    TEMPLATE_CLASSIC = "CLASSIC"
    TEMPLATE_LIGHT = "LIGHT"

    -- Define Block
	enum "ListStyle" {
        TEMPLATE_CLASSIC,
		TEMPLATE_LIGHT,
    }

    -- Backdrop settings
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

	-- Help functions
    local function getAnchors(frame)
        local x, y = frame:GetCenter()
        local xFrom, xTo = "", ""
        local yFrom, yTo = "", ""
        if x < GetScreenWidth() / 3 then
            xFrom, xTo = "LEFT", "RIGHT"
        elseif x > GetScreenWidth() / 3 then
            xFrom, xTo = "RIGHT", "LEFT"
        end
        if y < GetScreenHeight() / 3 then
            yFrom, yTo = "BOTTOM", "TOP"
        elseif y > GetScreenWidth() / 3 then
            yFrom, yTo = "TOP", "BOTTOM"
        end
        local from = yFrom..xFrom
        local to = yTo..xTo
        return (from == "" and "CENTER" or from), (to == "" and "CENTER" or to)
    end

	local _OnGameTooltip

	local function Item_OnEnter(self)
		if self.Parent.ShowTootip then
			local from, to = getAnchors(self)
			local parent = self.Parent

			if _OnGameTooltip then
				_OnGameTooltip = nil
				GameTooltip:ClearLines()
				GameTooltip:Hide()
			end

			if not parent.Items[self.ID] then
				return
			end

			_OnGameTooltip = self
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(from, self, to, 0, 0)
			GameTooltip:SetText(parent.Items[self.ID])
			parent:Fire("OnGameTooltipShow", GameTooltip, parent.Keys[self.ID], parent.Items[self.ID], parent.Icons[self.ID], parent.Frames[self.ID])
			GameTooltip:Show()
		end
		self.Parent:Fire("OnEnter")
	end

	local function Item_OnLeave(self)
		_OnGameTooltip = nil
		GameTooltip:ClearLines()
        GameTooltip:Hide()
		self.Parent:Fire("OnLeave")
	end

	local function Item_OnClick(self)
		local parent = self.Parent
		parent.__ChooseItem = self.ID
		for i = 1, parent.__DisplayItemCount do
			parent:GetChild("ListBtn_"..i).HighlightLocked = false
		end
		self.HighlightLocked = true
		return parent:Fire("OnItemChoosed", parent.Keys[self.ID], parent.Items[self.ID], parent.Icons[self.ID], parent.Frames[self.ID])
	end

	local function Item_OnDoubleClick(self)
		local parent = self.Parent
		return parent:Fire("OnItemDoubleClick", parent.Keys[self.ID], parent.Items[self.ID], parent.Icons[self.ID], parent.Frames[self.ID])
	end

	local function ScrollBar_OnEnter(self)
		return self.Parent:Fire("OnEnter")
	end

	local function ScrollBar_OnLeave(self)
		return self.Parent:Fire("OnLeave")
	end

	local function RefreshItem(self, btnIdx, itemIdx)
		local btn = self:GetChild("ListBtn_"..btnIdx)

		if not btn then return end

		if itemIdx and self.Keys[itemIdx] ~= nil then
			btn:GetChild("Text"):SetText(self.Items[itemIdx] or "")
			if self.Icons[itemIdx] then
				btn:GetChild("Icon").Width = 18
				btn:GetChild("Icon"):SetTexture(self.Icons[itemIdx])
			else
				btn:GetChild("Icon").Width = 1
				btn:GetChild("Icon"):SetTexture(nil)
			end
			if self.Frames[itemIdx] and type(self.Frames[itemIdx]) == "table" and self.Frames[itemIdx].SetAllPoints then
				btn:GetChild("Text").Visible = false
				btn:GetChild("Icon").Visible = false
				if btn.__ShowF and btn.__ShowF.Parent == btn then
					btn.__ShowF.Visible = false
					btn.__ShowF:ClearAllPoints()
					btn.__ShowF.Parent = nil
				end
				btn.__ShowF = self.Frames[itemIdx]
				self.Frames[itemIdx].Parent = btn
				self.Frames[itemIdx]:ClearAllPoints()
				self.Frames[itemIdx]:SetAllPoints(btn)
				self.Frames[itemIdx].FrameLevel = btn.FrameLevel - 1
				self.Frames[itemIdx].Visible = true
			else
				btn:GetChild("Text").Visible = true
				btn:GetChild("Icon").Visible = true
				if btn.__ShowF and btn.__ShowF.Parent == btn then
					btn.__ShowF.Visible = false
					btn.__ShowF:ClearAllPoints()
					btn.__ShowF.Parent = nil
				end
				btn.__ShowF = nil
			end
		else
			btn:GetChild("Text"):SetText("")
			btn:GetChild("Icon"):SetTexture(nil)
			if btn.__ShowF and btn.__ShowF.Parent == btn then
				btn.__ShowF.Visible = false
				btn.__ShowF:ClearAllPoints()
				btn.__ShowF.Parent = nil
			end
			btn.__ShowF = nil
		end

		if btn == _OnGameTooltip then
			GameTooltip:ClearLines()
			GameTooltip:Hide()
			_OnGameTooltip = nil

			if self.ShowTootip and self.Items[btn.ID] then
				local from, to = getAnchors(btn)

				_OnGameTooltip = btn
				GameTooltip:SetOwner(btn, "ANCHOR_NONE")
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint(from, btn, to, 0, 0)
				GameTooltip:SetText(self.Items[btn.ID])
				self:Fire("OnGameTooltipShow", GameTooltip, self.Keys[btn.ID], self.Items[btn.ID], self.Icons[btn.ID], self.Frames[btn.ID])
				GameTooltip:Show()
			end
		end
	end

	local function ScrollBar_OnValueChanged(self)
		local parent = self.Parent

		--if not parent.Visible then return end

		for i = 1, parent.__DisplayItemCount do
			RefreshItem(parent, i, i + self:GetValue() - 1)
			parent:GetChild("ListBtn_"..i).ID = i + self:GetValue() - 1
			parent:GetChild("ListBtn_"..i).HighlightLocked = false
			if parent:GetChild("ListBtn_"..i).ID == parent.__ChooseItem then
				parent:GetChild("ListBtn_"..i).HighlightLocked = true
			end
		end
	end

	local function relayoutFrame(self)
		if not self.__Layout then return end

		-- Dropdown List
		local dropCount = self.__DisplayItemCount

		-- Scroll Bar
		local scrollBar = self:GetChild("ScrollBar")

		local i, btn, btnFontString, texture, icon

		-- Add Button
		for i = 1, dropCount do
			if not self:GetChild("ListBtn_"..i) then
				btn = Button("ListBtn_"..i, self)
				btn:ClearAllPoints()
				btn:SetPoint("LEFT", self, "LEFT")
				btn:SetPoint("RIGHT", scrollBar, "LEFT")
				btn:SetPoint("TOP", self, "TOP", 0, (i - 1) * -_Height)
				btn:SetHeight(_Height)
				btn:SetHighlightTexture("Interface\\BUTTONS\\UI-Common-MouseHilight.blp", "ADD")
				texture = btn:GetHighlightTexture()
				texture:SetTexCoord(0.125,0.875,0.125,0.875)

				icon = Texture("Icon", btn, "OVERLAY")
				icon:SetWidth(18)
				icon:SetHeight(18)
				icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
				icon:SetPoint("LEFT", btn, "LEFT", 8, 0)

				btnFontString = FontString("Text", btn, "ARTWORK","GameFontNormal")
				--btn:SetFontString(btnFontString)
				btnFontString:SetPoint("LEFT", icon, "RIGHT")
				btnFontString:SetPoint("RIGHT", btn, "RIGHT")
				btnFontString:SetJustifyH(self.__JustifyH or "LEFT")
				btnFontString:SetJustifyV("MIDDLE")

				btn:SetText("")
				--btn:Hide()
				btn.OnClick = Item_OnClick
				btn.OnDoubleClick = Item_OnDoubleClick
				btn.OnEnter = Item_OnEnter
				btn.OnLeave = Item_OnLeave
			else
				self:GetChild("ListBtn_"..i).Visible = true
			end
		end

		-- Hide no use button
		i = dropCount + 1
		while self:GetChild("ListBtn_"..i) do
			self:GetChild("ListBtn_"..i):Hide()
			i = i + 1
		end

		local iStrCount = (self.Keys and #self.Keys) or 0

		if iStrCount == 0 then
			for i = 1, dropCount do
				self:GetChild("ListBtn_"..i):Hide()
				RefreshItem(self, i)
			end
			self:GetChild("ScrollBar"):SetMinMaxValues(1, 1)
			self:GetChild("ScrollBar"):Hide()
		elseif dropCount >= iStrCount then
			for i = 1, iStrCount do
				self:GetChild("ListBtn_"..i):Show()
				RefreshItem(self, i, i)
				self:GetChild("ListBtn_"..i).ID = i
				self:GetChild("ListBtn_"..i).HighlightLocked = false
				if self:GetChild("ListBtn_"..i).ID == self.__ChooseItem then
					self:GetChild("ListBtn_"..i).HighlightLocked = true
				end
			end

			if dropCount > iStrCount then
				for i = iStrCount +1, dropCount do
					self:GetChild("ListBtn_"..i):Hide()
					RefreshItem(self, i)
					self:GetChild("ListBtn_"..i).ID = i
					self:GetChild("ListBtn_"..i).HighlightLocked = false
				end
			end

			self:GetChild("ScrollBar"):SetMinMaxValues(1, 1)
			self:GetChild("ScrollBar"):Hide()
		else
			for i = 1, dropCount do
				self:GetChild("ListBtn_"..i):Show()
				RefreshItem(self, i, i)
				self:GetChild("ListBtn_"..i).ID = i
				self:GetChild("ListBtn_"..i).HighlightLocked = false
				if self:GetChild("ListBtn_"..i).ID == self.__ChooseItem then
					self:GetChild("ListBtn_"..i).HighlightLocked = true
				end
			end
			self:GetChild("ScrollBar"):SetMinMaxValues(1, iStrCount - dropCount + 1)
			self:GetChild("ScrollBar"):Show()
		end

		self:GetChild("ScrollBar"):SetValue(1)
	end

	local function OnMouseWheel(self, arg1)
		local scrollBar = self:GetChild("ScrollBar")
		local iMin, iMax = scrollBar:GetMinMaxValues()
		local iPos = scrollBar:GetValue()
		local step = scrollBar.ValueStep
		local btnC = self.__DisplayItemCount

		if arg1 > 0 then
			if IsShiftKeyDown() then
				scrollBar.Value = iMin
			elseif IsControlKeyDown() then
				if iPos - btnC > iMin then
					scrollBar.Value = iPos - btnC
				else
					scrollBar.Value = iMin
				end
			else
				if iPos - step > iMin then
					scrollBar.Value = iPos - step
				else
					scrollBar.Value = iMin
				end
			end
		elseif arg1 < 0 then
			if IsShiftKeyDown() then
				scrollBar.Value = iMax
			elseif IsControlKeyDown() then
				if iPos + btnC < iMax then
					scrollBar.Value = iPos + btnC
				else
					scrollBar.Value = iMax
				end
			else
				if iPos + step < iMax then
					scrollBar.Value = iPos + step
				else
					scrollBar.Value = iMax
				end
			end
		end
	end

	local function ScrollBar_OnSizeChanged(self)
		if self.__LastRefreshTime and GetTime() - self.__LastRefreshTime < 0.1 then
			return
		else
			self.__LastRefreshTime = GetTime()
		end

		local cnt = math.ceil((self.Height - 12) / _Height)

		if cnt > 0 and cnt ~= self.Parent.__DisplayItemCount then
			self.Parent.__DisplayItemCount = cnt
			--if self.Parent.Visible then
			self.Parent:Refresh()
			--end
		end
	end

	local function OnShow(self)
		self:Refresh()
	end

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnGameTooltipShow
		@type event
		@desc Run when the mouse is over an item, and the Tooltip property is set
		@param gameTooltip System.Widget.GameTooltip, the GameTooltip object
		@param key any, the choosed item's value
		@param text string, the choosed item's text
		@param icon string, the choosed item's icon texture path
	]======]
	event "OnGameTooltipShow"

	doc [======[
		@name OnItemChoosed
		@type event
		@desc Run when the choosed item is changed
		@param key any, the choosed item's value
		@param text string, the choosed item's text
		@param icon string, the choosed item's icon texture path
	]======]
	event "OnItemChoosed"

	doc [======[
		@name OnItemDoubleClick
		@type method
		@desc Run when an item is double-clicked
		@param key any, the choosed item's value
		@param text string, the choosed item's text
		@param icon string, the choosed item's icon texture path
	]======]
	event "OnItemDoubleClick"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name SetStyle
		@type method
		@desc Sets the list's style
		@param style System.Widget.List.ListStyle
		@return nil
	]======]
	function SetStyle(self, style)
		local t

		-- Check Style
		if not style or type(style) ~= "string" then
			return
		end

		if (not ListStyle[style]) or style == self.__Style then
			return
		end

		-- Change Style
		if style == TEMPLATE_CLASSIC then
			self:SetBackdrop(_FrameBackdropCommon)
			self:SetBackdropColor(0,0,0,1)
		elseif style == TEMPLATE_LIGHT then
			self:SetBackdrop(_FrameBackdrop)
			self:SetBackdropColor(0,0,0,1)
		end

		self.__Style = style

		self.ScrollBar.Style = style
	end

	doc [======[
		@name GetStyle
		@type method
		@desc Gets the List's style
		@return System.Widget.List.ListStyle
	]======]
	function GetStyle(self)
		return self.__Style or TEMPLATE_LIGHT
	end

	doc [======[
		@name SelectItemByIndex
		@type method
		@desc Select a item by index
		@param index number
		@return nil
	]======]
	function SelectItemByIndex(self, index)
		-- Check later, maybe nil
		if not index or type(index) ~= "number" or index <= 0 then
			index = 0
		elseif index > #self.Keys then
			index = #self.Keys
		end

		if index == 0 or #self.Keys <= self.__DisplayItemCount then
			self:GetChild("ScrollBar"):SetValue(1)
		elseif self.__DisplayItemCount + index > #self.Keys then
			self:GetChild("ScrollBar"):SetValue(#self.Keys - self.__DisplayItemCount + 1)
		else
			self:GetChild("ScrollBar"):SetValue(index)
		end

		for i = 1, self.__DisplayItemCount do
			self:GetChild("ListBtn_"..i).HighlightLocked = false
			if self:GetChild("ListBtn_"..i).ID == index then
				self:GetChild("ListBtn_"..i).HighlightLocked = true
			end
		end

		if self.__ChooseItem ~= index then
			self.__ChooseItem = index
			--self:Fire("OnItemChoosed", self.Keys[self.__ChooseItem], self.Items[self.__ChooseItem], self.Icons[self.__ChooseItem], self.Frames[self.__ChooseItem])
		end
	end

	doc [======[
		@name SelectItemByText
		@type method
		@desc Select a item by text
		@param text string
		@return nil
	]======]
	function SelectItemByText(self, text)
		if text and type(text) == "string" then
			for i =1, #self.Items do
				if self.Items[i] == text then
					return self:SelectItemByIndex(i)
				end
			end
		end
		return self:SelectItemByIndex(0)
	end

	doc [======[
		@name SelectItemByValue
		@type method
		@desc Select a item by value
		@param value any
		@return nil
	]======]
	function SelectItemByValue(self, val)
		if val ~= nil then	-- val could be false, so check with nil
			for i = 1, #self.Keys do
				if self.Keys[i] == val then
					return self:SelectItemByIndex(i)
				end
			end
		end
		return self:SelectItemByIndex(0)
	end

	doc [======[
		@name GetSelectedItemIndex
		@type method
		@desc Gets the selected item's index
		@return number
	]======]
	function GetSelectedItemIndex(self)
		return self.__ChooseItem or 0
	end

	doc [======[
		@name GetSelectedItemValue
		@type method
		@desc Gets the selected item's value
		@return any
	]======]
	function GetSelectedItemValue(self)
		return self.__ChooseItem and self.Keys[self.__ChooseItem]
	end

	doc [======[
		@name GetSelectedItemText
		@type method
		@desc Gets the selected item's text
		@return string
	]======]
	function GetSelectedItemText(self)
		return self.__ChooseItem and self.Items[self.__ChooseItem]
	end

	doc [======[
		@name GetScrollStep
		@type method
		@desc Returns the minimum increment between allowed slider values
		@return number
	]======]
	function GetScrollStep(self)
		return self:GetChild("ScrollBar").ValueStep
	end

	doc [======[
		@name SetScrollStep
		@type method
		@desc Sets the minimum increment between allowed slider values
		@param step number, minimum increment between allowed slider values
		@return nil
	]======]
	function SetScrollStep(self, step)
		if step > 0 then
			self:GetChild("ScrollBar").ValueStep = step
		end
	end

	doc [======[
		@name Refresh
		@type method
		@desc Refresh the list
		@return nil
	]======]
	function Refresh(self)
		--if not self.Visible then
		--	return
		--end

		-- ReDraw
		relayoutFrame(self)

		-- Select Item
		return self:SelectItemByIndex(self.__ChooseItem)
	end

	doc [======[
		@name SuspendLayout
		@type method
		@desc Stop the refresh of the list
		@param ...
		@return nil
	]======]
	function SuspendLayout(self)
		self.__Layout = false
	end

	doc [======[
		@name ResumeLayout
		@type method
		@desc Resume the refresh of the list
		@return nil
	]======]
	function ResumeLayout(self)
		self.__Layout = true
		self:Refresh()
	end

	doc [======[
		@name Clear
		@type method
		@desc Clear the list
		@return nil
	]======]
	function Clear(self)
		for i = #self.Keys, 1, -1 do
			self.Keys[i] = nil
			self.Items[i] = nil
			self.Icons[i] = nil
			self.Frames[i] = nil
		end
		self.__ChooseItem = nil

		--if self.Visible then
		self:Refresh()
		--end
	end

	doc [======[
		@name AddItem
		@type method
		@desc Add an item to the list
		@format key, text[, icon]
		@param key any, the value of the item
		@param text string, the text of the item, to be displayed for informations
		@param icon string ,the icon path of the item, will be shown at the left of the text if set
		@return nil
	]======]
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

		--if self.Visible then
		self:Refresh()
		--end
	end

	doc [======[
		@name SetItem
		@type method
		@desc Modify or add an item in the item list
		@format key, text[, icon]
		@param key any, the value of the item
		@param text string, the text of the item, to be displayed for informations
		@param icon string ,the icon path of the item, will be shown at the left of the text if set
		@return nil
	]======]
	function SetItem(self, key, text, icon, frame)
		local idx = 1
		if key == nil then
			return
		end
		while self.Keys[idx] and self.Keys[idx] ~= key do
			idx = idx + 1
		end
		self.Keys[idx] = key
		if text and type(text) == "string" then
			self.Items[idx] = text
		else
			self.Items[idx] = tostring(key)
		end
		self.Icons[idx] = icon
		self.Frames[idx] = frame

		--if self.Visible then
		self:Refresh()
		--end
	end

	doc [======[
		@name GetItem
		@type method
		@desc Get an item's info from the item list by key
		@param key any, the value of the item
		@return key any, the value of the item
		@return text string, the text of the item, to be displayed for informations
		@return icon string ,the icon path of the item, will be shown at the left of the text if set
	]======]
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

	doc [======[
		@name GetItemByIndex
		@type method
		@desc Get an item's info from the item list by index
		@param index number, the item's index
		@return key any, the value of the item
		@return text string, the text of the item, to be displayed for informations
		@return icon string ,the icon path of the item, will be shown at the left of the text if set
	]======]
	function GetItemByIndex(self, idx)
		if self.Keys[idx] then
			return self.Keys[idx], self.Items[idx], self.Icons[idx], self.Frames[idx]
		end
	end

	doc [======[
		@name InsertItem
		@type method
		@desc Insert an item to the list
		@param index number, the index to be inserted, if nil, would be insert at last
		@param key any, the value of the item
		@param text string, the text of the item, to be displayed for informations
		@param icon string ,the icon path of the item, will be shown at the left of the text if set
		@return nil
	]======]
	function InsertItem(self, index, key, text, icon, frame)
		if not index or type(index) ~= "number" or index > #self.Keys + 1 then
			index = #self.Keys + 1
		end

		if key == nil then
			return
		end

		for i = #self.Keys, index, -1 do
			self.Keys[i + 1] = self.Keys[i]
			self.Items[i + 1] = self.Items[i]
			self.Icons[i + 1] = self.Icons[i]
			self.Frames[i + 1] = self.Frames[i]
		end

		self.Keys[index] = key
		if text and type(text) == "string" then
			self.Items[index] = text
		else
			self.Items[index] = tostring(key)
		end
		self.Icons[index] = icon
		self.Frames[index] = frame

		--if self.Visible then
		self:Refresh()
		--end
	end

	doc [======[
		@name RemoveItem
		@type method
		@desc Remove an item from the item list by key
		@param key any, the value of the item
		@return nil
	]======]
	function RemoveItem(self, key)
		local idx = 1
		if key == nil then
			return
		end
		while self.Keys[idx] and self.Keys[idx] ~= key do
			idx = idx + 1
		end
		if self.Keys[idx] and self.Keys[idx] == key then
			if idx == self.__ChooseItem then
				self.__ChooseItem = nil
			end

			for i = idx, #self.Keys do
				self.Keys[i] = self.Keys[i + 1]
				self.Items[i] = self.Items[i + 1]
				self.Icons[i] = self.Icons[i + 1]
				self.Frames[i] = self.Frames[i + 1]
			end

			--if self.Visible then
			self:Refresh()
			--end
		end
	end

	doc [======[
		@name RemoveItemByIndex
		@type method
		@desc Remove an item from the item list by index
		@param index number, the item's index
		@return nil
	]======]
	function RemoveItemByIndex(self, idx)
		if self.Keys[idx] then
			if idx == self.__ChooseItem then
				self.__ChooseItem = nil
			end

			for i = idx, #self.Keys do
				self.Keys[i] = self.Keys[i + 1]
				self.Items[i] = self.Items[i + 1]
				self.Icons[i] = self.Icons[i + 1]
				self.Frames[i] = self.Frames[i + 1]
			end

			--if self.Visible then
			self:Refresh()
			--end
		end
	end

	doc [======[
		@name SetList
		@type method
		@desc Build item list from a table
		@param list table, a table contains key-value pairs like {[true] = "True", [false] = "False"}
		@return nil
	]======]
	function SetList(self, list)
		if type(list) == "table" then
			self:SuspendLayout()
			self:Clear()
			for k, v in pairs(list) do
				self:AddItem(k, v)
			end
			self:ResumeLayout()
		else
			error("The parameter must be a table")
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name ScrollStep
		@type property
		@desc the minimum increment between allowed slider values
	]======]
	property "ScrollStep" {
		Set = "SetScrollStep",
		Get = "GetScrollStep",
		Type = Number,
	}

	doc [======[
		@name DisplayItemCount
		@type property
		@desc the display count in the list
	]======]
	property "DisplayItemCount" {
		Field = "__DisplayItemCount",
		Set = function(self, cnt)
			if cnt and type(cnt) == "number" and cnt > 3 and cnt ~= self.__DisplayItemCount then
				self.__DisplayItemCount = cnt
				self.Height = cnt * _Height + 6
				--if self.Visible then
				self:Refresh()
				--end
			end
		end,
		Type = Number,
	}

	doc [======[
		@name Keys
		@type property
		@desc a table that contains keys of the items
	]======]
	property "Keys" {
		Set = function(self, keys)
			self.__Keys = keys or {}
		end,
		Get = function(self)
			self.__Keys = self.__Keys or {
				_AutoCreated = true,
			}
			return self.__Keys
		end,
		Type = Table + Userdata + nil,
	}

	doc [======[
		@name Items
		@type property
		@desc a table that contains Text of the items
	]======]
	property "Items" {
		Set = function(self, items)
			items = items or {}

			if not self.__Keys or self.__Keys._AutoCreated or self.__Keys == self.__Items then
				self.__Keys = items
			end

			self.__Items = items

			self:Refresh()
		end,
		Get = function(self)
			self.__Items = self.__Items or {}
			return self.__Items
		end,
		Type = Table + Userdata + nil,
	}

	doc [======[
		@name Icons
		@type property
		@desc a table that contains icons of the items
	]======]
	property "Icons" {
		Set = function(self, icons)
			self.__Icons = icons or {}
			self:Refresh()
		end,
		Get = function(self)
			self.__Icons = self.__Icons or {}
			return self.__Icons
		end,
		Type = Table + Userdata + nil,
	}

	doc [======[
		@name Frames
		@type property
		@desc a table that contains frames of the items
	]======]
	property "Frames" {
		Set = function(self, frames)
			self.__Frames = frames or {}
			self:Refresh()
		end,
		Get = function(self)
			self.__Frames = self.__Frames or {}
			return self.__Frames
		end,
		Type = Table + Userdata + nil,
	}

	doc [======[
		@name ItemCount
		@type property
		@desc the item's count
	]======]
	property "ItemCount" {
		Get = function(self)
			return #self.Keys
		end,
		Type = Number,
	}

	doc [======[
		@name JustifyH
		@type property
		@desc the list's horizontal text alignment style
	]======]
	property "JustifyH" {
		Field = "__JustifyH",
		Set = function(self, justifyH)
			self.__JustifyH = justifyH
			local i = 1
			while self:GetChild("ListBtn_"..i) do
				local btn = Button("ListBtn_"..i, self)

				local btnFontString = FontString("Text", btn, "ARTWORK","GameFontNormal")
				btnFontString:SetJustifyH(self.__JustifyH or "LEFT")

				i = i + 1
			end
		end,
		Type = JustifyHType,
	}

	doc [======[
		@name Style
		@type property
		@desc the list's style
	]======]
	property "Style" {
		Set = "SetStyle",
		Get = "GetStyle",
		Type = ListStyle,
	}

	doc [======[
		@name SelectedIndex
		@type property
		@desc the selected item's index
	]======]
	property "SelectedIndex" {
		Set = function(self, index)
			self:SelectItemByIndex(index)
		end,
		Get = function(self)
			return self.__ChooseItem or 0
		end,
		Type = Number + nil,
	}

	doc [======[
		@name ShowTootip
		@type property
		@desc whether show tooltip or not
	]======]
	property "ShowTootip" {
		Field = "__ShowTootip",
		Type = Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function List(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.MouseWheelEnabled = true
		self.Visible = true
		self:ClearAllPoints()
		self:SetBackdrop(_FrameBackdrop)
		self:SetBackdropColor(0, 0, 0, 1)
		self.__DisplayItemCount = 6
		self.Height = 6 * _Height + 6
		self.__Layout = true

		-- Scroll Bar
		local scrollBar = ScrollBar("ScrollBar", self)
		scrollBar:Hide()

		-- Event Handle
		scrollBar.OnValueChanged = ScrollBar_OnValueChanged
		scrollBar.OnSizeChanged = ScrollBar_OnSizeChanged
		scrollBar.OnEnter = ScrollBar_OnEnter
		scrollBar.OnLeave = ScrollBar_OnLeave

		self.OnMouseWheel = self.OnMouseWheel + OnMouseWheel
		self.OnShow = self.OnShow + OnShow

		self.__JustifyH = "LEFT"
		self.__Style = TEMPLATE_LIGHT

		relayoutFrame(self)
	end
endclass "List"