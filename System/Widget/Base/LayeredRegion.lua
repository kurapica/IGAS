-- Author      : Kurapica
-- Create Date : 6/13/2008 5:22:03 PM
-- ChangeLog
--				2011/03/12	Recode as class

-- Check Version
local version = 4
if not IGAS:NewAddon("IGAS.Widget.LayeredRegion", version) then
	return
end

class "LayeredRegion"
	inherit "Region"

	doc [======[
		@name LayeredRegion
		@type class
		@desc LayeredRegion is an abstract UI type that groups together the functionality of layered graphical regions, specifically Textures and FontStrings.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetDrawLayer
		@type method
		@desc Returns the draw layer for the Region
		@return System.Widget.DrawLayer
	]======]

	doc [======[
		@name SetDrawLayer
		@type method
		@desc Sets the draw layer for the Region
		@param layer System.Widget.DrawLayer
		@return nil
	]======]

	doc [======[
		@name SetVertexColor
		@type method
		@desc Sets a color shading for the region's graphics.
		@param red number, red component of the color (0.0 - 1.0)
		@param green number, green component of the color (0.0 - 1.0)
		@param blue number, blue component of the color (0.0 - 1.0)
		@param alpha number, alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]
	function SetVertexColor(self, r, g, b, a)
		self.__VertexColor = self.__VertexColor or {}
		self.__VertexColor.r = r
		self.__VertexColor.g = g
		self.__VertexColor.b = b
		self.__VertexColor.a = a

		return IGAS:GetUI(self):SetVertexColor(r, g, b, a)
	end

	doc [======[
		@name GetVertexColor
		@type method
		@desc Gets a color shading for the region's graphics.
		@return red number, red component of the color (0.0 - 1.0)
		@return green number, green component of the color (0.0 - 1.0)
		@return blue number, blue component of the color (0.0 - 1.0)
		@return alpha number, alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	]======]
	function GetVertexColor(self)
		self.__VertexColor = self.__VertexColor or ColorType(1, 1, 1, 1)

		return self.__VertexColor.r, self.__VertexColor.g, self.__VertexColor.b, self.__VertexColor.a
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name DrawLayer
		@type property
		@desc the layer at which the region's graphics are drawn relative to others in its frame
	]======]
	property "DrawLayer" {
		Get = function(self)
			return self:GetDrawLayer()
		end,
		Set = function(self, layer)
			return self:SetDrawLayer(layer)
		end,
		Type = DrawLayer,
	}

	doc [======[
		@name VertexColor
		@type property
		@desc the color shading for the region's graphics
	]======]
	property "VertexColor" {
		Get = function(self)
			return self:GetVertexColor()
		end,
		Set = function(self, color)
			self:SetVertexColor(color.r, color.g, color.b, color.a)
		end,
		Type = ColorType,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "LayeredRegion"