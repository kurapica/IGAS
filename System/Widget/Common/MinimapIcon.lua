-- Author      : Kurapica
-- Change Log  :
--				2011/03/13	Recode as class

---------------------------------------------------------------------------------------------------------------------------------------
--- MinimapIcon is a widget type using for to add a icon to minimap.
-- <br><br>inherit <a href="..\Base\VirtualUIObject.html">VirtualUIObject</a> For all methods, properties and scriptTypes
-- @name MinimapIcon
-- @class table
-- @field Tooltip the tooltip head to be shown when the cursor is over the icon
-- @field Menu if setted, the menu will be shown when right-click the icon
-- @field Position the position of the icon
-- @field Visible the visible of the icon
-- @field Text the text to be diplayed on the icon
---------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 8

if not IGAS:NewAddon("IGAS.Widget.MinimapIcon", version) then
	return
end

class "MinimapIcon"
	inherit "VirtualUIObject"

	-- Script
    GameTooltip = IGAS.GameTooltip
    Minimap = IGAS.Minimap

    minimapShapes = {
        ["ROUND"] = {true, true, true, true},
        ["SQUARE"] = {false, false, false, false},
        ["CORNER-TOPLEFT"] = {true, false, false, false},
        ["CORNER-TOPRIGHT"] = {false, false, true, false},
        ["CORNER-BOTTOMLEFT"] = {false, true, false, false},
        ["CORNER-BOTTOMRIGHT"] = {false, false, false, true},
        ["SIDE-LEFT"] = {true, true, false, false},
        ["SIDE-RIGHT"] = {false, false, true, true},
        ["SIDE-TOP"] = {true, false, true, false},
        ["SIDE-BOTTOM"] = {false, true, false, true},
        ["TRICORNER-TOPLEFT"] = {true, true, true, false},
        ["TRICORNER-TOPRIGHT"] = {true, false, true, true},
        ["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
        ["TRICORNER-BOTTOMRIGHT"] = {false, true, true, true},
    }

    local function updatePosition(button)
        local radius = button.__Position.radius
        local rounding = button.__Position.rounding
        local position = button.__Position.angel

        local angle = math.rad(position)
        local x, y, q = math.cos(angle), math.sin(angle), 1
        if x < 0 then q = q + 1 end
        if y > 0 then q = q + 2 end
        local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
        local quadTable = minimapShapes[minimapShape]
        if quadTable[q] then
            x, y = x*radius, y*radius
        else
            local diagRadius = math.sqrt(2*(radius)^2)-rounding
            x = math.max(-radius, math.min(x*diagRadius, radius))
            y = math.max(-radius, math.min(y*diagRadius, radius))
        end
        button:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end

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
            return "BOTTOM"..xFrom, "TOP"..xTo
        elseif y > GetScreenWidth() / 3 then
            yFrom, yTo = "TOP", "BOTTOM"
        end
        local from = yFrom..xFrom
        local to = yTo..xTo
        return (from == "" and "CENTER" or from), (to == "" and "CENTER" or to)
    end

    local function OnEnter(self, ...)
        local from, to
        from, to = getAnchors(self)

		if not self.__Tooltip or strtrim(self.__Tooltip) == "" then
			self.__Mask:Fire("OnEnter", ...)
			return
		end

        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint(from, self, to, 0, 0)
		GameTooltip:SetText(self.__Tooltip)
        self.__Mask:Fire("OnGameTooltipShow", GameTooltip)
        GameTooltip:Show()

		self.__Mask:Fire("OnEnter", ...)
    end

    local function OnLeave(self, ...)
        GameTooltip:Hide()
		self.__Mask:Fire("OnLeave", ...)
    end

    local function OnMouseDown(self, ...)
        self:GetChild("Icon"):SetTexCoord(0, 1, 0, 1)
    end

    local function OnMouseUp(self, ...)
        self:GetChild("Icon"):SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end

    local function OnUpdate(self)
        local mx, my = Minimap:GetCenter()
        local px, py = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        px, py = px / scale, py / scale
        self.__Position.angel = math.deg(math.atan2(py - my, px - mx)) % 360
        updatePosition(self)
    end

    local function OnDragStart(self, ...)
        self:LockHighlight()
        self:GetChild("Icon"):SetTexCoord(0, 1, 0, 1)
        self.OnUpdate = OnUpdate
        GameTooltip:Hide()
		self.__Mask:Fire("OnDragStart", ...)
    end

    local function OnDragStop(self, ...)
        self.OnUpdate = nil
        self:GetChild("Icon"):SetTexCoord(0.05, 0.95, 0.05, 0.95)
        self:UnlockHighlight()

		self.__Mask:Fire("OnDragStop", ...)
        self.__Mask:Fire("OnPositionChanged")
    end

	local function OnClick(self, button, down)
		if button == "RightButton" then
			-- Open Menu
			if self.__DropDownList then
				self.__DropDownList.Visible = false
				self.__DropDownList.Parent = self
				self.__DropDownList.Visible = true
			end
			return
		end

		self.__Mask:Fire("OnClick", button, down)
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the MinimapIcon's position is changed
	-- @name MinimapIcon:OnPositionChanged
	-- @class function
	-- @usage function MinimapIcon:OnPositionChanged()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnPositionChanged"

	------------------------------------
	--- ScriptType, Run when the mouse is over the icon, and the tooltip is setted.
	-- @name MinimapIcon:OnGameTooltipShow
	-- @class function
	-- @param GameTooltip the GameTooltip object
	-- @usage function MinimapIcon:OnGameTooltipShow(GameTooltip)<br>
	--    -- do someting like<br>
	--    GameTooltip:AddLine("Version 1")
	-- end
	------------------------------------
	script "OnGameTooltipShow"

	------------------------------------
	--- ScriptType, Run when icon is clicked
	-- @name MinimapIcon:OnClick
	-- @class function
	-- @usage function MinimapIcon:OnClick()<br>
	--    -- do someting like<br>
	-- end
	------------------------------------
	script "OnClick"

	------------------------------------
	--- ScriptType, Run when mouse is over the icon
	-- @name MinimapIcon:OnEnter
	-- @class function
	-- @usage function MinimapIcon:OnEnter()<br>
	--    -- do someting like<br>
	-- end
	------------------------------------
	script "OnEnter"

	------------------------------------
	--- ScriptType, Run when mouse is leaving the icon
	-- @name MinimapIcon:OnLeave
	-- @class function
	-- @usage function MinimapIcon:OnLeave()<br>
	--    -- do someting like<br>
	-- end
	------------------------------------
	script "OnLeave"

	------------------------------------
	--- ScriptType, Run when start dragging the icon
	-- @name MinimapIcon:OnDragStart
	-- @class function
	-- @usage function MinimapIcon:OnDragStart()<br>
	--    -- do someting like<br>
	-- end
	------------------------------------
	script "OnDragStart"

	------------------------------------
	--- ScriptType, Run when stop dragging the icon
	-- @name MinimapIcon:OnDragStop
	-- @class function
	-- @usage function MinimapIcon:OnDragStop()<br>
	--    -- do someting like<br>
	-- end
	------------------------------------
	script "OnDragStop"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	-- Dispose()
	function Dispose(self)
		if self.__MiniMapBtn.__DropDownList and self.__MiniMapBtn.__DropDownList.Parent == self.__MiniMapBtn then
			self.__MiniMapBtn.__DropDownList.Visible = false
			self.__MiniMapBtn.__DropDownList.Parent = nil
		end
		self.__MiniMapBtn:Dispose()
		-- Call super's dispose
		return VirtualUIObject.Dispose(self)
	end

	------------------------------------
	--- Sets the MinimapIcon's icon texutre
	-- @name MinimapIcon:SetIcon
	-- @class function
	-- @param texture the texture to be shown on the icon
	-- @usage MinimapIcon:SetIcon("Interface\\Icons\\Ability_Creature_Cursed_04")
	------------------------------------
	function SetIcon(self, icon)
		self.__MiniMapBtn:GetChild("Icon"):SetTexture(icon)
	end

	------------------------------------
	--- Hide the MinimapIcon
	-- @name MinimapIcon:Hide
	-- @class function
	-- @usage MinimapIcon:Hide()
	------------------------------------
	function Hide(self)
		return self.__MiniMapBtn:Hide()
	end

	------------------------------------
	--- Show the MinimapIcon
	-- @name MinimapIcon:Show
	-- @class function
	-- @usage MinimapIcon:Show()
	------------------------------------
	function Show(self)
		self.__MiniMapBtn:Show()
	end

	------------------------------------
	--- Check if the MinimapIcon is shown
	-- @name MinimapIcon:IsShown
	-- @class function
	-- @return true if the MinimapIcon is shown
	-- @usage MinimapIcon:IsShown()
	------------------------------------
	function IsShown(self)
		return self.__MiniMapBtn:IsShown()
	end

	------------------------------------
	--- Check if the MinimapIcon is visible
	-- @name MinimapIcon:IsVisible
	-- @class function
	-- @return true if the MinimapIcon is visible
	-- @usage MinimapIcon:IsVisible()
	------------------------------------
	function IsVisible(self)
		return self.__MiniMapBtn:IsVisible()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Tooltip
	property "Tooltip" {
		Set = function(self, tooltip)
			self.__MiniMapBtn.__Tooltip = tostring(tooltip or "")
		end,
		Get = function(self)
			return self.__MiniMapBtn.__Tooltip or ""
		end,
		Type = LocaleString,
	}
	-- Menu
	property "Menu" {
		Set = function(self, list)
			self.__MiniMapBtn.__DropDownList = list
		end,

		Get = function(self)
			return self.__MiniMapBtn.__DropDownList
		end,

		Type = DropDownList,
	}
	-- Position
	property "Position" {
		Set = function(self, position)
			if position then
				self.__MiniMapBtn.__Position["radius"] = position["radius"]
				self.__MiniMapBtn.__Position["rounding"] = position["rounding"]
				self.__MiniMapBtn.__Position["angel"] = position["angel"]
				updatePosition(self.__MiniMapBtn)
			end
		end,
		Get = function(self)
			return {["radius"] = self.__MiniMapBtn.__Position["radius"],
					["rounding"] = self.__MiniMapBtn.__Position["rounding"],
					["angel"] = self.__MiniMapBtn.__Position["angel"],
					}
		end,
		Type = MiniMapPosition + nil,
	}
	-- Visible
	property "Visible" {
		Set = function(self, visible)
			self.__MiniMapBtn.Visible = visible
		end,

		Get = function(self)
			return self.__MiniMapBtn.Visible
		end,

		Type = Boolean,
	}
	-- Text
	property "Text" {
		Set = function(self, text)
			self.__MiniMapBtn.txtInfo.Text = text
		end,

		Get = function(self)
			return self.__MiniMapBtn.txtInfo.Text or ""
		end,

		Type = LocaleString,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function MinimapIcon(name, parent)
		local mask = VirtualUIObject(name, parent)

		local button = Button(nil, Minimap)
		mask.__MiniMapBtn = button
		button.__Mask = mask

        button:SetFrameStrata("MEDIUM")
        button:SetWidth(31)
        button:SetHeight(31)
        button:SetFrameLevel(8)
        button:RegisterForClicks("anyUp")
        button:RegisterForDrag("LeftButton")
        button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

        local overlay = Texture("OverLay", button, "OVERLAY")
        overlay:SetWidth(53)
        overlay:SetHeight(53)
        overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
        overlay:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)

        local icon = Texture("Icon", button, "BACKGROUND")
        icon:SetWidth(20)
        icon:SetHeight(20)
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
        icon:SetPoint("TOPLEFT", button, "TOPLEFT", 7, -5)

		local txtInfo = FontString("txtInfo", button, "ARTWORK", "GameFontHighlight")
		txtInfo:SetAllPoints(button)
		txtInfo.Text = ""

        button.__Position = {
            ["radius"] = 80,
            ["rounding"] = 10,
            ["angel"] = random(0, 360),
        }

        updatePosition(button)

        button.OnEnter = OnEnter
        button.OnLeave = OnLeave
        button.OnDragStart = OnDragStart
        button.OnDragStop = OnDragStop
        button.OnMouseDown = OnMouseDown
        button.OnMouseUp = OnMouseUp
		button.OnClick = OnClick

		return mask
	end
endclass "MinimapIcon"
