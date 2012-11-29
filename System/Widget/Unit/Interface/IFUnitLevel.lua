-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFUnitLevel
-- @type Interface
-- @name IFUnitLevel
-- @need property String : Text
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFUnitLevel", version) then
	return
end

_IFUnitLevelUnitList = _IFUnitLevelUnitList or UnitList(_Name)

_All = "all"

function _IFUnitLevelUnitList:OnUnitListChanged()
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	self.OnUnitListChanged = nil
end

function _IFUnitLevelUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFUnitLevel"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFUnitLevelUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self.Unit then
			local lvl = UnitLevel(self.Unit)

			if lvl and lvl > 0 then
				self.Text = self.FormatLevel:format(lvl)
			else
				self.Text = self.FormatLevel:format("???")
			end
		else
			self.Text = ""
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- FormatLevel
	property "FormatLevel" {
		Get = function(self)
			return self.__FormatLevel or "Lv.%s"
		end,
		Set = function(self, value)
			self.__FormatLevel = value
		end,
		Type = System.String,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFUnitLevel(self)
		_IFUnitLevelUnitList[self] = _All
	end
endinterface "IFUnitLevel"