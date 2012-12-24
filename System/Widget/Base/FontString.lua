-- Author      : Kurapica
-- Create Date : 7/16/2008 15:19
-- ChangeLog   :
--				2010.01.12	Add the default parameters for _New
--				2010.08.20  Set StringHeight property to readonly, set this property should cause some problem.
--				2011/03/11	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- FontStrings are one of the two types of Region that is visible on the screen. It draws a block of text on the screen using the characteristics in an associated FontObject.
-- <br><br>inherit <a href=".\LayeredRegion.html">LayeredRegion</a> For all methods, properties and scriptTypes
-- @name FontString
-- @class table
-- @field Font the font's defined table, contains font path, height and flags' settings
-- @field FontObject the `Font` object
-- @field JustifyH the fontstring's horizontal text alignment style
-- @field JustifyV the fontstring's vertical text alignment style
-- @field ShadowColor the color of the font's text shadow
-- @field ShadowOffset the offset of the fontstring's text shadow from its text
-- @field Spacing the fontstring's amount of spacing between lines
-- @field TextColor the fontstring's default text color
-- @field NonSpaceWrap whether long lines of text will wrap within or between words
-- @field StringHeight the height of the text displayed in the font string
-- @field StringWidth Readonly, the width of the text displayed in the font string
-- @field Text the text to be displayed in the font string
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 10
if not IGAS:NewAddon("IGAS.Widget.FontString", version) then
	return
end

