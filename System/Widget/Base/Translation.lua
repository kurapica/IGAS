-- Author      : Kurapica
-- Create Date : 8/18/2009
-- ChangeLog
--				2011/03/11	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Translation is an Animation type that applies an affine translation to its affected region automatically as it progresses.
-- <br><br>inherit <a href=".\Animation.html">Animation</a> For all methods, properties and scriptTypes
-- @name Translation
-- @class table
-- @field Offset the animation's translation offsets
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.Translation", version) then
	return
end

class "Translation"
	inherit "Animation"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Sets the animation's translation offsets
	-- @name Translation:SetOffset
	-- @class function
	-- @param xOffset Distance away from the left edge of the screen (in pixels) to move the region over the animation's duration (number)
	-- @param yOffset Distance away from the bottom edge of the screen (in pixels) to move the region over the animation's duration (number)
	-- @usage Translation:SetOffset(10, 20)
	------------------------------------
	-- SetOffset

	------------------------------------
	--- Gets the animation's translation offsets
	-- @name Translation:GetOffset
	-- @class function
	-- @return xOffset - Distance away from the left edge of the screen (in pixels) to move the region over the animation's duration (number)
	-- @return yOffset - Distance away from the bottom edge of the screen (in pixels) to move the region over the animation's duration (number)
	-- @usage Translation:GetOffset()
	------------------------------------
	-- GetOffset

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Offset
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
	-- Script Handler
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