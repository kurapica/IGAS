-- Author      : Kurapica
-- Create Date : 2014/06/28
-- ChangeLog   :

Module "System.Task" "1.1.0"

namespace "System"

------------------------------------------------------
-- Constant Settings
------------------------------------------------------
do
	PHASE_THRESHOLD = 50 	-- The max task operation time per phase

	PHASE_TIME_FACTOR = 0.4 -- The factor used to calculate the task operation time per phase
	PHASE_ADD_FACTOR = 1.5 	-- The factor used to calculate the additional task operation time based on current one
end

------------------------------------------------------
-- Task API
------------------------------------------------------
do
	CORE_PRIORITY = 0 	-- For Task Job
	HIGH_PRIORITY = 1 	-- For Direct, Continue, Thread
	NORMAL_PRIORITY = 2 -- For Event, Next
	LOW_PRIORITY = 3 	-- For Delay

	DELAY_EVENT = "DELAY"

	g_Phase = 0 		-- The Nth phase based on GetTime()
	g_PhaseTime = 0
	g_Threshold = 0 	-- The threshold based on GetFramerate(), in ms
	g_InPhase = false
	g_FinishedTask = 0
	g_TaskCount = {
		[HIGH_PRIORITY] = 0,
		[NORMAL_PRIORITY] = 0,
		[LOW_PRIORITY] = 0,
	}
	g_StartTime = 0
	g_EndTime = 0
	g_AverageTime = 20 	-- A useless init value
	g_RequireTime = false

	local r_Header = nil-- The core task header
	local r_Tail = nil 	-- The core task tail
	local r_Count = 0 	-- The core task count

	p_Header = {}		-- The header pointer
	p_Tail = {}			-- The tail pointer

	c_Task = {}			-- Cache for useless task objects
	c_Event = {}		-- Cache for registered events

	callThread = System.Reflector.ThreadCall

	-- Phase API
	function StartPhase()
		if g_InPhase then return end

		g_InPhase = true

		-- One phase per one time
		local now = GetTime()
		if now ~= g_Phase then
			-- Prepare the phase
			g_Phase = now
			g_RequireTime = false

			-- Task system also cost some time
			g_StartTime = debugprofilestop()

			-- Calculate the average time per task
			if g_FinishedTask > 0 then
				g_AverageTime = (g_AverageTime + (g_EndTime - g_StartTime) / g_FinishedTask) / 2
				g_FinishedTask = 0
			end

			-- Move task to core based on priority
			for i = HIGH_PRIORITY, LOW_PRIORITY do
				if p_Header[i] then
					if r_Header and r_Tail then
						r_Tail.Next = p_Header[i]
						r_Tail = p_Tail[i]
						r_Count = r_Count + g_TaskCount[i]
					else
						r_Header = p_Header[i]
						r_Tail = p_Tail[i]
						r_Count = g_TaskCount[i]
					end

					p_Header[i] = nil
					p_Tail[i] = nil
					g_TaskCount[i] = 0
				end
			end

			local task = r_Header

			g_PhaseTime = 1000 * PHASE_TIME_FACTOR / GetFramerate()

			if g_PhaseTime > PHASE_THRESHOLD then g_PhaseTime = PHASE_THRESHOLD end

			g_Threshold = g_StartTime + g_PhaseTime
		elseif not r_Header and p_Header[HIGH_PRIORITY] then
			-- Only tasks of high priority can be executed with several generations in one phase
			r_Header = p_Header[HIGH_PRIORITY]
			r_Tail = p_Tail[HIGH_PRIORITY]
			r_Count = g_TaskCount[HIGH_PRIORITY]

			p_Header[HIGH_PRIORITY] = nil
			p_Tail[HIGH_PRIORITY] = nil
			g_TaskCount[HIGH_PRIORITY] = 0
		end

		-- It's time to execute tasks
		while r_Header do
			local task = r_Header
			local ok, msg
			local stop = debugprofilestop()

			if g_Threshold <= stop and not g_RequireTime then
				-- One time per phase
				g_RequireTime = true

				-- Consider tasks in next phase to smooth the performance
				local cost = (r_Count + g_TaskCount[HIGH_PRIORITY] + g_TaskCount[NORMAL_PRIORITY] + g_TaskCount[LOW_PRIORITY]) * g_AverageTime / 2

				if cost + g_PhaseTime > PHASE_THRESHOLD then cost = PHASE_THRESHOLD - g_PhaseTime end

				g_Threshold = g_Threshold + cost

				if g_Threshold <= stop then break end

				task = r_Header
			end

			-- Execute task
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

			if not ok then pcall(geterrorhandler(), msg) end

			g_FinishedTask = g_FinishedTask + 1
			r_Count = r_Count - 1

			wipe(task)
			tinsert(c_Task, task)
		end

		g_EndTime = debugprofilestop()

		g_InPhase = false

		-- Try again if have time with high priority tasks
		return not r_Header and g_Threshold > g_EndTime and p_Header[HIGH_PRIORITY] and StartPhase()
	end

	-- Queue API
	function QueueTask(priority, task, noStart)
		local tail, ntail, count = task, task.Next, 1

		while ntail do tail, ntail, count = ntail, ntail.Next, count + 1 end

		if p_Tail[priority] then
			p_Tail[priority].Next = task
			p_Tail[priority] = tail

			g_TaskCount[priority] = g_TaskCount[priority] + count
		else
			p_Header[priority] = task
			p_Tail[priority] = tail

			g_TaskCount[priority] = count
		end

		return not noStart and priority == HIGH_PRIORITY and StartPhase()
	end

	function QueueDelayTask(time, task)
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

		if not task.Next then p_Tail[DELAY_EVENT] = task end
	end

	function QueueEventTask(event, task)
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

		local tail = p_Tail[event]

		if tail then
			tail.Next = task
			p_Tail[event] = task
		else
			p_Header[event] = task
			p_Tail[event] = task
		end
	end
