-- Author      : Kurapica
-- Create Date : 2012/11/07
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.UnitPanel", version) then
	return
end

-----------------------------------------------
--- UnitPanel
-- @type class
-- @name UnitPanel
-----------------------------------------------
class "UnitPanel"
	inherit "SecureFrame"
	extend "IFElementPanel" "IFGroup"

	MAX_RAID_MEMBERS = _G.MAX_RAID_MEMBERS
	NUM_RAID_GROUPS = _G.NUM_RAID_GROUPS
	MEMBERS_PER_RAID_GROUP = _G.MEMBERS_PER_RAID_GROUP

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function UnitPanel(...)
		local obj = Super(...)

		-- Make sure obj can use methodes & properties now
		obj:ConvertClass(UnitPanel)

		obj.ElementType = UnitFrame	-- Default Element, need override

		obj.RowCount = MEMBERS_PER_RAID_GROUP
		obj.ColumnCount = NUM_RAID_GROUPS
		obj.ElementWidth = 80
		obj.ElementHeight = 32

		obj.Orientation = Orientation.VERTICAL
		obj.HSpacing = 2
		obj.VSpacing = 2
		obj.AutoSize = false		-- Since can't resize in combat, do it manually

		obj.MarginTop = 0
		obj.MarginBottom = 0
		obj.MarginLeft = 0
		obj.MarginRight = 0

		return obj
    end
endclass "UnitPanel"