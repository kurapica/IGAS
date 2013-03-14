-- Author		: Kurapica
-- Create Date	: 8/04/2008 00:06
-- ChangeLog	:
--				2010/05/31 Fix OnEnter and OnLeave Script
--				2011/03/13	Recode as class

-- Check Version
local version = 9
if not IGAS:NewAddon("IGAS.Widget.ScrollBar", version) then
	return
end

class "ScrollBar"
	inherit "Frame"

	doc [======[
		@name ScrollBar
		@type class
		@desc ScrollBar is used as scroll controller for scrollForm and others
	]======]

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

		slider:SetValue(slider:GetValue() - slider:GetValueStep())
        PlaySound("UChatScrollButton")
    end

    local function clickDownBtn(self)
        local slider = self:GetParent():GetChild("Slider")

        slider:SetValue(slider:GetValue() + slider:GetValueStep())
        PlaySound("UChatScrollButton")
    end

    local function OnMouseWheel(self, value)
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

        if (self:GetChild("Slider"):GetValue() - iMin) <= 0.005 then
            self:GetChild("UpBtn"):Disable()
        else
            self:GetChild("UpBtn"):Enable()
        end

        if (iMax - self:GetChild("Slider"):GetValue()) <= 0.005  then
            self:GetChild("DownBtn"):Disable()
        else
            self:GetChild("DownBtn"):Enable()
        end

        if not self:GetChild("UpBtn").Enabled and not self:GetChild("DownBtn").Enabled then
        	self.Alpha = 0
        else
        	self.Alpha = 1
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
	doc [======[
		@name OnValueChanged
		@type script
		@desc Run when the ScrollBar's or status bar's value changes
		@param value number, new value of the ScrollBar
	]======]
	script "OnValueChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name SetStyle
		@type method
		@desc Sets the scrollbar's style
		@param style System.Widget.ScrollBar.ScrollBarStyle
		@return nil
	]======]
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

	doc [======[
		@name GetStyle
		@type method
		@desc Gets the scrollbar's style
		@return System.Widget.ScrollBar.ScrollBarStyle
	]======]
	function GetStyle(self)
		return self.__Style or TEMPLATE_LIGHT
	end

	doc [======[
		@name GetMinMaxValues
		@type method
		@desc Get the current bounds of the slider
		@return min number, the lower boundary of the slider
		@return max number, the upper boundary of the silder
	]======]
	function GetMinMaxValues(self)
		return self:GetChild("Slider"):GetMinMaxValues()
	end

	doc [======[
		@name GetValue
		@type method
		@desc  Get the current value of the slider
		@return number the value of the scrollbar
	]======]
	function GetValue(self)
		return self:GetChild("Slider"):GetValue()
	end

	doc [======[
		@name GetValueStep
		@type method
		@desc Get the current step size of the slider
		@return number the current step size of the slider
	]======]
	function GetValueStep(self)
		return self:GetChild("Slider"):GetValueStep()
	end

	doc [======[
		@name SetMinMaxValues
		@type method
		@desc Sets the minimum and maximum values for the slider
		@param minValue number, lower boundary for values represented by the slider position
		@param maxValue number, upper boundary for values represented by the slider position
		@return nil
	]======]
	function SetMinMaxValues(self, iMin, iMax)
		self:GetChild("Slider"):SetMinMaxValues(iMin, iMax)
		return UpdateButton(self)
	end

	doc [======[
		@name SetValue
		@type method
		@desc Sets the value representing the position of the slider thumb
		@param value number, the value representing the new position of the slider thumb
		@return nil
	]======]
	function SetValue(self, value)
		self:GetChild("Slider"):SetValue(value)
		return UpdateButton(self)
	end

	doc [======[
		@name SetValueStep
		@type method
		@desc Sets the minimum increment between allowed slider values
		@param value number, Minimum increment between allowed slider values
		@return nil
	]======]
	function SetValueStep(self, value)
		self:GetChild("Slider"):SetValueStep(value)
	end

	doc [======[
		@name Disable
		@type method
		@desc Disable the scrollbar
		@return nil
	]======]
	function Disable(self)
		self:GetChild("DownBtn"):Disable()
		self:GetChild("UpBtn"):Disable()
		self:GetChild("Slider"):GetThumbTexture():Hide()
	end

	doc [======[
		@name Enable
		@type method
		@desc Enable the scrollbar
		@return nil
	]======]
	function Enable(self)
		self:GetChild("Slider"):GetThumbTexture():Show()

		return UpdateButton(self)
	end

	doc [======[
		@name IsEnabled
		@type method
		@desc Whether if the scrollbar is enabled
		@return boolean true if the scrollbar is enabled
	]======]
	function IsEnabled(self)
		return self:GetChild("Slider"):GetThumbTexture():IsShown()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Value
		@type property
		@desc the value representing the current position of the slider thumb
	]======]
	property "Value" {
		Set = function(self, value)
			self:SetValue(value)
		end,

		Get = function(self)
			return self:GetValue()
		end,

		Type = Number,
	}

	doc [======[
		@name ValueStep
		@type property
		@desc the minimum increment between allowed slider values
	]======]
	property "ValueStep" {
		Set = function(self, value)
			self:SetValueStep(value)
		end,

		Get = function(self)
			return self:GetValueStep()
		end,

		Type = Number,
	}

	doc [======[
		@name Enabled
		@type property
		@desc whether user interaction with the slider is allowed
	]======]
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

	doc [======[
		@name Style
		@type property
		@desc the scrollbar's style
	]======]
	property "Style" {
		Set = function(self, style)
			self:SetStyle(style)
		end,

		Get = function(self)
			return self:GetStyle()
		end,

		Type = ScrollBarStyle,
	}

	doc [======[
		@name MinMaxValue
		@type property
		@desc the min &amp; max boundary of the scrollbar's values
	]======]
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
   function ScrollBar(self, name, parent)
        self:SetWidth(18)
        self:ClearAllPoints()
        self:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -8, -8)
        self:SetPoint("BOTTOM", parent, "BOTTOM", 0, 8)

        local slider = Slider("Slider", self)
        slider:ClearAllPoints()
        slider:SetPoint("LEFT", self, "LEFT", 0, 0)
        slider:SetPoint("RIGHT", self, "RIGHT", 0, 0)
        slider:SetPoint("TOP", self, "TOP", 0, -24)
        slider:SetPoint("BOTTOM", self, "BOTTOM", 0, 24)
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

        local btnScrollUp = Button("UpBtn", self)
        btnScrollUp:SetWidth(32)
        btnScrollUp:SetHeight(32)
        btnScrollUp:ClearAllPoints()
        btnScrollUp:SetPoint("TOP", self, "TOP", 0, 4)
        btnScrollUp:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up.blp")
        btnScrollUp:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down.blp")
        btnScrollUp:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled.blp")
        btnScrollUp:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight.blp", "ADD")
        btnScrollUp:SetHitRectInsets(6, 7, 7, 8)
		btnScrollUp.OnEnter = OnEnter
		btnScrollUp.OnLeave = OnLeave

        local btnScrollDown = Button("DownBtn", self)
        btnScrollDown:SetWidth(32)
        btnScrollDown:SetHeight(32)
        btnScrollDown:ClearAllPoints()
        btnScrollDown:SetPoint("BOTTOM", self, "BOTTOM", 0, -4)
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

        -- Default handler, can be overridden
        self.OnValueChanged = OnValueChanged

        btnScrollUp:Disable()
        btnScrollDown:Disable()
    end
endclass "ScrollBar"