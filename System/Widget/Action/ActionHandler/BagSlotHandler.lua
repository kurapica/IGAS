-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.BagSlotHandler", version) then
	return
end

handler = ActionTypeHandler {
	Type = "bagslot",

	Action = "bagslot",

	InitSnippet = [[
	]],

	PickupSnippet = [[
	]],

	UpdateSnippet = [[
	]],

	ReceiveSnippet = [[
	]],
}

-- Overwrite methods
function handler:PickupAction(target, detail)
	return PickupContainerItem(target, detail)
end

function handler:HasAction()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return HasAction(target)
	elseif kind == "pet" or kind == "petaction" then
		return GetPetActionInfo(target) and true
	elseif kind and kind ~= "" then
		return true
	end
end

function handler:GetActionText()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return GetActionText(target)
	elseif kind == "macro" then
		return (GetMacroInfo(target))
	elseif kind == "equipmentset" then
		return target
	else
		return ""
	end
end

function handler:GetActionTexture()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return GetActionTexture(target)
	elseif kind == "pet" or kind == "petaction" then
		local name, _, texture, isToken = GetPetActionInfo(target)
		if name then
			return isToken and _G[texture] or texture
		end
	elseif kind == "spell" then
		if _IFActionHandler_StanceMap[target] then
			return (GetShapeshiftFormInfo(_IFActionHandler_StanceMap[target]))
		else
			return GetSpellTexture(target)
		end
	elseif kind == "flyout" then
		return _IFActionHandler_FlyoutTexture[target]
	elseif kind == "item" then
		return GetItemIcon(target)
	elseif kind == "macro" then
		return (select(2, GetMacroInfo(target)))
	elseif kind == "companion" then
		if _IFActionHandler_MountMap[target] then
			return select(4, GetCompanionInfo("MOUNT", _IFActionHandler_MountMap[target]))
		end
	elseif kind == "equipmentset" then
		return _IFActionHandler_EquipSetMap[target] and select(2, GetEquipmentSetInfo(_IFActionHandler_EquipSetMap[target]))
	elseif kind == "battlepet" then
		return select(9, C_PetJournal.GetPetInfoByPetID(target))
	elseif kind == "worldmarker" then
		return _WorldMarker[tonumber(target)]
	else
		return self.__IFActionHandler_Texture
	end
end

function handler:GetActionCharges()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return GetActionCharges(target)
	elseif kind == "spell" then
		return GetSpellCharges(target)
	end
end

function handler:GetActionCount()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return GetActionCount(target)
	elseif kind == "spell" then
		return GetSpellCount(target)
	elseif kind == "item" then
		return GetItemCount(target)
	else
		return 0
	end
end

function handler:GetActionCooldown()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return GetActionCooldown(target)
	elseif kind == "pet" or kind == "petaction" then
		return GetPetActionCooldown(target)
	elseif kind == "spell" then
		if _IFActionHandler_StanceMap[target] then
			if select(2, GetSpellCooldown(target)) > 2 then
				return GetSpellCooldown(target)
			end
		else
			return GetSpellCooldown(target)
		end
	elseif kind == "item" then
		return GetItemCooldown(target)
	else
		return 0, 0, 0
	end
end

function handler:IsAttackAction()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return IsAttackAction(target)
	elseif kind == "spell" then
		return IsAttackSpell(GetSpellInfo(target))
	end
end

function handler:IsEquippedItem()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return IsEquippedAction(target)
	elseif kind == "item" then
		return IsEquippedItem(target)
	elseif kind == "equipmentset" then
		return true
	end
end

function handler:IsActivedAction()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return IsCurrentAction(target)
	elseif kind == "spell" then
		return IsCurrentSpell(target)
	elseif kind == "item" then
		return IsCurrentItem(target)
	elseif kind == "equipmentset" then
		return _IFActionHandler_EquipSetMap[target] and select(4, GetEquipmentSetInfo(_IFActionHandler_EquipSetMap[target]))
	elseif kind == "companion" then
		return _IFActionHandler_MountMap[target] and select(5, GetCompanionInfo("MOUNT", _IFActionHandler_MountMap[target]))
	elseif kind == "worldmarker" then
		target = tonumber(target)
		-- No event for world marker, disable it now
		return false and target and target >= 1 and target <= NUM_WORLD_RAID_MARKERS and IsRaidMarkerActive(target)
	end
