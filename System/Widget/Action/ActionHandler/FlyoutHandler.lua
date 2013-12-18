-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.FlyoutHandler", version) then
	return
end

import "ActionRefreshMode"

MAX_SKILLLINE_TABS = _G.MAX_SKILLLINE_TABS

enum "FlyoutDirection" {
	"UP",
	"DOWN",
	"LEFT",
	"RIGHT",
}

_FlyoutSlotTemplate = "_FlyoutSlot[%d] = %d\n"

_FlyoutSlot = {}
_FlyoutTexture = {}

-- Event handler
function OnEnable(self)
	self:RegisterEvent("LEARNED_SPELL_IN_TAB")
	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("SKILL_LINES_CHANGED")
	self:RegisterEvent("PLAYER_GUILD_UPDATE")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

	OnEnable = nil
end

function LEARNED_SPELL_IN_TAB(self)
	return UpdateFlyoutSlotMap()
end

function SPELLS_CHANGED(self)
	return UpdateFlyoutSlotMap()
end

function SKILL_LINES_CHANGED(self)
	return UpdateFlyoutSlotMap()
end

function PLAYER_GUILD_UPDATE(self)
	return UpdateFlyoutSlotMap()
end

function PLAYER_SPECIALIZATION_CHANGED(self, unit)
	if unit == "player" then
		return UpdateFlyoutSlotMap()
	end
end

function UpdateFlyoutSlotMap()
	local str = "for i in pairs(_FlyoutSlot) do _FlyoutSlot[i] = nil end\n"
	local type, id
	local name, texture, offset, numEntries, isGuild, offspecID

	wipe(_FlyoutSlot)
	wipe(_FlyoutTexture)

	for i = 1, MAX_SKILLLINE_TABS do
		name, texture, offset, numEntries, isGuild, offspecID = GetSpellTabInfo(i)

		if not name then
			break
		end

		if not isGuild and offspecID == 0 then
			for index = offset + 1, offset + numEntries do
				type, id = GetSpellBookItemInfo(index, "spell")

				if type == "FLYOUT" then
					if not _FlyoutSlot[id] then
						str = str.._FlyoutSlotTemplate:format(id, index)
						_FlyoutSlot[id] = index
						_FlyoutTexture[id] = GetSpellBookItemTexture(index, "spell")
					end
				end
			end
		end
	end

	IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
		handler:RunSnippet( str )
	end)
end

-- Flyout action type handler
handler = ActionTypeHandler {
	Name = "flyout",

	Target = "spell",

	InitSnippet = [[
		_FlyoutSlot = newtable()
	]],

	PickupSnippet = [[
		return "clear", "flyout", ...
	]],

	UpdateSnippet = [[
	]],

	ReceiveSnippet = [[
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	return PickupSpellBookItem(_FlyoutSlot[target], "spell")
end

function handler:GetActionTexture()
	return _FlyoutTexture[self.ActionTarget]
end

function handler:SetTooltip(GameTooltip)
	GameTooltip:SetSpellBookItem(_FlyoutSlot[self.ActionTarget], "spell")
end

function handler:IsFlyout()
	return true
end