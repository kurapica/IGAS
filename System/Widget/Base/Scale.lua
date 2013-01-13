-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Scale", version) then
	return
end

class "Scale"
	inherit "Animation"

	doc [======[
		@name Scale
		@type class
		@desc Scale is an Animation type that automatically applies an affine scalar transformation to the region being animated as it progresses. You can set both the multiplier by which it scales, and the point from which it is scaled.
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetOrigin
		@type method
		@desc Returns the scale animation's origin point. During a scale animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the scale factor.
		@return point System.Widget.FramePoint, Anchor point for the scale origin
		@return xOffset number, Horizontal distance from the anchor point to the scale origin (in pixels)
		@return yOffset number, Vertical distance from the anchor point to the scale origin (in pixels)
	]======]

	doc [======[
		@name GetScale
		@type method
		@desc Returns the animation's scaling factors. At the end of the scale animation, the animated region's dimensions are equal to its initial dimensions multiplied by its scaling factors.
		@return xFactor number, Horizontal scaling factor
		@return yFactor number, Vertical scaling factor
	]======]

	doc [======[
		@name SetOrigin
		@type method
		@desc Sets the scale animation's origin point. During a scale animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the scale factor.
		@param point System.Widget.FramePoint, anchor point for the scale origin
		@param xOffset number, horizontal distance from the anchor point to the scale origin (in pixels)
		@param yOffset number, vertical distance from the anchor point to the scale origin (in pixels)
	]======]

	doc [======[
		@name SetScale
		@type method
		@desc Sets the animation's scaling factors. At the end of the scale animation, the animated region's dimensions are equal to its initial dimensions multiplied by its scaling factors.
		@param xFactor number, Horizontal scaling factor
		@param yFactor number, Vertical scaling factor
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Scale
	property "Scale" {
		Get = function(self)
			return Dimension(self:GetScale())
		end,
		Set = function(self, offset)
			self:SetScale(offset.x, offset.y)
		end,
		Type = Dimension,
	}
	-- Origin
	property "Origin" {
		Get = function(self)
			return AnimOriginType(self:GetOrigin())
		end,
		Set = function(self, origin)
			self:SetOrigin(origin.point, origin.x, origin.y)
		end,
		Type = AnimOriginType,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		if not Object.IsClass(parent, AnimationGroup) then
			error("Usage : Scale(name, parent) : 'parent' - AnimationGroup element expected.", 2)
		end

		return IGAS:GetUI(parent):CreateAnimation("Scale", nil, ...)
	end
endclass "Scale"

partclass "Scale"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Scale, AnimationGroup)
endclass "Scale"