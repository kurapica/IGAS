-- Author      : Kurapica
-- Create Date : 7/16/2008 12:21
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Minimap is a frame type whose backdrop is filled in with a top-down representation of the area around the character being played.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name Minimap
-- @class table
-- @field Zoom the minimap's current zoom level
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Minimap", version) then
	return
end

class "Minimap"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the location of the last "ping" on the minimap. Coordinates are pixel distances relative to the center of the minimap (not fractions of the minimap's size as with :GetPingPosition()); positive coordinates are above or to the right of the center, negative are below or to the left.
	-- @name Minimap:GetPingPosition
	-- @class function
	-- @return x - Horizontal coordinate of the "ping" position (number)
	-- @return y - Vertical coordinate of the "ping" position (number)
	------------------------------------
	-- GetPingPosition

	------------------------------------
	--- Returns the minimap's current zoom level
	-- @name Minimap:GetZoom
	-- @class function
	-- @return zoomLevel - Index of the current zoom level (between 0 for the widest possible zoom and (minimap:GetZoomLevels()- 1) for the narrowest possible zoom) (number)
	------------------------------------
	-- GetZoom

	------------------------------------
	--- Returns the number of available zoom settings for the minimap
	-- @name Minimap:GetZoomLevels
	-- @class function
	-- @return zoomLevels - Number of available zoom settings for the minimap (number)
	------------------------------------
	-- GetZoomLevels

	------------------------------------
	--- "Pings" the minimap at a given location. Coordinates are pixel distances relative to the center of the minimap (not fractions of the minimap's size as with :GetPingPosition()); positive coordinates are above or to the right of the center, negative are below or to the left.
	-- @name Minimap:PingLocation
	-- @class function
	-- @param x Horizontal coordinate of the "ping" position (in pixels) (number)
	-- @param y Vertical coordinate of the "ping" position (in pixels) (number)
	------------------------------------
	-- PingLocation

	------------------------------------
	--- Sets the texture used to display quest and tracking icons on the minimap. The replacement texture must match the specifications of the default texture (Interface\\Minimap\\ObjectIcons): 256 pixels wide by 64 pixels tall, containing an 8x2 grid of icons each 32x32 pixels square.
	-- @name Minimap:SetBlipTexture
	-- @class function
	-- @param filename Path to a texture containing display quest and tracking icons for the minimap (string)
	------------------------------------
	-- SetBlipTexture

	------------------------------------
	--- Sets the texture used to display party and raid members on the minimap. Usefulness of this method to addons is limited, as the replacement texture must match the specifications of the default texture (Interface\\Minimap\\PartyRaidBlips): 256 pixels wide by 128 pixels tall, containing an 8x4 grid of icons each 32x32 pixels square.
	-- @name Minimap:SetClassBlipTexture
	-- @class function
	-- @param filename Path to a texture containing icons for party and raid members (string)
	------------------------------------
	-- SetClassBlipTexture

	------------------------------------
	--- Sets the texture used to the player's corpse when located beyond the scope of the minimap. The default texture is Interface\\Minimap\\ROTATING-MINIMAPCORPSEARROW.
	-- @name Minimap:SetCorpsePOIArrowTexture
	-- @class function
	-- @param filename Path to a texture image (string)
	------------------------------------
	-- SetCorpsePOIArrowTexture

	------------------------------------
	--- Sets the texture used to display various points of interest on the minimap. Usefulness of this method to addons is limited, as the replacement texture must match the specifications of the default texture (Interface\\Minimap\\POIIcons): a 256x256 pixel square containing a 16x16 grid of icons each 16x16 pixels square.
	-- @name Minimap:SetIconTexture
	-- @class function
	-- @param filename Path to a texture containing icons for various map landmarks (string)
	------------------------------------
	-- SetIconTexture

	------------------------------------
	--- Sets the texture used to mask the shape of the minimap. White areas in the texture define where the dynamically drawn minimap is visible. The default mask (Textures\\MinimapMask) is circular; a texture image consisting of an all-white square will result in a square minimap.
	-- @name Minimap:SetMaskTexture
	-- @class function
	-- @param filename Path to a texture used to mask the shape of the minimap (string)
	------------------------------------
	-- SetMaskTexture

	------------------------------------
	--- Sets the texture used to represent the player on the minimap. The default texture is Interface\Minimap\MinimapArrow.
	-- @name Minimap:SetPlayerTexture
	-- @class function
	-- @param filename Path to a texture image (string)
	------------------------------------
	-- SetPlayerTexture

	------------------------------------
	--- Sets the height of the texture used to represent the player on the minimap
	-- @name Minimap:SetPlayerTextureHeight
	-- @class function
	-- @param height Height of the texture used to represent the player on the minimap (number)
	------------------------------------
	-- SetPlayerTextureHeight

	------------------------------------
	--- Sets the width of the texture used to represent the player on the minimap
	-- @name Minimap:SetPlayerTextureWidth
	-- @class function
	-- @param width Width of the texture used to represent the player on the minimap (number)
	------------------------------------
	-- SetPlayerTextureWidth

	------------------------------------
	--- Sets the texture used to represent points of interest located beyond the scope of the minimap. This texture is used for points of interest such as those which appear when asking a city guard for directions. The default texture is Interface\Minimap\ROTATING-MINIMAPGUIDEARROW.
	-- @name Minimap:SetPOIArrowTexture
	-- @class function
	-- @param filename Path to a texture image (string)
	------------------------------------
	-- SetPOIArrowTexture

	------------------------------------
	--- Sets the texture used to represent static points of interest located beyond the scope of the minimap. This texture is used for static points of interest such as nearby towns and cities. The default texture is Interface\\Minimap\\ROTATING-MINIMAPARROW.
	-- @name Minimap:SetStaticPOIArrowTexture
	-- @class function
	-- @param filename Path to a texture image (string)
	------------------------------------
	-- SetStaticPOIArrowTexture

	------------------------------------
	--- Sets the minimap's zoom level
	-- @name Minimap:SetZoom
	-- @class function
	-- @param zoomLevel Index of a zoom level (between 0 for the widest possible zoom and (minimap:GetZoomLevels()- 1) for the narrowest possible zoom) (number)
	------------------------------------
	-- SetZoom

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	--- Zoom
	property "Zoom" {
		Get = function(self)
			return self:GetZoom()
		end,
		Set = function(self, level)
			self:SetZoom(level)
		end,
		Type = Number,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Minimap(name, parent, ...)
		return UIObject(name, parent, CreateFrame("Minimap", nil, parent, ...))
	end
endclass "Minimap"

partclass "Minimap"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Minimap)
endclass "Minimap"