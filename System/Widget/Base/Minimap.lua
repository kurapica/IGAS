-- Author      : Kurapica
-- Create Date : 7/16/2008 12:21
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Minimap", version) then
	return
end

class "Minimap"
	inherit "Frame"

	doc [======[
		@name Minimap
		@type class
		@desc Minimap is a frame type whose backdrop is filled in with a top-down representation of the area around the character being played.
	]======]
	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetPingPosition
		@type method
		@desc Returns the location of the last "ping" on the minimap. Coordinates are pixel distances relative to the center of the minimap (not fractions of the minimap's size as with :GetPingPosition()); positive coordinates are above or to the right of the center, negative are below or to the left.
		@return x number, horizontal coordinate of the "ping" position
		@return y number, vertical coordinate of the "ping" position
	]======]

	doc [======[
		@name GetZoom
		@type method
		@desc Returns the minimap's current zoom level
		@return number Index of the current zoom level (between 0 for the widest possible zoom and (minimap:GetZoomLevels()- 1) for the narrowest possible zoom)
	]======]

	doc [======[
		@name GetZoomLevels
		@type method
		@desc Returns the number of available zoom settings for the minimap
		@return number Number of available zoom settings for the minimap
	]======]

	doc [======[
		@name PingLocation
		@type method
		@desc "Pings" the minimap at a given location. Coordinates are pixel distances relative to the center of the minimap (not fractions of the minimap's size as with :GetPingPosition()); positive coordinates are above or to the right of the center, negative are below or to the left.
		@param x number, horizontal coordinate of the "ping" position (in pixels)
		@param y number, vertical coordinate of the "ping" position (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetBlipTexture
		@type method
		@desc Sets the texture used to display quest and tracking icons on the minimap. The replacement texture must match the specifications of the default texture (Interface\\Minimap\\ObjectIcons): 256 pixels wide by 64 pixels tall, containing an 8x2 grid of icons each 32x32 pixels square.
		@param filename string, path to a texture containing display quest and tracking icons for the minimap
		@return nil
	]======]

	doc [======[
		@name SetClassBlipTexture
		@type method
		@desc Sets the texture used to display party and raid members on the minimap. Usefulness of this method to addons is limited, as the replacement texture must match the specifications of the default texture (Interface\\Minimap\\PartyRaidBlips): 256 pixels wide by 128 pixels tall, containing an 8x4 grid of icons each 32x32 pixels square.
		@param filename string, path to a texture containing icons for party and raid members
		@return nil
	]======]

	doc [======[
		@name SetCorpsePOIArrowTexture
		@type method
		@desc Sets the texture used to the player's corpse when located beyond the scope of the minimap. The default texture is Interface\\Minimap\\ROTATING-MINIMAPCORPSEARROW.
		@param filename string, path to a texture image
		@return nil
	]======]

	doc [======[
		@name SetIconTexture
		@type method
		@desc Sets the texture used to display various points of interest on the minimap. Usefulness of this method to addons is limited, as the replacement texture must match the specifications of the default texture (Interface\\Minimap\\POIIcons): a 256x256 pixel square containing a 16x16 grid of icons each 16x16 pixels square.
		@param filename string, path to a texture containing icons for various map landmarks
		@return nil
	]======]

	doc [======[
		@name SetMaskTexture
		@type method
		@desc Sets the texture used to mask the shape of the minimap. White areas in the texture define where the dynamically drawn minimap is visible. The default mask (Textures\\MinimapMask) is circular; a texture image consisting of an all-white square will result in a square minimap.
		@param filename string, path to a texture used to mask the shape of the minimap
		@return nil
	]======]

	doc [======[
		@name SetPlayerTexture
		@type method
		@desc Sets the texture used to represent the player on the minimap. The default texture is Interface\Minimap\MinimapArrow.
		@param filename string, path to a texture image
		@return nil
	]======]

	doc [======[
		@name SetPlayerTextureHeight
		@type method
		@desc Sets the height of the texture used to represent the player on the minimap
		@param height number, Height of the texture used to represent the player on the minimap
		@return nil
	]======]

	doc [======[
		@name SetPlayerTextureWidth
		@type method
		@desc Sets the width of the texture used to represent the player on the minimap
		@param width number, Width of the texture used to represent the player on the minimap
		@return nil
	]======]

	doc [======[
		@name SetPOIArrowTexture
		@type method
		@desc Sets the texture used to represent points of interest located beyond the scope of the minimap. This texture is used for points of interest such as those which appear when asking a city guard for directions. The default texture is Interface\Minimap\ROTATING-MINIMAPGUIDEARROW.
		@param filename string, ath to a texture image
		@return nil
	]======]

	doc [======[
		@name SetStaticPOIArrowTexture
		@type method
		@desc Sets the texture used to represent static points of interest located beyond the scope of the minimap. This texture is used for static points of interest such as nearby towns and cities. The default texture is Interface\\Minimap\\ROTATING-MINIMAPARROW.
		@param filename string, path to a texture image
		@return nil
	]======]

	doc [======[
		@name SetZoom
		@type method
		@desc Sets the minimap's zoom level
		@param zoomLevel number, index of a zoom level (between 0 for the widest possible zoom and (minimap:GetZoomLevels()- 1) for the narrowest possible zoom)
		@return nil
	]======]

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("Minimap", nil, parent, ...)
	end
endclass "Minimap"

partclass "Minimap"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Minimap)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Zoom
		@type property
		@desc the minimap's current zoom level
	]======]
	__Auto__{ Method = true, Type = Number }
	property "Zoom" {}

endclass "Minimap"