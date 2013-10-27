-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Alpha", version) then
	return
end

class "Alpha"
	inherit "Animation"

	doc [======[
		@name Alpha
		@type class
		@desc  Alpha is a type of animation that automatically changes the transparency level of its attached region as it progresses. You can set the degree by which it will change the alpha as a fraction; for instance, a change of -1 will fade out a region completely
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetChange
		@type method
		@desc Returns the animation's amount of alpha (opacity) change. A region's alpha value can be between 0 (fully transparent) and 1 (fully opaque); thus, an animation which changes alpha by 1 will always increase the region to full opacity, regardless of the region's existing alpha (and an animation whose change amount is -1 will reduce the region to fully transparent).
		@return number Amount by which the region's alpha value changes over the animation's duration (between -1 and 1)
	]======]

	doc [======[
		@name SetChange
		@type method
		@desc Sets the animation's amount of alpha (opacity) change. A region's alpha value can be between 0 (fully transparent) and 1 (fully opaque); thus, an animation which changes alpha by 1 will always increase the region to full opacity, regardless of the region's existing alpha (and an animation whose change amount is -1 will reduce the region to fully transparent).
		@param change number, Amount by which the region's alpha value should change over the animation's duration (between -1 and 1)
		@return nil
	]======]

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		if not Object.IsClass(parent, AnimationGroup) then
			error("Usage : Alpha(name, parent) : 'parent' - AnimationGroup element expected.", 2)
		end

		return IGAS:GetUI(parent):CreateAnimation("Alpha", nil, ...)
	end
endclass "Alpha"

class "Alpha"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Alpha, AnimationGroup)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Change
		@type property
		@desc the animation's amount of alpha (opacity) change
	]======]
	property "Change" { Type = Number }

endclass "Alpha"