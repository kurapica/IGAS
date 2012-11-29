------------------------------------------------------
-- Author      : Kurapica
-- Create Date : 2012/06/28
-- ChangeLog

------------------------------------------------------
--- IFFont is the interface for the font frames
-- @name IFFont
-- @class interface
-- @field Font the font's defined table, contains font path, height and flags' settings
-- @field FontObject the `Font` object
-- @field JustifyH the font instance's horizontal text alignment style
-- @field JustifyV the font instance's vertical text alignment style
-- @field ShadowColor the color of the font's text shadow
-- @field ShadowOffset the offset of the font instance's text shadow from its text
-- @field Spacing the font instance's amount of spacing between lines
-- @field TextColor the font instance's default text color
------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFFont", version) then
	return
end

interface "IFFont"
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
	function GetFontObject(self)
		return IGAS:GetWrapper(self.__UI:GetFontObject())
	end

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

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Font
	property "Font" {
		Get = function(self)
			local font = {}
			local flags

			font.path, font.height, flags = self:GetFont()
			flags = (flags or ""):upper()
			if flags:find("THICKOUTLINE") then
				font.outline = "THICK"
			elseif flags:find("OUTLINE") then
				font.outline = "NORMAL"
			else
				font.outline = "NONE"
			end
			if flags:find("MONOCHROME") then
				font.monochrome = true
			end

			return font
		end,
		Set = function(self, font)
			local flags = ""
			if font.outline then
				if font.outline == "NORMAL" then
					flags = flags.."OUTLINE"
				elseif font.outline == "THICK" then
					flags = flags.."THICKOUTLINE"
				end
			end
			if font.monochrome then
				if flags ~= "" then
					flags = flags..","
				end
				flags = flags.."MONOCHROME"
			end

			self:SetFont(font.path, font.height, flags)
		end,
		Type = FontType,
	}
	-- FontObject
	property "FontObject" {
		Get = function(self)
			return self:GetFontObject()
		end,
		Set = function(self, fontObject)
			self:SetFontObject(fontObject)
		end,
		Type = Font + String + nil,
	}
	-- JustifyH
	property "JustifyH" {
		Get = function(self)
			return self:GetJustifyH()
		end,
		Set = function(self, justifyH)
			self:SetJustifyH(justifyH)
		end,
		Type = JustifyHType,
	}
	-- JustifyV
	property "JustifyV" {
		Get = function(self)
			return self:GetJustifyV()
		end,
		Set = function(self, justifyV)
			self:SetJustifyV(justifyV)
		end,
		Type = JustifyVType,
	}
	-- ShadowColor
	property "ShadowColor" {
		Get = function(self)
			return ColorType(self:GetShadowColor())
		end,
		Set = function(self, color)
			self:SetShadowColor(color.r, color,g, color.b, color.a)
		end,
		Type = ColorType,
	}
	-- ShadowOffset
	property "ShadowOffset" {
		Get = function(self)
			return Dimension(self:GetShadowOffset())
		end,
		Set = function(self, offset)
			self:SetShadowOffset(offset.x, offset.y)
		end,
		Type = Dimension,
	}
	-- Spacing
	property "Spacing" {
		Get = function(self)
			return self:GetSpacing()
		end,
		Set = function(self, spacing)
			self:SetSpacing(spacing)
		end,
		Type = Number,
	}
	-- TextColor
	property "TextColor" {
		Get = function(self)
			return ColorType(self:GetTextColor())
		end,
		Set = function(self, color)
			self:SetTextColor(color.r, color.g, color.b, color.a)
		end,
		Type = ColorType,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endinterface "IFFont"
