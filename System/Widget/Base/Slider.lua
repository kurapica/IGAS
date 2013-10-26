-- Author      : Kurapica
-- Create Date : 7/16/2008 14:39
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Slider", version) then
	return
end

class "Slider"
	inherit "Frame"

	doc [======[
		@name Slider
		@type class
		@desc Sliders are elements intended to display or allow the user to choose a value in a range.
	]======]

	------------------------------------------------------
	-- Event
	-----------------------------------------------------
	doc [======[
		@name OnMinMaxChanged
		@type event
		@desc Fired when the slider's minimum and maximum values change
		@param min new minimun value of the slider bar
		@param max new maximum value of the slider bar
	]======]
	event "OnMinMaxChanged"

	doc [======[
		@name OnValueChanged
		@type event
		@desc Fired when the slider's value changes
		@param value new value of the slider bar
	]======]
	event "OnValueChanged"

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("Slider", nil, parent, ...)
	end
endclass "Slider"

class "Slider"
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Enable
		@type method
		@desc Allows user interaction with the slider
		@return nil
	]======]

	doc [======[
		@name GetOrientation
		@type method
		@desc Returns the orientation of the slider
		@return System.Widget.Orientation
	]======]

	doc [======[
		@name GetThumbTexture
		@type method
		@desc Returns the texture for the slider thumb
		@return System.Widget.Texture the Texture object used for the slider thumb
	]======]
	function GetThumbTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetThumbTexture(...))
	end

	doc [======[
		@name GetValue
		@type method
		@desc Returns the value representing the current position of the slider thumb
		@return number Value representing the current position of the slider thumb
	]======]

	doc [======[
		@name GetValueStep
		@type method
		@desc Returns the minimum increment between allowed slider values
		@return number minimum increment between allowed slider values
	]======]

	doc [======[
		@name IsEnabled
		@type method
		@desc Returns whether user interaction with the slider is allowed
		@return boolean 1 if user interaction with the slider is allowed; otherwise nil
	]======]

	doc [======[
		@name SetMinMaxValues
		@type method
		@desc Sets the minimum and maximum values of the slider
		@param minValue number, Lower boundary for values represented on the slider
		@param maxValue number, Upper boundary for values represented on the slider
		@return nil
	]======]

	doc [======[
		@name SetOrientation
		@type method
		@desc Sets the orientation of the slider
		@param orientation System.Widget.Orientation, token describing the orientation and direction of the slider
		@return nil
	]======]

	doc [======[
		@name SetThumbTexture
		@type method
		@desc Sets the texture for the slider thumb
		@format filename|texture[, layer]
		@param texture System.Widget.Texture, Reference to an existing Texture object
		@param filename string, Path to a texture image file
		@param layer System.Widget.DrawLayer, Graphics layer in which the texture should be drawn; defaults to ARTWORK if not specified
		@return nil
	]======]
	function SetThumbTexture(self, texture, layer)
		self.__Layer = layer
		return self.__UI:SetThumbTexture(IGAS:GetUI(texture), layer)
	end

	doc [======[
		@name SetValue
		@type method
		@desc Sets the value representing the position of the slider thumb
		@param value number, representing the new position of the slider thumb
		@return nil
	]======]

	doc [======[
		@name SetValueStep
		@type method
		@desc Sets the minimum increment between allowed slider values. The portion of the slider frame's area in which the slider thumb moves is its width (or height, for vertical sliders) minus 16 pixels on either end. If the number of possible values determined by the slider's minimum, maximum, and step values is less than the width (or height) of this area, the step value also affects the movement of the slider thumb
		@param step number, minimum increment between allowed slider values
		@return nil
	]======]

	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Slider)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Orientation
		@type property
		@desc the orientation of the slider
	]======]
	property "Orientation" { Type = Orientation }

	doc [======[
		@name ThumbTexture
		@type property
		@desc the texture object for the slider thumb
	]======]
	property "ThumbTexture" {
		Set = function(self, texture)
			self:SetThumbTexture(texture, self.Layer)
		end,
		Get = "GetThumbTexture",
		Type = Texture + nil,
	}

	doc [======[
		@name ThumbTexturePath
		@type property
		@desc the texture file path for the slider thumb
	]======]
	property "ThumbTexturePath" {
		Get = function(self)
			return self:GetThumbTexture() and self:GetThumbTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetThumbTexture(texture, self.Layer)
		end,
		Type = String + nil,
	}

	doc [======[
		@name Layer
		@type property
		@desc the layer used for drawing the filled-in portion of the slider
	]======]
	property "Layer" {
		Get = function(self)
			return self.__Layer or "ARTWORK"
		end,
		Set = function(self, layer)
			self:SetThumbTexture(self:GetThumbTexture(), layer)
		end,
		Type = DrawLayer,
	}

	doc [======[
		@name Value
		@type property
		@desc the value representing the current position of the slider thumb
	]======]
	property "Value" { Type = Number }

	doc [======[
		@name ValueStep
		@type property
		@desc the minimum increment between allowed slider values
	]======]
	property "ValueStep" { Type = Number }

	doc [======[
		@name Enabled
		@type property
		@desc whether user interaction with the slider is allowed
	]======]
	property "Enabled" {
		Get = function(self)
			return (self:IsEnabled() and true) or false
		end,
		Set = function(self, enabled)
			if enabled then
				self:Enable()
			else
				self:Disable()
			end
		end,
		Type = Boolean,
	}

	doc [======[
		@name MinMaxValue
		@type property
		@desc the minimum and maximum values of the slider bar
	]======]
	property "MinMaxValue" {
		Get = function(self)
			return MinMax(self:GetMinMaxValues())
		end,
		Set = function(self, value)
			return self:SetMinMaxValues(value.min, value.max)
		end,
		Type = MinMax,
	}

endclass "Slider"