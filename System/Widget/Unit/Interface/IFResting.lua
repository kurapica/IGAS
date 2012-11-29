-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFResting
-- @type Interface
-- @name IFResting
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFResting", version) then
	return
end

_IFRestingUnitList = _IFRestingUnitList or UnitList(_Name)

function _IFRestingUnitList:OnUnitListChanged()
	self:RegisterEvent("PLAYER_UPDATE_RESTING")

	self.OnUnitListChanged = nil
end

function _IFRestingUnitList:ParseEvent(event)
	self:EachK("player", "Refresh")
end

interface "IFResting"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFRestingUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		self.Visible = self.Unit == "player" and IsResting()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		if self.Unit == "player" then
			_IFRestingUnitList[self] = self.Unit
		else
			_IFRestingUnitList[self] = nil
			self.Visible = false
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFResting(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged

		-- Default Texture
		if self:IsClass(Texture) then
			if not self.TexturePath and not self.Color then
				self.TexturePath = [[Interface\CharacterFrame\UI-StateIcon]]
				self:SetTexCoord(0, .5, 0, .421875)
			end
		end
	end
endinterface "IFResting"