-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- RaidRosterIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name RaidRosterIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.RaidRosterIcon", version) then
	return
end

class "RaidRosterIcon"
	inherit "Texture"
	extend "IFRaidRoster"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if IsInRaid() and self.Unit and not UnitHasVehicleUI(self.Unit) then
			if GetPartyAssignment('MAINTANK', self.Unit) then
				self.Visible = true
				self.TexturePath = [[Interface\GROUPFRAME\UI-GROUP-MAINTANKICON]]
			elseif GetPartyAssignment('MAINASSIST', self.Unit) then
				self.Visible = true
				self.TexturePath = [[Interface\GROUPFRAME\UI-GROUP-MAINASSISTICON]]
			else
				self.Visible = false
			end
		else
			self.Visible = false
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function RaidRosterIcon(self)
		self.Height = 16
		self.Width = 16
	end
endclass "RaidRosterIcon"