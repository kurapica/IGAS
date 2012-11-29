-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFFaction
-- @type Interface
-- @name IFFaction
-- @need property String : TexturePath
-- @need property Boolean : Visible
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFFaction", version) then
	return
end

_IFFactionUnitList = _IFFactionUnitList or UnitList(_Name)

function _IFFactionUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_FACTION")

	self.OnUnitListChanged = nil
end

interface "IFFaction"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFFactionUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self.IsPVPFreeForAll then
			self.TexturePath = [[Interface\TargetingFrame\UI-PVP-FFA]]
			self.Visible = true
		elseif self.IsPVP and self.Faction then
			self.TexturePath = [[Interface\TargetingFrame\UI-PVP-]]..self.Faction
			self.Visible = true
		else
			self.Visible = false
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFFactionUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFFaction(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
	end
endinterface "IFFaction"