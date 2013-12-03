-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.SpellHandler", version) then
	return
end

import "ActionRefreshMode"

_StanceMapTemplate = "_StanceMap[%d] = %d\n"

_StanceMap = {}
_Profession = {}

-- Event handler
function OnEnable(self)
	self:RegisterEvent("LEARNED_SPELL_IN_TAB")
	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("SKILL_LINES_CHANGED")
	self:RegisterEvent("PLAYER_GUILD_UPDATE")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")

	UpdateStanceMap()

	OnEnable = nil
end

function LEARNED_SPELL_IN_TAB(self)
	RefreshTooltip()

	return UpdateProfession()
end

function SPELLS_CHANGED(self)
	return UpdateProfession()
end

function SKILL_LINES_CHANGED(self)
	return UpdateProfession()
end

function PLAYER_GUILD_UPDATE(self)
	return UpdateProfession()
end

function PLAYER_SPECIALIZATION_CHANGED(self, unit)
	if unit == "player" then
		return UpdateProfession()
	end
end

function UPDATE_SHAPESHIFT_FORMS(self)
	UpdateStanceMap()

	return handler:Refresh()
end

function UpdateStanceMap()
	local str = "for i in pairs(_StanceMap) do _StanceMap[i] = nil end\n"

	wipe(_StanceMap)

	for i = 1, GetNumShapeshiftForms() do
	    local name = select(2, GetShapeshiftFormInfo(i))
	    name = GetSpellLink(name)
	    name = tonumber(name and name:match("spell:(%d+)"))
	    if name then
			str = str.._StanceMapTemplate:format(name, i)
	    	_StanceMap[name] = i
	    end
	end

	if str ~= "" then
		IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
			handler:RunSnippet( str )

			for _, btn in handler() do
				if _StanceMap[btn.ActionTarget] then
					btn:SetAttribute("*type*", "macro")
					btn:SetAttribute("*macrotext*", "/click StanceButton".._StanceMap[btn.ActionTarget])
				end
			end
		end)
	end
end

function UpdateProfession()
	local lst = {GetProfessions()}
	local offset, spell, name

	for i = 1, 6 do
	    if lst[i] then
	        offset = 1 + select(6, GetProfessionInfo(lst[i]))
	        spell = select(2, GetSpellBookItemInfo(offset, "spell"))
	        name = GetSpellBookItemName(offset, "spell")

	        if _Profession[name] ~= spell then
	        	_Profession[name] = spell
	        	IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
	        		for _, btn in handler() do
	        			if GetSpellInfo(btn.ActionTarget) == name then
	        				btn:SetAction("spell", spell)
	        			end
	        		end
	        	end)
	        end
	    end
	end
end

-- Spell action type handler
handler = ActionTypeHandler {
	Type = "spell",

	Action = "spell",

	InitSnippet = [[
		_StanceMap = newtable()
	]],

	PickupSnippet = [[
		return "clear", "spell", ...
	]],

	UpdateSnippet = [[
		local target = ...

		if _StanceMap[target] then
			-- Need this to cancel stance, use spell to replace stance button
			self:SetAttribute("*type*", "macro")
			self:SetAttribute("*macrotext*", "/click StanceButton".. _StanceMap[target])
		end
	]],

	ReceiveSnippet = [[
		local value, detail, extra = ...

		-- Spell id is stored in extra
		return extra
	]],

	ClearSnippet = [[
		self:SetAttribute("*type*", nil)
		self:SetAttribute("*macrotext*", nil)
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	return PickupSpell(target)
end

function handler:GetActionTexture()
	local target = self.ActionTarget

	if _StanceMap[target] then
		return (GetShapeshiftFormInfo(_StanceMap[target]))
	else
		return GetSpellTexture(target)
	end
end

function handler:GetActionCharges()
	return GetSpellCharges(self.ActionTarget)
end

function handler:GetActionCount()
	return GetSpellCount(self.ActionTarget)
end

function handler:GetActionCooldown()
	local target = self.ActionTarget

	if _StanceMap[target] then
		if select(2, GetSpellCooldown(target)) > 2 then
			return GetSpellCooldown(target)
		end
	else
		return GetSpellCooldown(target)
	end
end

function handler:IsAttackAction()
	return IsAttackSpell(GetSpellInfo(self.ActionTarget))
end

function handler:IsActivedAction()
	if _StanceMap[self.ActionTarget] then
		return select(3, GetShapeshiftFormInfo(_StanceMap[target]))
	else
		return IsCurrentSpell(self.ActionTarget)
	end
end

function handler:IsAutoRepeatAction()
	return IsAutoRepeatSpell(GetSpellInfo(self.ActionTarget))
end

function handler:IsUsableAction()
	local target = self.ActionTarget

	if _StanceMap[target] then
		return select(4, GetShapeshiftFormInfo(_StanceMap[target]))
	else
		return IsUsableSpell(target)
	end
end

function handler:IsConsumableAction()
	return IsConsumableSpell(self.ActionTarget)
end

function handler:IsInRange()
	return IsSpellInRange(GetSpellInfo(self.ActionTarget), self:GetAttribute("unit"))
end

function handler:SetTooltip(GameTooltip)
	GameTooltip:SetSpellByID(self.ActionTarget)
end

function handler:GetSpellId()
	return self.ActionTarget
end

-- Part-interface definition
interface "IFActionHandler"
	local old_SetAction = IFActionHandler.SetAction

	function SetAction(self, kind, target, ...)
		if kind == "spell" then
			-- Convert to spell id
			if tonumber(target) then
				target = tonumber(target)
			else
				target = GetSpellLink(target)
		   		target = tonumber(target and target:match("spell:(%d+)"))
			end

			if target and _Profession[GetSpellInfo(target)] then
				target = _Profession[GetSpellInfo(target)]
			end
		end

		return old_SetAction(self, kind, target, ...)
	end
endinterface "IFActionHandler"