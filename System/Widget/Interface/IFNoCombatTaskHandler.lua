-- Author      : Kurapica
-- Create Date : 2012/09/07
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFNoCombatTaskHandler", version) then
	return
end

geterrorhandler = geterrorhandler or function()
	return print
end

errorhandler = errorhandler or function(err)
	return pcall(geterrorhandler(), err)
end

_IFNoCombat_TaskList = _IFNoCombat_TaskList or {Start = 1, End = 0}
_IFNoCombat_TaskArg = _IFSpellHandler_TaskArg or setmetatable({},
	{
		__index = function(self, key)
			if type(key) == "number" then
				rawset(self, key, {})
				return rawget(self, key)
			end
		end,
	}
)
_IFNoCombat_TaskThread = _IFNoCombat_TaskThread or System.Threading.Thread()

function CheckArgs(index, ...)
	for i = 1, select('#', ...) do
		if _IFNoCombat_TaskArg[i][index] ~= select(i, ...) then
			return false
		end
	end
	return true
end

function PushArgs(index, ...)
	for i = 1, select('#', ...) do
		_IFNoCombat_TaskArg[i][index] = select(i, ...)
	end
end

_TempArgs = setmetatable({}, {__mode="v"})

function PopArgs(index)
	wipe(_TempArgs)
	for i = 1, #_IFNoCombat_TaskArg do
		_TempArgs[i] = _IFNoCombat_TaskArg[i][index]
		_IFNoCombat_TaskArg[i][index] = nil
	end
	return unpack(_TempArgs)
end

function TaskHandler()
	local ret, msg
	local func
	local start, endp

	while _IFNoCombat_TaskThread:WaitEvent("PLAYER_REGEN_ENABLED") do
		start, endp = _IFNoCombat_TaskList.Start, _IFNoCombat_TaskList.End

		for i = start, endp do
			if InCombatLockdown() then
				-- just for safe
				break
			end

			func = _IFNoCombat_TaskList[i]

			-- Remove from task list first
			_IFNoCombat_TaskList[i] = nil
			_IFNoCombat_TaskList.Start = i + 1

			-- Make sure nothing stop the thread service
			ret, msg = pcall(func, PopArgs(i))

			if not ret then
				errorhandler(msg)
			end
		end
	end
end

------------------------------------
--- Do task or save task to task list
-- @name RegisterTask
-- @type function
-- <param name="func">function to call</param>
-- <param name="...">args for the function</param>
------------------------------------
function RegisterTask(func, ...)
	if not InCombatLockdown() then
		-- Just do task when not in combat
		return func(...)
	else
		for i = _IFNoCombat_TaskList.Start, _IFNoCombat_TaskList.End do
			-- Check if there is same task in
			if func == _IFNoCombat_TaskList[i] and CheckArgs(i, ...) then
				return
			end
		end

		local last = _IFNoCombat_TaskList.End + 1

		-- Save task to the task list
		_IFNoCombat_TaskList.End = last

		_IFNoCombat_TaskList[last] = func

		PushArgs(last, ...)

		-- Check thread
		if _IFNoCombat_TaskThread:IsDead() then
			-- Bind handler to thread
			_IFNoCombat_TaskThread.Thread = TaskHandler

			-- Thread start
			_IFNoCombat_TaskThread()
		end
	end
end

__Doc__[[IFNoCombatTaskHandler provide a class method to register no-combat task]]
interface "IFNoCombatTaskHandler"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	__Doc__[[
		<desc>Register task to do when no combat</desc>
		<param name="func">function, the task function</param>
		<param name="...">the function's parameters</param>
	]]
	function RegisterNoCombatTask(self, func, ...)
		if type(func) == "function" then
			return RegisterTask(func, ...)
		elseif type(func) == "string" and type(self[func]) == "function" then
			return RegisterTask(self[func], ...)
		end

		error("Usage: Object:RegisterNoCombatTask(func, ...) - 'func' must be function or method name.", 2)
	end

	__Doc__[[
		<desc>Register task to do when no combat</desc>
		<param name="func">function, the task function</param>
		<param name="...">the function's parameters</param>
	]]
	function _RegisterNoCombatTask(func, ...)
		if type(func) == "function" then
			return RegisterTask(func, ...)
		end

		error("Usage: IFNoCombatTaskHandler._RegisterNoCombatTask(func, ...) - 'func' must be function.", 2)
	end
endinterface "IFNoCombatTaskHandler"