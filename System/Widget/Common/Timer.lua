-- Author      : Kurapica
-- ChangreLog  :
--				2010.01.13	Change the Timer's Parent to WorldFrame
--				2011/03/13	Recode as class
--				2011/05/29	Recode

-- Check Version
local version = 11

if not IGAS:NewAddon("IGAS.Widget.Timer", version) then
	return
end

class "Timer"
	inherit "VirtualUIObject"

	doc [======[
		@name Timer
		@type class
		@desc Timer is used to fire an event on a specified interval
	]======]

	WorldFrame = IGAS.WorldFrame

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
    _Timer = _Timer or CreateFrame("Frame", nil, WorldFrame)

	-- _Container is shared in all versions
	_Container = _Container or {}
	_TempContainer = _TempContainer or {}
	_Updating = _Updating or false

	--Timers will not be fired more often than HZ-1 times per second.
	local HZ = 11

	local lastint = floor(GetTime() * HZ)

	_Timer:SetScript("OnUpdate", function(self, elapsed)
		local now = GetTime()
		local nowint = floor(now * HZ)

		-- Reduce cpu cost.
		if nowint == lastint then return end

		local soon = now + 0.1

		_Updating = true

		-- Consider people will disable timer when a onTimer event triggered, and enable it when all is done, so, I don't use one container to control the enabled timers, another for disabled timers.
		for timer, delay in pairs(_Container) do
			if delay > 0 and delay < soon then
				timer:Fire("OnTimer")

				-- set next time
				if timer.__Interval then
					_Container[timer] = now + timer.__Interval
				else
					_Container[timer] = nil
				end
			end
		end

		lastint = nowint
		_Updating = false

		for timer, delay in pairs(_TempContainer) do
			if delay <= 0 then
				_Container[timer] = nil
			else
				_Container[timer] = delay
			end
		end

		wipe(_TempContainer)
	end)

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnTimer
		@type event
		@desc Run when the timer is at the right time
	]======]
	event "OnTimer"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Interval
		@type property
		@desc Gets or sets the interval at which to fire the Elapsed event
	]======]
	property "Interval" {
		Get = function(self)
			return self.__Interval or 0
		end,
		Set = function(self, int)
			if int >= 0 then
				if int == 0 then
					-- Set 0 means stop.
					self.__Interval = 0

					if _Container[self] then
						if _Updating then
							_TempContainer[self] = 0
						else
							_Container[self] = nil
						end
					end
				else
					-- Interval must more than 0.1s
					if int < (1 / (HZ - 1)) then
						int = 1 / (HZ - 1)
					end

					self.__Interval = int
					-- Restart time count
					if self.__Enabled then
						if _Updating then
							_TempContainer[self] = GetTime() + int
						else
							_Container[self] = GetTime() + int
						end
					end
				end
			else
				error("Interval must be a number, and not negative",2)
			end
		end,
		Type = Number,
	}

	doc [======[
		@name Enabled
		@type property
		@desc Whether the timer is enabled or disabled, default true
	]======]
	property "Enabled" {
		Get = function(self)
			return self.__Enabled and true or false
		end,
		Set = function(self, flag)
			if self.__Enabled == flag then
				return
			end
			self.__Enabled = flag

			if self.__Enabled then
				if self.__Interval > 0 then
					-- Restart time count
					if _Updating then
						_TempContainer[self] = GetTime() + self.__Interval
					else
						_Container[self] = GetTime() + self.__Interval
					end
				end
			elseif _Container[self] then
				if _Updating then
					_TempContainer[self] = 0
				else
					_Container[self] = nil
				end
			end
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_Container[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Timer(self)
		self.__Interval = 0
		self.__Enabled = true
	end
endclass "Timer"