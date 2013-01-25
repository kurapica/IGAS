-- Author      : Kurapica
-- Create Date : 7/16/2008 14:16
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 6
if not IGAS:NewAddon("IGAS.Widget.ScrollFrame", version) then
	return
end

class "ScrollFrame"
	inherit "Frame"

	doc [======[
		@name ScrollFrame
		@type class
		@desc ScrollFrame is how a large body of content can be displayed through a small window. The ScrollFrame is the size of the "window" through which you want to see the larger content, and it has another frame set as a "ScrollChild" containing the full content.
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	doc [======[
		@name OnHorizontalScroll
		@type script
		@desc Run when the scroll frame's horizontal scroll position changes
		@param offset number, new horizontal scroll position (in pixels, measured from the leftmost scroll position)
	]======]
	script "OnHorizontalScroll"

	doc [======[
		@name OnScrollRangeChanged
		@type script
		@desc Run when the scroll frame's scroll position is changed
		@param xOffset number, new horizontal scroll range (in pixels, measured from the leftmost scroll position)
		@param yOffset number, new vertical scroll range (in pixels, measured from the topmost scroll position)
	]======]
	script "OnScrollRangeChanged"

	doc [======[
		@name OnVerticalScroll
		@type script
		@desc Run when the scroll frame's vertical scroll position changes
		@param offset number, new vertical scroll position (in pixels, measured from the topmost scroll position)
	]======]
	script "OnVerticalScroll"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetHorizontalScroll
		@type method
		@desc Returns the scroll frame's current horizontal scroll position
		@return number Current horizontal scroll position
	]======]

	doc [======[
		@name GetHorizontalScrollRange
		@type method
		@desc Returns the scroll frame's maximum horizontal (rightmost) scroll position
		@return number Maximum horizontal scroll position
	]======]

	doc [======[
		@name GetScrollChild
		@type method
		@desc Returns the frame scrolled by the scroll frame
		@return widgetObject Reference to the Frame object scrolled by the scroll frame
	]======]

	doc [======[
		@name GetVerticalScroll
		@type method
		@desc Returns the scroll frame's current vertical scroll position
		@return number Current vertical scroll position
	]======]

	doc [======[
		@name GetVerticalScrollRange
		@type method
		@desc Returns the scroll frame's maximum vertical (bottom) scroll position
		@return number Maximum vertical scroll position
	]======]

	doc [======[
		@name SetHorizontalScroll
		@type method
		@desc Sets the scroll frame's horizontal scroll position
		@param scroll number, Current horizontal scroll position
		@return nil
	]======]

	doc [======[
		@name SetScrollChild
		@type method
		@desc Sets the scroll child for the scroll frame. The scroll child frame represents the (generally larger) area into which the scroll frame provides a (generally smaller) movable "window". The child must have an absolute size
		@param frame widgetObject, Reference to another frame to be the ScrollFrame's child.
		@return nil
	]======]

	doc [======[
		@name SetVerticalScroll
		@type method
		@desc Sets the scroll frame's vertical scroll position
		@param scroll number, Current vertical scroll position
		@return nil
	]======]

	doc [======[
		@name UpdateScrollChildRect
		@type method
		@desc Updates the position of the scroll frame's child. The ScrollFrame automatically adjusts the position of the child frame when scrolled, but manually updating its position may be necessary when changing the size or contents of the child frame.
		@return nil
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name HorizontalScroll
		@type property
		@desc the scroll frame's current horizontal scroll position
	]======]
	property "HorizontalScroll" {
		Get = function(self)
			return self:GetHorizontalScroll()
		end,
		Set = function(self, offset)
			self:SetHorizontalScroll(offset)
		end,
		Type = Number,
	}

	doc [======[
		@name VerticalScroll
		@type property
		@desc the scroll frame's vertical scroll position
	]======]
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