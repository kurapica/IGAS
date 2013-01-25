-- Author      : Kurapica
-- Create Date : 7/16/2008 14:36
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.SimpleHTML", version) then
	return
end

class "SimpleHTML"
	inherit "Frame"

	doc [======[
		@name SimpleHTML
		@type class
		@desc The most sophisticated control over text display is offered by SimpleHTML widgets. When its text is set to a string containing valid HTML markup, a SimpleHTML widget will parse the content into its various blocks and sections, and lay the text out. While it supports most common text commands, a SimpleHTML widget accepts an additional argument to most of these; if provided, the element argument will specify the HTML elements to which the new style information should apply, such as formattedText:SetTextColor("h2", 1, 0.3, 0.1) which will cause all level 2 headers to display in red. If no element name is specified, the settings apply to the SimpleHTML widget's default font.
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	doc [======[
		@name OnHyperlinkClick
		@type script
		@desc Run when the mouse clicks a hyperlink in the SimpleHTML frame
		@param linkData string, essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
		@param link string, complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
		@param button string, name of the mouse button responsible for the click action
	]======]
	script "OnHyperlinkClick"

	doc [======[
		@name OnHyperlinkEnter
		@type script
		@desc Run when the mouse moves over a hyperlink in the SimpleHTML frame
		@param linkData string, essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
		@param link string, complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	]======]
	script "OnHyperlinkEnter"

	doc [======[
		@name OnHyperlinkLeave
		@type script
		@desc Run when the mouse moves away from a hyperlink in the SimpleHTML frame
		@param linkData string, essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
		@param link string, complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	]======]
	script "OnHyperlinkLeave"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetFont
		@type method
		@desc Returns basic properties of a font used in the frame
		@param element Optional,Name of an HTML element (e.g. p, h1); if omitted, returns information about the frame's default
		@return filename string, Path to a font file (string)
		@return fontHeight number, Height (point size) of the font to be displayed (in pixels) (number)
		@return flags string, Additional properties for the font specified by one or more (separated by commas) of the following tokens: (string)
	]======]

	doc [======[
		@name GetFontObject
		@type method
		@desc Returns the Font object from which the properties of a font used in the frame are inherited
		@param element string, name of an HTML element (e.g. p, h1); if omitted, returns information about the frame's default
		@return System.Widget.Font the Font object from which font properties are inherited, or nil if no properties are inherited
	]======]
	function GetFontObject(self, ...)
		return IGAS:GetWrapper(self.__UI:GetFontObject(...))
	end

	doc [======[
		@name GetHyperlinkFormat
		@type method
		@desc Returns the format string used for displaying hyperlinks in the frame
		@param format string, Format string used for displaying hyperlinks in the frame
		@return nil
	]======]

	doc [======[
		@name GetHyperlinksEnabled
		@type method
		@desc Returns whether hyperlinks in the frame's text are interactive
		@return boolean 1 if hyperlinks in the frame's text are interactive; otherwise nil
	]======]

	doc [======[
		@name GetIndentedWordWrap
		@type method
		@desc Returns whether long lines of text are indented when wrapping
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return boolean 1 if long lines of text are indented when wrapping; otherwise nil
	]======]

	doc [======[
		@name GetJustifyH
		@type method
		@desc Returns the horizontal alignment style for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return System.Widget.JustifyHType horizontal text alignment style
	]======]


	doc [======[
		@name GetJustifyV
		@type method
		@desc Returns the vertical alignment style for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return System.Widget.JustifyVType vertical text alignment style
	]======]

	doc [======[
		@name GetShadowColor
		@type method
		@desc Returns the shadow color for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return shadowR number, Red component of the shadow color (0.0 - 1.0)
		@return shadowG number, Green component of the shadow color (0.0 - 1.0)
		@return shadowB number, Blue component of the shadow color (0.0 - 1.0)
		@return shadowAlpha number, Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name GetShadowOffset
		@type method
		@desc Returns the offset of text shadow from text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return xOffset number, Horizontal distance between the text and its shadow (in pixels)
		@return yOffset number, Vertical distance between the text and its shadow (in pixels)
	]======]

	doc [======[
		@name GetSpacing
		@type method
		@desc Returns the amount of spacing between lines of text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return number amount of space between lines of text (in pixels)
	]======]

	doc [======[
		@name GetTextColor
		@type method
		@desc Returns the color of text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return textR number, Red component of the text color (0.0 - 1.0)
		@return textG number, Green component of the text color (0.0 - 1.0)
		@return textB number, Blue component of the text color (0.0 - 1.0)
		@return textAlpha number, Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name SetFont
		@type method
		@desc Sets the font instance's basic font properties
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param filename string, path to a font file
		@param fontHeight number, height (point size) of the font to be displayed (in pixels)
		@param flags string, additional properties for the font specified by one or more (separated by commas) of the following tokens: MONOCHROME, OUTLINE, THICKOUTLINE
		@return boolean 1 if filename refers to a valid font file; otherwise nil
	]======]

	doc [======[
		@name SetFontObject
		@type method
		@desc Sets the Font object from which the font instance's properties are inherited
		@format [element, ]fontObject|fontName
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param fontObject System.Widget.Font, a font object
		@param fontName string, global font object's name
		@return nil
	]======]

	doc [======[
		@name SetHyperlinkFormat
		@type method
		@desc Sets the format string used for displaying hyperlinks in the frame
		@param format string, format string used for displaying hyperlinks in the frame
		@return nil
	]======]

	doc [======[
		@name SetHyperlinksEnabled
		@type method
		@desc Enables or disables hyperlink interactivity in the frame
		@param enable boolean, true to enable hyperlink interactivity in the frame; false to disable
		@return nil
	]======]

	doc [======[
		@name SetIndentedWordWrap
		@type method
		@desc Sets whether long lines of text are indented when wrapping
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param indent boolean, true to indent wrapped lines of text; false otherwise
		@return nil
	]======]

	doc [======[
		@name SetJustifyH
		@type method
		@desc Sets the horizontal alignment style for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param justifyH System.Widget.JustifyHType
		@return nil
	]======]

	doc [======[
		@name SetJustifyV
		@type method
		@desc Sets the vertical alignment style for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param justifyV System.Widget.JustifyVType
		@return nil
	]======]

	doc [======[
		@name SetShadowColor
		@type method
		@desc Sets the shadow color for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param shadowR number, Red component of the shadow color (0.0 - 1.0)
		@param shadowG number, Green component of the shadow color (0.0 - 1.0)
		@param shadowB number, Blue component of the shadow color (0.0 - 1.0)
		@param shadowAlpha number, Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name SetShadowOffset
		@type method
		@desc Sets the offset of text shadow from text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param xOffset number, Horizontal distance between the text and its shadow (in pixels)
		@param yOffset number, Vertical distance between the text and its shadow (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetSpacing
		@type method
		@desc Sets the amount of spacing between lines of text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param spacing number, amount of space between lines of text (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetText
		@type method
		@desc For HTML formatting, the entire text must be enclosed in <html><body> and </body></html> tags.
		<br>All tags must be closed (img and br must use self-closing syntax; e.g. <br/>, not <br >).
		<br>Tags are case insensitive, but closing tags must match the case of opening tags.
		<br>Attribute values must be enclosed in single or double quotation marks (" or ').
		<br>Characters occurring in HTML markup must be entity-escaped (&quot; &lt; &gt; &amp;); no other entity-escapes are supported.
		<br>Unrecognized tags and their contents are ignored (e.g. given <h1><foo>bar</foo>baz</h1>, only "baz" will appear).
		<br>Any HTML parsing error will result in the raw HTML markup being displayed.
		<br>Only the following tags and attributes are supported:
		<br>
		<br>p, h1, h2, h3 - Block elements; e.g. <p align="left">
		<br>
		<br>align - Text alignment style (optional); allowed values are left, center, and right.
		<br>img - Image; may only be used as a block element (not inline with text); e.g. <img src="Interface\Icons\INV_Misc_Rune_01" />.
		<br>
		<br>src - Path to the image file (filename extension omitted).
		<br>align - Alignment of the image block in the frame (optional); allowed values are left, center, and right.
		<br>width - Width at which to display the image (in pixels; optional).
		<br>height - Height at which to display the image (in pixels; optional).
		<br>a - Inline hyperlink; e.g. <a href="aLink">text</a>
		<br>
		<br>href - String identifying the link; passed as argument to hyperlink-related scripts when the player interacts with the link.
		<br>br - Explicit line break in text; e.g. <br />.
		<br>
		@param text string, text(with HTML markup) to be displayed
		@return nil
	]======]

	doc [======[
		@name SetTextColor
		@type method
		@desc ets the color of text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param textR number, Red component of the text color (0.0 - 1.0)
		@param textG number, Green component of the text color (0.0 - 1.0)
		@param textB number, Blue component of the text color (0.0 - 1.0)
		@param textAlpha number, Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name HyperlinksEnabled
		@type property
		@desc Whether hyperlinks in the frame's text are interactive
	]======]
	property "HyperlinksEnabled" {
		Get = function(self)
			return (self:GetHyperlinksEnabled() and true) or false
		end,
		Set = function(self, state)
			self:SetHyperlinksEnabled(state)
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
		return CreateFrame("SimpleHTML", nil, parent, ...)
	end
endclass "SimpleHTML"

partclass "SimpleHTML"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(SimpleHTML)
endclass "SimpleHTML"