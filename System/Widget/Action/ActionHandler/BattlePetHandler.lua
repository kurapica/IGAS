-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.BattlePetHandler", version) then
	return
end

_Enabled = false

-- Event handler
function OnEnable(self)
	self:RegisterEvent("PET_JOURNAL_LIST_UPDATE")

	OnEnable = nil
end

function PET_JOURNAL_LIST_UPDATE(self)
	return handler:Refresh()
end

-- Battlepet action type handler
handler = ActionTypeHandler {
	Name = "battlepet",

	InitSnippet = [[
	]],

	PickupSnippet = "Custom",

	UpdateSnippet = [[
		local target = ...

		-- just *type* to keep type to battlepet
		self:SetAttribute("*type*", "macro")
		self:SetAttribute("*macrotext*", "/summonpet "..target)
	]],

	ReceiveSnippet = [[
	]],

	ClearSnippet = [[
		self:SetAttribute("*type*", nil)
		self:SetAttribute("*macrotext*", nil)
	]],

	OnEnableChanged = function(self) _Enabled = self.Enabled end,
}

-- Overwrite methods
function handler:PickupAction(target)
	return C_PetJournal.PickupPet(target)
end

function handler:GetActionTexture()
	return select(9, C_PetJournal.GetPetInfoByPetID(self.ActionTarget))
end

function handler:SetTooltip(GameTooltip)
	local speciesID, _, _, _, _, _, _, name, _, _, _, sourceText, description, _, _, tradable, unique = C_PetJournal.GetPetInfoByPetID(self.ActionTarget)

	if speciesID then
		GameTooltip:SetText(name, 1, 1, 1)

		if sourceText and sourceText ~= "" then
			GameTooltip:AddLine(sourceText, 1, 1, 1, true)
		end

		if description and description ~= "" then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(description, nil, nil, nil, true)
		end
		GameTooltip:Show()
	end
end
