-- Author      : Kurapica
-- Create Date : 2012/08/03
-- ChangeLog

----------------------------------------------------------------------------------------------------------------------------------------
--- ElementPanel
-- <br><br>inherit <a href="..\Base\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name ElementPanel
----------------------------------------------------------------------------------------------------------------------------------------

local version = 2
if not IGAS:NewAddon("IGAS.Widget.ElementPanel", version) then
	return
end

class "ElementPanel"
	inherit "Frame"
	extend "IFElementPanel"

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ElementPanel(name, parent, ...)
		local panel = Super(name, parent, ...)

		return panel
	end
endclass "ElementPanel"