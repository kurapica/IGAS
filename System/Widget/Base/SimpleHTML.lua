-- Author      : Kurapica
-- Create Date : 7/16/2008 14:36
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- The most sophisticated control over text display is offered by SimpleHTML widgets. When its text is set to a string containing valid HTML markup, a SimpleHTML widget will parse the content into its various blocks and sections, and lay the text out. While it supports most common text commands, a SimpleHTML widget accepts an additional argument to most of these; if provided, the element argument will specify the HTML elements to which the new style information should apply, such as formattedText:SetTextColor("h2", 1, 0.3, 0.1) which will cause all level 2 headers to display in red. If no element name is specified, the settings apply to the SimpleHTML widget's default font.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name SimpleHTML
-- @class table
-- @field HyperlinksEnabled whether hyperlinks in the frame's text are interactive
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.SimpleHTML", version) then
	return
end

class "SimpleHTML"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the mouse clicks a hyperlink in the scrolling message frame or SimpleHTML frame
	-- @name SimpleHTML:OnHyperlinkClick
	-- @class function
	-- @param linkData Essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
	-- @param link Complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	-- @param button Name of the mouse button responsible for the click action
	-- @usage function SimpleHTML:OnHyperlinkClick(linkData, link, button)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHyperlinkClick"

	------------------------------------
	--- ScriptType, Run when the mouse moves over a hyperlink in the scrolling message frame or SimpleHTML frame
	-- @name SimpleHTML:OnHyperlinkEnter
	-- @class function
	-- @param linkData Essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
	-- @param link Complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	-- @usage function SimpleHTML:OnHyperlinkEnter(linkData, link)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHyperlinkEnter"

	------------------------------------
	--- ScriptType, Run when the mouse moves away from a hyperlink in the scrolling message frame or SimpleHTML frame
	-- @name SimpleHTML:OnHyperlinkLeave
	-- @class function
	-- @param linkData Essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
	-- @param link Complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	-- @usage function SimpleHTML:OnHyperlinkLeave(linkData, link)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHyperlinkLeave"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns basic properties of a font used in the frame
	-- @name SimpleHTML:GetFont
	-- @class function
	-- @param element Optional,Name of an HTML element (e.g. p, h1); if omitted, returns information about the frame's default
	-- @return filename - Path to a font file (string)
	-- @return fontHeight - Height (point size) of the font to be displayed (in pixels) (number)
	-- @return flags - Additional properties for the font specified by one or more (separated by commas) of the following tokens:MONOCHROME, OUTLINE, THICKOUTLINE
	-- @usage SimpleHTML:GetFont()
	------------------------------------

	-- GetFont

	------------------------------------
	--- Returns the Font object from which the properties of a font used in the frame are inherited
	-- @name SimpleHTML:GetFontObject
	-- @class function
	-- @param element Optional,Name of an HTML element (e.g. p, h1); if omitted, returns information about the frame's default
	-- @return font - Reference to the Font object from which font properties are inherited, or nil if no properties are inherited
	-- @usage SimpleHTML:GetFontObject()
	------------------------------------

	-- GetFontObject
	function GetFontObject(self, ...)
		return IGAS:GetWrapper(self.__UI:GetFontObject(...))
	end

	------------------------------------
	--- Returns the format string used for displaying hyperlinks in the frame. See :SetHyperlinkFormat() for details.
	-- @name SimpleHTML:GetHyperlinkFormat
	-- @class function
	-- @return format - Format string used for displaying hyperlinks in the frame (string)
	------------------------------------
	-- GetHyperlinkFormat

	------------------------------------
	--- Returns whether hyperlinks in the frame's text are interactive
	-- @name SimpleHTML:GetHyperlinksEnabled
	-- @class function
	-- @return enabled - 1 if hyperlinks in the frame's text are interactive; otherwise nil (1nil)
	------------------------------------
	-- GetHyperlinksEnabled

	------------------------------------
	--- Returns whether long lines of text are indented when wrapping
	-- @name SimpleHTML:GetIndentedWordWrap
	-- @class function
	-- @param element Name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style (string)
	-- @return indent - 1 if long lines of text are indented when wrapping; otherwise nil (1nil)
	------------------------------------
	-- GetIndentedWordWrap

	------------------------------------
	--- Returns the horizontal alignment style for text in the frame
	-- @name SimpleHTML:GetJustifyH
	-- @class function
	-- @param element Name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style (string)
	-- @return justify - Horizontal text alignment style (string, justifyH) <ul><li>CENTER
	------------------------------------
	-- GetJustifyH

	------------------------------------
	--- Returns the vertical alignment style for text in the frame
	-- @name SimpleHTML:GetJustifyV
	-- @class function
	-- @param element Name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style (string)
	-- @return justify - Vertical text alignment style (string, justifyV) <ul><li>BOTTOM
	------------------------------------
	-- GetJustifyV

	------------------------------------
	--- Returns the shadow color for text in the frame
	-- @name SimpleHTML:GetShadowColor
	-- @class function
	-- @param element Name of an HTML element for which to return font information (e.g. p, h1); if omitted, returns information about the frame's default font (string)
	-- @return shadowR - Red component of the shadow color (0.0 - 1.0) (number)
	-- @return shadowG - Green component of the shadow color (0.0 - 1.0) (number)
	-- @return shadowB - Blue component of the shadow color (0.0 - 1.0) (number)
	-- @return shadowAlpha - Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetShadowColor

	------------------------------------
	--- Returns the offset of text shadow from text in the frame
	-- @name SimpleHTML:GetShadowOffset
	-- @class function
	-- @param element Name of an HTML element for which to return font information (e.g. p, h1); if omitted, returns information about the frame's default font (string)
	-- @return xOffset - Horizontal distance between the text and its shadow (in pixels) (number)
	-- @return yOffset - Vertical distance between the text and its shadow (in pixels) (number)
	------------------------------------
	-- GetShadowOffset

	------------------------------------
	--- Returns the amount of spacing between lines of text in the frame
	-- @name SimpleHTML:GetSpacing
	-- @class function
	-- @param element Name of an HTML element for which to return font information (e.g. p, h1); if omitted, returns information about the frame's default font (string)
	-- @return spacing - Amount of space between lines of text (in pixels) (number)
	------------------------------------
	-- GetSpacing

	------------------------------------
	--- Returns the color of text in the frame
	-- @name SimpleHTML:GetTextColor
	-- @class function
	-- @param element Name of an HTML element for which to return font information (e.g. p, h1); if omitted, returns information about the frame's default font (string)
	-- @return textR - Red component of the text color (0.0 - 1.0) (number)
	-- @return textG - Green component of the text color (0.0 - 1.0) (number)
	-- @return textB - Blue component of the text color (0.0 - 1.0) (number)
	-- @return textAlpha - Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetTextColor

	------------------------------------
	--- Sets basic properties of a font used in the frame
	-- @name SimpleHTML:SetFont
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param filename Path to a font file (string)
	-- @param fontHeight Height (point size) of the font to be displayed (in pixels) (number)
	-- @param flags Additional properties for the font specified by one or more (separated by commas) of the following tokens: (string) <ul><li>MONOCHROME - Font is rendered without antialiasing
	-- @param OUTLINE Font is displayed with a black outline
	-- @param THICKOUTLINE Font is displayed with a thick black outline
	-- @return isValid - 1 if filename refers to a valid font file; otherwise nil (1nil)
	------------------------------------
	-- SetFont

	------------------------------------
	--- Sets the Font object from which the properties of a font used in the frame are inherited. This method allows for easy standardization and reuse of font styles. For example, a SimpleHTML frame's normal font can be set to appear in the same style as many default UI elements by setting its font to "GameFontNormal" -- if Blizzard changes the main UI font in a future path, or if the user installs another addon which changes the main UI font, the button's font will automatically change to match.
	-- @name SimpleHTML:SetFontObject
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param font Reference to a Font object (table)
	-- @param name Global name of a Font object (string)
	------------------------------------
	-- SetFontObject

	------------------------------------
	--- Sets the format string used for displaying hyperlinks in the frame. Hyperlinks are specified via HTML in the text input to a SimpleHTML frame, but in order to be handled as hyperlinks by the game's text engine they need to be formatted like the hyperlinks used elsewhere. </p>
	--- <p>This property specifies the translation between formats: its default value of |H%s|h%s|h provides minimal formatting, turning (for example) &lt;a href="achievement:892"&gt;The Right Stuff&lt;/a&gt; into |Hachievement:892|hThe Right Stuff|h. Using a colorString or other formatting may be useful for making hyperlinks distinguishable from other text.
	-- @name SimpleHTML:SetHyperlinkFormat
	-- @class function
	-- @param format Format string used for displaying hyperlinks in the frame (string)
	------------------------------------
	-- SetHyperlinkFormat

	------------------------------------
	--- Enables or disables hyperlink interactivity in the frame. The frame's hyperlink-related script handlers will only be run if hyperlinks are enabled.
	-- @name SimpleHTML:SetHyperlinksEnabled
	-- @class function
	-- @param enable True to enable hyperlink interactivity in the frame; false to disable (boolean)
	------------------------------------
	-- SetHyperlinksEnabled

	------------------------------------
	--- Sets whether long lines of text are indented when wrapping
	-- @name SimpleHTML:SetIndentedWordWrap
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param indent True to indent wrapped lines of text; false otherwise (boolean)
	------------------------------------
	-- SetIndentedWordWrap

	------------------------------------
	--- Sets the horizontal alignment style for text in the frame
	-- @name SimpleHTML:SetJustifyH
	-- @class function
	-- @param element Name of an HTML element for which to set properties (e.g. p, h1); if omitted, sets properties of the frame's default text style (string)
	-- @param justify Horizontal text alignment style (string, justifyH) <ul><li>CENTER
	------------------------------------
	-- SetJustifyH

	------------------------------------
	--- Sets the vertical alignment style for text in the frame
	-- @name SimpleHTML:SetJustifyV
	-- @class function
	-- @param element Name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style (string)
	-- @param justify Vertical text alignment style (string, justifyV) <ul><li>BOTTOM
	------------------------------------
	-- SetJustifyV

	------------------------------------
	--- Sets the shadow color for text in the frame
	-- @name SimpleHTML:SetShadowColor
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param shadowR Red component of the shadow color (0.0 - 1.0) (number)
	-- @param shadowG Green component of the shadow color (0.0 - 1.0) (number)
	-- @param shadowB Blue component of the shadow color (0.0 - 1.0) (number)
	-- @param shadowAlpha Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetShadowColor

	------------------------------------
	--- Returns the offset of text shadow from text in the frame
	-- @name SimpleHTML:SetShadowOffset
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param xOffset Horizontal distance between the text and its shadow (in pixels) (number)
	-- @param yOffset Vertical distance between the text and its shadow (in pixels) (number)
	------------------------------------
	-- SetShadowOffset

	------------------------------------
	--- Sets the amount of spacing between lines of text in the frame
	-- @name SimpleHTML:SetSpacing
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param spacing Amount of space between lines of text (in pixels) (number)
	------------------------------------
	-- SetSpacing

	------------------------------------
	--- Sets the text to be displayed in the SimpleHTML frame. Text for display in the frame can be formatted using a simplified version of HTML markup:</p>
	--- <ul>
	--- <li>For HTML formatting, the entire text must be enclosed in &lt;html&gt;&lt;body&gt; and &lt;/body&gt;&lt;/html&gt; tags.</li>
	--- <li>All tags must be closed (img and br must use self-closing syntax; e.g. &lt;br/&gt;, not &lt;br&gt;).</li>
	--- <li>Tags are case insensitive, but closing tags must match the case of opening tags.</li>
	--- <li>Attribute values must be enclosed in single or double quotation marks (" or ').</li>
	--- <li>Characters occurring in HTML markup must be entity-escaped (&amp;quot; &amp;lt; &amp;gt; &amp;amp;); no other entity-escapes are supported.</li>
	--- <li>Unrecognized tags and their contents are ignored (e.g. given &lt;h1&gt;&lt;foo&gt;bar&lt;/foo&gt;baz&lt;/h1&gt;, only "baz" will appear).</li>
	--- <li>Any HTML parsing error will result in the raw HTML markup being displayed.</li>
	--- </ul>
	--- <p>Only the following tags and attributes are supported:</p>
	--- <ul>
	--- <li><p>p, h1, h2, h3 - Block elements; e.g. &lt;p align="left"&gt;</p>
	--- <ul>
	--- 	<li>align - Text alignment style (optional); allowed values are left, center, and right.</li>
	--- </ul></li>
	--- <li><p>img - Image; may only be used as a block element (not inline with text); e.g. &lt;img src="Interface\Icons\INV_Misc_Rune_01" /&gt;.</p>
	--- <ul>
	--- 	<li>src - Path to the image file (filename extension omitted).</li>
	--- 	<li>align - Alignment of the image block in the frame (optional); allowed values are left, center, and right.</li>
	--- 	<li>width - Width at which to display the image (in pixels; optional).</li>
	--- 	<li>height - Height at which to display the image (in pixels; optional).</li>
	--- </ul></li>
	--- <li><p>a - Inline hyperlink; e.g. &lt;a href="aLink"&gt;text&lt;/a&gt;</p>
	--- <ul>
	--- 	<li>href - String identifying the link; passed as argument to hyperlink-related scripts when the player interacts with the link.</li>
	--- </ul></li>
	--- <li><p>br - Explicit line break in text; e.g. &lt;br /&gt;.</p></li>
	--- </ul>
	--- <p>Inline escape sequences used in FontStrings (e.g. colorStrings) may also be used.
	-- @name SimpleHTML:SetText
	-- @class function
	-- @param text Text (with HTML markup) to be displayed (string)
	------------------------------------
	-- SetText

	------------------------------------
	--- Sets the color of text in the frame
	-- @name SimpleHTML:SetTextColor
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param textR Red component of the text color (0.0 - 1.0) (number)
	-- @param textG Green component of the text color (0.0 - 1.0) (number)
	-- @param textB Blue component of the text color (0.0 - 1.0) (number)
	-- @param textAlpha Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetTextColor

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- HyperlinksEnabled
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