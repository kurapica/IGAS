-- Author      : Kurapica
-- Create Date : 2012/08/03
-- ChangeLog

local version = 2
if not IGAS:NewAddon("IGAS.Widget.ElementPanel", version) then
	return
end

class "ElementPanel"
	inherit "Frame"
	extend "IFElementPanel"

	doc [======[
		@name ElementPanel
		@type class
		@desc ElementPanel is used to contains several same class ui elements like a grid.
	]======]

endclass "ElementPanel"