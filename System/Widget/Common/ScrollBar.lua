-- Author		: Kurapica
-- Create Date	: 8/04/2008 00:06
-- ChangeLog	:
--				2010/05/31 Fix OnEnter and OnLeave Script
--				2011/03/13	Recode as class

---------------------------------------------------------------------------------------------------------------------------------------
--- ScrollBar is a widget type using for <a href=".\ScrollForm">ScrollForm</a>
-- <br><br>inherit <a href="..\Base\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name ScrollBar
-- @class table
-- @field Value the value representing the current position of the slider thumb
-- @field ValueStep the minimum increment between allowed slider values
-- @field Enabled whether user interaction with the slider is allowed
-- @field Style the popupdialog's style: CLASSIC, LIGHT
---------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 7
if not IGAS:NewAddon("IGAS.Widget.ScrollBar", version) then
	return
end

class "ScrollBar"
	inherit "Frame"

    -- ScrollBar Template
    TEMPLATE_CLASSIC = "CLASSIC"
    TEMPLATE_LIGHT = "LIGHT"

    -- Define Block
	enum "ScrollBarStyle" {
        TEMPLATE_CLASSIC,
        TEMPLATE_LIGHT,
    }

	-- Scripts
	local function OnEnter(self)
		self.Parent:Fire("OnEnter")
	end

	local function OnLeave(self)
		self.Parent:Fire("OnLeave")
	end

    local function OnValueChanged(self, value)
		if self.Parent.SetVerticalScroll then
			self:GetParent():SetVerticalScroll(value)
		end
    end

    local function clickUpBtn(self)
        local slider = self:GetParent():GetChild("Slider")

		slider:SetValue(slider:GetValue() - slider:GetValueStep());
        PlaySound("UChatScrollButton")
    end

    local function clickDownBtn(self)
        local slider = self:GetParent():GetChild("Slider")

        slider:SetValue(slider:GetValue() + slider:GetValueStep());
        PlaySound("UChatScrollButton")
    end

    local function OnMouseWheel(self,value)
        local iMin, iMax = self:GetMinMaxValues()

        if value > 0 then
            if IsShiftKeyDown() then
                self.Value = iMin
            else
                 if self.Value - self.ValueStep > iMin then
                   self.Value = self.Value - self.ValueStep
                else
                   self.Value = iMin
                end
            end
        elseif value < 0 then
            if IsShiftKeyDown() then
                self.Value = iMax
            else
                if self.Value + self.ValueStep < iMax then
                   self.Value = self.Value + self.ValueStep
                else
                   self.Value = iMax
                end
            end
        end
    end

	local function UpdateButton(self)
        local iMin, iMax = self:GetChild("Slider"):GetMinMaxValues()

        if self:GetChild("Slider"):GetValue() == iMin then
            self:GetChild("UpBtn"):Disable()
        else
            self:GetChild("UpBtn"):Enable()
        end

        if self:GetChild("Slider"):GetValue() == iMax then
            self:GetChild("DownBtn"):Disable()
        else
            self:GetChild("DownBtn"):Enable()
        end
	end

    local function scrollChg(self)
		if self.__Value == self:GetValue() then
			return
		end

		self.__Value = self:GetValue()

		UpdateButton(self:GetParent())

        return self:GetParent():Fire("OnValueChanged", self.__Value)
    end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the ScrollBar's or status bar's value changes
	-- @name ScrollBar:OnValueChanged
	-- @class function
	-- @param value New value of the ScrollBar or the status bar
	-- @usage function ScrollBar:OnValueChanged(value)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnValueChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Sets the scrollbar's style
	-- @name ScrollBar:SetStyle
	-- @class function
	-- @param style the style of the scrollbar : CLASSIC, LIGHT
	-- @usage ScrollBar:SetStyle("LIGHT")
	------------------------------------
	function SetStyle(self, style)
		local t

		-- Check Style
		if not style or type(style) ~= "string" then
			return
		end

		if (not ScrollBarStyle[style]) or style == self.__Style then
			return
		end

		-- Change Style
		if style == TEMPLATE_CLASSIC then
			local top = Texture("TopTexture", self, "ARTWORK")
			top.TexturePath = [[Interface\PaperDollInfoFrame\UI-Character-ScrollBar]]
			top.Width = 32
			top.Height = 24
			top:SetTexCoord(0, 0.484375, 0, 0.086)
			top:SetPoint("TOP", self, "TOP")
			top.Visible = true

			local bottom = Texture("BottomTexture", self, "ARTWORK")
			bottom.TexturePath = [[Interface\PaperDollInfoFrame\UI-Character-ScrollBar]]
			bottom.Width = 32
			bottom.Height = 24
			bottom:SetTexCoord(0.515625, 1, 0.333, 0.4140625)
			bottom:SetPoint("BOTTOM", self, "BOTTOM")
			bottom.Visible = true

			local middle = Texture("MiddleTexture", self, "ARTWORK")
			middle.TexturePath = [[Interface\PaperDollInfoFrame\UI-Character-ScrollBar]]
			middle:SetTexCoord(0, 0.484375, 0.75, 1.0)
			middle:SetPoint("TOPLEFT", top, "BOTTOMLEFT")
			middle:SetPoint("BOTTOMRIGHT", bottom, "TOPRIGHT")
			middle.Visible = true

		elseif style == TEMPLATE_LIGHT then
			if self.MiddleTexture then
				self.MiddleTexture.Visible = false
			end
			if self.TopTexture then
				self.TopTexture.Visible = false
			end
			if self.BottomTexture then
				self.BottomTexture.Visible = false
			end
		end

		self.__Style = style
	end

	------------------------------------
	--- Gets the scrollbar's style
	-- @name ScrollBar:GetStyle
	-- @class function
	-- @return the style of the scrollbar : CLASSIC, LIGHT
	-- @usage ScrollBar:GetStyle()
	------------------------------------
	function GetStyle(self)
		return self.__Style or TEMPLATE_LIGHT
	end

	------------------------------------
	--- Get the current bounds of the slider.
	-- @name ScrollBar:GetMinMaxValues
	-- @class function
	-- @return the current bounds of the slider
	-- @usage ScrollBar:GetMinMaxValues()
	------------------------------------
	function GetMinMaxValues(self)
		return self:GetChild("Slider"):GetMinMaxValues()
	end

	------------------------------------
	--- Get the current value of the slider.
	-- @name ScrollBar:GetMinMaxValues
	-- @class function
	-- @return the current value of the slider
	-- @usage ScrollBar:GetMinMaxValues()
	------------------------------------
	function GetValue(self)
		return self:GetChild("Slider"):GetValue()
	end

	------------------------------------
	--- Get the current step size of the slider.
	-- @name ScrollBar:GetValueStep
	-- @class function
	-- @return the current step size of the slider
	-- @usage ScrollBar:GetValueStep()
	------------------------------------
	function GetValueStep(self)
		return self:GetChild("Slider"):GetValueStep()
	end

	------------------------------------
	--- Sets the minimum and maximum values for the slider
	-- @name ScrollBar:SetMinMaxValues
	-- @class function
	-- @param minValue - Lower boundary for values represented by the slider position (number)
	-- @param maxValue - Upper boundary for values represented by the slider position (number)
	-- @usage ScrollBar:SetMinMaxValues(1, 100)
	------------------------------------
	function SetMinMaxValues(self, iMin, iMax)
		self:GetChild("Slider"):SetMinMaxValues(iMin, iMax)
		return UpdateButton(self)
	end

	------------------------------------
	--- Gets the minimum and maximum values for the slider
	-- @name ScrollBar:GetMinMaxValues
	-- @class function
	-- @return minValue - Lower boundary for values represented by the slider position (number)
	-- @return maxValue - Upper boundary for values represented by the slider position (number)
	-- @usage ScrollBar:GetMinMaxValues()
	------------------------------------
	function GetMinMaxValues(self)
		return self:GetChild("Slider"):GetMinMaxValues()
	end

	------------------------------------
	--- Sets the value representing the position of the slider thumb
	-- @name ScrollBar:SetValue
	-- @class function
	-- @param value Value representing the new position of the slider thumb (between minValue and maxValue, where minValue, maxValue = slider:GetMinMaxValues())
	-- @usage ScrollBar:SetValue(10)
	------------------------------------
	function SetValue(self, value)
		self:GetChild("Slider"):SetValue(value)
		return UpdateButton(self)
	end

	------------------------------------
	--- Sets the minimum increment between allowed slider values.
	-- @name ScrollBar:SetValueStep
	-- @class function
	-- @param step Minimum increment between allowed slider values
	-- @usage ScrollBar:SetValueStep(10)
	------------------------------------
	function SetValueStep(self, value)
		self:GetChild("Slider"):SetValueStep(value)
	end

	------------------------------------
	--- Disable the scrollbar
	-- @name ScrollBar:Disable
	-- @class function
	-- @usage ScrollBar:Disable()
	------------------------------------
	function Disable(self)
		self:GetChild("DownBtn"):Disable()
		self:GetChild("UpBtn"):Disable()
		self:GetChild("Slider"):GetThumbTexture():Hide()
	end

	------------------------------------
	--- Enable the scrollbar
	-- @name ScrollBar:Enable
	-- @class function
	-- @usage ScrollBar:Enable()
	------------------------------------
	function Enable(self)
		self:GetChild("Slider"):GetThumbTexture():Show()

		return UpdateButton(self)
	end

	------------------------------------
	--- Check if the scrollbar is enabled
	-- @name ScrollBar:IsEnabled
	-- @class function
	-- @return true if the scrollbar is enabled
	-- @usage ScrollBar:IsEnabled()
	------------------------------------
	function IsEnabled(self)
		return self:GetChild("Slider"):GetThumbTexture():IsShown()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Value
	property "Value" {
		Set = function(self, value)
			self:SetValue(value)
		end,

		Get = function(self)
			return self:GetValue()
		end,

		Type = Number,
	}
	-- ValueStep
	property "ValueStep" {
		Set = function(self, value)
			self:SetValueStep(value)
		end,

		Get = function(self)
			return self:GetValueStep()
		end,

		Type = Number,
	}
	-- Enabled
	property "Enabled" {
		Set = function(self, flag)
			if flag then
				self:Enable()
			else
				self:Disable()
			end
		end,

		Get = function(self)
			return (self:IsEnabled() and true) or false
		end,

		Type = Boolean,
	}
	-- Style
	property "Style" {
		Set = function(self, style)
			self:SetStyle(style)
		end,

		Get = function(self)
			return self:GetStyle()
		end,

		Type = ScrollBarStyle,
	}
	-- MinMaxValue
	property "MinMaxValue" {
		Get = function(self)
			return MinMax(self:GetMinMaxValues())
		end,
		Set = function(self, value)
			return self:SetMinMaxValues(value.min, value.max)
		end,
		Type = MinMax,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
   function ScrollBar(name, parent)
        -- ScrollBar
		local scrollBar = Frame(name,parent)

        scrollBar:SetWidth(18)
        scrollBar:ClearAllPoints()
        scrollBar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -8, -8)
        scrollBar:SetPoint("BOTTOM", parent, "BOTTOM", 0, 8)

        local slider = Slider("Slider", scrollBar)
        slider:ClearAllPoints()
        slider:SetPoint("LEFT", scrollBar, "LEFT", 0, 0)
        slider:SetPoint("RIGHT", scrollBar, "RIGHT", 0, 0)
        slider:SetPoint("TOP", scrollBar, "TOP", 0, -24)
        slider:SetPoint("BOTTOM", scrollBar, "BOTTOM", 0, 24)
        slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob.blp")
        slider.MouseWheelEnabled = true
		slider.OnEnter = OnEnter
		slider.OnLeave = OnLeave

        local texture = slider:GetThumbTexture()
        texture:SetTexCoord(7/32, 25/32, 7/32, 24/32)
        texture:SetWidth(18)
        texture:SetHeight(17)
        slider:SetMinMaxValues(1, 10)
        slider:SetValueStep(1)
        slider:SetValue(1)

        local btnScrollUp = Button("UpBtn", scrollBar)
        btnScrollUp:SetWidth(32)
        btnScrollUp:SetHeight(32)
        btnScrollUp:ClearAllPoints()
        btnScrollUp:SetPoint("TOP", scrollBar, "TOP", 0, 4)
        btnScrollUp:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up.blp")
        btnScrollUp:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down.blp")
        btnScrollUp:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled.blp")
        btnScrollUp:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight.blp", "ADD")
        btnScrollUp:SetHitRectInsets(6, 7, 7, 8)
		btnScrollUp.OnEnter = OnEnter
		btnScrollUp.OnLeave = OnLeave

        local btnScrollDown = Button("DownBtn", scrollBar)
        btnScrollDown:SetWidth(32)
        btnScrollDown:SetHeight(32)
        btnScrollDown:ClearAllPoints()
        btnScrollDown:SetPoint("BOTTOM", scrollBar, "BOTTOM", 0, -4)
        btnScrollDown:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up.blp")
        btnScrollDown:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down.blp")
        btnScrollDown:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled.blp")
        btnScrollDown:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight.blp", "ADD")
        btnScrollDown:SetHitRectInsets(6, 7, 7, 8)
		btnScrollDown.OnEnter = OnEnter
		btnScrollDown.OnLeave = OnLeave

        -- Event Handle
        btnScrollUp.OnClick = clickUpBtn
        btnScrollDown.OnClick = clickDownBtn
        slider.OnValueChanged = scrollChg
        slider.OnMouseWheel = OnMouseWheel

        -- Can be override, Special use.
		scrollBar = ScrollBar(scrollBar)
        scrollBar.OnValueChanged = OnValueChanged

        btnScrollUp:Disable()
        btnScrollDown:Disable()

        return scrollBar
    end
endclass "ScrollBar"