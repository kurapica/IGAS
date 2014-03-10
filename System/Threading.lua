 -- Author      : Kurapica
-- Create Date : 2013/08/13
-- ChangeLog   :

Module "System.Threading" "1.10.0"

namespace "System"

------------------------------------------------------
-- System.Threading.Sleep
------------------------------------------------------
do
	HZ = 11
	lastint = floor(GetTime() * HZ)

	_SleepThread = _SleepThread or {}
	_TmpSleepThread = _TmpSleepThread or {}
	_OnUpdateSleepTimer = _OnUpdateSleepTimer or false

	_SleepTimer = _SleepTimer or CreateFrame("Frame", nil, WorldFrame)
	if not next(_SleepThread) then _SleepTimer:Hide() end

	_SleepTimer:SetScript("OnUpdate", function(self)
		local now = GetTime()
		local nowint = floor(now * HZ)
		local ok, ret

		-- Reduce cpu cost.
		if nowint == lastint then return end

		_OnUpdateSleepTimer = true

		now = now + 0.1

		for th, tm in pairs(_SleepThread) do
			if tm < now then
				if _WaitThread[th] then
					UnregisterAllEvent(th)
				else
					_SleepThread[th] = nil
				end

				if th and status(th) == "suspended" then
					ok, ret = resume(th)

					if not ok then
						errorhandler(ret)
					end
				end
			end
		end

		lastint = nowint

		_OnUpdateSleepTimer = false

		for th, tm in pairs(_TmpSleepThread) do
			if not _SleepThread[th] then
				_SleepThread[th] = tm
			end
		end
		wipe(_TmpSleepThread)

		if not next(_SleepThread) then
			self:Hide()
		end
	end)

	function Sleep(delay)
		local thread = running()

		if thread and type(delay) == "number" and delay > 0 then
			if delay < 0.1 then
				delay = 0.1
			end

			if not _OnUpdateSleepTimer then
				_SleepThread[thread] = GetTime() + delay
			else
				_TmpSleepThread[thread] = GetTime() + delay
			end

			_SleepTimer:Show()

			return yield()
		end
	end
end

------------------------------------------------------
-- System.Threading.WaitEvent
------------------------------------------------------
do
	_EventManager = _EventManager or CreateFrame("Frame")
	_EventManager:Hide()

	_EventDistribution =  _EventDistribution or {}
	_EventThreads = _EventThreads or {} -- setmetatable({}, {__mode = "k"})
	_MetaWeakV = _MetaWeakV or {__mode = "v"}

	-- RegisterEvent
	function RegisterEvent(event, thread)
		if type(event) == "string" and event ~= "" then
			if not _EventDistribution[event] then
				_EventManager:RegisterEvent(event)
			end

			_EventDistribution[event] = _EventDistribution[event] or setmetatable({
				startLoc = 1,
				endLoc = 1,
			}, _MetaWeakV)

			_EventDistribution[event][_EventDistribution[event].endLoc] = thread
			_EventDistribution[event].endLoc = _EventDistribution[event].endLoc + 1

			return true
		end
	end

	-- UnregisterAllEvent
	function UnregisterAllEvent(thread)
		local mark = _EventThreads[thread]
		local data

		if _SleepThread then
			_SleepThread[thread] = nil
		end

		_EventThreads[thread] = nil
		_WaitThread[thread] = nil

		if mark then
			for event in mark:gmatch("[^\001]+") do
				data = _EventDistribution[event]
				if data then
					for i = data.startLoc, data.endLoc - 1 do
						if data[i] == thread then
							data[i] = nil
							break
						end
					end
				end
			end
		end
	end

	--  Special Settings for _EventManager
	_EventManager:SetScript("OnEvent", function(self, event, ...)
		local ok, ret, th, threads

		threads = _EventDistribution[event]

		if threads then
			for i = threads.startLoc, threads.endLoc - 1 do
				threads.startLoc = threads.startLoc + 1

				th = threads[i]

				if th then
					UnregisterAllEvent(th)

					if status(th) == "suspended" then
						ok, ret = resume(th, event, ...)

						if not ok then
							errorhandler(ret)
						end
					end
				end
			end
		end
	end)

	function WaitEvent(...)
		local thread = running()
		local hasEvent = false
		local mark = ""

		if thread then
			for i=1, select('#', ...) do
				if RegisterEvent(select(i, ...), thread) then
					mark = mark..select(i, ...).."\001"
					hasEvent = true
				end
			end
		end

		if hasEvent then
			_EventThreads[thread] = mark:sub(1, -2)
			return yield()
		end
	end
