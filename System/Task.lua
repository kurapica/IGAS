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

	DELAY_EVENT = "DELAY"

	g_Phase = 0 		-- The Nth phase based on GetTime()
	g_Threshold = 0 	-- The threshold based on GetFramerate(), in ms
	g_TimeUsage = 0 	-- The used time based on debugprofilestop() in one phase

	r_Header = nil 		-- The core task header
	r_Tail = nil 		-- The tail task header

	p_Header = {}		-- The header pointer
	p_Tail = {}			-- The tail pointer

	c_Task = {}			-- Cache for useless task objects
	c_Event = {}		-- Cache for registered events

	callThread = System.Reflector.ThreadCall

	-- Phase API
	function StartPhase()
		-- One phase per one time
		local now = GetTime()
		if now ~= g_Phase then
			-- Prepare the phase
			g_Phase = now
			g_Threshold = debugprofilestop() ＋ 1000 / GetFramerate()	-- @todo: need a better solution

			-- Move task to core based on priority
			for i = HIGH_PRIORITY, LOW_PRIORITY do
				if p_Header[i] then
					if r_Header and r_Tail then
						r_Tail.Next = p_Header[i]
						r_Tail = p_Tail[i]
					else
						r_Header = p_Header[i]
						r_Tail = p_Tail[i]
					end

					p_Header[i] = nil
					p_Tail[i] = nil
				end
			end
		end

		-- It's time to execute tasks
		while r_Header and g_Threshold > debugprofilestop() do
			local task = r_Header
			local ok, msg

			r_Header = r_Header.Next

			if type(task.Method) == "thread" then
				if task.NArgs > 0 then
					ok, msg = resume(task.Method, unpack(task, 1, task.NArgs))
				else
					ok, msg = resume(task.Method)
				end
			else
				if task.NArgs > 0 then
					ok, msg = pcall(task.Method, unpack(task, 1, task.NArgs))
				else
					ok, msg = pcall(task.Method)
				end
			end

			wipe(task)
			tinsert(c_Task, task)

			if not ok then geterrorhandler()(msg)
		end
	end

	-- Queue API
	function QueueTask(priority, task)
		if p_Tail[priority] then
			p_Tail[priority].Next = task
		else
			p_Tail[priority] = task
			p_Header[priority] = task
		end

		while task.Next do task = task.Next end

		p_Tail[priority] = task

		if type(priority) == "number" then
			return StartPhase()
		end
	end

	function NewDelayTask(delay, task)
		local time = GetTime() + delay

		task.Time = time

		local header = p_Header[DELAY_EVENT]
		local oHeader

		while header and header.Time <= time do
			oHeader = header
			header = header.Next
		end

		if oHeader then
			task.Next = header
			oHeader.Next = task
		else
			task.Next = header
			p_Header[DELAY_EVENT] = task
		end
	end

	function NewEventTask(event, task)
		if not c_Event[event] then
			TaskManager:RegisterEvent(event)

			if not TaskManager:IsEventRegistered(event) then
				wipe(task)				-- empty the task, should we?
				tinsert(c_Task, task)	-- reuse the task
				return geterrorhandler()(("No '%s' event exist."):format(event))
			else
				c_Event[event] = true
			end
		end

		return QueueTask(event, task)
	end
end

------------------------------------------------------
-- Task Manager
------------------------------------------------------
do
	TaskManager = CreateFrame("Frame")

	-- Delay Event Handler
	TaskManager:SetScript("OnUpdate", function(self, elapsed)
		local header = p_Header[DELAY_EVENT]
		local now = GetTime()

		if header and header.Time <= now then
			local otail = header
			local tail = header.Next

			while tail and tail.Time <= now do
				otail = tail
				tail = tail.Next
			end

			p_Header[DELAY_EVENT] = tail
			otail.Next = nil

			return QueueTask(LOW_PRIORITY, header)
		else
			return StartPhase()
		end
	end)

	-- System Event Handler
	TaskManager:SetScript("OnEvent", function(self, event, ...)
		local header = p_Header[event]
		if not header then return end

		-- Clear
		p_Header[event] = nil
		p_Tail[event] = nil

		-- Attach to Queue
		return QueueTask(NORMAL_PRIORITY, header)
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
		local task = tremove(c_Task) or {}

		task.NArgs = select('#', ...)

		for i = 1, task.NArgs do
			task[i] = select(i, ...)
		end

		task.Method = callable

		return QueueTask(HIGH_PRIORITY, task)
	end

	__Doc__[[
		<desc>Call method after several second</desc>
		<format>delay, callable[, ...]</format>
		<param name="delay">the time to delay</param>
		<param name="callable">Callable object, function, thread, table with __call</param>
		<param name="...">method parameter</param>
	]]
	function DelayCall(delay, callable, ...)
		local dTask = tremove(c_Task) or {}

		dTask.NArgs = select('#', ...)

		for i = 1, dTask.NArgs do
			dTask[i] = select(i, ...)
		end

		dTask.Method = callable

		local task = tremove(c_Task) or {}

		task.NArgs = 2

		task[1] = tonumber(delay) or 0
		task[2] = dTask
		task.Method = NewDelayTask

		return QueueTask(LOW_PRIORITY, task)
	end

	__Doc__[[
		<desc>Call method wait for system event</desc>
		<format>event, callable[, ...]</format>
		<param name="event">the system event name</param>
		<param name="callable">Callable object, function, thread, table with __call</param>
		<param name="...">method parameter</param>
	]]
	function EventCall(event, callable, ...)
		local dTask = tremove(c_Task) or {}

		dTask.NArgs = select('#', ...)

		for i = 1, dTask.NArgs do
			dTask[i] = select(i, ...)
		end

		dTask.Method = callable
		dTask.Delay = tonumber(delay) or 0

		local task = tremove(c_Task) or {}

		task.NArgs = 2

		task[1] = tostring(event)
		task[2] = dTask
		task.Method = NewEventTask

		return QueueTask(NORMAL_PRIORITY, task)
	end

	__Doc__[[
		<desc>Call method with thread mode</desc>
		<format>callable[, ...]</format>
		<param name="callable">Callable object, function, thread, table with __call</param>
		<param name="...">method parameter</param>
	]]
	function ThreadCall(callable, ...)
		local task = tremove(c_Task) or {}

		task.NArgs = select('#', ...) + 1

		task[1] = callable
		for i = 1, task.NArgs do
			task[i + 1] = select(i, ...)
		end

		task.Method = callThread

		return QueueTask(NORMAL_PRIORITY, task)
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