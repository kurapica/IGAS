-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.ItemHandler", version) then
	return
end

import "ActionRefreshMode"

_Enabled = false

-- Event handler
function OnEnable(self)
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	OnEnable = nil
end

function BAG_UPDATE(self)
	handler:Refresh(RefreshCount)
	return handler:Refresh(RefreshUsable)
end

function BAG_UPDATE_COOLDOWN(self)
	return handler:Refresh(RefreshCooldown)
end

function PLAYER_EQUIPMENT_CHANGED(self)
	return handler:Refresh()
end

function PLAYER_REGEN_ENABLED(self)
	handler:Refresh(RefreshCount)
	return handler:Refresh(RefreshUsable)
end

function PLAYER_REGEN_DISABLED(self)
	return handler:Refresh(RefreshUsable)
end

-- Item action type handler
handler = ActionTypeHandler {
	Name = "item",

	UpdateSnippet = [[
		local target = ...

		if tonumber(target) then
			self:SetAttribute("*item*", "item:"..target)
		end
	]],

	ClearSnippet = [[
		self:SetAttribute("*item*", nil)
	]],

	OnEnableChanged = function(self) _Enabled = self.Enabled end,
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
	return GetItemCooldown(self.ActionTarget)
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
	local maxStack = select(8, GetItemInfo(target))

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

-- Part-interface definition
interface "IFActionHandler"
	local old_SetAction = IFActionHandler.SetAction

	function SetAction(self, kind, target, ...)
		if kind == "item" then
			if tonumber(target) then
				-- pass
			elseif target and select(2, GetItemInfo(target)) then
				target = select(2, GetItemInfo(target)):match("item:(%d+)")
			end

			target = tonumber(target)
		end

		return old_SetAction(self, kind, target, ...)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Item
		@type property
		@desc The action button's content if its type is 'item'
	]======]
	property "Item" {
		Get = function(self)
			return self:GetAttribute("actiontype") == "item" and self:GetAttribute("item") or nil
		end,
		Set = function(self, value)
			self:SetAction("item", value and GetItemInfo(value) and select(2, GetItemInfo(value)):match("item:%d+") or nil)
		end,
		Type = System.String + System.Number + nil,
	}

endinterface "IFActionHandler"
