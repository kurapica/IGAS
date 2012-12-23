-- Author      : Kurapica
-- Create Date : 2011/02/28
-- ChangeLog   :
--				2011/03/17	the msg can be formatted string.

----------------------------------------------------------------------------------------------------------------------------------------
--- Logger class used to keep logs for debugging.
-- @name Logger
-- @class table
-- @field LogLevel the logging system's loglevel, if log message's loglevel is lower than Logger.LogLevel, that message will be discarded.
-- @field MaxLog the log message will be stored in the Logger temporarily , you can using Logger[1], Logger[2] to access it, the less index the newest log message.When the message number is passed Logger.MaxLog, the oldest messages would be discarded, the default MaxLog is 1.
-- @field TimeFormat if the timeformat is setted, the log message will add a timestamp at the header.<br><br>
-- Time Format:<br>
-- %a	abbreviated weekday name (e.g., Wed)<br>
-- %A	full weekday name (e.g., Wednesday)<br>
-- %b	abbreviated month name (e.g., Sep)<br>
-- %B	full month name (e.g., September)<br>
-- %c	date and time (e.g., 09/16/98 23:48:10)<br>
-- %d	day of the month (16) [01-31]<br>
-- %H	hour, using a 24-hour clock (23) [00-23]<br>
-- %I	hour, using a 12-hour clock (11) [01-12]<br>
-- %M	minute (48) [00-59]<br>
-- %m	month (09) [01-12]<br>
-- %p	either "am" or "pm" (pm)<br>
-- %S	second (10) [00-61]<br>
-- %w	weekday (3) [0-6 = Sunday-Saturday]<br>
-- %x	date (e.g., 09/16/98)<br>
-- %X	time (e.g., 23:48:10)<br>
-- %Y	full year (1998)<br>
-- %y	two-digit year (98) [00-99]<br>
----------------------------------------------------------------------------------------------------------------------------------------

local version = 6

if not IGAS:NewAddon("IGAS.Logger", version) then
	return
end

namespace "System"

floor = math.floor

