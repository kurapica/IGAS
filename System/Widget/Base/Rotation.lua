-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Rotation is an Animation that automatically applies an affine rotation to the region being animated. You can set the origin around which the rotation is being done, and the angle of rotation in either degrees or radians.<br>
-- Rotation animations have no effect on FontStrings.
-- <br><br>inherit <a href=".\Animation.html">Animation</a> For all methods, properties and scriptTypes
-- @name Rotation
-- @class table
-- @field Degrees the animation's rotation amount (in degrees)
-- @field Radians the animation's rotation amount (in radians)
-- @field Origin the rotation animation's origin point
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Rotation", version) then
	return
end

class "Rotation"
	inherit "Animation"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the animation's rotation amount (in degrees)
	-- @name Rotation:GetDegrees
	-- @class function
	-- @return degrees - Amount by which the region rotates over the animation's duration (in degrees; positive values for counter-clockwise rotation, negative for clockwise) (number)
	------------------------------------
	-- GetDegrees

	------------------------------------
	--- Returns the rotation animation's origin point. During a rotation animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the rotation amount.
	-- @name Rotation:GetOrigin
	-- @class function
	-- @return point - Anchor point for the rotation origin (string, anchorPoint)
	-- @return xOffset - Horizontal distance from the anchor point to the rotation origin (in pixels) (number)
	-- @return yOffset - Vertical distance from the anchor point to the rotation origin (in pixels) (number)
	------------------------------------
	-- GetOrigin

	------------------------------------
	--- Returns the animation's rotation amount (in radians)
	-- @name Rotation:GetRadians
	-- @class function
	-- @return radians - Amount by which the region rotates over the animation's duration (in radians; positive values for counter-clockwise rotation, negative for clockwise) (number)
	------------------------------------
	-- GetRadians

	------------------------------------
	--- Sets the animation's rotation amount (in degrees)
	-- @name Rotation:SetDegrees
	-- @class function
	-- @param degrees Amount by which the region should rotate over the animation's duration (in degrees; positive values for counter-clockwise rotation, negative for clockwise) (number)
	------------------------------------
	-- SetDegrees

	------------------------------------
	--- Sets the rotation animation's origin point. During a rotation animation, the origin point remains in place while the positions of all other points in the scaled region are moved according to the rotation amount.
	-- @name Rotation:SetOrigin
	-- @class function
	-- @param point Anchor point for the rotation origin (string, anchorPoint)
	-- @param xOffset Horizontal distance from the anchor point to the rotation origin (in pixels) (number)
	-- @param yOffset Vertical distance from the anchor point to the rotation origin (in pixels) (number)
	------------------------------------
	-- SetOrigin

	------------------------------------
	--- Sets the animation's rotation amount (in radians)
	-- @name Rotation:SetRadians
	-- @class function
	-- @param radians Amount by which the region should rotate over the animation's duration (in radians; positive values for counter-clockwise rotation, negative for clockwise) (number)
	------------------------------------
	-- SetRadians

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Degrees
	property "Degrees" {
		Get = function(self)
			return self:GetDegrees()
		end,
		Set = function(self, degrees)
			self:SetDegrees(degrees)
		end,
		Type = Number,
	}
	-- Radians
	property "Radians" {
		Get = function(self)
			return self:GetRadians()
		end,
		Set = function(self, radians)
			self:SetRadians(radians)
		end,
		Type = Number,
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
	function Rotation(name, parent, ...)
		if not Object.IsClass(parent, AnimationGroup) then
			error("Usage : Rotation(name, parent) : 'parent' - AnimationGroup element expected.", 2)
		end

		return UIObject(name, parent, IGAS:GetUI(parent):CreateAnimation("Rotation", nil, ...))
	end
endclass "Rotation"

partclass "Rotation"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Rotation, AnimationGroup)
endclass "Rotation"