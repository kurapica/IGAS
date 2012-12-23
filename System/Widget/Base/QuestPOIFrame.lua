-- Author      : Kurapica
-- Create Date : 2011/03/13
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- QuestPOIFrame
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name QuestPOIFrame
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.QuestPOIFrame", version) then
	return
end

class "QuestPOIFrame"
	inherit "Frame"

	------------------------------------------------------
	-- Script
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Draws the Blob for the Quest.. If a quest has a area where the quest need to be completed at, this function will draw a Blob to show that area.</p>
	--- <p>Also, Drawing it more than once does nothing, to make any changes to it you have to QuestPOIFrame:DrawBlob(ID,false)... Make changes ... QuestPOIFrame:DrawBlob(ID,true)
	-- @name QuestPOIFrame:DrawBlob
	-- @class function
	-- @param QuestId The Id of the Quest (number)
	-- @param Draw Draw the Blob (True = Yes, False = No) (bool)
	------------------------------------
	-- DrawBlob

	------------------------------------
	---
	-- @name QuestPOIFrame:DrawNone
	-- @class function
	------------------------------------
	-- DrawNone

	------------------------------------
	---
	-- @name QuestPOIFrame:EnableMerging
	-- @class function
	------------------------------------
	-- EnableMerging

	------------------------------------
	---
	-- @name QuestPOIFrame:EnableSmoothing
	-- @class function
	------------------------------------
	-- EnableSmoothing

	------------------------------------
	---
	-- @name QuestPOIFrame:GetNumTooltips
	-- @class function
	------------------------------------
	-- GetNumTooltips

	------------------------------------
	---
	-- @name QuestPOIFrame:GetTooltipIndex
	-- @class function
	------------------------------------
	-- GetTooltipIndex

	------------------------------------
	--- Set the alpha for the border texture
	-- @name QuestPOIFrame:SetBorderAlpha
	-- @class function
	-- @param Alpha How bright the border texture is drawn (number)
	------------------------------------
	-- SetBorderAlpha

	------------------------------------
	--- Set the Border Scalar
	-- @name QuestPOIFrame:SetBorderScalar
	-- @class function
	-- @param Scalar Set the glow(size) of the border (number)
	------------------------------------
	-- SetBorderScalar

	------------------------------------
	--- Sets the border Texture for the Blob
	-- @name QuestPOIFrame:SetBorderTexture
	-- @class function
	-- @param Texture Path to a texture image (string)
	------------------------------------
	-- SetBorderTexture

	------------------------------------
	--- Set the Alpha for the fill Texture
	-- @name QuestPOIFrame:SetFillAlpha
	-- @class function
	-- @param Alpha How bright the fill texture is drawn. (number)
	------------------------------------
	-- SetFillAlpha

	------------------------------------
	--- Set the fill Texture for the Blob.
	-- @name QuestPOIFrame:SetFillTexture
	-- @class function
	-- @param Texture Path to a texture image (string)
	------------------------------------
	-- SetFillTexture

	------------------------------------
	---
	-- @name QuestPOIFrame:SetMergeThreshold
	-- @class function
	------------------------------------
	-- SetMergeThreshold

	------------------------------------
	---
	-- @name QuestPOIFrame:SetNumSplinePoints
	-- @class function
	------------------------------------
	-- SetNumSplinePoints

	------------------------------------
	---
	-- @name QuestPOIFrame:UpdateMouseOverTooltip
	-- @class function
	------------------------------------
	-- UpdateMouseOverTooltip

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("QuestPOIFrame", nil, parent, ...)
	end
endclass "QuestPOIFrame"

partclass "QuestPOIFrame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(QuestPOIFrame)
endclass "QuestPOIFrame"