-- Author      : Kurapica
-- Create Date : 7/16/2008 15:10
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- TabardModel is a frame type provided specifically for designing or modifying guild tabards.
-- <br><br>inherit <a href=".\PlayerModel.html">PlayerModel</a> For all methods, properties and scriptTypes
-- @name TabardModel
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.TabardModel", version) then
	return
end

class "TabardModel"
	inherit "PlayerModel"

	------------------------------------------------------
	-- Script
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the image file for the lower portion of the tabard model's current background design
	-- @name TabardModel:GetLowerBackgroundFileName
	-- @class function
	-- @param filename Path to the texture image file for the lower portion of the tabard model's current background design (string)
	------------------------------------
	-- GetLowerBackgroundFileName

	------------------------------------
	--- Returns the image file for the lower portion of the tabard model's current emblem design
	-- @name TabardModel:GetLowerEmblemFileName
	-- @class function
	-- @param filename Path to the texture image file for the lower portion of the tabard model's current emblem design (string)
	------------------------------------
	-- GetLowerEmblemFileName

	------------------------------------
	--- Sets a Texture object to display the lower portion of the tabard model's current emblem design
	-- @name TabardModel:GetLowerEmblemTexture
	-- @class function
	-- @param texture Reference to a Texture object (texture)
	------------------------------------
	-- GetLowerEmblemTexture

	------------------------------------
	--- Returns the image file for the upper portion of the tabard model's current background design
	-- @name TabardModel:GetUpperBackgroundFileName
	-- @class function
	-- @param filename Path to the texture image file for the upper portion of the tabard model's current background design (string)
	------------------------------------
	-- GetUpperBackgroundFileName

	------------------------------------
	--- Returns the image file for the upper portion of the tabard model's current emblem design
	-- @name TabardModel:GetUpperEmblemFileName
	-- @class function
	-- @param filename Path to the texture image file for the upper portion of the tabard model's current emblem design (string)
	------------------------------------
	-- GetUpperEmblemFileName

	------------------------------------
	--- Sets a Texture object to display the upper portion of the tabard model's current emblem design
	-- @name TabardModel:GetUpperEmblemTexture
	-- @class function
	-- @param texture Reference to a Texture object (texture)
	------------------------------------
	-- GetUpperEmblemTexture

	------------------------------------
	--- Sets the tabard model's design to match the player's guild tabard. If the player is not in a guild or the player's guild does not yet have a tabard design, randomizes the tabard model's design.
	-- @name TabardModel:InitializeTabardColors
	-- @class function
	------------------------------------
	-- InitializeTabardColors

	------------------------------------
	--- Saves the current tabard model design as the player's guild tabard. Has no effect if the player is not a guild leader.
	-- @name TabardModel:Save
	-- @class function
	------------------------------------
	-- Save

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function TabardModel(name, parent, ...)
		return UIObject(name, parent, CreateFrame("TabardModel", nil, parent, ...))
	end
endclass "TabardModel"

partclass "TabardModel"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(TabardModel)
endclass "TabardModel"