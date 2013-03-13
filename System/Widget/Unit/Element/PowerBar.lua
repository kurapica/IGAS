-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.PowerBar", version) then
	return
end

class "PowerBar"
	inherit "StatusBar"
	extend "IFPower"

	doc [======[
		@name PowerBar
		@type class
		@desc The power bar
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function PowerBar(self)
		self.FrameStrata = "LOW"
		self.UsePowerColor = true
	end
endclass "PowerBar"

class "PowerBarFrequent"
	inherit "StatusBar"
	extend "IFPowerFrequent"

	doc [======[
		@name PowerBarFrequent
		@type class
		@desc The frequent power bar
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function PowerBarFrequent(self)
		self.FrameStrata = "LOW"
		self.UsePowerColor = true
	end
endclass "PowerBarFrequent"