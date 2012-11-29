-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Button is the primary means for users to control the game and their characters.
-- <br><br>inherit <a href=".\Animation.html">Animation</a> For all methods, properties and scriptTypes
-- @name Scale
-- @class table
-- @field Scale the animation's scaling factors
-- @field Origin the scale animation's origin point
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Scale", version) then
	return
end

class "Scale"
	inherit "Animation"
	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the scale animation's origin point. During a scale animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the scale factor.
	-- @name Scale:GetOrigin
	-- @class function
	-- @return point - Anchor point for the scale origin (string, anchorPoint)
	-- @return xOffset - Horizontal distance from the anchor point to the scale origin (in pixels) (number)
	-- @return yOffset - Vertical distance from the anchor point to the scale origin (in pixels) (number)
	------------------------------------
	-- GetOrigin

	------------------------------------
	--- Returns the animation's scaling factors. At the end of the scale animation, the animated region's dimensions are equal to its initial dimensions multiplied by its scaling factors.
	-- @name Scale:GetScale
	-- @class function
	-- @return xFactor - Horizontal scaling factor (number)
	-- @return yFactor - Vertical scaling factor (number)
	------------------------------------
	-- GetScale

	------------------------------------
	--- Sets the scale animation's origin point. During a scale animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the scale factor.
	-- @name Scale:SetOrigin
	-- @class function
	-- @param point Anchor point for the scale origin (string, anchorPoint)
	-- @param xOffset Horizontal distance from the anchor point to the scale origin (in pixels) (number)
	-- @param yOffset Vertical distance from the anchor point to the scale origin (in pixels) (number)
	------------------------------------
	-- SetOrigin

	------------------------------------
	--- Sets the animation's scaling factors. At the end of the scale animation, the animated region's dimensions are equal to its initial dimensions multiplied by its scaling factors.
	-- @name Scale:SetScale
	-- @class function
	-- @param xFactor Horizontal scaling factor (number)
	-- @param yFactor Vertical scaling factor (number)
	------------------------------------
	-- SetScale

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
	function Scale(name, parent, ...)
		if not Object.IsClass(parent, AnimationGroup) then
			error("Usage : Scale(name, parent) : 'parent' - AnimationGroup element expected.", 2)
		end

		return UIObject(name, parent, IGAS:GetUI(parent):CreateAnimation("Scale", nil, ...))
	end
endclass "Scale"

partclass "Scale"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Scale, AnimationGroup)
endclass "Scale"