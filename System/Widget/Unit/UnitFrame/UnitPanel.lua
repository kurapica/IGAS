-- Author      : Kurapica
-- Create Date : 2012/11/07
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.UnitPanel", version) then
	return
end

class "UnitPanel"
	inherit "SecureFrame"
	extend "IFGroup"

	doc [======[
		@name UnitPanel
		@type class
		@desc The unit panel for party or raid members
	]======]

	MAX_RAID_MEMBERS = _G.MAX_RAID_MEMBERS
	NUM_RAID_GROUPS = _G.NUM_RAID_GROUPS
	MEMBERS_PER_RAID_GROUP = _G.MEMBERS_PER_RAID_GROUP

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Refresh
		@type method
		@desc Refresh the unit panel
		@return nil
	]======]
	function Refresh(self)
		if not self.__Deactivated then
			return IFGroup.Refresh(self)
		end
	end

	doc [======[
		@name Activate
		@type method
		@desc Activate the unit panel
		@return nil
	]======]
	function Activate(self)
		if self.__Deactivated then
			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self.__Deactivated = nil
				return self:Refresh()
			end)
		end
	end

	doc [======[
		@name Deactivate
		@type method
		@desc Deactivate the unit panel
		@return nil
	]======]
	function Deactivate(self)
		if not self.__Deactivated then
			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self.__Deactivated = true

				for i = 1, self.Count do
					self.Element[i].Unit = nil
				end

				self:UpdatePanelSize()
			end)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Activated
		@type property
		@desc Whether the unit panel is activated
	]======]
	property "Activated" {
		Get = function(self)
			return not self.__Deactivated
		end,
		Set = function(self, value)
			if value then
				self:Activate()
			else
				self:Deactivate()
			end
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function UnitPanel(self)
		self.ElementType = UnitFrame	-- Default Element, need override

		self.RowCount = MEMBERS_PER_RAID_GROUP
		self.ColumnCount = NUM_RAID_GROUPS
		self.ElementWidth = 80
		self.ElementHeight = 32

		self.Orientation = Orientation.VERTICAL
		self.HSpacing = 2
		self.VSpacing = 2
		self.AutoSize = false		-- Since can't resize in combat, do it manually

		self.MarginTop = 0
		self.MarginBottom = 0
		self.MarginLeft = 0
		self.MarginRight = 0
    end
endclass "UnitPanel"