-- Author      : Kurapica
-- Create Date : 2014/10/16
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.ToyHandler", version) then
	return
end

import "System.Widget.Action.ActionRefreshMode"

_ToyCastTemplate = "/run UseToy(%d)"

-- Event handler
function OnEnable(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("TOYS_UPDATED")
	self:RegisterEvent("SPELLS_CHANGED")
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")

	OnEnable = nil
end

function PLAYER_ENTERING_WORLD(self)
	return handler:Refresh()
end

function SPELLS_CHANGED(self)
	return handler:Refresh()
end

function UPDATE_SHAPESHIFT_FORM(self)
	return handler:Refresh()
end

function TOYS_UPDATED(self, itemID, new)
	return handler:Refresh()
end

function SPELL_UPDATE_COOLDOWN(self)
	return handler:Refresh(RefreshCooldown)
end

-- Companion action type handler
handler = ActionTypeHandler {
	Name = "toy",

	InitSnippet = [[
		_ToyCastTemplate = "/run UseToy(%d)"
	]],

	PickupSnippet = "Custom",

	UpdateSnippet = [[
		local target = ...

		self:SetAttribute("*type*", "macro")
		self:SetAttribute("*macrotext*", _ToyCastTemplate:format(target))
	]],

	ReceiveSnippet = [[
		local value, detail, extra = ...

		local mount
		for spell, index in pairs(_ToyMap) do
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
	local target = self.ActionTarget
	return target and C_ToyBox.PickupToyBoxItem(target)
end

function handler:GetActionTexture()
	local target = self.ActionTarget
	return target and (select(3, C_ToyBox.GetToyInfo(target)))
end

function handler:GetActionCooldown()
	local target = self.ActionTarget
	return target and GetItemCooldown(target)
end

function handler:IsUsableAction()
	local target = self.ActionTarget
	return target and IsUsableItem(target)
end

function handler:SetTooltip(GameTooltip)
	local target = self.ActionTarget
	return target and GameTooltip:SetToyByItemID(target)
end

-- Expand IFActionHandler
interface "IFActionHandler"
	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[The action button's content if its type is 'toy']]
	property "Toy" {
		Get = function(self)
			return self:GetAttribute("actiontype") == "toy"
		end,
		Set = function(self, value)
			self:SetAction("toy", value)
		end,
		Type = System.Number + nil,
	}
endinterface "IFActionHandler"