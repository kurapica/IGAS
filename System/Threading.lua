 -- Author      : Kurapica
-- Create Date : 2011/02/28
-- ChangeLog   :
--               2011/10/22 Stop UnregisterEvent when no thread in
--               2012/04/05 Thread:Resume methods would call UnregisterAllEvent to clear it's settings
--               2012/01/17 Fix local error


Module "System.Threading" "v9"

namespace "System"

partinterface "Threading"

	local RegisterEvent
	local UnregisterAllEvent

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

		doc [======[
			@name Sleep
			@type method
			@method interface
			@desc Make current thread sleep for a while
			@param delay number, the sleep time for current thread
			@return nil
			@usage System.Threading.Sleep(10)
		]======]
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
		_EventThreads = _EventThreads or {} -- setmetatable({}, {__mode = "k"})
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

		doc [======[
			@name WaitEvent
			@type method
			@method interface
			@desc Make current thread sleeping until event triggered
			@format event[, ...]
			@param event string, event to be waiting for
			@param ... other events' list
			@return nil
			@usage System.Threading.WaitEvent(event1, event2, event3)
		]======]
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

		doc [======[
			@name Wait
			@type method
			@method interface
			@desc Make current thread sleeping until event triggered or meet the timeline
			@format delay|event[, ...]
			@param delay number, the waiting time's deadline
			@param event string, the waiting event
			@param ... other events' list
			@return nil
			@usage System.Threading.Wait(10, event1, event2)
		]======]
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
	partclass "Thread"
		------------------------------------------------------
		-- Method
		------------------------------------------------------
		doc [======[
			@name Wait
			@type method
			@desc Make current thread sleeping until event triggered or meet the timeline
			@format delay|event[, ...]
			@param delay the waiting time
			@param event the waiting event
			@param ... other events' list
			@return nil
		]======]
		function Wait(self, ...)
			local co = running()

			if co then
				self.Thread = co
			end

			return Threading.Wait(...)
		end

		doc [======[
			@name WaitEvent
			@type method
			@desc Make current thread sleeping until event triggered
			@format event[, ...]
			@param event the waiting event
			@param ... other events' list
			@return nil
		]======]
		function WaitEvent(self, ...)
			local co = running()

			if co then
				self.Thread = co
			end

			return Threading.WaitEvent(...)
		end

		doc [======[
			@name Sleep
			@type method
			@desc Make current thread sleeping
			@format delay
			@param delay the waiting time
			@return nil
		]======]
		function Sleep(self, delay)
			local co = running()

			if co then
				self.Thread = co
			end

			return Threading.Sleep(delay)
		end
	endclass "Thread"
endinterface "Threading"