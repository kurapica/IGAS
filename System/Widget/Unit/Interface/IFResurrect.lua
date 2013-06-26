-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

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

	doc [======[
		@name IFResurrect
		@type interface
		@desc IFResurrect is used to handle the unit resurrection state's updating
		@overridable Visible property, boolean, used to receive the result that whether the resurrection indicator should be shown
	]======]

	------------------------------------------------------
	-- Event
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
		self.Visible = self.Unit and UnitHasIncomingResurrection(self.Unit)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFResurrectUnitList[self] = nil
	end

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