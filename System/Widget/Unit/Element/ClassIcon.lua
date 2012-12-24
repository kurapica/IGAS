-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- ClassIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name ClassIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.ClassIcon", version) then
	return
end

class "ClassIcon"
	inherit "Texture"
	extend "IFUnitElement"

	CLASS_ICON_TCOORDS = CopyTable(_G.CLASS_ICON_TCOORDS)

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		local cls = self.UnitClass
		if cls then
			self.Alpha = 1
			self:SetTexCoord(unpack(CLASS_ICON_TCOORDS[cls]))
		else
			self.Alpha = 0
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ClassIcon(self)
		self.TexturePath = [[Interface\TargetingFrame\UI-Classes-Circles]]
		self.Height = 16
		self.Width = 16
	end
endclass "ClassIcon"