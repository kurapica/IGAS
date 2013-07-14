-- Author      : Kurapica
-- Create Date : 2013/02/03
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFPetGroup", version) then
	return
end

_All = "all"
_IFPetGroupUnitList = _IFPetGroupUnitList or UnitList(_Name)

_IFPetGroup_Deactivated = _IFPetGroup_Deactivated or {}

function _IFPetGroupUnitList:OnUnitListChanged()
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self.OnUnitListChanged = nil
end

function _IFPetGroupUnitList:ParseEvent(event)
	IFNoCombatTaskHandler._RegisterNoCombatTask(RefreshAll)
end

function RefreshAll()
	for _, panel in _IFPetGroupUnitList(_All) do
		if not _IFPetGroup_Deactivated[panel] then
			panel:Refresh()
		end
	end
end

-------------------------------------
-- Helper functions
-------------------------------------
do
	function GetGroupType(self)
		local kind, start, stop

		local nRaid = GetNumGroupMembers()
		local nParty = GetNumSubgroupMembers()

		if IsInRaid() and self.ShowRaid then
			kind = "RAID"
		elseif IsInGroup() and self.ShowParty then
			kind = "PARTY"
		elseif nRaid == 0 and nParty == 0 and self.ShowSolo then
			kind = "SOLO"
		end

		if kind then
			if kind == "RAID" then
				start = 1
				stop = nRaid
			else
				if kind	== "SOLO" or self.ShowPlayer then
					start = 0
				else
					start = 1
				end
				if kind == "PARTY" then
					stop = nParty
				else
					stop = 0
				end

			end
		end

		return kind, start, stop
	end

	function GetPetUnit(kind, index)
		if ( kind == "RAID" ) then
			return "raidpet"..index
		elseif ( index > 0 ) then
			return "partypet"..index
		else
			return "pet"
		end
	end
end

interface "IFPetGroup"
	extend "IFElementPanel"

	doc [======[
		@name IFPetGroup
		@type interface
		@desc IFPetGroup is used to handle the pet group's updating
	]======]

	------------------------------------------------------
	-- Helper functions
	------------------------------------------------------
	local function SecureSetAttribute(self, attr, value)
		IFNoCombatTaskHandler._RegisterNoCombatTask(self.SetAttribute, self, attr, value)
	end

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
		local kind, start, stop	 = GetGroupType(self)
		local index = 1
		local unit

		if kind and start and stop then
			for i = start, stop do
				unit = GetPetUnit(kind, i)

				if UnitExists(unit) then
					self.Element[index].Unit = unit

					index = index + 1
				end
			end
		end

		for i = index, self.Count do
			self.Element[i].Unit = nil
		end

		self:UpdatePanelSize()
	end

	doc [======[
		@name Activate
		@type method
		@desc Activate the unit panel
		@return nil
	]======]
	function Activate(self)
		if _IFPetGroup_Deactivated[self] then
			_IFPetGroup_Deactivated[self] = nil

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				return self:Refresh()
			end)
		end
	end

	doc [======[
		@name Deactivate
		@type method
		@desc Deactivate the unit panel
		@return nil
	]======]
	function Deactivate(self)
		if not _IFPetGroup_Deactivated[self] then
			_IFPetGroup_Deactivated[self] = true

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				for i = 1, self.Count do
					self.Element[i].Unit = nil
				end

				self:UpdatePanelSize()
			end)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Activated
		@type property
		@desc Whether the unit panel is activated
	]======]
	property "Activated" {
		Get = function(self)
			return not _IFPetGroup_Deactivated[self]
		end,
		Set = function(self, value)
			if value then
				self:Activate()
			else
				self:Deactivate()
			end
		end,
		Type = Boolean,
	}

	doc [======[
		@name ShowRaid
		@type property
		@desc Whether the panel should be shown while in a raid
	]======]
	property "ShowRaid" {
		Get = function(self)
			return self:GetAttribute("showRaid") or false
		end,
		Set = function(self, value)
			SecureSetAttribute(self, "showRaid", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name ShowParty
		@type property
		@desc Whether the panel should be shown while in a party and not in a raid
	]======]
	property "ShowParty" {
		Get = function(self)
			return self:GetAttribute("showParty") or false
		end,
		Set = function(self, value)
			SecureSetAttribute(self, "showParty", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name ShowPlayer
		@type property
		@desc Whether the panel should show the player while not in a raid
	]======]
	property "ShowPlayer" {
		Get = function(self)
			return self:GetAttribute("showPlayer") or false
		end,
		Set = function(self, value)
			SecureSetAttribute(self, "showPlayer", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name ShowSolo
		@type property
		@desc Whether the panel should be shown while not in a group
	]======]
	property "ShowSolo" {
		Get = function(self)
			return self:GetAttribute("showSolo") or false
		end,
		Set = function(self, value)
			SecureSetAttribute(self, "showSolo", value)
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFPetGroupUnitList[self] = nil
		_IFPetGroup_Deactivated[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFPetGroup(self)
		_IFPetGroupUnitList[self] = _All
	end
endinterface "IFPetGroup"