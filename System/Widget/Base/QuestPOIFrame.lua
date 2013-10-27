-- Author      : Kurapica
-- Create Date : 2011/03/13
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.QuestPOIFrame", version) then
	return
end

class "QuestPOIFrame"
	inherit "Frame"

	doc [======[
		@name QuestPOIFrame
		@type class
		@desc
	]======]

	------------------------------------------------------
	-- Event
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name DrawBlob
		@type method
		@desc Draws the Blob for the Quest. If a quest has a area where the quest need to be completed at, this function will draw a Blob to show that area.
		@param questId number, the Id of the quest
		@param draw boolean, draw the Blob
	]======]

	doc [======[
		@name DrawNone
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name EnableMerging
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name EnableSmoothing
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name GetNumTooltips
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name GetTooltipIndex
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name SetBorderAlpha
		@type method
		@desc  Set the alpha for the border texture
		@param alpha number, set alpha the border texture is drawn
		@return nil
	]======]

	doc [======[
		@name SetBorderScalar
		@type method
		@desc Set the Border Scalar
		@param scalar number, set the glow(size) of the border
		@return nil
	]======]

	doc [======[
		@name SetBorderTexture
		@type method
		@desc Sets the border texture for the blob
		@param path string, the texture path for the border textureof the blob
		@return nil
	]======]

	doc [======[
		@name SetFillAlpha
		@type method
		@desc Set the Alpha for the fill Texture
		@param alpha number the alpha for the fill texture
		@return nil
	]======]

	doc [======[
		@name SetFillTexture
		@type method
		@desc Set the fill texture for the blob.
		@param path string, the texture path for the fill texture
		@return nil
	]======]

	doc [======[
		@name SetMergeThreshold
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name SetNumSplinePoints
		@type method
		@desc
		@return nil
	]======]

	doc [======[
		@name UpdateMouseOverTooltip
		@type method
		@desc
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
		return CreateFrame("QuestPOIFrame", nil, parent, ...)
	end
endclass "QuestPOIFrame"

class "QuestPOIFrame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(QuestPOIFrame)
endclass "QuestPOIFrame"