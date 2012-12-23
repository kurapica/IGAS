-- Author      : Kurapica
-- Create Date : 7/16/2008 11:15
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- ColorSelect is a very specialized type of frame with a specific purpose; to allow the user to interactively select a color, typically to control the appearance of another UI element.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name ColorSelect
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.ColorSelect", version) then
	return
end

class "ColorSelect"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the color select frame's color selection changes
	-- @name ColorSelect:OnColorSelect
	-- @class function
	-- @param r Red component of the selected color (0.0 - 1.0)
	-- @param g Green component of the selected color (0.0 - 1.0)
	-- @param b Blue component of the selected color (0.0 - 1.0)
	-- @usage function ColorSelect:OnColorSelect(r, g, b)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnColorSelect"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the hue, saturation and value of the currently selected color
	-- @name ColorSelect:GetColorHSV
	-- @class function
	-- @return hue - Hue of the selected color (angle on the color wheel in degrees; 0 = red, increasing counter-clockwise) (number)
	-- @return saturation - Saturation of the selected color (0.0 - 1.0) (number)
	-- @return value - Value of the selected color (0.0 - 1.0) (number)
	------------------------------------
	-- GetColorHSV

	------------------------------------
	--- Returns the red, green and blue components of the currently selected color
	-- @name ColorSelect:GetColorRGB
	-- @class function
	-- @return red - Red component of the color (0.0 - 1.0) (number)
	-- @return blue - Blue component of the color (0.0 - 1.0) (number)
	-- @return green - Green component of the color (0.0 - 1.0) (number)
	------------------------------------
	-- GetColorRGB

	------------------------------------
	--- Returns the texture for the color picker's value slider background. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. (In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.)
	-- @name ColorSelect:GetColorValueTexture
	-- @class function
	-- @return texture - Reference to the Texture object used for drawing the value slider background (texture)
	------------------------------------
	function GetColorValueTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetColorValueTexture(...))
	end

	------------------------------------
	--- Returns the texture for the color picker's value slider thumb. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. (In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.) The thumb texture is the movable part indicating the current value selection.
	-- @name ColorSelect:GetColorValueThumbTexture
	-- @class function
	-- @return texture - Reference to the Texture object used for drawing the slider thumb (texture)
	------------------------------------
	function GetColorValueThumbTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetColorValueThumbTexture(...))
	end

	------------------------------------
	--- Returns the texture for the color picker's hue/saturation wheel
	-- @name ColorSelect:GetColorWheelTexture
	-- @class function
	-- @return texture - Reference to the Texture object used for drawing the hue/saturation wheel (texture)
	------------------------------------
	function GetColorWheelTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetColorWheelTexture(...))
	end

	------------------------------------
	--- Returns the texture for the selection indicator on the color picker's hue/saturation wheel
	-- @name ColorSelect:GetColorWheelThumbTexture
	-- @class function
	-- @return texture - Reference to the Texture object used for drawing the hue/saturation wheel's selection indicator (texture)
	------------------------------------
	function GetColorWheelThumbTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetColorWheelThumbTexture(...))
	end

	------------------------------------
	--- Sets the color picker's selected color by hue, saturation and value
	-- @name ColorSelect:SetColorHSV
	-- @class function
	-- @param hue Hue of a color (angle on the color wheel in degrees; 0 = red, increasing counter-clockwise) (number)
	-- @param saturation Saturation of a color (0.0 - 1.0) (number)
	-- @param value Value of a color (0.0 - 1.0) (number)
	------------------------------------
	-- SetColorHSV

	------------------------------------
	--- Sets the color picker's selected color by red, green and blue components
	-- @name ColorSelect:SetColorRGB
	-- @class function
	-- @param red Red component of the color (0.0 - 1.0) (number)
	-- @param blue Blue component of the color (0.0 - 1.0) (number)
	-- @param green Green component of the color (0.0 - 1.0) (number)
	------------------------------------
	-- SetColorRGB

	------------------------------------
	--- Sets the Texture object used to display the color picker's value slider. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.</p>
	--- <p>This method does not allow changing the texture image displayed for the slider background; rather, it allows customization of the size and placement of the Texture object into which the game engine draws the color value gradient.
	-- @name ColorSelect:SetColorValueTexture
	-- @class function
	-- @param texture Reference to a Texture object (texture)
	------------------------------------
	-- SetColorValueTexture

	------------------------------------
	--- Sets the texture for the color picker's value slider thumb. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. (In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.) The thumb texture is the movable part indicating the current value selection.
	-- @name ColorSelect:SetColorValueThumbTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	------------------------------------
	-- SetColorValueThumbTexture

	------------------------------------
	--- Sets the Texture object used to display the color picker's hue/saturation wheel. This method does not allow changing the texture image displayed for the color wheel; rather, it allows customization of the size and placement of the Texture object into which the game engine draws the standard color wheel image.
	-- @name ColorSelect:SetColorWheelTexture
	-- @class function
	-- @param texture Reference to a Texture object (texture)
	------------------------------------
	-- SetColorWheelTexture

	------------------------------------
	--- Sets the texture for the selection indicator on the color picker's hue/saturation wheel
	-- @name ColorSelect:SetColorWheelThumbTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	------------------------------------
	-- SetColorWheelThumbTexture

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
		return CreateFrame("ColorSelect", nil, parent, ...)
	end
endclass "ColorSelect"

partclass "ColorSelect"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(ColorSelect)
endclass "ColorSelect"