end

function handler:IsAutoRepeatAction()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return IsAutoRepeatAction(target)
	elseif kind == "spell" then
		return IsAutoRepeatSpell(GetSpellInfo(target))
	end
end

function handler:IsUsableAction()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return IsUsableAction(target)
	elseif kind == "pet" or kind == "petaction" then
		return GetPetActionSlotUsable(target)
	elseif kind == "spell" then
		if _IFActionHandler_StanceMap[target] then
			return select(4, GetShapeshiftFormInfo(_IFActionHandler_StanceMap[target]))
		else
			return IsUsableSpell(target)
		end
	elseif kind == "item" then
		return IsUsableItem(target)
	elseif kind == "companion" then
		return IsUsableSpell(target)
	elseif kind and kind ~= "" then
		return true
	end
end

function handler:IsConsumableAction()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return IsConsumableAction(target) or IsStackableAction(target) or (not IsItemAction(target) and GetActionCount(target) > 0)
	elseif kind == "spell" then
		return IsConsumableSpell(target)
	elseif kind == "item" then
		-- return IsConsumableItem(target) blz sucks, wait until IsConsumableItem is fixed
		local _, _, _, _, _, _, _, maxStack = GetItemInfo(target)

		if IsUsableItem(target) and maxStack and maxStack > 1 then
			return true
		else
			return false
		end
	end
end

function handler:IsInRange()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		return IsActionInRange(target, self:GetAttribute("unit"))
	elseif kind == "spell" then
		return IsSpellInRange(GetSpellInfo(target), self:GetAttribute("unit"))
	elseif kind == "item" then
		return IsItemInRange(target, self:GetAttribute("unit"))
	end
end

function handler:IsAutoCastAction()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "pet" or kind == "petaction" then
		return select(6, GetPetActionInfo(target))
	else
		return false
	end
end

function handler:IsAutoCasting()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "pet" or kind == "petaction" then
		return select(7, GetPetActionInfo(target))
	else
		return false
	end
end

function handler:SetTooltip()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		_GameTooltip:SetAction(target)
	elseif kind == "pet" or kind == "petaction" then
		_GameTooltip:SetPetAction(target)
	elseif kind == "spell" then
		_GameTooltip:SetSpellByID(target)
	elseif kind == "flyout" then
		_GameTooltip:SetSpellBookItem(_IFActionHandler_FlyoutSlot[target], "spell")
	elseif kind == "item" then
		_GameTooltip:SetHyperlink(select(2, GetItemInfo(target)))
	elseif kind == "companion" then
		if _IFActionHandler_MountMap[target] then
			_GameTooltip:SetSpellByID(select(3, GetCompanionInfo("MOUNT", _IFActionHandler_MountMap[target])))
		end
	elseif kind == "equipmentset" then
		_GameTooltip:SetEquipmentSet(target)
	elseif kind == "battlepet" then
		local speciesID, _, _, _, _, _, _, name, _, _, _, sourceText, description, _, _, tradable, unique = C_PetJournal.GetPetInfoByPetID(target)

		if speciesID then
			_GameTooltip:SetText(name, 1, 1, 1)

			if sourceText and sourceText ~= "" then
				_GameTooltip:AddLine(sourceText, 1, 1, 1, true)
			end

			if description and description ~= "" then
				_GameTooltip:AddLine(" ")
				_GameTooltip:AddLine(description, nil, nil, nil, true)
			end
			_GameTooltip:Show()
		end
	elseif self.__IFActionHandler_Tooltip then
		_GameTooltip:SetText(self.__IFActionHandler_Tooltip)
	end
end

function handler:GetSpellId()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "action" then
		local type, id = GetActionInfo(target)
		if type == "spell" then
			return id
		elseif type == "macro" then
			return (select(3, GetMacroSpell(id)))
		end
	elseif kind == "spell" then
		return target
	end
end

function handler:IsFlyout()
	local kind, target = self.__IFActionHandler_Kind, self.__IFActionHandler_Action
	if kind == "flyout" then
		return true
	end
end