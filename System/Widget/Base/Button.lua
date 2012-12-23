-- Author      : Kurapica
-- Create Date : 7/12/2008 14:38
-- Change Log  :
--				2010.10.18	Remove Style properties, since button is a base widget, should not have style.
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Button is the primary means for users to control the game and their characters.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name Button
-- @class table
-- @field Enabled true if the button is enabled
-- @field ButtonState the button's current state: DISABLED, NORMAL, PUSHED
-- @field Locked true if the button is locked
-- @field HighlightLocked true if the button's highlight state is locked
-- @field DisabledTexture the texture used when the button is disabled
-- @field DisabledTexturePath the texture file used when the button is disabled
-- @field HighlightTexture the texture used when the button is highlighted
-- @field HighlightTexturePath the texture file used when the button is highlighted
-- @field NormalTexture the texture used for the button's normal state
-- @field NormalTexturePath the texture file used for the button's normal state
-- @field PushedTexture the texture used when the button is pushed
-- @field PushedTexturePath the texture file used when the button is pushed
-- @field FontString the `FontString` object used for the button's label text
-- @field DisabledFontObject the font object used for the button's disabled state
-- @field HighlightFontObject the font object used when the button is highlighted
-- @field NormalFontObject the font object used for the button's normal state
-- @field PushedTextOffset the offset for moving the button's label text when pushed
-- @field Text the text displayed as the button's label
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.Button", version) then
	return
end

