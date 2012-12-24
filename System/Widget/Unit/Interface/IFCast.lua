-- Author      : Kurapica
-- Create Date : 2012/07/29
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFCast
-- @type Interface
-- @name IFCast
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFCast", version) then
	return
end

_IFCastUnitList = _IFCastUnitList or UnitList(_Name)

function _IFCastUnitList:OnUnitListChanged()
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
	self:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
	self:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

	self.OnUnitListChanged = nil
end

_IFCast_EVENT_HANDLER = {
	UNIT_SPELLCAST_START = "Start",
	UNIT_SPELLCAST_FAILED = "Fail",
	UNIT_SPELLCAST_STOP = "Stop",
	UNIT_SPELLCAST_INTERRUPTED = "Interrupt",
	UNIT_SPELLCAST_INTERRUPTIBLE = "Interruptible",
	UNIT_SPELLCAST_NOT_INTERRUPTIBLE = "UnInterruptible",
	UNIT_SPELLCAST_DELAYED = "Delay",
	UNIT_SPELLCAST_CHANNEL_START = "ChannelStart",
	UNIT_SPELLCAST_CHANNEL_UPDATE = "ChannelUpdate",
	UNIT_SPELLCAST_CHANNEL_STOP = "ChannelStop",
}

function _IFCastUnitList:ParseEvent(event, unit, ...)
	self:EachK(unit, _IFCast_EVENT_HANDLER[event], ...)
end

interface "IFCast"
	extend "IFUnitElement"

	_IFCastUnitList = _IFCastUnitList

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		_IFCastUnitList[self] = nil
	end

	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if self.Unit then
			if UnitCastingInfo(self.Unit) then
				local name, subText, _, _, _, _, _, castID, notInterruptible = UnitCastingInfo(self.Unit)
				self:Start(name, subText, castID)
				return
			elseif UnitChannelInfo(self.Unit) then
				return self:ChannelStart()
			else
				return self:Stop()
			end
		else
			return self:Stop()
		end
	end

	------------------------------------
	--- Fires when unit begins casting a spell
	-- @name Start
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Start(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Start][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	------------------------------------
	--- Fires when unit's spell cast fails
	-- @name Fail
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Fail(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Fail][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	------------------------------------
	--- Fires when unit stops or cancels casting a spell
	-- @name Stop
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Stop(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Stop][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	------------------------------------
	--- Fires when unit's spell cast is interrupted
	-- @name Interrupt
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Interrupt(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Interrupt][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	------------------------------------
	--- Fires when unit's spell cast becomes interruptible again
	-- @name Interruptible
	-- @type function
	------------------------------------
	function Interruptible(self)
		Log(1, "[%s][Interruptible]", tostring(self:GetClass()))
	end

	------------------------------------
	--- Fires when unit's spell cast becomes uninterruptible
	-- @name UnInterruptible
	-- @type function
	------------------------------------
	function UnInterruptible(self)
		Log(1, "[%s][UnInterruptible]", tostring(self:GetClass()))
	end

	------------------------------------
	--- Fires when unit's spell cast is delayed
	-- @name Interrupt
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Delay(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Delay][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	------------------------------------
	--- Fires when unit starts channeling a spell
	-- @name ChannelStart
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function ChannelStart(self, spell, rank, lineID, spellID)
		Log(1, "[%s][ChannelStart][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	------------------------------------
	--- Fires when unit's channeled spell is interrupted or delayed
	-- @name ChannelUpdate
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function ChannelUpdate(self, spell, rank, lineID, spellID)
		Log(1, "[%s][ChannelUpdate][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	------------------------------------
	--- Fires when unit stops or cancels a channeled spell
	-- @name ChannelStop
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function ChannelStop(self, spell, rank, lineID, spellID)
		Log(1, "[%s][ChannelStop][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFCastUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFCast(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
	end
endinterface "IFCast"