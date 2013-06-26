-- Author      : Kurapica
-- Create Date : 2011/03/13
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
---
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name ArchaeologyDigSiteFrame
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.ArchaeologyDigSiteFrame", version) then
	return
end

class "ArchaeologyDigSiteFrame"
	inherit "Frame"

	doc [======[
		@name ArchaeologyDigSiteFrame
		@type class
		@desc ArchaeologyDigSiteFrame is a frame that is used to display digsites. Any one frame can be used to display any number of digsites, called blobs. Each blob is a polygon with a border and a filling texture.
		<br><br>To draw a blob onto the frame use the DrawBlob function. This will draw a polygon representing the specified digsite. It seems that it's only possible to draw digsites where you can dig and is on the current map.
		<br><br>Changes to how the blobs should render will only affect newly drawn blobs. That means that if you want to change the opacity of a blob you must first clear all blobs using the DrawNone function and then redraw the blobs.
		<br>
	]======]

	------------------------------------------------------
	-- Event
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name function_name
		@type method
		@desc  Draws a blob onto the frame. This will render the specified blob onto the frame with the current settings.
		@param blobId numeric, the numeric ID of the blob to draw
		@param draw boolean, draw the blob
		@return nil
	]======]

	doc [======[
		@name DrawNone
		@type method
		@desc Removes all drawn blobs on the frame. Removes all blobs from the frame.
		@return nil
	]======]

	doc [======[
		@name EnableMerging
		@type method
		@desc
		@param boolean
		@return nil
	]======]

	doc [======[
		@name EnableSmoothing
		@type method
		@desc
		@param boolean
		@return nil
	]======]

	doc [======[
		@name SetBorderAlpha
		@type method
		@desc
		@param alpha number, (0-255)
		@return nil
	]======]

	doc [======[
		@name SetBorderScalar
		@type method
		@desc
		@param scala number
		@return nil
	]======]

	doc [======[
		@name SetBorderTexture
		@type method
		@desc
		@param filename string
		@return nil
	]======]

	doc [======[
		@name SetFillAlpha
		@type method
		@desc
		@param
		@return nil
	]======]

	doc [======[
		@name SetFillTexture
		@type method
		@desc
		@param
		@return nil
	]======]

	doc [======[
		@name SetMergeThreshold
		@type method
		@desc
		@param
		@return nil
	]======]

	doc [======[
		@name SetNumSplinePoints
		@type method
		@desc Sets the number of points used in the blob polygon. Sets the number of corners of the polygon used when a drawing a blob using the DrawBlob function.The blob will allways have a minimum of 8 points, any number below that will default to 8.
		@param points number, the number of points in the polygon used to draw the blobs.
		@return nil
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("ArchaeologyDigSiteFrame", nil, parent, ...)
	end
endclass "ArchaeologyDigSiteFrame"

partclass "ArchaeologyDigSiteFrame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(ArchaeologyDigSiteFrame)
endclass "ArchaeologyDigSiteFrame"