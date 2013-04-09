-- Author      : Kurapica
-- Create Date : 2012/07/18
-- Change Log  :

-- Check Version
local version = 2
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
	-- InRange
	property "InRange" {
		Set = function(self, value)
			if value then
				self.Parent.Alpha = 1
			else
				self.Parent.Alpha = 0.5
			end
		end,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "RangeChecker"