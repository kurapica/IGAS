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

---------------------------------------------------------------------------------------------------------------------------------------
--- List is a widget type using for show list of infomations
-- <br><br>inherit <a href="..\Base\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name List
-- @class table
-- @field ScrollStep the minimum increment between allowed slider values
-- @field DisplayItemCount the display count in the list
-- @field Keys a table that contains keys of the items
-- @field Items a table that contains Text of the items
-- @field Icons a table that contains icons of the items
-- @field Frames a table that contains frames of the items
-- @field ItemCount the item's count
-- @field Style the list's style: CLASSIC, LIGHT
-- @field SelectedIndex the selected item's index
-- @field ShowTootip whether show tooltip or not
---------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 14
if not IGAS:NewAddon("IGAS.Widget.List", version) then
	return
end

class "List"
	inherit "Frame"

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
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the mouse is over an item, and the tooltip is setted.
	-- @name List:OnGameTooltipShow
	-- @class function
	-- @param GameTooltip the GameTooltip object
	-- @param key the choosed item's value
	-- @param text the choosed item's text setting
	-- @param icon the choosed item's icon setting
	-- @param frame the choosed item's frame setting
	-- @usage function List:OnGameTooltipShow(GameTooltip, key, text, icon, farme)<br>
	--    -- do someting like<br>
	--    GameTooltip:AddLine("Version 1")
	-- end
	------------------------------------
	script "OnGameTooltipShow"

	------------------------------------
	--- ScriptType, Run when the choosed item is changed
	-- @name List:OnItemChoosed
	-- @class function
	-- @param key the choosed item's value
	-- @param text the choosed item's text setting
	-- @param icon the choosed item's icon setting
	-- @param frame the choosed item's frame setting
	-- @usage function List:OnItemChoosed(key, text, icon, frame)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnItemChoosed"

	------------------------------------
	--- ScriptType, Run when an item is double-clicked
	-- @name List:OnItemDoubleClick
	-- @class function
	-- @param key the dbl-clicked item's value
	-- @param text the dbl-clicked item's text setting
	-- @param icon the dbl-clicked item's icon setting
	-- @param frame the dbl-clicked item's frame setting
	-- @usage function List:OnItemDoubleClick(key, text, icon, frame)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnItemDoubleClick"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Sets the list's style
	-- @name List:SetStyle
	-- @class function
	-- @param style the style of the List : CLASSIC, LIGHT
	-- @usage List:SetStyle("LIGHT")
	------------------------------------
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

	------------------------------------
	--- Gets the List's style
	-- @name List:GetStyle
	-- @class function
	-- @return the style of the List : CLASSIC, LIGHT
	-- @usage List:GetStyle()
	------------------------------------
	function GetStyle(self)
		return self.__Style or TEMPLATE_LIGHT
	end

	------------------------------------
	--- Select a item by index
	-- @name List:SelectItemByIndex
	-- @class function
	-- @param index the index of the item
	-- @usage List:SelectItemByIndex(3)
	------------------------------------
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

	------------------------------------
	--- Select a item by text
	-- @name List:SelectItemByText
	-- @class function
	-- @param text the text of the item
	-- @usage List:SelectItemByText("True")
	------------------------------------
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

	------------------------------------
	--- Select a item by value
	-- @name List:SelectItemByValue
	-- @class function
	-- @param value the value of the item
	-- @usage List:SelectItemByValue(true)
	------------------------------------
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

	------------------------------------
	--- Gets the selected item's index
	-- @name List:GetSelectedItemIndex
	-- @class function
	-- @return the index of the selected item
	-- @usage List:GetSelectedItemIndex()
	------------------------------------
	function GetSelectedItemIndex(self)
		return self.__ChooseItem or 0
	end

	------------------------------------
	--- Gets the selected item's value
	-- @name List:GetSelectedItemValue
	-- @class function
	-- @return the value of the selected item
	-- @usage List:GetSelectedItemValue()
	------------------------------------
	function GetSelectedItemValue(self)
		return self.__ChooseItem and self.Keys[self.__ChooseItem]
	end

	------------------------------------
	--- Gets the selected item's text
	-- @name List:GetSelectedItemText
	-- @class function
	-- @return the text of the selected item
	-- @usage List:GetSelectedItemText()
	------------------------------------
	function GetSelectedItemText(self)
		return self.__ChooseItem and self.Items[self.__ChooseItem]
	end

	------------------------------------
	--- Returns the minimum increment between allowed slider values
	-- @name List:GetValueStep
	-- @class function
	-- @return step - Minimum increment between allowed slider values
	-- @usage List:GetValueStep()
	------------------------------------
	function GetScrollStep(self)
		return self:GetChild("ScrollBar").ValueStep
	end

	------------------------------------
	--- Sets the minimum increment between allowed slider values.
	-- @name List:SetScrollStep
	-- @class function
	-- @param step Minimum increment between allowed slider values
	-- @usage List:SetScrollStep(10)
	------------------------------------
	function SetScrollStep(self, step)
		if step > 0 then
			self:GetChild("ScrollBar").ValueStep = step
		end
	end

	------------------------------------
	--- Refresh the item list
	-- @name List:Refresh
	-- @class function
	-- @usage List:Refresh()
	------------------------------------
	function Refresh(self)
		--if not self.Visible then
		--	return
		--end

		-- ReDraw
		relayoutFrame(self)

		-- Select Item
		return self:SelectItemByIndex(self.__ChooseItem)
	end

	------------------------------------
	--- stop the refresh of the list
	-- @name List:SuspendLayout
	-- @class function
	-- @usage List:SuspendLayout()
	------------------------------------
	function SuspendLayout(self)
		self.__Layout = false
	end

	------------------------------------
	--- resume the refresh of the list
	-- @name List:ResumeLayout
	-- @class function
	-- @usage List:ResumeLayout()
	------------------------------------
	function ResumeLayout(self)
		self.__Layout = true
		self:Refresh()
	end

	------------------------------------
	--- Clear the item list
	-- @name List:Clear
	-- @class function
	-- @usage List:Clear()
	------------------------------------
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

	------------------------------------
	--- Add an item to the list
	-- @name List:AddItem
	-- @class function
	-- @param key the key of the item
	-- @param text the text of the item, to be displayed for informations
	-- @param icon Optional,the icon of the item, will be shown at the left of the text if setted
	-- @param frame Optional,the frame of the item, for some special need
	-- @usage List:AddItem(true, "True")
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

		--if self.Visible then
		self:Refresh()
		--end
	end

	------------------------------------
	--- Modify or add an item in the item list
	-- @name List:SetItem
	-- @class function
	-- @param key the key of the item
	-- @param text the text of the item, to be displayed for informations
	-- @param icon Optional,the icon of the item, will be shown at the left of the text if setted
	-- @param frame Optional,the frame of the item, for some special need
	-- @usage List:SetItem(true, "True")
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

	------------------------------------
	--- Get an item's info from the item list by key
	-- @name List:GetItem
	-- @class function
	-- @param key the key of the item
	-- @return key - the key of the item
	-- @return text - the text of the item, to be displayed for informations
	-- @return icon - the icon of the item, will be shown at the left of the text if setted
	-- @return frame - the frame of the item, for some special need
	-- @usage List:GetItem(true)
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
	-- @name List:GetItemByIndex
	-- @class function
	-- @param index the index of the item
	-- @return key - the key of the item
	-- @return text - the text of the item, to be displayed for informations
	-- @return icon - the icon of the item, will be shown at the left of the text if setted
	-- @return frame - the frame of the item, for some special need
	-- @usage List:GetItemByIndex(1)
	------------------------------------
	function GetItemByIndex(self, idx)
		if self.Keys[idx] then
			return self.Keys[idx], self.Items[idx], self.Icons[idx], self.Frames[idx]
		end
	end

	------------------------------------
	--- Insert an item to the list
	-- @name List:InsertItem
	-- @class function
	-- @param index - where the item should be placed, if nil, would be the last
	-- @param key - the key of the item
	-- @param text - the text of the item, to be displayed for informations
	-- @param icon - the icon of the item, will be shown at the left of the text if setted
	-- @param frame - the frame of the item, for some special need
	-- @usage List:InsertItem(10, 10, "Ten")
	------------------------------------
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

	------------------------------------
	--- Remove an item from the item list by key
	-- @name List:RemoveItem
	-- @class function
	-- @param key the key of the item
	-- @usage List:RemoveItem(true)
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

	------------------------------------
	--- Remove an item from the item list by index
	-- @name List:RemoveItemByIndex
	-- @class function
	-- @param index the index of the item
	-- @usage List:RemoveItemByIndex(1)
	------------------------------------
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

	------------------------------------
	--- Build item list from a table
	-- @name List:SetList
	-- @class function
	-- @param list a table contains key-value pairs
	-- @usage List:SetList{[true] = "True", [false] = "False"}
	------------------------------------
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
	-- ScrollStep
	property "ScrollStep" {
		Set = function(self, step)
			self:SetScrollStep(step)
		end,

		Get = function(self)
			return self:GetScrollStep()
		end,

		Type = Number,
	}
	-- DisplayItemCount
	property "DisplayItemCount" {
		Set = function(self, cnt)
			if cnt and type(cnt) == "number" and cnt > 3 and cnt ~= self.__DisplayItemCount then
				self.__DisplayItemCount = cnt
				self.Height = cnt * _Height + 6
				--if self.Visible then
				self:Refresh()
				--end
			end
		end,

		Get = function(self)
			return self.__DisplayItemCount
		end,

		Type = Number,
	}
	-- Keys
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
	-- Items
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
	-- Icons
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
	-- Frames
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
	-- ItemCount
	property "ItemCount" {
		Get = function(self)
			return #self.Keys
		end,

		Type = Number,
	}
	-- JustifyH
	property "JustifyH" {
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

		Get = function(self)
			return self.__JustifyH
		end,

		Type = JustifyHType,
	}
	-- Style
	property "Style" {
		Set = function(self, style)
			self:SetStyle(style)
		end,

		Get = function(self)
			return self:GetStyle()
		end,

		Type = ListStyle,
	}
	-- SelectedIndex
	property "SelectedIndex" {
		Set = function(self, index)
			self:SelectItemByIndex(index)
		end,
		Get = function(self)
			return self.__ChooseItem or 0
		end,
		Type = Number + nil,
	}
	-- ShowTootip
	property "ShowTootip" {
		Set = function(self, flag)
			self.__ShowTootip = (flag and true) or false
		end,
		Get = function(self)
			return self.__ShowTootip or false
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function List(name, parent)
		local frame = Frame(name, parent)

		frame.MouseWheelEnabled = true
		frame.Visible = true
		frame:ClearAllPoints()
		frame:SetBackdrop(_FrameBackdrop)
		frame:SetBackdropColor(0, 0, 0, 1)
		frame.__DisplayItemCount = 6
		frame.Height = 6 * _Height + 6
		frame.__Layout = true

		-- Scroll Bar
		local scrollBar = ScrollBar("ScrollBar", frame)
		scrollBar:Hide()

		-- Event Handle
		scrollBar.OnValueChanged = ScrollBar_OnValueChanged
		scrollBar.OnSizeChanged = ScrollBar_OnSizeChanged
		scrollBar.OnEnter = ScrollBar_OnEnter
		scrollBar.OnLeave = ScrollBar_OnLeave

		frame.OnMouseWheel = frame.OnMouseWheel + OnMouseWheel
		frame.OnShow = frame.OnShow + OnShow

		frame.__JustifyH = "LEFT"
		frame.__Style = TEMPLATE_LIGHT

		relayoutFrame(frame)

		return frame
	end
endclass "List"