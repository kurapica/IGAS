-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.MountHandler", version) then
	return
end

import "System.Widget.Action.ActionRefreshMode"

_MountMapTemplate = "_MountMap[%d] = %d"
_MountCastTemplate = "/run if not InCombatLockdown() then if select(4, C_MountJournal.GetMountInfo(%d)) then C_MountJournal.Dismiss() else C_MountJournal.Summon(%d) end end"

_MountMap = {}

GetMountInfo = C_MountJournal.GetMountInfo

-- Event handler
function OnEnable(self)
	IGAS_DB.MountHandler_Data = IGAS_DB.MountHandler_Data or {}

	MountData = IGAS_DB.MountHandler_Data

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

	for i = 1, C_MountJournal.GetNumMounts() do
		if i % 10 == 0 then Task.Continue() end

		local ty, moundID

		if MountData[i] then
			moundID = MountData[i]
		else
			C_MountJournal.Pickup(i)
		    ty, moundID = GetCursorInfo()
			ClearCursor()
			MountData[i] = moundID
		end

	    if moundID and _MountMap[moundID] ~= i then
	    	tinsert(cache, _MountMapTemplate:format(moundID, i))
			_MountMap[moundID] = i
	    end
	end

	if next(cache) then
		IFNoCombatTaskHandler._RegisterNoCombatTask(function ()
			handler:RunSnippet( tblconcat(cache, ";") )

			for _, btn in handler() do
				local index = btn.ActionTarget
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
		_MountMap = newtable()

		_MountCastTemplate = "/run if not InCombatLockdown() then if select(4, C_MountJournal.GetMountInfo(%d)) then C_MountJournal.Dismiss() else C_MountJournal.Summon(%d) end end"
	]],

	PickupSnippet = "Custom",

	UpdateSnippet = [[
		local target = ...

		self:SetAttribute("*type*", "macro")
		self:SetAttribute("*macrotext*", _MountCastTemplate:format(target, target))
	]],

	ReceiveSnippet = [[
		local value, detail, extra = ...
		value = _MountMap[value]
		return value
	]],

	ClearSnippet = [[
		self:SetAttribute("*type*", nil)
		self:SetAttribute("*macrotext*", nil)
	]],
}

-- Overwrite methods
function handler:PickupAction(target)
	return target and C_MountJournal.Pickup(target)
end

function handler:GetActionTexture()
	return (select(3, GetMountInfo(self.ActionTarget)))
end

function handler:IsActivedAction()
	return (select(4, GetMountInfo(self.ActionTarget)))
end

function handler:IsUsableAction()
	return (select(5, GetMountInfo(self.ActionTarget)))
end

function handler:SetTooltip(GameTooltip)
	return GameTooltip:SetMountBySpellID(select(2, GetMountInfo(self.ActionTarget)))
end

-- Expand IFActionHandler
interface "IFActionHandler"
	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[The action button's content if its type is 'mount']]
	property "Mount" {
		Get = function(self)
			return self:GetAttribute("actiontype") == "mount" and tonumber(self:GetAttribute("mount")) or nil
		end,
		Set = function(self, value)
			self:SetAction("mount", value)
		end,
		Type = System.Number + nil,
	}
endinterface "IFActionHandler"