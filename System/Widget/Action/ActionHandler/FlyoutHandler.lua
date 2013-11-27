-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.FlyoutHandler", version) then
	return
end

MAX_SKILLLINE_TABS = _G.MAX_SKILLLINE_TABS

enum "FlyoutDirection" {
	"UP",
	"DOWN",
	"LEFT",
	"RIGHT",
}

_FlyoutSlotTemplate = "_FlyoutSlot[%d] = %d\n"

_FlyoutSlot = {}
_FlyoutTexture = {}

handler = ActionTypeHandler {
	Type = "flyout",

	Action = "spell",

	InitSnippet = [[
		_FlyoutSlot = newtable()
	]],

	PickupSnippet = [[
		return "clear", ...
	]],

	UpdateSnippet = [[
	]],

	ReceiveSnippet = [[
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	return PickupSpellBookItem(_FlyoutSlot[target], "spell")
end

function handler:GetActionTexture()
	return _FlyoutTexture[self.ActionTarget]
end

function handler:SetTooltip(GameTooltip)
	GameTooltip:SetSpellBookItem(_FlyoutSlot[self.ActionTarget], "spell")
end

function handler:IsFlyout()
	return true
end