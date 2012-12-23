-- Author      : Kurapica
-- Create Date : 7/16/2008 12:09
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- MessageFrames are used to present series of messages or other lines of text, usually stacked on top of each other.
-- <br><br>inherit <a href=".\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name MessageFrame
-- @class table
-- @field Fading whether messages added to the frame automatically fade out after a period of time
-- @field TimeVisible the amount of time for which a message remains visible before beginning to fade out
-- @field FadeDuration the duration of the fade-out animation for disappearing messages
-- @field InsertMode the position at which new messages are added to the frame
-- @field IndentedWordWrap whether long lines of text are indented when wrapping
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.MessageFrame", version) then
	return
end

class "MessageFrame"
	inherit "Frame"
	extend "IFFont"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Adds a message to those listed in the frame. If the frame was already 'full' with messages, then the oldest message is discarded when the new one is added.
	-- @name MessageFrame:AddMessage
	-- @class function
	-- @param text Text of the message (string)
	-- @param red Red component of the text color for the message (0.0 - 1.0) (number)
	-- @param green Green component of the text color for the message (0.0 - 1.0) (number)
	-- @param blue Blue component of the text color for the message (0.0 - 1.0) (number)
	-- @param alpha Alpha (opacity) for the message (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- AddMessage

	------------------------------------
	--- Removes all messages displayed in the frame
	-- @name MessageFrame:Clear
	-- @class function
	------------------------------------
	-- Clear

	------------------------------------
	--- Returns the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade, see :GetTimeVisible().
	-- @name MessageFrame:GetFadeDuration
	-- @class function
	-- @return duration - Duration of the fade-out animation for disappearing messages (in seconds) (number)
	------------------------------------
	-- GetFadeDuration

	------------------------------------
	--- Returns whether messages added to the frame automatically fade out after a period of time
	-- @name MessageFrame:GetFading
	-- @class function
	-- @return fading - 1 if messages added to the frame automatically fade out after a period of time; otherwise nil (1nil)
	------------------------------------
	-- GetFading

	------------------------------------
	--- Returns whether long lines of text are indented when wrapping
	-- @name MessageFrame:GetIndentedWordWrap
	-- @class function
	-- @return indent - 1 if long lines of text are indented when wrapping; otherwise nil (1nil)
	------------------------------------
	-- GetIndentedWordWrap

	------------------------------------
	--- Returns the position at which new messages are added to the frame
	-- @name MessageFrame:GetInsertMode
	-- @class function
	-- @return position - Token identifying the position at which new messages are added to the frame (string) <ul><li>BOTTOM
	------------------------------------
	-- GetInsertMode

	------------------------------------
	--- Returns the amount of time for which a message remains visible before beginning to fade out. For the duration of the fade-out animation, see :GetFadeDuration().
	-- @name MessageFrame:GetTimeVisible
	-- @class function
	-- @return time - Amount of time for which a message remains visible before beginning to fade out (in seconds) (number)
	------------------------------------
	-- GetTimeVisible

	------------------------------------
	--- Sets the duration of the fade-out animation for disappearing messages. For the amount of time a message remains in the frame before beginning to fade, see :SetTimeVisible().
	-- @name MessageFrame:SetFadeDuration
	-- @class function
	-- @param duration Duration of the fade-out animation for disappearing messages (in seconds) (number)
	------------------------------------
	-- SetFadeDuration

	------------------------------------
	--- Sets whether messages added to the frame automatically fade out after a period of time
	-- @name MessageFrame:SetFading
	-- @class function
	-- @param fading True to cause messages added to the frame to automatically fade out after a period of time; false to leave message visible (boolean)
	------------------------------------
	-- SetFading

	------------------------------------
	--- Sets whether long lines of text are indented when wrapping
	-- @name MessageFrame:SetIndentedWordWrap
	-- @class function
	-- @param indent True to indent wrapped lines of text; false otherwise (boolean)
	------------------------------------
	-- SetIndentedWordWrap

	------------------------------------
	--- Sets the position at which new messages are added to the frame
	-- @name MessageFrame:SetInsertMode
	-- @class function
	-- @param position Token identifying the position at which new messages should be added to the frame (string) <ul><li>BOTTOM
	------------------------------------
	-- SetInsertMode

	------------------------------------
	--- Sets the amount of time for which a message remains visible before beginning to fade out. For the duration of the fade-out animation, see :SetFadeDuration().
	-- @name MessageFrame:SetTimeVisible
	-- @class function
	-- @param time Amount of time for which a message remains visible before beginning to fade out (in seconds) (number)
	------------------------------------
	-- SetTimeVisible

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
	-- IndentedWordWrap
	property "IndentedWordWrap" {
		Get = function(self)
			return (self:GetIndentedWordWrap() and true) or false
		end,
		Set = function(self, state)
			self:SetIndentedWordWrap(state)
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

	------------------------------------------------------
	-- Script Handler
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
endclass "MessageFrame"