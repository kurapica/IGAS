-- Author      : Kurapica
-- ChangreLog  :
--				2011/03/13	Recode as class

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- ColorPicker is using to pick color for special using.
-- <br><br>inherit <a href="..\Base\ColorSelect.html">ColorSelect</a> For all methods, properties and scriptTypes
-- @name ColorPicker
-- @class table
-- @field CaptionAlign the caption's align:LEFT, RIGHT, CENTER
-- @field TitleBarColor the title bar's color, default a is 0, so make it can't be see
-- @field Caption The text to be displayed at the top of the ColorPicker.
-- @field Color The color that the colorPicker is picked or to be displayed
-- @field OkayButtonText the text that displayed on the okay button
-- @field CancelButtonText the text that displayed on the cancel button
-- @field Style the colorPicker's style: CLASSIC, LIGHT
-- @field HasOpacity Whether the opacity should be used
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.ColorPicker", version) then
	return
end

class "ColorPicker"
	inherit "ColorSelect"

	-- Define Style
    -- Style
    TEMPLATE_CLASSIC = "CLASSIC"
    TEMPLATE_LIGHT = "LIGHT"

    -- Define Block
	enum "ColorPickerStyle" {
        TEMPLATE_CLASSIC,
		TEMPLATE_LIGHT,
    }

	-- Backdrop Handlers
	_FrameBackdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 9,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}
	_FrameBackdropTitle = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "",
		tile = true, tileSize = 16, edgeSize = 0,
		insets = { left = 3, right = 3, top = 3, bottom = 0 }
	}
	_FrameBackdropCommon = {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 }
	}
	_FrameBackdropSlider = {
		bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
		edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
		tile = true, tileSize = 8, edgeSize = 8,
		insets = { left = 3, right = 3, top = 6, bottom = 6 }
	}

	-- Event Handlers
	local function frameOnMouseDown(self)
		if not self.Parent.InDesignMode then
			self.Parent:StartMoving()
		end
	end

	local function frameOnMouseUp(self)
		self.Parent:StopMovingOrSizing()
	end

	local function Format(value)
		return tonumber(format("%.2f", value))
	end

	local function Slider_OnValueChanged(self)
		self.Text.Text = format("%.2f", 1 - self.Value)
		if self.Visible and self.Enabled then
			return self.Parent:Fire("OnColorPicked", self.Parent:GetColor())
		end
	end

	local function OnColorSelect(self)
		self.ColorSwatch:SetTexture(self:GetColorRGB())
		return self:Fire("OnColorPicked", self:GetColor())
	end

	local function Okay_OnClick(self)
		local parent = self.Parent
		parent:Fire("OnColorPicked", parent:GetColor())
		parent.Visible = false
	end

	local function Cancel_OnClick(self)
		local parent = self.Parent
		parent:Fire("OnColorPicked", parent.__DefaultValue.r, parent.__DefaultValue.g, parent.__DefaultValue.b, parent.__DefaultValue.a)
		parent.Visible = false
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the color is selected
	-- @name ColorPicker:OnColorPicked
	-- @class function
	-- @usage function ColorPicker:OnColorPicked(r, g, b, a)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnColorPicked"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Sets the ColorPicker's style
	-- @name ColorPicker:SetStyle
	-- @class function
	-- @param style the style of the ColorPicker : CLASSIC, LIGHT
	-- @usage ColorPicker:SetStyle("LIGHT")
	------------------------------------
	function SetStyle(self, style)
		local t

		-- Check Style
		if not style or type(style) ~= "string" or style == self.__Style then
			return
		end

		-- Change Style
		if style == TEMPLATE_CLASSIC then
			self:SetBackdrop(_FrameBackdropCommon)

			self.ColorPicker_Caption:SetBackdrop(nil)
			self.ColorPicker_Caption:ClearAllPoints()
			self.ColorPicker_Caption:SetPoint("TOP", self, "TOP", 0, 12)
			self.ColorPicker_Caption.Width = 136
			self.ColorPicker_Caption.Height = 36
			self.ColorPicker_Caption.Text.JustifyV = "MIDDLE"
			self.ColorPicker_Caption.Text.JustifyH = "CENTER"

			local backTexture = Texture("HeaderBack", self.ColorPicker_Caption, "BACKGROUND")

			backTexture.TexturePath = [[Interface\DialogFrame\UI-DialogBox-Header]]
			backTexture:SetAllPoints(self.ColorPicker_Caption)
			backTexture:SetTexCoord(0.24, 0.76, 0, 0.56)
			backTexture.Visible = true

			if self:GetChild("ColorPicker_Caption"):GetChild("Text").Width + 36 > 136 then
				self:GetChild("ColorPicker_Caption").Width = self:GetChild("ColorPicker_Caption"):GetChild("Text").Width + 36
			else
				self:GetChild("ColorPicker_Caption").Width = 136
			end
		elseif style == TEMPLATE_LIGHT then
			self:SetBackdrop(_FrameBackdrop)
			self:SetBackdropColor(0, 0, 0)
			self:SetBackdropBorderColor(0.4, 0.4, 0.4)

			local title = Frame("ColorPicker_Caption", self)
			title:ClearAllPoints()
			title:SetPoint("TOPLEFT", self, "TOPLEFT", 6, 0)
			title:SetPoint("RIGHT", self, "RIGHT")
			title:SetBackdrop(_FrameBackdropTitle)
			title:SetBackdropColor(1, 0, 0, 0)
			title.Height = 24

			if title.HeaderBack then
				title.HeaderBack.Visible = false
			end
		end

		self.__Style = style
	end

	------------------------------------
	--- Gets the ColorPicker's style
	-- @name ColorPicker:GetStyle
	-- @class function
	-- @return the style of the ColorPicker : CLASSIC, LIGHT
	-- @usage ColorPicker:GetStyle()
	------------------------------------
	function GetStyle(self)
		return self.__Style or TEMPLATE_LIGHT
	end

	------------------------------------
	--- Sets the ColorPicker's default color
	-- @name ColorPicker:SetColor
	-- @class function
	-- @param r component of the color (0.0 - 1.0)
	-- @param g component of the color (0.0 - 1.0)
	-- @param b component of the color (0.0 - 1.0)
	-- @param a Optional,opacity for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	-- @usage ColorPicker:SetColor(1, 0.7, 0, 0.6)
	------------------------------------
	function SetColor(self, r, g, b, a)
		a = (a and type(a) == "number" and a >= 0 and a <= 1 and a) or 1

		self.OpacitySlider.Value = 1 - a

		self:SetColorRGB(r, g, b)

		r, g, b = self:GetColorRGB()

		a = 1 - self.OpacitySlider.Value

		-- Keep default
		self.__DefaultValue.r, self.__DefaultValue.g, self.__DefaultValue.b, self.__DefaultValue.a = Format(r), Format(g), Format(b), Format(a)
	end

	------------------------------------
	--- Gets the ColorPicker's default color
	-- @name ColorPicker:GetColor
	-- @class function
	-- @return r component of the color (0.0 - 1.0)
	-- @return g component of the color (0.0 - 1.0)
	-- @return b component of the color (0.0 - 1.0)
	-- @return a Optional,opacity for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	-- @usage ColorPicker:GetColor()
	------------------------------------
	function GetColor(self)
		local r, g, b = self:GetColorRGB()

		if self.OpacitySlider.Visible and self.OpacitySlider.Enabled then
			return Format(r), Format(g), Format(b), Format(1 - self.OpacitySlider.Value)
		else
			return Format(r), Format(g), Format(b)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Color
	property "Color" {
		Set = function(self, color)
			self:SetColor(color.r, color.g, color.b, color.a)
		end,
		Get = function(self)
			return ColorType(self:GetColor())
		end,
		Type = ColorType,
	}
	-- Style
	property "Style" {
		Set = function(self, style)
			self:SetStyle(style)
		end,
		Get = function(self)
			return self:GetStyle()
		end,
		Type = ColorPickerStyle,
	}
	-- CaptionAlign
	property "CaptionAlign" {
		Get = function(self)
			return self:GetChild("ColorPicker_Caption"):GetChild("Text").JustifyH
		end,
		Set = function(self, value)
			if self.Style ~= TEMPLATE_CLASSIC then
				self:GetChild("ColorPicker_Caption"):GetChild("Text").JustifyH = value
			end
		end,
		Type = JustifyHType,
	}
	-- TitleBarColor
	property "TitleBarColor" {
		Get = function(self)
			return self:GetChild("ColorPicker_Caption").BackdropColor
		end,
		Set = function(self, value)
			self:GetChild("ColorPicker_Caption").BackdropColor = value
		end,
		Type = ColorType,
	}
	-- Caption
	property "Caption" {
		Set = function(self, title)
			self:GetChild("ColorPicker_Caption"):GetChild("Text").Text = title

			if self.Style == TEMPLATE_CLASSIC then
				if self:GetChild("ColorPicker_Caption"):GetChild("Text").Width + 36 > 136 then
					self:GetChild("ColorPicker_Caption").Width =  self:GetChild("ColorPicker_Caption"):GetChild("Text").Width + 36
				else
					self:GetChild("ColorPicker_Caption").Width = 136
				end
			end
		end,
		Get = function(self)
			return self:GetChild("ColorPicker_Caption"):GetChild("Text").Text
		end,
		Type = LocaleString,
	}
	-- OkayText
	property "OkayButtonText" {
		Set = function(self, text)
			self:GetChild("OkayBtn").Text = text or "Okay"
		end,
		Get = function(self)
			return self:GetChild("OkayBtn").Text
		end,
		Type = LocaleString,
	}
	-- CancelText
	property "CancelButtonText" {
		Set = function(self, text)
			self:GetChild("CancelBtn").Text = text or "Cancel"
		end,
		Get = function(self)
			return self:GetChild("CancelBtn").Text
		end,
		Type = LocaleString,
	}
	-- HasOpacity
	property "HasOpacity" {
		Set = function(self, flag)
			self:GetChild("OpacitySlider").Enabled = flag
		end,
		Get = function(self)
			return self:GetChild("OpacitySlider").Enabled
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ColorPicker(self, name, parent)
		self.Width = 360
		self.Height = 220
		self.Movable = true
		self.Resizable = true
		self.FrameStrata = "FULLSCREEN_DIALOG"
		self.Toplevel = true
		self.MouseEnabled = true
		self.KeyboardEnabled = true

		self:SetPoint("CENTER",parent,"CENTER",0,0)
		self:SetMinResize(300,200)
        self:SetBackdrop(_FrameBackdrop)
		self:SetBackdropColor(0, 0, 0)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4)

		self.__DefaultValue = {}

		self.OnColorSelect = self.OnColorSelect + OnColorSelect

		-- Caption
		local title = Frame("ColorPicker_Caption", self)
		title.MouseEnabled = true
		title.Height = 24
		title:SetPoint("TOPLEFT", self, "TOPLEFT", 6, 0)
		title:SetPoint("RIGHT", self, "RIGHT")
		title:SetBackdrop(_FrameBackdropTitle)
		title:SetBackdropColor(1, 0, 0, 0)
		title.OnMouseDown = frameOnMouseDown
		title.OnMouseUp = frameOnMouseUp

		local titleText = FontString("Text", title, "OVERLAY", "GameFontNormal")
		titleText:SetPoint("LEFT", title, "LEFT")
		titleText:SetPoint("RIGHT", title, "RIGHT")
		titleText:SetPoint("CENTER", title, "CENTER")
		titleText.Height = 24
		titleText.Text = "ColorPicker"
		titleText.JustifyV = "MIDDLE"
		titleText.JustifyH = "CENTER"

		-- ColorWheelTexture
		local colorWheel = Texture("ColorWheel", self)
		colorWheel.Width = 128
		colorWheel.Height = 128
		colorWheel:SetPoint("TOPLEFT", self, "TOPLEFT", 32, -32)
		self:SetColorWheelTexture(colorWheel)

		-- ColorWheelThumbTexture
		local colorWheelThumb = Texture("ColorWheelThumb", self)
		colorWheelThumb.Width = 10
		colorWheelThumb.Height = 10
		colorWheelThumb.TexturePath = [[Interface\Buttons\UI-ColorPicker-Buttons]]
		colorWheelThumb:SetTexCoord(0, 0.15625, 0, 0.625)
		self:SetColorWheelThumbTexture(colorWheelThumb)

		-- ColorValueTexture
		local colorValue = Texture("ColorValue", self)
		colorValue.Width = 32
		colorValue.Height = 128
		colorValue:SetPoint("TOPLEFT", colorWheel, "TOPRIGHT", 24, 0)
		self:SetColorValueTexture(colorValue)

		-- ColorValueThumbTexture
		local colorValueThumb = Texture("ColorValueThumb", self)
		colorValueThumb.Width = 48
		colorValueThumb.Height = 14
		colorValueThumb.TexturePath = [[Interface\Buttons\UI-ColorPicker-Buttons]]
		colorValueThumb:SetTexCoord(0.25, 1.0, 0, 0.875)
		self:SetColorValueThumbTexture(colorValueThumb)

		-- ColorSwatch
		local watch = Texture("ColorSwatch", self, "ARTWORK")
		watch.Width = 32
		watch.Height = 32
		watch:SetPoint("TOPLEFT", colorValue, "TOPRIGHT", 24, 0)
		watch:SetTexture(1, 1, 1, 1)

		-- OpacitySlider
		local sliderOpacity = Slider("OpacitySlider", self)
		sliderOpacity:SetMinMaxValues(0, 1)
		sliderOpacity:SetPoint("TOPLEFT", watch, "TOPRIGHT", 24, 0)
		sliderOpacity.Orientation = "VERTICAL"
		sliderOpacity.ValueStep = 0.01
		sliderOpacity.Value = 0
		sliderOpacity.Width = 16
		sliderOpacity.Height = 128
		sliderOpacity:SetBackdrop(_FrameBackdropSlider)
		sliderOpacity:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Vertical")

		local thumb = sliderOpacity:GetThumbTexture()
		thumb.Height = 32
		thumb.Width = 32

		local sliderText = FontString("Text", sliderOpacity, "ARTWORK", "GameFontNormalSmall")
		sliderText:SetPoint("BOTTOM", sliderOpacity, "TOP")
		sliderText.Text = "1.00"

		local subText = FontString("SubText", sliderOpacity, "ARTWORK", "GameFontNormalHuge")
		subText.Text = "-"
		subText:SetPoint("BOTTOMLEFT", sliderOpacity, "BOTTOMRIGHT", 8, 3)
		subText:SetTextColor(1, 1, 1)

		local addText = FontString("AddText", sliderOpacity, "ARTWORK", "GameFontNormalHuge")
		addText.Text = "+"
		addText:SetPoint("TOPLEFT", sliderOpacity, "TOPRIGHT", 6, -3)
		addText:SetTextColor(1, 1, 1)

		sliderOpacity.OnValueChanged = Slider_OnValueChanged

		-- Okay Button
		local btnOkay = NormalButton("OkayBtn", self)
		btnOkay.Style = "CLASSIC"
		btnOkay.Height = 24
		btnOkay.Text = "Okay"
		btnOkay:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 6, 12)
		btnOkay:SetPoint("RIGHT", self, "CENTER")
		btnOkay.OnClick = Okay_OnClick

		-- Cancel Button
		local btnCancel = NormalButton("CancelBtn", self)
		btnCancel.Style = "CLASSIC"
		btnCancel.Height = 24
		btnCancel.Text = "Cancel"
		btnCancel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -6, 12)
		btnCancel:SetPoint("LEFT", self, "CENTER")
		btnCancel.OnClick = Cancel_OnClick
	end
endclass "ColorPicker"
