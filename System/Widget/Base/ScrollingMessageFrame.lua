-- Author      : Kurapica
-- Create Date : 7/16/2008 14:28
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Button is the primary means for users to control the game and their characters.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name ScrollingMessageFrame
-- @class table
-- @field Fading whether messages added to the frame automatically fade out after a period of time
-- @field HyperlinksEnabled whether hyperlinks in the frame's text are interactive
-- @field TimeVisible the amount of time for which a message remains visible before beginning to fade out
-- @field FadeDuration the duration of the fade-out animation for disappearing messages
-- @field InsertMode the position at which new messages are added to the frame
-- @field MaxLines the maximum number of messages to be kept in the frame
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 7
if not IGAS:NewAddon("IGAS.Widget.ScrollingMessageFrame", version) then
	return
end

class "ScrollingMessageFrame"
	inherit "Frame"
	extend "IFFont"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the mouse clicks a hyperlink in the scrolling message frame or SimpleHTML frame
	-- @name ScrollingMessageFrame:OnHyperlinkClick
	-- @class function
	-- @param linkData linkData - Essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
	-- @param link Complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	-- @param button Name of the mouse button responsible for the click action
	-- @usage function ScrollingMessageFrame:OnHyperlinkClick(linkData, link, button)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHyperlinkClick"

	------------------------------------
	--- ScriptType, Run when the mouse moves over a hyperlink in the scrolling message frame or SimpleHTML frame
	-- @name ScrollingMessageFrame:OnHyperlinkEnter
	-- @class function
	-- @param linkData Essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
	-- @param link Complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	-- @usage function ScrollingMessageFrame:OnHyperlinkEnter(linkData, link)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHyperlinkEnter"

	------------------------------------
	--- ScriptType, Run when the mouse moves away from a hyperlink in the scrolling message frame or SimpleHTML frame
	-- @name ScrollingMessageFrame:OnHyperlinkLeave
	-- @class function
	-- @param linkData Essential data (linktype:linkdata portion) of the hyperlink (e.g. "quest:982:17")
	-- @param link Complete hyperlink text (e.g. "|cffffff00|Hquest:982:17|h[Deep Ocean, Vast Sea]|h|r")
	-- @usage function ScrollingMessageFrame:OnHyperlinkLeave(linkData, link)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHyperlinkLeave"

	------------------------------------
	--- ScriptType, Run when the scrolling message frame's scroll position changes
	-- @name ScrollingMessageFrame:OnMessageScrollChanged
	-- @class function
	-- @usage function ScrollingMessageFrame:OnMessageScrollChanged()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnMessageScrollChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Adds a message to those listed in the frame
	-- @name ScrollingMessageFrame:AddMessage
	-- @class function
	-- @param text Text of the message (string)
	-- @param red Red component of the text color for the message (0.0 - 1.0) (number)
	-- @param green Green component of the text color for the message (0.0 - 1.0) (number)
	-- @param blue Blue component of the text color for the message (0.0 - 1.0) (number)
	-- @param id Identifier for the message's type (see :UpdateColorByID()) (number)
	-- @param addToTop True to insert the message above all others listed in the frame, even if the frame's insert mode is set to BOTTOM; false to insert according to the frame's insert mode (boolean)
	------------------------------------
	-- AddMessage

	------------------------------------
	--- Returns whether the message frame is currently scrolled to the bottom of its contents
	-- @name ScrollingMessageFrame:AtBottom
	-- @class function
	-- @return atBottom - 1 if the message frame is currently scrolled to the bottom of its contents; otherwise nil (1nil)
	------------------------------------
	-- AtBottom

	------------------------------------
	--- Returns whether the message frame is currently scrolled to the top of its contents
	-- @name ScrollingMessageFrame:AtTop
	-- @class function
	-- @return atTop - 1 if the message frame is currently scrolled to the top of its contents; otherwise nil (1nil)
	------------------------------------
	-- AtTop

	------------------------------------
	--- Removes all messages stored or displayed in the frame
	-- @name ScrollingMessageFrame:Clear
	-- @class function
	------------------------------------
	-- Clear

	------------------------------------
	--- Returns a number identifying the last message added to the frame. This number starts at 0 when the frame is created and increments with each message AddMessage to the frame; however, it resets to 0 when a message is added beyond the frame's GetMaxLines.
	-- @name ScrollingMessageFrame:GetCurrentLine
	-- @class function
	-- @return lineNum - A number identifying the last message added to the frame (number)
	------------------------------------
	-- GetCurrentLine

	------------------------------------
	--- Returns the message frame's current scroll position
	-- @name ScrollingMessageFrame:GetCurrentScroll
	-- @class function
	-- @return offset - Number of lines by which the frame is currently scrolled back from the end of its message history (number)
	------------------------------------
	-- GetCurrentScroll

	------------------------------------
	--- Returns the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade, see :GetTimeVisible().
	-- @name ScrollingMessageFrame:GetFadeDuration
	-- @class function
	-- @return duration - Duration of the fade-out animation for disappearing messages (in seconds) (number)
	------------------------------------
	-- GetFadeDuration

	------------------------------------
	--- Returns whether messages added to the frame automatically fade out after a period of time
	-- @name ScrollingMessageFrame:GetFading
	-- @class function
	-- @return fading - 1 if messages added to the frame automatically fade out after a period of time; otherwise nil (1nil)
	------------------------------------
	-- GetFading

	------------------------------------
	--- Returns whether hyperlinks in the frame's text are interactive
	-- @name ScrollingMessageFrame:GetHyperlinksEnabled
	-- @class function
	-- @return enabled - 1 if hyperlinks in the frame's text are interactive; otherwise nil (1nil)
	------------------------------------
	-- GetHyperlinksEnabled

	------------------------------------
	--- Returns whether long lines of text are indented when wrapping
	-- @name ScrollingMessageFrame:GetIndentedWordWrap
	-- @class function
	-- @return indent - 1 if long lines of text are indented when wrapping; otherwise nil (1nil)
	------------------------------------
	-- GetIndentedWordWrap

	------------------------------------
	--- Returns the position at which new messages are added to the frame
	-- @name ScrollingMessageFrame:GetInsertMode
	-- @class function
	-- @return position - Token identifying the position at which new messages are added to the frame (string) <ul><li>BOTTOM
	------------------------------------
	-- GetInsertMode

	------------------------------------
	--- Returns the maximum number of messages kept in the frame
	-- @name ScrollingMessageFrame:GetMaxLines
	-- @class function
	-- @param maxLines Maximum number of messages kept in the frame (number)
	------------------------------------
	-- GetMaxLines

	------------------------------------
	---
	-- @name ScrollingMessageFrame:GetMessageInfo
	-- @class function
	------------------------------------
	-- GetMessageInfo

	------------------------------------
	--- Returns the number of lines displayed in the message frame. This number reflects the list of messages currently displayed, not including those which are stored for display if the frame is scrolled.
	-- @name ScrollingMessageFrame:GetNumLinesDisplayed
	-- @class function
	-- @return count - Number of messages currently displayed in the frame (number)
	------------------------------------
	-- GetNumLinesDisplayed

	------------------------------------
	--- Returns the number of messages currently kept in the frame's message history. This number reflects the list of messages which can be seen by scrolling the frame, including (but not limited to) the list of messages currently displayed.
	-- @name ScrollingMessageFrame:GetNumMessages
	-- @class function
	-- @return count - Number of messages currently kept in the frame's message history (number)
	------------------------------------
	-- GetNumMessages

	------------------------------------
	--- Returns the amount of time for which a message remains visible before beginning to fade out
	-- @name ScrollingMessageFrame:GetTimeVisible
	-- @class function
	-- @return time - Amount of time for which a message remains visible before beginning to fade out (in seconds) (number)
	------------------------------------
	-- GetTimeVisible

	------------------------------------
	--- Scrolls the message frame's contents down by one page. One "page" is slightly less than the number of lines displayed in the frame.
	-- @name ScrollingMessageFrame:PageDown
	-- @class function
	------------------------------------
	-- PageDown

	------------------------------------
	--- Scrolls the message frame's contents up by one page. One "page" is slightly less than the number of lines displayed in the frame.
	-- @name ScrollingMessageFrame:PageUp
	-- @class function
	------------------------------------
	-- PageUp

	------------------------------------
	---
	-- @name ScrollingMessageFrame:RemoveMessagesByAccessID
	-- @class function
	------------------------------------
	-- RemoveMessagesByAccessID

	------------------------------------
	--- Scrolls the message frame's contents down by two lines
	-- @name ScrollingMessageFrame:ScrollDown
	-- @class function
	------------------------------------
	-- ScrollDown

	------------------------------------
	--- Scrolls to the bottom of the message frame's contents
	-- @name ScrollingMessageFrame:ScrollToBottom
	-- @class function
	------------------------------------
	-- ScrollToBottom

	------------------------------------
	--- Scrolls to the top of the message frame's contents
	-- @name ScrollingMessageFrame:ScrollToTop
	-- @class function
	------------------------------------
	-- ScrollToTop

	------------------------------------
	--- Scrolls the message frame's contents up by two lines
	-- @name ScrollingMessageFrame:ScrollUp
	-- @class function
	------------------------------------
	-- ScrollUp

	------------------------------------
	--- Sets the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade, see :SetTimeVisible().
	-- @name ScrollingMessageFrame:SetFadeDuration
	-- @class function
	-- @param duration Duration of the fade-out animation for disappearing messages (in seconds) (number)
	------------------------------------
	-- SetFadeDuration

	------------------------------------
	--- Sets whether messages added to the frame automatically fade out after a period of time
	-- @name ScrollingMessageFrame:SetFading
	-- @class function
	-- @param fading True to cause messages added to the frame to automatically fade out after a period of time; false to leave message visible (boolean)
	------------------------------------
	-- SetFading

	------------------------------------
	--- Enables or disables hyperlink interactivity in the frame. The frame's hyperlink-related script handlers will only be run if hyperlinks are enabled.
	-- @name ScrollingMessageFrame:SetHyperlinksEnabled
	-- @class function
	-- @param enable True to enable hyperlink interactivity in the frame; false to disable (boolean)
	------------------------------------
	-- SetHyperlinksEnabled

	------------------------------------
	--- Sets whether long lines of text are indented when wrapping
	-- @name ScrollingMessageFrame:SetIndentedWordWrap
	-- @class function
	-- @param indent True to indent wrapped lines of text; false otherwise (boolean)
	------------------------------------
	-- SetIndentedWordWrap

	------------------------------------
	--- Sets the position at which new messages are added to the frame
	-- @name ScrollingMessageFrame:SetInsertMode
	-- @class function
	-- @param position Token identifying the position at which new messages should be added to the frame (string) <ul><li>BOTTOM
	------------------------------------
	-- SetInsertMode

	------------------------------------
	--- Sets the maximum number of messages to be kept in the frame. If additional messages are added beyond this number, the oldest lines are discarded and can no longer be seen by scrolling.
	-- @name ScrollingMessageFrame:SetMaxLines
	-- @class function
	-- @param maxLines Maximum number of messages to be kept in the frame (number)
	------------------------------------
	-- SetMaxLines

	------------------------------------
	--- Sets the message frame's scroll position
	-- @name ScrollingMessageFrame:SetScrollOffset
	-- @class function
	-- @param offset Number of lines to scroll back from the end of the frame's message history (number)
	------------------------------------
	-- SetScrollOffset

	------------------------------------
	--- Sets the amount of time for which a message remains visible before beginning to fade out. For the duration of the fade-out animation, see :SetFadeDuration().
	-- @name ScrollingMessageFrame:SetTimeVisible
	-- @class function
	-- @param time Amount of time for which a message remains visible before beginning to fade out (in seconds) (number)
	------------------------------------
	-- SetTimeVisible

	------------------------------------
	--- Updates the color of a set of messages already added to the frame. Used in the default UI to allow customization of chat window message colors by type: each type of chat window message (party, raid, emote, system message, etc.) has a numeric identifier found in the global table ChatTypeInfo; this is passed as the fifth argument to :AddMessage() when messages are added to the frame, allowing them to be identified for recoloring via this method.
	-- @name ScrollingMessageFrame:UpdateColorByID
	-- @class function
	-- @param id Identifier for a message's type (as set when the messages were added to the frame) (number)
	-- @param red Red component of the new text color (0.0 - 1.0) (number)
	-- @param green Green component of the new text color (0.0 - 1.0) (number)
	-- @param blue Blue component of the new text color (0.0 - 1.0) (number)
	------------------------------------
	-- UpdateColorByID

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Fading
	property "Fading" {
		Get = function(self)
			return (self:GetFading() and true) or false
		end,
		Set = function(self, state)
			self:SetFading(state)
		end,
		Type = Boolean,
	}
	-- HyperlinksEnabled
	property "HyperlinksEnabled" {
		Get = function(self)
			return (self:GetHyperlinksEnabled() and true) or false
		end,
		Set = function(self, state)
			self:SetHyperlinksEnabled(state)
		end,
		Type = Boolean,
	}
	-- TimeVisible
	property "TimeVisible" {
		Get = function(self)
			return self:GetTimeVisible()
		end,
		Set = function(self, seconds)
			self:SetTimeVisible(seconds)
		end,
		Type = Number,
	}
	-- FadeDuration
	property "FadeDuration" {
		Get = function(self)
			return self:GetFadeDuration()
		end,
		Set = function(self, seconds)
			self:SetFadeDuration(seconds)
		end,
		Type = Number,
	}
	-- InsertMode
	property "InsertMode" {
		Get = function(self)
			return self:GetInsertMode()
		end,
		Set = function(self, mode)
			self:SetInsertMode(mode)
		end,
		Type = InsertMode,
	}
	-- MaxLines
	property "MaxLines" {
		Get = function(self)
			return self:GetMaxLines()
		end,
		Set = function(self, lines)
			self:SetMaxLines(lines)
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
		return CreateFrame("ScrollingMessageFrame", nil, parent, ...)
	end
endclass "ScrollingMessageFrame"

partclass "ScrollingMessageFrame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(ScrollingMessageFrame)
endclass "ScrollingMessageFrame"