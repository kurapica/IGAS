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

	Target = "macrotext",

	DragStyle = "Block",

	ReceiveStyle = "Block",

	OnEnableChanged = function(self) _Enabled = self.Enabled end,
}

-- Overwrite methods
function handler:GetActionText()
	return self.CustomText
end

function handler:GetActionTexture()
	return self.CustomTexture
end

function handler:SetTooltip(GameTooltip)
	if self.CustomTooltip then
		GameTooltip:SetText(self.CustomTooltip)
	end
end

-- Expand IFActionHandler
interface "IFActionHandler"
	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Macro
		@type property
		@desc The action button's content if its type is 'macrotext'
	]======]
	property "MacroText" {
		Get = function(self)
			return self:GetAttribute("actiontype") == "macrotext" and self:GetAttribute("macrotext") or nil
		end,
		Set = function(self, value)
			self:SetAction("macrotext", value)
		end,
		Type = System.String + nil,
	}

	doc [======[
		@name CustomText
		@type property
		@desc The custom text
	]======]
	property "CustomText" { Type = String + nil }

	doc [======[
		@name CustomTexture
		@type property
		@desc The custom texture path
	]======]
	property "CustomTexture" { Type = String + nil }

	doc [======[
		@name CustomTooltip
		@type property
		@desc The custom tooltip
	]======]
	property "CustomTooltip" { Type = String + nil }
endinterface "IFActionHandler"