end

------------------------------------------------------
-- System.Threading.Wait
------------------------------------------------------
do
	_WaitThread = _WaitThread or setmetatable({}, {__mode = "k"})

	function Wait(...)
		local thread = running()

		if not thread then return end

		local needWait = false
		local inSleep = false
		local mark = ""
		local cond = nil

		for i=1, select('#', ...) do
			cond = select(i, ...)

			if _SleepThread and type(cond) == "number" and not inSleep and cond > 0 then
				if cond < 0.1 then cond = 0.1 end

				if not _OnUpdateSleepTimer then
					_SleepThread[thread] = GetTime() + cond
				else
					_TmpSleepThread[thread] = GetTime() + cond
				end

				_SleepTimer:Show()

				inSleep = true
				needWait = true
			end

			if type(cond) == "string" then
				if RegisterEvent(cond, thread) then
					mark = mark..cond.."\001"
					needWait = true
				end
			end
		end

		if needWait then
			_WaitThread[thread] = true

			if mark ~= "" then
				_EventThreads[thread] = mark:sub(1, -2)
			end
			return yield()
		end
	end
end

interface "Threading"
	__Doc__[[
		<desc>Make current thread sleep for a while</desc>
		<param name="delay" type="number">the sleep time for current thread</param>
		<usage>System.Threading.Sleep(10)</usage>
	]]
	Sleep = _M.Sleep

	__Doc__[[
		<desc>Make current thread sleeping until event triggered</desc>
		<param name="...">the event list</param>
		<usage>System.Threading.WaitEvent(event1, event2, event3)</usage>
	]]
	WaitEvent = _M.WaitEvent

	__Doc__[[
		<desc>Make current thread sleeping until event triggered or meet the timeline</desc>
		<param name="delay">number, the waiting time's deadline</param>
		<param name="...">the event list</param>
		<usage>System.Threading.Wait(10, event1, event2)</usage>
	]]
	Wait = _M.Wait

	------------------------------------------------------
	-- System.Threading.Thread
	------------------------------------------------------
	class "Thread"
		------------------------------------------------------
		-- Method
		------------------------------------------------------
		__Doc__[[
			<desc>Resume the thread</desc>
			<param name="...">resume arguments</param>
			<return type="...">return values from thread</return>
		]]
		function Resume(self, ...)
			if self.Thread then
				UnregisterAllEvent(self.Thread)
				return resume(self.Thread, ...)
			end
		end

		__Doc__[[
			<desc>Make current thread sleeping until event triggered or meet the timeline</desc>
			<param name="delay">the waiting time</param>
			<param name="...">the event list</param>
		]]
		function Wait(self, ...)
			local co = running()

			if co then
				self.Thread = co
			end

			return Threading.Wait(...)
		end

		__Doc__[[
			<desc>Make current thread sleeping until event triggered</desc>
			<param name="...">the event list</param>
		]]
		function WaitEvent(self, ...)
			local co = running()

			if co then
				self.Thread = co
			end

			return Threading.WaitEvent(...)
		end

		__Doc__[[
			<desc>Make current thread sleeping</desc>
			<param name="delay">the waiting time</param>
		]]
		function Sleep(self, delay)
			local co = running()

			if co then
				self.Thread = co
			end

			return Threading.Sleep(delay)
		end
	endclass "Thread"
endinterface "Threading"