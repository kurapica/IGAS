-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.CustomHandler", version) then
	return
end

handler = ActionTypeHandler {
	Type = "custom",

	Action = "custom",

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

	ValidateSnippet = [[
		return nil
	]],
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
