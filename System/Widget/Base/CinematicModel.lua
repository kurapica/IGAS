-- Author      : Kurapica
-- Create Date : 2016/07/21
-- ChangeLog   :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.CinematicModel", version) then
	return
end

__AutoProperty__()
class "CinematicModel"
	inherit "PlayerModel"

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	local BackdropTemplateMixin = _G.BackdropTemplateMixin

	function Constructor(self, name, parent, template, ...)
		if BackdropTemplateMixin then
			if template then
				template = template .. ", BackdropTemplate"
			else
				template = "BackdropTemplate"
			end
		end
		return CreateFrame("CinematicModel", nil, parent, template, ...)
	end

endclass "CinematicModel"

class "CinematicModel"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(CinematicModel)

	------------------------------------------------------
	-- Property
	------------------------------------------------------
endclass "CinematicModel"