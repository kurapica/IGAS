-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- AssistantIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name AssistantIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.AssistantIcon", version) then
	return
end

class "AssistantIcon"
	inherit "Texture"
	extend "IFAssistant"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function AssistantIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "AssistantIcon"