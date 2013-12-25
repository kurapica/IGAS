-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.EmptyHandler", version) then
	return
end

_Enabled = false

handler = ActionTypeHandler {
	Name = "empty",
	DragStyle = "Block",
	ReceiveStyle = "Clear",

	OnEnableChanged = function(self) _Enabled = self.Enabled end,
}

function handler:HasAction()
	return false
end
