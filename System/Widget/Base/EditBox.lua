-- Author      : Kurapica
-- Create Date : 7/16/2008 11:15
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- EditBoxes are used to allow the player to type text into a UI component.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name EditBox
-- @class table
-- @field MultiLine true if the edit box shows more than one line of text
-- @field NumericOnly true if the edit box only accepts numeric input
-- @field Password true if the text entered in the edit box is masked
-- @field AutoFocus true if the edit box automatically acquires keyboard input focus
-- @field HistoryLines the maximum number of history lines stored by the edit box
-- @field Focused true if the edit box is currently focused
-- @field AltArrowKeyMode true if the arrow keys are ignored by the edit box unless the Alt key is held
-- @field BlinkSpeed the rate at which the text insertion blinks when the edit box is focused
-- @field CursorPosition the current cursor position inside edit box
-- @field MaxBytes the maximum number of bytes of text allowed in the edit box, default is 0(Infinite)
-- @field MaxLetters the maximum number of text characters allowed in the edit box
-- @field Number the contents of the edit box as a number
-- @field Text the edit box's text contents
-- @field TextInsets the insets from the edit box's edges which determine its interactive text area
-- @field Editable true if the edit box is editable
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 7
if not IGAS:NewAddon("IGAS.Widget.EditBox", version) then
	return
end

