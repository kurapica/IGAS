-- Author      : Kurapica
-- Create Date : 6/13/2008 5:22:03 PM
-- ChangeLog
--				2011/03/12	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- LayeredRegion is an abstract UI type that groups together the functionality of layered graphical regions, specifically Textures and FontStrings.
-- <br><br>inherit <a href=".\Region.html">Region</a> For all methods, properties and scriptTypes
-- @name LayeredRegion
-- @class table
-- @field DrawLayer the layer at which the region's graphics are drawn relative to others in its frame
-- @field VertexColor the color shading for the region's graphics
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 4
if not IGAS:NewAddon("IGAS.Widget.LayeredRegion", version) then
	return
end

class "LayeredRegion"
	inherit "Region"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the draw layer for the Region
	-- @name LayeredRegion:GetDrawLayer
	-- @class function
	-- @return the draw layer for the Region
	-- @usage LayeredRegion:GetDrawLayer()
	------------------------------------
	-- GetDrawLayer

	------------------------------------
	--- Sets the draw layer for the Region
	-- @name LayeredRegion:SetDrawLayer
	-- @class function
	-- @param layer String identifying a graphics layer;
	-- @usage LayeredRegion:SetDrawLayer("ARTWORK")
	------------------------------------
	-- SetDrawLayer

	------------------------------------
	--- Sets a color shading for the region's graphics. The effect of changing this property differs by the type of region:
	-- @name LayeredRegion:SetVertexColor
	-- @class function
	-- @param red Red component of the color (0.0 - 1.0)
	-- @param green Green component of the color (0.0 - 1.0)
	-- @param blue Blue component of the color (0.0 - 1.0)
	-- @param alpha Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	-- @usage LayeredRegion:SetVertexColor(1, 1, 1, 1)
	------------------------------------
	-- SetVertexColor

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- DrawLayer
	property "DrawLayer" {
		Get = function(self)
			return self:GetDrawLayer()
		end,
		Set = function(self, layer)
			return self:SetDrawLayer(layer)
		end,
		Type = DrawLayer,
	}
	-- VertexColor
	property "VertexColor" {
		Get = function(self)
			return self.__VertexColor or ColorType(1, 1, 1, 1)
		end,
		Set = function(self, color)
			self.__VertexColor = color
			self:SetVertexColor(color.r, color.g, color.b, color.a)
		end,
		Type = ColorType,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function LayeredRegion()
		return
	end
endclass "LayeredRegion"