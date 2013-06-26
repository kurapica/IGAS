-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

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

	doc [======[
		@name IFResting
		@type interface
		@desc IFResting is used to handle the unit resting state's updating
		@overridable Visible property, boolean, used to receive the result that whether the resting indicator should be shown
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
		self.Visible = self.Unit == "player" and IsResting()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
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
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFRestingUnitList[self] = nil
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