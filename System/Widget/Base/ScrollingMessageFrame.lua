-- Author      : Kurapica
-- Create Date : 7/16/2008 14:28
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 7
if not IGAS:NewAddon("IGAS.Widget.ScrollingMessageFrame", version) then
	return
end

class "ScrollingMessageFrame"
	inherit "Frame"
	extend "IFFont"

	doc [======[
		@name ScrollingMessageFrame
		@type class
		@desc ScrollingMessageFrame expands on MessageFrame with the ability to store a much longer series of messages.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnHyperlinkClick
		@type event
		@desc Run when the mouse clicks a hyperlink in the ScrollingMessageFrame
		@param linkData string, essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
		@param link string, complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
		@param button string, name of the mouse button responsible for the click action
	]======]
	event "OnHyperlinkClick"

	doc [======[
		@name OnHyperlinkEnter
		@type event
		@desc Run when the mouse moves over a hyperlink in the ScrollingMessageFrame
		@param linkData string, essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
		@param link string, complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	]======]
	event "OnHyperlinkEnter"

	doc [======[
		@name OnHyperlinkLeave
		@type event
		@desc Run when the mouse moves away from a hyperlink in the ScrollingMessageFrame
		@param linkData string, essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
		@param link string, complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	]======]
	event "OnHyperlinkLeave"

	doc [======[
		@name OnMessageScrollChanged
		@type interface
		@desc Run when the scrolling message frame's scroll position changes
	]======]
	event "OnMessageScrollChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name AddMessage
		@type method
		@desc Adds a message to those listed in the frame
		@param text string, text of the message
		@param red number, red component of the text color for the message (0.0 - 1.0)
		@param green number, green component of the text color for the message (0.0 - 1.0)
		@param blue number, blue component of the text color for the message (0.0 - 1.0)
		@param id number, identifier for the message's type (see :UpdateColorByID())
		@param addToTop boolean, true to insert the message above all others listed in the frame, even if the frame's insert mode is set to BOTTOM; false to insert according to the frame's insert mode
		@return nil
	]======]

	doc [======[
		@name AtBottom
		@type method
		@desc Returns whether the message frame is currently scrolled to the bottom of its contents
		@return boolean 1 if the message frame is currently scrolled to the bottom of its contents; otherwise nil
	]======]

	doc [======[
		@name AtTop
		@type method
		@desc Returns whether the message frame is currently scrolled to the top of its contents
		@return boolean 1 if the message frame is currently scrolled to the top of its contents; otherwise nil
	]======]

	doc [======[
		@name Clear
		@type method
		@desc Removes all messages stored or displayed in the frame
		@return nil
	]======]

	doc [======[
		@name GetCurrentLine
		@type method
		@desc Returns a number identifying the last message added to the frame. This number starts at 0 when the frame is created and increments with each message AddMessage to the frame; however, it resets to 0 when a message is added beyond the frame's GetMaxLines
		@return number A number identifying the last message added to the frame
	]======]

	doc [======[
		@name GetCurrentScroll
		@type method
		@desc Returns the message frame's current scroll position
		@return number Number of lines by which the frame is currently scrolled back from the end of its message history
	]======]

	doc [======[
		@name GetFadeDuration
		@type method
		@desc Returns the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade
		@return number Duration of the fade-out animation for disappearing messages (in seconds)
	]======]

	doc [======[
		@name GetFading
		@type method
		@desc Returns whether messages added to the frame automatically fade out after a period of time
		@return boolean 1 if messages added to the frame automatically fade out after a period of time; otherwise nil
	]======]

	doc [======[
		@name GetHyperlinksEnabled
		@type method
		@desc Returns whether hyperlinks in the frame's text are interactive
		@return boolean 1 if hyperlinks in the frame's text are interactive; otherwise nil
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
		@name GetMaxLines
		@type method
		@desc Returns the maximum number of messages kept in the frame
		@return number Maximum number of messages kept in the frame
	]======]

	doc [======[
		@name GetMessageInfo
		@type method
		@desc Return information about a previously added chat message.
		@format index[, accessID]
		@param index Index of the message (between 1 and object:GetNumMessages(accessID)) for which information should be retrieved. Out of range values will non-silently fail
		@param accessID If specified, only messages for this accessID are included in the index count
		@return text string, the line's displayed text.
		@return accessID number, accessID for the message. For chat frames, can be passed to ChatHistory_GetChatType(accessID) to determine the message's chat type.
		@return lineID number, arg5 to object:AddMessage(). For default chat frames, is always zero as of 4.3.4 live. Instead, the lineID is embedded into the message text's player link.
		@return extraData number, arg8 to object:AddMessage(). Unknown use in the chat frames.
	]======]

	doc [======[
		@name GetNumLinesDisplayed
		@type method
		@desc Returns the number of lines displayed in the message frame. This number reflects the list of messages currently displayed, not including those which are stored for display if the frame is scrolled.
		@return number Number of messages currently displayed in the frame.
	]======]

	doc [======[
		@name GetNumMessages
		@type method
		@desc Returns the number of messages currently kept in the frame's message history. This number reflects the list of messages which can be seen by scrolling the frame, including (but not limited to) the list of messages currently displayed.
		@return number Number of messages currently kept in the frame's message history
	]======]

	doc [======[
		@name GetTimeVisible
		@type method
		@desc Returns the amount of time for which a message remains visible before beginning to fade out
		@return number Amount of time for which a message remains visible before beginning to fade out (in seconds)
	]======]

	doc [======[
		@name PageDown
		@type method
		@desc Scrolls the message frame's contents down by one page. One "page" is slightly less than the number of lines displayed in the frame.
		@return nil
	]======]

	doc [======[
		@name PageUp
		@type method
		@desc Scrolls the message frame's contents up by one page. One "page" is slightly less than the number of lines displayed in the frame.
		@return nil
	]======]

	doc [======[
		@name RemoveMessagesByAccessID
		@type method
		@desc Remove message by accessID
		@param accessID
		@return nil
	]======]

	doc [======[
		@name ScrollDown
		@type method
		@desc Scrolls the message frame's contents down by two lines
		@return nil
	]======]

	doc [======[
		@name ScrollToBottom
		@type method
		@desc Scrolls to the bottom of the message frame's contents
		@return nil
	]======]

	doc [======[
		@name ScrollToTop
		@type method
		@desc Scrolls to the top of the message frame's contents
		@return nil
	]======]

	doc [======[
		@name ScrollUp
		@type method
		@desc Scrolls the message frame's contents up by two lines
		@return nil
	]======]

	doc [======[
		@name SetFadeDuration
		@type method
		@desc Sets the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade.
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
		@name SetHyperlinksEnabled
		@type method
		@desc Enables or disables hyperlink interactivity in the frame. The frame's hyperlink-related script handlers will only be run if hyperlinks are enabled.
		@param enable boolean, true to enable hyperlink interactivity in the frame; false to disable
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
		@name SetMaxLines
		@type method
		@desc Sets the maximum number of messages to be kept in the frame. If additional messages are added beyond this number, the oldest lines are discarded and can no longer be seen by scrolling.
		@param maxLines number, maximum number of messages to be kept in the frame
		@return nil
	]======]

	doc [======[
		@name SetScrollOffset
		@type method
		@desc Sets the message frame's scroll position
		@param  offset number, number of lines to scroll back from the end of the frame's message history
		@return nil
	]======]

	doc [======[
		@name SetTimeVisible
		@type method
		@desc Sets the amount of time for which a message remains visible before beginning to fade out.
		@param duration number, amount of time for which a message remains visible before beginning to fade out (in seconds)
		@return nil
	]======]

	doc [======[
		@name UpdateColorByID
		@type method
		@desc Updates the color of a set of messages already added to the frame. Used in the default UI to allow customization of chat window message colors by type: each type of chat window message (party, raid, emote, system message, etc.) has a numeric identifier found in the global table ChatTypeInfo; this is passed as the fifth argument to :AddMessage() when messages are added to the frame, allowing them to be identified for recoloring via this method.
		@param id  number, Identifier for a message's type (as set when the messages were added to the frame)
		@param red  number, Red component of the new text color (0.0 - 1.0)
		@param green  number, Green component of the new text color (0.0 - 1.0)
		@param blue  number, Blue component of the new text color (0.0 - 1.0)
		@return nil
	]======]

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("ScrollingMessageFrame", nil, parent, ...)
	end
endclass "ScrollingMessageFrame"

class "ScrollingMessageFrame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(ScrollingMessageFrame)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Fading
		@type property
		@desc whether messages added to the frame automatically fade out after a period of time
	]======]
	property "Fading" { Type = Boolean }

	doc [======[
		@name HyperlinksEnabled
		@type property
		@desc whether hyperlinks in the frame's text are interactive
	]======]
	property "HyperlinksEnabled" { Type = Boolean }

	doc [======[
		@name TimeVisible
		@type property
		@desc the amount of time for which a message remains visible before beginning to fade out
	]======]
	property "TimeVisible" { Type = Number }

	doc [======[
		@name FadeDuration
		@type property
		@desc the duration of the fade-out animation for disappearing messages
	]======]
	property "FadeDuration" { Type = Number }

	doc [======[
		@name InsertMode
		@type property
		@desc the position at which new messages are added to the frame
	]======]
	property "InsertMode" { Type = InsertMode }

	doc [======[
		@name MaxLines
		@type property
		@desc the maximum number of messages to be kept in the frame
	]======]
	property "MaxLines" { Type = Number }
endclass "ScrollingMessageFrame"