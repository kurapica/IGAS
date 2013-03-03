-- Author      : Kurapica
-- Create Date : 2012/07/22
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFTotem", version) then
	return
end

MAX_TOTEMS = _G.MAX_TOTEMS

PRIORITIES = CopyTable(_G.STANDARD_TOTEM_PRIORITIES)

if(select(2, UnitClass'player') == 'SHAMAN') then
	PRIORITIES = CopyTable(_G.SHAMAN_TOTEM_PRIORITIES)
end

SLOT_MAP = {}

for slot, index in ipairs(PRIORITIES) do
	SLOT_MAP[index] = slot
end

_All = "all"
_IFTotemUnitList = _IFTotemUnitList or UnitList(_Name)

function _IFTotemUnitList:OnUnitListChanged()
	self:RegisterEvent("PLAYER_TOTEM_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")	-- won't update if leave instance.

	self.OnUnitListChanged = nil
end

function _IFTotemUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFTotem"
	extend "IFUnitElement"

	doc [======[
		@name IFTotem
		@type interface
		@desc IFTotem is used to handle the unit's totem updating
		@usage For default, the object need contains MAX_TOTEMS elements, these elements should extend from System.Widget.IFCooldown, and with several properties:
		<br><br>Icon property, string, used to receive the totem's image file path
		<br><br>Slot property, number, used to receive the totem's slot index
		<br><br>Visible property, boolean, used to receive the check result for whether should show the totem
	]======]

	MAX_TOTEMS = MAX_TOTEMS

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
		local btn

		for i = 1, MAX_TOTEMS do
			btn = self[i]

			if btn and SLOT_MAP[i] then
				local haveTotem, name, start, duration, icon = GetTotemInfo(SLOT_MAP[i])

				if haveTotem and duration > 0 then
					btn.Icon = icon
					btn.Slot = SLOT_MAP[i]
					btn:OnCooldownUpdate(start, duration)

					btn.Visible = true
				else
					btn:OnCooldownUpdate()
					btn.Visible = false
				end
			else
				btn:OnCooldownUpdate()
				btn.Visible = false
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
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFTotemUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFTotem(self)
		_IFTotemUnitList[self] = _All
	end
endinterface "IFTotem"