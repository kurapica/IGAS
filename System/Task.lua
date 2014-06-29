-- Author      : Kurapica
-- Create Date : 2014/06/28
-- ChangeLog   :

Module "System.Task" "0.1.0"

namespace "System"

------------------------------------------------------
-- Task API
------------------------------------------------------
do
	CORE_PRIORITY = 0 	-- For Task Job
	HIGH_PRIORITY = 1 	-- For Direct call
	NORMAL_PRIORITY = 2 -- For Threading, Event
	LOW_PRIORITY = 3 	-- For Delay

	g_Phase = 0 		-- The Nth phase based on GetTime()
	g_Threshold = 0 	-- The threshold based on GetFramerate()
	g_TimeUsage = 0 	-- The used time based on debugprofilestop() in one phase

	callThread = System.Reflector.ThreadCall

	function QueueTask(task)

	end

	function StartPhase()
		-- One phase per one time
		local now = GetTime()

		if now == g_Phase then return end

		g_Phase = now
	end
end

------------------------------------------------------
-- Task Manager
------------------------------------------------------
do
	TaskManager = CreateFrame("Frame")

	TaskManager:SetScript("OnUpdate", function(self, elapsed)

	end)

	TaskManager:SetScript("OnEvent", function(self, event, ...)

	end)
end

__Doc__[[Task system used to improve performance for the whole system]]
__NonInheritable__()
interface "Task"

	------------------------------------------------------
	-- Task Creation Method
	------------------------------------------------------
	__Doc__[[
		<desc>Call method directly</desc>
		<format>callable[, ...]</format>
		<param name="callable">Callable object, function, thread, table with __call</param>
		<param name="...">method parameter</param>
	]]
	function DirectCall(callable, ...)
		-- body
	end

	__Doc__[[
		<desc>Call method after several second</desc>
		<format>delay, callable[, ...]</format>
		<param name="delay">the time to delay</param>
		<param name="callable">Callable object, function, thread, table with __call</param>
		<param name="...">method parameter</param>
	]]
	function DelayCall(delay, callable, ...)
		-- body
	end

	__Doc__[[
		<desc>Call method wait for system event</desc>
		<format>event, callable[, ...]</format>
		<param name="event">the system event name</param>
		<param name="callable">Callable object, function, thread, table with __call</param>
		<param name="...">method parameter</param>
	]]
	function EventCall(event, callable, ...)
		-- body
	end

	__Doc__[[
		<desc>Call method with thread mode</desc>
		<format>callable[, ...]</format>
		<param name="callable">Callable object, function, thread, table with __call</param>
		<param name="...">method parameter</param>
	]]
	function ThreadCall(callable, ...)
		-- body
	end

	------------------------------------------------------
	-- Thread Helper
	------------------------------------------------------
	__Doc__[[Check if the current thread should keep running or wait for next time slice]]
	function Continue()
		-- body
	end

	__Doc__[[
		<desc>Delay the current thread for several second</desc>
		<param name="delay">the time to delay</param>
	]]
	function Delay(delay)
		-- body
	end

	__Doc__[[
		<desc>Make the current thread wait for a system event</desc>
		<param name="event">the system event name</param>
	]]
	function Event(event)
		-- body
	end
endinterface "Task"