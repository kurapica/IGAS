-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :
--               2014/10/17 Use the spell id as the action content, not index

-- Check Version
local version = 3
if not IGAS:NewAddon("IGAS.Widget.Action.MountHandler", version) then
	return
end

import "System.Widget.Action.ActionRefreshMode"

_MountMapTemplate = "_MountPick2Spell[%d] = %d;_MountSpell2Index[%d] = %d"
_MountCastTemplate = "/run if not InCombatLockdown() then if select(4, C_MountJournal.GetMountInfo(%d)) then C_MountJournal.Dismiss() else C_MountJournal.Summon(%d) end end"

_MountMap = {}
Pick2Spell = {}
Spell2Index = {}

GetMountInfo = C_MountJournal.GetMountInfo

-- Event handler
function OnEnable(self)
	IGAS_DB.MountHandler_Data = IGAS_DB.MountHandler_Data or {}

	MountData = IGAS_DB.MountHandler_Data

	-- Update for new ui version
	if MountData.Version ~= select(4, GetBuildInfo()) then
		MountData.Version = select(4, GetBuildInfo())
		MountData.Pick2Spell = {}
		MountData.Spell2Index = {}
	end

	Pick2Spell = MountData.Pick2Spell
	Spell2Index = MountData.Spell2Index

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMPANION_LEARNED")
	self:RegisterEvent("COMPANION_UNLEARNED")
	self:RegisterEvent("COMPANION_UPDATE")
	self:RegisterEvent("MOUNT_JOURNAL_USABILITY_CHANGED")
	self:RegisterEvent("SPELL_UPDATE_USABLE")

	OnEnable = nil
end

function PLAYER_ENTERING_WORLD(self)
	Task.ThreadCall(UpdateMount)
	PLAYER_ENTERING_WORLD = nil
end

function COMPANION_LEARNED(self, companionType)
	if not companionType or companionType == "MOUNT" then
		Task.ThreadCall(UpdateMount)
	end
end

function COMPANION_UNLEARNED(self, companionType)
	if not companionType or companionType == "MOUNT" then
		Task.ThreadCall(UpdateMount)
	end
end
function COMPANION_UPDATE(self, companionType)
	if not companionType or companionType == "MOUNT" then
		return handler:Refresh(RefreshUsable)
	end
end
function MOUNT_JOURNAL_USABILITY_CHANGED(self, companionType)
	if not companionType or companionType == "MOUNT" then
		Task.ThreadCall(UpdateMount)
	end
end

function SPELL_UPDATE_USABLE(self)
	return handler:Refresh(RefreshButtonState)
end

function UpdateMount(init)
	local cache = {}

	if not next(_MountMap) then
		-- Do the init
		for pick, spell in pairs(Pick2Spell) do
			local index = Spell2Index[spell]
			_MountMap[index] = true
	    	tinsert(cache, _MountMapTemplate:format(pick, spell, spell, index))
		end
	end

	for index = 1, C_MountJournal.GetNumMounts() do
		if index % 10 == 0 then Task.Continue() end

		if not _MountMap[index] then
			local _, spell = GetMountInfo(index)

			-- It's wierd but useful
			C_MountJournal.Pickup(index)
		    local ty, pick = GetCursorInfo()
			ClearCursor()

			spell = tonumber(spell)
			pick = tonumber(pick)

			if pick and spell then
				Pick2Spell[pick] = spell
				Spell2Index[spell] = index

				_MountMap[index] = true
	    		tinsert(cache, _MountMapTemplate:format(pick, spell, spell, index))
			end
		end
	end

	if next(cache) then
		IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
			handler:RunSnippet( tblconcat(cache, ";") )

			for _, btn in handler() do
				local index = Spell2Index[btn.ActionTarget]
				if index then
					btn:SetAttribute("*type*", "macro")
					btn:SetAttribute("*macrotext*", _MountCastTemplate:format(index, index))
				end
			end

			handler:Refresh()
		end)
	end
end

-- Companion action type handler
handler = ActionTypeHandler {
	Name = "mount",

	InitSnippet = [[
		_MountPick2Spell = newtable()
		_MountSpell2Index = newtable()

		_MountCastTemplate = "/run if not InCombatLockdown() then if select(4, C_MountJournal.GetMountInfo(%d)) then C_MountJournal.Dismiss() else C_MountJournal.Summon(%d) end end"
	]],

	PickupSnippet = "Custom",

	UpdateSnippet = [[
		local target = ...
		target = _MountSpell2Index[target]

		if target then
			self:SetAttribute("*type*", "macro")
			self:SetAttribute("*macrotext*", _MountCastTemplate:format(target, target))
		else
			self:SetAttribute("*type*", nil)
			self:SetAttribute("*macrotext*", nil)
		end
	]],

	ReceiveSnippet = [[
		local value = ...
		return _MountPick2Spell[value]
	]],

	ClearSnippet = [[
		self:SetAttribute("*type*", nil)
		self:SetAttribute("*macrotext*", nil)
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	return target and C_MountJournal.Pickup(Spell2Index[target])
end

function handler:GetActionTexture()
	return (select(3, GetMountInfo(Spell2Index[self.ActionTarget])))
end

function handler:IsActivedAction()
	return (select(4, GetMountInfo(Spell2Index[self.ActionTarget])))
end

function handler:IsUsableAction()
	return (select(5, GetMountInfo(Spell2Index[self.ActionTarget])))
end

function handler:SetTooltip(GameTooltip)
	return GameTooltip:SetMountBySpellID(self.ActionTarget)
end

-- Expand IFActionHandler
interface "IFActionHandler"
	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[The action button's content if its type is 'mount']]
	property "Mount" {
		Get = function(self)
			return self:GetAttribute("actiontype") == "mount" and tonumber(self:GetAttribute("mount"))
		end,
		Set = function(self, value)
			self:SetAction("mount", value)
		end,
		Type = System.Number + nil,
	}
endinterface "IFActionHandler"