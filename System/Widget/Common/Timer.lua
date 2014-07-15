-- Author     : Kurapica
-- ChangreLog :
--              2010.01.13 Change the Timer's Parent to WorldFrame
--              2011/03/13 Recode as class
--              2014/07/08 Recode with System.Task

-- Check Version
local version = 12

if not IGAS:NewAddon("IGAS.Widget.Timer", version) then
	return
end

import "System.Task"

r_Started = false
r_TimerCount = 0
r_PreviousTime = 0

p_Start = nil
p_Work = nil

function Process()
	local now = GetTime()
	local percent = (now - r_PreviousTime) / 0.1
	if percent > 1 then percent = 1 end

	r_PreviousTime = now

	if r_Started then
		p_Work = p_Work or p_Start

		if p_Work then
			for i = 1, ceil( r_TimerCount * percent ) do
				if p_Work._AwakeTime <= now then
					p_Work._AwakeTime = GetTime() + p_Work.Interval

					p_Work:Fire("OnTimer")
				end
				p_Work = p_Work._Next
			end
		end

		return NextCall( Process )
	end
end

function QueueRing(self)
	if not self._Previous then
		if p_Start == nil then
			p_Start = self
			self._Previous = self
			self._Next = self
		else
			local tail = p_Start._Previous

			self._Previous = tail
			self._Next = p_Start

			tail._Next = self

			p_Start._Previous = self
		end

		r_TimerCount = r_TimerCount + 1

		if r_TimerCount == 1 then
			-- Start the process
			r_Started = true
			r_PreviousTime = GetTime()
			return NextCall( Process )
		end
	end
end

function UnqueueRing(self)
	if self._Previous then
		local prev = self._Previous
		local next = self._Next

		prev._Next = next
		next._Previous = prev

		if self == p_Start then p_Start = next end
		if self == p_Start then p_Start = nil end

		if self == p_Work then p_Work = next end
		if self == p_Work then p_Work = nil end

		self._Next = nil
		self._Previous = nil

		r_TimerCount = r_TimerCount - 1

		if r_TimerCount == 0 then r_Started = false end
	end
end

function RefreshTimer(self)
	if self.Interval > 0 and self.Enabled then
		self._AwakeTime = GetTime() + self.Interval
		return QueueRing(self)
	elseif p_Start == self or self._Previous then
		return UnqueueRing(self)
	end
end

__Doc__[[Timer is used to fire an event on a specified interval]]
class "Timer"
	inherit "VirtualUIObject"

	__StructType__(StructType.Custom)
	__Default__( 0 )
	struct "TimerInterval"
		function Validate(value)
			if type(value) ~= "number" or value < 0 then
				value = 0
			elseif value > 0 and value < 0.1 then
				value = 0.1
			end
			return value
		end
	endstruct "TimerInterval"

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	__Doc__[[Run when the timer is at the right time]]
	event "OnTimer"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[Gets or sets the interval at which to fire the Elapsed event]]
	__Handler__( RefreshTimer )
	property "Interval" { Type = TimerInterval }

	__Doc__[[Whether the timer is enabled or disabled, default true]]
	__Handler__( RefreshTimer )
	property "Enabled" { Type = Boolean, Default = true }

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	Dispose = UnqueueRing

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "Timer"