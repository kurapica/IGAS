-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.ActionHandler", version) then
	return
end


handler = ActionTypeHandler {
	Type = "action",

	Action = "action",

	DragStyle = "Keep",

	ReceiveStyle = "Keep",

	InitSnippet = [[
	]],

	PickupSnippet = [[
		return "action", ...
	]],

	UpdateSnippet = [[
	]],

	ReceiveSnippet = [[
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	return PickupAction(target)
end

function handler:HasAction()
	return HasAction(self.ActionTarget)
end

function handler:GetActionText()
	return GetActionText(self.ActionTarget)
end

function handler:GetActionTexture()
	return GetActionTexture(self.ActionTarget)
end

function handler:GetActionCharges()
	return GetActionCharges(self.ActionTarget)
end

function handler:GetActionCount()
	return GetActionCount(self.ActionTarget)
end

function handler:GetActionCooldown()
	return GetActionCooldown(self.ActionTarget)
end

function handler:IsAttackAction()
	return IsAttackAction(self.ActionTarget)
end

function handler:IsEquippedItem()
	return IsEquippedAction(self.ActionTarget)
end

function handler:IsActivedAction()
	return IsCurrentAction(self.ActionTarget)
end

function handler:IsAutoRepeatAction()
	return IsAutoRepeatAction(self.ActionTarget)
end

function handler:IsUsableAction()
	return IsUsableAction(self.ActionTarget)
end

function handler:IsConsumableAction()
	local target = self.ActionTarget
	return IsConsumableAction(target) or IsStackableAction(target) or (not IsItemAction(target) and GetActionCount(target) > 0)
end

function handler:IsInRange()
	return IsActionInRange(self.ActionTarget, self:GetAttribute("unit"))
end

function handler:SetTooltip(GameTooltip)
	GameTooltip:SetAction(self.ActionTarget)
end

function handler:GetSpellId()
	local type, id = GetActionInfo(self.ActionTarget)
	if type == "spell" then
		return id
	elseif type == "macro" then
		return (select(3, GetMacroSpell(id)))
	end
end
