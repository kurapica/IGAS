-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- PhaseIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name PhaseIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.PhaseIcon", version) then
	return
end

class "PhaseIcon"
	inherit "Texture"
	extend "IFPhase"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Refresh(self)
		self.Visible = not UnitInPhase(self.Unit)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function PhaseIcon(self)
		self.TexturePath = [[Interface\TargetingFrame\UI-PhasingIcon]]

		self.Height = 16
		self.Width = 16
	end
endclass "PhaseIcon"