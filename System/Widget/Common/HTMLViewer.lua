-- Author      : Kurapica
-- Create Date : 2012/12/2
-- Change Log  :

-- Check Version
local version = 1

if not IGAS:NewAddon("IGAS.Widget.HTMLViewer", version) then
	return
end

class "HTMLViewer"
	inherit "ScrollForm"

	doc [======[
		@name HTMLViewer
		@type class
		@desc HTMLViewer is used to view simple html
	]======]

	------------------------------------------------------
	-- Translate
	------------------------------------------------------
	_HTML_Color_Stack = {}

	local function ParseColorToken(token, isEnd, args)
		if isEnd then
			local last
			for i = #_HTML_Color_Stack, 1, -1 do
				last = tremove(_HTML_Color_Stack)
				if last == token then
					if i > 1 then
						return FontColor[_HTML_Color_Stack[i-1]] or FontColor.NORMAL
					else
						return FontColor.CLOSE
					end
				end
			end
			return ""
		else
			tinsert(_HTML_Color_Stack, token)
			if FontColor[token] then
				return FontColor[token]
			else
				return FontColor.NORMAL
			end
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
		wipe(_HTML_Color_Stack)

		if type(text) == "string" and text ~= "" then
			text = text:gsub("<.->", ParseToken)
		else
			text = ""
		end
		return text
	end

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
	function GetFont(self, ...)
		return self.__HTMLViewer:GetFont(...)
	end

	doc [======[
		@name GetFontObject
		@type method
		@desc Returns the Font object from which the properties of a font used in the frame are inherited
		@param element string, name of an HTML element (e.g. p, h1); if omitted, returns information about the frame's default
		@return System.Widget.Font the Font object from which font properties are inherited, or nil if no properties are inherited
	]======]
	function GetFontObject(self, ...)
		return self.__HTMLViewer:GetFontObject(...)
	end

	doc [======[
		@name GetHyperlinkFormat
		@type method
		@desc Returns the format string used for displaying hyperlinks in the frame
		@param format string, Format string used for displaying hyperlinks in the frame
		@return nil
	]======]
	function GetHyperlinkFormat(self, ...)
		return self.__HTMLViewer:GetHyperlinkFormat(...)
	end

	doc [======[
		@name GetHyperlinksEnabled
		@type method
		@desc Returns whether hyperlinks in the frame's text are interactive
		@return boolean 1 if hyperlinks in the frame's text are interactive; otherwise nil
	]======]
	function GetHyperlinksEnabled(self, ...)
		return self.__HTMLViewer:GetHyperlinksEnabled(...)
	end

	doc [======[
		@name GetIndentedWordWrap
		@type method
		@desc Returns whether long lines of text are indented when wrapping
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return boolean 1 if long lines of text are indented when wrapping; otherwise nil
	]======]
	function GetIndentedWordWrap(self, ...)
		return self.__HTMLViewer:GetIndentedWordWrap(...)
	end

	doc [======[
		@name GetJustifyH
		@type method
		@desc Returns the horizontal alignment style for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return System.Widget.JustifyHType horizontal text alignment style
	]======]
	function GetJustifyH(self, ...)
		return self.__HTMLViewer:GetJustifyH(...)
	end

	doc [======[
		@name GetJustifyV
		@type method
		@desc Returns the vertical alignment style for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return System.Widget.JustifyVType vertical text alignment style
	]======]
	function GetJustifyV(self, ...)
		return self.__HTMLViewer:GetJustifyV(...)
	end

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
	function GetShadowColor(self, ...)
		return self.__HTMLViewer:GetShadowColor(...)
	end

	doc [======[
		@name GetShadowOffset
		@type method
		@desc Returns the offset of text shadow from text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return xOffset number, Horizontal distance between the text and its shadow (in pixels)
		@return yOffset number, Vertical distance between the text and its shadow (in pixels)
	]======]
	function GetShadowOffset(self, ...)
		return self.__HTMLViewer:GetShadowOffset(...)
	end

	doc [======[
		@name GetSpacing
		@type method
		@desc Returns the amount of spacing between lines of text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@return number amount of space between lines of text (in pixels)
	]======]
	function GetSpacing(self, ...)
		return self.__HTMLViewer:GetSpacing(...)
	end

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
	function GetTextColor(self, ...)
		return self.__HTMLViewer:GetTextColor(...)
	end

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
	function SetFont(self, ...)
		return self.__HTMLViewer:SetFont(...)
	end

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
	function SetFontObject(self, ...)
		return self.__HTMLViewer:SetFontObject(...)
	end

	doc [======[
		@name SetHyperlinkFormat
		@type method
		@desc Sets the format string used for displaying hyperlinks in the frame
		@param format string, format string used for displaying hyperlinks in the frame
		@return nil
	]======]
	function SetHyperlinkFormat(self, ...)
		return self.__HTMLViewer:SetHyperlinkFormat(...)
	end

	doc [======[
		@name SetHyperlinksEnabled
		@type method
		@desc Enables or disables hyperlink interactivity in the frame
		@param enable boolean, true to enable hyperlink interactivity in the frame; false to disable
		@return nil
	]======]
	function SetHyperlinksEnabled(self, ...)
		return self.__HTMLViewer:SetHyperlinksEnabled(...)
	end

	doc [======[
		@name SetIndentedWordWrap
		@type method
		@desc Sets whether long lines of text are indented when wrapping
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param indent boolean, true to indent wrapped lines of text; false otherwise
		@return nil
	]======]
	function SetIndentedWordWrap(self, ...)
		return self.__HTMLViewer:SetIndentedWordWrap(...)
	end

	doc [======[
		@name SetJustifyH
		@type method
		@desc Sets the horizontal alignment style for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param justifyH System.Widget.JustifyHType
		@return nil
	]======]
	function SetJustifyH(self, ...)
		return self.__HTMLViewer:SetJustifyH(...)
	end


	doc [======[
		@name SetJustifyV
		@type method
		@desc Sets the vertical alignment style for text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param justifyV System.Widget.JustifyVType
		@return nil
	]======]
	function SetJustifyV(self, ...)
		return self.__HTMLViewer:SetJustifyV(...)
	end

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
	function SetShadowColor(self, ...)
		return self.__HTMLViewer:SetShadowColor(...)
	end

	doc [======[
		@name SetShadowOffset
		@type method
		@desc Sets the offset of text shadow from text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param xOffset number, Horizontal distance between the text and its shadow (in pixels)
		@param yOffset number, Vertical distance between the text and its shadow (in pixels)
		@return nil
	]======]
	function SetShadowOffset(self, ...)
		return self.__HTMLViewer:SetShadowOffset(...)
	end

	doc [======[
		@name SetSpacing
		@type method
		@desc Sets the amount of spacing between lines of text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param spacing number, amount of space between lines of text (in pixels)
		@return nil
	]======]
	function SetSpacing(self, ...)
		return self.__HTMLViewer:SetSpacing(...)
	end

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
	function SetText(self, text)
		self.__HTMLContent = text
		return self.__HTMLViewer:SetText(ParseHTML(text))
	end

	doc [======[
		@name GetText
		@type method
		@desc Gets the contents of the htmlViewer
		@return string
	]======]
	function GetText(self)
		return self.__HTMLContent
	end

	doc [======[
		@name SetTextColor
		@type method
		@desc Sets the color of text in the frame
		@param element string, name of an HTML element for which to return text style information (e.g. p, h1); if omitted, returns information about the frame's default text style
		@param textR number, Red component of the text color (0.0 - 1.0)
		@param textG number, Green component of the text color (0.0 - 1.0)
		@param textB number, Blue component of the text color (0.0 - 1.0)
		@param textAlpha number, Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]
	function SetTextColor(self, ...)
		return self.__HTMLViewer:SetTextColor(...)
	end

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
			return self:GetHyperlinksEnabled() and true or false
		end,
		Set = function(self, state)
			self:SetHyperlinksEnabled(state)
		end,
		Type = Boolean,
	}

	doc [======[
		@name Text
		@type property
		@desc The content of the html viewer
	]======]
	property "Text" {
		Get = function(self)
			return self:GetText()
		end,
		Set = function(self, value)
			self:SetText(value)
		end,
		Type = String + nil,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnHyperlinkClick(self, linkData, link, button)
		return self.Parent:Fire("OnHyperlinkClick", linkData, link, button)
	end

	local function OnHyperlinkEnter(self, linkData, link)
		return self.Parent:Fire("OnHyperlinkEnter", linkData, link)
	end

	local function OnHyperlinkLeave(self, linkData, link)
		return self.Parent:Fire("OnHyperlinkLeave", linkData, link)
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function HTMLViewer(self, name, parent)
		local html = SimpleHTML("HTMLViewer", self)
		self.ScrollChild = html

		html:SetFontObject("GameFontNormal")
		html.HyperlinksEnabled = true
		html:SetHyperlinkFormat("|cff00FF00|H%s|h%s|h|r")
		html:SetTextColor(1, 1, 1)

		self.__HTMLViewer = html

		html.OnHyperlinkClick = html.OnHyperlinkClick + OnHyperlinkClick
		html.OnHyperlinkEnter = html.OnHyperlinkEnter + OnHyperlinkEnter
		html.OnHyperlinkLeave = html.OnHyperlinkLeave + OnHyperlinkLeave
	end
endclass "HTMLViewer"
