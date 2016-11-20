 -- Author      : Kurapica
-- Create Date  : 2013/08/13
-- ChangeLog    :
--                2014/07/07 Recode with System.Task for older version

Module "System.Threading" "99.0.0"

namespace "System"

------------------------------------------------------
-- System.Threading
------------------------------------------------------
__Doc__[[
	<desc>Make current thread sleep for a while</desc>
	<param name="delay" type="number">the sleep time for current thread</param>
	<usage>System.Threading.Sleep(10)</usage>
]]
Threading.Sleep = Task.Delay

__Doc__[[
	<desc>Make current thread sleeping until event triggered</desc>
	<param name="event">the event name</param>
	<usage>System.Threading.WaitEvent(event)</usage>
]]
Threading.WaitEvent = Task.Event

__Doc__[[
	<desc>Make current thread sleeping until event triggered or meet the timeline</desc>
	<param name="delay">number, the waiting time's deadline</param>
	<param name="...">the event list</param>
	<usage>System.Threading.Wait(10, event1, event2)</usage>
]]
Threading.Wait = Task.Wait

------------------------------------------------------
-- System.Threading.Thread
------------------------------------------------------
__Doc__[[
	<desc>Make current thread sleeping until event triggered or meet the timeline</desc>
	<param name="delay">the waiting time</param>
	<param name="...">the event list</param>
]]
function Threading.Thread:Wait(...)
	self.Thread = running()
	return Task.Wait(...)
end

__Doc__[[
	<desc>Make current thread sleeping until event triggered</desc>
	<param name="event">the event name</param>
]]
function Threading.Thread:WaitEvent(event)
	self.Thread = running()
	return Task.Event(event)
end

__Doc__[[
	<desc>Make current thread sleeping</desc>
	<param name="delay">the waiting time</param>
]]
function Threading.Thread:Sleep(delay)
	self.Thread = running()
	return Task.Delay(delay)
end