class "FontString"
	inherit "LayeredRegion"
	extend "IFFont"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the font instance's basic font properties
	-- @name Font:GetFont
	-- @class function
	-- @return filename - Path to a font file (string)
	-- @return fontHeight - Height (point size) of the font to be displayed (in pixels) (number)
	-- @return flags - Additional properties for the font specified by one or more (separated by commas) of the following tokens: (string) <ul><li>MONOCHROME - Font is rendered without antialiasing
	-- @return OUTLINE - Font is displayed with a black outline
	-- @return THICKOUTLINE - Font is displayed with a thick black outline
	------------------------------------
	-- GetFont

	------------------------------------
	--- Returns the Font object from which the font instance's properties are inherited. See Font:SetFontObject() for details.
	-- @name Font:GetFontObject
	-- @class function
	-- @return font - Reference to the Font object from which the font instance's properties are inherited, or nil if the font instance has no inherited properties (font)
	------------------------------------
	-- GetFontObject

	------------------------------------
	--- Returns the font instance's horizontal text alignment style
	-- @name Font:GetJustifyH
	-- @class function
	-- @return justify - Horizontal text alignment style (string, justifyH) <ul><li>CENTER
	------------------------------------
	-- GetJustifyH

	------------------------------------
	--- Returns the font instance's vertical text alignment style
	-- @name Font:GetJustifyV
	-- @class function
	-- @return justify - Vertical text alignment style (string, justifyV) <ul><li>BOTTOM
	------------------------------------
	-- GetJustifyV

	------------------------------------
	--- Returns the color of the font's text shadow
	-- @name Font:GetShadowColor
	-- @class function
	-- @return shadowR - Red component of the shadow color (0.0 - 1.0) (number)
	-- @return shadowG - Green component of the shadow color (0.0 - 1.0) (number)
	-- @return shadowB - Blue component of the shadow color (0.0 - 1.0) (number)
	-- @return shadowAlpha - Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetShadowColor

	------------------------------------
	--- Returns the offset of the font instance's text shadow from its text
	-- @name Font:GetShadowOffset
	-- @class function
	-- @return xOffset - Horizontal distance between the text and its shadow (in pixels) (number)
	-- @return yOffset - Vertical distance between the text and its shadow (in pixels) (number)
	------------------------------------
	-- GetShadowOffset

	------------------------------------
	--- Returns the font instance's amount of spacing between lines
	-- @name Font:GetSpacing
	-- @class function
	-- @return spacing - Amount of space between lines of text (in pixels) (number)
	------------------------------------
	-- GetSpacing

	------------------------------------
	--- Returns the font instance's default text color
	-- @name Font:GetTextColor
	-- @class function
	-- @return textR - Red component of the text color (0.0 - 1.0) (number)
	-- @return textG - Green component of the text color (0.0 - 1.0) (number)
	-- @return textB - Blue component of the text color (0.0 - 1.0) (number)
	-- @return textAlpha - Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetTextColor

	------------------------------------
	--- Sets the font instance's basic font properties. Font files included with the default WoW client:</p>
	--- <ul>
	--- <li>Fonts\\FRIZQT__.TTF - Friz Quadrata, used by default for player names and most UI text</li>
	--- <li>Fonts\\ARIALN.TTF - Arial Narrow, used by default for chat windows, action button numbers, etc.</li>
	--- <li>Fonts\\skurri.ttf - Skurri, used by default for incoming damage/parry/miss/etc indicators on the Player and Pet frames</li>
	--- <li>Fonts\\MORPHEUS.ttf - Morpheus, used by default for quest title headers, mail, and readable in-game objects.</li>
	--- </ul>
	--- <p>Font files can also be included in addons.
	-- @name Font:SetFont
	-- @class function
	-- @param filename Path to a font file (string)
	-- @param fontHeight Height (point size) of the font to be displayed (in pixels) (number)
	-- @param flags Additional properties for the font specified by one or more (separated by commas) of the following tokens: (string) <ul><li>MONOCHROME - Font is rendered without antialiasing
	-- @param OUTLINE Font is displayed with a black outline
	-- @param THICKOUTLINE Font is displayed with a thick black outline
	-- @return isValid - 1 if filename refers to a valid font file; otherwise nil (1nil)
	------------------------------------
	-- SetFont

	------------------------------------
	--- Sets the Font object from which the font instance's properties are inherited. This method allows for easy standardization and reuse of font styles. For example, a button's normal font can be set to appear in the same style as many default UI elements by setting its font to "GameFontNormal" -- if Blizzard changes the main UI font in a future patch, or if the user installs another addon which changes the main UI font, the button's font will automatically change to match.
	-- @name Font:SetFontObject
	-- @class function
	-- @param object Reference to a Font object (font)
	-- @param name Global name of a Font object (string)
	------------------------------------
	-- SetFontObject

	------------------------------------
	--- Sets the font instance's horizontal text alignment style
	-- @name Font:SetJustifyH
	-- @class function
	-- @param justify Horizontal text alignment style (string, justifyH) <ul><li>CENTER
	------------------------------------
	-- SetJustifyH

	------------------------------------
	--- Sets the font instance's vertical text alignment style
	-- @name Font:SetJustifyV
	-- @class function
	-- @param justify Vertical text alignment style (string, justifyV) <ul><li>BOTTOM
	------------------------------------
	-- SetJustifyV

	------------------------------------
	--- Sets the color of the font's text shadow
	-- @name Font:SetShadowColor
	-- @class function
	-- @param shadowR Red component of the shadow color (0.0 - 1.0) (number)
	-- @param shadowG Green component of the shadow color (0.0 - 1.0) (number)
	-- @param shadowB Blue component of the shadow color (0.0 - 1.0) (number)
	-- @param shadowAlpha Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetShadowColor

	------------------------------------
	--- Sets the offset of the font instance's text shadow from its text
	-- @name Font:SetShadowOffset
	-- @class function
	-- @param xOffset Horizontal distance between the text and its shadow (in pixels) (number)
	-- @param yOffset Vertical distance between the text and its shadow (in pixels) (number)
	------------------------------------
	-- SetShadowOffset

	------------------------------------
	--- Sets the font instance's amount of spacing between lines
	-- @name Font:SetSpacing
	-- @class function
	-- @param spacing Amount of space between lines of text (in pixels) (number)
	------------------------------------
	-- SetSpacing

	------------------------------------
	--- Sets the font instance's default text color. This color is used for otherwise unformatted text displayed using the font instance; however, portions of the text may be colored differently using the colorString format (commonly seen in hyperlinks).
	-- @name Font:SetTextColor
	-- @class function
	-- @param textR Red component of the text color (0.0 - 1.0) (number)
	-- @param textG Green component of the text color (0.0 - 1.0) (number)
	-- @param textB Blue component of the text color (0.0 - 1.0) (number)
	-- @param textAlpha Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetTextColor

	------------------------------------
	--- Returns whether long lines of text will wrap within or between words
	-- @name FontString:CanNonSpaceWrap
	-- @class function
	-- @return enabled - 1 if long lines of text will wrap at any character boundary (i.e possibly in the middle of a word); nil to only wrap at whitespace characters (i.e. only between words) (1nil)
	------------------------------------
	-- CanNonSpaceWrap

	------------------------------------
	--- Returns whether long lines of text in the font string can wrap onto subsequent lines
	-- @name FontString:CanWordWrap
	-- @class function
	-- @return enabled - 1 if long lines of text can wrap onto subsequent lines; otherwise nil (1nil)
	------------------------------------
	-- CanWordWrap

	------------------------------------
	---
	-- @name FontString:GetFieldSize
	-- @class function
	------------------------------------
	-- GetFieldSize

	------------------------------------
	---
	-- @name FontString:GetIndentedWordWrap
	-- @class function
	------------------------------------
	-- GetIndentedWordWrap

	------------------------------------
	--- Returns the height of the text displayed in the font string. This value is based on the text currently displayed; e.g. a long block of text wrapped to several lines results in a greater height than that for a short block of text that fits on fewer lines.
	-- @name FontString:GetStringHeight
	-- @class function
	-- @return height - Height of the text currently displayed in the font string (in pixels) (number)
	------------------------------------
	-- GetStringHeight

	------------------------------------
	--- Returns the width of the text displayed in the font string. This value is based on the text currently displayed; e.g. a short text label results in a smaller width than a longer block of text. Very long blocks of text that don't fit the font string's dimensions all result in similar widths, because this method measures the width of the text displayed, which is truncated with an ellipsis ("бн").
	-- @name FontString:GetStringWidth
	-- @class function
	-- @return width - Width of the text currently displayed in the font string (in pixels) (number)
	------------------------------------
	-- GetStringWidth

	------------------------------------
	--- Returns the text currently set for display in the font string. This is not necessarily the text actually displayed: text that does not fit within the FontString's dimensions will be truncated with an ellipsis ("бн") for display.
	-- @name FontString:GetText
	-- @class function
	-- @return text - Text to be displayed in the font string (string)
	------------------------------------
	-- GetText

	------------------------------------
	---
	-- @name FontString:GetWrappedWidth
	-- @class function
	------------------------------------
	-- GetWrappedWidth

	------------------------------------
	---
	-- @name FontString:IsTruncated
	-- @class function
	------------------------------------
	-- IsTruncated

	------------------------------------
	--- Creates an opacity gradient over the text in the font string. Seen in the default UI when quest text is presented by a questgiver (if the "Instant Quest Text" feature is not turned on): This method is used with a length of 30 to fade in the letters of the description, starting at the first character; then the start value is incremented in an OnUpdate script, creating the animated fade-in effect.
	-- @name FontString:SetAlphaGradient
	-- @class function
	-- @param start Character position in the font string's text at which the gradient should begin (between 0 and string.len(fontString:GetText()) - 6) (number)
	-- @param length Width of the gradient in pixels, or 0 to restore the text to full opacity (number)
	------------------------------------
	-- SetAlphaGradient

	------------------------------------
	--- Sets the text displayed in the font string using format specifiers. Equivalent to :SetText(format(format, ...)), but does not create a throwaway Lua string object, resulting in greater memory-usage efficiency.
	-- @name FontString:SetFormattedText
	-- @class function
	-- @param formatString A string containing format specifiers (as with string.format()) (string)
	-- @param ... A list of values to be included in the formatted string (list)
	------------------------------------
	-- SetFormattedText

	------------------------------------
	---
	-- @name FontString:SetIndentedWordWrap
	-- @class function
	------------------------------------
	-- SetIndentedWordWrap

	------------------------------------
	--- Sets whether long lines of text will wrap within or between words
	-- @name FontString:SetNonSpaceWrap
	-- @class function
	-- @param enable True to wrap long lines of text at any character boundary (i.e possibly in the middle of a word); false to only wrap at whitespace characters (i.e. only between words) (boolean)
	------------------------------------
	-- SetNonSpaceWrap

	------------------------------------
	--- Sets the text to be displayed in the font string
	-- @name FontString:SetText
	-- @class function
	-- @param text Text to be displayed in the font string (string)
	------------------------------------
	-- SetText

	------------------------------------
	--- Scales the font string's rendered text to a different height. This method scales the image of the text as already rendered at its existing height by the game's graphics engine -- producing an effect which is efficient enough for use in fast animations, but with reduced visual quality in the text. To re-render the text at a new point size, see :SetFont().
	-- @name FontString:SetTextHeight
	-- @class function
	-- @param height Height (point size) to which the text should be scaled (in pixels) (number)
	------------------------------------
	-- SetTextHeight

	------------------------------------
	--- Sets whether long lines of text in the font string can wrap onto subsequent lines
	-- @name FontString:SetWordWrap
	-- @class function
	-- @param enable True to allow long lines of text in the font string to wrap onto subsequent lines; false to disallow (boolean)
	------------------------------------
	-- SetWordWrap

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- NonSpaceWrap
	property "NonSpaceWrap" {
		Get = function(self)
			return (self:CanNonSpaceWrap() and true) or false
		end,
		Set = function(self, flag)
			self:SetNonSpaceWrap(flag)
		end,
		Type = Boolean,
	}
	-- StringHeight
	property "StringHeight" {
		Get = function(self)
			return self:GetStringHeight()
		end,
		Type = Number,
	}
	-- StringWidth
	property "StringWidth" {
		Get = function(self)
			return self:GetStringWidth()
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
		Type = LocaleString,
	}

	------------------------------------------------------
	-- Script Handler
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
endclass "FontString"

partclass "FontString"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(FontString)
endclass "FontString"