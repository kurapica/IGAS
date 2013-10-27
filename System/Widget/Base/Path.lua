-- Author      : Kurapica
-- Create Date : 2013/04/11
-- ChangeLog

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Path", version) then
	return
end

class "Path"
	inherit "Animation"

	doc [======[
		@name Path
		@type class
		@desc Path is an Animation type that  combines multiple transitions into a single control path with multiple ControlPoints.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name CreateControlPoint
		@type method
		@desc Creates a new control point for the given path
		@format [name [, template [, order]]]
		@param name string, the name of the object
		@param template string, the template from which the new point should inherit
		@param order number, the order of the new control point
		@return System.Widget.ControlPoint Reference to the new control point object
	]======]
	function CreateControlPoint(self, name, ...)
		return ControlPoint(name, self, ...)
	end

	doc [======[
		@name GetControlPoints
		@type method
		@desc Returns the control points that belong to a given path
		@return ...  A list of ControlPoint objects that belong to the given path.
	]======]
	function GetControlPoints(self)
		local lst = {IGAS:GetUI(self):GetControlPoints()}

		for i, v in ipairs(lst) do
			lst[i] = IGAS:GetWrapper(v)
		end

		return unpack(lst)
	end

	doc [======[
		@name GetMaxOrder
		@type method
		@desc Returns the maximum order of the control points belonging to a given path
		@return number The maximum order of the control points belonging to the given path.
	]======]

	doc [======[
		@name SetCurve
		@type method
		@desc Sets the curve type for the path animation
		@param curveType string, NONE | SMOOTH
		@return nil
	]======]

	doc [======[
		@name GetCurve
		@type method
		@desc Returns the curveType of the given path
		@return curveType string, NONE | SMOOTH
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		if not Object.IsClass(parent, AnimationGroup) then
			error("Usage : Path(name, parent) : 'parent' - AnimationGroup element expected.", 2)
		end

		return IGAS:GetUI(parent):CreateAnimation("Path", nil, ...)
	end
endclass "Path"

class "Path"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Path, AnimationGroup)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Curve
		@type property
		@desc The curveType of the given path
	]======]
	property "Curve" { Type = AnimCurveType }

endclass "Path"

class "ControlPoint"
	inherit "UIObject"

	doc [======[
		@name ControlPoint
		@type class
		@desc A special type of UIObject that represent a point in a Path Animation.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name SetOffset
		@type method
		@desc Sets the offset for the control point
		@param xOffset numner, Distance away from the left edge of the screen (in pixels) to move the region over the animation's duration
		@param yOffset number, Distance away from the bottom edge of the screen (in pixels) to move the region over the animation's duration
		@return nil
	]======]

	doc [======[
		@name GetOffset
		@type method
		@desc Gets the offset for the control point
		@return xOffset number, Distance away from the left edge of the screen (in pixels) to move the region over the animation's duration
		@return yOffset number, Distance away from the bottom edge of the screen (in pixels) to move the region over the animation's duration
	]======]

	doc [======[
		@name SetOrder
		@type method
		@desc Sets the order for control point to play within its parent group.
		@param order number, position at which the animation should play relative to others in its group (between 0 and 100)
		@return nil
	]======]

	doc [======[
		@name GetOrder
		@type method
		@desc Returns the order of control point within its parent group.
		@return number Position at which the animation will play relative to others in its group (between 0 and 100)
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		if not Object.IsClass(parent, Path) then
			error("Usage : ControlPoint(name, parent) : 'parent' - Path UI element expected.", 2)
		end
		return IGAS:GetUI(parent):CreateControlPoint(nil, ...)
	end
endclass "ControlPoint"

class "ControlPoint"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(ControlPoint, Path, AnimationGroup)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Offset
		@type property
		@desc the control point offsets
	]======]
	property "Offset" {
		Get = function(self)
			return Dimension(elf:GetOffset())
		end,
		Set = function(self, offset)
			return self:SetOffset(offset.x, offset.y)
		end,
		Type = Dimension,
	}

	doc [======[
		@name Order
		@type property
		@desc Position at which the animation will play relative to others in its group (between 0 and 100)
	]======]
	property "Order" { Type = Number }

endclass "ControlPoint"