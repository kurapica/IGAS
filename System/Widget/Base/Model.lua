-- Author      : Kurapica
-- Create Date : 7/16/2008 12:29
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Model provide a rendering environment which is drawn into the backdrop of their frame, allowing you to display the contents of an .m2 file and set facing, scale, light and fog information, or run motions associated
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name Model
-- @class table
-- @field FogColor the model's current fog color
-- @field FogFar the far clipping distance for the model's fog
-- @field FogNear the near clipping distance for the model's fog
-- @field ModelScale the scale factor determining the size at which the 3D model appears
-- @field Model the model file to be displayed
-- @field Position the position of the 3D model within the frame
-- @field Light properties of the light sources used when rendering the model
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Model", version) then
	return
end

class "Model"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the model's animation finishes
	-- @name Model:OnAnimFinished
	-- @class function
	-- @usage function Model:OnAnimFinished()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnAnimFinished"

	------------------------------------
	--- ScriptType, Run when a model changes or animates
	-- @name Model:OnUpdateModel
	-- @class function
	-- @usage function Model:OnUpdateModel()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnUpdateModel"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Advances to the model's next animation frame. (Applies to 3D animations defined within the model file, not UI Animations.)
	-- @name Model:AdvanceTime
	-- @class function
	------------------------------------
	-- AdvanceTime

	------------------------------------
	--- Disables fog display for the model.
	-- @name Model:ClearFog
	-- @class function
	------------------------------------
	-- ClearFog

	------------------------------------
	--- Removes the 3D model currently displayed
	-- @name Model:ClearModel
	-- @class function
	------------------------------------
	-- ClearModel

	------------------------------------
	--- Returns the model's current rotation setting. The 3D model displayed by the model object can be rotated about its vertical axis. For example, a model of a player race faces towards the viewer when its facing is set to 0; setting facing to math.pi faces it away from the viewer.
	-- @name Model:GetFacing
	-- @class function
	-- @return facing - Current rotation angle of the model (in radians) (number)
	------------------------------------
	-- GetFacing

	------------------------------------
	--- Returns the model's current fog color. Does not indicate whether fog display is enabled.
	-- @name Model:GetFogColor
	-- @class function
	-- @return red - Red component of the color (0.0 - 1.0) (number)
	-- @return green - Green component of the color (0.0 - 1.0) (number)
	-- @return blue - Blue component of the color (0.0 - 1.0) (number)
	------------------------------------
	-- GetFogColor

	------------------------------------
	--- Returns the far clipping distance for the model's fog.. This determines how far from the camera the fog ends.
	-- @name Model:GetFogFar
	-- @class function
	-- @return distance - The distance to the fog far clipping plane (number)
	------------------------------------
	-- GetFogFar

	------------------------------------
	--- Returns the near clipping distance for the model's fog.. This determines how close to the camera the fog begins.
	-- @name Model:GetFogNear
	-- @class function
	-- @return distance - The distance to the fog near clipping plane (number)
	------------------------------------
	-- GetFogNear

	------------------------------------
	--- Returns properties of the light sources used when rendering the model
	-- @name Model:GetLight
	-- @class function
	-- @return enabled - 1 if lighting is enabled; otherwise nil (1nil)
	-- @return omni - 1 if omnidirectional lighting is enabled; otherwise 0 (number)
	-- @return dirX - Coordinate of the directional light in the axis perpendicular to the screen (negative values place the light in front of the model, positive values behind) (number)
	-- @return dirY - Coordinate of the directional light in the horizontal axis (negative values place the light to the left of the model, positive values to the right) (number)
	-- @return dirZ - Coordinate of the directional light in the vertical axis (negative values place the light below the model, positive values above (number)
	-- @return ambIntensity - Intensity of the ambient light (0.0 - 1.0) (number)
	-- @return ambR - Red component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0 (number)
	-- @return ambG - Green component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0 (number)
	-- @return ambB - Blue component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0 (number)
	-- @return dirIntensity - Intensity of the directional light (0.0 - 1.0) (number)
	-- @return dirR - Red component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0 (number)
	-- @return dirG - Green component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0 (number)
	-- @return dirB - Blue component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0 (number)
	------------------------------------
	-- GetLight

	------------------------------------
	--- Returns the model file currently displayed. May instead return a reference to the Model object itself if a filename is not available.
	-- @name Model:GetModel
	-- @class function
	-- @return filename - Path to the model file currently displayed (string)
	------------------------------------
	-- GetModel

	------------------------------------
	--- Returns the scale factor determining the size at which the 3D model appears
	-- @name Model:GetModelScale
	-- @class function
	-- @return scale - Scale factor determining the size at which the 3D model appears (number)
	------------------------------------
	-- GetModelScale

	------------------------------------
	--- Returns the position of the 3D model within the frame
	-- @name Model:GetPosition
	-- @class function
	-- @return x - Position of the model on the axis perpendicular to the plane of the screen (positive values make the model appear closer to the viewer; negative values place it further away) (number)
	-- @return y - Position of the model on the horizontal axis (positive values place the model to the right of its default position; negative values place it to the left) (number)
	-- @return z - Position of the model on the vertical axis (positive values place the model above its default position; negative values place it below) (number)
	------------------------------------
	-- GetPosition

	------------------------------------
	--- Sets the icon texture used by the model. Only affects models that use icons (e.g. the model producing the default UI's animation which appears when an item goes into a bag).
	-- @name Model:ReplaceIconTexture
	-- @class function
	-- @param filename Path to an icon texture for use in the model (string)
	------------------------------------
	-- ReplaceIconTexture

	------------------------------------
	--- Sets the view angle on the model to a pre-defined camera location. Camera view angles are defined within the model files and not otherwise available to the scripting system. Some camera indices are standard across most models:
	-- @name Model:SetCamera
	-- @class function
	-- @param index Index of a camera view defined by the model file (number)
	------------------------------------
	-- SetCamera

	------------------------------------
	--- Sets the model's current rotation. The 3D model displayed by the model object can be rotated about its vertical axis. For example, if the model faces towards the viewer when its facing is set to 0, setting facing to math.pi faces it away from the viewer.
	-- @name Model:SetFacing
	-- @class function
	-- @param facing Rotation angle for the model (in radians) (number)
	------------------------------------
	-- SetFacing

	------------------------------------
	--- Sets the model's fog color, enabling fog display if disabled
	-- @name Model:SetFogColor
	-- @class function
	-- @param red Red component of the color (0.0 - 1.0) (number)
	-- @param green Green component of the color (0.0 - 1.0) (number)
	-- @param blue Blue component of the color (0.0 - 1.0) (number)
	------------------------------------
	-- SetFogColor

	------------------------------------
	--- Sets the far clipping distance for the model's fog.. This sets how far from the camera the fog ends.
	-- @name Model:SetFogFar
	-- @class function
	-- @param distance The distance to the fog far clipping plane (number)
	------------------------------------
	-- SetFogFar

	------------------------------------
	--- Sets the near clipping distance for the model's fog.. This sets how close to the camera the fog begins.
	-- @name Model:SetFogNear
	-- @class function
	-- @param distance The distance to the fog near clipping plane (number)
	------------------------------------
	-- SetFogNear

	------------------------------------
	--- Sets the model's glow amount
	-- @name Model:SetGlow
	-- @class function
	-- @param amount Glow amount for the model (number)
	------------------------------------
	-- SetGlow

	------------------------------------
	--- Sets properties of the light sources used when rendering the model
	-- @name Model:SetLight
	-- @class function
	-- @param enabled 1 if lighting is enabled; otherwise nil (1nil)
	-- @param omni 1 if omnidirectional lighting is enabled; otherwise 0 (number)
	-- @param dirX Coordinate of the directional light in the axis perpendicular to the screen (negative values place the light in front of the model, positive values behind) (number)
	-- @param dirY Coordinate of the directional light in the horizontal axis (negative values place the light to the left of the model, positive values to the right) (number)
	-- @param dirZ Coordinate of the directional light in the vertical axis (negative values place the light below the model, positive values above (number)
	-- @param ambIntensity Intensity of the ambient light (0.0 - 1.0) (number)
	-- @param ambR Red component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0 (number)
	-- @param ambG Green component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0 (number)
	-- @param ambB Blue component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0 (number)
	-- @param dirIntensity Intensity of the directional light (0.0 - 1.0) (number)
	-- @param dirR Red component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0 (number)
	-- @param dirG Green component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0 (number)
	-- @param dirB Blue component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0 (number)
	------------------------------------
	-- SetLight

	------------------------------------
	--- Sets the model file to be displayed
	-- @name Model:SetModel
	-- @class function
	-- @param filename Path to the model file to be displayed (string)
	------------------------------------
	-- SetModel

	------------------------------------
	--- Sets the scale factor determining the size at which the 3D model appears
	-- @name Model:SetModelScale
	-- @class function
	-- @param scale Scale factor determining the size at which the 3D model appears (number)
	------------------------------------
	-- SetModelScale

	------------------------------------
	--- Returns the position of the 3D model within the frame
	-- @name Model:SetPosition
	-- @class function
	-- @param x Position of the model on the axis perpendicular to the plane of the screen (positive values make the model appear closer to the viewer; negative values place it further away) (number)
	-- @param y Position of the model on the horizontal axis (positive values place the model to the right of its default position; negative values place it to the left) (number)
	-- @param z Position of the model on the vertical axis (positive values place the model above its default position; negative values place it below) (number)
	------------------------------------
	-- SetPosition

	------------------------------------
	--- Sets the animation sequence to be used by the model. The number of available sequences and behavior of each are defined within the model files and not available to the scripting system.
	-- @name Model:SetSequence
	-- @class function
	-- @param sequence Index of an animation sequence defined by the model file (number)
	------------------------------------
	-- SetSequence

	------------------------------------
	--- Sets the animation sequence and time index to be used by the model. The number of available sequences and behavior of each are defined within the model files and not available to the scripting system.
	-- @name Model:SetSequenceTime
	-- @class function
	-- @param sequence Index of an animation sequence defined by the model file (number)
	-- @param time Time index within the sequence (number)
	------------------------------------
	-- SetSequenceTime

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- FogColor
	property "FogColor" {
		Get = function(self)
			return ColorType(self:GetFogColor())
		end,
		Set = function(self, colorTable)
			self:SetFogColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
		end,
		Type = ColorType,
	}
	-- FogFar
	property "FogFar" {
		Get = function(self)
			return self:GetFogFar()
		end,
		Set = function(self, value)
			self:SetFogFar(value)
		end,
		Type = Number,
	}
	-- FogNear
	property "FogNear" {
		Get = function(self)
			return self:GetFogNear()
		end,
		Set = function(self, value)
			self:SetFogNear(value)
		end,
		Type = Number,
	}
	-- ModelScale
	property "ModelScale" {
		Get = function(self)
			return self:GetModelScale()
		end,
		Set = function(self, scale)
			self:SetModelScale(scale)
		end,
		Type = Number,
	}
	-- Model
	property "Model" {
		Get = function(self)
			return self:GetModel()
		end,
		Set = function(self, file)
			if file and type(file) == "string" and file ~= "" then
				self:SetModel(file)
			else
				self:ClearModel()
			end
		end,
		Type = String + nil,
	}
	-- Position
	property "Position" {
		Get = function(self)
			return Position(self:GetPosition())
		end,
		Set = function(self, value)
			self:SetPosition(value.x, value.y, value.z)
		end,
		Type = Position,
	}
	-- Light
	property "Light" {
		Get = function(self)
			return LightType(self:GetLight())
		end,
		Set = function(self, set)
			self:SetLight(set.enabled, set.omni, set.dirX, set.dirY, set.dirZ, set.ambIntensity, set.ambR, set.ambG, set.ambB, set.dirIntensity, set.dirR, set.dirG, set.dirB)
		end,
		Type = LightType,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Model(name, parent, ...)
		return UIObject(name, parent, CreateFrame("Model", nil, parent, ...))
	end
endclass "Model"

partclass "Model"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Model)
endclass "Model"