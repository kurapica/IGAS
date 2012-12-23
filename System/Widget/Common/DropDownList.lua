-- Author      : Kurapica
-- ChangreLog  :
--				2010.01.13	Change the DropDownList's Parent to WorldFrame
--				2010.10.14  Add Color Choose for DropDownMenuButton
--				2010.12.22	GetMenuButton can use numeric paramters as index, or fix using with string
--				2011.01.04	Now menubutton's dropdownlist can be a Frame or DropDownList
--				2011/03/13	Recode as class

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- DropDownList is using to create menus
-- <br><br>inherit <a href="..\Base\VirtualUIObject.html">VirtualUIObject</a> For all methods, properties and scriptTypes
-- @name DropDownList
-- @class table
-- @field ItemCount the menu button' count.
-- @field ShowOnCursor whether show the dropdownlist at the cursor's position
-- @field MultiSelect whether the dropdownlist can select mult-checkbuttons
-- @field Alpha Set or get the frame's transparency value(0-1)
-- @field Height the height of the dropdownlist
-- @field Width the width of the dropdownlist
-- @field Visible the visible of the dropdownlist
-- @field Backdrop the backdrop graphic for the dropdownlist
-- @field BackdropBorderColor the shading color for the dropdownlist's border graphic
-- @field BackdropColor the shading color for the dropdownlist's background graphic
-- @field ClampRectInsets offsets from the dropdownlist's edges used when limiting user movement or resizing of the dropdownlist
-- @field HitRectInsets the insets from the dropdownlist's edges which determine its mouse-interactable area
-- @field ID a numeric identifier for the dropdownlist
-- @field Depth the 3D depth of the dropdownlist (for stereoscopic 3D setups)
-- @field DepthIgnored whether the dropdownlist's depth property is ignored (for stereoscopic 3D setups)
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 17

if not IGAS:NewAddon("IGAS.Widget.DropDownList", version) then
	return
end

