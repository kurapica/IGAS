-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.CompanionHandler", version) then
	return
end

import "System.Widget.Action.ActionRefreshMode"

_MountMapTemplate = "_MountMap[%d] = %d\n"
_MountCastTemplate = "/run if not InCombatLockdown() then if select(4, MountJournal_GetMountInfo(%d)) then MountJournal_Dismiss() else MountJournal_Summon(%d) end end"

_MountMap = {}

-- Event handler
function OnEnable(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMPANION_LEARNED")
	self:RegisterEvent("COMPANION_UNLEARNED")
	self:RegisterEvent("COMPANION_UPDATE")
	self:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
	self:RegisterEvent("SPELL_UPDATE_USABLE")

	OnEnable = nil
end

function PLAYER_ENTERING_WORLD(self)
	if not next(_MountMap) then
		UpdateMount()
	end
end

function COMPANION_LEARNED(self)
	UpdateMount()
end

function COMPANION_UNLEARNED(self)
	UpdateMount()
end

function COMPANION_UPDATE(self, type)
	if type == "MOUNT" then
		UpdateMount()
		handler:Refresh(RefreshButtonState)
	end
end

function MOUNT_JOURNAL_USABILITY_CHANGED(self)
	UpdateMount()
	handler:Refresh(RefreshButtonState)
end

function SPELL_UPDATE_USABLE(self)
	return handler:Refresh(RefreshUsable)
end

function UpdateMount()
	local str = ""

	for i = 1, MountJournal_GetNumMounts() do
	    local _, spellId = MountJournal_GetMountInfo(i)

	    if spellId and _MountMap[spellId] ~= i then
			str = str.._MountMapTemplate:format(spellId, i)
			_MountMap[spellId] = i
	    end
	end

	if str ~= "" then
		handler:Refresh()

		IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
			handler:RunSnippet( str )

			for _, btn in handler() do
				local index = _MountMap[btn.ActionTarget]
				if index then
					btn:SetAttribute("*type*", "macro")
					btn:SetAttribute("*macrotext*", _MountCastTemplate:format(index, index))
				end
			end
		end)
	end
end

-- Companion action type handler
handler = ActionTypeHandler {
	Name = "companion",

	InitSnippet = [[
		_MountMap = newtable()

		_MountCastTemplate = "/run if not InCombatLockdown() then if select(4, MountJournal_GetMountInfo(%d)) then MountJournal_Dismiss() else MountJournal_Summon(%d) end end"
	]],

	PickupSnippet = [[
		local target = ...
		return "clear", "companion", "mount", _MountMap[target]
	]],

	UpdateSnippet = [[
		local target = ...
		local index = _MountMap[target]

		self:SetAttribute("*type*", "macro")
		self:SetAttribute("*macrotext*", _MountCastTemplate:format(index, index))
	]],

	ReceiveSnippet = [[
		local value, detail, extra = ...

		local mount
		for spell, index in pairs(_MountMap) do
			if value == index then
				mount = spell
				break
			end
		end
		value = mount

		return value
	]],

	ClearSnippet = [[
		self:SetAttribute("*type*", nil)
		self:SetAttribute("*macrotext*", nil)
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	local target = _MountMap[self.ActionTarget]

	return target and MountJournal_Pickup(target)
end

function handler:GetActionTexture()
	local target = _MountMap[self.ActionTarget]

	return target and (select(3, MountJournal_GetMountInfo(target)))
end

function handler:IsActivedAction()
	local target = _MountMap[self.ActionTarget]

	return target and (select(4, MountJournal_GetMountInfo(target)))
end

function handler:IsUsableAction()
	local target = _MountMap[self.ActionTarget]

	return target and (select(5, MountJournal_GetMountInfo(target)))
end

function handler:SetTooltip(GameTooltip)
	local target = _MountMap[self.ActionTarget]

	return target and GameTooltip:SetMountBySpellID(select(2, MountJournal_GetMountInfo(target)))
end

-- Expand IFActionHandler
interface "IFActionHandler"
	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[The action button's content if its type is 'mount']]
	property "Mount" {
		Get = function(self)
			return self:GetAttribute("actiontype") == "companion" and tonumber(self:GetAttribute("companion")) or nil
		end,
		Set = function(self, value)
			self:SetAction("companion", value)
		end,
		Type = System.Number + nil,
	}
endinterface "IFActionHandler"