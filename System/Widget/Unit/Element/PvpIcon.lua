-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- PvpIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name PvpIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.PvpIcon", version) then
	return
end

class "PvpIcon"
	inherit "Texture"
	extend "IFFaction"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self.IsPVPFreeForAll then
			self.TexturePath = [[Interface\TargetingFrame\UI-PVP-FFA]]
			self.Visible = true
		elseif self.IsPVP and self.Faction then
			self.TexturePath = [[Interface\TargetingFrame\UI-PVP-]]..self.Faction
			self.Visible = true
		else
			self.Visible = false
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function PvpIcon(self)
		self.Height = 64
		self.Width = 64
	end
endclass "PvpIcon"