class "Logger"
	inherit "Object"

	_Logger = _Logger or {}
	_Info = _Info or setmetatable({}, {__mode = "k"})

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	script "OnHandlerChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Dispose this object
	-- @name Object:Dispose
	-- @class function
	-- @usage Object:Dispose()
	------------------------------------
	function Dispose(self)
		_Logger[_Info[self].Name] = nil
		_Info[self] = nil
		return Object.Dispose(self)
	end

	------------------------------------
	--- output message
	-- @name Logger:Log
	-- @class function
	-- @param loglevel the output message's loglevel, if lower than Logger.LogLevel, the message will be discarded.
	-- @param message the output message(can be formatted string )
	-- @param ... A list of values to be included in the formatted string
	-- @return nil
	-- @usage Logger:Log(1, "Something wrong")
	------------------------------------
	function Log(self, logLvl, msg, ...)
		if type(logLvl) ~= "number" then
			error(("Usage Logger:Log(logLvl, msg, ...) : logLvl - number expected, got %s."):format(type(logLvl)), 2)
		end

		if type(msg) ~= "string" then
			error(("Usage Logger:Log(logLvl, msg, ...) : msg - string expected, got %s."):format(type(msg)), 2)
		end

		if logLvl >= self.LogLevel then
			-- Prefix and TimeStamp
			local prefix = self.TimeFormat and date(self.TimeFormat)

			if not prefix or type(prefix) ~= "string" then
				prefix = ""
			end

			if prefix ~= "" and not strmatch(prefix, "^%[.*%]$") then
				prefix = "["..prefix.."]"
			end

			prefix = prefix..(_Info[self].Prefix[logLvl] or "")

			if select('#', ...) > 0 then
				msg = msg:format(...)
			end

			msg = prefix..msg

			-- Save message to pool
			local pool = _Info[self].Pool
			pool[pool.EndLog] = msg
			pool.EndLog = pool.EndLog + 1

			-- Remove old message
			while pool.EndLog - pool.StartLog - 1 > self.MaxLog do
				pool.StartLog = pool.StartLog + 1
				pool[pool.StartLog] = nil
			end

			-- Send message to handlers
			local chk, err

			for handler, lvl in pairs(_Info[self].Handler) do
				if lvl == true or lvl == logLvl then
					chk, err = pcall(handler, msg)
					if not chk then
						errorhandler(err)
					end
				end
			end
		end
	end

	------------------------------------
	--- Add a log handler, the handler must be a function and receive <b>message</b> as arg.
	-- @name Logger:AddHandler
	-- @class function
	-- @param handler a function to handle the log message
	-- @param [loglevel] binding log level
	-- @return nil
	-- @usage Logger:AddHandler(print) -- this would print the message out to the ChatFrame
	------------------------------------
	function AddHandler(self, handler, loglevel)
		if type(handler) == "function" then
			if not _Info[self].Handler[handler] then
				_Info[self].Handler[handler] = loglevel and tonumber(loglevel) or true
				self:Fire("OnHandlerChanged", handler, "ADD")
			end
		else
			error(("Usage : Logger:AddHandler(handler) : 'handler' - function expected, got %s."):format(type(handler)), 2)
		end
	end

	------------------------------------
	--- Remove a log handler
	-- @name Logger:RemoveHandler
	-- @class function
	-- @param handler a function to handle the log message
	-- @return nil
	-- @usage Logger:RemoveHandler(print) -- this would print the message out to the ChatFrame
	------------------------------------
	function RemoveHandler(self, handler)
		if type(handler) == "function" then
			if _Info[self].Handler[handler] then
				_Info[self].Handler[handler] = nil
				self:Fire("OnHandlerChanged", handler, "REMOVE")
			end
		else
			error(("Usage : Logger:RemoveHandler(handler) : 'handler' - function expected, got %s."):format(type(handler)), 2)
		end
	end

	------------------------------------
	--- Set a prefix for a log level, the prefix will be added to the message when the message is that log level.
	-- @name Logger:SetPrefix
	-- @class function
	-- @param logLevel the log message's level
	-- @param prefix the prefix string
	-- @param [method] method name
	-- @return nil
	-- @usage Logger:SetPrefix(1, "[DEBUG]") -- this would print the message out to the ChatFrame
	------------------------------------
	function SetPrefix(self, loglvl, prefix, method)
		if type(prefix) == "string" then
			if not prefix:match("%W+$") then
				prefix = prefix.." "
			end
		else
			prefix = nil
		end
		_Info[self].Prefix[loglvl] = prefix

		-- Register
		if type(method) == "string" then
			local fenv = getfenv(2)

			if not fenv[method] then
				fenv[method] = function(msg)
					return self:Log(loglvl, msg)
				end
			end
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- LogLevel
	property "LogLevel" {
		Set = function(self, lvl)
			if lvl < 0 then lvl = 0 end

			_Info[self].LogLevel = floor(lvl)
		end,
		Get = function(self)
			return _Info[self].LogLevel or 0
		end,
		Type = Number,
	}
	-- MaxLog
	property "MaxLog" {
		Set = function(self, maxv)
			if maxv < 1 then maxv = 1 end

			maxv = floor(maxv)

			_Info[self].MaxLog = maxv

			local pool = _Info[self].Pool

			while pool.EndLog - pool.StartLog - 1 > maxv do
				pool.StartLog = pool.StartLog + 1
				pool[pool.StartLog] = nil
			end
		end,
		Get = function(self)
			return _Info[self].MaxLog or 1
		end,
		Type = Number,
	}
	-- TimeFormat
	property "TimeFormat" {
		Set = function(self, timeFormat)
			if timeFormat and type(timeFormat) == "string" and timeFormat ~= "*t" then
				_Info[self].TimeFormat = timeFormat
			else
				_Info[self].TimeFormat = nil
			end
		end,
		Get = function(self)
			return _Info[self].TimeFormat
		end,
		Type = String + nil,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Logger(self, name)
		if type(name) ~= "string" then
			error(("Usage : Logger(name) : 'name' - string expected, got %s."):format(type(name)), 2)
		end

		name = name:match("[_%w]+")

		if not name or name == "" then return end

		_Logger[name] = self

		_Info[self] = {
			Owner = self,
			Name = name,
			Pool = {["StartLog"] = 0, ["EndLog"] = 1},
			Handler = {},
			Prefix = {},
		}
	end

	------------------------------------------------------
	-- Exist checking
	------------------------------------------------------
	function __exist(name)
		if type(name) ~= "string" then
			return
		end

		name = name:match("[_%w]+")

		return name and _Logger[name]
	end

	------------------------------------------------------
	-- __index for class instance
	------------------------------------------------------
	function __index(self, key)
		if type(key) == "number" and key >= 1 then
			key = floor(key)

			return _Info[self].Pool[_Info[self].Pool.EndLog - key]
		end
	end

	------------------------------------------------------
	-- __newindex for class instance
	------------------------------------------------------
	function __newindex(self, key, value)
		-- nothing to do
		error("a logger is readonly.", 2)
	end

	------------------------------------------------------
	-- __len for class instance
	------------------------------------------------------
	function __len(self)
		return _Info[self].Pool.EndLog - _Info[self].Pool.StartLog - 1
	end

	------------------------------------------------------
	-- __call for class instance
	------------------------------------------------------
	function __call(self, loglvl, msg, ...)
		return self:Log(loglvl, msg, ...)
	end
endclass "Logger"

------------------------------------------------------
-- Global Settings
------------------------------------------------------

------------------------------------
--- Create or get the logger for the given log name
-- @name IGAS:NewLogger
-- @class function
-- @param name always be the addon's name, using to manage an addon's message
-- @return Logger used for the log name
-- @usage IGAS:NewLogger("IGAS")
------------------------------------
function IGAS:NewLogger(name)
	return Logger(name)
end
