------------------------------------------------------
-- Author : kurapica.igas@gmail.com
-- Create Date 	: 2012/06/28
-- ChangeLog

------------------------------------------------------
local version = 6

if not IGAS:NewAddon("IGAS.Widget.Unit", version) then
	return
end

------------------------------------------------------
-- Header for System.Widget.Unit.*
------------------------------------------------------
import "System"
import "System.Widget"

namespace "System.Widget.Unit"

_ClassPowerMap = {
	[0] = "MANA",
	[1] = "RAGE",
	[2] = "FOCUS",
	[3] = "ENERGY",
	[4] = "NOUSE",
	[5] = "RUNES",
	[6] = "RUNIC_POWER",
	[7] = "SOUL_SHARDS",
	[8] = "ECLIPSE",
	[9] = "HOLY_POWER",
	[10] = "ALTERNATE_POWER",
	[11] = "DARK_FORCE",
	[12] = "CHI",
	[13] = "SHADOW_ORBS",
	[14] = "BURNING_EMBERS",
	[15] = "DEMONIC_FURY",
}

for i, v in ipairs(_ClassPowerMap) do
	_ClassPowerMap[v] = i
end

PowerBarColor = CopyTable(_G.PowerBarColor)

PowerBarColor["MANA"] = ColorType(0.0, 0.6, 1)
PowerBarColor[_G.SPELL_POWER_MANA] = ColorType(0.0, 0.6, 1)

class "UnitList"
	extend "IFIterator"

	doc [======[
		@name UnitList
		@type class
		@desc UnitList is used to contain ui elements that with the same unit for some special using
	]======]

	------------------------------------------------------
	-- Event Manager
	------------------------------------------------------
	_UnitListEventDistribution = _UnitListEventDistribution or {}
	_UnitListEventManager = _UnitListEventManager or CreateFrame("Frame")
	_UnitListEventManager:Hide()
	_UnitListEventManager:SetScript("OnEvent", function(self, event, ...)
		for _, lst in ipairs(_UnitListEventDistribution[event]) do
			lst:ParseEvent(event, ...)
		end
	end)

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnUnitListChanged
		@type event
		@desc Fired when the unit list's elements is added or removed
	]======]
	event "OnUnitListChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name ParseEvent
		@type method
		@desc Parse event, Overridable
		@param event the event's name
		@param ... the arguments
		@return nil
	]======]
	function ParseEvent(self, event, unit, ...)
		if self:HasUnit(unit) then
			return self:EachK(unit, "Refresh", ...)
		end
	end

	doc [======[
		@name RegisterEvent
		@type method
		@desc Register an event
		@param event string, the event name
		@return nil
	]======]
	function RegisterEvent(self, event)
		_UnitListEventManager:RegisterEvent(event)
		_UnitListEventDistribution[event] = _UnitListEventDistribution[event] or {}
		for i, lst in ipairs(_UnitListEventDistribution[event]) do
			if lst == self then
				return
			end
		end
		tinsert(_UnitListEventDistribution[event], self)
	end

	doc [======[
		@name UnregisterEvent
		@type method
		@desc Undo register an event
		@param event string, the event name
		@return nil
	]======]
	function UnregisterEvent(self, event)
		_UnitListEventDistribution[event] = _UnitListEventDistribution[event] or {}

		for i, lst in ipairs(_UnitListEventDistribution[event]) do
			if lst == self then
				tremove(_UnitListEventDistribution[event], i)
				if #_UnitListEventDistribution[event] == 0 then
					_UnitListEventManager:UnregisterEvent(event)
					break
				end
			end
		end
	end

	function Next(self, key)
		return _UnitList_Traverse[self], self, type(key) == "string" and key:lower() or nil
	end

	doc [======[
		@name HasUnit
		@type method
		@desc Check if UnitList contains items with the unit
		@param unit
		@return boolean
	]======]
	function HasUnit(self, unit)
		unit = type(unit) == "string" and unit:lower() or nil

		if unit and rawget(self, unit) then
			return true
		else
			return false
		end
	end

	_UnitList_Info = _UnitList_Info or {}
	_UnitList_Prev = _UnitList_Prev or {}
	_UnitList_Next = _UnitList_Next or {}
	_UnitList_Traverse = _UnitList_Traverse or {}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function UnitList(self, name)
		if type(name) ~= "string" then
			error("Usage : UnitList(name) - name must be a unique string.", 2)
		end

		local prev = "__UnitList_" .. name .. "_Prev"
		local nxt = "__UnitList_" .. name .. "_Next"

		_UnitList_Info[name] = self
		_UnitList_Prev[self] = prev
		_UnitList_Next[self] = nxt
		_UnitList_Traverse[self] = function (data, key)
			if type(key) == "string" and not key:match("^_") and type(data[key]) == "table" then
				return data[key], data[key]
			elseif type(key) == "table" then
				return key[nxt], key[nxt]
			end
		end
	end

	------------------------------------------------------
	-- __exist
	------------------------------------------------------
	function __exist(name)
		if type(name) == "string" and _UnitList_Info[name] then
			return _UnitList_Info[name]
		end
	end

	------------------------------------------------------
	-- MetaMethod
	------------------------------------------------------
	function __index(self, unit)
		if type(unit) == "string" then
			return rawget(self, unit:lower())
		end
	end

	function __newindex(self, frame, unit)
		if type(frame) == "string" and type(unit) == "function" then
			rawset(self, frame, unit)
			return
		end

		if type(frame) ~= "table" then
			error("key must be a table.", 2)
		end

		if unit ~= nil and ( type(unit) ~= "string" or unit:match("^__") ) then
			error("value not supported.", 2)
		end

		unit = unit and unit:lower()

		if UnitList[unit] then
			error("value not supported.", 2)
		end

		local preKey = _UnitList_Prev[self]
		local nxtKey = _UnitList_Next[self]

		local prev = frame[preKey]
		local next = frame[nxtKey]
		local header = prev

		while type(header) == "table" do
			header = header[preKey]
		end

		-- no change
		if header == unit then
			return
		end

		-- Remove link
		if header then
			if prev == header then
				rawset(self, header, next)
				if next then next[preKey] = prev end
			else
				prev[nxtKey] = next
				if next then next[preKey] = prev end
			end

			frame[preKey] = nil
			frame[nxtKey] = nil
		end

		-- Add link
		if unit then
			local tail = self[unit]

			rawset(self, unit, frame)
			frame[preKey] = unit

			if tail then
				tail[preKey] = frame
				frame[nxtKey] = tail
			end
		end

		Object.Fire(self, "OnUnitListChanged")
	end

	function __call(self, unit)
		return _UnitList_Traverse[self], self, type(unit) == "string" and unit:lower() or nil
	end
endclass "UnitList"