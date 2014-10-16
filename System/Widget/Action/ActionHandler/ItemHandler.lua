-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.ItemHandler", version) then
	return
end

import "System.Widget.Action.ActionRefreshMode"

_ToyFilter = {}
_ToyFilterTemplate = "_ToyFilter[%d] = true"

-- Event handler
function OnEnable(self)
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("BAG_UPDATE_COOLDOWN")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("TOYS_UPDATED")
	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")

	OnEnable = nil

	return handler:Refresh()
end

function PLAYER_ENTERING_WORLD(self)
	if not next(_ToyFilter) then
		Task.ThreadCall(UpdateToys)
	end
end

function SPELLS_CHANGED(self)
	for _, btn in handler() do
		if _ToyFilter[btn.ActionTarget] then
			handler:Refresh(btn)
		end
	end
end

function UPDATE_SHAPESHIFT_FORM(self)
	for _, btn in handler() do
		if _ToyFilter[btn.ActionTarget] then
			handler:Refresh(btn)
		end
	end
end

function TOYS_UPDATED(self, itemID, new)
	Task.ThreadCall(UpdateToys)
end

function SPELL_UPDATE_COOLDOWN(self)
	for _, btn in handler() do
		if _ToyFilter[btn.ActionTarget] then
			handler:Refresh(btn, RefreshCooldown)
		end
	end
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

function UpdateToys()
	local cache = {}
	local found = false

	while not found do
		for i = 1, C_ToyBox.GetNumToys() do
			local index = C_ToyBox.GetToyFromIndex(i)

			if index > 0 then
				local itemID = C_ToyBox.GetToyInfo(index)
				if itemID and itemID > 0 then
					found = true
					_ToyFilter[itemID] = true
					tinsert(cache, _ToyFilterTemplate:format(itemID))
				end
			end
		end

		if found then
			IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
				handler:RunSnippet( tblconcat(cache, ";") )

				for _, btn in handler() do
					local target = btn.ActionTarget
					if _ToyFilter[target] then
						btn:SetAttribute("*item*", nil)
						btn:SetAttribute("*type*", "toy")
						btn:SetAttribute("*toy*", target)

						handler:Refresh(btn)
					end
				end
			end)
		elseif not IsAddOnLoaded("Blizzard_PetJournal") then
			IFNoCombatTaskHandler._RegisterNoCombatTask(PetJournal_LoadUI)
		else
			local parent = _G.PetJournalParent
			parent:Show()
			parent:SetAlpha(0)

			Task.Next()

			parent:SetAlpha(1)
			parent:Hide()
		end
		Task.Delay(0.1)
	end
end

-- Item action type handler
handler = ActionTypeHandler {
	Name = "item",

	InitSnippet = [[
		_ToyFilter = newtable()

		_ToyCastTemplate = "/run UseToy(%d)"
	]],

	UpdateSnippet = [[
		local target = ...

		if tonumber(target) then
			if _ToyFilter[target] then
				self:SetAttribute("*item*", nil)
				self:SetAttribute("*type*", "toy")
				self:SetAttribute("*toy*", target)
			else
				self:SetAttribute("*type*", nil)
				self:SetAttribute("*toy*", nil)
				self:SetAttribute("*item*", "item:"..target)
			end
		end
	]],

	ClearSnippet = [[
		self:SetAttribute("*item*", nil)
		self:SetAttribute("*type*", nil)
		self:SetAttribute("*toy*", nil)
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	if _ToyFilter(target) then
		return  C_ToyBox.PickupToyBoxItem(target)
	else
		return PickupItem(target)
	end
end

function handler:GetActionTexture()
	local target = self.ActionTarget
	if _ToyFilter[target] then
		return (select(3, C_ToyBox.GetToyInfo(target)))
	else
		return GetItemIcon(target)
	end
end

function handler:GetActionCount()
	local target = self.ActionTarget
	return _ToyFilter[target] and 0 or GetItemCount(target)
end

function handler:GetActionCooldown()
	return GetItemCooldown(self.ActionTarget)
end

function handler:IsEquippedItem()
	local target = self.ActionTarget
	return not _ToyFilter[target] and IsEquippedItem(target)
end

function handler:IsActivedAction()
	-- Block now, no event to deactivate
	return false and IsCurrentItem(self.ActionTarget)
end

function handler:IsUsableAction()
	local target = self.ActionTarget
	return _ToyFilter[target] or IsUsableItem(target)
end

function handler:IsConsumableAction()
	local target = self.ActionTarget
	if _ToyFilter[target] then return false end
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
	local target = self.ActionTarget
	if _ToyFilter[target] then
		GameTooltip:SetToyByItemID(target)
	else
		GameTooltip:SetHyperlink(select(2, GetItemInfo(self.ActionTarget)))
	end
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
	__Doc__[[The action button's content if its type is 'item']]
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
