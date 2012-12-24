-- Author      : Kurapica
-- Create Date : 2010.10.18
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- NormalButton is inherited from Button with custom style to help author creating useful buttons.
-- <br><br>inherit <a href="..\Base\Button.html">Button</a> For all methods, properties and scriptTypes
-- @name NormalButton
-- @class table
-- @field Style the style of the button:NONE, CLASSIC, GRAY, CLOSE, PLUS, MINUS
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 3
if not IGAS:NewAddon("IGAS.Widget.NormalButton", version) then
	return
end

class "NormalButton"
	inherit "Button"

    -- Button Template
    TEMPLATE_NONE = "NONE"
    TEMPLATE_CLASSIC = "CLASSIC"
    TEMPLATE_GRAY = "GRAY"
    TEMPLATE_CLOSEBTN = "CLOSE"
	TEMPLATE_ADD = "PLUS"
	TEMPLATE_MINUS = "MINUS"

    -- Define Block
	enum "NormalButtonStyle" {
        TEMPLATE_NONE,
        TEMPLATE_CLASSIC,
        TEMPLATE_GRAY,
        TEMPLATE_CLOSEBTN,
		TEMPLATE_ADD,
		TEMPLATE_MINUS,
    }

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
    local function OnClick_Close(self)
		if not self.Parent.InDesignMode then
			self.Parent.Visible = false
		end
    end

	local function SetButtonStyle(self, style)
		local t

		-- Check Style
		if (not NormalButtonStyle[style]) or style == self.__Style then
			return
		end

		self.__Style = style

		-- Change Style
		self.OnClick = nil

		if style == TEMPLATE_NONE then
			--- Texture
			self:SetNormalTexture(nil)
			self:SetPushedTexture(nil)
			self:SetDisabledTexture(nil)
			self:SetHighlightTexture(nil)
		elseif style == TEMPLATE_CLASSIC then
			--- Font
			self:SetNormalFontObject(GameFontNormal)
			self:SetDisabledFontObject(GameFontDisable)
			self:SetHighlightFontObject(GameFontHighlight)

			--- Texture
			self:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
			t = self:GetNormalTexture()
			t:SetTexCoord(0,0.625,0,0.6875)

			self:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
			t = self:GetPushedTexture()
			t:SetTexCoord(0,0.625,0,0.6875)

			self:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
			t = self:GetDisabledTexture()
			t:SetTexCoord(0,0.625,0,0.6875)

			self:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
			t = self:GetHighlightTexture()
			t:SetTexCoord(0,0.625,0,0.6875)
		elseif style == TEMPLATE_GRAY then
			--- Font
			self:SetNormalFontObject(GameFontHighlight)
			self:SetDisabledFontObject(GameFontDisable)
			self:SetHighlightFontObject(GameFontHighlight)

			--- Texture
			self:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
			t = self:GetNormalTexture()
			t:SetTexCoord(0,0.625,0,0.6875)

			self:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Disabled-Down")
			t = self:GetPushedTexture()
			t:SetTexCoord(0,0.625,0,0.6875)

			self:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
			t = self:GetDisabledTexture()
			t:SetTexCoord(0,0.625,0,0.6875)

			self:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
			t = self:GetHighlightTexture()
			t:SetTexCoord(0,0.625,0,0.6875)
		elseif style == TEMPLATE_CLOSEBTN then
			--- Texture
			self:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")

			self:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")

			self:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
			t = self:GetHighlightTexture()
			t:SetBlendMode("ADD")

			self.Width = 32
			self.Height = 32
			self.OnClick = OnClick_Close
		elseif style == TEMPLATE_ADD then
			self:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP")
			self:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN")
			self:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
			t = self:GetHighlightTexture()
			t:SetBlendMode("ADD")
			self.Width = 24
			self.Height = 24
		elseif style == TEMPLATE_MINUS then
			self:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP")
			self:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN")
			self:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
			t = self:GetHighlightTexture()
			t:SetBlendMode("ADD")
			self.Width = 24
			self.Height = 24
		end
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Set the Button's Style
	-- @name Button:SetStyle
	-- @class function
	-- @param style the button's style, NONE, CLASSIC, GRAY, CLOSE, PLUS, MINUS
	-- @usage Button:SetStyle("CLASSIC")
	------------------------------------
	function SetStyle(self, style)
		return SetButtonStyle(self, style)
	end

	------------------------------------
	--- Get the Button's Style
	-- @name Button:GetStyle
	-- @class function
	-- @return the button's style, NONE, NORMAL, GRAY, CLOSE, PLUS, MINUS
	-- @usage Button:GetStyle()
	------------------------------------
	function GetStyle(self)
		return self.__Style or TEMPLATE_NONE
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Style
	property "Style" {
		Get = function(self)
			return self:GetStyle()
		end,
		Set = function(self, style)
			self:SetStyle(style)
		end,
		Type = NormalButtonStyle,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function NormalButton(self)
		self.__Style = TEMPLATE_NONE
	end
endclass "NormalButton"