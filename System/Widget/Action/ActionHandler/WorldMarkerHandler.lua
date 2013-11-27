-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.WorldMarkerHandler", version) then
	return
end

_WorldMarker = {
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_6",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_3",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_7",
	"Interface\\TargetingFrame\\UI-RaidTargetingIcon_1",
}

handler = ActionTypeHandler {
	Type = "worldmarker",

	Action = "marker",

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

	ClearSnippet = [[
		self:SetAttribute("action", nil)
	]],
}

-- Overwrite methods
function handler:GetActionTexture()
	return _WorldMarker[tonumber(self.ActionTarget)]
end

function handler:IsActivedAction()
	local target = tonumber(self.ActionTarget)
	-- No event for world marker, disable it now
	return false and target and target >= 1 and target <= NUM_WORLD_RAID_MARKERS and IsRaidMarkerActive(target)
end