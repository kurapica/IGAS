-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.CustomHandler", version) then
	return
end

_Enabled = false

handler = ActionTypeHandler {
	Name = "custom",

	DragStyle = "Block",

	ReceiveStyle = "Block",

	InitSnippet = [[
	]],

	PickupSnippet = [[
	]],

	UpdateSnippet = [[
	]],

	ReceiveSnippet = [[
	]],

	OnEnableChanged = function(self) _Enabled = self.Enabled end,
}

-- Overwrite methods
function handler:GetActionTexture()
	return self.CustomTexture
end

function handler:SetTooltip(GameTooltip)
	if self.CustomTooltip then
		GameTooltip:SetText(self.CustomTooltip)
	end
end

-- Part-interface definition
interface "IFActionHandler"
	local old_SetAction = IFActionHandler.SetAction

	function SetAction(self, kind, target, ...)
		if kind == "custom" then
			self.custom = type(target) == "function" and target or nil
			target = type(target) == "string" and target or nil
		end

		return old_SetAction(self, kind, target, ...)
	end
endinterface "IFActionHandler"