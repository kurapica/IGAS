-- Author      : Kurapica
-- Create Date : 2012/12/2
-- Change Log  :

---------------------------------------------------------------------------------------------------------------------------------------
--- HTMLViewer
-- @name HTMLViewer
---------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1

if not IGAS:NewAddon("IGAS.Widget.HTMLViewer", version) then
	return
end

class "HTMLViewer"
	inherit "ScrollForm"

	------------------------------------------------------
	-- Translate
	------------------------------------------------------
	local function ParseColorToken(token, isEnd, args)
		if isEnd then
			return FontColor.CLOSE
		elseif FontColor[token] then
			return FontColor[token]
		else
			return FontColor.NORMAL
		end
	end

	------------------------------------------------------
	-- Tokens
	------------------------------------------------------
	_HTML_TOKEN_MAP = {}

	------------------------------------------------------
	--- Colors : <red>some text</red>
	------------------------------------------------------
	for _, colorname in ipairs(Reflector.GetEnums(FontColor)) do
		colorname = colorname:lower()

		if colorname ~= "close" then
			_HTML_TOKEN_MAP[colorname] = ParseColorToken
		end
	end

	------------------------------------------------------
	-- Parse Html
	------------------------------------------------------
	local function ParseToken(set)
		if set and set:len() >= 3 then
			if set:sub(2, 2) == "/" then
				local token = set:match("</(%w+)")

				if token and _HTML_TOKEN_MAP[token:lower()] then
					return _HTML_TOKEN_MAP[token:lower()](token:lower(), true)
				else
					return set
				end
			else
				local token, args = set:match("<(%w+)%s*(.*)>")

				if token and _HTML_TOKEN_MAP[token:lower()] then
					return _HTML_TOKEN_MAP[token:lower()](token:lower(), false, args)
				else
					return set
				end
			end
		else
			return set
		end
	end

	local function ParseHTML(text)
		if type(text) == "string" and text ~= "" then
			text = text:gsub("<.->", ParseToken)
		end
		return text
	end

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
	function GetFont(self, ...)
		return self.__HTMLViewer:GetFont(...)
	end

	------------------------------------
	--- Returns the Font object from which the properties of a font used in the frame are inherited
	-- @name SimpleHTML:GetFontObject
	-- @class function
	-- @param element Optional,Name of an HTML element (e.g. p, h1); if omitted, returns information about the frame's default
	-- @return font - Reference to the Font object from which font properties are inherited, or nil if no properties are inherited
	-- @usage SimpleHTML:GetFontObject()
	------------------------------------
	function GetFontObject(self, ...)
		return self.__HTMLViewer:GetFontObject(...)
	end

	------------------------------------
	--- Returns the format string used for displaying hyperlinks in the frame. See :SetHyperlinkFormat() for details.
	-- @name SimpleHTML:GetHyperlinkFormat
	-- @class function
	-- @return format - Format string used for displaying hyperlinks in the frame (string)
	------------------------------------
	function GetHyperlinkFormat(self, ...)
		return self.__HTMLViewer:GetHyperlinkFormat(...)
	end

	------------------------------------
	--- Returns whether hyperlinks in the frame's text are interactive
	-- @name SimpleHTML:GetHyperlinksEnabled
	-- @class function
	-- @return enabled - 1 if hyperlinks in the frame's text are interactive; otherwise nil (1nil)
	------------------------------------
	function GetHyperlinksEnabled(self, ...)
		return self.__HTMLViewer:GetHyperlinksEnabled(...)
	end

	------------------------------------
	--- Returns whether long lines of text are indented when wrapping
	-- @name SimpleHTML:GetIndentedWordWrap
	-- @class function
	-- @param element Name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style (string)
	-- @return indent - 1 if long lines of text are indented when wrapping; otherwise nil (1nil)
	------------------------------------
	function GetIndentedWordWrap(self, ...)
		return self.__HTMLViewer:GetIndentedWordWrap(...)
	end

	------------------------------------
	--- Returns the horizontal alignment style for text in the frame
	-- @name SimpleHTML:GetJustifyH
	-- @class function
	-- @param element Name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style (string)
	-- @return justify - Horizontal text alignment style (string, justifyH) <ul><li>CENTER
	------------------------------------
	function GetJustifyH(self, ...)
		return self.__HTMLViewer:GetJustifyH(...)
	end

	------------------------------------
	--- Returns the vertical alignment style for text in the frame
	-- @name SimpleHTML:GetJustifyV
	-- @class function
	-- @param element Name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style (string)
	-- @return justify - Vertical text alignment style (string, justifyV) <ul><li>BOTTOM
	------------------------------------
	function GetJustifyV(self, ...)
		return self.__HTMLViewer:GetJustifyV(...)
	end

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
	function GetShadowColor(self, ...)
		return self.__HTMLViewer:GetShadowColor(...)
	end

	------------------------------------
	--- Returns the offset of text shadow from text in the frame
	-- @name SimpleHTML:GetShadowOffset
	-- @class function
	-- @param element Name of an HTML element for which to return font information (e.g. p, h1); if omitted, returns information about the frame's default font (string)
	-- @return xOffset - Horizontal distance between the text and its shadow (in pixels) (number)
	-- @return yOffset - Vertical distance between the text and its shadow (in pixels) (number)
	------------------------------------
	function GetShadowOffset(self, ...)
		return self.__HTMLViewer:GetShadowOffset(...)
	end

	------------------------------------
	--- Returns the amount of spacing between lines of text in the frame
	-- @name SimpleHTML:GetSpacing
	-- @class function
	-- @param element Name of an HTML element for which to return font information (e.g. p, h1); if omitted, returns information about the frame's default font (string)
	-- @return spacing - Amount of space between lines of text (in pixels) (number)
	------------------------------------
	function GetSpacing(self, ...)
		return self.__HTMLViewer:GetSpacing(...)
	end

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
	function GetTextColor(self, ...)
		return self.__HTMLViewer:GetTextColor(...)
	end

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
	function SetFont(self, ...)
		return self.__HTMLViewer:SetFont(...)
	end

	------------------------------------
	--- Sets the Font object from which the properties of a font used in the frame are inherited. This method allows for easy standardization and reuse of font styles. For example, a SimpleHTML frame's normal font can be set to appear in the same style as many default UI elements by setting its font to "GameFontNormal" -- if Blizzard changes the main UI font in a future path, or if the user installs another addon which changes the main UI font, the button's font will automatically change to match.
	-- @name SimpleHTML:SetFontObject
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param font Reference to a Font object (table)
	-- @param name Global name of a Font object (string)
	------------------------------------
	function SetFontObject(self, ...)
		return self.__HTMLViewer:SetFontObject(...)
	end

	------------------------------------
	--- Sets the format string used for displaying hyperlinks in the frame. Hyperlinks are specified via HTML in the text input to a SimpleHTML frame, but in order to be handled as hyperlinks by the game's text engine they need to be formatted like the hyperlinks used elsewhere. </p>
	--- <p>This property specifies the translation between formats: its default value of |H%s|h%s|h provides minimal formatting, turning (for example) &lt;a href="achievement:892"&gt;The Right Stuff&lt;/a&gt; into |Hachievement:892|hThe Right Stuff|h. Using a colorString or other formatting may be useful for making hyperlinks distinguishable from other text.
	-- @name SimpleHTML:SetHyperlinkFormat
	-- @class function
	-- @param format Format string used for displaying hyperlinks in the frame (string)
	------------------------------------
	function SetHyperlinkFormat(self, ...)
		return self.__HTMLViewer:SetHyperlinkFormat(...)
	end

	------------------------------------
	--- Enables or disables hyperlink interactivity in the frame. The frame's hyperlink-related script handlers will only be run if hyperlinks are enabled.
	-- @name SimpleHTML:SetHyperlinksEnabled
	-- @class function
	-- @param enable True to enable hyperlink interactivity in the frame; false to disable (boolean)
	------------------------------------
	function SetHyperlinksEnabled(self, ...)
		return self.__HTMLViewer:SetHyperlinksEnabled(...)
	end

	------------------------------------
	--- Sets whether long lines of text are indented when wrapping
	-- @name SimpleHTML:SetIndentedWordWrap
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param indent True to indent wrapped lines of text; false otherwise (boolean)
	------------------------------------
	function SetIndentedWordWrap(self, ...)
		return self.__HTMLViewer:SetIndentedWordWrap(...)
	end

	------------------------------------
	--- Sets the horizontal alignment style for text in the frame
	-- @name SimpleHTML:SetJustifyH
	-- @class function
	-- @param element Name of an HTML element for which to set properties (e.g. p, h1); if omitted, sets properties of the frame's default text style (string)
	-- @param justify Horizontal text alignment style (string, justifyH) <ul><li>CENTER
	------------------------------------
	function SetJustifyH(self, ...)
		return self.__HTMLViewer:SetJustifyH(...)
	end

	------------------------------------
	--- Sets the vertical alignment style for text in the frame
	-- @name SimpleHTML:SetJustifyV
	-- @class function
	-- @param element Name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style (string)
	-- @param justify Vertical text alignment style (string, justifyV) <ul><li>BOTTOM
	------------------------------------
	function SetJustifyV(self, ...)
		return self.__HTMLViewer:SetJustifyV(...)
	end

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
	function SetShadowColor(self, ...)
		return self.__HTMLViewer:SetShadowColor(...)
	end

	------------------------------------
	--- Returns the offset of text shadow from text in the frame
	-- @name SimpleHTML:SetShadowOffset
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param xOffset Horizontal distance between the text and its shadow (in pixels) (number)
	-- @param yOffset Vertical distance between the text and its shadow (in pixels) (number)
	------------------------------------
	function SetShadowOffset(self, ...)
		return self.__HTMLViewer:SetShadowOffset(...)
	end

	------------------------------------
	--- Sets the amount of spacing between lines of text in the frame
	-- @name SimpleHTML:SetSpacing
	-- @class function
	-- @param element Name of an HTML element for which to set font properties (e.g. p, h1); if omitted, sets properties for the frame's default font (string)
	-- @param spacing Amount of space between lines of text (in pixels) (number)
	------------------------------------
	function SetSpacing(self, ...)
		return self.__HTMLViewer:SetSpacing(...)
	end

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
	function SetText(self, text, height)
		if height and height > 0 then
			self.__HTMLViewer.Height = height
			self:FixHeight()
		end
		return self.__HTMLViewer:SetText(ParseHTML(text))
	end

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
	function SetTextColor(self, ...)
		return self.__HTMLViewer:SetTextColor(...)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- HyperlinksEnabled
	property "HyperlinksEnabled" {
		Get = function(self)
			return self:GetHyperlinksEnabled() and true or false
		end,
		Set = function(self, state)
			self:SetHyperlinksEnabled(state)
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnHyperlinkClick(self, linkData, link, button)
		return self.__Container:Fire("OnHyperlinkClick", linkData, link, button)
	end

	local function OnHyperlinkEnter(self, linkData, link)
		return self.__Container:Fire("OnHyperlinkEnter", linkData, link)
	end

	local function OnHyperlinkLeave(self, linkData, link)
		return self.__Container:Fire("OnHyperlinkLeave", linkData, link)
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function HTMLViewer(self, name, parent)
		local container = self.Container

		local html = SimpleHTML("HTMLViewer", container)
		html:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
		html:SetPoint("TOPRIGHT", container, "TOPRIGHT", 0, 0)
		html:SetFontObject("GameFontNormal")

		html.HyperlinksEnabled = true
		html:SetHyperlinkFormat("|H%s|h%s|h")

		html.__Container = self
		self.__HTMLViewer = html

		html.OnHyperlinkClick = html.OnHyperlinkClick + OnHyperlinkClick
		html.OnHyperlinkEnter = html.OnHyperlinkEnter + OnHyperlinkEnter
		html.OnHyperlinkLeave = html.OnHyperlinkLeave + OnHyperlinkLeave

		self:FixHeight()
	end
endclass "HTMLViewer"
