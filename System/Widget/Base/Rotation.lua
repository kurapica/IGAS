-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Rotation", version) then
	return
end

class "Rotation"
	inherit "Animation"

	doc [======[
		@name Rotation
		@type class
		@desc Rotation is an Animation that automatically applies an affine rotation to the region being animated. You can set the origin around which the rotation is being done, and the angle of rotation in either degrees or radians.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		if not Object.IsClass(parent, AnimationGroup) then
			error("Usage : Rotation(name, parent) : 'parent' - AnimationGroup element expected.", 2)
		end

		return IGAS:GetUI(parent):CreateAnimation("Rotation", nil, ...)
	end
endclass "Rotation"

class "Rotation"
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetDegrees
		@type method
		@desc Returns the animation's rotation amount (in degrees)
		@return number Amount by which the region rotates over the animation's duration (in degrees; positive values for counter-clockwise rotation, negative for clockwise)
	]======]

	doc [======[
		@name GetOrigin
		@type method
		@desc Returns the rotation animation's origin point. During a rotation animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the rotation amount.
		@return point System.Widget.FramePoint, anchor point for the rotation origin
		@return xOffset number, horizontal distance from the anchor point to the rotation origin (in pixels)
		@return yOffset number, vertical distance from the anchor point to the rotation origin (in pixels)
	]======]

	doc [======[
		@name GetRadians
		@type method
		@desc Returns the animation's rotation amount (in radians)
		@return number Amount by which the region rotates over the animation's duration (in radians; positive values for counter-clockwise rotation, negative for clockwise)
	]======]

	doc [======[
		@name SetDegrees
		@type method
		@desc Sets the animation's rotation amount (in degrees)
		@param degrees number, Amount by which the region should rotate over the animation's duration (in degrees; positive values for counter-clockwise rotation, negative for clockwise)
		@return nil
	]======]

	doc [======[
		@name SetOrigin
		@type method
		@desc Sets the rotation animation's origin point. During a rotation animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the rotation amount.
		@param point System.Widget.FramePoint, anchor point for the rotation origin
		@param xOffset number, horizontal distance from the anchor point to the rotation origin (in pixels)
		@param yOffset number, vertical distance from the anchor point to the rotation origin (in pixels)
	]======]

	doc [======[
		@name SetRadians
		@type method
		@desc Sets the animation's rotation amount (in radians)
		@param radians number, amount by which the region should rotate over the animation's duration (in radians; positive values for counter-clockwise rotation, negative for clockwise)
		@return nil
	]======]

	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Rotation, AnimationGroup)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Degrees
		@type property
		@desc the animation's rotation amount (in degrees)
	]======]
	property "Degrees" { Type = Number }

	doc [======[
		@name Radians
		@type property
		@desc the animation's rotation amount (in radians)
	]======]
	property "Radians" { Type = Number }

	doc [======[
		@name Origin
		@type property
		@desc the rotation animation's origin point
	]======]
	property "Origin" {
		Get = function(self)
			return AnimOriginType(self:GetOrigin())
		end,
		Set = function(self, origin)
			self:SetOrigin(origin.point, origin.x, origin.y)
		end,
		Type = AnimOriginType,
	}

endclass "Rotation"