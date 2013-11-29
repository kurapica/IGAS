-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.EquipSetHandler", version) then
	return
end

_EquipSetTemplate = "_EquipSet[%q] = %d\n"

_EquipSetMap = {}

handler = ActionTypeHandler {
	Type = "equipmentset",

	Action = "equipmentset",

	InitSnippet = [[
		_EquipSet = newtable()
	]],

	PickupSnippet = [[
		local target = ...
		return "clear", "equipmentset", _EquipSet[target]
	]],

	UpdateSnippet = [[
		local target = ...

		self:SetAttribute("*type*", "macro")
		self:SetAttribute("*macrotext*", "/equipset "..target)
	]],

	ReceiveSnippet = [[
	]],

	ClearSnippet = [[
		self:SetAttribute("*type*", nil)
		self:SetAttribute("*macrotext*", nil)
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	local index = 1
	while GetEquipmentSetInfo(index) do
		if GetEquipmentSetInfo(index) == target then
			return PickupEquipmentSet(index)
		end
		index = index + 1
	end
end

function handler:GetActionText()
	return self.ActionTarget
end

function handler:GetActionTexture()
	local target = self.ActionTarget
	return _EquipSetMap[target] and select(2, GetEquipmentSetInfo(_EquipSetMap[target]))
end

function handler:IsEquippedItem()
	return true
end

function handler:IsActivedAction()
	local target = self.ActionTarget
	return _EquipSetMap[target] and select(4, GetEquipmentSetInfo(_EquipSetMap[target]))
end

function handler:SetTooltip(GameTooltip)
	GameTooltip:SetEquipmentSet(self.ActionTarget)
end
