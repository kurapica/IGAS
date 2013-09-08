-- Author      : Kurapica
-- Create Date : 7/16/2008 11:15
-- Change Log  :
--				2011/03/13	Recode as class
--              2013/06/14  Fix text won't display when create it in the game with no hardware trigger(Hate to fix things caused by blz)

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.EditBox", version) then
	return
end

class "EditBox"
	inherit "Frame"
	extend "IFFont"

	doc [======[
		@name EditBox
		@type class
		@desc EditBoxes are used to allow the player to type text into a UI component.
	]======]

	_FirstLoadedFix = setmetatable({}, {__mode = "k",})

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnCharComposition
		@type event
		@desc Run when the edit box's input composition mode changes
		@param text string, The text entered
	]======]
	event "OnCharComposition"

	doc [======[
		@name OnCursorChanged
		@type event
		@desc Run when the position of the text insertion cursor in the edit box changes
		@param x number, horizontal position of the cursor relative to the top left corner of the edit box (in pixels)
		@param y number, vertical position of the cursor relative to the top left corner of the edit box (in pixels)
		@param width number, width of the cursor graphic (in pixels)
		@param height number, height of the cursor graphic (in pixels); matches the height of a line of text in the edit box
	]======]
	event "OnCursorChanged"

	doc [======[
		@name OnEditFocusGained
		@type event
		@desc Run when the edit box becomes focused for keyboard input
	]======]
	event "OnEditFocusGained"

	doc [======[
		@name OnEditFocusLost
		@type event
		@desc Run when the edit box loses keyboard input focus
	]======]
	event "OnEditFocusLost"

	doc [======[
		@name OnEnterPressed
		@type event
		@desc Run when the Enter (or Return) key is pressed while the edit box has keyboard focus
	]======]
	event "OnEnterPressed"

	doc [======[
		@name OnEscapePressed
		@type event
		@desc Run when the Escape key is pressed while the edit box has keyboard focus
	]======]
	event "OnEscapePressed"

	doc [======[
		@name OnInputLanguageChanged
		@type event
		@desc Run when the edit box's language input mode changes
		@param language string, name of the new input language
	]======]
	event "OnInputLanguageChanged"

	doc [======[
		@name OnSpacePressed
		@type event
		@desc Run when the space bar is pressed while the edit box has keyboard focus
	]======]
	event "OnSpacePressed"

	doc [======[
		@name OnTabPressed
		@type event
		@desc Run when the Tab key is pressed while the edit box has keyboard focus
	]======]
	event "OnTabPressed"

	doc [======[
		@name OnTextChanged
		@type event
		@desc Run when the edit box's text is changed
		@param isUserInput boolean
	]======]
	event "OnTextChanged"

	doc [======[
		@name OnTextSet
		@type event
		@desc Run when the edit box's text is set programmatically
	]======]
	event "OnTextSet"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name AddHistoryLine
		@type method
		@desc Add text to the edit history
		@param text string, text to be added to the edit box's list of history lines
		@return nil
	]======]

	doc [======[
		@name ClearHistory
		@type method
		@desc Clear history
		@return nil
	]======]

	doc [======[
		@name ClearFocus
		@type method
		@desc Releases keyboard input focus from the edit box
		@return nil
	]======]

	doc [======[
		@name GetAltArrowKeyMode
		@type method
		@desc Returns whether arrow keys are ignored by the edit box unless the Alt key is held
		@return boolean 1 if arrow keys are ignored by the edit box unless the Alt key is held; otherwise nil
	]======]

	doc [======[
		@name GetBlinkSpeed
		@type method
		@desc Returns the rate at which the text insertion blinks when the edit box is focused
		@return number Amount of time for which the cursor is visible during each "blink" (in seconds)
	]======]

	doc [======[
		@name GetCursorPosition
		@type method
		@desc Returns the current cursor position inside edit box
		@return number Current position of the keyboard input cursor (between 0, for the position before the first character, and editbox:GetNumLetters(), for the position after the last character)
	]======]

	doc [======[
		@name GetHistoryLines
		@type method
		@desc Returns the maximum number of history lines stored by the edit box
		@return number Maximum number of history lines stored by the edit box
	]======]

	doc [======[
		@name GetIndentedWordWrap
		@type method
		@desc Returns whether long lines of text are indented when wrapping
		@return boolean 1 if long lines of text are indented when wrapping; otherwise nil
	]======]

	doc [======[
		@name GetInputLanguage
		@type method
		@desc Returns the currently selected keyboard input language (character set / input method). Applies to keyboard input methods, not in-game languages or client locales.
		@return string the input language
	]======]

	doc [======[
		@name GetMaxBytes
		@type method
		@desc Returns the maximum number of bytes of text allowed in the edit box. Note: Unicode characters may consist of more than one byte each, so the behavior of a byte limit may differ from that of a character limit in practical use.
		@return number Maximum number of text bytes allowed in the edit box
	]======]

	doc [======[
		@name GetMaxLetters
		@type method
		@desc Returns the maximum number of text characters allowed in the edit box
		@return number Maximum number of text characters allowed in the edit box
	]======]

	doc [======[
		@name GetNumber
		@type method
		@desc Returns the contents of the edit box as a number. Similar to tonumber(editbox:GetText()); returns 0 if the contents of the edit box cannot be converted to a number.
		@return number Contents of the edit box as a number
	]======]

	doc [======[
		@name GetNumLetters
		@type method
		@desc Returns the number of text characters in the edit box
		@return number Number of text characters in the edit box
	]======]

	doc [======[
		@name GetText
		@type method
		@desc Returns the edit box's text contents
		@return string Text contained in the edit box
	]======]

	doc [======[
		@name GetTextInsets
		@type method
		@desc Returns the insets from the edit box's edges which determine its interactive text area
		@return left number, distance from the left edge of the edit box to the left edge of its interactive text area (in pixels)
		@return right number, distance from the right edge of the edit box to the right edge of its interactive text area (in pixels)
		@return top number, distance from the top edge of the edit box to the top edge of its interactive text area (in pixels)
		@return bottom number, distance from the bottom edge of the edit box to the bottom edge of its interactive text area (in pixels)
	]======]

	doc [======[
		@name GetUTF8CursorPosition
		@type method
		@desc Returns the cursor's numeric position in the edit box, taking UTF-8 multi-byte character into account. If the EditBox contains multi-byte Unicode characters, the GetCursorPosition() method will not return correct results, as it considers each eight byte character to count as a single glyph.  This method properly returns the position in the edit box from the perspective of the user.
		@return number The cursor's numeric position (leftmost position is 0), taking UTF8 multi-byte characters into account.
	]======]

	doc [======[
		@name HasFocus
		@type method
		@desc Returns whether the edit box is currently focused for keyboard input
		@return boolean 1 if the edit box is currently focused for keyboard input; otherwise nil
	]======]

	doc [======[
		@name HighlightText
		@type method
		@desc Selects all or a portion of the text in the edit box
		@param start number, character position at which to begin the selection (between 0, for the position before the first character, and editbox:GetNumLetters(), for the position after the last character); defaults to 0 if not specified
		@param end number, character position at which to end the selection; if not specified or if less than start, selects all characters after the start position; if equal to start, selects nothing and positions the cursor at the start position
		@return nil
	]======]

	doc [======[
		@name Insert
		@type method
		@desc Inserts text into the edit box at the current cursor position
		@param text string, text to be inserted
		@return nil
	]======]

	doc [======[
		@name IsAutoFocus
		@type method
		@desc Returns whether the edit box automatically acquires keyboard input focus
		@return boolean 1 if the edit box automatically acquires keyboard input focus; otherwise nil
	]======]

	doc [======[
		@name IsCountInvisibleLetters
		@type method
		@desc
		@return boolean
	]======]

	doc [======[
		@name IsInIMECompositionMode
		@type method
		@desc Returns whether the edit box is in Input Method Editor composition mode. Character composition mode is used for input methods in which multiple keypresses generate one printed character. In such input methods, the edit box's OnChar script is run for each keypress
		@return boolean 1 if the edit box is in IME character composition mode; otherwise nil
	]======]

	doc [======[
		@name IsMultiLine
		@type method
		@desc Returns whether the edit box shows more than one line of text
		@return boolean 1 if the edit box shows more than one line of text; otherwise nil
	]======]

	doc [======[
		@name IsNumeric
		@type method
		@desc Returns whether the edit box only accepts numeric input
		@return boolean 1 if only numeric input is allowed; otherwise nil
	]======]

	doc [======[
		@name IsPassword
		@type method
		@desc Returns whether the text entered in the edit box is masked
		@return boolean 1 if text entered in the edit box is masked with asterisk characters (*); otherwise nil
	]======]

	doc [======[
		@name SetAltArrowKeyMode
		@type method
		@desc Sets whether arrow keys are ignored by the edit box unless the Alt key is held
		@param enable boolean, true to cause the edit box to ignore arrow key presses unless the Alt key is held; false to allow unmodified arrow key presses for cursor movement
		@return nil
	]======]

	doc [======[
		@name SetAutoFocus
		@type method
		@desc Sets whether the edit box automatically acquires keyboard input focus. If auto-focus behavior is enabled, the edit box automatically acquires keyboard focus when it is shown and when no other edit box is focused.
		@param enable boolean, true to enable the edit box to automatically acquire keyboard input focus; false to disable
		@return nil
	]======]

	doc [======[
		@name SetBlinkSpeed
		@type method
		@desc Sets the rate at which the text insertion blinks when the edit box is focused. The speed indicates how long the cursor stays in each state (shown and hidden); e.g. if the blink speed is 0.5 (the default, the cursor is shown for one half second and then hidden for one half second (thus, a one-second cycle); if the speed is 1.0, the cursor is shown for one second and then hidden for one second (a two-second cycle).
		@param duration number, Amount of time for which the cursor is visible during each "blink" (in seconds)
		@return nil
	]======]

	doc [======[
		@name SetCountInvisibleLetters
		@type method
		@desc
		@param ...
		@return nil
	]======]

	doc [======[
		@name SetCursorPosition
		@type method
		@desc Sets the cursor position in the edit box
		@param position number, new position for the keyboard input cursor (between 0, for the position before the first character, and editbox:GetNumLetters(), for the position after the last character)
		@return nil
	]======]

	doc [======[
		@name SetFocus
		@type method
		@desc Focuses the edit box for keyboard input. Only one edit box may be focused at a time; setting focus to one edit box will remove it from the currently focused edit box.
		@return nil
	]======]

	doc [======[
		@name SetHistoryLines
		@type method
		@desc Sets the maximum number of history lines stored by the edit box. Lines of text can be added to the edit box's history by calling :AddHistoryLine(); once added, the user can quickly set the edit box's contents to one of these lines by pressing the up or down arrow keys. (History lines are only accessible via the arrow keys if the edit box is not in multi-line mode.)
		@param count number, Maximum number of history lines to be stored by the edit box
		@return nil
	]======]

	doc [======[
		@name SetIndentedWordWrap
		@type method
		@desc Sets whether long lines of text are indented when wrapping
		@param indent boolean, true to indent wrapped lines of text; false otherwise
		@return nil
	]======]

	doc [======[
		@name SetMaxBytes
		@type method
		@desc Sets the maximum number of bytes of text allowed in the edit box
		@param maxBytes number, Maximum number of text bytes allowed in the edit box, or 0 for no limit
		@return nil
	]======]

	doc [======[
		@name SetMaxLetters
		@type method
		@desc Sets the maximum number of text characters allowed in the edit box.
		@param maxLetters number, Maximum number of text characters allowed in the edit box, or 0 for no limit
		@return nil
	]======]

	doc [======[
		@name SetMultiLine
		@type method
		@desc Sets whether the edit box shows more than one line of text. When in multi-line mode, the edit box's height is determined by the number of lines shown and cannot be set directly -- enclosing the edit box in a ScrollFrame may prove useful in such cases.
		@param multiLine boolean, true to allow the edit box to display more than one line of text; false for single-line display
		@return nil
	]======]

	doc [======[
		@name SetNumber
		@type method
		@desc Sets the contents of the edit box to a number
		@param num number, new numeric content for the edit box
		@return nil
	]======]

	doc [======[
		@name SetNumeric
		@type method
		@desc Sets whether the edit box only accepts numeric input. Note: an edit box in numeric mode <em>only</em> accepts numeral input -- all other characters, including those commonly used in numeric representations (such as ., E, and -) are not allowed.
		@param enable boolean, true to allow only numeric input; false to allow any text
		@return nil
	]======]

	doc [======[
		@name SetPassword
		@type method
		@desc Sets whether the text entered in the edit box is masked
		@param enable boolean, true to mask text entered in the edit box with asterisk characters (*); false to show the actual text entered
		@return nil
	]======]

	doc [======[
		@name SetText
		@type method
		@desc Sets the edit box's text contents
		@param text string, text to be placed in the edit box
		@return nil
	]======]
	function SetText(self, text)
		self.__UI:SetText(text)

		if _FirstLoadedFix[self] then
			_FirstLoadedFix[self] = nil

			self.__UI:SetCursorPosition(0)
		end
	end

	doc [======[
		@name SetTextInsets
		@type method
		@desc Sets the insets from the edit box's edges which determine its interactive text area
		@param left number, distance from the left edge of the edit box to the left edge of its interactive text area (in pixels)
		@param right number, distance from the right edge of the edit box to the right edge of its interactive text area (in pixels)
		@param top number, distance from the top edge of the edit box to the top edge of its interactive text area (in pixels)
		@param bottom number, distance from the bottom edge of the edit box to the bottom edge of its interactive text area (in pixels)
		@return nil
	]======]

	doc [======[
		@name ToggleInputLanguage
		@type method
		@desc Switches the edit box's language input mode. If the edit box is in ROMAN mode and an alternate Input Method Editor composition mode is available (as determined by the client locale and system settings), switches to the alternate input mode. If the edit box is in IME composition mode, switches back to ROMAN.
		@return nil
	]======]

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("EditBox", nil, parent, ...)
	end

	function EditBox(self)
		_FirstLoadedFix[self] = true
	end
endclass "EditBox"

partclass "EditBox"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(EditBox)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name MultiLine
		@type property
		@desc true if the edit box shows more than one line of text
	]======]
	property "MultiLine" {
		Get = "IsMultiLine",
		Set = "SetMultiLine",
		Type = Boolean,
	}

	doc [======[
		@name NumericOnly
		@type property
		@desc true if the edit box only accepts numeric input
	]======]
	property "NumericOnly" {
		Get = "IsNumeric",
		Set = "SetNumeric",
		Type = Boolean,
	}

	doc [======[
		@name Password
		@type property
		@desc true if the text entered in the edit box is masked
	]======]
	property "Password" {
		Get = "IsPassword",
		Set = "SetPassword",
		Type = Boolean,
	}

	doc [======[
		@name AutoFocus
		@type property
		@desc true if the edit box automatically acquires keyboard input focus
	]======]
	property "AutoFocus" {
		Get = "IsAutoFocus",
		Set = "SetAutoFocus",
		Type = Boolean,
	}

	doc [======[
		@name HistoryLines
		@type property
		@desc the maximum number of history lines stored by the edit box
	]======]
	__Auto__{ Method = true, Type = Number }
	property "HistoryLines" {}

	doc [======[
		@name Focused
		@type property
		@desc true if the edit box is currently focused
	]======]
	property "Focused" {
		Get = "HasFocus",
		Set = function(self, focus)
			if focus then
				self:SetFocus()
			else
				self:ClearFocus()
			end
		end,
		Type = Boolean,
	}

	doc [======[
		@name AltArrowKeyMode
		@type property
		@desc true if the arrow keys are ignored by the edit box unless the Alt key is held
	]======]
	__Auto__{ Method = true, Type = Boolean }
	property "AltArrowKeyMode" {}

	doc [======[
		@name BlinkSpeed
		@type property
		@desc the rate at which the text insertion blinks when the edit box is focused
	]======]
	__Auto__{ Method = true, Type = Number }
	property "BlinkSpeed" {}

	doc [======[
		@name CursorPosition
		@type property
		@desc the current cursor position inside edit box
	]======]
	__Auto__{ Method = true, Type = Number }
	property "CursorPosition" {}

	doc [======[
		@name MaxBytes
		@type property
		@desc the maximum number of bytes of text allowed in the edit box, default is 0(Infinite)
	]======]
	__Auto__{ Method = true, Type = Number }
	property "MaxBytes" {}

	doc [======[
		@name MaxLetters
		@type property
		@desc the maximum number of text characters allowed in the edit box
	]======]
	__Auto__{ Method = true, Type = Number }
	property "MaxLetters" {}

	doc [======[
		@name Number
		@type property
		@desc the contents of the edit box as a number
	]======]
	__Auto__{ Method = true, Type = Number }
	property "Number" {}

	doc [======[
		@name Text
		@type property
		@desc the edit box's text contents
	]======]
	__Auto__{ Method = true, Type = String + Number }
	property "Text" {}

	doc [======[
		@name TextInsets
		@type property
		@desc the insets from the edit box's edges which determine its interactive text area
	]======]
	property "TextInsets" {
		Get = function(self)
			return Inset(self:GetTextInsets())
		end,
		Set = function(self, value)
			self:SetTextInsets(value.left, value.right, value.top, value.bottom)
		end,
		Type = Inset,
	}

	doc [======[
		@name Editable
		@type property
		@desc true if the edit box is editable
	]======]
	property "Editable" {
		Get = function(self)
			return self.MouseEnabled
		end,
		Set = function(self, flag)
			self.MouseEnabled = flag
			if not flag then
				self.AutoFocus = false
				if self:HasFocus() then
					self:ClearFocus()
				end
			end
		end,
		Type = Boolean,
	}

endclass "EditBox"