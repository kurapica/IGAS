-- Author      : Kurapica
-- Create Date : 2012/07/24
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFCooldown", version) then
	return
end

interface "IFCooldown"
	doc [======[
		@name IFCooldown
		@type interface
		@desc IFCooldown provide a root interface for cooldown features
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	doc [======[
		@name OnCooldownUpdate
		@type script
		@desc Fired when the object's cooldown need update
		@param start number, the start time of the cooldown
		@param duration number, the duration of the cooldown
	]======]
	script "OnCooldownUpdate"
endinterface "IFCooldown"
