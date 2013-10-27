-- Author      : Kurapica
-- Create Date : 7/12/2008 14:38
-- Change Log  :
--				2010.10.18	Remove Style properties, since button is a base widget, should not have style.
--				2011/03/13	Recode as class

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.Button", version) then
	return
end

class "Button"
	inherit "Frame"

	doc [======[
		@name Button
		@type class
		@desc Button is the primary means for users to control the game and their characters.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnClick
		@type event
		@desc Run when the button is clicked
		@param button string, name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
		@param down boolean, true for a mouse button down action; false for button up or other actions
	]======]
	event "OnClick"

	doc [======[
		@name OnDoubleClick
		@type event
		@desc Run when the button is double-clicked
		@param button string, name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	]======]
	event "OnDoubleClick"

	doc [======[
		@name PostClick
		@type event
		@desc Run immediately following the button's `OnClick` handler with the same arguments
		@param button string, name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
		@param down boolean, true for a mouse button down action; false for button up or other actions
	]======]
	event "PostClick"

	doc [======[
		@name PreClick
		@type event
		@desc Run immediately before the button's `OnClick` handler with the same arguments
		@param button string, name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
		@param down boolean, true for a mouse button down action; false for button up or other actions
	]======]
	event "PreClick"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Click
		@type method
		@desc Performs a (virtual) mouse click on the button.
		@param button string, name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
		@return nil
	]======]

	doc [======[
		@name Disable
		@type method
		@desc Disallows user interaction with the button. Automatically changes the visual state of the button if its DisabledTexture, DisabledTextColor or DisabledFontObject are set.
		@return nil
	]======]

	doc [======[
		@name Enable
		@type method
		@desc Allows user interaction with the button. If a disabled appearance was specified for the button, automatically returns the button to its normal appearance.
		@return nil
	]======]

	doc [======[
		@name GetButtonState
		@type method
		@desc Returns the button's current state
		@return System.Widget.ButtonStateType State of the button
	]======]

	doc [======[
		@name GetDisabledFontObject
		@type method
		@desc Returns the font object used for the button's disabled state
		@return System.Widget.Font
	]======]
	function GetDisabledFontObject(self)
		return IGAS:GetWrapper(self.__UI:GetDisabledFontObject())
	end

	doc [======[
		@name GetDisabledTexture
		@type method
		@desc Returns the texture used when the button is disabled
		@return System.Widget.Texture
	]======]
	function GetDisabledTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetDisabledTexture(...))
	end

	doc [======[
		@name GetFontString
		@type method
		@desc Returns the FontString object used for the button's label text
		@return System.Widget.FontString Reference to the FontString object used for the button's label text
	]======]
	function GetFontString(self, ...)
		return IGAS:GetWrapper(self.__UI:GetFontString(...))
	end

	doc [======[
		@name GetHighlightFontObject
		@type method
		@desc  Returns the font object used when the button is highlighted
		@return System.Widget.Font Reference to the Font object used when the button is highlighted
	]======]
	function GetHighlightFontObject(self)
		return IGAS:GetWrapper(self.__UI:GetHighlightFontObject())
	end

	doc [======[
		@name GetHighlightTexture
		@type method
		@desc Returns the texture used when the button is highlighted
		@return System.Widget.Texture Reference to the Texture object used when the button is highlighted
	]======]
	function GetHighlightTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetHighlightTexture(...))
	end

	doc [======[
		@name GetMotionScriptsWhileDisabled
		@type method
		@desc Determines whether OnEnter/OnLeave scripts will fire while the button is disabled
		@return boolean 1 if motion scripts run while hidden; otherwise nil
	]======]

	doc [======[
		@name GetNormalFontObject
		@type method
		@desc Returns the font object used for the button's normal state
		@return System.Widget.Font Reference to the Font object used for the button's normal state
	]======]
	function GetNormalFontObject(self)
		return IGAS:GetWrapper(self.__UI:GetNormalFontObject())
	end

	doc [======[
		@name GetNormalTexture
		@type method
		@desc Returns the texture used for the button's normal state
		@return System.Widget.Texture Reference to the Texture object used for the button's normal state
	]======]
	function GetNormalTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetNormalTexture(...))
	end

	doc [======[
		@name GetPushedTextOffset
		@type method
		@desc Returns the offset for moving the button's label text when pushed
		@return x number, horizontal offset for the text (in pixels; values increasing to the right)
		@return y number, vertical offset for the text (in pixels; values increasing upward)
	]======]

	doc [======[
		@name GetPushedTexture
		@type method
		@desc Returns the texture used when the button is pushed
		@return System.Widget.Texture Reference to the Texture object used when the button is pushed
	]======]
	function GetPushedTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetPushedTexture(...))
	end

	doc [======[
		@name GetText
		@type method
		@desc Returns the text of the button's label
		@return string Text of the button's label
	]======]

	doc [======[
		@name GetTextHeight
		@type method
		@desc Returns the height of the button's text label. Reflects the height of the rendered text (which increases if the text wraps onto two lines), not the point size of the text's font.
		@return number Height of the button's text (in pixels)
	]======]

	doc [======[
		@name GetTextWidth
		@type method
		@desc Returns the width of the button's text label
		@return number Width of the button's text (in pixels)
	]======]

	doc [======[
		@name IsEnabled
		@type method
		@desc Returns whether user interaction with the button is allowed
		@return boolean 1 if user interaction with the button is allowed; otherwise nil
	]======]

	doc [======[
		@name LockHighlight
		@type method
		@desc Locks the button in its highlight state. When the highlight state is locked, the button will always appear highlighted regardless of whether it is moused over.
		@return nil
	]======]

	doc [======[
		@name RegisterForClicks
		@type method
		@desc Registers a button to receive mouse clicks
		@param ... A list of strings, each the combination of a button name and click action for which the button's click-related script handlers should be run.
		@return nil
	]======]

	doc [======[
		@name SetButtonState
		@type method
		@desc Sets the button's state
		@format state[, locked]
		@param state System.Widget.ButtonStateType
		@param locked boolean
		@return nil
	]======]
	function SetButtonState(self, state, locked)
		if locked ~= nil then
			self.__Locked = locked
		end

		self.__UI:SetButtonState(state, self.__Locked)
	end

	doc [======[
		@name SetDisabledFontObject
		@type method
		@desc Sets the font object used for the button's disabled state
		@param font System.Widget.Font, reference to a Font object to be used when the button is disabled
		@return nil
	]======]

	doc [======[
		@name SetDisabledTexture
		@type method
		@desc Sets the texture used when the button is disabled
		@format texture|filename
		@param texture System.Widget.Texture, reference to an existing Texture object
		@param filename string, path to a texture image file
		@return nil
	]======]

	doc [======[
		@name SetFontString
		@type method
		@desc Sets the FontString object used for the button's label text
		@param fontstring System.Widget.FontString, reference to a FontString object to be used for the button's label text
		@return nil
	]======]

	doc [======[
		@name SetFormattedText
		@type method
		@desc Sets the button's label text using format specifiers.
		@param formatString string, a string containing format specifiers (as with string.format())
		@param ... A list of values to be included in the formatted string
		@return nil
	]======]

	doc [======[
		@name SetHighlightFontObject
		@type method
		@desc Sets the font object used when the button is highlighted
		@param font System.Widget.Font, reference to a Font object to be used when the button is highlighted
		@return nil
	]======]

	doc [======[
		@name SetHighlightTexture
		@type method
		@desc Sets the texture used when the button is highlighted. Unlike the other button textures for which only one is visible at a time, the button's highlight texture is drawn on top of its existing (normal or pushed) texture; thus, this method also allows specification of the texture's blend mode.
		@format texture|filename[, mode]
		@param texture System.Widget.Texture, reference to an existing Texture object
		@param filename string, path to a texture image file
		@param mode System.Widget.AlphaMode, Blend mode for the texture; defaults to ADD if omitted
		@return nil
	]======]

	doc [======[
		@name SetMotionScriptsWhileDisabled
		@type method
		@desc Sets whether the button should fire OnEnter/OnLeave events while disabled
		@param enable boolean, true to enable the scripts while the button is disabled, false otherwise
		@return nil
	]======]

	doc [======[
		@name SetNormalFontObject
		@type method
		@desc Sets the font object used for the button's normal state
		@param font System.Widget.Font, reference to a Font object to be used in the button's normal state
		@return nil
	]======]

	doc [======[
		@name SetNormalTexture
		@type method
		@desc Sets the texture used for the button's normal state
		@format texture|filename
		@param texture System.Widget.Texture, reference to an existing Texture object
		@param filename string, path to a texture image file
		@return nil
	]======]

	doc [======[
		@name SetPushedTextOffset
		@type method
		@desc Sets the offset for moving the button's label text when pushed. Moving the button's text while it is being clicked can provide an illusion of 3D depth for the button -- in the default UI's standard button templates, this offset matches the apparent movement seen in the difference between the buttons' normal and pushed textures.
		@param x number, horizontal offset for the text (in pixels; values increasing to the right)
		@param y number, vertical offset for the text (in pixels; values increasing upward)
		@return nil
	]======]

	doc [======[
		@name SetPushedTexture
		@type method
		@desc Sets the texture used when the button is pushed
		@format texture|filename
		@param texture System.Widget.Texture, reference to an existing Texture object
		@param filename string, path to a texture image file
		@return nil
	]======]

	doc [======[
		@name SetText
		@type method
		@desc Sets the text displayed as the button's label
		@param text string, text to be displayed as the button's label
		@return nil
	]======]

	doc [======[
		@name UnlockHighlight
		@type method
		@desc Unlocks the button's highlight state. Can be used after a call to :LockHighlight() to restore the button's normal mouseover behavior.
		@return nil
	]======]

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("Button", nil, parent, ...)
	end
