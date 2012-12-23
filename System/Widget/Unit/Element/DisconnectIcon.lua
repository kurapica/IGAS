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
	function DisconnectIcon(self)
		self.TexturePath = [[Interface\CharacterFrame\Disconnect-Icon]]
		self.Height = 16
		self.Width = 16
	end
endclass "DisconnectIcon"