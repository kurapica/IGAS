-- Author      : Kurapica
-- Create Date : 7/16/2008 15:06
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.PlayerModel", version) then
	return
end

class "PlayerModel"
	inherit "Model"

	doc [======[
		@name PlayerModel
		@type class
		@desc PlayerModels are the most commonly used subtype of Model frame. They expand on the Model type by adding functions to quickly set the model to represent a particular player or creature, by unitID or creature ID.
	]======]

	------------------------------------------------------
	-- Script
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name RefreshCamera
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name RefreshUnit
		@type method
		@desc Updates the model's appearance to match that of its unit. Used in the default UI's inspect window when the player's target changes (changing the model to match the "new appearance" of the unit "target") or when the UNIT_MODEL_CHANGED event fires for the inspected unit (updating the model's appearance to reflect changes in the unit's equipment or shapeshift form).
		@return nil
	]======]

	doc [======[
		@name SetBarberShopAlternateForm
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name SetCamDistanceScale
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name SetCreature
		@type method
		@desc Sets the model to display the 3D model of a specific creature. Used in the default UI to set the model used for previewing non-combat pets and mounts (see GetCompanionInfo()), but can also be used to display the model for any creature whose data is cached by the client.
		@param creatureID number, numeric ID of a creature
		@return nil
	]======]

	doc [======[
		@name SetDisplayInfo
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name SetPortraitZoom
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name SetRotation
		@type method
		@desc Sets the model's current rotation by animating the model. This method is similar to Model:SetFacing() in that it rotates the 3D model displayed about its vertical axis; however, since the PlayerModel object displays a unit's model, this method is provided to allow for animating the rotation using the model's built-in animations for turning right and left.
		@param facing number, rotation angle for the model (in radians)
		@return nil
	]======]

	doc [======[
		@name SetUnit
		@type method
		@desc Sets the model to display the 3D model of a specific unit
		@param unit string, unit ID of a visible unit
		@return nil
	]======]

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
		return CreateFrame("PlayerModel", nil, parent, ...)
	end
endclass "PlayerModel"

partclass "PlayerModel"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(PlayerModel)
endclass "PlayerModel"