class "DropDownList"
	inherit "VirtualUIObject"

	WorldFrame = IGAS.WorldFrame

	-- Container & ColorPicker
    _DropDownListContainer = Frame("IGAS_GUI_ListContainer", WorldFrame)
    _DropDownListContainer.__ShowList = _DropDownListContainer.__ShowList or nil

	_DropDownColorPicker = ColorPicker("DropDownColorPicker", _DropDownListContainer)
	_DropDownColorPicker:ClearAllPoints()
	_DropDownColorPicker:SetPoint("CENTER", WorldFrame, "CENTER")
	_DropDownColorPicker.Visible = false

	function _DropDownColorPicker:OnColorPicked(red, green, blue, alpha)
		if self._DropDownButton then
			self._DropDownButton.ColorSwatch.NormalTexture:SetVertexColor(red, green, blue, alpha)
			self._DropDownButton:Fire("OnColorPicked", red, green, blue, alpha)
		end
	end

	function _DropDownColorPicker:OnShow()
		if self._DropDownButton then
			self.Color = self._DropDownButton.Color
		end
	end

	------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--- DropDownMenuButton is using to create buttons on the DropDownList, can only be created by DropDownList.
	-- <br><br>inherit <a href="..\Base\Button.html">Button</a> For all methods, properties and scriptTypes
	-- @name DropDownMenuButton
	-- @class table
	-- @field DropDownList the sub menu binds to the button, can be any frame
	-- @field Text the text to be displayed on the button
	-- @field IsCheckButton whether the button is using as a checkbutton
	-- @field Checked if the button is a checkbutton, whether the button is checked
	-- @field IsColorPicker whether the button's color picker icon is shown
	-- @field Icon the icon that to be displayed on the button
	-- @field TextColor the text color of the button
	-- @field Index the index of this dropDownMenuButton
	----------------------------------------------------------------------------------------------------------------------------------------
    class "DropDownMenuButton"
		inherit "Button"

		itemHeight = 16

        -- Scripts
        --- colorBack
        local function colorsWatch_OnClick(self)
            self.Parent:Fire("OnClick")
			_DropDownColorPicker._DropDownButton = self.Parent
			_DropDownColorPicker.Visible = true
        end

        local function colorsWatch_OnEnter(self)
            self:GetChild("SwatchBg"):SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
			self.Parent:Fire("OnEnter")
        end

        local function colorsWatch_OnLeave(self)
            self:GetChild("SwatchBg"):SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			self.Parent:Fire("OnLeave")
        end

        local function hideDropList(self)
			if self["IsObjectType"] and self:IsObjectType("DropDownList") then
				self = self.__DdList or self
			end
            if self.__Childs and type(self.__Childs) == "table" then
                for _, v in pairs(self.__Childs) do
                    if type(v) == "table" and v["IsObjectType"] and v:IsObjectType(DropDownMenuButton) then
                        if v.__DropDownList then
                            hideDropList(v.__DropDownList)
                        end
                    end
                end
            end
            self.Visible = false
        end

        local function hideDropDownList(self)
            if self["IsObjectType"] and self:IsObjectType(DropDownMenuButton) and self.__DropDownList then
                hideDropList(self.__DropDownList)
            end
        end

        local function showDropDownList(self)
            local offsetx, offsety, menu

            -- Hide other sub dropdownlist
            if self.Parent.__Childs and type(self.Parent.__Childs) == "table" then
                for _,v in pairs(self.Parent.__Childs) do
                    if type(v) == "table" then
                        hideDropDownList(v)
                    end
                end
            end

            -- Show self's dropdownlist
            menu = self.__DropDownList

            if menu then
                menu.Visible = true

                -- Offset-X
                if self.Parent:GetRight() + menu.Width > GetScreenWidth() then
                    offsetx = - (self.Parent.Width + menu.Width)
                else
                    offsetx = 0
                end
                -- Offset-Y
                if self:GetTop() < menu.Height then
                    offsety = menu.Height - self:GetTop()
                else
                    offsety = 0
                end
				menu:ClearAllPoints()
                menu:SetPoint("TOPLEFT", self, "TOPRIGHT", offsetx, offsety)
            end
        end

        local function toggleDropDownList(self)
            if self.__DropDownList then
                if self.__DropDownList.Visible then
                    hideDropDownList(self)
                else
                    showDropDownList(self)
                end
            end
        end

        --- expandArrow
        local function expandArrow_OnClick(self)
            toggleDropDownList(self.Parent)
        end

        local function expandArrow_OnEnter(self)
            showDropDownList(self.Parent)
			self.Parent.Parent:Fire("OnEnter")
        end

        local function expandArrow_OnLeave(self)
            self.Parent.Parent:Fire("OnLeave")
        end

        -- Item
        local function item_OnEnter(self)
            showDropDownList(self)
            self:GetChild("HighLight"):Show()
            self.Parent:Fire("OnEnter")
        end

        local function item_OnLeave(self)
            self:GetChild("HighLight"):Hide()
            self.Parent:Fire("OnLeave")
        end

        local function updateWidth(self)
            local maxW = 0

            if self.__Childs and type(self.__Childs) == "table" then
                for i,v in pairs(self.__Childs) do
                    if type(v) == "table" and v["IsObjectType"] and v:IsObjectType(DropDownMenuButton) then
                        if v:GetChild("Text"):GetStringWidth()> maxW then
                            maxW = v:GetChild("Text"):GetStringWidth()
                        end
                    end
                end

                maxW = maxW + 48

                self.Width = maxW
            end
        end

        -- OnClick Script
        local function OnClick(self, ...)
            -- if this is checkButton
            if self.__IsCheckButton then
                if self.Parent.__MultiSelect then
                    self.Checked = not self.Checked
                    return true
                else
                    if self.Checked then
                        -- No need to action
                        hideDropList(self.Parent)
                        return true
                    end
                    self.Checked = true
                    for i, v in pairs(self.Parent.__Childs) do
                        if type(v) == "table" and v["IsObjectType"] and v:IsObjectType(DropDownMenuButton) and v.__IsCheckButton and v ~= self and v.Checked then
                            v.Checked = false
                        end
                    end
                    hideDropList(self.Parent)
                end
                return
			elseif self.ColorSwatch.Visible then
				_DropDownColorPicker._DropDownButton = self
				_DropDownColorPicker.Visible = true
            end

            local root = self.Parent

            while root.__MenuBase do
                root = root.__MenuBase
            end

            hideDropList(root)
		end

		local function Frame_OnEnter(self)
			if self.__MenuBase then
				return self.__MenuBase:Fire("OnEnter")
			end
		end

		local function Frame_OnLeave(self)
			if self.__MenuBase then
				return self.__MenuBase:Fire("OnLeave")
			end
		end

		------------------------------------------------------
		-- Script
		------------------------------------------------------
		------------------------------------
		--- ScriptType, Run when the button's checking state is changed
		-- @name DropDownMenuButton:OnCheckChanged
		-- @class function
		-- @usage function DropDownMenuButton:OnCheckChanged()<br>
		--    -- do someting<br>
		-- end
		------------------------------------
		script "OnCheckChanged"

		------------------------------------
		--- ScriptType, Run when the color is selected
		-- @name DropDownMenuButton:OnColorPicked
		-- @class function
		-- @usage function DropDownMenuButton:OnColorPicked(red, green, blue, alpha)<br>
		--    -- do someting<br>
		-- end
		------------------------------------
		script "OnColorPicked"

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		-- Dispose, release resource
		function Dispose(self)
			for i,v in pairs(self.Parent:GetChilds()) do
				if v ~= self and type(v) == "table" and v["IsObjectType"] and v:IsObjectType(DropDownMenuButton) then
					if v.__Index > self.__Index then
						v.__Index = v.__Index - 1
						v:SetPoint("TOP", self.Parent, "TOP", 0, -(16 + itemHeight * (v.__Index - 1)))
					end
				end
			end

			self.Parent.__ItemCount = self.Parent.__ItemCount - 1
			self.Parent.Height = self.Parent.Height - itemHeight

			-- Call super's dispose
			return Button.Dispose(self)
		end

		------------------------------------
		--- Add or get a dropDownMenuButton with the given name list
		-- @name DropDownMenuButton:AddMenuButton
		-- @class function
		-- @param name the name of the menu button
		-- @param ... the sub menu item's name list
		-- @return Reference to the new dropdownmenubutton
		-- @usage DropDownMenuButton:AddMenuButton("Action", "Click", "Item")
		------------------------------------
		function AddMenuButton(self, ...)
			local name, mnuBtn, menu

			mnuBtn = self

			for i = 1, select("#", ...) do
				name = select(i, ...)

				if name and type(name) == "string" and name ~= "" then
					menu = mnuBtn.DropDownList or DropDownList("MenuList", mnuBtn)

					mnuBtn:SetDropDownList(menu)

					if not menu:IsObjectType("DropDownList") then
						error("The object with name ["..name.."] is not a DropDownList.")
					end

					if menu:GetMenuButton(name) then
						mnuBtn = menu:GetMenuButton(name)
					else
						mnuBtn = DropDownMenuButton(name, menu.__DdList)
						mnuBtn.Text = name
					end
				else
					error("The name must be string.", 2)
				end
			end

			return mnuBtn
		end

		------------------------------------
		--- get a dropDownMenuButton with the given name list
		-- @name DropDownMenuButton:GetMenuButton
		-- @class function
		-- @param name the name of the menu button
		-- @param ... the sub menu item's name list
		-- @return Reference to the dropdownmenubutton
		-- @usage DropDownMenuButton:GetMenuButton("Action", "Click", "Item")
		------------------------------------
		function GetMenuButton(self, ...)
			local name, mnuBtn, menu

			menu = self.DropDownList

			for i = 1, select("#", ...) do
				name = select(i, ...)

				if name and type(name) == "string" and name ~= "" then
					if not menu or not menu:IsObjectType("DropDownList") then
						return nil
					end

					mnuBtn = menu.__DdList:GetChild(name)

					if not mnuBtn then
						return nil
					end

					menu = mnuBtn.DropDownList
				elseif name and type(name) == "number" and name > 0 then
					if not menu or not menu:IsObjectType("DropDownList")  or name > (menu.__DdList.__ItemCount or 0) then
						return nil
					end

					mnuBtn = nil

					 for _, v in pairs(menu.__DdList:GetChilds()) do
						if type(v) == "table" and v["IsObjectType"] and v:IsObjectType(DropDownMenuButton) and v.__Index == name then
							mnuBtn = v
							break
						end
					end

					if not mnuBtn then
						return nil
					end

					menu = mnuBtn.DropDownList
				else
					return nil
				end
			end

			return mnuBtn
		end

		------------------------------------
		--- remove dropDownMenuButton with the given name list
		-- @name DropDownMenuButton:RemoveMenuButton
		-- @class function
		-- @param name the name of the menu button
		-- @param ... the sub menu item's name list
		-- @usage DropDownMenuButton:RemoveMenuButton("Action", "Click", "Item")
		------------------------------------
		function RemoveMenuButton(self, ...)
			local mnuBtn = self:GetMenuButton(...)

			return mnuBtn and mnuBtn:Dispose()
		end

		------------------------------------
		--- Sets the button's display text
		-- @name DropDownMenuButton:SetText
		-- @class function
		-- @param text tht text to be displayed
		-- @usage DropDownMenuButton:SetText("File")
		------------------------------------
		function SetText(self, text)
			if self.__TextColor and next(self.__TextColor) then
				self:GetChild("Text").Text = string.format("|cFF%02x%02x%02x", floor(self.__TextColor.red * 255), floor(self.__TextColor.green * 255), floor(self.__TextColor.blue * 255))..text.."|r"
			else
				self:GetChild("Text").Text = text
			end
			self.__Text = text
			updateWidth(self.Parent)
		end

		------------------------------------
		--- Gets the button's display text
		-- @name DropDownMenuButton:GetText
		-- @class function
		-- @return the displayed text
		-- @usage DropDownMenuButton:GetText()
		------------------------------------
		function GetText(self)
			return self.__Text or ""
		end

		------------------------------------
		--- Set the sub menu for the button
		-- @name DropDownMenuButton:SetDropDownList
		-- @class function
		-- @param dropDownList the sub menu
		-- @usage DropDownMenuButton:SetDropDownList(dropdownlist1)
		------------------------------------
		function SetDropDownList(self, list)
			if list == nil or (type(list) == "table" and list.IsObjectType and list.Show and list.Hide) then
				if self.__DropDownList == list then
					return
				end

				if self.__DropDownList and not self.__DropDownList:IsObjectType("DropDownList") then
					self.__DropDownList.OnEnter = self.__DropDownList.OnEnter - Frame_OnEnter
					self.__DropDownList.OnLeave = self.__DropDownList.OnLeave - Frame_OnLeave
					self.__DropDownList.__MenuBase = nil
				end

				self.__DropDownList = list
				if self.__DropDownList then
					self:GetChild("ExpandArrow"):Show()
					if list:IsObjectType("DropDownList") then
						list.__DdList.__MenuLevel = self.Parent.__MenuLevel + 1
						list.__DdList.__MenuBase = self.Parent
					else
						list.__MenuBase = self.Parent
						list.OnEnter = list.OnEnter + Frame_OnEnter
						list.OnLeave = list.OnLeave + Frame_OnLeave
					end
				else
					self:GetChild("ExpandArrow"):Hide()
				end
			else
				error("The parameter must be a DropDownList or Frame.")
			end
		end

		------------------------------------
		--- Get the sub menu for the button
		-- @name DropDownMenuButton:GetDropDownList
		-- @class function
		-- @return dropDownList the sub menu
		-- @usage DropDownMenuButton:GetDropDownList()
		------------------------------------
		function GetDropDownList(self)
			return self.__DropDownList
		end

		------------------------------------
		--- Set the icon to be displayed on the button
		-- @name DropDownMenuButton:SetIcon
		-- @class function
		-- @param icon the icon's path
		-- @usage DropDownMenuButton:SetIcon([[Interface\Icon\Amubush]])
		------------------------------------
		function SetIcon(self, texture)
			self:GetChild("Icon").Visible = (texture and true) or false
			self:GetChild("Icon").TexturePath = texture
		end

		------------------------------------
		--- Get the icon to be displayed on the button
		-- @name DropDownMenuButton:GetIcon
		-- @class function
		-- @return icon the icon's path
		-- @usage DropDownMenuButton:GetIcon()
		------------------------------------
		function GetIcon(self)
			return self:GetChild("Icon").TexturePath
		end

		------------------------------------
		--- Set the text color for the button
		-- @name DropDownMenuButton:SetTextColor
		-- @class function
		-- @param red Red component of the color (0.0 - 1.0)
		-- @param green Green component of the color (0.0 - 1.0)
		-- @param blue Blue component of the color (0.0 - 1.0)
		-- @usage DropDownMenuButton:SetTextColor(1, 1, 1)
		------------------------------------
		function SetTextColor(self, r, g, b)
			if r and type(r) == "number" and r >= 0 and r <= 1
				and g and type(g) == "number" and g >=0 and g <= 1
				and b and type(b) == "number" and b >=0 and b <= 1 then

				self.__TextColor = {
					red = r,
					green = g,
					blue = b,
				}

				if self.__Text then
					self:GetChild("Text").Text = string.format("|cFF%02x%02x%02x", floor(r * 255), floor(g * 255), floor(b * 255))..self.__Text.."|r"

				end
			else
				self.__TextColor = nil
				self:GetChild("Text").Text = self.__Text
			end
		end

		------------------------------------
		--- Get the text color for the button
		-- @name DropDownMenuButton:GetTextColor
		-- @class function
		-- @return red Red component of the color (0.0 - 1.0)
		-- @return green Green component of the color (0.0 - 1.0)
		-- @return blue Blue component of the color (0.0 - 1.0)
		-- @usage DropDownMenuButton:GetTextColor()
		------------------------------------
		function GetTextColor(self)
			if self.__TextColor then
				return self.__TextColor.red, self.__TextColor.green, self.__TextColor.blue
			end
		end

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		-- Index
		property "Index" {
			Set = function(self, index)
				if index <= 0 then
					error("The Index must be more than 0.", 2)
				end

				if index > self.Parent.__ItemCount then
					index = self.Parent.__ItemCount
				end

				if self.__Index == index then
					return
				end

				if index > self.__Index then
					for i,v in pairs(self.Parent:GetChilds()) do
						if v ~= self and type(v) == "table" and v["IsObjectType"] and v:IsObjectType(DropDownMenuButton) then
							if v.__Index > self.__Index and v.__Index <= index then
								v.__Index = v.__Index - 1
								v:SetPoint("TOP", self.Parent, "TOP", 0, -(16 + itemHeight * (v.__Index - 1)))
							end
						end
					end
				else
					for i,v in pairs(self.Parent:GetChilds()) do
						if v ~= self and type(v) == "table" and v["IsObjectType"] and v:IsObjectType(DropDownMenuButton) then
							if v.__Index < self.__Index and v.__Index >= index then
								v.__Index = v.__Index + 1
								v:SetPoint("TOP", self.Parent, "TOP", 0, -(16 + itemHeight * (v.__Index - 1)))
							end
						end
					end
				end

				self.__Index = index

				self:SetPoint("TOP", self.Parent, "TOP", 0, -(16 + itemHeight * (index - 1)))
			end,

			Get = function(self)
				return self.__Index
			end,

			Type = Number,
		}
		-- TextColor
		property "TextColor" {
			Set = function(self, color)
				self:SetTextColor(color.red, color.green, color.blue)
			end,

			Get = function(self)
				return self.__TextColor or {}
			end,

			Type = ColorType,
		}
		-- Icon
		property "Icon" {
			Set = function(self, path)
				self:SetIcon(path)
			end,

			Get = function(self)
				return self:GetIcon()
			end,

			Type = String + nil,
		}
		-- DropDownList
		property "DropDownList" {
			Set = function(self, list)
				self:SetDropDownList(list)
			end,

			Get = function(self)
				return self:GetDropDownList()
			end,

			Type = DropDownList + Region + nil,
		}
		-- Text
		property "Text" {
			Set = function(self, text)
				self:SetText(text)
			end,

			Get = function(self)
				return self:GetText()
			end,

			Type = LocaleString,
		}
		-- IsCheckButton
		property "IsCheckButton" {
			Set = function(self, flag)
				self.__IsCheckButton = (flag and true) or false
				if not flag then
					self:GetChild("Check").Visible = false
				end
			end,

			Get = function(self)
				return (self.__IsCheckButton and true) or false
			end,

			Type = Boolean,
		}
		-- Checked
		property "Checked" {
			Set = function(self, flag)
				self:GetChild("Check").Visible = (flag and true) or false
				self:Fire("OnCheckChanged")
			end,

			Get = function(self)
				return self:GetChild("Check").Visible
			end,

			Type = Boolean,
		}
		-- IsColorPicker
		property "IsColorPicker" {
			Set = function(self, flag)
				self.ColorSwatch.Visible = flag
			end,

			Get = function(self)
				return self.ColorSwatch.Visible
			end,

			Type = Boolean,
		}
		-- Color
		property "Color" {
			Get = function(self)
				return self.ColorSwatch.NormalTexture.VertexColor
			end,
			Set = function(self, color)
				self.ColorSwatch.NormalTexture.VertexColor = color
			end,
			Type = ColorType,
		}

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
        function DropDownMenuButton(self, name, parent)
			parent = parent.__DdList or parent

            local maxID = parent.__ItemCount or 0

            self.Width = 100
            self.Height = itemHeight

            maxID = maxID + 1
            self.__Index = maxID
            parent.__ItemCount = maxID

            -- Anchor
            self:SetPoint("LEFT", parent, "LEFT", 4, 0)
            self:SetPoint("RIGHT", parent, "RIGHT", -4, 0)
            self:SetPoint("TOP", parent, "TOP", 0, - (16 + itemHeight * (maxID - 1)))
            parent.Height = 32 + itemHeight * maxID

            -- HighLightTexture
            local highLight = Texture("HighLight", self, "BACKGROUND")
            highLight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
            highLight:SetBlendMode("ADD")
            highLight:SetAllPoints(self)
            highLight.Visible = false

            -- CheckTexture
            local check = Texture("Check", self, "ARTWORK")
            check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
            check.Height = 18
            check.Width = 18
			check.Visible = false
            check:SetPoint("LEFT", self, "LEFT")

            -- IconTexture
            local icon = Texture("Icon", self, "ARTWORK")
            icon.Height = 16
            icon.Width = 16
            icon.Visible = false
            icon:SetPoint("LEFT", self, "LEFT")

            -- ColorSwatch
            local colorsWatch = Button("ColorSwatch", self)
            colorsWatch.Height = 16
            colorsWatch.Width = 16
            colorsWatch.Visible = false
            colorsWatch:SetPoint("RIGHT", self, "RIGHT", -6, 0)
            colorsWatch:SetNormalTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")

            local colorBack = Texture("SwatchBg", colorsWatch, "BACKGROUND")
            colorBack.Height = 14
            colorBack.Width = 14
			colorBack.DrawLayer = "BACKGROUND"
            colorBack:SetPoint("CENTER", colorsWatch, "CENTER")
            colorBack:SetVertexColor(1.0, 1.0, 1.0)

            colorsWatch.OnClick = colorsWatch_OnClick
            colorsWatch.OnEnter = colorsWatch_OnEnter
            colorsWatch.OnLeave = colorsWatch_OnLeave

            -- ExpandArrow
            local expandArrow = Button("ExpandArrow", self)
            expandArrow.Height = 16
            expandArrow.Width = 16
            expandArrow.Visible = false
            expandArrow:SetPoint("RIGHT", self, "RIGHT", 0, 0)
            expandArrow:SetNormalTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")

            expandArrow.OnClick = expandArrow_OnClick
            expandArrow.OnEnter = expandArrow_OnEnter
            expandArrow.OnLeave = expandArrow_OnLeave

            -- FontString
            local text = FontString("Text",self,"OVERLAY","GameFontNormal")
            text.JustifyH = "LEFT"
            text:SetPoint("LEFT", self, "LEFT", 18, 0)
            text:SetHeight(16)
            self:SetFontString(text)

            -- Script
            self.OnEnter = self.OnEnter + item_OnEnter
            self.OnLeave = self.OnLeave + item_OnLeave
            self.OnClick = self.OnClick + OnClick

            --- Font
            self:SetNormalFontObject(GameFontHighlightSmallLeft)
            self:SetDisabledFontObject(GameFontDisableSmallLeft)
            self:SetHighlightFontObject(GameFontHighlightSmallLeft)
        end
    endclass "DropDownMenuButton"

    ------------------------------------------------------
	--------------------- DropDownList ----------------------
	------------------------------------------------------

	-- Script
	_FrameBackdrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 9,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
	}

    local function hideDropList(self)
		if self["IsObjectType"] and self:IsObjectType("DropDownList") then
			self = self.__DdList or self
		end
        if self.__Childs and type(self.__Childs) == "table" then
            for i,v in pairs(self.__Childs) do
                if type(v) == "table" and v["IsObjectType"] and v:IsObjectType(DropDownMenuButton) then
                    if v.__DropDownList then
                        hideDropList(v.__DropDownList)
                    end
                end
            end
        end
        self.Visible = false
    end

	local function OnTimer(self)
		if not self.Parent.__Mask.InDesignMode then
			hideDropList(self.Parent)
			self.Interval = 0
		end
	end

	local function OnEnter(self)
		self:GetChild("DropDownList_Timer").Interval = 0

        if self.__MenuBase then
            self.__MenuBase:Fire("OnEnter")
        end

		return self.__Mask:Fire("OnEnter")
	end

	local function OnLeave(self)
		if self.Visible then
			self:GetChild("DropDownList_Timer").Interval = 2
		end
        if self.__MenuBase then
            self.__MenuBase:Fire("OnLeave")
        end

		return self.__Mask:Fire("OnLeave")
	end

    local function OnShow(self, ...)
        self:GetChild("DropDownList_Timer").Interval = 2

        -- Set the dropdownframe scale
		local uiScale
		local uiParentScale = UIParent:GetScale()
		if (GetCVar("useUIScale") == "1" ) then
			uiScale = tonumber(GetCVar("uiscale"))
			if (uiParentScale < uiScale ) then
				uiScale = uiParentScale
			end
		else
			uiScale = uiParentScale
		end

		self:SetScale(uiScale)

        if self.__MenuLevel > 1 then
            return self.__Mask:Fire("OnShow")
        end

		if not self.__Mask.InDesignMode then
			if _DropDownListContainer.__ShowList and _DropDownListContainer.__ShowList ~= self then
				_DropDownListContainer.__ShowList.Visible = false
			end

			_DropDownListContainer.__ShowList = self
		end

		if self.__ShowOnCursor then
            local cursorX, cursorY = GetCursorPosition()
            cursorX = cursorX/uiScale
            cursorY =  cursorY/uiScale

            local offsetX, offsetY

            offsetX = cursorX
            offsetY = cursorY

            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", offsetX, offsetY)

            local x, y = self:GetCenter()

            if not (x and y) then
                self:Hide()
                return
            end

            -- Determine whether the menu is off the screen or not
            local offscreenY, offscreenX;
            if ((y - self:GetHeight()/2) < 0 ) then
                offscreenY = 1
            end
            if (self:GetRight() > GetScreenWidth() ) then
                offscreenX = 1
            end

            self:ClearAllPoints()
            if offscreenX and offscreenY then
                self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", offsetX, offsetY)
            elseif offscreenX then
                self:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", offsetX, offsetY)
            elseif offscreenY then
                self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", offsetX, offsetY)
            end
        end

		return self.__Mask:Fire("OnShow")
    end

    local function OnHide(self, ...)
		self:GetChild("DropDownList_Timer").Interval = 0

		hideDropList(self)

        if self.__MenuLevel > 1 then
            return self.__Mask:Fire("OnHide")
        end

        if _DropDownListContainer.__ShowList and _DropDownListContainer.__ShowList == self then
            _DropDownListContainer.__ShowList = nil
        end

		return self.__Mask:Fire("OnHide")
    end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the DropDownList becomes visible
	-- @name DropDownList:OnShow
	-- @class function
	-- @usage function DropDownList:OnShow()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnShow"

	------------------------------------
	--- ScriptType, Run when the DropDownList's visbility changes to hidden
	-- @name DropDownList:OnHide
	-- @class function
	-- @usage function DropDownList:OnHide()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHide"

	------------------------------------
	--- ScriptType, Run when the mouse cursor enters the DropDownList's interactive area
	-- @name DropDownList:OnEnter
	-- @class function
	-- @param motion True if the handler is being run due to actual mouse movement; false if the cursor entered the DropDownList due to other circumstances (such as the frame being created underneath the cursor)
	-- @usage function DropDownList:OnEnter(motion)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEnter"

	------------------------------------
	--- ScriptType, Run when the mouse cursor leaves the DropDownList's interactive area
	-- @name DropDownList:OnLeave
	-- @class function
	-- @param motion True if the handler is being run due to actual mouse movement; false if the cursor left the DropDownList due to other circumstances (such as the frame being created underneath the cursor)
	-- @usage function DropDownList:OnLeave(motion)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnLeave"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	-- Dispose, release resource
	function Dispose(self)
		self.__DdList:Dispose()

		-- Call super's dispose
		return VirtualUIObject.Dispose(self)
	end

	------------------------------------
	--- Add or get a dropDownMenuButton with the given name list
	-- @name DropDownList:AddMenuButton
	-- @class function
	-- @param name the name of the menu button
	-- @param ... the sub menu item's name list
	-- @return Reference to the new dropdownmenubutton
	-- @usage DropDownList:AddMenuButton("Action", "Click", "Item")
	------------------------------------
	function AddMenuButton(self, ...)
		local name, mnuBtn, menu

		for i = 1, select("#", ...) do
			name = select(i, ...)

			if name and type(name) == "string" and name ~= "" then
				menu = (mnuBtn and (mnuBtn.DropDownList or DropDownList("MenuList", mnuBtn))) or self

				if not menu:IsObjectType("DropDownList") then
					error("The object with name ["..name.."] is not a DropDownList.")
				end

				if mnuBtn then
					mnuBtn:SetDropDownList(menu)
				end

				if menu:GetMenuButton(name) then
					mnuBtn = menu:GetMenuButton(name)
				else
					mnuBtn = DropDownMenuButton(name, menu.__DdList)
					mnuBtn.Text = name
				end
			else
				error("The name must be string.", 2)
			end
		end

		return mnuBtn
	end

	------------------------------------
	--- get a dropDownMenuButton with the given name list
	-- @name DropDownList:GetMenuButton
	-- @class function
	-- @param name the name of the menu button
	-- @param ... the sub menu item's name list
	-- @return Reference to the dropdownmenubutton
	-- @usage DropDownList:GetMenuButton("Action", "Click", "Item")
	------------------------------------
	function GetMenuButton(self, ...)
		local name, mnuBtn, menu

		menu = self

		for i = 1, select("#", ...) do
			name = select(i, ...)

			if name and type(name) == "string" and name ~= "" then
				if not menu or not menu:IsObjectType("DropDownList") then
					return nil
				end

				mnuBtn = menu.__DdList:GetChild(name)

				if not mnuBtn then
					return nil
				end

				menu = mnuBtn.DropDownList
			elseif name and type(name) == "number" and name > 0 then
				if not menu or not menu:IsObjectType("DropDownList") or name > (menu.__DdList.__ItemCount or 0) then
					return nil
				end

				mnuBtn = nil

				 for _, v in pairs(menu.__DdList:GetChilds()) do
					if type(v) == "table" and v["IsObjectType"] and v:IsObjectType(DropDownMenuButton) and v.__Index == name then
						mnuBtn = v
						break
					end
				end

				if not mnuBtn then
					return nil
				end

				menu = mnuBtn.DropDownList
			else
				return nil
			end
		end

		return mnuBtn
	end

	------------------------------------
	--- remove dropDownMenuButton with the given name list
	-- @name DropDownList:RemoveMenuButton
	-- @class function
	-- @param name the name of the menu button
	-- @param ... the sub menu item's name list
	-- @usage DropDownList:RemoveMenuButton("Action", "Click", "Item")
	------------------------------------
	function RemoveMenuButton(self, ...)
		local mnuBtn = self:GetMenuButton(...)

		return mnuBtn and mnuBtn:Dispose()
	end

	------------------------------------
	--- Return this object's alpha (transparency) value.
	-- @name DropDownList:GetAlpha
	-- @class function
	-- @return this object's alpha (transparency) value
	-- @usage DropDownList:GetAlpha()
	------------------------------------
	function GetAlpha(self)
		return self.__DdList:GetAlpha() or 1
	end

	------------------------------------
	--- Set the object's alpha (transparency) value.
	-- @name DropDownList:SetAlpha
	-- @class function
	-- @param alpha this object's alpha (transparency) value
	-- @usage DropDownList:SetAlpha(1)
	------------------------------------
	function SetAlpha(self, alpha)
		self.__DdList:SetAlpha(alpha)
	end

	------------------------------------
	--- Clear all attachment points for this object.
	-- @name DropDownList:ClearAllPoints
	-- @class function
	-- @usage DropDownList:ClearAllPoints()
	------------------------------------
	function ClearAllPoints(self)
		self.__DdList:ClearAllPoints()
	end

	------------------------------------
	--- Get the y location of the bottom edge of this object
	-- @name DropDownList:GetBottom
	-- @class function
	-- @return the y location of the bottom edge of this object
	-- @usage DropDownList:GetBottom()
	------------------------------------
	function GetBottom(self)
		return self.__DdList:GetBottom()
	end

	------------------------------------
	--- Get the coordinates of the center of this object
	-- @name DropDownList:GetCenter
	-- @class function
	-- @return x - Distance from the left edge of the screen to the center of the object (in pixels)
	-- @return y - Distance from the bottom edge of the screen to the center of the object (in pixels)
	-- @usage DropDownList:GetCenter()
	------------------------------------
	function GetCenter(self)
		return self.__DdList:GetCenter()
	end

	------------------------------------
	--- Get the height of this object.
	-- @name DropDownList:GetHeight
	-- @class function
	-- @return the height of this object
	-- @usage DropDownList:GetHeight()
	------------------------------------
	function GetHeight(self)
		return self.__DdList:GetHeight()
	end

	------------------------------------
	--- Get the x location of the left edge of this object
	-- @name DropDownList:GetLeft
	-- @class function
	-- @return the x location of the left edge of this object
	-- @usage DropDownList:GetLeft()
	------------------------------------
	function GetLeft(self)
		return self.__DdList:GetLeft()
	end

	------------------------------------
	--- Get the number of anchor points for this object
	-- @name DropDownList:GetNumPoints
	-- @class function
	-- @return the number of anchor points for this object
	-- @usage DropDownList:GetNumPoints()
	------------------------------------
	function GetNumPoints(self)
		return self.__DdList:GetNumPoints()
	end

	------------------------------------
	--- Returns information about one of the object's anchor points
	-- @name DropDownList:GetPoint
	-- @class function
	-- @param index Index of an anchor point defined for the object (between 1 and DropDownList:GetNumPoints())
	-- @return point - Point on this object at which it is anchored to another (string, anchorPoint)
	-- @return relativeTo - Reference to the other object to which this object is anchored (region)
	-- @return relativePoint - Point on the other object to which this object is anchored (string, anchorPoint)
	-- @return xOffset - Horizontal distance between point and relativePoint (in pixels; positive values put point  to the right of relativePoint) (number)
	-- @return yOffset - Vertical distance between point and relativePoint (in pixels; positive values put point  below relativePoint) (number)
	-- @usage DropDownList:GetPoint(1)
	------------------------------------
	function GetPoint(self, pointNum)
		return self.__DdList:GetPoint(pointNum)
	end

	------------------------------------
	--- Get the x location of the right edge of this object
	-- @name DropDownList:GetRight
	-- @class function
	-- @return the x location of the right edge of this object
	-- @usage DropDownList:GetRight()
	------------------------------------
	function GetRight(self)
		return self.__DdList:GetRight()
	end

	------------------------------------
	--- Get the y location of the top edge of this object
	-- @name DropDownList:GetTop
	-- @class function
	-- @return the y location of the top edge of this object
	-- @usage DropDownList:GetTop()
	------------------------------------
	function GetTop(self)
		return self.__DdList:GetTop()
	end

	------------------------------------
	--- Get the width of this object
	-- @name DropDownList:GetWidth
	-- @class function
	-- @return the width of this object
	-- @usage DropDownList:GetWidth()
	------------------------------------
	function GetWidth(self)
		return self.__DdList:GetWidth()
	end

	------------------------------------
	--- Set this object to hidden (it and all of its children will disappear).
	-- @name DropDownList:Hide
	-- @class function
	-- @usage DropDownList:Hide()
	------------------------------------
	function Hide(self)
		return self.__DdList:Hide()
	end

	------------------------------------
	--- Set this object to shown (it will appear if its parent is visible).
	-- @name DropDownList:Show
	-- @class function
	-- @usage DropDownList:Show()
	------------------------------------
	function Show(self)
		self.__DdList:Show()
	end

	------------------------------------
	--- Determine if this object is shown (would be visible if its parent was visible).
	-- @name DropDownList:IsShown
	-- @class function
	-- @return true if the object is shown
	-- @usage DropDownList:IsShown()
	------------------------------------
	function IsShown(self)
		return self.__DdList:IsShown()
	end

	------------------------------------
	--- Get whether the object is visible on screen (logically (IsShown() and GetParent():IsVisible()));
	-- @name DropDownList:IsVisible
	-- @class function
	-- @return true if the object is visible
	-- @usage DropDownList:IsVisible()
	------------------------------------
	function IsVisible(self)
		return self.__DdList:IsVisible()
	end

	------------------------------------
	--- Sets all anchor points of the object to match those of another object. If no object is specified, the object's anchor points are set to those of its parent.
	-- @name DropDownList:SetAllPoints
	-- @class function
	-- @param object Reference to a object or a global name of a object
	-- @usage DropDownList:SetAllPoints(UIParent)
	------------------------------------
	function SetAllPoints(self, frame)
		if frame and type(frame) == "string" then
			frame = _G[frame]
		end

		if not frame or type(frame) ~= "table" then
			frame = self.Parent
		end

		self.__DdList:SetAllPoints(frame)
	end

	------------------------------------
	--- Sets an anchor point for the object
	-- @name DropDownList:SetPoint
	-- @class function
	-- @param point Point on this object at which it is to be anchored to another (string, anchorPoint)
	-- @param relativeTo Reference to the other object to which this object is to be anchored; if nil or omitted, anchors the object relative to its parent (or to the screen dimensions if the region has no parent) (region)
	-- @param relativePoint Point on the other object to which this object is to be anchored; if nil or omitted, defaults to the same value as point (string, anchorPoint)
	-- @param xOffset Horizontal distance between point and relativePoint (in pixels; positive values put point to the right of relativePoint); if nil or omitted, defaults to 0 (number)
	-- @param yOffset Vertical distance between point and relativePoint (in pixels; positive values put point below relativePoint); if nil or omitted, defaults to 0 (number)
	-- @usage DropDownList:SetPoint("CENTER", UIParent, "CENTER", 50, 40)
	------------------------------------
	function SetPoint(self, point, relativeObject, relativePoint, xOfs, yOfs)
		self.__DdList:SetPoint(point, relativeObject, relativePoint, xOfs, yOfs)
	end

	------------------------------------
	--- Returns the position and dimensions of the object
	-- @name DropDownList:GetRect
	-- @class function
	-- @return left - Distance from the left edge of the screen to the left edge of the object (in pixels) (number)
	-- @return bottom - Distance from the bottom edge of the screen to the bottom of the object (in pixels) (number)
	-- @return width - Width of the object (in pixels) (number)
	-- @return height - Height of the object (in pixels)
	-- @usage DropDownList:GetRect()
	------------------------------------
	function GetRect(self)
		return self.__DdList:GetRect()
	end

	------------------------------------
	--- Returns whether the object is currently being dragged
	-- @name DropDownList:IsDragging
	-- @class function
	-- @return isDragging - 1 if the object (or its parent or ancestor) is currently being dragged; otherwise nil
	-- @usage DropDownList:IsDragging()
	------------------------------------
	function IsDragging(self)
		return self.__DdList:IsDragging()
	end

	------------------------------------
	--- Disable rendering of "regions" (fontstrings, textures) in the specified draw layer.
	-- @name DropDownList:DisableDrawLayer
	-- @class function
	-- @param layer Name of a graphics layer
	-- @usage DropDownList:DisableDrawLayer("ARTWORK")
	------------------------------------
	function DisableDrawLayer(self, ...)
		return self.__DdList:DisableDrawLayer(...)
	end

	------------------------------------
	--- Enable rendering of "regions" (fontstrings, textures) in the specified draw layer.
	-- @name DropDownList:EnableDrawLayer
	-- @class function
	-- @param layer Name of a graphics layer
	-- @usage DropDownList:EnableDrawLayer("ARTWORK")
	------------------------------------
	function EnableDrawLayer(self, ...)
		return self.__DdList:EnableDrawLayer(...)
	end

	------------------------------------
	--- Creates and returns a backdrop table suitable for use in SetBackdrop
	-- @name DropDownList:GetBackdrop
	-- @class function
	-- @return A table containing the backdrop settings, or nil if the object has no backdrop
	-- @usage DropDownList:GetBackdrop()
	------------------------------------
	function GetBackdrop(self, ...)
		return self.__DdList:GetBackdrop(...)
	end

	------------------------------------
	--- Set the backdrop of the object according to the specification provided.
	-- @name DropDownList:SetBackdrop
	-- @class function
	-- @param backdropTable Optional,A table containing the backdrop settings, or nil to remove the object's backdrop
	-- @usage DropDownList:SetBackdrop{<br>
	--    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",<br>
	--    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",<br>
	--    tile = true,<br>
	--    tileSize = 32,<br>
	--    edgeSize = 32,<br>
	--    insets = {<br>
	--         left = 11,<br>
	--         right = 12,<br>
	--         top = 12,<br>
	--         bottom = 11,<br>
	--    },<br>
	-- }<br>
	------------------------------------
	function SetBackdrop(self, backdropTable)
		return self.__DdList:SetBackdrop(backdropTable or nil)
	end

	------------------------------------
	--- Gets the object's backdrop border color (r, g, b, a)
	-- @name DropDownList:GetBackdropBorderColor
	-- @class function
	-- @return red Red component of the color (0.0 - 1.0)
	-- @return green Green component of the color (0.0 - 1.0)
	-- @return blue Blue component of the color (0.0 - 1.0)
	-- @return alpha Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	-- @usage DropDownList:GetBackdropBorderColor()
	------------------------------------
	function GetBackdropBorderColor(self, ...)
		return self.__DdList:GetBackdropBorderColor(...)
	end

	------------------------------------
	--- Set the object's backdrop's border's color.
	-- @name DropDownList:SetBackdropBorderColor
	-- @class function
	-- @param red Red component of the color (0.0 - 1.0)
	-- @param green Green component of the color (0.0 - 1.0)
	-- @param blue Blue component of the color (0.0 - 1.0)
	-- @param alpha Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	-- @usage DropDownList:SetBackdropBorderColor(1, 1, 0.8, 0.4)
	------------------------------------
	function SetBackdropBorderColor(self, ...)
		return self.__DdList:SetBackdropBorderColor(...)
	end

	------------------------------------
	--- Gets the object's backdrop color (r, g, b, a)
	-- @name DropDownList:GetBackdropColor
	-- @class function
	-- @return red Red component of the color (0.0 - 1.0)
	-- @return green Green component of the color (0.0 - 1.0)
	-- @return blue Blue component of the color (0.0 - 1.0)
	-- @return alpha Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	-- @usage DropDownList:GetBackdropColor()
	------------------------------------
	function GetBackdropColor(self, ...)
		return self.__DdList:GetBackdropColor(...)
	end

	------------------------------------
	--- Set the object's backdrop color.
	-- @name DropDownList:SetBackdropColor
	-- @class function
	-- @param red Red component of the color (0.0 - 1.0)
	-- @param green Green component of the color (0.0 - 1.0)
	-- @param blue Blue component of the color (0.0 - 1.0)
	-- @param alpha Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	-- @usage DropDownList:SetBackdropColor(1, 1, 0.8, 0.4)
	------------------------------------
	function SetBackdropColor(self, ...)
		return self.__DdList:SetBackdropColor(...)
	end

	------------------------------------
	--- Gets the modifiers to the object's rectangle used for clamping the object to screen.
	-- @name DropDownList:GetClampRectInsets
	-- @class function
	-- @return left Offset from the left edge of the object to the left edge of its clamping area (in pixels)
	-- @return right Offset from the right edge of the object's clamping area to the right edge of the object (in pixels)
	-- @return top Offset from the top edge of the object's clamping area to the top edge of the object (in pixels)
	-- @return bottom Offset from the bottom edge of the object to the bottom edge of its clamping area (in pixels)
	-- @usage DropDownList:GetClampRectInsets()
	------------------------------------
	function GetClampRectInsets(self, ...)
		return self.__DdList:GetClampRectInsets(...)
	end

	------------------------------------
	--- Modify the object's rectangle used to prevent dragging offscreen.
	-- @name DropDownList:SetClampRectInsets
	-- @class function
	-- @param left Offset from the left edge of the object to the left edge of its clamping area (in pixels)
	-- @param right Offset from the right edge of the object's clamping area to the right edge of the object (in pixels)
	-- @param top Offset from the top edge of the object's clamping area to the top edge of the object (in pixels)
	-- @param bottom Offset from the bottom edge of the object to the bottom edge of its clamping area (in pixels)
	-- @usage DropDownList:SetClampRectInsets(50, -50, -50, 50)
	------------------------------------
	function SetClampRectInsets(self, ...)
		return self.__DdList:SetClampRectInsets(...)
	end

	------------------------------------
	--- Returns the 3D depth of the object (for stereoscopic 3D setups)
	-- @name DropDownList:GetDepth
	-- @class function
	-- @return Apparent 3D depth of this object relative to that of its parent object
	-- @usage DropDownList:GetDepth()
	------------------------------------
	function GetDepth(self, ...)
		return self.__DdList:GetDepth(...)
	end

	------------------------------------
	--- Sets the 3D depth of the object (for stereoscopic 3D configurations)
	-- @name DropDownList:SetDepth
	-- @class function
	-- @param depth Apparent 3D depth of this object relative to that of its parent object
	-- @usage DropDownList:SetDepth(10)
	------------------------------------
	function SetDepth(self, ...)
		return self.__DdList:SetDepth(...)
	end

	------------------------------------
	--- Returns the effective alpha of a object.
	-- @name DropDownList:GetEffectiveAlpha
	-- @class function
	-- @return Effective alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque)
	-- @usage DropDownList:GetEffectiveAlpha()
	------------------------------------
	function GetEffectiveAlpha(self, ...)
		return self.__DdList:GetEffectiveAlpha(...)
	end

	------------------------------------
	--- Returns the overall 3D depth of the object (for stereoscopic 3D configurations).
	-- @name DropDownList:GetEffectiveDepth
	-- @class function
	-- @return Apparent 3D depth of this object relative to the screen
	-- @usage DropDownList:GetEffectiveDepth()
	------------------------------------
	function GetEffectiveDepth(self, ...)
		return self.__DdList:GetEffectiveDepth(...)
	end

	------------------------------------
	--- Get the scale factor of this object relative to the root window.
	-- @name DropDownList:GetEffectiveScale
	-- @class function
	-- @return Scale factor for the object relative to its parent
	-- @usage DropDownList:GetEffectiveScale()
	------------------------------------
	function GetEffectiveScale(self, ...)
		return self.__DdList:GetEffectiveScale(...)
	end

	------------------------------------
	--- Gets the object's hit rectangle inset distances (l, r, t, b)
	-- @name DropDownList:GetHitRectInsets
	-- @class function
	-- @return left Distance from the left edge of the object to the left edge of its mouse-interactive area (in pixels)
	-- @return right Distance from the right edge of the object to the right edge of its mouse-interactive area (in pixels)
	-- @return top Distance from the top edge of the object to the top edge of its mouse-interactive area (in pixels)
	-- @return bottom Distance from the bottom edge of the object to the bottom edge of its mouse-interactive area (in pixels)
	-- @usage DropDownList:GetHitRectInsets()
	------------------------------------
	function GetHitRectInsets(self, ...)
		return self.__DdList:GetHitRectInsets(...)
	end

	------------------------------------
	--- Set the inset distances for the object's hit rectangle
	-- @name DropDownList:SetHitRectInsets
	-- @class function
	-- @param left Distance from the left edge of the object to the left edge of its mouse-interactive area (in pixels)
	-- @param right Distance from the right edge of the object to the right edge of its mouse-interactive area (in pixels)
	-- @param top Distance from the top edge of the object to the top edge of its mouse-interactive area (in pixels)
	-- @param bottom Distance from the bottom edge of the object to the bottom edge of its mouse-interactive area (in pixels)
	-- @usage DropDownList:SetHitRectInsets(10, -10, -10, 10)
	------------------------------------
	function SetHitRectInsets(self, ...)
		return self.__DdList:SetHitRectInsets(...)
	end

	------------------------------------
	--- Get the ID of this object.
	-- @name DropDownList:GetID
	-- @class function
	-- @return the ID of this object
	-- @usage DropDownList:GetID()
	------------------------------------
	function GetID(self, ...)
		return self.__DdList:GetID(...)
	end

	------------------------------------
	--- Set the ID of this object.
	-- @name DropDownList:SetID
	-- @class function
	-- @param id A numeric identifier for the object
	-- @usage DropDownList:SetID(1)
	------------------------------------
	function SetID(self, ...)
		return self.__DdList:SetID(...)
	end

	------------------------------------
	--- Sets whether the object's depth property is ignored (for stereoscopic 3D setups).
	-- @name DropDownList:IgnoreDepth
	-- @class function
	-- @param enable True to ignore the object's depth property; false to disable
	-- @usage DropDownList:IgnoreDepth(false)
	------------------------------------
	function IgnoreDepth(self, ...)
		return self.__DdList:IgnoreDepth(...)
	end

	------------------------------------
	--- Returns whether the object's depth property is ignored (for stereoscopic 3D setups)
	-- @name DropDownList:IsIgnoringDepth
	-- @class function
	-- @return 1 if the object's depth property is ignored; otherwise nil
	-- @usage DropDownList:IsIgnoringDepth()
	------------------------------------
	function IsIgnoringDepth(self, ...)
		return self.__DdList:IsIgnoringDepth(...)
	end

	------------------------------------
	--- Get the list of "children" (frames and things derived from frames) of this object.
	-- @name DropDownList:GetChilds
	-- @class function
	-- @return a list of child-frames
	-- @usage DropDownList:GetChilds()
	------------------------------------
	function GetChilds(self, ...)
		return self.__DdList:GetChilds()
	end

	------------------------------------
	--- Get the child of the given name
	-- @name DropDownList:GetChild
	-- @class function
	-- @param name the child's name or itself
	-- @return the child
	-- @usage DropDownList:GetChild("BtnOkay")
	------------------------------------
	function GetChild(self, ob)
		return self.__DdList:GetChild(ob)
	end

	--	Property
	--- Alpha
	property "Alpha" {
		Set = function(self, alpha)
			self:SetAlpha(alpha)
		end,

		Get = function(self)
			return self:GetAlpha()
		end,

		Type = ColorFloat,
	}
	property "ShowOnCursor" {
		Set = function(self, flag)
			self = self.__DdList
			self.__ShowOnCursor = (flag and true) or false
		end,

		Get = function(self)
			self = self.__DdList
			return (self.__ShowOnCursor and true) or false
		end,

		Type = Boolean,
	}
	property "MultiSelect" {
		Set = function(self, flag)
			self = self.__DdList
			self.__MultiSelect = (flag and true) or false
		end,

		Get = function(self)
			self = self.__DdList
			return (self.__MultiSelect and true) or false
		end,

		Type = Boolean,
	}
	--- Height
	property "Height" {
		Get = function(self)
			self = self.__DdList
			return self:GetHeight()
		end,

		Type = Number,
	}
	--- Width
	property "Width" {
		Get = function(self)
			self = self.__DdList
			return self:GetWidth()
		end,

		Type = Number,
	}
	--- Visible
	property "Visible" {
		Set = function(self, visible)
			self.__DdList.Visible = visible
		end,

		Get = function(self)
			return self.__DdList.Visible
		end,

		Type = Boolean,
	}
	property "Backdrop" {
		Set = function(self, backdropTable)
			self:SetBackdrop(backdropTable)
		end,

		Get = function(self)
			return self:GetBackdrop()
		end,

		Type = BackdropType,
	}
	property "BackdropBorderColor" {
		Set = function(self, colorTable)
			self:SetBackdropBorderColor(colorTable.red, colorTable.green, colorTable.blue, colorTable.alpha)
		end,

		Get = function(self)
			local colorTable = {}
			colorTable.red, colorTable.green, colorTable.blue, colorTable.alpha = self:GetBackdropBorderColor()
			return colorTable
		end,

		Type = ColorType,
	}
	property "BackdropColor" {
		Set = function(self, colorTable)
			self:SetBackdropColor(colorTable.red, colorTable.green, colorTable.blue, colorTable.alpha)
		end,

		Get = function(self)
			local colorTable = {}
			colorTable.red, colorTable.green, colorTable.blue, colorTable.alpha = self:GetBackdropColor()
			return colorTable
		end,

		Type = ColorType,
	}
	property "ClampRectInsets" {
		Set = function(self, RectInset)
			self:SetClampRectInsets(RectInset.left, RectInset.right, RectInset.top, RectInset.bottom)
		end,

		Get = function(self)
			local RectInset = {}
			RectInset.left, RectInset.right, RectInset.top, RectInset.bottom = self:GetClampRectInsets()
			return RectInset
		end,

		Type = Inset,
	}
	property "HitRectInsets" {
		Set = function(self, RectInset)
			self:SetHitRectInsets(RectInset.left, RectInset.right, RectInset.top, RectInset.bottom)
		end,

		Get = function(self)
			local RectInset = {}
			RectInset.left, RectInset.right, RectInset.top, RectInset.bottom = self:GetHitRectInsets()
			return RectInset
		end,

		Type = Inset,
	}
	property "ID" {
		Set = function(self, id)
			self:SetID(id)
		end,

		Get = function(self)
			return self:GetID()
		end,

		Type = Number,
	}
	property "Depth" {
		Set = function(self, depth)
			self:SetDepth(depth)
		end,

		Get = function(self)
			return self:GetDepth()
		end,

		Type = Number,
	}
	property "DepthIgnored" {
		Set = function(self, enabled)
			self:IgnoreDepth(enabled)
		end,

		Get = function(self)
			return (self:IsIgnoringDepth() and true) or false
		end,

		Type = Boolean,
	}
	-- ItemCount
	property "ItemCount" {
		Get = function(self)
			return self.__DdList.__ItemCount
		end,

		Type = Number,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function DropDownList(self, name, parent)
        local frame = Button(nil, _DropDownListContainer)
		frame.__Mask = self
		self.__DdList = frame

        frame.FrameStrata = "TOOLTIP"
        frame.MouseWheelEnabled = true
        frame.Visible = false
        frame:ClearAllPoints()
        frame:SetBackdrop(_FrameBackdrop)
        frame:SetBackdropBorderColor(1, 1, 1);
		frame:SetBackdropColor(0.09, 0.09, 0.19);
        frame.Height = 8
        frame.Width = 100
		frame.__ShowOnCursor = true
		frame.__MultiSelect = true
		frame.__ItemCount = 0

        frame.OnShow = OnShow
        frame.OnHide = OnHide
        frame.OnEnter = OnEnter
        frame.OnLeave = OnLeave

		-- Timer
		local timer = Timer("DropDownList_Timer", frame)
		timer.Interval = 0
		timer.OnTimer = OnTimer

        -- MenuLevel
        frame.__MenuLevel = 1
	end
endclass "DropDownList"
