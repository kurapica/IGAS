-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFResurrect
-- @type Interface
-- @name IFResurrect
-- @need property Boolean : Visible
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFResurrect", version) then
	return
end

_All = "all"
_IFResurrectUnitList = _IFResurrectUnitList or UnitList(_Name)

function _IFResurrectUnitList:OnUnitListChanged()
	self:RegisterEvent("INCOMING_RESURRECT_CHANGED")

	self.OnUnitListChanged = nil
end

function _IFResurrectUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFResurrect"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFResurrectUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		self.Visible = self.Unit and UnitHasIncomingResurrection(self.Unit)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFResurrect(self)
		_IFResurrectUnitList[self] = _All

		-- Default Texture
		if self:IsClass(Texture) then
			if not self.TexturePath and not self.Color then
				self.TexturePath = [[Interface\RaidFrame\Raid-Icon-Rez]]
			end
		end
	end
endinterface "IFResurrect"