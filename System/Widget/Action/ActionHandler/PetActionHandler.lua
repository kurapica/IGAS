-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.PetActionHandler", version) then
	return
end

handler = ActionTypeHandler {
	Type = "pet",
	Type2 = "petaction",

	Action = "action",

	InitSnippet = [[
	]],

	PickupSnippet = [[
		local kind, target = ...
		return "petaction", target
	]],

	UpdateSnippet = [[
		local kind, target = ...

		if tonumber(target) then
			-- Use macro to toggle auto cast
			self:SetAttribute("type2", "macro")
			self:SetAttribute("macrotext2", "/click PetActionButton".. target .. " RightButton")
		end
	]],

	ReceiveSnippet = [[
	]],
}

-- Overwrite methods
function handler:HasAction()
	return GetPetActionInfo(self.ActionTarget) and true
end

function handler:GetActionTexture()
	local name, _, texture, isToken = GetPetActionInfo(self.ActionTarget)
	if name then
		return isToken and _G[texture] or texture
	end
end

function handler:GetActionCooldown()
	return GetPetActionCooldown(self.ActionTarget)
end

function handler:IsUsableAction()
	return GetPetActionSlotUsable(self.ActionTarget)
end

function handler:IsAutoCastAction()
	return select(6, GetPetActionInfo(self.ActionTarget))
end

function handler:IsAutoCasting()
	return select(7, GetPetActionInfo(self.ActionTarget))
end

function handler:SetTooltip(GameTooltip)
	GameTooltip:SetPetAction(self.ActionTarget)
end
