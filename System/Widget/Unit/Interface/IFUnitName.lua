-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFUnitName
-- @type Interface
-- @name IFUnitName
-- @need property String : Text
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFUnitName", version) then
	return
end

_All = "all"
_IFUnitNameUnitList = _IFUnitNameUnitList or UnitList(_Name)

_RAID_CLASS_COLORS = CopyTable(_G.RAID_CLASS_COLORS)

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

	local function TranslateColor(r, g, b)
		return r and ("\124cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255) or ""
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFUnitNameUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self.Unit then
			local name, server = UnitName(self.Unit)
			local cls = select(2, UnitClass(self.Unit))
			if (name and server and self.WithServerName and server ~= "") then
				name = name.."-"..server
			end
			if name then
				if self.UseSelectionColor then
					self.Text = TranslateColor(UnitSelectionColor(self.Unit)) .. name .. "|r"
					return
				elseif self.UseClassColor then
					if _RAID_CLASS_COLORS[cls] then
						self.Text = "|c".. _RAID_CLASS_COLORS[cls].colorStr .. name .. "|r"
						return
					end
				end
			end
			self.Text = name or ""
		else
			self.Text = ""
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- UseSelectionColor
	property "UseSelectionColor" {
		Get = function(self)
			return self.__UseSelectionColor
		end,
		Set = function(self, value)
			self.__UseSelectionColor = value
			self:Refresh()
		end,
		Type = System.Boolean,
	}
	-- UseClassColor
	property "UseClassColor" {
		Get = function(self)
			return self.__UseClassColor
		end,
		Set = function(self, value)
			self.__UseClassColor = value
			self:Refresh()
		end,
		Type = System.Boolean,
	}
	-- WithServerName
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
	-- Constructor
	------------------------------------------------------
	function IFUnitName(self)
		_IFUnitNameUnitList[self] = _All
	end
endinterface "IFUnitName"