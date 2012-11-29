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
	-- extend "IFDispose" -- not really need to extend IFDispose, just use it
	
	local create = coroutine.create
	local resume = coroutine.resume
	local status = coroutine.status

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	script "OnEvent"

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------
	--- Check if the script type is supported by the frame
	-- @name Object:HasScript
	-- @class function
	-- @param name the script type's name
	-- @return true if the frame has that script type
	-- @usage Object:HasScript("OnEnter")
	------------------------------------
	function HasScript(self, name)
		if type(name) ~= "string" then
			error(("Usage : Object:HasScript(name) : 'name' - string expected, got %s."):format(type(name)), 2)
		end
		return Reflector.HasScript(Reflector.GetObjectClass(self), name) or false
	end
	
	------------------------------------
	--- Get the class type of this object
	-- @name Object:GetClass
	-- @class function
	-- @usage Object:GetClass()
	------------------------------------
	function GetClass(self)
		return Reflector.GetObjectClass(self)
	end

	------------------------------------
	--- Check if this object is an instance of the class
	-- @name Object:IsClass
	-- @class function
	-- @param class	the class type that you want to check if this object is an instance of.
	-- @usage Object:IsClass(Object)
	------------------------------------
	function IsClass(self, cls)
		return Reflector.ObjectIsClass(self, cls)
	end

	------------------------------------
	--- Check if this object is an instance of the interface
	-- @name Object:IsInterface
	-- @class function
	-- @param IF the interface type that you want to check if this object is an instance of.
	-- @usage Object:IsInterface(Object)
	------------------------------------
	function IsInterface(self, IF)
		return Reflector.ObjectIsInterface(self, IF)
	end
	
	------------------------------------
	--- Dispose this object
	-- @name Object:Dispose
	-- @class function
	-- @usage Object:Dispose()
	------------------------------------
	function Dispose(self)
		UnregisterAllEvents(self)
	end

	------------------------------------------------------
	-- Event System
	------------------------------------------------------
	_EventDistrbt = _EventDistrbt or {}
	_EventSource = _EventSource or {}

	-- Weak Table
	_MetaWeak = _MetaWeak or {__mode = "k"}

	------------------------------------
	--- Register an event
	-- @name Object:RegisterEvent
	-- @class function
	-- @param event the event's name
	-- @return nil
	-- @usage Object:RegisterEvent("CUSTOM_EVENT_1")
	------------------------------------
	function RegisterEvent(self, event)
		if type(event) == "string" and event ~= "" then
			_EventDistrbt[event] = _EventDistrbt[event] or setmetatable({}, _MetaWeak)

			_EventDistrbt[event][self] = true
		else
			error(("Usage Object: Object:RegisterEvent(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
		end
	end

	------------------------------------
	--- Check if  a event is registered for an object
	-- @name Object:IsEventRegistered
	-- @class function
	-- @param event the event's name
	-- @return true if the event is registered to that object
	-- @usage Object:IsEventRegistered("CUSTOM_EVENT_1")
	------------------------------------
	function IsEventRegistered(self, event)
		return _EventDistrbt[event] and _EventDistrbt[event][self] or false
	end

	------------------------------------
	--- Undo register all events for the object
	-- @name Object:UnregisterAllEvents
	-- @class function
	-- @return nil
	-- @usage Object:UnregisterAllEvents()
	------------------------------------
	function UnregisterAllEvents(self)
		for _, s in pairs(_EventDistrbt) do
			s[self] = nil
		end
	end

	------------------------------------
	--- Undo Register an event for an object
	-- @name Object:UnregisterEvent
	-- @class function
	-- @param event the event's name
	-- @return nil
	-- @usage Object:UnregisterEvent("CUSTOM_EVENT_1")
	------------------------------------
	function UnregisterEvent(self, event)
		if _EventDistrbt[event] then
			_EventDistrbt[event][self] = nil
		end
	end

	------------------------------------
	--- Fire an event
	-- @name Object:FireEvent
	-- @class function
	-- @param event the event's name, must not be a system event's name
	-- @param ... the parameters for the event
	-- @return nil
	-- @usage Object:FireEvent("CUSTOM_EVENT_1", arg1, arg2, arg3, ...)
	------------------------------------
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

	------------------------------------
	--- Fire script, to trigger the object's script handlers
	-- @name Object:Fire
	-- @class function
	-- @param scriptType the script type to be triggered
	-- @param ... the parameters
	-- @usage Object:Fire("OnChoose", 1)
	------------------------------------
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

	------------------------------------
	--- Active thread mode for special scripts.
	-- @name Object:ActiveThread
	-- @class function
	-- @param ... script name list
	-- @usage Object:ActiveThread("OnClick", "OnEnter")
	------------------------------------
	function ActiveThread(self, ...)
		return Reflector.ActiveThread(self, ...)
	end

	------------------------------------
	--- Whether the thread mode is actived for special scripts.
	-- @name Object:IsThreadActived
	-- @class function
	-- @param obj object
	-- @param script
	-- @usage Object:IsThreadActived("OnClick")
	------------------------------------
	function IsThreadActived(self, sc)
		return Reflector.IsThreadActived(self, sc)
	end

	------------------------------------
	--- Inactive thread mode for special scripts.
	-- @name InactiveThread
	-- @class function
	-- @param obj object
	-- @param ... script name list
	-- @usage Object:InactiveThread("OnClick", "OnEnter")
	------------------------------------
	function InactiveThread(self, ...)
		return Reflector.InactiveThread(self, ...)
	end

	------------------------------------
	--- Block script for object
	-- @name Object:BlockScript
	-- @class function
	-- @param ... script name list
	-- @usage Object:BlockScript("OnClick", "OnEnter")
	------------------------------------
	function BlockScript(self, ...)
		return Reflector.BlockScript(self, ...)
	end

	------------------------------------
	--- Whether the script is blocked for object
	-- @name Object:IsScriptBlocked
	-- @class function
	-- @param obj object
	-- @param script
	-- @usage Object:IsScriptBlocked("OnClick")
	------------------------------------
	function IsScriptBlocked(self, sc)
		return Reflector.IsScriptBlocked(self, sc)
	end

	------------------------------------
	--- Un-Block script for object
	-- @name UnBlockScript
	-- @class function
	-- @param obj object
	-- @param ... script name list
	-- @usage Object:UnBlockScript("OnClick", "OnEnter")
	------------------------------------
	function UnBlockScript(self, ...)
		return Reflector.UnBlockScript(self, ...)
	end
	
	------------------------------------
	--- Convert the object to a new class.
	-- @name ConvertClass
	-- @class function
	-- @param cls class
	-- @usage Object:ConvertClass(System.Addon)
	------------------------------------
	function ConvertClass(self, ns)
		return Reflector.ConvertClass(self, ns)
	end

	------------------------------------
	--- Call method as thread, self would be the first arg to the method
	-- @name ThreadCall
	-- @class function
	-- @param method method or method name
	-- @param ... arguments
	-- @usage Object:ThreadCall("Show")
	------------------------------------
	function ThreadCall(self, method, ...)
		if type(method) == "string" then
			method = self[method]
		end
		
		if type(method) == "function" then
			local thread = create(method)
			return resume(thread, self, ...)
		end
	end
	
	------------------------------------
	--- Create a new instance of the Object
	-- @name Object
	-- @class function
	-- @return object
	-- @usage obj = Object()
	------------------------------------
	function Object()
		return {}
	end

endclass "Object"