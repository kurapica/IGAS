-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.DisconnectIcon", version) then
	return
end

class "DisconnectIcon"
	inherit "Texture"
	extend "IFConnect"

	doc [======[
		@name DisconnectIcon
		@type class
		@desc The disconnect indicator
	]======]

	------------------------------------------------------
	-- Event
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