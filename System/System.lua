-- System
-- Author: kurapica.igas@gmail.com
-- Create Date : 2011/02/25
-- ChangeLog   :
--               2011/04/24	LocaleString added
--               2011/05/11 ActiveThread method added to Object
--               2011/10/30 ConvertClass method added to Object
--               2011/10/30 HasEvent method added to Object
--               2011/10/31 InactiveThread method added to Object
--               2012/06/12 IsInterface method added to Object
--               2012/07/18 ThreadCall method added to Object
--               2012/07/18 PositiveNumber added to System
--               2013/04/26 Remove assert to reduce cost
--               2013/06/27 Remove the custom event system

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
local version = 16

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

	-- Common Functions
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

format = string.format

function assert(flag, msg, ...)
	if not flag then
		error(format(msg, ...), 2)
	end
end

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
		if type(value) ~= "string" then
			error(format("%s must be a string, got %s.", "%s", type(value)))
		end
		return value
	end
endstruct "String"

------------------------------------------------------
-- Number
------------------------------------------------------
struct "Number"
	function Validate(value)
		if type(value) ~= "number" then
			error(format("%s must be a number, got %s.", "%s", type(value)))
		end
		return value
	end
endstruct "Number"

------------------------------------------------------
-- Function
------------------------------------------------------
struct "Function"
	function Validate(value)
		if type(value) ~= "function" then
			error(format("%s must be a function, got %s.", "%s", type(value)))
		end
		return value
	end
endstruct "Function"

------------------------------------------------------
-- Table
------------------------------------------------------
struct "Table"
	function Validate(value)
		if type(value) ~= "table" then
			error(format("%s must be a table, got %s.", "%s", type(value)))
		end
		return value
	end
endstruct "Table"

------------------------------------------------------
-- Userdata
------------------------------------------------------
struct "Userdata"
	function Validate(value)
		if type(value) ~= "userdata" then
			error(format("%s must be a userdata, got %s.", "%s", type(value)))
		end
		return value
	end
endstruct "Userdata"

------------------------------------------------------
-- Thread
------------------------------------------------------
struct "Thread"
	function Validate(value)
		if type(value) ~= "thread" then
			error(format("%s must be a thread, got %s.", "%s", type(value)))
		end
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
		if type(value) ~= "string" then
			error(format("%s must be a string, got %s.", "%s", type(value)))
		end
		return value
	end
endstruct "LocaleString"

------------------------------------------------------
-- PositiveNumber
------------------------------------------------------
struct "PositiveNumber"
	function Validate(value)
		if type(value) ~= "number" then
			error(format("%s must be a number, got %s.", "%s", type(value)))
		end
		if value <= 0 then
			error("%s must be greater than zero.")
		end
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
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name HasEvent
		@type method
		@desc Check if the event type is supported by the object
		@param name the event's name
		@return boolean true if the object has that event type
	]======]
	function HasEvent(self, name)
		if type(name) ~= "string" then
			error(("Usage : object:HasEvent(name) : 'name' - string expected, got %s."):format(type(name)), 2)
		end
		return Reflector.HasEvent(Reflector.GetObjectClass(self), name) or false
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

	doc [======[
		@name Fire
		@type method
		@desc Fire an object's event, to trigger the object's event handlers
		@param event the event name
		@param ... the event's arguments
		@return nil
	]======]
	function Fire(self, sc, ...)
		if type(sc) ~= "string" then
			error(("Usage : Object:Fire(event [, args, ...]) : 'event' - string exepected, got %s."):format(type(sc)), 2)
		end

		if rawget(self, "__Events") and rawget(self.__Events, sc) then
			return rawget(self.__Events, sc)(self, ...)
		end
	end

	doc [======[
		@name ActiveThread
		@type method
		@desc Active the thread mode for special events
		@format event[, ...]
		@param event the event name
		@param ... other event's name list
		@return nil
	]======]
	function ActiveThread(self, ...)
		return Reflector.ActiveThread(self, ...)
	end

	doc [======[
		@name IsThreadActivated
		@type method
		@desc Check if the thread mode is actived for the event
		@param event the event's name
		@return boolean true if the event is in thread mode
	]======]
	function IsThreadActivated(self, sc)
		return Reflector.IsThreadActivated(self, sc)
	end

	doc [======[
		@name InactiveThread
		@type method
		@desc Turn off the thread mode for the events
		@format event[, ...]
		@param event the event's name
		@param ... other event's name list
		@return nil
	]======]
	function InactiveThread(self, ...)
		return Reflector.InactiveThread(self, ...)
	end

	doc [======[
		@name BlockEvent
		@type method
		@desc Block some events for the object
		@format event[, ...]
		@param event the event's name
		@param ... other event's name list
		@return nil
	]======]
	function BlockEvent(self, ...)
		return Reflector.BlockEvent(self, ...)
	end

	doc [======[
		@name IsEventBlocked
		@type method
		@desc Check if the event is blocked for the object
		@param event the event's name
		@return boolean true if th event is blocked
	]======]
	function IsEventBlocked(self, sc)
		return Reflector.IsEventBlocked(self, sc)
	end

	doc [======[
		@name UnBlockEvent
		@type method
		@desc Un-Block some events for the object
		@format event[, ...]
		@param event the event's name
		@param ... other event's name list
		@return nil
	]======]
	function UnBlockEvent(self, ...)
		return Reflector.UnBlockEvent(self, ...)
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
endclass "Object"