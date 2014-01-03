-- Author      : Kurapica
-- Create Date : 2013/11/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.MacroHandler", version) then
	return
end

_Enabled = false

handler = ActionTypeHandler {
	Name = "macrotext",

	Type = "macro",

	InitSnippet = [[
	]],

	PickupSnippet = [[
		return "clear", "macro", ...
	]],

	UpdateSnippet = [[
	]],

	ReceiveSnippet = [[
	]],

	ClearSnippet = [[
		self:SetAttribute("macrotext", nil)
	]],

	OnEnableChanged = function(self) _Enabled = self.Enabled end,
}

-- Overwrite methods
function handler:PickupAction(target)
	return PickupMacro(target)
end

function handler:GetActionText()
	return (GetMacroInfo(self.ActionTarget))
end

function handler:GetActionTexture()
	return (select(2, GetMacroInfo(self.ActionTarget)))
end

-- Expand IFActionHandler
interface "IFActionHandler"
	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Macro
		@type property
		@desc The action button's content if its type is 'macro'
	]======]
	property "Macro" {
		Get = function(self)
			return self:GetAttribute("type") == "macro" and self:GetAttribute("macro") or nil
		end,
		Set = function(self, value)
			self:SetAction("macro", value)
		end,
		Type = System.String + System.Number + nil,
	}
endinterface "IFActionHandler"