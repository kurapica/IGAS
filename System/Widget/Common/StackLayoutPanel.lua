-- Author      : Kurapica
-- Create Date : 2012/09/07
-- ChangeLog

local version = 1
if not IGAS:NewAddon("IGAS.Widget.StackLayoutPanel", version) then
	return
end

class "StackLayoutPanel"
	inherit "LayoutPanel"

	doc [======[
		@name StackLayoutPanel
		@type class
		@desc Auto stack elements into the layout panel
	]======]

	------------------------------------------------------
	-- Event
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
endclass "StackLayoutPanel"