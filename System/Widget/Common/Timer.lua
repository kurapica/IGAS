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

	--Timers will not be fired more often than HZ-1 times per second.
	local HZ = 11
	local minInterval = 1 / (HZ - 1)

	__StructType__(StructType.Custom)
	__Default__( 0 )
	struct "TimerInterval"
		function Validate(value)
			if type(value) ~= "number" or value < 0 then
				value = 0
			elseif value > 0 and value < minInterval then
				value = minInterval
			end
			return value
		end
	endstruct "TimerInterval"

	WorldFrame = IGAS.WorldFrame

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
    _Timer = _Timer or CreateFrame("Frame", nil, WorldFrame)
    _Timer:Hide()

	-- _Container is shared in all versions
	_Container = _Container or {}
	_TempContainer = _TempContainer or {}
	_Updating = _Updating or false
	_Working = false

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
			if delay > 0 and delay <= soon then
				timer:Fire("OnTimer")

				int = timer.Interval

				if timer.Enabled and int > 0 then
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

		if not next(_Container) then
			_Working = false
			self:Hide()
		end

		wipe(_TempContainer)
	end)

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	__Doc__[[Run when the timer is at the right time]]
	event "OnTimer"

	local function RefreshTimer(self)
		local int = self.Interval

		if int > 0 and self.Enabled then
			if not _Container[self] then
				if _Updating then
					_TempContainer[self] = GetTime() + int
				else
					_Container[self] = GetTime() + int
				end

				if not _Working then
					_Working = true
					_Timer:Show()
				end
			end
		else
			if _Container[self] then
				if _Updating then
					_TempContainer[self] = 0
				else
					_Container[self] = nil
				end
			end
		end
	end

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
	function Dispose(self)
		if _Container[self] then
			if _Updating then
				_TempContainer[self] = 0
			else
				_Container[self] = nil
			end
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "Timer"