end

------------------------------------------------------
-- Task Manager
------------------------------------------------------
do
	TaskManager = CreateFrame("Frame")

	-- Delay Event Handler
	TaskManager:SetScript("OnUpdate", function(self, elapsed)
		local now = GetTime()

		-- Make sure unexpected error won't stop the whole task system
		if now > g_Phase then g_InPhase = false end

		local header = p_Header[DELAY_EVENT]

		if header and header.Time <= now then
			local otail = header
			local tail = header.Next

			while tail and tail.Time <= now do
				otail = tail
				tail = tail.Next
			end

			p_Header[DELAY_EVENT] = tail
			otail.Next = nil

			QueueTask(NORMAL_PRIORITY, header, true)
		end

		return StartPhase()
	end)

	-- System Event Handler
	TaskManager:SetScript("OnEvent", function(self, event, ...)
		local header = p_Header[event]
		if not header then return end

		-- Clear
		p_Header[event] = nil
		p_Tail[event] = nil

		-- Fill args
		local task = header
		while task do
			task.NArgs = select('#', ...)
			for i = 1, task.NArgs do task[i] = select(i, ...) end

			task = task.Next
		end

		-- Attach to Queue
		return QueueTask(HIGH_PRIORITY, header)
	end)
end

__Doc__[[Task system used to improve performance for the whole system]]
__NonInheritable__()
interface "Task"

	------------------------------------------------------
	-- Task Creation Method
	------------------------------------------------------
	__Doc__[[
		<desc>Call method with high priority, the method should be called as soon as possible.</desc>
		<format>callable[, ...]</format>
		<param name="callable">Callable object, function, thread, table with __call</param>
		<param name="...">method parameter</param>
	]]
	function DirectCall(callable, ...)
		local task = tremove(c_Task) or {}

		task.NArgs = select('#', ...)

		for i = 1, task.NArgs do task[i] = select(i, ...) end

		task.Method = callable

		return QueueTask(HIGH_PRIORITY, task)
	end

	__Doc__[[
		<desc>Call method with normal priority, the method should be called in the next phase.</desc>
		<format>callable[, ...]</format>
		<param name="callable">Callable object, function, thread, table with __call</param>
		<param name="...">method parameter</param>
	]]
	function NextCall(callable, ...)
		local task = tremove(c_Task) or {}

		task.NArgs = select('#', ...)

		for i = 1, task.NArgs do task[i] = select(i, ...) end

		task.Method = callable

		return QueueTask(NORMAL_PRIORITY, task)
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

		for i = 1, dTask.NArgs do dTask[i] = select(i, ...) end

		dTask.Method = callable

		local task = tremove(c_Task) or {}

		task.NArgs = 2

		task[1] = (tonumber(delay) or 0) + GetTime()
		task[2] = dTask
		task.Method = QueueDelayTask

		return QueueTask(LOW_PRIORITY, task)
	end

	__Doc__[[
		<desc>Call method wait for system event</desc>
		<format>event, callable[, ...]</format>
		<param name="event">the system event name</param>
		<param name="callable">Callable object, function, thread, table with __call</param>
	]]
	function EventCall(event, callable)
		local dTask = tremove(c_Task) or {}

		dTask.NArgs = 0
		dTask.Method = callable

		local task = tremove(c_Task) or {}

		task.NArgs = 2

		task[1] = tostring(event)
		task[2] = dTask
		task.Method = QueueEventTask

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
		for i = 1, task.NArgs do task[i + 1] = select(i, ...) end

		task.Method = callThread

		return QueueTask(HIGH_PRIORITY, task)
	end

	------------------------------------------------------
	-- Thread Helper
	------------------------------------------------------
	__Doc__[[Check if the current thread should keep running or wait for next time slice]]
	function Continue()
		local thread = running()
		assert(thread, "Task.Continue() can only be used in a thread.")

		local task = tremove(c_Task) or {}
		task.NArgs = 0
		task.Method = thread

		QueueTask(HIGH_PRIORITY, task, true)

		return yield()
	end

	__Doc__[[Make the current thread wait for next phase]]
	function Next()
		local thread = running()
		assert(thread, "Task.Next() can only be used in a thread.")

		local task = tremove(c_Task) or {}
		task.NArgs = 0
		task.Method = thread

		QueueTask(NORMAL_PRIORITY, task, true)

		return yield()
	end

	__Doc__[[
		<desc>Delay the current thread for several second</desc>
		<param name="delay">the time to delay</param>
	]]
	function Delay(delay)
		local thread = running()
		assert(thread, "Task.Delay(delay) can only be used in a thread.")

		local dTask = tremove(c_Task) or {}

		dTask.NArgs = 0
		dTask.Method = thread

		local task = tremove(c_Task) or {}

		task.NArgs = 2

		task[1] = (tonumber(delay) or 0) + GetTime()
		task[2] = dTask
		task.Method = QueueDelayTask

		QueueTask(LOW_PRIORITY, task, true)

		return yield()
	end

	__Doc__[[
		<desc>Make the current thread wait for a system event</desc>
		<param name="event">the system event name</param>
	]]
	function Event(event)
		local thread = running()
		assert(thread, "Task.Event(event) can only be used in a thread.")

		local dTask = tremove(c_Task) or {}

		dTask.NArgs = 0
		dTask.Method = thread

		local task = tremove(c_Task) or {}

		task.NArgs = 2

		task[1] = tostring(event)
		task[2] = dTask
		task.Method = QueueEventTask

		QueueTask(NORMAL_PRIORITY, task, true)

		return yield()
	end
endinterface "Task"