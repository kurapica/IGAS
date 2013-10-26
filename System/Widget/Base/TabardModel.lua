-- Author      : Kurapica
-- Create Date : 7/16/2008 15:10
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.TabardModel", version) then
	return
end

class "TabardModel"
	inherit "PlayerModel"

	doc [======[
		@name TabardModel
		@type class
		@desc TabardModel is a frame type provided specifically for designing or modifying guild tabards.
	]======]

	------------------------------------------------------
	-- Event
	-----------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("TabardModel", nil, parent, ...)
	end
endclass "TabardModel"

class "TabardModel"
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetLowerBackgroundFileName
		@type method
		@desc Returns the image file for the lower portion of the tabard model's current background design
		@return string the image file for the lower portion of the tabard model's current background design
	]======]

	doc [======[
		@name GetLowerEmblemFileName
		@type method
		@desc Returns the image file for the lower portion of the tabard model's current emblem design
		@return string the image file for the lower portion of the tabard model's current emblem design
	]======]

	doc [======[
		@name GetLowerEmblemTexture
		@type method
		@desc Gets the texture object to display the lower portion of the tabard model's current emblem design
		@return System.Widget.Texture the texture object to display the lower portion of the tabard model's current emblem design
	]======]
	function GetLowerEmblemTexture(self)
		return IGAS:GetWrapper(self.__UI:GetLowerEmblemTexture())
	end

	doc [======[
		@name GetUpperBackgroundFileName
		@type method
		@desc Returns the image file for the upper portion of the tabard model's current background design
		@return string the image file path for the upper portion of the tabard model's current background design
	]======]

	doc [======[
		@name GetUpperEmblemFileName
		@type method
		@desc Returns the image file for the upper portion of the tabard model's current emblem design
		@return string the image file path for the upper portion of the tabard model's current emblem design
	]======]

	doc [======[
		@name GetUpperEmblemTexture
		@type method
		@desc Gets a Texture object to display the upper portion of the tabard model's current emblem design
		@return System.Widget.Texture the texture object to display the upper portion of the tabard model's current emblem design
	]======]
	function GetUpperEmblemTexture(self)
		return IGAS:GetWrapper(self.__UI:GetUpperEmblemTexture())
	end

	doc [======[
		@name InitializeTabardColors
		@type method
		@desc Sets the tabard model's design to match the player's guild tabard. If the player is not in a guild or the player's guild does not yet have a tabard design, randomizes the tabard model's design.
		@return nil
	]======]

	doc [======[
		@name Save
		@type method
		@desc Saves the current tabard model design as the player's guild tabard. Has no effect if the player is not a guild leader.
		@return nil
	]======]

	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(TabardModel)
endclass "TabardModel"