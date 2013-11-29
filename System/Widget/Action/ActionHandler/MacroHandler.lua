-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.MacroHandler", version) then
	return
end

handler = ActionTypeHandler {
	Type = "macro",

	Action = "macro",

	InitSnippet = [[
	]],

	PickupSnippet = [[
		return "clear", "macro", ...
	]],

	UpdateSnippet = [[
	]],

	ReceiveSnippet = [[
	]],

	ClearSnippet = [[
		self:SetAttribute("macrotext", nil)
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	return PickupMacro(target)
end

function handler:GetActionText()
	return (GetMacroInfo(self.ActionTarget))
end

function handler:GetActionTexture()
	return (select(2, GetMacroInfo(self.ActionTarget)))
end
