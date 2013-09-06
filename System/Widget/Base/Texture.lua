-- Author      : Kurapica
-- Create Date : 6/13/2008 9:27:45 PM
-- ChangeLog
--				2011/03/12	Recode as class
--              2012/09/04  Rotate & Shear method added

-- Check Version
local version = 13
if not IGAS:NewAddon("IGAS.Widget.Texture", version) then
	return
end

_SetPortraitTexture = SetPortraitTexture

class "Texture"
	inherit "LayeredRegion"

	doc [======[
		@name Texture
		@type class
		@desc Texture is used to display pic or color
		@format name, [parent], [layer], [inherits], [sublevel]
		@param name string, the texture's name, access by it's parent
		@param parent widgetObejct, the texture's parent, default UIParent
		@param layer System.Widget.DrawLayer, Graphic layer on which to create the texture; defaults to ARTWORK if not specified
		@param inherits string, Name of a template from which the new texture should inherit
		@param sublevel number, The sub-level on the given graphics layer ranging from -8 to 7. The default value of this argument is 0
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetBlendMode
		@type method
		@desc Returns the blend mode of the texture
		@return System.Widget.AlphaMode
	]======]

	doc [======[
		@name GetHorizTile
		@type method
		@desc
		@return boolean
	]======]

	doc [======[
		@name GetNonBlocking
		@type method
		@desc Returns whether the texture object loads its image file in the background
		@return boolean 1 if the texture object loads its image file in the background
	]======]

	doc [======[
		@name GetTexCoord
		@type method
		@desc Returns corner coordinates for scaling or cropping the texture image
		@return ULx number, Upper left corner X position, as a fraction of the image's width from the left
		@return ULy number, Upper left corner Y position, as a fraction of the image's height from the top
		@return LLx number, Lower left corner X position, as a fraction of the image's width from the left
		@return LLy number, Lower left corner Y position, as a fraction of the image's height from the top
		@return URx number, Upper right corner X position, as a fraction of the image's width from the left
		@return URy number, Upper right corner Y position, as a fraction of the image's height from the top
		@return LRx number, Lower right corner X position, as a fraction of the image's width from the left
		@return LRy number, Lower right corner Y position, as a fraction of the image's height from the top
	]======]

	doc [======[
		@name GetTexture
		@type method
		@desc Returns the path to the texture's image file or the color settings
		@returnformat texturePath
		@returnformat red, green, blue, alpha
		@return texturePath string, the path of the texture's image file
		@return red number, the color's red part
		@return green number, the color's green part
		@return blue number, the color's blue part
		@return alpha number, the color's alpha
	]======]
	function GetTexture(self, ...)
		local value = self.__UI:GetTexture(...)

		if not value then return nil end

		if strmatch(value, "^Portrait%d*") then
			return self.__Unit
		elseif value == "SolidTexture" then
			if self.__Color then
				return self.__Color.r, self.__Color.g, self.__Color.b, self.__Color.a
			else
				return nil
			end
		end

		return self.__UI:GetTexture(...)
	end

	doc [======[
		@name GetVertexColor
		@type method
		@desc Returns the shading color of the texture. For details about vertex color shading
		@return red number, the color's red part
		@return green number, the color's green part
		@return blue number, the color's blue part
		@return alpha number, the color's alpha
	]======]

	doc [======[
		@name GetVertTile
		@type method
		@desc
		@return boolean
	]======]

	doc [======[
		@name IsDesaturated
		@type method
		@desc Returns whether the texture image should be displayed with zero saturation (i.e. converted to grayscale). The texture may not actually be displayed in grayscale if the current display hardware doesn't support that feature;
		@return boolean 1 if the texture should be displayed in grayscale, otherwise nil
	]======]

	doc [======[
		@name SetBlendMode
		@type method
		@desc Sets the blend mode of the texture
		@param mode System.Widget.AlphaMode, Blend mode of the texture
		@return nil
	]======]

	doc [======[
		@name SetDesaturated
		@type method
		@desc Sets whether the texture image should be displayed with zero saturation (i.e. converted to grayscale). Returns nil if the current system does not support texture desaturation; in such cases, this method has no visible effect
		@param desaturate boolean, true to display the texture in grayscale, false to display original texture colors
		@return nil
	]======]

	doc [======[
		@name SetGradient
		@type method
		@desc Sets a gradient color shading for the texture. Gradient color shading does not change the underlying color of the texture image, but acts as a filter
		@param orientation System.Widget.Orientation, Token identifying the direction of the gradient
		@param startR number, Red component of the start color (0.0 - 1.0)
		@param startG number, Green component of the start color (0.0 - 1.0)
		@param startB number, Blue component of the start color (0.0 - 1.0)
		@param endR number, Red component of the end color (0.0 - 1.0)
		@param endG number, Green component of the end color (0.0 - 1.0)
		@param endB number, Blue component of the end color (0.0 - 1.0)
		@return nil
	]======]

	doc [======[
		@name SetGradientAlpha
		@type method
		@desc Sets a gradient color shading for the texture (including opacity in the gradient). Gradient color shading does not change the underlying color of the texture image, but acts as a filter
		@param orientation System.Widget.Orientation, Token identifying the direction of the gradient (string)
		@param startR number, Red component of the start color (0.0 - 1.0)
		@param startG number, Green component of the start color (0.0 - 1.0)
		@param startB number, Blue component of the start color (0.0 - 1.0)
		@param startAlpha number, Alpha (opacity) for the start side of the gradient (0.0 = fully transparent, 1.0 = fully opaque)
		@param endR number, Red component of the end color (0.0 - 1.0)
		@param endG number, Green component of the end color (0.0 - 1.0)
		@param endB number, Blue component of the end color (0.0 - 1.0)
		@param endAlpha number, Alpha (opacity) for the end side of the gradient (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name SetHorizTile
		@type method
		@desc
		@param boolean
		@return nil
	]======]

	doc [======[
		@name SetNonBlocking
		@type method
		@desc Sets whether the texture object loads its image file in the background. Texture loading is normally synchronous, so that UI objects are not shown partially textured while loading; however, non-blocking (asynchronous) texture loading may be desirable in some cases where large numbers of textures need to be loaded in a short time. This feature is used in the default UI's icon chooser window for macros and equipment sets, allowing a large number of icon textures to be loaded without causing the game's frame rate to stagger.
		@param nonBlocking boolean, true to allow texture object to load it's image file in background
		@return nil
	]======]

	doc [======[
		@name SetRotation
		@type method
		@desc Rotates the texture image
		@param radians number, Amount by which the texture image should be rotated, positive values for counter-clockwise rotation, negative for clockwise
		@return nil
	]======]

	doc [======[
		@name SetTexCoord
		@type method
		@desc Sets corner coordinates for scaling or cropping the texture image
		@format left, right, top, bottom
		@format ULx, ULy, LLx, LLy, URx, URy, LRx, LRy
		@param left number, Left edge of the scaled/cropped image, as a fraction of the image's width from the left
		@param right number, Right edge of the scaled/cropped image, as a fraction of the image's width from the left
		@param top number, Top edge of the scaled/cropped image, as a fraction of the image's height from the top
		@param bottom number, Bottom edge of the scaled/cropped image, as a fraction of the image's height from the top
		@param ULx number, Upper left corner X position, as a fraction of the image's width from the left
		@param ULy number, Upper left corner Y position, as a fraction of the image's height from the top
		@param LLx number, Lower left corner X position, as a fraction of the image's width from the left
		@param LLy number, Lower left corner Y position, as a fraction of the image's height from the top
		@param URx number, Upper right corner X position, as a fraction of the image's width from the left
		@param URy number, Upper right corner Y position, as a fraction of the image's height from the top
		@param LRx number, Lower right corner X position, as a fraction of the image's width from the left
		@param LRy number, Lower right corner Y position, as a fraction of the image's height from the top
		@return nil
	]======]

	doc [======[
		@name SetTexture
		@type method
		@desc Sets the texture object's image or color
		@param texture string, Path to a texture image
		@param red number, Red component of the color (0.0 - 1.0)
		@param green number, Green component of the color (0.0 - 1.0)
		@param blue number, Blue component of the color (0.0 - 1.0)
		@param alpha number, Alpha (opacity) for the color (0.0 = fully transparent, 1.0 = fully opaque)
		@return boolean 1 if the texture was successfully changed; otherwise nil (1nil)
	]======]
	function SetTexture(self, ...)
		self.__Color = nil
		self.__Unit = nil
		self.__OriginTexCoord = nil

		SetTexCoord(self, 0, 1, 0, 1)

		if select("#", ...) > 0 then
			if type(select(1, ...)) == "string" then
				return self.__UI:SetTexture(select(1, ...))
			elseif type(select(1, ...)) == "number" then
				local r, g, b, a = ...

				r = (r and type(r) == "number" and ((r < 0 and 0) or (r > 1 and 1) or r)) or 0
				g = (g and type(g) == "number" and ((g < 0 and 0) or (g > 1 and 1) or g)) or 0
				b = (b and type(b) == "number" and ((b < 0 and 0) or (b > 1 and 1) or b)) or 0
				a = (a and type(a) == "number" and ((a < 0 and 0) or (a > 1 and 1) or a)) or 1

				self.__Color = ColorType(r, g, b, a)
				return self.__UI:SetTexture(r, g, b, a)
			end
		end
		return self.__UI:SetTexture(nil)
	end

	doc [======[
		@name SetVertTile
		@type method
		@desc
		@param boolean
		@return nil
	]======]

	doc [======[
		@name SetPortraitUnit
		@type method
		@desc Paint a Texture object with the specified unit's portrait
		@param unit string, the unit to be painted
		@return nil
	]======]
	function SetPortraitUnit(self, ...)
		self.__Color = nil
		self.__Unit = nil
		self.__OriginTexCoord = nil

		local unit = select(1, ...)

		SetTexCoord(self, 0, 1, 0, 1)

		if unit and type(unit) == "string" and UnitExists(unit) then
			self.__Unit = unit
			return _SetPortraitTexture(self.__UI, unit)
		else
			return self.__UI:SetTexture(nil)
		end
	end

	doc [======[
		@name SetPortraitTexture
		@type method
		@desc Sets the texture to be displayed from a file applying circular opacity mask making it look round like portraits
		@param texture string, the texture file path
		@return nil
	]======]
	function SetPortraitTexture(self, ...)
		local path = select(1, ...)

		self.__Portrait = nil

		if path and type(path) == "string" then
			self.__Portrait = path
			return SetPortraitToTexture(self.__UI, path)
		end

		return SetPortraitToTexture(self.__UI, nil)
	end

	doc [======[
		@name RotateRaid
		@type method
		@desc Rotate texture for radian with current texcoord settings
		@param radian number, the rotation raidian
		@return nil
	]======]
	function RotateRadian(self, radian)
		if type(radian) ~= "number" then
			error("Usage: Texture:RotateRadian(radian) - 'radian' must be number.", 2)
		end

		if not self.__OriginTexCoord then
			self.__OriginTexCoord = {self:GetTexCoord()}
			self.__OriginWidth = self.Width
			self.__OriginHeight = self.Height
		end

		while radian < 0 do
			radian = radian + 2 * math.pi
		end
		radian = radian % (2 * math.pi)

		local angle = radian % (math.pi /2)

		local left = self.__OriginTexCoord[1]
		local top = self.__OriginTexCoord[2]
		local right = self.__OriginTexCoord[7]
		local bottom = self.__OriginTexCoord[8]

		local dy = self.__OriginWidth * math.cos(angle) * math.sin(angle) * (bottom-top) / self.__OriginHeight
		local dx = self.__OriginHeight * math.cos(angle) * math.sin(angle) * (right - left) / self.__OriginWidth
		local ox = math.cos(angle) * math.cos(angle) * (right-left)
		local oy = math.cos(angle) * math.cos(angle) * (bottom-top)

		local newWidth = self.__OriginWidth*math.cos(angle) + self.__OriginHeight*math.sin(angle)
		local newHeight = self.__OriginWidth*math.sin(angle) + self.__OriginHeight*math.cos(angle)

		local ULx	-- Upper left corner X position, as a fraction of the image's width from the left (number)
		local ULy 	-- Upper left corner Y position, as a fraction of the image's height from the top (number)
		local LLx 	-- Lower left corner X position, as a fraction of the image's width from the left (number)
		local LLy 	-- Lower left corner Y position, as a fraction of the image's height from the top (number)
		local URx	-- Upper right corner X position, as a fraction of the image's width from the left (number)
		local URy 	-- Upper right corner Y position, as a fraction of the image's height from the top (number)
		local LRx 	-- Lower right corner X position, as a fraction of the image's width from the left (number)
		local LRy 	-- Lower right corner Y position, as a fraction of the image's height from the top (number)

		if radian < math.pi / 2 then
			-- 0 ~ 90
			ULx = left - dx
			ULy = bottom - oy

			LLx = right - ox
			LLy = bottom + dy

			URx = left + ox
			URy = top - dy

			LRx = right + dx
			LRy = top + oy
		elseif radian < math.pi then
			-- 90 ~ 180
			URx = left - dx
			URy = bottom - oy

			ULx = right - ox
			ULy = bottom + dy

			LRx = left + ox
			LRy = top - dy

			LLx = right + dx
			LLy = top + oy

			newHeight, newWidth = newWidth, newHeight
		elseif radian < 3 * math.pi / 2 then
			-- 180 ~ 270
			LRx = left - dx
			LRy = bottom - oy

			URx = right - ox
			URy = bottom + dy

			LLx = left + ox
			LLy = top - dy

			ULx = right + dx
			ULy = top + oy
		else
			-- 270 ~ 360
			LLx = left - dx
			LLy = bottom - oy

			LRx = right - ox
			LRy = bottom + dy

			ULx = left + ox
			ULy = top - dy

			URx = right + dx
			URy = top + oy

			newHeight, newWidth = newWidth, newHeight
		end

		self:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
		self.Width = newWidth
		self.Height = newHeight
	end

	doc [======[
		@name RotateDegree
		@type method
		@desc Rotate texture for degree with current texcoord settings
		@param degree number, the rotation degree
		@return nil
	]======]
	function RotateDegree(self, degree)
		if type(degree) ~= "number" then
			error("Usage: Texture:RotateDegree(degree) - 'degree' must be number.", 2)
		end
		return RotateRadian(self, math.rad(degree))
	end

	doc [======[
		@name Shear
		@type method
		@desc Shear texture for raidian
		@param radian number, the shear radian
		@return nil
	]======]
	function ShearRadian(self, radian)
		if type(radian) ~= "number" then
			error("Usage: Texture:ShearRadian(radian) - 'radian' must be number.", 2)
		end

		if not self.__OriginTexCoord then
			self.__OriginTexCoord = {self:GetTexCoord()}
			self.__OriginWidth = self.Width
			self.__OriginHeight = self.Height
		end

		while radian < - math.pi/2 do
			radian = radian + 2 * math.pi
		end
		radian = radian % (2 * math.pi)

		if radian > math.pi /2 then
			error("Usage: Texture:ShearRadian(radian) - 'radian' must be between -pi/2 and pi/2.", 2)
		end

		local left = self.__OriginTexCoord[1]
		local top = self.__OriginTexCoord[2]
		local right = self.__OriginTexCoord[7]
		local bottom = self.__OriginTexCoord[8]

		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = unpack(self.__OriginTexCoord)

		if radian > 0 then
			ULx = left - (bottom-top)*math.sin(radian)
			LRx = right + (bottom-top)*math.sin(radian)
		elseif radian < 0 then
			radian = math.abs(radian)
			LLx = left - (bottom-top)*math.sin(radian)
			URx = right + (bottom-top)*math.sin(radian)
		end

		self:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
	end

	doc [======[
		@name Shear
		@type method
		@desc Shear texture with degree
		@param degree number, the shear degree
		@return nil
	]======]
	function ShearDegree(self, degree)
		if type(degree) ~= "number" then
			error("Usage: Texture:ShearDegree(degree) - 'degree' must be number.", 2)
		end

		return ShearRadian(self, math.rad(degree))
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name BlendMode
		@type property
		@desc the blend mode of the texture
	]======]
	property "BlendMode" {
		Get = function(self)
			return self:GetBlendMode()
		end,
		Set = function(self, mode)
			self:SetBlendMode(mode)
		end,
		Type = AlphaMode,
	}

	doc [======[
		@name Desaturated
		@type property
		@desc whether the texture image should be displayed with zero saturation
	]======]
	property "Desaturated" {
		Get = function(self)
			return (self:IsDesaturated() and true) or false
		end,
		Set = function(self, desaturation)
			local shaderSupported = self:SetDesaturated(desaturation);
			if ( not shaderSupported ) then
				if ( desaturation ) then
					self:SetVertexColor(0.5, 0.5, 0.5);
				else
					self:SetVertexColor(1.0, 1.0, 1.0);
				end
			end
		end,
		Type = Boolean,
	}

	doc [======[
		@name TexturePath
		@type property
		@desc the texture object's image file path
	]======]
	property "TexturePath" {
		Get = function(self)
			local path = self:GetTexture()

			if path and type(path) == "string" and path ~= "SolidTexture" and not strmatch(path, "^Portrait%d*") then
				return path
			end
		end,
		Set = function(self, path)
			return self:SetTexture(path)
		end,
		Type = String + nil,
	}

	doc [======[
		@name PortraitUnit
		@type property
		@desc the unit be de displayed as a portrait, such as "player", "target"
	]======]
	property "PortraitUnit" {
		Get = function(self)
			local texture = self:GetTexture()

			if texture and type(texture) == "string" and strmatch(texture, "^Portrait%d*") then
				return self.__Unit
			end
		end,
		Set = function(self, unit)
			return self:SetPortraitUnit(unit)
		end,
		Type = String + nil,
	}

	doc [======[
		@name PortraitTexture
		@type property
		@desc the texture to be displayed from a file applying circular opacity mask making it look round like portraits.
	]======]
	property "PortraitTexture" {
		Get = function(self)
			return self.__Portrait
		end,
		Set = function(self, texture)
			return self:SetPortraitTexture(texture)
		end,
		Type = String + nil,
	}

	doc [======[
		@name Color
		@type property
		@desc the texture's color
	]======]
	property "Color" {
		Get = function(self)
			local texture = self:GetTexture()

			if texture == "SolidTexture" then
				return self.__Color or ColorType(0, 0, 0, 1)
			end
		end,
		Set = function(self, color)
			self:SetTexture(color.r, color.g, color.b, color.a)
		end,
		Type = ColorType,
	}

	doc [======[
		@name VertexColor
		@type property
		@desc the color shading for the region's graphics
	]======]
	property "VertexColor" {
		Get = function(self)
			return ColorType(self:GetVertexColor())
		end,
		Set = function(self, color)
			self:SetVertexColor(color.r, color.g, color.b, color.a)
		end,
		Type = ColorType,
	}

	doc [======[
		@name HorizTile
		@type property
		@desc
	]======]
	property "HorizTile" {
		Get = function(self)
			return self:GetHorizTile()
		end,
		Set = function(self, value)
			return self:SetHorizTile(value)
		end,
		Type = Boolean,
	}

	doc [======[
		@name VertTile
		@type property
		@desc
	]======]
	property "VertTile" {
		Get = function(self)
			return self:GetVertTile()
		end,
		Set = function(self, value)
			return self:SetVertTile(value)
		end,
		Type = Boolean,
	}

	doc [======[
		@name NonBlocking
		@type property
		@desc whether the texture object loads its image file in the background
	]======]
	property "NonBlocking" {
		Get = function(self)
			return self:GetNonBlocking() and true or false
		end,
		Set = function(self, value)
			return self:SetNonBlocking(value)
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		if not Object.IsClass(parent, UIObject) or not IGAS:GetUI(parent).CreateTexture then
			error("Usage : Texture(name, parent) : 'parent' - UI element expected.", 2)
		end
		return IGAS:GetUI(parent):CreateTexture(nil, ...)
	end

	__Arguments__{ Argument{ Name = "Name" }, Argument{ Name = "Parent" }, Argument{ Name = "Layer" }, Argument{ Name = "Inherit" }, Argument{ Name = "Sublevel" } }
endclass "Texture"

partclass "Texture"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Texture)
endclass "Texture"