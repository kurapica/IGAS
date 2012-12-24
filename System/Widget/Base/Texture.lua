-- Author      : Kurapica
-- Create Date : 6/13/2008 9:27:45 PM
-- ChangeLog
--				2011/03/12	Recode as class
--              2012/09/04  Rotate & Shear method added

----------------------------------------------------------------------------------------------------------------------------------------
--- Texture is used to display pic or color.
-- <br><br>inherit <a href=".\LayeredRegion.html">LayeredRegion</a> For all methods, properties and scriptTypes
-- @name Texture
-- @class table
-- @field BlendMode the blend mode of the texture
-- @field Desaturated whether the texture image should be displayed with zero saturation (i.e. converted to grayscale)
-- @field TexturePath the texture object's image file path
-- @field PortraitUnit the unit be de displayed as a portrait, such as "player", "target"
-- @field PortraitTexture the texture to be displayed from a file applying circular opacity mask making it look round like portraits.
-- @field Color the texture's color
-- @field VertexColor the color shading for the region's graphics
-- @field NonBlocking
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 12
if not IGAS:NewAddon("IGAS.Widget.Texture", version) then
	return
end

_SetPortraitTexture = SetPortraitTexture

class "Texture"
	inherit "LayeredRegion"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the blend mode of the texture
	-- @name Texture:GetBlendMode
	-- @class function
	-- @return mode - Blend mode of the texture (string) <ul><li>ADD - Adds texture color values to the underlying color values, using the alpha channel; light areas in the texture lighten the background while dark areas are more transparent
	-- @return ALPHAKEY - One-bit transparency; pixels with alpha values greater than ~0.8 are treated as fully opaque and all other pixels are treated as fully transparent
	-- @return BLEND - Normal color blending, using any alpha channel in the texture image
	-- @return DISABLE - Ignores any alpha channel, displaying the texture as fully opaque
	-- @return MOD - Ignores any alpha channel in the texture and multiplies texture color values by background color values; dark areas in the texture darken the background while light areas are more transparent
	------------------------------------
	-- GetBlendMode

	------------------------------------
	---
	-- @name Texture:GetHorizTile
	-- @class function
	------------------------------------
	-- GetHorizTile

	------------------------------------
	--- Returns whether the texture object loads its image file in the background. See :SetNonBlocking() for further details.
	-- @name Texture:GetNonBlocking
	-- @class function
	-- @return nonBlocking - 1 if the texture object loads its image file in the background; nil if the game engine is halted while the texture loads (1nil)
	------------------------------------
	-- GetNonBlocking

	------------------------------------
	--- Returns corner coordinates for scaling or cropping the texture image. See Texture:SetTexCoord() example for details.
	-- @name Texture:GetTexCoord
	-- @class function
	-- @return ULx - Upper left corner X position, as a fraction of the image's width from the left (number)
	-- @return ULy - Upper left corner Y position, as a fraction of the image's height from the top (number)
	-- @return LLx - Lower left corner X position, as a fraction of the image's width from the left (number)
	-- @return LLy - Lower left corner Y position, as a fraction of the image's height from the top (number)
	-- @return URx - Upper right corner X position, as a fraction of the image's width from the left (number)
	-- @return URy - Upper right corner Y position, as a fraction of the image's height from the top (number)
	-- @return LRx - Lower right corner X position, as a fraction of the image's width from the left (number)
	-- @return LRy - Lower right corner Y position, as a fraction of the image's height from the top (number)
	------------------------------------
	-- GetTexCoord

	------------------------------------
	--- Returns the path to the texture's image file
	-- @name Texture:GetTexture
	-- @class function
	-- @return texture - Path to the texture image file, or one of the following values: (string) <ul><li>Portrait1 - Texture is set to a generated image (e.g. via SetPortraitTexture())
	-- @return SolidTexture - Texture is set to a solid color instead of an image
	------------------------------------
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

	------------------------------------
	--- Returns the shading color of the texture. For details about vertex color shading, see LayeredRegion:SetVertexColor().
	-- @name Texture:GetVertexColor
	-- @class function
	-- @return red - Red component of the color (0.0 - 1.0) (number)
	-- @return green - Green component of the color (0.0 - 1.0) (number)
	-- @return blue - Blue component of the color (0.0 - 1.0) (number)
	-- @return alpha - Alpha (opacity) for the texture (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetVertexColor

	------------------------------------
	---
	-- @name Texture:GetVertTile
	-- @class function
	------------------------------------
	-- GetVertTile

	------------------------------------
	--- Returns whether the texture image should be displayed with zero saturation (i.e. converted to grayscale). The texture may not actually be displayed in grayscale if the current display hardware doesn't support that feature; see Texture:SetDesaturated() for details.
	-- @name Texture:IsDesaturated
	-- @class function
	-- @return desaturated - 1 if the texture should be displayed in grayscale; otherwise nil (1nil)
	------------------------------------
	-- IsDesaturated

	------------------------------------
	--- Sets the blend mode of the texture
	-- @name Texture:SetBlendMode
	-- @class function
	-- @param mode Blend mode of the texture (string) <ul><li>ADD - Adds texture color values to the underlying color values, using the alpha channel; light areas in the texture lighten the background while dark areas are more transparent
	-- @param ALPHAKEY One-bit transparency; pixels with alpha values greater than ~0.8 are treated as fully opaque and all other pixels are treated as fully transparent
	-- @param BLEND Normal color blending, using any alpha channel in the texture image
	-- @param DISABLE Ignores any alpha channel, displaying the texture as fully opaque
	-- @param MOD Ignores any alpha channel in the texture and multiplies texture color values by background color values; dark areas in the texture darken the background while light areas are more transparent
	------------------------------------
	-- SetBlendMode

	------------------------------------
	--- Sets whether the texture image should be displayed with zero saturation (i.e. converted to grayscale). Returns nil if the current system does not support texture desaturation; in such cases, this method has no visible effect (but still flags the texture object as desaturated). Authors may wish to implement an alternative to desaturation for such cases (see example).
	-- @name Texture:SetDesaturated
	-- @class function
	-- @param desaturate True to display the texture in grayscale; false to display original texture colors (boolean)
	-- @return supported - 1 if the current system supports texture desaturation; otherwise nil (1nil)
	------------------------------------
	-- SetDesaturated

	------------------------------------
	--- Sets a gradient color shading for the texture. Gradient color shading does not change the underlying color of the texture image, but acts as a filter: see LayeredRegion:SetVertexColor() for details.
	-- @name Texture:SetGradient
	-- @class function
	-- @param VERTICAL Start color at the bottom, end color at the top
	------------------------------------
	-- SetGradient

	------------------------------------
	--- Sets a gradient color shading for the texture (including opacity in the gradient). Gradient color shading does not change the underlying color of the texture image, but acts as a filter: see LayeredRegion:SetVertexColor() for details.
	-- @name Texture:SetGradientAlpha
	-- @class function
	-- @param VERTICAL Start color at the bottom, end color at the top
	------------------------------------
	-- SetGradientAlpha

	------------------------------------
	---
	-- @name Texture:SetHorizTile
	-- @class function
	------------------------------------
	-- SetHorizTile

	------------------------------------
	--- Sets whether the texture object loads its image file in the background. Texture loading is normally synchronous, so that UI objects are not shown partially textured while loading; however, non-blocking (asynchronous) texture loading may be desirable in some cases where large numbers of textures need to be loaded in a short time. This feature is used in the default UI's icon chooser window for macros and equipment sets, allowing a large number of icon textures to be loaded without causing the game's frame rate to stagger.
	-- @name Texture:SetNonBlocking
	-- @class function
	-- @param nonBlocking True to allow the texture object to load its image file in the background; false (default) to halt the game engine while the texture loads (boolean)
	------------------------------------
	-- SetNonBlocking

	------------------------------------
	--- Rotates the texture image. This is an efficient shorthand for the more complex Texture:SetTexCoord().
	-- @name Texture:SetRotation
	-- @class function
	-- @param radians Amount by which the texture image should be rotated (in radians; positive values for counter-clockwise rotation, negative for clockwise)  (number)
	------------------------------------
	-- SetRotation

	------------------------------------
	--- Sets corner coordinates for scaling or cropping the texture image. See example for details.
	-- @name Texture:SetTexCoord
	-- @class function
	-- @param left Left edge of the scaled/cropped image, as a fraction of the image's width from the left (number)
	-- @param right Right edge of the scaled/cropped image, as a fraction of the image's width from the left (number)
	-- @param top Top edge of the scaled/cropped image, as a fraction of the image's height from the top (number)
	-- @param bottom Bottom edge of the scaled/cropped image, as a fraction of the image's height from the top (number)
	-- @param ULx Upper left corner X position, as a fraction of the image's width from the left (number)
	-- @param ULy Upper left corner Y position, as a fraction of the image's height from the top (number)
	-- @param LLx Lower left corner X position, as a fraction of the image's width from the left (number)
	-- @param LLy Lower left corner Y position, as a fraction of the image's height from the top (number)
	-- @param URx Upper right corner X position, as a fraction of the image's width from the left (number)
	-- @param URy Upper right corner Y position, as a fraction of the image's height from the top (number)
	-- @param LRx Lower right corner X position, as a fraction of the image's width from the left (number)
	-- @param LRy Lower right corner Y position, as a fraction of the image's height from the top (number)
	------------------------------------
	-- SetTexCoord

	------------------------------------
	--- Sets the texture object's image or color. Returns nil if the texture could not be set (e.g. if the file path is invalid or points to a file which cannot be used as a texture).
	-- @name Texture:SetTexture
	-- @class function
	-- @param texture Path to a texture image (string)
	-- @param red Red component of the color (0.0 - 1.0) (number)
	-- @param green Green component of the color (0.0 - 1.0) (number)
	-- @param blue Blue component of the color (0.0 - 1.0) (number)
	-- @param alpha Alpha (opacity) for the color (0.0 = fully transparent, 1.0 = fully opaque) (number)
	-- @return visible - 1 if the texture was successfully changed; otherwise nil (1nil)
	------------------------------------
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

	------------------------------------
	---
	-- @name Texture:SetVertTile
	-- @class function
	------------------------------------
	-- SetVertTile

	------------------------------------
	--- Paint a Texture object with the specified unit's portrait.
	-- @name Texture:SetPortraitUnit
	-- @class function
	-- @param unit the unit to be painted
	-- @usage Texture:SetPortraitUnit("player")
	------------------------------------
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

	------------------------------------
	--- Sets the texture to be displayed from a file applying circular opacity mask making it look round like portraits.
	-- @name Texture:SetPortraitTexture
	-- @class function
	-- @param texture the texture to be displayed
	-- @usage Texture:SetPortraitTexture([[Interface\Texture\Test]])
	------------------------------------
	function SetPortraitTexture(self, ...)
		local path = select(1, ...)

		self.__Portrait = nil

		if path and type(path) == "string" then
			self.__Portrait = path
			return SetPortraitToTexture(self.__UI, path)
		end

		return SetPortraitToTexture(self.__UI, nil)
	end

	------------------------------------
	--- Rotate texture for rfadian
	-- @name RotateRaid
	-- @type function
	-- @param radian
	------------------------------------
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
			radian = degree + 2 * math.pi
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

	------------------------------------
	--- Rotate texture for degree
	-- @name RotateDegree
	-- @type function
	-- @param degree
	------------------------------------
	function RotateDegree(self, degree)
		if type(degree) ~= "number" then
			error("Usage: Texture:RotateDegree(degree) - 'degree' must be number.", 2)
		end
		return RotateRadian(self, math.rad(degree))
	end

	------------------------------------
	--- Shear texture for raidian
	-- @name Shear
	-- @type function
	-- @param radian
	------------------------------------
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
			radian = degree + 2 * math.pi
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

	------------------------------------
	--- function_description
	-- @name Shear
	-- @type function
	-- @param degree
	-- @return nil
	------------------------------------
	function ShearDegree(self, degree)
		if type(degree) ~= "number" then
			error("Usage: Texture:ShearDegree(degree) - 'degree' must be number.", 2)
		end

		return ShearRadian(self, math.rad(degree))
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	--- BlendMode
	property "BlendMode" {
		Get = function(self)
			return self:GetBlendMode()
		end,
		Set = function(self, mode)
			self:SetBlendMode(mode)
		end,
		Type = AlphaMode,
	}
	--- Desaturated
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
	-- TexturePath
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
	-- PortraitUnit
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
	-- PortraitTexture
	property "PortraitTexture" {
		Get = function(self)
			return self.__Portrait
		end,
		Set = function(self, texture)
			return self:SetPortraitTexture(texture)
		end,
		Type = String + nil,
	}
	-- Color
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
	--- VertexColor
	property "VertexColor" {
		Get = function(self)
			return ColorType(self:GetVertexColor())
		end,
		Set = function(self, color)
			self:SetVertexColor(color.r, color.g, color.b, color.a)
		end,
		Type = ColorType,
	}
	-- HorizTile
	property "HorizTile" {
		Get = function(self)
			return self:GetHorizTile()
		end,
		Set = function(self, value)
			return self:SetHorizTile(value)
		end,
		Type = Boolean,
	}
	-- VertTile
	property "VertTile" {
		Get = function(self)
			return self:GetVertTile()
		end,
		Set = function(self, value)
			return self:SetVertTile(value)
		end,
		Type = Boolean,
	}
	-- NonBlocking
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
	-- Script Handler
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
endclass "Texture"

partclass "Texture"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Texture)
endclass "Texture"