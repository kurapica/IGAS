-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.CompanionHandler", version) then
	return
end

_MountMapTemplate = "_MountMap[%d] = %d\n"
_MountCastTemplate = "/run if not InCombatLockdown() then if select(5, GetCompanionInfo('MOUNT', %d)) then DismissCompanion('MOUNT') else CallCompanion('MOUNT', %d) end end"

_MountMap = {}

handler = ActionTypeHandler {
	Type = "companion",

	Action = "companion",

	InitSnippet = [[
		_MountMap = newtable()

		_MountCastTemplate = "/run if not InCombatLockdown() then if select(5, GetCompanionInfo('MOUNT', %d)) then DismissCompanion('MOUNT') else CallCompanion('MOUNT', %d) end end"
	]],

	PickupSnippet = [[
		local kind, target = ...
		return "clear", kind, "mount", _MountMap[target]
	]],

	UpdateSnippet = [[
		local kind, target = ...
		local index = _MountMap[target]

		self:SetAttribute("*type*", "macro")
		self:SetAttribute("*macrotext*", _MountCastTemplate:format(index, index))
	]],

	ReceiveSnippet = [[
	]],
}

-- Overwrite methods
function handler:GetActionTexture()
	local target = self.ActionTarget
	if _MountMap[target] then
		return select(4, GetCompanionInfo("MOUNT", _MountMap[target]))
	end
end

function handler:IsActivedAction()
	local target = self.ActionTarget
	return _MountMap[target] and select(5, GetCompanionInfo("MOUNT", _MountMap[target]))
end

function handler:IsUsableAction()
	return IsUsableSpell(self.ActionTarget)
end

function handler:SetTooltip(GameTooltip)
	local target = self.ActionTarget
	if _MountMap[target] then
		GameTooltip:SetSpellByID(select(3, GetCompanionInfo("MOUNT", _MountMap[target])))
	end
end