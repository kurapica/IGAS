-- Author      : Kurapica
-- Create Date : 2012/08/06
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFAssistant", version) then
	return
end

_All = "all"
_IFAssistantUnitList = _IFAssistantUnitList or UnitList(_Name)

function _IFAssistantUnitList:OnUnitListChanged()
	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	self.OnUnitListChanged = nil
end

function _IFAssistantUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFAssistant"
	extend "IFUnitElement"

	doc [======[
		@name IFAssistant
		@type interface
		@desc IFAssistant is used to check whether the unit is the assistant in the group
		@overridable Visible property, boolean, which used to receive the check result
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
		self.Visible = self.IsGroupAssistant
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFAssistantUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFAssistant(self)
		_IFAssistantUnitList[self] = _All

		-- Default Texture
		if self:IsClass(Texture) then
			if not self.TexturePath and not self.Color then
				self.TexturePath = [[Interface\GroupFrame\UI-Group-AssistantIcon]]
			end
		end
	end
endinterface "IFAssistant"