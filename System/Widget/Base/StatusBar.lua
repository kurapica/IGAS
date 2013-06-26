-- Author      : Kurapica
-- Create Date : 7/16/2008 14:51
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.StatusBar", version) then
	return
end

class "StatusBar"
	inherit "Frame"

	doc [======[
		@name StatusBar
		@type class
		@desc StatusBars are similar to Sliders, but they are generally used for display as they don't offer any tools to receive user input.
	]======]

	------------------------------------------------------
	-- Event
	-----------------------------------------------------
	doc [======[
		@name OnMinMaxChanged
		@type event
		@desc Fired when the status bar's minimum and maximum values change
		@param min new minimun value of the status bar
		@param max new maximum value of the status bar
	]======]
	event "OnMinMaxChanged"

	doc [======[
		@name OnValueChanged
		@type event
		@desc Fired when the status bar's value changes
		@param value new value of the status bar
	]======]
	event "OnValueChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetMinMaxValues
		@type method
		@desc Returns the minimum and maximum values of the status bar
		@return minValue number, lower boundary for values represented on the status bar
		@return maxValue number, upper boundary for values represented on the status bar
	]======]

	doc [======[
		@name GetOrientation
		@type method
		@desc Returns the orientation of the status bar
		@return System.Widget.Orientation
	]======]

	doc [======[
		@name GetRotatesTexture
		@type method
		@desc Returns whether the status bar's texture is rotated to match its orientation
		@return boolean 1 if the status bar texture should be rotated 90 degrees counter-clockwise when the status bar is vertically orientation, otherwise nil
	]======]

	doc [======[
		@name GetStatusBarColor
		@type method
		@desc Returns the color shading used for the status bar's texture
		@return red number, Red component of the color (0.0 - 1.0)
		@return green number, Green component of the color (0.0 - 1.0)
		@return blue number, Blue component of the color (0.0 - 1.0)
		@return alpha number, Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name GetStatusBarTexture
		@type method
		@desc Returns the Texture object used for drawing the filled-in portion of the status bar
		@return System.Widget.Texture the Texture object used for drawing the filled-in portion of the status bar
	]======]
	function GetStatusBarTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetStatusBarTexture(...))
	end

	doc [======[
		@name GetValue
		@type method
		@desc Returns the current value of the status bar
		@return number the value indicating the amount of the status bar's area to be filled in
	]======]

	doc [======[
		@name SetMinMaxValues
		@type method
		@desc Sets the minimum and maximum values of the status bar
		@param minValue number, Lower boundary for values represented on the status bar
		@param maxValue number, Upper boundary for values represented on the status bar
		@return nil
	]======]

	doc [======[
		@name SetOrientation
		@type method
		@desc Sets the orientation of the status bar
		@param orientation System.Widget.Orientation, token describing the orientation and direction of the status bar
		@return nil
	]======]

	doc [======[
		@name SetRotatesTexture
		@type method
		@desc Sets whether the status bar's texture is rotated to match its orientation
		@param boolean True to rotate the status bar texture 90 degrees counter-clockwise when the status bar is vertically oriented; false otherwise
		@return nil
	]======]

	doc [======[
		@name SetStatusBarColor
		@type method
		@desc Sets the color shading for the status bar's texture. As with :SetVertexColor(), this color is a shading applied to the texture image.
		@param red number, Red component of the color (0.0 - 1.0)
		@param green number, Green component of the color (0.0 - 1.0)
		@param blue number, Blue component of the color (0.0 - 1.0)
		@param alpha number, Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name SetStatusBarTexture
		@type method
		@desc Sets the texture used for drawing the filled-in portion of the status bar. The texture image is stretched to fill the dimensions of the entire status bar, then cropped to show only a portion corresponding to the status bar's current value.
		@format texture|filename[, layer]
		@param texture System.Widget.Texture, Reference to an existing Texture object
		@param filename string, Path to a texture image file
		@param layer System.Widget.DrawLayer, Graphics layer in which the texture should be drawn; defaults to ARTWORK if not specified
		@return nil
	]======]
	function SetStatusBarTexture(self, texture, layer)
		self.__Layer = layer
		return self.__UI:SetStatusBarTexture(IGAS:GetUI(texture), layer)
	end

	doc [======[
		@name SetValue
		@type method
		@desc Sets the value of the status bar
		@param value number, indicating the amount of the status bar's area to be filled in
		@return nil
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name MinMaxValue
		@type property
		@desc the minimum and maximum values of the status bar
	]======]
	property "MinMaxValue" {
		Get = function(self)
			return MinMax(self:GetMinMaxValues())
		end,
		Set = function(self, set)
			self:SetMinMaxValues(set.min, set.max)
		end,
		Type = MinMax,
	}

	doc [======[
		@name Orientation
		@type property
		@desc the orientation of the status bar
	]======]
	property "Orientation" {
		Get = function(self)
			return self:GetOrientation()
		end,
		Set = function(self, orientation)
			self:SetOrientation(orientation)
		end,
		Type = Orientation,
	}

	doc [======[
		@name StatusBarColor
		@type property
		@desc the color shading for the status bar's texture
	]======]
	property "StatusBarColor" {
		Get = function(self)
			return ColorType(self:GetStatusBarColor())
		end,
		Set = function(self, colorTable)
			self:SetStatusBarColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
		end,
		Type = ColorType,
	}

	doc [======[
		@name StatusBarTexture
		@type property
		@desc the texture used for drawing the filled-in portion of the status bar
	]======]
	property "StatusBarTexture" {
		Get = function(self)
			return self:GetStatusBarTexture()
		end,
		Set = function(self, texture)
			self:SetStatusBarTexture(texture, self.Layer)
		end,
		Type = Texture + nil,
	}

	doc [======[
		@name StatusBarTexturePath
		@type property
		@desc the texture file used for drawing the filled-in portion of the status bar
	]======]
	property "StatusBarTexturePath" {
		Get = function(self)
			return self:GetStatusBarTexture() and self:GetStatusBarTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetStatusBarTexture(texture, self.Layer)
		end,
		Type = String + nil,
	}

	doc [======[
		@name Layer`
		@type property
		@desc the layer used for drawing the filled-in portion of the status bar
	]======]
	property "Layer" {
		Get = function(self)
			return self.__Layer or "ARTWORK"
		end,
		Set = function(self, layer)
			self:SetStatusBarTexture(self:GetStatusBarTexture(), layer)
		end,
		Type = DrawLayer,
	}

	doc [======[
		@name Value
		@type property
		@desc  the value of the status bar
	]======]
	property "Value" {
		Get = function(self)
			return self:GetValue()
		end,
		Set = function(self, value)
			self:SetValue(value)
		end,
		Type = Number,
	}

	doc [======[
		@name RotatesTexture
		@type property
		@desc whether the status bar's texture is rotated to match its orientation
	]======]
	property "RotatesTexture" {
		Get = function(self)
			return self:GetRotatesTexture() and true or false
		end,
		Set = function(self, flag)
			self:SetRotatesTexture(flag)
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("StatusBar", nil, parent, ...)
	end
endclass "StatusBar"

partclass "StatusBar"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(StatusBar)
endclass "StatusBar"