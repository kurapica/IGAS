-- Author      : Kurapica
-- Create Date : 2012/09/07
-- ChangeLog

----------------------------------------------------------------------------------------------------------------------------------------
--- StackLayoutPanel
-- <br><br>inherit <a href=".\LayoutPanel.html">StackLayoutPanel</a> For all methods, properties and scriptTypes
-- @name StackLayoutPanel
----------------------------------------------------------------------------------------------------------------------------------------

local version = 1
if not IGAS:NewAddon("IGAS.Widget.StackLayoutPanel", version) then
	return
end

-----------------------------------------------
--- StackLayoutPanel
-- @type class
-- @name StackLayoutPanel
-----------------------------------------------
class "StackLayoutPanel"
	inherit "LayoutPanel"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------
	--- Add Widget to the panel
	-- @name LayoutPanel:AddWidget
	-- @class function
	-- @param widget
	-- @return index
	------------------------------------
	function AddWidget(self, widget)
	end

	------------------------------------
	--- Insert Widget to the panel
	-- @name LayoutPanel:InsertWidget
	-- @class function
	-- @param before the index to be insert
	-- @param widget
	------------------------------------
	function InsertWidget(self, before, widget)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function StackLayoutPanel(name, parent)
		local panel = Super(name, parent)

		return panel
    end
endclass "StackLayoutPanel"