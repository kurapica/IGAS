-- Author      : Kurapica
-- Create Date : 2012/08/06
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.AlternatePowerBar", version) then
	return
end

class "AlternatePowerBar"
	inherit "StatusBar"
	extend "IFAlternatePower"

	doc [======[
		@name AlternatePowerBar
		@type class
		@desc the alternate power bar
	]======]

	------------------------------------------------------
	-- Event
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