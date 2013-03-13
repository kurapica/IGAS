-- Author      : Kurapica
-- Create Date : 2012/07/18
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.RangeChecker", version) then
	return
end

class "RangeChecker"
	inherit "VirtualUIObject"
	extend "IFRange"

	doc [======[
		@name RangeChecker
		@type class
		@desc The in-range indicator
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Alpha
	property "Alpha" {
		Get = function(self)
			return self.Parent.Alpha
		end,
		Set = function(self, value)
			self.Parent.Alpha = value
		end,
		Type = System.Number,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "RangeChecker"