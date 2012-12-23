-- Author      : Kurapica
-- Create Date : 7/16/2008 14:51
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- StatusBars are similar to Sliders, but they are generally used for display as they don't offer any tools to receive user input.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name StatusBar
-- @class table
-- @field MinMaxValue the minimum and maximum values of the status bar
-- @field Orientation the orientation of the status bar
-- @field StatusBarColor the color shading for the status bar's texture
-- @field StatusBarTexture the texture used for drawing the filled-in portion of the status bar
-- @field StatusBarTexturePath the texture file used for drawing the filled-in portion of the status bar
-- @field Layer the layer used for drawing the filled-in portion of the status bar
-- @field Value the value of the status bar
-- @field RotatesTexture
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.StatusBar", version) then
	return
end

class "StatusBar"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	-----------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the slider's or status bar's minimum and maximum values change
	-- @name StatusBar:OnMinMaxChanged
	-- @class function
	-- @param min New minimum value of the slider or the status bar
	-- @param max New maximum value of the slider or the status bar
	-- @usage function StatusBar:OnMinMaxChanged(min, max)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnMinMaxChanged"

	------------------------------------
	--- ScriptType, Run when the slider's or status bar's value changes
	-- @name StatusBar:OnValueChanged
	-- @class function
	-- @param value New value of the slider or the status bar
	-- @usage function StatusBar:OnValueChanged(value)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnValueChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the minimum and maximum values of the status bar
	-- @name StatusBar:GetMinMaxValues
	-- @class function
	-- @return minValue - Lower boundary for values represented on the status bar (number)
	-- @return maxValue - Upper boundary for values represented on the status bar (number)
	------------------------------------
	-- GetMinMaxValues

	------------------------------------
	--- Returns the orientation of the status bar
	-- @name StatusBar:GetOrientation
	-- @class function
	-- @return orientation - Token describing the orientation and direction of the status bar (string) <ul><li>HORIZONTAL - Fills from left to right as the status bar value increases
	-- @return VERTICAL - Fills from top to bottom as the status bar value increases
	------------------------------------
	-- GetOrientation

	------------------------------------
	--- Returns whether the status bar's texture is rotated to match its orientation
	-- @name StatusBar:GetRotatesTexture
	-- @class function
	-- @return rotate - 1 if the status bar texture should be rotated 90 degrees counter-clockwise when the status bar is vertically oriented; otherwise nil (1nil)
	------------------------------------
	-- GetRotatesTexture

	------------------------------------
	--- Returns the color shading used for the status bar's texture
	-- @name StatusBar:GetStatusBarColor
	-- @class function
	-- @return red - Red component of the color (0.0 - 1.0) (number)
	-- @return green - Green component of the color (0.0 - 1.0) (number)
	-- @return blue - Blue component of the color (0.0 - 1.0) (number)
	-- @return alpha - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetStatusBarColor

	------------------------------------
	--- Returns the Texture object used for drawing the filled-in portion of the status bar
	-- @name StatusBar:GetStatusBarTexture
	-- @class function
	-- @return texture - Reference to the Texture object used for drawing the filled-in portion of the status bar (texture)
	------------------------------------
	function GetStatusBarTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetStatusBarTexture(...))
	end

	------------------------------------
	--- Returns the current value of the status bar
	-- @name StatusBar:GetValue
	-- @class function
	-- @return value - Value indicating the amount of the status bar's area to be filled in (between minValue and maxValue, where minValue, maxValue = StatusBar:GetMinMaxValues()) (number)
	------------------------------------
	-- GetValue

	------------------------------------
	--- Sets the minimum and maximum values of the status bar
	-- @name StatusBar:SetMinMaxValues
	-- @class function
	-- @param minValue Lower boundary for values represented on the status bar (number)
	-- @param maxValue Upper boundary for values represented on the status bar (number)
	------------------------------------
	-- SetMinMaxValues

	------------------------------------
	--- Sets the orientation of the status bar
	-- @name StatusBar:SetOrientation
	-- @class function
	-- @param orientation Token describing the orientation and direction of the status bar (string) <ul><li>HORIZONTAL - Fills from left to right as the status bar value increases (default)
	-- @param VERTICAL Fills from top to bottom as the status bar value increases
	------------------------------------
	-- SetOrientation

	------------------------------------
	--- Sets whether the status bar's texture is rotated to match its orientation
	-- @name StatusBar:SetRotatesTexture
	-- @class function
	-- @param rotate True to rotate the status bar texture 90 degrees counter-clockwise when the status bar is vertically oriented; false otherwise (1nil)
	------------------------------------
	-- SetRotatesTexture

	------------------------------------
	--- Sets the color shading for the status bar's texture. As with :SetVertexColor(), this color is a shading applied to the texture image.
	-- @name StatusBar:SetStatusBarColor
	-- @class function
	-- @param red Red component of the color (0.0 - 1.0) (number)
	-- @param green Green component of the color (0.0 - 1.0) (number)
	-- @param blue Blue component of the color (0.0 - 1.0) (number)
	-- @param alpha Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetStatusBarColor

	------------------------------------
	--- Sets the texture used for drawing the filled-in portion of the status bar. The texture image is stretched to fill the dimensions of the entire status bar, then cropped to show only a portion corresponding to the status bar's current value.
	-- @name StatusBar:SetStatusBarTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	-- @param layer Graphics layer in which the texture should be drawn; defaults to ARTWORK if not specified (string, layer)
	------------------------------------
	function SetStatusBarTexture(self, texture, layer)
		self.__Layer = layer
		return self.__UI:SetStatusBarTexture(IGAS:GetUI(texture), layer)
	end

	------------------------------------
	--- Sets the value of the status bar
	-- @name StatusBar:SetValue
	-- @class function
	-- @param value Value indicating the amount of the status bar's area to be filled in (between minValue and maxValue, where minValue, maxValue = StatusBar:GetMinMaxValues()) (number)
	------------------------------------
	-- SetValue

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- MinMaxValue
	property "MinMaxValue" {
		Get = function(self)
			return MinMax(self:GetMinMaxValues())
		end,
		Set = function(self, set)
			self:SetMinMaxValues(set.min, set.max)
		end,
		Type = MinMax,
	}
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
	-- StatusBarColor
	property "StatusBarColor" {
		Get = function(self)
			return ColorType(self:GetStatusBarColor())
		end,
		Set = function(self, colorTable)
			self:SetStatusBarColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
		end,
		Type = ColorType,
	}
	-- StatusBarTexture
	property "StatusBarTexture" {
		Get = function(self)
			return self:GetStatusBarTexture()
		end,
		Set = function(self, texture)
			self:SetStatusBarTexture(texture, self.Layer)
		end,
		Type = Texture + nil,
	}
	-- StatusBarTexturePath
	property "StatusBarTexturePath" {
		Get = function(self)
			return self:GetStatusBarTexture() and self:GetStatusBarTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetStatusBarTexture(texture, self.Layer)
		end,
		Type = String + nil,
	}
	-- Layer
	property "Layer" {
		Get = function(self)
			return self.__Layer or "ARTWORK"
		end,
		Set = function(self, layer)
			self:SetStatusBarTexture(self:GetStatusBarTexture(), layer)
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
	-- RotatesTexture
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
	-- Script Handler
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