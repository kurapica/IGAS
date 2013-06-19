------------------------------------------------------
-- Author      : Kurapica
-- Create Date : 2012/06/28
-- ChangeLog

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFFont", version) then
	return
end

interface "IFFont"

	doc [======[
		@name IFFont
		@type interface
		@desc IFFont is the interface for the font frames
	]======]

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetFont
		@type method
		@desc Returns the font instance's basic font properties
		@return filename string, path to a font file (string)
		@return fontHeight number, height (point size) of the font to be displayed (in pixels) (number)
		@return flags string, additional properties for the font specified by one or more (separated by commas)
	]======]

	doc [======[
		@name GetFontObject
		@type method
		@desc Returns the Font object from which the font instance's properties are inherited
		@return System.Widget.Font the Font object from which the font instance's properties are inherited, or nil if the font instance has no inherited properties
	]======]
	function GetFontObject(self)
		return IGAS:GetWrapper(self.__UI:GetFontObject())
	end

	doc [======[
		@name GetJustifyH
		@type method
		@desc Returns the font instance's horizontal text alignment style
		@return System.Widget.JustifyHType
	]======]

	doc [======[
		@name GetJustifyV
		@type method
		@desc Returns the font instance's vertical text alignment style
		@return System.Widget.JustifyVType
	]======]

	doc [======[
		@name GetShadowColor
		@type method
		@desc Returns the color of the font's text shadow
		@return shadowR number, Red component of the shadow color (0.0 - 1.0)
		@return shadowG number, Green component of the shadow color (0.0 - 1.0)
		@return shadowB number, Blue component of the shadow color (0.0 - 1.0)
		@return shadowAlpha number, Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name GetShadowOffset
		@type method
		@desc Returns the offset of the font instance's text shadow from its text
		@return xOffset number, Horizontal distance between the text and its shadow (in pixels)
		@return yOffset number, Vertical distance between the text and its shadow (in pixels)
	]======]

	doc [======[
		@name GetSpacing
		@type method
		@desc Returns the font instance's amount of spacing between lines
		@return number amount of space between lines of text (in pixels)
	]======]

	doc [======[
		@name GetTextColor
		@type method
		@desc Returns the font instance's default text color
		@return textR number, Red component of the text color (0.0 - 1.0)
		@return textG number, Green component of the text color (0.0 - 1.0)
		@return textB number, Blue component of the text color (0.0 - 1.0)
		@return textAlpha number, Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name SetFont
		@type method
		@desc Sets the font instance's basic font properties
		@param filename string, path to a font file
		@param fontHeight number, height (point size) of the font to be displayed (in pixels)
		@param flags string, additional properties for the font specified by one or more (separated by commas) of the following tokens: MONOCHROME, OUTLINE, THICKOUTLINE
		@return boolean 1 if filename refers to a valid font file; otherwise nil
	]======]

	doc [======[
		@name SetFontObject
		@type method
		@desc Sets the Font object from which the font instance's properties are inherited
		@format fontObject|fontName
		@param fontObject System.Widget.Font, a font object
		@param fontName string, global font object's name
		@return nil
	]======]

	doc [======[
		@name SetJustifyH
		@type method
		@desc Sets the font instance's horizontal text alignment style
		@param justifyH System.Widget.JustifyHType
		@return nil
	]======]

	doc [======[
		@name SetJustifyV
		@type method
		@desc Sets the font instance's vertical text alignment style
		@param justifyV System.Widget.JustifyVType
		@return nil
	]======]

	doc [======[
		@name SetShadowColor
		@type method
		@desc Sets the color of the font's text shadow
		@param shadowR number, Red component of the shadow color (0.0 - 1.0)
		@param shadowG number, Green component of the shadow color (0.0 - 1.0)
		@param shadowB number, Blue component of the shadow color (0.0 - 1.0)
		@param shadowAlpha number, Alpha (opacity) of the text's shadow (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name SetShadowOffset
		@type method
		@desc Sets the offset of the font instance's text shadow from its text
		@param xOffset number, Horizontal distance between the text and its shadow (in pixels)
		@param yOffset number, Vertical distance between the text and its shadow (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetSpacing
		@type method
		@desc Sets the font instance's amount of spacing between lines
		@param spacing number, amount of space between lines of text (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetTextColor
		@type method
		@desc Sets the font instance's default text color. This color is used for otherwise unformatted text displayed using the font instance
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
		@name Font
		@type property
		@desc the font's defined table, contains font path, height and flags' settings
	]======]
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

	doc [======[
		@name FontObject
		@type property
		@desc the Font object
	]======]
	property "FontObject" {
		Get = function(self)
			return self:GetFontObject()
		end,
		Set = function(self, fontObject)
			self:SetFontObject(fontObject)
		end,
		Type = Font + String + nil,
	}

	doc [======[
		@name JustifyH
		@type property
		@desc the fontstring's horizontal text alignment style
	]======]
	property "JustifyH" {
		Get = function(self)
			return self:GetJustifyH()
		end,
		Set = function(self, justifyH)
			self:SetJustifyH(justifyH)
		end,
		Type = JustifyHType,
	}

	doc [======[
		@name JustifyV
		@type property
		@desc the fontstring's vertical text alignment style
	]======]
	property "JustifyV" {
		Get = function(self)
			return self:GetJustifyV()
		end,
		Set = function(self, justifyV)
			self:SetJustifyV(justifyV)
		end,
		Type = JustifyVType,
	}

	doc [======[
		@name ShadowColor
		@type property
		@desc the color of the font's text shadow
	]======]
	property "ShadowColor" {
		Get = function(self)
			return ColorType(self:GetShadowColor())
		end,
		Set = function(self, color)
			self:SetShadowColor(color.r, color.g, color.b, color.a)
		end,
		Type = ColorType,
	}

	doc [======[
		@name ShadowOffset
		@type property
		@desc the offset of the fontstring's text shadow from its text
	]======]
	property "ShadowOffset" {
		Get = function(self)
			return Dimension(self:GetShadowOffset())
		end,
		Set = function(self, offset)
			self:SetShadowOffset(offset.x, offset.y)
		end,
		Type = Dimension,
	}

	doc [======[
		@name Spacing
		@type property
		@desc the fontstring's amount of spacing between lines
	]======]
	property "Spacing" {
		Get = function(self)
			return self:GetSpacing()
		end,
		Set = function(self, spacing)
			self:SetSpacing(spacing)
		end,
		Type = Number,
	}

	doc [======[
		@name TextColor
		@type property
		@desc the fontstring's default text color
	]======]
	property "TextColor" {
		Get = function(self)
			return ColorType(self:GetTextColor())
		end,
		Set = function(self, color)
			self:SetTextColor(color.r, color.g, color.b, color.a)
		end,
		Type = ColorType,
	}
endinterface "IFFont"
