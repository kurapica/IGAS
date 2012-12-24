-- Author      : Kurapica
-- Create Date : 7/16/2008 15:06
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- PlayerModels are the most commonly used subtype of Model frame. They expand on the Model type by adding functions to quickly set the model to represent a particular player or creature, by unitID or creature ID.
-- <br><br>inherit <a href=".\Model.html">Model</a> For all methods, properties and scriptTypes
-- @name PlayerModel
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.PlayerModel", version) then
	return
end

class "PlayerModel"
	inherit "Model"

	------------------------------------------------------
	-- Script
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	---
	-- @name PlayerModel:RefreshCamera
	-- @class function
	------------------------------------
	-- RefreshCamera

	------------------------------------
	--- Updates the model's appearance to match that of its unit. Used in the default UI's inspect window when the player's target changes (changing the model to match the "new appearance" of the unit "target") or when the UNIT_MODEL_CHANGED event fires for the inspected unit (updating the model's appearance to reflect changes in the unit's equipment or shapeshift form).
	-- @name PlayerModel:RefreshUnit
	-- @class function
	------------------------------------
	-- RefreshUnit

	------------------------------------
	---
	-- @name PlayerModel:SetBarberShopAlternateForm
	-- @class function
	------------------------------------
	-- SetBarberShopAlternateForm

	------------------------------------
	---
	-- @name PlayerModel:SetCamDistanceScale
	-- @class function
	------------------------------------
	-- SetCamDistanceScale

	------------------------------------
	--- Sets the model to display the 3D model of a specific creature. Used in the default UI to set the model used for previewing non-combat pets and mounts (see GetCompanionInfo()), but can also be used to display the model for any creature whose data is cached by the client. Creature IDs can commonly be found on database sites (e.g. creature ID #10181).
	-- @name PlayerModel:SetCreature
	-- @class function
	-- @param creature Numeric ID of a creature (number)
	------------------------------------
	-- SetCreature

	------------------------------------
	---
	-- @name PlayerModel:SetDisplayInfo
	-- @class function
	------------------------------------
	-- SetDisplayInfo

	------------------------------------
	---
	-- @name PlayerModel:SetPortraitZoom
	-- @class function
	------------------------------------
	-- SetPortraitZoom

	------------------------------------
	--- Sets the model's current rotation by animating the model. This method is similar to Model:SetFacing() in that it rotates the 3D model displayed about its vertical axis; however, since the PlayerModel object displays a unit's model, this method is provided to allow for animating the rotation using the model's built-in animations for turning right and left.</p>
	--- <p>For example, if the model faces towards the viewer when its facing is set to 0, setting its facing to math.pi faces it away from the viewer.
	-- @name PlayerModel:SetRotation
	-- @class function
	-- @param facing Rotation angle for the model (in radians) (number)
	------------------------------------
	-- SetRotation

	------------------------------------
	--- Sets the model to display the 3D model of a specific unit
	-- @name PlayerModel:SetUnit
	-- @class function
	-- @param unit Unit ID of a visible unit (string, unitID)
	------------------------------------
	-- SetUnit

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