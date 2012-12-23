-- Author      : Kurapica
-- Create Date : 7/16/2008 14:16
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- ScrollFrame is how a large body of content can be displayed through a small window. The ScrollFrame is the size of the "window" through which you want to see the larger content, and it has another frame set as a "ScrollChild" containing the full content.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name ScrollFrame
-- @class table
-- @field HorizontalScroll the scroll frame's current horizontal scroll position
-- @field VerticalScroll the scroll frame's vertical scroll position
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.ScrollFrame", version) then
	return
end

class "ScrollFrame"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the scroll frame's horizontal scroll position changes
	-- @name ScrollFrame:OnHorizontalScroll
	-- @class function
	-- @param offset New horizontal scroll position (in pixels, measured from the leftmost scroll position)
	-- @usage function ScrollFrame:OnHorizontalScroll(offset)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHorizontalScroll"

	------------------------------------
	--- ScriptType, Run when the scroll frame's scroll position is changed
	-- @name ScrollFrame:OnScrollRangeChanged
	-- @class function
	-- @param xOffset New horizontal scroll range (in pixels, measured from the leftmost scroll position)
	-- @param yOffset New vertical scroll range (in pixels, measured from the topmost scroll position)
	-- @usage function ScrollFrame:OnScrollRangeChanged(xOffset, yOffset)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnScrollRangeChanged"

	------------------------------------
	--- ScriptType, Run when the scroll frame's vertical scroll position changes
	-- @name ScrollFrame:OnVerticalScroll
	-- @class function
	-- @param offset New vertical scroll position (in pixels, measured from the topmost scroll position)
	-- @usage function ScrollFrame:OnVerticalScroll(offset)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnVerticalScroll"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns the scroll frame's current horizontal scroll position
	-- @name ScrollFrame:GetHorizontalScroll
	-- @class function
	-- @return scroll - Current horizontal scroll position (0 = at left edge, frame:GetHorizontalScrollRange() = at right edge) (number)
	------------------------------------
	-- GetHorizontalScroll

	------------------------------------
	--- Returns the scroll frame's maximum horizontal (rightmost) scroll position
	-- @name ScrollFrame:GetHorizontalScrollRange
	-- @class function
	-- @return maxScroll - Maximum horizontal scroll position (representing the right edge of the scrolled area) (number)
	------------------------------------
	-- GetHorizontalScrollRange

	------------------------------------
	--- Returns the frame scrolled by the scroll frame
	-- @name ScrollFrame:GetScrollChild
	-- @class function
	-- @return scrollChild - Reference to the Frame object scrolled by the scroll frame (frame)
	------------------------------------
	-- GetScrollChild

	------------------------------------
	--- Returns the scroll frame's current vertical scroll position
	-- @name ScrollFrame:GetVerticalScroll
	-- @class function
	-- @return scroll - Current vertical scroll position (0 = at top edge, frame:GetVerticalScrollRange() = at bottom edge) (number)
	------------------------------------
	-- GetVerticalScroll

	------------------------------------
	--- Returns the scroll frame's maximum vertical (bottom) scroll position
	-- @name ScrollFrame:GetVerticalScrollRange
	-- @class function
	-- @return maxScroll - Maximum vertical scroll position (representing the bottom edge of the scrolled area) (number)
	------------------------------------
	-- GetVerticalScrollRange

	------------------------------------
	--- Sets the scroll frame's horizontal scroll position
	-- @name ScrollFrame:SetHorizontalScroll
	-- @class function
	-- @param scroll Current horizontal scroll position (0 = at left edge, frame:GetHorizontalScrollRange() = at right edge) (number)
	------------------------------------
	-- SetHorizontalScroll

	------------------------------------
	--- Sets the scroll child for the scroll frame. The scroll child frame represents the (generally larger) area into which the scroll frame provides a (generally smaller) movable "window". The child must have an absolute size, set either by &lt;AbsDimension&gt; in XML or using both SetWidth() and SetHeight() in Lua.</p>
	--- <p>Setting a frame's scroll child involves changing the child frame's parent -- thus, if the frame's scroll child is protected, this operation cannot be performed while in combat.
	-- @name ScrollFrame:SetScrollChild
	-- @class function
	-- @param frame Reference to another frame to be the ScrollFrame's child. (frame)
	------------------------------------
	-- SetScrollChild

	------------------------------------
	--- Sets the scroll frame's vertical scroll position
	-- @name ScrollFrame:SetVerticalScroll
	-- @class function
	-- @param scroll Current vertical scroll position (0 = at top edge, frame:GetVerticalScrollRange() = at bottom edge) (number)
	------------------------------------
	-- SetVerticalScroll

	------------------------------------
	--- Updates the position of the scroll frame's child. The ScrollFrame automatically adjusts the position of the child frame when scrolled, but manually updating its position may be necessary when changing the size or contents of the child frame.
	-- @name ScrollFrame:UpdateScrollChildRect
	-- @class function
	------------------------------------
	-- UpdateScrollChildRect

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- HorizontalScroll
	property "HorizontalScroll" {
		Get = function(self)
			return self:GetHorizontalScroll()
		end,
		Set = function(self, offset)
			self:SetHorizontalScroll(offset)
		end,
		Type = Number,
	}
	-- VerticalScroll
	property "VerticalScroll" {
		Get = function(self)
			return self:GetVerticalScroll()
		end,
		Set = function(self, offset)
			self:SetVerticalScroll(offset)
		end,
		Type = Number,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("ScrollFrame", nil, parent, ...)
	end
endclass "ScrollFrame"

partclass "ScrollFrame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(ScrollFrame)
endclass "ScrollFrame"