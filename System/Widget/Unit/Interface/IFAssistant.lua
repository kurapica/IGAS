-- Author      : Kurapica
-- Create Date : 2012/08/06
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFAssistant
-- @type Interface
-- @name IFAssistant
-- @need property Boolean :	Visible
----------------------------------------------------------------------------------------------------------------------------------------

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

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFAssistantUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
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