-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFRaidTarget
-- @type Interface
-- @name IFRaidTarget
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFRaidTarget", version) then
	return
end

_All = "all"
_IFRaidTargetUnitList = _IFRaidTargetUnitList or UnitList(_Name)

function _IFRaidTargetUnitList:OnUnitListChanged()
	self:RegisterEvent("RAID_TARGET_UPDATE")

	self.OnUnitListChanged = nil
end

function _IFRaidTargetUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFRaidTarget"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFRaidTargetUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self:IsClass(Texture) then
			local index = self.Unit and GetRaidTargetIndex(self.Unit)

			if index then
				SetRaidTargetIconTexture(self, index)
				self.Visible = true
			else
				self.Visible = false
			end
		end
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
	function IFRaidTarget(self)
		_IFRaidTargetUnitList[self] = _All

		-- Default Texture
		if self:IsClass(Texture) then
			if not self.TexturePath and not self.Color then
				self.TexturePath = [[Interface\TargetingFrame\UI-RaidTargetingIcons]]
			end
		end
	end
endinterface "IFRaidTarget"