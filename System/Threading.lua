 -- Author      : Kurapica
-- Create Date : 2011/02/28
-- ChangeLog   :
--               2011/10/22 Stop UnregisterEvent when no thread in
--               2012/04/05 Thread:Resume methods would call UnregisterAllEvent to clear it's settings

----------------------------------------------------------------------------------------------------------------------------------------
--- Threading is a lib to control threads using in script handlers.
-- @name Thread
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

local version = 8

if not IGAS:NewAddon("IGAS.Threading", version) then
	return
end

namespace "System"

create = coroutine.create
resume = coroutine.resume
running = coroutine.running
status = coroutine.status
wrap = coroutine.wrap
yield = coroutine.yield

interface "Threading"

	enum "ThreadStatus" {
		"running",
		"suspended",
		"normal",
		"dead",
	}

	------------------------------------------------------
	-- System.Threading.Sleep
	------------------------------------------------------
	if CreateFrame then
		local HZ = 11
		local lastint = floor(GetTime() * HZ)

		local wipe = wipe or function(t)
			for k in pairs(t) do
				t[k] = nil
			end
		end

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

		------------------------------------
		--- Make current thread sleeping
		-- @name Sleep
		-- @class function
		-- @param delay
		-- @usage System.Threading.Sleep(10)
		------------------------------------
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
		_EventManager = _EventManager or nil
		if CreateFrame and not _EventManager then
			_EventManager = _EventManager or CreateFrame("Frame")
			_EventManager:Hide()
		end
		_CstmEvtManager = _CstmEvtManager or System.Object()

		_EventDistribution =  _EventDistribution or {}
		_EventThreads = _EventThreads or setmetatable({}, {__mode = "k"})
		_MetaWeakV = _MetaWeakV or {__mode = "v"}

		-- RegisterEvent
		function RegisterEvent(event, thread)
			if type(event) == "string" and event ~= "" then
				if not _EventDistribution[event] then
					if _EventManager then
						_EventManager:RegisterEvent(event)
					end

					if not _EventManager or not _EventManager:IsEventRegistered(event) then
						_CstmEvtManager:RegisterEvent(event)
					end
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
		if _EventManager then
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

					--[[if threads.startLoc == threads.endLoc then
						if _EventManager then
							_EventManager:UnregisterEvent(event)
						end
						_CstmEvtManager:UnregisterEvent(event)
					end --]]
				end
			end)
		end

		function _CstmEvtManager:OnEvent(event, ...)
			local ok, ret, th, threads

			threads = _EventDistribution[event]

			if threads then
				for i = threads.startLoc, threads.endLoc - 1 do
					threads.startLoc = threads.startLoc + 1

					th = threads[i]

					if th then
						UnregisterAllEvent(th)

						ok, ret = resume(th, event, ...)

						if not ok then
							errorhandler(ret)
						end
					end
				end

				--[[if threads.startLoc == threads.endLoc then
					if _EventManager then
						_EventManager:UnregisterEvent(event)
					end
					_CstmEvtManager:UnregisterEvent(event)
				end--]]
			end
		end

		------------------------------------
		--- Make current thread sleeping until event triggered
		-- @name WaitEvent
		-- @class function
		-- @param event
		-- @usage System.Threading.WaitEvent(event[, ...])
		------------------------------------
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

		------------------------------------
		--- Make current thread sleeping until event triggered or meet the timeline
		-- @name WaitEvent
		-- @class function
		-- @param delay|event
		-- @usage System.Threading.Wait(delay|event[, ...])
		------------------------------------
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

	------------------------------------------------------
	-- System.Threading.Thread
	------------------------------------------------------
	class "Thread"
		_Threads = _Threads or setmetatable({}, {__mode = "k"})

		------------------------------------------------------
		-- Script
		------------------------------------------------------

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		------------------------------------
		--- Make current thread sleeping until event triggered or meet the timeline
		-- @name Wait
		-- @class function
		-- @param event
		-- @usage thread:Wait(event[, ...])
		------------------------------------
		function Wait(self, ...)
			local co = running()

			if co then
				_Threads[self] = co
			end

			return Threading.Wait(...)
		end

		------------------------------------
		--- Make current thread sleeping until event triggered
		-- @name WaitEvent
		-- @class function
		-- @param event
		-- @usage thread:WaitEvent(event[, ...])
		------------------------------------
		function WaitEvent(self, ...)
			local co = running()

			if co then
				_Threads[self] = co
			end

			return Threading.WaitEvent(...)
		end

		------------------------------------
		--- Make current thread sleeping
		-- @name Sleep
		-- @class function
		-- @param delay
		-- @usage thread:Sleep(10)
		------------------------------------
		function Sleep(self, delay)
			local co = running()

			if co then
				_Threads[self] = co
			end

			return Threading.Sleep(delay)
		end

		------------------------------------
		--- Resume the thread
		-- @name Resume
		-- @class function
		-- @param ...
		-- @usage thread:Resume(...)
		------------------------------------
		function Resume(self, ...)
			if _Threads[self] then
				UnregisterAllEvent(_Threads[self])
				return resume(_Threads[self], ...)
			end
		end

		------------------------------------
		--- Yield the thread
		-- @name Yield
		-- @class function
		-- @param ...
		-- @usage thread:Yield(...)
		------------------------------------
		function Yield(self, ...)
			local co = running()

			if co then
				_Threads[self] = co

				return yield(...)
			end
		end

		------------------------------------
		--- Whether the thread is running
		-- @name IsRunning
		-- @class function
		-- @usage thread:IsRunning()
		------------------------------------
		function IsRunning(self)
			return _Threads[self] and (status(_Threads[self]) == "running" or status(_Threads[self]) == "normal") or false
		end

		------------------------------------
		--- Whether the thread is running
		-- @name IsSuspended
		-- @class function
		-- @usage thread:IsSuspended()
		------------------------------------
		function IsSuspended(self)
			return _Threads[self] and status(_Threads[self]) == "suspended" or false
		end

		------------------------------------
		--- Whether the thread is running
		-- @name IsDead
		-- @class function
		-- @usage thread:IsDead()
		------------------------------------
		function IsDead(self)
			return (_Threads[self] == nil) or status(_Threads[self]) == "dead" or false
		end

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		property "Status" {
			Get = function(self)
				if _Threads[self] then
					return status(_Threads[self])
				end
			end,
		}

		property "Thread" {
			Set = function(self, th)
				if type(th) == "function" then
					_Threads[self] = create(th)
				elseif type(th) == "thread" then
					_Threads[self] = th
				else
					_Threads[self] = _Threads[th]
				end
			end,
			Type = System.Function + System.Thread + System.Threading.Thread + nil,
		}

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
		function Thread(func)
			assert((func == nil) or type(func) == "function" or type(func) == "thread", "Usage : System.Threading.Thread(func) - 'func' must be a function or thread or nil.")

			local self = {}

			if type(func) == "function" then
				_Threads[self] = create(func)
			elseif type(func) == "thread" then
				_Threads[self] = func
			end

			return self
		end

		------------------------------------------------------
		-- __call for class instance
		------------------------------------------------------
		function __call(self, ...)
			return _Threads[self] and resume(_Threads[self], ...)
		end
	endclass "Thread"
endinterface "Threading"