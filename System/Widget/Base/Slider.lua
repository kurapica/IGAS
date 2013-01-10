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
	-- Script
	-----------------------------------------------------
	doc [======[
		@name OnMinMaxChanged
		@type script
		@desc Fired when the slider's minimum and maximum values change
		@param min new minimun value of the slider bar
		@param max new maximum value of the slider bar
	]======]
	script "OnMinMaxChanged"

	doc [======[
		@name OnValueChanged
		@type script
		@desc Fired when the slider's value changes
		@param value new value of the slider bar
	]======]
	script "OnValueChanged"

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
	-- Property
	------------------------------------------------------
	-- Orientation
	property "Orientation" {
		Get = function(self)
			return self:GetOrientation()
		end,
		Set = function(self, orientation)
			self:SetOrientation(orientation)
		end,
		Type = Orientation,
	}
	-- ThumbTexture
	property "ThumbTexture" {
		Get = function(self)
			return self:GetThumbTexture()
		end,
		Set = function(self, texture)
			self:SetThumbTexture(texture, self.Layer)
		end,
		Type = Texture + nil,
	}
	-- ThumbTexturePath
	property "ThumbTexturePath" {
		Get = function(self)
			return self:GetThumbTexture() and self:GetThumbTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetThumbTexture(texture, self.Layer)
		end,
		Type = String + nil,
	}
	-- Layer
	property "Layer" {
		Get = function(self)
			return self.__Layer or "ARTWORK"
		end,
		Set = function(self, layer)
			self:SetThumbTexture(self:GetThumbTexture(), layer)
		end,
		Type = DrawLayer,
	}
	-- Value
	property "Value" {
		Get = function(self)
			return self:GetValue()
		end,
		Set = function(self, value)
			self:SetValue(value)
		end,
		Type = Number,
	}
	-- ValueStep
	property "ValueStep" {
		Get = function(self)
			return self:GetValueStep()
		end,
		Set = function(self, value)
			self:SetValueStep(value)
		end,
		Type = Number,
	}
	-- Enabled
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
	-- MinMaxValue
	property "MinMaxValue" {
		Get = function(self)
			return MinMax(self:GetMinMaxValues())
		end,
		Set = function(self, value)
			return self:SetMinMaxValues(value.min, value.max)
		end,
		Type = MinMax,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("Slider", nil, parent, ...)
	end
endclass "Slider"

partclass "Slider"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Slider)
endclass "Slider"