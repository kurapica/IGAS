-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFUnitName", version) then
	return
end

_All = "all"
_IFUnitNameUnitList = _IFUnitNameUnitList or UnitList(_Name)

function _IFUnitNameUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_NAME_UPDATE")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	self.OnUnitListChanged = nil
end

function _IFUnitNameUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFUnitName"
	extend "IFUnitElement"

	doc [======[
		@name IFUnitName
		@type interface
		@desc IFUnitName is used to handle the unit name's update
		@overridable Text property, string, which used to receive the unit's name
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Refresh
		@type method
		@desc The default refresh method, overridable
		@return nil
	]======]
	function Refresh(self)
		if self.Unit then
			local name, server = UnitName(self.Unit)
			if (name and server and self.WithServerName and server ~= "") then
				name = name.."-"..server
			end
			self.Text = name or self.Unit
		else
			self.Text = ""
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name WithServerName
		@type property
		@desc Whether show the server name
	]======]
	property "WithServerName" {
		Get = function(self)
			return self.__WithServerName
		end,
		Set = function(self, value)
			self.__WithServerName = value
			self:Refresh()
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFUnitNameUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFUnitName(self)
		_IFUnitNameUnitList[self] = _All
	end
endinterface "IFUnitName"