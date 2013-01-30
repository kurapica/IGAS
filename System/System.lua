-- System
-- Author: kurapica.igas@gmail.com
-- Create Date : 2011/02/25
-- ChangeLog   :
--               2011/04/24	LocaleString added
--               2011/05/11 ActiveThread method added to Object
--               2011/10/30 ConvertClass method added to Object
--               2011/10/30 HasScript method added to Object
--               2011/10/31 InactiveThread method added to Object
--               2012/06/12 IsInterface method added to Object
--               2012/07/18 ThreadCall method added to Object
--               2012/07/18 PositiveNumber added to System

------------------------------------------------------------------------
-- The base struct types is defined here
--
--	Boolean
--	String
--	Number
--	Function
--	Table
--	Userdata
--
--	LocaleString
--  PositiveNumber
--
--	The base class is defined here
--
--	Object
------------------------------------------------------------------------
local version = 14

------------------------------------------------------
-- Version Check & Environment
------------------------------------------------------
do
	local _Meta = getmetatable(IGAS)

	-- Version Check
	if _Meta._IGAS_System_Version and _Meta._IGAS_System_Version >= version then
		return
	end

	_Meta._IGAS_System_Version = version

	-- Class Environment
	_Meta._System_ENV = _Meta._System_ENV or {}

	setmetatable(_Meta._System_ENV, {
		__index = function(self,  key)
			if type(key) == "string" and key ~= "_G" and key:find("^_") then
				return
			end

			if _Meta._Class_KeyWords[key] then
				return _Meta._Class_KeyWords[key]
			end

			if _G[key] then
				rawset(self, key, _G[key])
				return rawget(self, key)
			end
		end,
	})

	setfenv(1, _Meta._System_ENV)

	-- Scripts
	strtrim = strtrim or function(s)
	  return (s:gsub("^%s*(.-)%s*$", "%1")) or ""
	end

	wipe = wipe or function(t)
		for k in pairs(t) do
			t[k] = nil
		end
	end

	geterrorhandler = geterrorhandler or function()
		return print
	end

	errorhandler = errorhandler or function(err)
		return geterrorhandler()(err)
	end

	tinsert = tinsert or table.insert
	tremove = tremove or table.remove
end

namespace "System"

------------------------------------------------------
-- Boolean
------------------------------------------------------
struct "Boolean"
	function Validate(value)
		return value and true or false
	end
endstruct "Boolean"

------------------------------------------------------
-- String
------------------------------------------------------
struct "String"
	function Validate(value)
		assert(type(value) == "string", ("%s must be a string, got %s."):format("%s", type(value)))
		return value
	end
endstruct "String"

------------------------------------------------------
-- Number
------------------------------------------------------
struct "Number"
	function Validate(value)
		assert(type(value) == "number", ("%s must be a number, got %s."):format("%s", type(value)))
		return value
	end
endstruct "Number"

------------------------------------------------------
-- Function
------------------------------------------------------
struct "Function"
	function Validate(value)
		assert(type(value) == "function", ("%s must be a function, got %s."):format("%s", type(value)))
		return value
	end
endstruct "Function"

------------------------------------------------------
-- Table
------------------------------------------------------
struct "Table"
	function Validate(value)
		assert(type(value) == "table", ("%s must be a table, got %s."):format("%s", type(value)))
		return value
	end
endstruct "Table"

------------------------------------------------------
-- Userdata
------------------------------------------------------
struct "Userdata"
	function Validate(value)
		assert(type(value) == "userdata", ("%s must be a userdata, got %s."):format("%s", type(value)))
		return value
	end
endstruct "Userdata"

------------------------------------------------------
-- Thread
------------------------------------------------------
struct "Thread"
	function Validate(value)
		assert(type(value) == "thread", ("%s must be a thread, got %s."):format("%s", type(value)))
		return value
	end
endstruct "Thread"

------------------------------------------------------
-- Any
------------------------------------------------------
struct "Any"
	function Validate(value)
		return value
	end
endstruct "Any"

------------------------------------------------------
-- LocaleString
------------------------------------------------------
struct "LocaleString"
	function Validate(value)
		assert(type(value) == "string", ("%s must be a string, got %s."):format("%s", type(value)))
		return value
	end
endstruct "LocaleString"

------------------------------------------------------
-- PositiveNumber
------------------------------------------------------
struct "PositiveNumber"
	function Validate(value)
		assert(type(value) == "number", ("%s must be a number, got %s."):format("%s", type(value)))
		assert(value > 0, ("%s must be greater than zero."):format("%s"))
		return value
	end
endstruct "PositiveNumber"

