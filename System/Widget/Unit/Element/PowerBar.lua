-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- PowerBar
-- <br><br>inherit <a href="..\Base\StatusBar.html">StatusBar</a> For all methods, properties and scriptTypes
-- @name PowerBar
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.PowerBar", version) then
	return
end

class "PowerBar"
	inherit "StatusBar"
	extend "IFPower"

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

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function PowerBarFrequent(self)
		self.FrameStrata = "LOW"
		self.UsePowerColor = true
	end
endclass "PowerBarFrequent"