-- Author      : Kurapica
-- Create Date : 7/16/2008 15:19
-- ChangeLog   :
--				2010.01.12	Add the default parameters for _New
--				2010.08.20  Set StringHeight property to readonly, set this property should cause some problem.
--				2011/03/11	Recode as class

-- Check Version
local version = 10
if not IGAS:NewAddon("IGAS.Widget.FontString", version) then
	return
end

class "FontString"
	inherit "LayeredRegion"
	extend "IFFont"

	doc [======[
		@name FontString
		@type class
		@desc  FontStrings are one of the two types of Region that is visible on the screen. It draws a block of text on the screen using the characteristics in an associated FontObject.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name CanNonSpaceWrap
		@type method
		@desc Returns whether long lines of text will wrap within or between words
		@return boolean 1 if long lines of text will wrap at any character boundary; nil to only wrap at whitespace characters
	]======]

	doc [======[
		@name CanWordWrap
		@type method
		@desc Returns whether long lines of text in the font string can wrap onto subsequent lines
		@return boolean 1 if long lines of text can wrap onto subsequent lines; otherwise nil
	]======]

	doc [======[
		@name GetFieldSize
		@type method
		@desc
		@return
	]======]

	doc [======[
		@name GetIndentedWordWrap
		@type method
		@desc
		@return boolean
	]======]

	doc [======[
		@name GetStringHeight
		@type method
		@desc Returns the height of the text displayed in the font string. This value is based on the text currently displayed; e.g. a long block of text wrapped to several lines results in a greater height than that for a short block of text that fits on fewer lines.
		@return number Height of the text currently displayed in the font string (in pixels)
	]======]

	doc [======[
		@name GetStringWidth
		@type method
		@desc Returns the width of the text displayed in the font string. This value is based on the text currently displayed; e.g. a short text label results in a smaller width than a longer block of text. Very long blocks of text that don't fit the font string's dimensions all result in similar widths, because this method measures the width of the text displayed, which is truncated with an ellipsis.
		@return number Width of the text currently displayed in the font string (in pixels)
	]======]

	doc [======[
		@name GetText
		@type method
		@desc Returns the text currently set for display in the font string. This is not necessarily the text actually displayed: text that does not fit within the FontString's dimensions will be truncated with an ellipsis for display.
		@return string Text to be displayed in the font string
	]======]

	doc [======[
		@name GetWrappedWidth
		@type method
		@desc
		@return number
	]======]

	doc [======[
		@name IsTruncated
		@type method
		@desc
		@return boolean
	]======]

	doc [======[
		@name SetAlphaGradient
		@type method
		@desc Creates an opacity gradient over the text in the font string. Seen in the default UI when quest text is presented by a questgiver (if the "Instant Quest Text" feature is not turned on): This method is used with a length of 30 to fade in the letters of the description, starting at the first character; then the start value is incremented in an OnUpdate script, creating the animated fade-in effect.
		@param start number, character position in the font string's text at which the gradient should begin (between 0 and string.len(fontString:GetText()) - 6)
		@param length number, width of the gradient in pixels, or 0 to restore the text to full opacity
		@return nil
	]======]

	doc [======[
		@name SetFormattedText
		@type method
		@desc Sets the text displayed in the font string using format specifiers. Equivalent to :SetText(format(format, ...)), but does not create a throwaway Lua string object, resulting in greater memory-usage efficiency.
		@param formatString string, a string containing format specifiers (as with string.format())
		@param ... a list of values to be included in the formatted string
		@return nil
	]======]

	doc [======[
		@name SetIndentedWordWrap
		@type method
		@desc
		@param boolean
		@return nil
	]======]

	doc [======[
		@name SetNonSpaceWrap
		@type method
		@desc Sets whether long lines of text will wrap within or between words
		@param enable boolean, true to wrap long lines of text at any character boundary; false to only wrap at whitespace characters
		@return nil
	]======]

	doc [======[
		@name SetText
		@type method
		@desc Sets the text to be displayed in the font string
		@param text string, text to be displayed in the font string
		@return nil
	]======]

	doc [======[
		@name SetTextHeight
		@type method
		@desc Scales the font string's rendered text to a different height. This method scales the image of the text as already rendered at its existing height by the game's graphics engine -- producing an effect which is efficient enough for use in fast animations, but with reduced visual quality in the text. To re-render the text at a new point size, see :SetFont().
		@param height number, height (point size) to which the text should be scaled (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetWordWrap
		@type method
		@desc Sets whether long lines of text in the font string can wrap onto subsequent lines
		@param enable boolean, true to allow long lines of text in the font string to wrap onto subsequent lines; false to disallow
		@return nil
	]======]

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, layer, inheritsFrom, ...)
		if not Object.IsClass(parent, UIObject) or not IGAS:GetUI(parent).CreateFontString then
			error("Usage : FontString(name, parent) : 'parent' - UI element expected.", 2)
		end

		return IGAS:GetUI(parent):CreateFontString(nil, layer or "OVERLAY", inheritsFrom or "GameFontNormal", ...)
	end

	__Arguments__{ Argument{ Name = "Name" }, Argument{ Name = "Parent" }, Argument{ Name = "Layer" }, Argument{ Name = "Inherit" } }
endclass "FontString"

partclass "FontString"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(FontString)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name NonSpaceWrap
		@type property
		@desc whether long lines of text will wrap within or between words
	]======]
	property "NonSpaceWrap" {
		Get = "CanNonSpaceWrap",
		Set = "SetNonSpaceWrap",
		Type = Boolean,
	}

	doc [======[
		@name StringHeight
		@type property
		@desc the height of the text displayed in the font string
	]======]
	property "StringHeight" {
		Get = "GetStringHeight",
	}

	doc [======[
		@name StringWidth
		@type property
		@desc the width of the text displayed in the font string
	]======]
	property "StringWidth" {
		Get = "GetStringWidth",
	}

	doc [======[
		@name Text
		@type property
		@desc the text to be displayed in the font string
	]======]
	__Auto__{ Method = true, Type = LocaleString }
	property "Text" {}

endclass "FontString"