-- Author      : Kurapica
-- Create Date : 7/16/2008 12:09
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.MessageFrame", version) then
	return
end

class "MessageFrame"
	inherit "Frame"
	extend "IFFont"

	doc [======[
		@name MessageFrame
		@type class
		@desc MessageFrames are used to present series of messages or other lines of text, usually stacked on top of each other.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name AddMessage
		@type method
		@desc Adds a message to those listed in the frame. If the frame was already 'full' with messages, then the oldest message is discarded when the new one is added.
		@param text string, text of the message
		@param red number, red component of the text color for the message (0.0 - 1.0)
		@param green number, green component of the text color for the message (0.0 - 1.0)
		@param blue number, blue component of the text color for the message (0.0 - 1.0)
		@param alpha number, alpha (opacity) for the message (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name Clear
		@type method
		@desc Removes all messages displayed in the frame
		@return nil
	]======]

	doc [======[
		@name GetFadeDuration
		@type method
		@desc Returns the duration of the fade-out animation for disappearing messages.
		@return number Duration of the fade-out animation for disappearing messages (in seconds)
	]======]

	doc [======[
		@name GetFading
		@type method
		@desc Returns whether messages added to the frame automatically fade out after a period of time
		@return boolean 1 if messages added to the frame automatically fade out after a period of time; otherwise nil
	]======]

	doc [======[
		@name GetIndentedWordWrap
		@type method
		@desc Returns whether long lines of text are indented when wrapping
		@return boolean 1 if long lines of text are indented when wrapping; otherwise nil
	]======]

	doc [======[
		@name GetInsertMode
		@type method
		@desc Returns the position at which new messages are added to the frame
		@return System.Widget.InsertMode Token identifying the position at which new messages are added to the frame
	]======]

	doc [======[
		@name GetTimeVisible
		@type method
		@desc Returns the amount of time for which a message remains visible before beginning to fade out. For the duration of the fade-out animation, see :GetFadeDuration().
		@return number Amount of time for which a message remains visible before beginning to fade out (in seconds)
	]======]

	doc [======[
		@name SetFadeDuration
		@type method
		@desc Sets the duration of the fade-out animation for disappearing messages.
		@param duration number, duration of the fade-out animation for disappearing messages (in seconds)
		@return nil
	]======]

	doc [======[
		@name SetFading
		@type method
		@desc Sets whether messages added to the frame automatically fade out after a period of time
		@param fading boolean, true to cause messages added to the frame to automatically fade out after a period of time; false to leave message visible
		@return nil
	]======]

	doc [======[
		@name SetIndentedWordWrap
		@type method
		@desc Sets whether long lines of text are indented when wrapping
		@param indent boolean, true to indent wrapped lines of text; false otherwise
		@return nil
	]======]

	doc [======[
		@name SetInsertMode
		@type method
		@desc Sets the position at which new messages are added to the frame
		@param position System.Widget.InsertMode, token identifying the position at which new messages should be added to the frame
		@return nil
	]======]

	doc [======[
		@name SetTimeVisible
		@type method
		@desc Sets the amount of time for which a message remains visible before beginning to fade out.
		@param time number, amount of time for which a message remains visible before beginning to fade out (in seconds)
		@return nil
	]======]

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("MessageFrame", nil, parent, ...)
	end
endclass "MessageFrame"

partclass "MessageFrame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(MessageFrame)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Fading
		@type property
		@desc whether messages added to the frame automatically fade out after a period of time
	]======]
	__Auto__{ Method = true, Type = Boolean }
	property "Fading" {}

	doc [======[
		@name IndentedWordWrap
		@type property
		@desc whether long lines of text are indented when wrapping
	]======]
	__Auto__{ Method = true, Type = Boolean }
	property "IndentedWordWrap" {}

	doc [======[
		@name TimeVisible
		@type property
		@desc the amount of time for which a message remains visible before beginning to fade out
	]======]
	__Auto__{ Method = true, Type = Number }
	property "TimeVisible" {}

	doc [======[
		@name FadeDuration
		@type property
		@desc the duration of the fade-out animation for disappearing messages
	]======]
	__Auto__{ Method = true, Type = Number }
	property "FadeDuration" {}

	doc [======[
		@name InsertMode
		@type property
		@desc the position at which new messages are added to the frame
	]======]
	__Auto__{ Method = true, Type = InsertMode }
	property "InsertMode" {}

endclass "MessageFrame"