endclass "Button"

class "Button"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Button)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Enabled
		@type property
		@desc true if the button is enabled
	]======]
	property "Enabled" {
		Get = "IsEnabled",
		Set = function(self, enabled)
			if enabled then
				self:Enable()
			else
				self:Disable()
			end
		end,
		Type = Boolean,
	}

	doc [======[
		@name ButtonState
		@type property
		@desc the button's current state: NORMAL, PUSHED
	]======]
	property "ButtonState" {
		Get = "GetButtonState",
		Set = function(self, state)
			self:SetButtonState(state, self.__Locked)
		end,
		Type = ButtonStateType,
	}

	doc [======[
		@name Locked
		@type property
		@desc true if the button is locked
	]======]
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

	doc [======[
		@name DisabledFontObject
		@type property
		@desc the font object used for the button's disabled state
	]======]
	property "DisabledFontObject" { Type = Font + String + nil }

	doc [======[
		@name DisabledTexture
		@type property
		@desc the texture object used when the button is disabled
	]======]
	property "DisabledTexture" { Type = Texture + nil }

	doc [======[
		@name DisabledTexturePath
		@type property
		@desc the texture file path used when the button is disabled
	]======]
	property "DisabledTexturePath" {
		Get = function(self)
			return self:GetDisabledTexture() and self:GetDisabledTexture().TexturePath
		end,
		Set = "SetDisabledTexture",
		Type = String + nil,
	}

	doc [======[
		@name HighlightTexture
		@type property
		@desc the texture object used when the button is highlighted
	]======]
	property "HighlightTexture" { Type = Texture + nil }

	doc [======[
		@name HighlightTexturePath
		@type property
		@desc the texture file path used when the button is highlighted
	]======]
	property "HighlightTexturePath" {
		Get = function(self)
			return self:GetHighlightTexture() and self:GetHighlightTexture().TexturePath
		end,
		Set = "SetHighlightTexture",
		Type = String + nil,
	}

	doc [======[
		@name NormalTexture
		@type property
		@desc the texture object used for the button's normal state
	]======]
	property "NormalTexture" { Type = Texture + nil }

	doc [======[
		@name NormalTexturePath
		@type property
		@desc the texture file used for the button's normal state
	]======]
	property "NormalTexturePath" {
		Get = function(self)
			return self:GetNormalTexture() and self:GetNormalTexture().TexturePath
		end,
		Set = "SetNormalTexture",
		Type = String + nil,
	}

	doc [======[
		@name PushedTexture
		@type property
		@desc the texture object used when the button is pushed
	]======]
	property "PushedTexture" { Type = Texture + nil }

	doc [======[
		@name PushedTexturePath
		@type property
		@desc the texture file path used when the button is pushed
	]======]
	property "PushedTexturePath" {
		Get = function(self)
			return self:GetPushedTexture() and self:GetPushedTexture().TexturePath
		end,
		Set = "SetPushedTexture",
		Type = String + nil,
	}

	doc [======[
		@name FontString
		@type property
		@desc the FontString object used for the button's label text
	]======]
	property "FontString" { Type = FontString }

	doc [======[
		@name HighlightFontObject
		@type property
		@desc the font object used when the button is highlighted
	]======]
	property "HighlightFontObject" { Type = Font + String + nil }

	doc [======[
		@name NormalFontObject
		@type property
		@desc the font object used for the button's normal state
	]======]
	property "NormalFontObject" { Type = Font + String + nil }

	doc [======[
		@name PushedTextOffset
		@type property
		@desc the offset for moving the button's label text when pushed
	]======]
	property "PushedTextOffset" {
		Get = function(self)
			return Dimension(self:GetPushedTextOffset())
		end,
		Set = function(self, offset)
			self:SetPushedTextOffset(offset.x, offset.y)
		end,
		Type = Dimension,
	}

	doc [======[
		@name Text
		@type property
		@desc the text displayed as the button's label
	]======]
	property "Text" { Type = LocaleString }

	doc [======[
		@name HighlightLocked
		@type property
		@desc true if the button's highlight state is locked
	]======]
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

endclass "Button"