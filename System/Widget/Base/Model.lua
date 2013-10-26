-- Author      : Kurapica
-- Create Date : 7/16/2008 12:29
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Model", version) then
	return
end

class "Model"
	inherit "Frame"

	doc [======[
		@name Model
		@type class
		@desc Model provide a rendering environment which is drawn into the backdrop of their frame, allowing you to display the contents of an .m2 file and set facing, scale, light and fog information, or run motions associated
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnAnimFinished
		@type event
		@desc Run when the model's animation finishes
	]======]
	event "OnAnimFinished"

	doc [======[
		@name OnUpdateModel
		@type event
		@desc Run when a model changes or animates
	]======]
	event "OnUpdateModel"

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("Model", nil, parent, ...)
	end
endclass "Model"

class "Model"
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name AdvanceTime
		@type method
		@desc Advances to the model's next animation frame. (Applies to 3D animations defined within the model file, not UI Animations.)
		@return nil
	]======]

	doc [======[
		@name ClearFog
		@type method
		@desc Disables fog display for the model.
		@return nil
	]======]

	doc [======[
		@name ClearModel
		@type method
		@desc Removes the 3D model currently displayed
		@return nil
	]======]

	doc [======[
		@name GetFacing
		@type method
		@desc Returns the model's current rotation setting. The 3D model displayed by the model object can be rotated about its vertical axis. For example, a model of a player race faces towards the viewer when its facing is set to 0; setting facing to math.pi faces it away from the viewer.
		@return number Current rotation angle of the model (in radians)
	]======]

	doc [======[
		@name GetFogColor
		@type method
		@desc Returns the model's current fog color. Does not indicate whether fog display is enabled.
		@return red number, red component of the color (0.0 - 1.0)
		@return green number, green component of the color (0.0 - 1.0)
		@return blue number, blue component of the color (0.0 - 1.0)
	]======]

	doc [======[
		@name GetFogFar
		@type method
		@desc Returns the far clipping distance for the model's fog. This determines how far from the camera the fog ends.
		@return number The distance to the fog far clipping plane
	]======]

	doc [======[
		@name GetFogNear
		@type method
		@desc Returns the near clipping distance for the model's fog. This determines how close to the camera the fog begins.
		@return number The distance to the fog near clipping plane
	]======]

	doc [======[
		@name GetLight
		@type method
		@desc Returns properties of the light sources used when rendering the model
		@return enabled boolean, 1 if lighting is enabled; otherwise nil
		@return omni number, 1 if omnidirectional lighting is enabled; otherwise 0
		@return dirX number, coordinate of the directional light in the axis perpendicular to the screen (negative values place the light in front of the model, positive values behind)
		@return dirY number, coordinate of the directional light in the horizontal axis (negative values place the light to the left of the model, positive values to the right)
		@return dirZ number, coordinate of the directional light in the vertical axis (negative values place the light below the model, positive values above
		@return ambIntensity number, intensity of the ambient light (0.0 - 1.0)
		@return ambR number, red component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0
		@return ambG number, green component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0
		@return ambB number, blue component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0
		@return dirIntensity number, intensity of the directional light (0.0 - 1.0)
		@return dirR number, red component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0
		@return dirG number, green component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0
		@return dirB number, blue component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0
	]======]

	doc [======[
		@name GetModel
		@type method
		@desc Returns the model file currently displayed. May instead return a reference to the Model object itself if a filename is not available.
		@return string Path to the model file currently displayed
	]======]

	doc [======[
		@name GetModelScale
		@type method
		@desc Returns the scale factor determining the size at which the 3D model appears
		@return number Scale factor determining the size at which the 3D model appears
	]======]

	doc [======[
		@name GetPosition
		@type method
		@desc Returns the position of the 3D model within the frame
		@@return x number, position of the model on the axis perpendicular to the plane of the screen (positive values make the model appear closer to the viewer; negative values place it further away)
		@return y number, position of the model on the horizontal axis (positive values place the model to the right of its default position; negative values place it to the left)
		@return z number, position of the model on the vertical axis (positive values place the model above its default position; negative values place it below)
	]======]

	doc [======[
		@name ReplaceIconTexture
		@type method
		@desc Sets the icon texture used by the model. Only affects models that use icons (e.g. the model producing the default UI's animation which appears when an item goes into a bag).
		@param filename string, Path to an icon texture for use in the model
		@return nil
	]======]

	doc [======[
		@name SetCamera
		@type method
		@desc Sets the view angle on the model to a pre-defined camera location. Camera view angles are defined within the model files and not otherwise available to the scripting system.
		@param index number, index of a camera view defined by the model file
		@return nil
	]======]

	doc [======[
		@name SetFacing
		@type method
		@desc Sets the model's current rotation. The 3D model displayed by the model object can be rotated about its vertical axis. For example, if the model faces towards the viewer when its facing is set to 0, setting facing to math.pi faces it away from the viewer.
		@param facing number, rotation angle for the model (in radians)
		@return nil
	]======]

	doc [======[
		@name SetFogColor
		@type method
		@desc Sets the model's fog color, enabling fog display if disabled
		@param red number, red component of the color (0.0 - 1.0)
		@param green number, green component of the color (0.0 - 1.0)
		@param blue number, blue component of the color (0.0 - 1.0)
	]======]

	doc [======[
		@name SetFogFar
		@type method
		@desc Sets the far clipping distance for the model's fog. This sets how far from the camera the fog ends.
		@param distance number, the distance to the fog far clipping plane
		@return nil
	]======]

	doc [======[
		@name SetFogNear
		@type method
		@desc Sets the near clipping distance for the model's fog. This sets how close to the camera the fog begins.
		@param distance number, The distance to the fog near clipping plane
		@return nil
	]======]

	doc [======[
		@name SetGlow
		@type method
		@desc Sets the model's glow amount
		@param amount number, glow amount for the model
		@return nil
	]======]

	doc [======[
		@name SetLight
		@type method
		@desc Sets properties of the light sources used when rendering the model
		@param enabled boolean, 1 if lighting is enabled; otherwise nil
		@param omni number, 1 if omnidirectional lighting is enabled; otherwise 0
		@param dirX number, coordinate of the directional light in the axis perpendicular to the screen (negative values place the light in front of the model, positive values behind)
		@param dirY number, coordinate of the directional light in the horizontal axis (negative values place the light to the left of the model, positive values to the right)
		@param dirZ number, coordinate of the directional light in the vertical axis (negative values place the light below the model, positive values above
		@param ambIntensity number, intensity of the ambient light (0.0 - 1.0)
		@param ambR number, red component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0
		@param ambG number, green component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0
		@param ambB number, blue component of the ambient light color (0.0 - 1.0); omitted if ambIntensity is 0
		@param dirIntensity number, intensity of the directional light (0.0 - 1.0)
		@param dirR number, red component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0
		@param dirG number, green component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0
		@param dirB number, blue component of the directional light color (0.0 - 1.0); omitted if dirIntensity is 0
		@return nil
	]======]

	doc [======[
		@name SetModel
		@type method
		@desc Sets the model file to be displayed
		@param filename string, path to the model file to be displayed
		@return nil
	]======]

	doc [======[
		@name SetModelScale
		@type method
		@desc Sets the scale factor determining the size at which the 3D model appears
		@param scale number, scale factor determining the size at which the 3D model appears
		@return nil
	]======]

	doc [======[
		@name SetPosition
		@type method
		@desc Set the position of the 3D model within the frame
		@param x number, position of the model on the axis perpendicular to the plane of the screen (positive values make the model appear closer to the viewer; negative values place it further away)
		@param y number, position of the model on the horizontal axis (positive values place the model to the right of its default position; negative values place it to the left)
		@param z number, position of the model on the vertical axis (positive values place the model above its default position; negative values place it below)
	]======]

	doc [======[
		@name SetSequence
		@type method
		@desc Sets the animation sequence to be used by the model. The number of available sequences and behavior of each are defined within the model files and not available to the scripting system.
		@param sequence number, index of an animation sequence defined by the model file
		@return nil
	]======]

	doc [======[
		@name SetSequenceTime
		@type method
		@desc Sets the animation sequence and time index to be used by the model. The number of available sequences and behavior of each are defined within the model files and not available to the scripting system.
		@param sequence number, index of an animation sequence defined by the model file
		@param time number, time index within the sequence
		@return nil
	]======]

	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Model)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name FogColor
		@type property
		@desc the model's current fog color
	]======]
	property "FogColor" {
		Get = function(self)
			return ColorType(self:GetFogColor())
		end,
		Set = function(self, colorTable)
			self:SetFogColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
		end,
		Type = ColorType,
	}

	doc [======[
		@name FogFar
		@type property
		@desc the far clipping distance for the model's fog
	]======]
	property "FogFar" { Type = Number }

	doc [======[
		@name FogNear
		@type property
		@desc the near clipping distance for the model's fog
	]======]
	property "FogNear" { Type = Number }

	doc [======[
		@name ModelScale
		@type property
		@desc the scale factor determining the size at which the 3D model appears
	]======]
	property "ModelScale" { Type = Number }

	doc [======[
		@name Model
		@type property
		@desc the model file to be displayed
	]======]
	property "Model" {
		Set = function(self, file)
			if file and type(file) == "string" and file ~= "" then
				self:SetModel(file)
			else
				self:ClearModel()
			end
		end,
		Get = "GetModel",
		Type = String + nil,
	}

	doc [======[
		@name Position
		@type property
		@desc the position of the 3D model within the frame
	]======]
	property "Position" {
		Get = function(self)
			return Position(self:GetPosition())
		end,
		Set = function(self, value)
			self:SetPosition(value.x, value.y, value.z)
		end,
		Type = Position,
	}

	doc [======[
		@name Light
		@type property
		@desc the light sources used when rendering the model
	]======]
	property "Light" {
		Get = function(self)
			return LightType(self:GetLight())
		end,
		Set = function(self, set)
			self:SetLight(set.enabled, set.omni, set.dirX, set.dirY, set.dirZ, set.ambIntensity, set.ambR, set.ambG, set.ambB, set.dirIntensity, set.dirR, set.dirG, set.dirB)
		end,
		Type = LightType,
	}

endclass "Model"