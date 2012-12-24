-- Author      : Kurapica
-- Create Date : 2012/07/12
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFGroupLoot
-- @type Interface
-- @name IFGroupLoot
-- @need property Boolean : Visible
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.IFGroupLoot", version) then
	return
end

_All = "all"
_IFGroupLootUnitList = _IFGroupLootUnitList or UnitList(_Name)

function _IFGroupLootUnitList:OnUnitListChanged()
	self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")

	self.OnUnitListChanged = nil
end

function _IFGroupLootUnitList:ParseEvent(event)
	self:EachK(_All, "Refresh")
end

interface "IFGroupLoot"
	extend "IFUnitElement"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFGroupLootUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self.InParty or self.InRaid then
			local method, pid, rid = GetLootMethod()

			if(method == 'master') then
				local mlUnit
				if(pid) then
					if(pid == 0) then
						mlUnit = 'player'
					else
						mlUnit = 'party'..pid
					end
				elseif(rid) then
					mlUnit = 'raid'..rid
				end

				self.Visible = UnitIsUnit(self.Unit, mlUnit)
			else
				self.Visible = false
			end
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

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFGroupLoot(self)
		_IFGroupLootUnitList[self] = _All

		-- Default Texture
		if self:IsClass(Texture) then
			if not self.TexturePath and not self.Color then
				self.TexturePath = [[Interface\GroupFrame\UI-Group-MasterLooter]]
			end
		end
	end
endinterface "IFGroupLoot"