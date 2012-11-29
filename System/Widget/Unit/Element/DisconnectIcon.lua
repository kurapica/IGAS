-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- DisconnectIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name DisconnectIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.DisconnectIcon", version) then
	return
end

class "DisconnectIcon"
	inherit "Texture"
	extend "IFConnect"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Connected
	property "Connected" {
		Set = function(self, value)
			self.Visible = not value
		end,
		Get = function(self)
			return not self.Visible
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function DisconnectIcon(...)
		local icon = Super(...)

		icon.TexturePath = [[Interface\CharacterFrame\Disconnect-Icon]]
		icon.Height = 16
		icon.Width = 16

		return icon
	end
endclass "DisconnectIcon"