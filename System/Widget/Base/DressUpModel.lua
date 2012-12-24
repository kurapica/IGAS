-- Author      : Kurapica
-- Create Date : 7/16/2008 15:10
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- The DressUpModel type was added to provide support for the "dressing room" functionality when it was introduced. This model can be set to a particular unit, and then given different pieces of gear to display on that unit with the TryOn function. It also provides an Undress feature which can be used to view how your character's gear will look without concealing articles such as a cloak or tabard that you might be wearing.
-- <br><br>inherit <a href=".\PlayerModel.html">PlayerModel</a> For all methods, properties and scriptTypes
-- @name DressUpModel
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.DressUpModel", version) then
	return
end

class "DressUpModel"
	inherit "PlayerModel"

	------------------------------------------------------
	-- Script
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Updates the model to reflect the character's currently equipped items
	-- @name DressUpModel:Dress
	-- @class function
	------------------------------------
	-- Dress

	------------------------------------
	--- Updates the model to reflect the character's appearance after equipping a specific item
	-- @name DressUpModel:TryOn
	-- @class function
	-- @param itemID An item's ID (number)
	-- @param itemName An item's name (string)
	-- @param itemLink An item's hyperlink, or any string containing the itemString portion of an item link (string)
	------------------------------------
	-- TryOn

	------------------------------------
	--- Updates the model to reflect the character's appearance without any equipped items
	-- @name DressUpModel:Undress
	-- @class function
	------------------------------------
	-- Undress

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("DressUpModel", nil, parent, ...)
	end
endclass "DressUpModel"

partclass "DressUpModel"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(DressUpModel)
endclass "DressUpModel"