------------------------------------------------------
-- Object
------------------------------------------------------
class "Object"

	doc [======[
		@name Object
		@type class
		@desc
				The root class of other classes. Object class contains several methodes for common use.
		<br><br>The Object class also provide an event system to help objects sending messages to each others.
		<br>
	]======]

	local create = coroutine.create
	local resume = coroutine.resume
	local status = coroutine.status

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	doc [======[
		@name OnEvent
		@type interface
		@desc Fired when registered event is happened.
		@param event the trigger event name
		@param ... the event's arguments
	]======]
	script "OnEvent"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name HasScript
		@type method
		@desc Check if the script type is supported by the object
		@param name the script's name
		@return boolean true if the object has that script type
	]======]
	function HasScript(self, name)
		if type(name) ~= "string" then
			error(("Usage : object:HasScript(name) : 'name' - string expected, got %s."):format(type(name)), 2)
		end
		return Reflector.HasScript(Reflector.GetObjectClass(self), name) or false
	end

	doc [======[
		@name GetClass
		@type method
		@desc Get the class type of the object
		@return class the object's class
	]======]
	function GetClass(self)
		return Reflector.GetObjectClass(self)
	end

	doc [======[
		@name IsClass
		@type method
		@desc Check if the object is an instance of the class
		@param class
		@return boolean true if the object is an instance of the class
	]======]
	function IsClass(self, cls)
		return Reflector.ObjectIsClass(self, cls)
	end

	doc [======[
		@name IsInterface
		@type method
		@desc Check if the object is extend from the interface
		@param interface
		@return boolean true if the object is extend from the interface
	]======]
	function IsInterface(self, IF)
		return Reflector.ObjectIsInterface(self, IF)
	end

	------------------------------------------------------
	-- Event System
	------------------------------------------------------
	_EventDistrbt = _EventDistrbt or {}
	_EventSource = _EventSource or {}

	-- Weak Table
	_MetaWeak = _MetaWeak or {__mode = "k"}

	doc [======[
		@name RegisterEvent
		@type method
		@desc Register an event
		@param event the event's name
		@return nil
	]======]
	function RegisterEvent(self, event)
		if type(event) == "string" and event ~= "" then
			_EventDistrbt[event] = _EventDistrbt[event] or setmetatable({}, _MetaWeak)

			_EventDistrbt[event][self] = true
		else
			error(("Usage Object: Object:RegisterEvent(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
		end
	end

	doc [======[
		@name IsEventRegistered
		@type method
		@desc Check if the object has registered the event
		@param event the event's name
		@return boolean true if the object has registered the event
	]======]
	function IsEventRegistered(self, event)
		return _EventDistrbt[event] and _EventDistrbt[event][self] or false
	end

	doc [======[
		@name UnregisterAllEvents
		@type method
		@desc Remove all registered events
	]======]
	function UnregisterAllEvents(self)
		for _, s in pairs(_EventDistrbt) do
			s[self] = nil
		end
	end

	doc [======[
		@name UnregisterEvent
		@type method
		@desc Un-register a event for the object
		@param event the event's name
		@return nil
	]======]
	function UnregisterEvent(self, event)
		if _EventDistrbt[event] then
			_EventDistrbt[event][self] = nil
		end
	end

	doc [======[
		@name FireEvent
		@type method
		@desc Fire an event and with it's arguments
		@param event the event's name
		@param ... the event's arguments
		@return nil
	]======]
	function FireEvent(self, event, ...)
		if not _EventDistrbt[event] or _EventSource[event] then
			-- On time one event can only have one source,
			return
		end

		-- Set the event's source
		_EventSource[event] = self

		for obj in pairs(_EventDistrbt[event]) do
			obj:Fire("OnEvent", event, ...)
		end

		-- Finish, clear the event's source
		_EventSource[event] = nil
	end

	doc [======[
		@name Fire
		@type method
		@desc Fire an object's script, to trigger the object's script handlers
		@param script the script name
		@param ... the scipt's arguments
		@return nil
	]======]
	function Fire(self, sc, ...)
		if type(sc) ~= "string" then
			error(("Usage : Object:Fire(script [, args, ...]) : 'script' - string exepected, got %s."):format(type(sc)), 2)
		end

		if rawget(self, "__Scripts") and rawget(self.__Scripts, sc) then
			return rawget(self.__Scripts, sc)(self, ...)
		elseif rawget(self, sc) and type(rawget(self, sc)) == "function" then
			return rawget(self, sc)(self, ...)
		end
	end

	doc [======[
		@name ActiveThread
		@type method
		@desc Active the thread mode for special script
		@format script[, ...]
		@param script the script name
		@param ... other script's name list
		@return nil
	]======]
	function ActiveThread(self, ...)
		return Reflector.ActiveThread(self, ...)
	end

	doc [======[
		@name IsThreadActivated
		@type method
		@desc Check if the thread mode is actived for the script
		@param script the script's name
		@return boolean true if the script is in thread mode
	]======]
	function IsThreadActivated(self, sc)
		return Reflector.IsThreadActivated(self, sc)
	end

	doc [======[
		@name InactiveThread
		@type method
		@desc Turn off the thread mode for the scipts
		@format script[, ...]
		@param script the script's name
		@param ... other script's name list
		@return nil
	]======]
	function InactiveThread(self, ...)
		return Reflector.InactiveThread(self, ...)
	end

	doc [======[
		@name BlockScript
		@type method
		@desc Block some script for the object
		@format script[, ...]
		@param script the script's name
		@param ... other script's name list
		@return nil
	]======]
	function BlockScript(self, ...)
		return Reflector.BlockScript(self, ...)
	end

	doc [======[
		@name IsScriptBlocked
		@type method
		@desc Check if the script is blocked for the object
		@param script the script's name
		@return boolean true if th script is blocked
	]======]
	function IsScriptBlocked(self, sc)
		return Reflector.IsScriptBlocked(self, sc)
	end

	doc [======[
		@name UnBlockScript
		@type method
		@desc Un-Block some scripts for the object
		@format script[, ...]
		@param script the script's name
		@param ... other script's name list
		@return nil
	]======]
	function UnBlockScript(self, ...)
		return Reflector.UnBlockScript(self, ...)
	end

	doc [======[
		@name ThreadCall
		@type method
		@desc Call method or function as a thread
		@param methodname|function
		@param ... the arguments
		@return nil
	]======]
	function ThreadCall(self, method, ...)
		if type(method) == "string" then
			method = self[method]
		end

		if type(method) == "function" then
			local thread = create(method)
			return resume(thread, self, ...)
		end
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		UnregisterAllEvents(self)
	end
endclass "Object"