-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Translation", version) then
	return
end

class "Translation"
	inherit "Animation"

	doc [======[
		@name Translation
		@type class
		@desc Translation is an Animation type that applies an affine translation to its affected region automatically as it progresses.
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
		@desc Sets the animation's translation offsets
		@param xOffset numner, Distance away from the left edge of the screen (in pixels) to move the region over the animation's duration
		@param yOffset number, Distance away from the bottom edge of the screen (in pixels) to move the region over the animation's duration
		@return nil
	]======]

	doc [======[
		@name GetOffset
		@type method
		@desc Gets the animation's translation offsets
		@return xOffset number, Distance away from the left edge of the screen (in pixels) to move the region over the animation's duration
		@return yOffset number, Distance away from the bottom edge of the screen (in pixels) to move the region over the animation's duration
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Offset
		@type property
		@desc the animation's translation offsets
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

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		if not Object.IsClass(parent, AnimationGroup) then
			error("Usage : Translation(name, parent) : 'parent' - AnimationGroup element expected.", 2)
		end

		return IGAS:GetUI(parent):CreateAnimation("Translation", nil, ...)
	end
endclass "Translation"

partclass "Translation"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Translation, AnimationGroup)
endclass "Translation"