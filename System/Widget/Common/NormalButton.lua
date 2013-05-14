-- Author      : Kurapica
-- Create Date : 2010.10.18
-- Change Log  :
--				2011/03/13 Recode as class
--              2013/05/10 AutoSize property added

-- Check Version
local version = 4
if not IGAS:NewAddon("IGAS.Widget.NormalButton", version) then
	return
end

class "NormalButton"
	inherit "Button"

	doc [======[
		@name NormalButton
		@type class
		@desc NormalButton is inherited from Button with custom style to help author creating useful buttons
	]======]

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
	doc [======[
		@name SetStyle
		@type method
		@desc Set the Button's style
		@param style System.Widget.NormalButton.NormalButtonStyle, the button's style
		@return nil
	]======]
	function SetStyle(self, style)
		return SetButtonStyle(self, style)
	end

	doc [======[
		@name GetStyle
		@type method
		@desc Get the button's style
		@return System.Widget.NormalButton.NormalButtonStyle
	]======]
	function GetStyle(self)
		return self.__Style or TEMPLATE_NONE
	end

	doc [======[
		@name SetText
		@type method
		@desc Sets the text displayed as the button's label
		@param text string, text to be displayed as the button's label
		@return nil
	]======]
	function SetText(self, text)
		text = text or ""

		Super.SetText(self, text)

		if self.AutoSize then
			-- adjust width
			local width = self:GetTextWidth()
			if ( width > 30 ) then
				self:SetWidth(width + 10)
			else
				self:SetWidth(40)
			end

			-- adjust height
			local height = self:GetNormalFontObject() and self:GetNormalFontObject().Font.height
			if self.Height <= height + 4 then
				self.Height = height + 4
			end
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Style
		@type property
		@desc The button's style
	]======]
	property "Style" {
		Get = function(self)
			return self:GetStyle()
		end,
		Set = function(self, style)
			self:SetStyle(style)
		end,
		Type = NormalButtonStyle,
	}

	doc [======[
		@name AutoSize
		@type property
		@desc Whether should auto change the button's size when text is changed
	]======]
	property "AutoSize" {
		Get = function(self)
			return self.__AutoSize
		end,
		Set = function(self, value)
			self.__AutoSize = value

			if value then
				-- adjust width
				local width = self:GetTextWidth()
				if ( width > 30 ) then
					self:SetWidth(width + 10)
				else
					self:SetWidth(40)
				end

				-- adjust height
				local height = self:GetNormalFontObject() and self:GetNormalFontObject().Font.height
				if self.Height <= height + 4 then
					self.Height = height + 4
				end
			end
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function NormalButton(self)
		self.__Style = TEMPLATE_NONE
	end
endclass "NormalButton"