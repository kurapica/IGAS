-- Author      : Kurapica
-- Create Date : 7/16/2008 11:15
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.ColorSelect", version) then
	return
end

class "ColorSelect"
	inherit "Frame"

	doc [======[
		@name ColorSelect
		@type class
		@desc ColorSelect is a very specialized type of frame with a specific purpose; to allow the user to interactively select a color, typically to control the appearance of another UI element.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnColorSelect
		@type event
		@desc Run when the color select frame's color selection changes
		@param r number, red component of the selected color (0.0 - 1.0)
		@param g number, green component of the selected color (0.0 - 1.0)
		@param b number, blue component of the selected color (0.0 - 1.0)
		@param a number, alpha component of the selected color (0.0 - 1.0)
	]======]
	event "OnColorSelect"

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("ColorSelect", nil, parent, ...)
	end
endclass "ColorSelect"

class "ColorSelect"
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetColorHSV
		@type method
		@desc Returns the hue, saturation and value of the currently selected color
		@return hue number, Hue of the selected color (angle on the color wheel in degrees; 0 = red, increasing counter-clockwise)
		@return saturation number, Saturation of the selected color (0.0 - 1.0)
		@return value number, Value of the selected color (0.0 - 1.0)
	]======]

	doc [======[
		@name GetColorRGB
		@type method
		@desc Returns the red, green and blue components of the currently selected color
		@return red number, Red component of the color (0.0 - 1.0)
		@return blue number, Blue component of the color (0.0 - 1.0)
		@return green number, Green component of the color (0.0 - 1.0)
	]======]

	doc [======[
		@name GetColorValueTexture
		@type method
		@desc Returns the texture for the color picker's value slider background. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. (In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.)
		@return System.Widget.Texture Reference to the Texture object used for drawing the value slider background
	]======]
	function GetColorValueTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetColorValueTexture(...))
	end

	doc [======[
		@name GetColorValueThumbTexture
		@type method
		@desc  Returns the texture for the color picker's value slider thumb. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. (In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.) The thumb texture is the movable part indicating the current value selection.
		@return System.Widget.Texture Reference to the Texture object used for drawing the slider thumb
	]======]
	function GetColorValueThumbTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetColorValueThumbTexture(...))
	end

	doc [======[
		@name GetColorWheelTexture
		@type method
		@desc Returns the texture for the color picker's hue/saturation wheel
		@return System.Widget.Texture Reference to the Texture object used for drawing the hue/saturation wheel
	]======]
	function GetColorWheelTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetColorWheelTexture(...))
	end

	doc [======[
		@name GetColorWheelThumbTexture
		@type method
		@desc Returns the texture for the selection indicator on the color picker's hue/saturation wheel
		@return System.Widget.Texture Reference to the Texture object used for drawing the hue/saturation wheel's selection indicator
	]======]
	function GetColorWheelThumbTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetColorWheelThumbTexture(...))
	end

	doc [======[
		@name SetColorHSV
		@type method
		@desc Sets the color picker's selected color by hue, saturation and value
		@param hue number,ue of a color (angle on the color wheel in degrees; 0 = red, increasing counter-clockwise)
		@param saturation number,aturation of a color (0.0 - 1.0)
		@param value number,alue of a color (0.0 - 1.0)
		@return nil
	]======]

	doc [======[
		@name SetColorRGB
		@type method
		@desc Sets the color picker's selected color by red, green and blue components
		@param red number,ed component of the color (0.0 - 1.0)
		@param blue number,lue component of the color (0.0 - 1.0)
		@param green number,reen component of the color (0.0 - 1.0)
		@return nil
	]======]

	doc [======[
		@name SetColorValueTexture
		@type method
		@desc Sets the Texture object used to display the color picker's value slider. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.</p>
		@param texture|filename
		@param texture System.Widget.Texture, Reference to a Texture object
		@param filename string, Path to a texture image file
		@return nil
	]======]

	doc [======[
		@name SetColorValueThumbTexture
		@type method
		@desc Sets the texture for the color picker's value slider thumb. The color picker's value slider displays a value gradient (and allows control of the color's value component) for whichever hue and saturation is selected in the color wheel. (In the default UI's ColorPickerFrame, this part is found to the right of the color wheel.) The thumb texture is the movable part indicating the current value selection.
		@param texture|filename
		@param texture System.Widget.Texture, Reference to a Texture object
		@param filename string, Path to a texture image file
		@return nil
	]======]

	------------------------------------
	---
	-- @name ColorSelect:SetColorWheelTexture
	-- @class function
	-- @param texture Reference to a Texture object (texture)
	------------------------------------
	-- SetColorWheelTexture
	doc [======[
		@name SetColorWheelTexture
		@type method
		@desc Sets the Texture object used to display the color picker's hue/saturation wheel. This method does not allow changing the texture image displayed for the color wheel; rather, it allows customization of the size and placement of the Texture object into which the game engine draws the standard color wheel image.
		@param texture|filename
		@param texture System.Widget.Texture, Reference to a Texture object
		@param filename string, Path to a texture image file
		@return nil
	]======]

	doc [======[
		@name SetColorWheelThumbTexture
		@type method
		@desc Sets the texture for the selection indicator on the color picker's hue/saturation wheel
		@param texture|filename
		@param texture System.Widget.Texture, Reference to a Texture object
		@param filename string, Path to a texture image file
		@return nil
	]======]

	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(ColorSelect)
endclass "ColorSelect"