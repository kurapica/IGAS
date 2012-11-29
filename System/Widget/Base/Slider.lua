-- Author      : Kurapica
-- Create Date : 7/16/2008 14:39
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Sliders are elements intended to display or allow the user to choose a value in a range.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name Slider
-- @class table
-- @field Orientation the orientation of the slider
-- @field ThumbTexture the texture for the slider thumb
-- @field ThumbTexturePath the texture file for the slider thumb
-- @field Layer the layer used for drawing the filled-in portion of the slider
-- @field Value the value representing the current position of the slider thumb
-- @field ValueStep the minimum increment between allowed slider values
-- @field Enabled whether user interaction with the slider is allowed
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Slider", version) then
	return
end

class "Slider"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	-----------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the slider's or status bar's minimum and maximum values change
	-- @name Slider:OnMinMaxChanged
	-- @class function
	-- @param min New minimum value of the slider or the status bar
	-- @param max New maximum value of the slider or the status bar
	-- @usage function Slider:OnMinMaxChanged(min, max)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnMinMaxChanged"

	------------------------------------
	--- ScriptType, Run when the slider's or status bar's value changes
	-- @name Slider:OnValueChanged
	-- @class function
	-- @param value New value of the slider or the status bar
	-- @usage function Slider:OnValueChanged(value)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnValueChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Allows user interaction with the slider
	-- @name Slider:Enable
	-- @class function
	------------------------------------
	-- Enable

	------------------------------------
	--- Returns the orientation of the slider
	-- @name Slider:GetOrientation
	-- @class function
	-- @return orientation - Token describing the orientation and direction of the slider (string) <ul><li>HORIZONTAL - Slider thumb moves from left to right as the slider's value increases
	-- @return VERTICAL - Slider thumb moves from top to bottom as the slider's value increases
	------------------------------------
	-- GetOrientation

	------------------------------------
	--- Returns the texture for the slider thumb
	-- @name Slider:GetThumbTexture
	-- @class function
	-- @return texture - Reference to the Texture object used for the slider thumb (texture)
	------------------------------------
	function GetThumbTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetThumbTexture(...))
	end

	------------------------------------
	--- Returns the value representing the current position of the slider thumb
	-- @name Slider:GetValue
	-- @class function
	-- @return value - Value representing the current position of the slider thumb (between minValue and maxValue, where minValue, maxValue = slider:GetMinMaxValues()) (number)
	------------------------------------
	-- GetValue

	------------------------------------
	--- Returns the minimum increment between allowed slider values
	-- @name Slider:GetValueStep
	-- @class function
	-- @return step - Minimum increment between allowed slider values (number)
	------------------------------------
	-- GetValueStep

	------------------------------------
	--- Returns whether user interaction with the slider is allowed
	-- @name Slider:IsEnabled
	-- @class function
	-- @return enabled - 1 if user interaction with the slider is allowed; otherwise nil (1nil)
	------------------------------------
	-- IsEnabled

	------------------------------------
	--- Sets the minimum and maximum values for the slider
	-- @name Slider:SetMinMaxValues
	-- @class function
	-- @param minValue Lower boundary for values represented by the slider position (number)
	-- @param maxValue Upper boundary for values represented by the slider position (number)
	------------------------------------
	-- SetMinMaxValues

	------------------------------------
	--- Sets the orientation of the slider
	-- @name Slider:SetOrientation
	-- @class function
	-- @param orientation Token describing the orientation and direction of the slider (string) <ul><li>HORIZONTAL - Slider thumb moves from left to right as the slider's value increases
	-- @param VERTICAL Slider thumb moves from top to bottom as the slider's value increases (default)
	------------------------------------
	-- SetOrientation

	------------------------------------
	--- Sets the texture for the slider thumb
	-- @name Slider:SetThumbTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	-- @param layer Graphics layer in which the texture should be drawn; defaults to ARTWORK if not specified (string, layer)
	------------------------------------
	function SetThumbTexture(self, texture, layer)
		self.__Layer = layer
		return self.__UI:SetThumbTexture(IGAS:GetUI(texture), layer)
	end

	------------------------------------
	--- Sets the value representing the position of the slider thumb
	-- @name Slider:SetValue
	-- @class function
	-- @param value Value representing the new position of the slider thumb (between minValue and maxValue, where minValue, maxValue = slider:GetMinMaxValues()) (number)
	------------------------------------
	-- SetValue

	------------------------------------
	--- Sets the minimum increment between allowed slider values. The portion of the slider frame's area in which the slider thumb moves is its width (or height, for vertical sliders) minus 16 pixels on either end. If the number of possible values determined by the slider's minimum, maximum, and step values is less than the width (or height) of this area, the step value also affects the movement of the slider thumb; see example for details.
	-- @name Slider:SetValueStep
	-- @class function
	-- @param step Minimum increment between allowed slider values (number)
	------------------------------------
	-- SetValueStep

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
	function Slider(name, parent, ...)
		return UIObject(name, parent, CreateFrame("Slider", nil, parent, ...))
	end
endclass "Slider"

partclass "Slider"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Slider)
endclass "Slider"