class "EditBox"
	inherit "Frame"
	extend "IFFont"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the edit box's input composition mode changes
	-- @name EditBox:OnCharComposition
	-- @class function
	-- @param text The text entered
	-- @usage function EditBox:OnCharComposition(text)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnCharComposition"

	------------------------------------
	--- ScriptType, Run when the position of the text insertion cursor in the edit box changes
	-- @name EditBox:OnCursorChanged
	-- @class function
	-- @param x Horizontal position of the cursor relative to the top left corner of the edit box (in pixels)
	-- @param y Vertical position of the cursor relative to the top left corner of the edit box (in pixels)
	-- @param width Width of the cursor graphic (in pixels)
	-- @param height Height of the cursor graphic (in pixels); matches the height of a line of text in the edit box
	-- @usage function EditBox:OnCursorChanged(x, y, width, height)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnCursorChanged"

	------------------------------------
	--- ScriptType, Run when the edit box becomes focused for keyboard input
	-- @name EditBox:OnEditFocusGained
	-- @class function
	-- @usage function EditBox:OnEditFocusGained()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEditFocusGained"

	------------------------------------
	--- ScriptType, Run when the edit box loses keyboard input focus
	-- @name EditBox:OnEditFocusLost
	-- @class function
	-- @usage function EditBox:OnEditFocusLost()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEditFocusLost"

	------------------------------------
	--- ScriptType, Run when the Enter (or Return) key is pressed while the edit box has keyboard focus
	-- @name EditBox:OnEnterPressed
	-- @class function
	-- @usage function EditBox:OnEnterPressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEnterPressed"

	------------------------------------
	--- ScriptType, Run when the Escape key is pressed while the edit box has keyboard focus
	-- @name EditBox:OnEscapePressed
	-- @class function
	-- @usage function EditBox:OnEscapePressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEscapePressed"

	------------------------------------
	--- ScriptType, Run when the edit box's language input mode changes
	-- @name EditBox:OnInputLanguageChanged
	-- @class function
	-- @param language Name of the new input language
	-- @usage function EditBox:OnInputLanguageChanged("language")<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnInputLanguageChanged"

	------------------------------------
	--- ScriptType, Run when the space bar is pressed while the edit box has keyboard focus
	-- @name EditBox:OnSpacePressed
	-- @class function
	-- @usage function EditBox:OnSpacePressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnSpacePressed"

	------------------------------------
	--- ScriptType, Run when the Tab key is pressed while the edit box has keyboard focus
	-- @name EditBox:OnTabPressed
	-- @class function
	-- @usage function EditBox:OnTabPressed()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTabPressed"

	------------------------------------
	--- ScriptType, Run when the edit box's text is changed
	-- @name EditBox:OnTextChanged
	-- @class function
	-- @param isUserInput
	-- @usage function EditBox:OnTextChanged(isUserInput)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTextChanged"

	------------------------------------
	--- ScriptType, Run when the edit box's text is set programmatically
	-- @name EditBox:OnTextSet
	-- @class function
	-- @usage function EditBox:OnTextSet()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnTextSet"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	---
	-- @name EditBox:ClearHistory
	-- @class function
	------------------------------------
	-- ClearHistory

	------------------------------------
	--- Returns whether arrow keys are ignored by the edit box unless the Alt key is held
	-- @name EditBox:GetAltArrowKeyMode
	-- @class function
	-- @return enabled - 1 if arrow keys are ignored by the edit box unless the Alt key is held; otherwise nil (1nil)
	------------------------------------
	-- GetAltArrowKeyMode

	------------------------------------
	--- Returns the rate at which the text insertion blinks when the edit box is focused
	-- @name EditBox:GetBlinkSpeed
	-- @class function
	-- @return duration - Amount of time for which the cursor is visible during each "blink" (in seconds) (number)
	------------------------------------
	-- GetBlinkSpeed

	------------------------------------
	--- Returns the current cursor position inside edit box
	-- @name EditBox:GetCursorPosition
	-- @class function
	-- @return position - Current position of the keyboard input cursor (between 0, for the position before the first character, and editbox:GetNumLetters(), for the position after the last character) (number)
	------------------------------------
	-- GetCursorPosition

	------------------------------------
	--- Returns the maximum number of history lines stored by the edit box
	-- @name EditBox:GetHistoryLines
	-- @class function
	-- @return count - Maximum number of history lines stored by the edit box (number)
	------------------------------------
	-- GetHistoryLines

	------------------------------------
	--- Returns whether long lines of text are indented when wrapping
	-- @name EditBox:GetIndentedWordWrap
	-- @class function
	-- @return indent - 1 if long lines of text are indented when wrapping; otherwise nil (1nil)
	------------------------------------
	-- GetIndentedWordWrap

	------------------------------------
	--- Returns the currently selected keyboard input language (character set / input method). Applies to keyboard input methods, not in-game languages or client locales.
	-- @name EditBox:GetInputLanguage
	-- @class function
	------------------------------------
	-- GetInputLanguage

	------------------------------------
	--- Returns the maximum number of bytes of text allowed in the edit box. Note: Unicode characters may consist of more than one byte each, so the behavior of a byte limit may differ from that of a character limit in practical use.
	-- @name EditBox:GetMaxBytes
	-- @class function
	-- @return maxBytes - Maximum number of text bytes allowed in the edit box (number)
	------------------------------------
	-- GetMaxBytes

	------------------------------------
	--- Returns the maximum number of text characters allowed in the edit box
	-- @name EditBox:GetMaxLetters
	-- @class function
	-- @return maxLetters - Maximum number of text characters allowed in the edit box (number)
	------------------------------------
	-- GetMaxLetters

	------------------------------------
	--- Returns the contents of the edit box as a number. Similar to tonumber(editbox:GetText()); returns 0 if the contents of the edit box cannot be converted to a number.
	-- @name EditBox:GetNumber
	-- @class function
	-- @return num - Contents of the edit box as a number (number)
	------------------------------------
	-- GetNumber

	------------------------------------
	--- Returns the number of text characters in the edit box
	-- @name EditBox:GetNumLetters
	-- @class function
	-- @return numLetters - Number of text characters in the edit box (number)
	------------------------------------
	-- GetNumLetters

	------------------------------------
	--- Returns the edit box's text contents
	-- @name EditBox:GetText
	-- @class function
	-- @return text - Text contained in the edit box (string)
	------------------------------------
	-- GetText

	------------------------------------
	--- Returns the insets from the edit box's edges which determine its interactive text area
	-- @name EditBox:GetTextInsets
	-- @class function
	-- @return left - Distance from the left edge of the edit box to the left edge of its interactive text area (in pixels) (number)
	-- @return right - Distance from the right edge of the edit box to the right edge of its interactive text area (in pixels) (number)
	-- @return top - Distance from the top edge of the edit box to the top edge of its interactive text area (in pixels) (number)
	-- @return bottom - Distance from the bottom edge of the edit box to the bottom edge of its interactive text area (in pixels) (number)
	------------------------------------
	-- GetTextInsets

	------------------------------------
	--- Returns the cursor's numeric position in the edit box, taking UTF-8 multi-byte character into account. If the EditBox contains multi-byte Unicode characters, the GetCursorPosition() method will not return correct results, as it considers each eight byte character to count as a single glyph.  This method properly returns the position in the edit box from the perspective of the user.
	-- @name EditBox:GetUTF8CursorPosition
	-- @class function
	-- @return position - The cursor's numeric position (leftmost position is 0), taking UTF8 multi-byte characters into account. (number)
	------------------------------------
	-- GetUTF8CursorPosition

	------------------------------------
	--- Returns whether the edit box is currently focused for keyboard input
	-- @name EditBox:HasFocus
	-- @class function
	-- @return enabled - 1 if the edit box is currently focused for keyboard input; otherwise nil (1nil)
	------------------------------------
	-- HasFocus

	------------------------------------
	--- Selects all or a portion of the text in the edit box
	-- @name EditBox:HighlightText
	-- @class function
	-- @param start Character position at which to begin the selection (between 0, for the position before the first character, and editbox:GetNumLetters(), for the position after the last character); defaults to 0 if not specified (number)
	-- @param end Character position at which to end the selection; if not specified or if less than start, selects all characters after the start position; if equal to start, selects nothing and positions the cursor at the start position (number)
	------------------------------------
	-- HighlightText

	------------------------------------
	--- Inserts text into the edit box at the current cursor position
	-- @name EditBox:Insert
	-- @class function
	-- @param text Text to be inserted (string)
	------------------------------------
	-- Insert

	------------------------------------
	--- Returns whether the edit box automatically acquires keyboard input focus
	-- @name EditBox:IsAutoFocus
	-- @class function
	-- @return enabled - 1 if the edit box automatically acquires keyboard input focus; otherwise nil (1nil)
	------------------------------------
	-- IsAutoFocus

	------------------------------------
	---
	-- @name EditBox:IsCountInvisibleLetters
	-- @class function
	------------------------------------
	-- IsCountInvisibleLetters

	------------------------------------
	--- Returns whether the edit box is in Input Method Editor composition mode. Character composition mode is used for input methods in which multiple keypresses generate one printed character. In such input methods, the edit box's OnChar script is run for each keypress -- if the OnChar script should act only when a complete character is entered in the edit box, :IsInIMECompositionMode() can be used to test for such cases.</p>
	--- <p>This mode is common in clients for languages using non-Roman characters (such as Chinese or Korean), but can still occur in client languages using Roman scripts (e.g. English) -- such as when typing accented characters on the Mac client (e.g. typing "option-u" then "e" to insert the character "?").
	-- @name EditBox:IsInIMECompositionMode
	-- @class function
	-- @return enabled - 1 if the edit box is in IME character composition mode; otherwise nil (1nil)
	------------------------------------
	-- IsInIMECompositionMode

	------------------------------------
	--- Returns whether the edit box shows more than one line of text
	-- @name EditBox:IsMultiLine
	-- @class function
	-- @return multiLine - 1 if the edit box shows more than one line of text; otherwise nil (1nil)
	------------------------------------
	-- IsMultiLine

	------------------------------------
	--- Returns whether the edit box only accepts numeric input
	-- @name EditBox:IsNumeric
	-- @class function
	-- @return enabled - 1 if only numeric input is allowed; otherwise nil (1nil)
	------------------------------------
	-- IsNumeric

	------------------------------------
	--- Returns whether the text entered in the edit box is masked
	-- @name EditBox:IsPassword
	-- @class function
	-- @return enabled - 1 if text entered in the edit box is masked with asterisk characters (*); otherwise nil (1nil)
	------------------------------------
	-- IsPassword

	------------------------------------
	--- Sets whether arrow keys are ignored by the edit box unless the Alt key is held
	-- @name EditBox:SetAltArrowKeyMode
	-- @class function
	-- @param enable True to cause the edit box to ignore arrow key presses unless the Alt key is held; false to allow unmodified arrow key presses for cursor movement (boolean)
	------------------------------------
	-- SetAltArrowKeyMode

	------------------------------------
	--- Sets whether the edit box automatically acquires keyboard input focus. If auto-focus behavior is enabled, the edit box automatically acquires keyboard focus when it is shown and when no other edit box is focused.
	-- @name EditBox:SetAutoFocus
	-- @class function
	-- @param enable True to enable the edit box to automatically acquire keyboard input focus; false to disable (boolean)
	------------------------------------
	-- SetAutoFocus

	------------------------------------
	--- Sets the rate at which the text insertion blinks when the edit box is focused. The speed indicates how long the cursor stays in each state (shown and hidden); e.g. if the blink speed is 0.5 (the default, the cursor is shown for one half second and then hidden for one half second (thus, a one-second cycle); if the speed is 1.0, the cursor is shown for one second and then hidden for one second (a two-second cycle).
	-- @name EditBox:SetBlinkSpeed
	-- @class function
	-- @param duration Amount of time for which the cursor is visible during each "blink" (in seconds) (number)
	------------------------------------
	-- SetBlinkSpeed

	------------------------------------
	---
	-- @name EditBox:SetCountInvisibleLetters
	-- @class function
	------------------------------------
	-- SetCountInvisibleLetters

	------------------------------------
	--- Sets the cursor position in the edit box
	-- @name EditBox:SetCursorPosition
	-- @class function
	-- @param position New position for the keyboard input cursor (between 0, for the position before the first character, and editbox:GetNumLetters(), for the position after the last character) (number)
	------------------------------------
	-- SetCursorPosition

	------------------------------------
	--- Focuses the edit box for keyboard input. Only one edit box may be focused at a time; setting focus to one edit box will remove it from the currently focused edit box.
	-- @name EditBox:SetFocus
	-- @class function
	------------------------------------
	-- SetFocus

	------------------------------------
	--- Sets the maximum number of history lines stored by the edit box. Lines of text can be added to the edit box's history by calling :AddHistoryLine(); once added, the user can quickly set the edit box's contents to one of these lines by pressing the up or down arrow keys. (History lines are only accessible via the arrow keys if the edit box is not in multi-line mode.)
	-- @name EditBox:SetHistoryLines
	-- @class function
	-- @param count Maximum number of history lines to be stored by the edit box (number)
	------------------------------------
	-- SetHistoryLines

	------------------------------------
	--- Sets whether long lines of text are indented when wrapping
	-- @name EditBox:SetIndentedWordWrap
	-- @class function
	-- @param indent True to indent wrapped lines of text; false otherwise (boolean)
	------------------------------------
	-- SetIndentedWordWrap

	------------------------------------
	--- Sets the maximum number of bytes of text allowed in the edit box. Attempts to type more than this number into the edit box will produce no results; programmatically inserting text or setting the edit box's text will truncate input to the maximum length.</p>
	--- <p>Note: Unicode characters may consist of more than one byte each, so the behavior of a byte limit may differ from that of a character limit in practical use.
	-- @name EditBox:SetMaxBytes
	-- @class function
	-- @param maxBytes Maximum number of text bytes allowed in the edit box, or 0 for no limit (number)
	------------------------------------
	-- SetMaxBytes

	------------------------------------
	--- Sets the maximum number of text characters allowed in the edit box. Attempts to type more than this number into the edit box will produce no results; programmatically inserting text or setting the edit box's text will truncate input to the maximum length.
	-- @name EditBox:SetMaxLetters
	-- @class function
	-- @param maxLetters Maximum number of text characters allowed in the edit box, or 0 for no limit (number)
	------------------------------------
	-- SetMaxLetters

	------------------------------------
	--- Sets whether the edit box shows more than one line of text. When in multi-line mode, the edit box's height is determined by the number of lines shown and cannot be set directly -- enclosing the edit box in a ScrollFrame may prove useful in such cases.
	-- @name EditBox:SetMultiLine
	-- @class function
	-- @param multiLine True to allow the edit box to display more than one line of text; false for single-line display (boolean)
	------------------------------------
	-- SetMultiLine

	------------------------------------
	--- Sets the contents of the edit box to a number
	-- @name EditBox:SetNumber
	-- @class function
	-- @param num New numeric content for the edit box (number)
	------------------------------------
	-- SetNumber

	------------------------------------
	--- Sets whether the edit box only accepts numeric input. Note: an edit box in numeric mode <em>only</em> accepts numeral input -- all other characters, including those commonly used in numeric representations (such as ., E, and -) are not allowed.
	-- @name EditBox:SetNumeric
	-- @class function
	-- @param enable True to allow only numeric input; false to allow any text (boolean)
	------------------------------------
	-- SetNumeric

	------------------------------------
	--- Sets whether the text entered in the edit box is masked
	-- @name EditBox:SetPassword
	-- @class function
	-- @param enable True to mask text entered in the edit box with asterisk characters (*); false to show the actual text entered (boolean)
	------------------------------------
	-- SetPassword

	------------------------------------
	--- Sets the edit box's text contents
	-- @name EditBox:SetText
	-- @class function
	-- @param text Text to be placed in the edit box (string)
	------------------------------------
	-- SetText

	------------------------------------
	--- Sets the insets from the edit box's edges which determine its interactive text area
	-- @name EditBox:SetTextInsets
	-- @class function
	-- @param left Distance from the left edge of the edit box to the left edge of its interactive text area (in pixels) (number)
	-- @param right Distance from the right edge of the edit box to the right edge of its interactive text area (in pixels) (number)
	-- @param top Distance from the top edge of the edit box to the top edge of its interactive text area (in pixels) (number)
	-- @param bottom Distance from the bottom edge of the edit box to the bottom edge of its interactive text area (in pixels) (number)
	------------------------------------
	-- SetTextInsets

	------------------------------------
	--- Switches the edit box's language input mode. If the edit box is in ROMAN mode and an alternate Input Method Editor composition mode is available (as determined by the client locale and system settings), switches to the alternate input mode. If the edit box is in IME composition mode, switches back to ROMAN.
	-- @name EditBox:ToggleInputLanguage
	-- @class function
	------------------------------------
	-- ToggleInputLanguage

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- MultiLine
	property "MultiLine" {
		Get = function(self)
			return (self:IsMultiLine() and true) or false
		end,
		Set = function(self, state)
			self:SetMultiLine(state)
		end,
		Type = Boolean,
	}
	-- NumericOnly
	property "NumericOnly" {
		Get = function(self)
			return (self:IsNumeric() and true) or false
		end,
		Set = function(self, state)
			self:SetNumeric(state)
		end,
		Type = Boolean,
	}
	-- Password
	property "Password" {
		Get = function(self)
			return (self:IsPassword() and true) or false
		end,
		Set = function(self, state)
			self:SetPassword(state)
		end,
		Type = Boolean,
	}
	-- AutoFocus
	property "AutoFocus" {
		Get = function(self)
			return (self:IsAutoFocus() and true) or false
		end,
		Set = function(self, state)
			self:SetAutoFocus(state)
		end,
		Type = Boolean,
	}
	-- HistoryLines
	property "HistoryLines" {
		Get = function(self)
			return self:GetHistoryLines()
		end,
		Set = function(self, num)
			self:SetHistoryLines(num)
		end,
		Type = Number,
	}
	-- Focus
	property "Focused" {
		Get = function(self)
			return (self:HasFocus() and true) or false
		end,
		Set = function(self, focus)
			if focus then
				self:SetFocus()
			else
				self:ClearFocus()
			end
		end,
		Type = Boolean,
	}
	-- AltArrowKeyMode
	property "AltArrowKeyMode" {
		Get = function(self)
			return (self:GetAltArrowKeyMode() and true) or false
		end,
		Set = function(self, enable)
			self:SetAltArrowKeyMode(enable)
		end,
		Type = Boolean,
	}
	-- BlinkSpeed
	property "BlinkSpeed" {
		Get = function(self)
			return self:GetBlinkSpeed()
		end,
		Set = function(self, speed)
			self:SetBlinkSpeed(speed)
		end,
		Type = Number,
	}
	-- CursorPosition
	property "CursorPosition" {
		Get = function(self)
			return self:GetCursorPosition()
		end,
		Set = function(self, position)
			self:SetCursorPosition(position)
		end,
		Type = Number,
	}
	-- MaxBytes
	property "MaxBytes" {
		Get = function(self)
			return self:GetMaxBytes()
		end,
		Set = function(self, maxBytes)
			self:SetMaxBytes(maxBytes)
		end,
		Type = Number,
	}
	-- MaxLetters
	property "MaxLetters" {
		Get = function(self)
			return self:GetMaxLetters()
		end,
		Set = function(self, maxLetters)
			self:SetMaxLetters(maxLetters)
		end,
		Type = Number,
	}
	-- Number
	property "Number" {
		Get = function(self)
			return self:GetNumber()
		end,
		Set = function(self, number)
			self:SetNumber(number)
		end,
		Type = Number,
	}
	-- Text
	property "Text" {
		Get = function(self)
			return self:GetText()
		end,
		Set = function(self, text)
			self:SetText(text)
		end,
		Type = String,
	}
	-- TextInsets
	property "TextInsets" {
		Get = function(self)
			return Inset(self:GetTextInsets())
		end,
		Set = function(self, value)
			self:SetTextInsets(value.left, value.right, value.top, value.bottom)
		end,
		Type = Inset,
	}
	-- Editable
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

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function EditBox(name, parent, ...)
		return UIObject(name, parent, CreateFrame("EditBox", nil, parent, ...))
	end
endclass "EditBox"

partclass "EditBox"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(EditBox)
endclass "EditBox"