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

__Doc__[[Timer is used to fire an event on a specified interval]]
class "Timer"
	inherit "VirtualUIObject"

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
	local minInterval = 1 / (HZ - 1)

	local lastint = floor(GetTime() * HZ)

	_Timer:SetScript("OnUpdate", function(self, elapsed)
		local now = GetTime()
		local nowint = floor(now * HZ)

		-- Reduce cpu cost.
		if nowint == lastint then return end

		local soon = now + 0.1
		local int

		_Updating = true

		-- Consider people will disable timer when a onTimer event triggered, and enable it when all is done, so, I don't use one container to control the enabled timers, another for disabled timers.
		for timer, delay in pairs(_Container) do
			if delay > 0 and delay < soon then
				timer:Fire("OnTimer")

				int = timer.Interval

				if timer.Enabled and int > 0 then
					if int < minInterval then int = minInterval end

					-- set next time
					_Container[timer] = now + int
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
	__Doc__[[Run when the timer is at the right time]]
	event "OnTimer"

	local function RefreshTimer(self)
		if self.Interval == 0 or not self.Enabled then
			if _Container[self] then
				if _Updating then
					_TempContainer[self] = 0
				else
					_Container[self] = nil
				end
			end
		else
			local int = self.Interval

			if int < minInterval then int = minInterval end

			if _Updating then
				_TempContainer[self] = GetTime() + int
			else
				_Container[self] = GetTime() + int
			end
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[Gets or sets the interval at which to fire the Elapsed event]]
	__Handler__( RefreshTimer )
	property "Interval" { Type = NaturalNumber }

	__Doc__[[Whether the timer is enabled or disabled, default true]]
	__Handler__( RefreshTimer )
	property "Enabled" { Type = Boolean, Default = true }

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_Container[self] = nil
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "Timer"