class "Button"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the button is clicked
	-- @name Button:OnClick
	-- @class function
	-- @param button Name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	-- @param down True for a mouse button down action; false for button up or other actions
	-- @usage function Button:OnClick(button, down)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnClick"

	------------------------------------
	--- ScriptType, Run when the button is double-clicked
	-- @name Button:OnDoubleClick
	-- @class function
	-- @param button Name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	-- @usage function Button:OnDoubleClick(button)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnDoubleClick"

	------------------------------------
	--- ScriptType, Run immediately following the button's `OnClick` handler with the same arguments
	-- @name Button:PostClick
	-- @class function
	-- @param button Name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	-- @param down True for a mouse button down action; false for button up or other actions
	-- @usage function Button:PostClick(button, down)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "PostClick"

	------------------------------------
	--- ScriptType, Run immediately before the button's `OnClick` handler with the same arguments
	-- @name Button:PreClick
	-- @class function
	-- @param button Name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	-- @param down True for a mouse button down action; false for button up or other actions
	-- @usage function Button:PreClick(button, down)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "PreClick"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Performs a (virtual) mouse click on the button. Causes any of the button's mouse click-related scripts to be run as if the button were clicked by the user.</p>
	--- <p>Calling this method can result in an error if the button inherits from a secure frame template and performs protected actions.
	-- @name Button:Click
	-- @class function
	------------------------------------
	-- Click

	------------------------------------
	--- Disallows user interaction with the button. Automatically changes the visual state of the button if its DisabledTexture, DisabledTextColor or DisabledFontObject are set.
	-- @name Button:Disable
	-- @class function
	------------------------------------
	-- Disable

	------------------------------------
	--- Allows user interaction with the button. If a disabled appearance was specified for the button, automatically returns the button to its normal appearance.
	-- @name Button:Enable
	-- @class function
	------------------------------------
	-- Enable

	------------------------------------
	--- Returns the button's current state
	-- @name Button:GetButtonState
	-- @class function
	-- @return state - State of the button (string) <ul><li>DISABLED - Button is disabled and cannot receive user input
	-- @return NORMAL - Button is in its normal state
	-- @return PUSHED - Button is pushed (as during a click on the button)
	------------------------------------
	-- GetButtonState

	------------------------------------
	--- Returns the font object used for the button's disabled state
	-- @name Button:GetDisabledFontObject
	-- @class function
	-- @return font - Reference to the Font object used when the button is disabled (font)
	------------------------------------
	function GetDisabledFontObject(self)
		return IGAS:GetWrapper(self.__UI:GetDisabledFontObject())
	end

	------------------------------------
	--- Returns the texture used when the button is disabled
	-- @name Button:GetDisabledTexture
	-- @class function
	-- @return texture - Reference to the Texture object used when the button is disabled (texture)
	------------------------------------
	function GetDisabledTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetDisabledTexture(...))
	end

	------------------------------------
	--- Returns the FontString object used for the button's label text
	-- @name Button:GetFontString
	-- @class function
	-- @return fontstring - Reference to the FontString object used for the button's label text (fontstring)
	------------------------------------
	function GetFontString(self, ...)
		return IGAS:GetWrapper(self.__UI:GetFontString(...))
	end

	------------------------------------
	--- Returns the font object used when the button is highlighted
	-- @name Button:GetHighlightFontObject
	-- @class function
	-- @return font - Reference to the Font object used when the button is highlighted (font)
	------------------------------------
	function GetHighlightFontObject(self)
		return IGAS:GetWrapper(self.__UI:GetHighlightFontObject())
	end

	------------------------------------
	--- Returns the texture used when the button is highlighted
	-- @name Button:GetHighlightTexture
	-- @class function
	-- @return texture - Reference to the Texture object used when the button is highlighted (texture)
	------------------------------------
	function GetHighlightTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetHighlightTexture(...))
	end

	------------------------------------
	--- Determines whether OnEnter/OnLeave scripts will fire while the button is disabled
	-- @name Button:GetMotionScriptsWhileDisabled
	-- @class function
	-- @return isEnabled - 1 if motion scripts run while hidden; otherwise nil (1nil)
	------------------------------------
	-- GetMotionScriptsWhileDisabled

	------------------------------------
	--- Returns the font object used for the button's normal state
	-- @name Button:GetNormalFontObject
	-- @class function
	-- @return font - Reference to the Font object used for the button's normal state (font)
	------------------------------------
	function GetNormalFontObject(self)
		return IGAS:GetWrapper(self.__UI:GetNormalFontObject())
	end

	------------------------------------
	--- Returns the texture used for the button's normal state
	-- @name Button:GetNormalTexture
	-- @class function
	-- @return texture - Reference to the Texture object used for the button's normal state (texture)
	------------------------------------
	function GetNormalTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetNormalTexture(...))
	end

	------------------------------------
	--- Returns the offset for moving the button's label text when pushed
	-- @name Button:GetPushedTextOffset
	-- @class function
	-- @return x - Horizontal offset for the text (in pixels; values increasing to the right) (number)
	-- @return y - Vertical offset for the text (in pixels; values increasing upward) (number)
	------------------------------------
	-- GetPushedTextOffset

	------------------------------------
	--- Returns the texture used when the button is pushed
	-- @name Button:GetPushedTexture
	-- @class function
	-- @return texture - Reference to the Texture object used when the button is pushed (texture)
	------------------------------------
	function GetPushedTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetPushedTexture(...))
	end

	------------------------------------
	--- Returns the text of the button's label
	-- @name Button:GetText
	-- @class function
	-- @return text - Text of the button's label (string)
	------------------------------------
	-- GetText

	------------------------------------
	--- Returns the height of the button's text label. Reflects the height of the rendered text (which increases if the text wraps onto two lines), not the point size of the text's font.
	-- @name Button:GetTextHeight
	-- @class function
	-- @return height - Height of the button's text (in pixels) (number)
	------------------------------------
	-- GetTextHeight

	------------------------------------
	--- Returns the width of the button's text label
	-- @name Button:GetTextWidth
	-- @class function
	-- @return width - Width of the button's text (in pixels) (number)
	------------------------------------
	-- GetTextWidth

	------------------------------------
	--- Returns whether user interaction with the button is allowed
	-- @name Button:IsEnabled
	-- @class function
	-- @return enabled - 1 if user interaction with the button is allowed; otherwise nil (1nil)
	------------------------------------
	-- IsEnabled

	------------------------------------
	--- Locks the button in its highlight state. When the highlight state is locked, the button will always appear highlighted regardless of whether it is moused over.
	-- @name Button:LockHighlight
	-- @class function
	------------------------------------
	-- LockHighlight

	------------------------------------
	--- Registers a button to receive mouse clicks
	-- @name Button:RegisterForClicks
	-- @class function
	-- @param ... A list of strings, each the combination of a button name and click action for which the button's click-related script handlers should be run. Possible values: (list) <ul><li>Button4Down
	-- @param AnyDown Responds to the down action of any mouse button
	-- @param AnyUp Responds to the up action of any mouse button
	------------------------------------
	-- RegisterForClicks

	------------------------------------
	--- Sets the button's state
	-- @name Button:SetButtonState
	-- @class function
	-- @param NORMAL Button is in its normal state
	-- @param PUSHED Button is pushed (as during a click on the button)
	------------------------------------
	function SetButtonState(self, state, locked)
		if locked ~= nil then
			self.__Locked = locked
		end

		self.__UI:SetButtonState(state, self.__Locked)
	end

	------------------------------------
	--- Sets the font object used for the button's disabled state
	-- @name Button:SetDisabledFontObject
	-- @class function
	-- @param font Reference to a Font object to be used when the button is disabled (font)
	------------------------------------
	-- SetDisabledFontObject

	------------------------------------
	--- Sets the texture used when the button is disabled
	-- @name Button:SetDisabledTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	------------------------------------
	-- SetDisabledTexture

	------------------------------------
	--- Sets the FontString object used for the button's label text
	-- @name Button:SetFontString
	-- @class function
	-- @param fontstring Reference to a FontString object to be used for the button's label text (fontstring)
	------------------------------------
	-- SetFontString

	------------------------------------
	--- Sets the button's label text using format specifiers. Equivalent to :SetText(format(format, ...)), but does not create a throwaway Lua string object, resulting in greater memory-usage efficiency.
	-- @name Button:SetFormattedText
	-- @class function
	-- @param formatString A string containing format specifiers (as with string.format()) (string)
	-- @param ... A list of values to be included in the formatted string (list)
	------------------------------------
	-- SetFormattedText

	------------------------------------
	--- Sets the font object used when the button is highlighted
	-- @name Button:SetHighlightFontObject
	-- @class function
	-- @param font Reference to a Font object to be used when the button is highlighted (font)
	------------------------------------
	-- SetHighlightFontObject

	------------------------------------
	--- Sets the texture used when the button is highlighted. Unlike the other button textures for which only one is visible at a time, the button's highlight texture is drawn on top of its existing (normal or pushed) texture; thus, this method also allows specification of the texture's blend mode.
	-- @name Button:SetHighlightTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	-- @param mode Blend mode for the texture; defaults to ADD if omitted (string) <ul><li>ADD - Adds texture color values to the underlying color values, using the alpha channel; light areas in the texture lighten the background while dark areas are more transparent
	-- @param ALPHAKEY One-bit transparency; pixels with alpha values greater than ~0.8 are treated as fully opaque and all other pixels are treated as fully transparent
	-- @param BLEND Normal color blending, using any alpha channel in the texture image
	-- @param DISABLE Ignores any alpha channel, displaying the texture as fully opaque
	-- @param MOD Ignores any alpha channel in the texture and multiplies texture color values by background color values; dark areas in the texture darken the background while light areas are more transparent
	------------------------------------
	-- SetHighlightTexture

	------------------------------------
	--- Sets whether the button should fire OnEnter/OnLeave events while disabled
	-- @name Button:SetMotionScriptsWhileDisabled
	-- @class function
	-- @param enabled True to enable the scripts while the button is disabled, false otherwise (boolean)
	------------------------------------
	-- SetMotionScriptsWhileDisabled

	------------------------------------
	--- Sets the font object used for the button's normal state
	-- @name Button:SetNormalFontObject
	-- @class function
	-- @param font Reference to a Font object to be used in the button's normal state (font)
	------------------------------------
	-- SetNormalFontObject

	------------------------------------
	--- Sets the texture used for the button's normal state
	-- @name Button:SetNormalTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	------------------------------------
	-- SetNormalTexture

	------------------------------------
	--- Sets the offset for moving the button's label text when pushed. Moving the button's text while it is being clicked can provide an illusion of 3D depth for the button -- in the default UI's standard button templates, this offset matches the apparent movement seen in the difference between the buttons' normal and pushed textures.
	-- @name Button:SetPushedTextOffset
	-- @class function
	-- @param x Horizontal offset for the text (in pixels; values increasing to the right) (number)
	-- @param y Vertical offset for the text (in pixels; values increasing upward) (number)
	------------------------------------
	-- SetPushedTextOffset

	------------------------------------
	--- Sets the texture used when the button is pushed
	-- @name Button:SetPushedTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	------------------------------------
	-- SetPushedTexture

	------------------------------------
	--- Sets the text displayed as the button's label
	-- @name Button:SetText
	-- @class function
	-- @param text Text to be displayed as the button's label (string)
	------------------------------------
	-- SetText

	------------------------------------
	--- Unlocks the button's highlight state. Can be used after a call to :LockHighlight() to restore the button's normal mouseover behavior.
	-- @name Button:UnlockHighlight
	-- @class function
	------------------------------------
	-- UnlockHighlight

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Enabled
	property "Enabled" {
		Get = function(self)
			return (self:IsEnabled() and true) or false
		end,
		Set = function(self, enabled)
			if enabled then
				self:Enable()
			else
				self:Disable()
			end
		end,
		Type = Boolean,
	}
	-- ButtonState
	property "ButtonState" {
		Get = function(self)
			return self:GetButtonState()
		end,
		Set = function(self, state)
			self:SetButtonState(state, self.__Locked)
		end,
		Type = ButtonStateType,
	}
	-- Locked
	property "Locked" {
		Get = function(self)
			return (self.__Locked and true) or false
		end,
		Set = function(self, enabled)
			self.__Locked = enabled
			self:SetButtonState(self.__UI:GetButtonState(), enabled)
		end,
		Type = Boolean,
	}
	-- DisabledFontObject
	property "DisabledFontObject" {
		Get = function(self)
			return self:GetDisabledFontObject()
		end,
		Set = function(self, font)
			self:SetDisabledFontObject(font)
		end,
		Type = Font + String + nil,
	}
	-- DisabledTexture
	property "DisabledTexture" {
		Get = function(self)
			return self:GetDisabledTexture()
		end,
		Set = function(self, texture)
			self:SetDisabledTexture(texture)
		end,
		Type = Texture + nil,
	}
	-- DisabledTexturePath
	property "DisabledTexturePath" {
		Get = function(self)
			return self:GetDisabledTexture() and self:GetDisabledTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetDisabledTexture(texture)
		end,
		Type = String + nil,
	}
	-- HighlightTexture
	property "HighlightTexture" {
		Get = function(self)
			return self:GetHighlightTexture()
		end,
		Set = function(self, texture)
			self:SetHighlightTexture(texture)
		end,
		Type = Texture + nil,
	}
	-- HighlightTexturePath
	property "HighlightTexturePath" {
		Get = function(self)
			return self:GetHighlightTexture() and self:GetHighlightTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetHighlightTexture(texture)
		end,
		Type = String + nil,
	}
	-- NormalTexture
	property "NormalTexture" {
		Get = function(self)
			return self:GetNormalTexture()
		end,
		Set = function(self, texture)
			self:SetNormalTexture(texture)
		end,
		Type = Texture + nil,
	}
	-- NormalTexturePath
	property "NormalTexturePath" {
		Get = function(self)
			return self:GetNormalTexture() and self:GetNormalTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetNormalTexture(texture)
		end,
		Type = String + nil,
	}
	-- PushedTexture
	property "PushedTexture" {
		Get = function(self)
			return self:GetPushedTexture()
		end,
		Set = function(self, texture)
			self:SetPushedTexture(texture)
		end,
		Type = Texture + nil,
	}
	-- PushedTexturePath
	property "PushedTexturePath" {
		Get = function(self)
			return self:GetPushedTexture() and self:GetPushedTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetPushedTexture(texture)
		end,
		Type = String + nil,
	}
	--- FontString
	property "FontString" {
		Get = function(self)
			return self:GetFontString()
		end,
		Set = function(self, label)
			self:SetFontString(label)
		end,
		Type = FontString,
	}
	--- HighlightFontObject
	property "HighlightFontObject" {
		Get = function(self)
			return self:GetHighlightFontObject()
		end,
		Set = function(self, fontObject)
			self:SetHighlightFontObject(fontObject)
		end,
		Type = Font + String + nil,
	}
	--- NormalFontObject
	property "NormalFontObject" {
		Get = function(self)
			return self:GetNormalFontObject()
		end,
		Set = function(self, fontObject)
			self:SetNormalFontObject(fontObject)
		end,
		Type = Font + String + nil,
	}
	--- PushedTextOffset
	property "PushedTextOffset" {
		Get = function(self)
			return Dimension(self:GetPushedTextOffset())
		end,
		Set = function(self, offset)
			self:SetPushedTextOffset(offset.x, offset.y)
		end,
		Type = Dimension,
	}
	--- Text
	property "Text" {
		Get = function(self)
			return self:GetText()
		end,
		Set = function(self, text)
			self:SetText(text)
		end,
		Type = LocaleString,
	}
	-- HighlightLocked
	property "HighlightLocked" {
		Get = function(self)
			return (self.__HighlightLocked and true) or false
		end,
		Set = function(self, locked)
			if locked then
				self.__UI:LockHighlight()
				self.__HighlightLocked = true
			else
				self.__UI:UnlockHighlight()
				self.__HighlightLocked = false
			end
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("Button", nil, parent, ...)
	end
endclass "Button"

partclass "Button"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Button)
endclass "Button"