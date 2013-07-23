-- Author      : Kurapica
-- Create Date : 2013/07/23
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFUnitGroup", version) then
	return
end

interface "IFUnitGroup"
	extend "IFGroup"

	doc [======[
		@name IFUnitGroup
		@type interface
		@desc IFUnitGroup is used to handle the group's updating
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFUnitGroup(self)
		IFGroup.ShadowGroupHeader("ShadowGroupHeader", self)
	end
endinterface "IFUnitGroup"