-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.BattlePetHandler", version) then
	return
end

handler = ActionTypeHandler {
	Type = "battlepet",

	Action = "battlepet",

	InitSnippet = [[
	]],

	PickupSnippet = [[
		return "clear", ...
	]],

	UpdateSnippet = [[
		local kind, target = ...

		-- just *type* to keep type to battlepet
		self:SetAttribute("*type*", "macro")
		self:SetAttribute("*macrotext*", "/summonpet "..target)
	]],

	ReceiveSnippet = [[
	]],
}

-- Overwrite methods
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
