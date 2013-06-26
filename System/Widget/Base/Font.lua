-- Author      : Kurapica
-- Create Date : 6/12/2008 1:13:42 AM
-- ChangeLog
--				2011/03/12	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Font", version) then
	return
end

class "Font"
	inherit "Object"

	doc [======[
		@name Font
		@type class
		@desc The Font object is to be shared between other objects that share font characteristics.
		@param name the Font's name
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetObjectType
		@type method
		@desc Get the type of this object.
		@return string the object's class' name
	]======]
	function GetObjectType(self)
		return Reflector.GetName(self:GetClass())
	end

	doc [======[
		@name IsObjectType
		@type method
		@desc Determine if this object is of the specified type, or a subclass of that type.
		@param type string, the object type to determined
		@return boolean true if the frame's type is the given type or the given type's sub-type.
	]======]
	function IsObjectType(self, objType)
		if objType then
			if type(objType) == "string" then
				objType = Widget[objType]
			end

			return Reflector.IsClass(objType) and Object.IsClass(self, objType) or false
		end

		return false
	end

	doc [======[
		@name GetName
		@type method
		@desc Get the full path of this object.
		@return string the full path of the object
	]======]

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

	doc [======[
		@name CopyFontObject
		@type method
		@desc Sets the font's properties to match those of another Font object. Unlike Font:SetFontObject(), this method allows one-time reuse of another font object's properties without continuing to inherit future changes made to the other object's properties.
		@format object|name
		@param object System.Widget.Font, reference to a Font object
		@param name string, global name of a Font object
		@return nil
	]======]

	doc [======[
		@name GetAlpha
		@type method
		@desc Returns the opacity for text displayed by the font
		@return number Alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name GetIndentedWordWrap
		@type method
		@desc Gets whether long lines of text are indented when wrapping
		@return boolean
	]======]

	doc [======[
		@name SetAlpha
		@type method
		@desc Sets the opacity for text displayed by the font
		@param alpha number, alpha (opacity) of the text (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name SetIndentedWordWrap
		@type method
		@desc Sets whether long lines of text are indented when wrapping
		@param boolean
		@return nil
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Name
		@type property
		@desc the name of the font object
	]======]
	property "Name" {
		Get = function(self)
			return self:GetName()
		end,
	}

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

	doc [======[
		@name Alpha
		@type property
		@desc the opacity for text displayed by the font
	]======]
	property "Alpha" {
		Get = function(self)
			return self:GetAlpha()
		end,
		Set = function(self, alpha)
			return self:SetAlpha(alpha)
		end,
		Type = ColorFloat,
	}

	doc [======[
		@name IndentedWordWrap
		@type property
		@desc whether long lines of text are indented when wrapping
	]======]
	property "IndentedWordWrap" {
		Get = function(self)
			return self:GetIndentedWordWrap()
		end,
		Set = function(self, flag)
			return self:SetIndentedWordWrap(flag)
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		-- Remove from _G if it exists
		if self:GetName() and IGAS:GetWrapper(_G[self:GetName()]) == self then
			_G[self:GetName()] = nil
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Font(self, name)
		local fontObject = type(name) == "string" and (_G[name] or CreateFont(name)) or name

		if not fontObject or type(fontObject) ~= "table" or type(fontObject[0]) ~= "userdata" then
			error("No font is found.", 2)
		end

		self[0] = fontObject[0]
		self.__UI = fontObject
		fontObject.__Wrapper = self
	end

	------------------------------------------------------
	-- Exist checking
	------------------------------------------------------
	function __exist(fontObject)
		if type(fontObject) == "string" then
			fontObject = _G[fontObject] or fontObject
		end

		if type(fontObject) == "table" and type(fontObject[0]) == "userdata" then
			-- Do Wrapper the blz's UI element

			-- VirtualUIObject's instance will not be checked here.
			if Object.IsClass(fontObject, Font) or not fontObject.GetObjectType then
				-- UIObject's instance will be return here.
				return fontObject
			end

			if fontObject.__Wrapper and Object.IsClass(fontObject.__Wrapper, Font) then
				return fontObject.__Wrapper
			end
		end
	end
endclass "Font"

partclass "Font"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Font, GameFontNormal)
endclass "Font"