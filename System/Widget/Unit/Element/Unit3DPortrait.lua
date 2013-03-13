-- Author      : Kurapica
-- Create Date : 2012/06/24

local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.Unit3DPortrait", version) then
	return
end

class "Unit3DPortrait"
	inherit "PlayerModel"
	extend "IFPortrait"

	doc [======[
		@name Unit3DPortrait
		@type class
		@desc The 3D unit portrait
	]======]
endclass "Unit3DPortrait"