-- Author      : Kurapica
-- Create Date : 2012/08/06
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- AlternatePowerBar
-- <br><br>inherit <a href="..\Base\StatusBar.html">StatusBar</a> For all methods, properties and scriptTypes
-- @name AlternatePowerBar
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.AlternatePowerBar", version) then
	return
end

class "AlternatePowerBar"
	inherit "StatusBar"
	extend "IFAlternatePower"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "AlternatePowerBar"