-- Author      : Kurapica
-- Create Date : 2012/07/22
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFTotem
-- @type Interface
-- @name IFTotem
-- @need property Boolean : Visible
-- @need property String : Icon
----------------------------------------------------------------------------------------------------------------------------------------

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

	MAX_TOTEMS = MAX_TOTEMS

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFTotemUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
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
	-- Constructor
	------------------------------------------------------
	function IFTotem(self)
		_IFTotemUnitList[self] = _All
	end
endinterface "IFTotem"