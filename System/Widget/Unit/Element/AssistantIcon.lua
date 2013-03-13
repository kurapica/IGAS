-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.AssistantIcon", version) then
	return
end

class "AssistantIcon"
	inherit "Texture"
	extend "IFAssistant"

	doc [======[
		@name AssistantIcon
		@type class
		@desc The assistant icon
	]======]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function AssistantIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "AssistantIcon"