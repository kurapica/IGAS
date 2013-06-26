-- Author      : Kurapica
-- Create Date : 2012/07/29
-- Change Log  :

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

	doc [======[
		@name IFCast
		@type interface
		@desc IFCast is used to handle the unit's spell casting
		@overridable Start method, be called when unit begins casting a spell
		@overridable Fail method, be called when unit's spell casting failed
		@overridable Stop method, be called when the unit stop or cancel the spell casting
		@overridable Interrupt method, be called when the unit's spell casting is interrupted
		@overridable Interruptible, method, be called when the unit's spell casting becomes interruptible
		@overridable UnInterruptible, method, be called when the unit's spell casting become uninterruptible
		@overridable Delay, method, be called when the unit's spell casting is delayed
		@overridable ChannelStart, method, be called when the unit start channeling a spell
		@overridable ChannelUpdate, method, be called when the unit's channeling spell is interrupted or delayed
		@overridable ChannelStop, method, be called when the unit stop or cancel the channeling spell
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

	doc [======[
		@name Start
		@type method
		@desc Be called when unit begins casting a spell
		@param spell string, the name of the spell that's being casted
		@param rank string, the rank of the spell that's being casted
		@param lineID number, spell lineID counter
		@param spellID number, the id of the spell that's being casted
		@return nil
	]======]
	function Start(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Start][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	doc [======[
		@name Fail
		@type method
		@desc Be called when unit's spell casting failed
		@param spell string, the name of the spell that's being casted
		@param rank string, the rank of the spell that's being casted
		@param lineID number, spell lineID counter
		@param spellID number, the id of the spell that's being casted
		@return nil
	]======]
	function Fail(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Fail][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	doc [======[
		@name Stop
		@type method
		@desc Be called when the unit stop or cancel the spell casting
		@param spell string, the name of the spell that's being casted
		@param rank string, the rank of the spell that's being casted
		@param lineID number, spell lineID counter
		@param spellID number, the id of the spell that's being casted
		@return nil
	]======]
	function Stop(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Stop][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	doc [======[
		@name Interrupt
		@type method
		@desc Be called when the unit's spell casting is interrupted
		@param spell string, the name of the spell that's being casted
		@param rank string, the rank of the spell that's being casted
		@param lineID number, spell lineID counter
		@param spellID number, the id of the spell that's being casted
		@return nil
	]======]
	function Interrupt(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Interrupt][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	doc [======[
		@name Interruptible
		@type method
		@desc Be called when the unit's spell casting becomes interruptible
		@return nil
	]======]
	function Interruptible(self)
		Log(1, "[%s][Interruptible]", tostring(self:GetClass()))
	end

	doc [======[
		@name UnInterruptible
		@type method
		@desc Be called when the unit's spell casting become uninterruptible
		@return nil
	]======]
	function UnInterruptible(self)
		Log(1, "[%s][UnInterruptible]", tostring(self:GetClass()))
	end

	doc [======[
		@name Delay
		@type method
		@desc Be called when the unit's spell casting is delayed
		@param spell string, the name of the spell that's being casted
		@param rank string, the rank of the spell that's being casted
		@param lineID number, spell lineID counter
		@param spellID number, the id of the spell that's being casted
		@return nil
	]======]
	function Delay(self, spell, rank, lineID, spellID)
		Log(1, "[%s][Delay][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	doc [======[
		@name ChannelStart
		@type method
		@desc Be called when the unit start channeling a spell
		@param spell string, the name of the spell that's being casted
		@param rank string, the rank of the spell that's being casted
		@param lineID number, spell lineID counter
		@param spellID number, the id of the spell that's being casted
		@return nil
	]======]
	function ChannelStart(self, spell, rank, lineID, spellID)
		Log(1, "[%s][ChannelStart][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	doc [======[
		@name ChannelUpdate
		@type method
		@desc Be called when the unit's channeling spell is interrupted or delayed
		@param spell string, the name of the spell that's being casted
		@param rank string, the rank of the spell that's being casted
		@param lineID number, spell lineID counter
		@param spellID number, the id of the spell that's being casted
		@return nil
	]======]
	function ChannelUpdate(self, spell, rank, lineID, spellID)
		Log(1, "[%s][ChannelUpdate][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	doc [======[
		@name ChannelStop
		@type method
		@desc Be called when the unit stop or cancel the channeling spell
		@param spell string, the name of the spell that's being casted
		@param rank string, the rank of the spell that's being casted
		@param lineID number, spell lineID counter
		@param spellID number, the id of the spell that's being casted
		@return nil
	]======]
	function ChannelStop(self, spell, rank, lineID, spellID)
		Log(1, "[%s][ChannelStop][%s][%s][%d][%d]", tostring(self:GetClass()), spell, rank, lineID, spellID)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnUnitChanged(self)
		_IFCastUnitList[self] = self.Unit
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFCastUnitList[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFCast(self)
		self.OnUnitChanged = self.OnUnitChanged + OnUnitChanged
	end
endinterface "IFCast"