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
	function PowerBar(...)
		local bar = Super(...)

		bar.FrameStrata = "LOW"
		bar.UsePowerColor = true

		return bar
	end
endclass "PowerBar"

class "PowerBarFrequent"
	inherit "StatusBar"
	extend "IFPowerFrequent"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function PowerBarFrequent(...)
		local bar = Super(...)

		bar.FrameStrata = "LOW"
		bar.UsePowerColor = true

		return bar
	end
endclass "PowerBarFrequent"