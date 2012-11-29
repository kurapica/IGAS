-- Author      : Kurapica
-- Create Date : 2011/03/13
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- ArchaeologyDigSiteFrame is a frame that is used to display digsites. Any one frame can be used to display any number of digsites, called blobs. Each blob is a polygon with a border and a filling texture.
--- <br>To draw a blob onto the frame use the DrawBlob function. This will draw a polygon representing the specified digsite. It seems that it's only possible to draw digsites where you can dig and is on the current map.
--- <br>Changes to how the blobs should render will only affect newly drawn blobs. That means that if you want to change the opacity of a blob you must first clear all blobs using the DrawNone function and then redraw the blobs.
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

	------------------------------------------------------
	-- Script
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Draws a blob onto the frame. This will render the specified blob onto the frame with the current settings. </p>
	--- <p>Blob IDs for the current map can be recovered using the ArcheologyGetVisibleBlobID function.
	-- @name ArchaeologyDigSiteFrame:DrawBlob
	-- @class function
	-- @param blobId The numeric ID of the blob to draw (number)
	-- @param draw Draw the Blob (True = Yes, False = No) (bool)
	------------------------------------
	-- DrawBlob

	------------------------------------
	--- Removes all drawn blobs on the frame. Removes all blobs from the frame. </p>
	--- <p>To redraw use ArchaeologyDigSiteFrame:DrawBlob
	-- @name ArchaeologyDigSiteFrame:DrawNone
	-- @class function
	------------------------------------
	-- DrawNone

	------------------------------------
	---
	-- @name ArchaeologyDigSiteFrame:EnableMerging
	-- @class function
	------------------------------------
	-- EnableMerging

	------------------------------------
	---
	-- @name ArchaeologyDigSiteFrame:EnableSmoothing
	-- @class function
	------------------------------------
	-- EnableSmoothing

	------------------------------------
	---
	-- @name ArchaeologyDigSiteFrame:SetBorderAlpha
	-- @class function
	------------------------------------
	-- SetBorderAlpha

	------------------------------------
	---
	-- @name ArchaeologyDigSiteFrame:SetBorderScalar
	-- @class function
	------------------------------------
	-- SetBorderScalar

	------------------------------------
	---
	-- @name ArchaeologyDigSiteFrame:SetBorderTexture
	-- @class function
	------------------------------------
	-- SetBorderTexture

	------------------------------------
	---
	-- @name ArchaeologyDigSiteFrame:SetFillAlpha
	-- @class function
	------------------------------------
	-- SetFillAlpha

	------------------------------------
	---
	-- @name ArchaeologyDigSiteFrame:SetFillTexture
	-- @class function
	------------------------------------
	-- SetFillTexture

	------------------------------------
	---
	-- @name ArchaeologyDigSiteFrame:SetMergeThreshold
	-- @class function
	------------------------------------
	-- SetMergeThreshold

	------------------------------------
	--- Sets the number of points used in the blob polygon. Sets the number of corners of the polygon used when a drawing a blob using the DrawBlob function.
	--- The blob will allways have a minimum of 8 points, any number below that will default to 8.
	-- @name ArchaeologyDigSiteFrame:SetNumSplinePoints
	-- @class function
	-- @param points The number of points in the polygon used to draw the blobs. (number)
	------------------------------------
	-- SetNumSplinePoints

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ArchaeologyDigSiteFrame(name, parent, ...)
		return UIObject(name, parent, CreateFrame("ArchaeologyDigSiteFrame", nil, parent, ...))
	end
endclass "ArchaeologyDigSiteFrame"

partclass "ArchaeologyDigSiteFrame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(ArchaeologyDigSiteFrame)
endclass "ArchaeologyDigSiteFrame"