-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.ItemHandler", version) then
	return
end

handler = ActionTypeHandler {
	Type = "item",

	Action = "item",

	InitSnippet = [[
	]],

	PickupSnippet = [[
		return "clear", "item", ...
	]],

	UpdateSnippet = [[
		local target = ...

		if tonumber(target) then
			self:SetAttribute("item", "item:"..target)
		end
	]],

	ReceiveSnippet = [[
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	return PickupItem(target)
end

function handler:GetActionTexture()
	return GetItemIcon(self.ActionTarget)
end

function handler:GetActionCount()
	return GetItemCount(self.ActionTarget)
end

function handler:GetActionCooldown()
	GetItemCooldown(self.ActionTarget)
end

function handler:IsEquippedItem()
	return IsEquippedItem(self.ActionTarget)
end

function handler:IsActivedAction()
	return IsCurrentItem(self.ActionTarget)
end

function handler:IsUsableAction()
	return IsUsableItem(self.ActionTarget)
end

function handler:IsConsumableAction()
	local target = self.ActionTarget

	-- return IsConsumableItem(target) blz sucks, wait until IsConsumableItem is fixed
	local _, _, _, _, _, _, _, maxStack = GetItemInfo(target)

	if IsUsableItem(target) and maxStack and maxStack > 1 then
		return true
	else
		return false
	end
end

function handler:IsInRange()
	return IsItemInRange(self.ActionTarget, self:GetAttribute("unit"))
end

function handler:SetTooltip(GameTooltip)
	GameTooltip:SetHyperlink(select(2, GetItemInfo(self.ActionTarget)))
end
