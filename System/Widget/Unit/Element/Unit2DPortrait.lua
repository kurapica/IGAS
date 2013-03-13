-- Author      : Kurapica
-- Create Date : 2012/06/24

local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.Unit2DPortrait", version) then
	return
end

class "Unit2DPortrait"
	inherit "Texture"
	extend "IFPortrait"

	doc [======[
		@name Unit2DPortrait
		@type class
		@desc The 2D unit portrait
	]======]
endclass "Unit2DPortrait"