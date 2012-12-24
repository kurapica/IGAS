-- Author      : Kurapica
-- Create Date : 2011/02/28
-- ChangeLog   :
--               2011/10/24 can use code like L"XXXX".

----------------------------------------------------------------------------------------------------------------------------------------
--- Locale is used to store local text for addons.
-- @name Local
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

local version = 3

if not IGAS:NewAddon("IGAS.Locale", version) then
	return
end

namespace "System"

class "Locale"
	_Locale = _Locale or {}

	_GameLocale = GetLocale and GetLocale() or "enUS"
	if _GameLocale == "enGB" then
		_GameLocale = "enUS"
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Locale(self, name, language, asDefault)
		if type(name) ~= "string" then
			error(("Usage : Local(name[, language, asDefault]) : 'name' - string expected, got %s."):format(type(name)), 2)
		end

		if language ~= nil and type(language) ~= "string" then
			error(("Usage : Local(name[, language, asDefault]) : 'language' - string expected, got %s."):format(type(language)), 2)
		end

		name = name:match("%S+")

		if not name or name == "" then return end

		if not asDefault and language and language:lower() ~= _GameLocale:lower() then
			return
		end

		_Locale[name] = self
	end

	------------------------------------------------------
	-- Exist checking
	------------------------------------------------------
	function __exist(name, language, asDefault)
		if type(name) ~= "string" then
			return
		end

		if language ~= nil and type(language) ~= "string" then
			return
		end

		name = name:match("%S+")

		if not name or name == "" then return end

		if not asDefault and language and language:lower() ~= _GameLocale:lower() then
			return
		end

		return _Locale[name]
	end

	------------------------------------------------------
	-- __index for class instance
	------------------------------------------------------
	function __index(self, key)
		if type(key) == "string" then
			rawset(self, key, key)
			return rawget(self, key)
		else
			error(("No '%s' keeped in the locale table."):format(tostring(key)))
		end
	end

	------------------------------------------------------
	-- __newindex for class instance
	------------------------------------------------------
	function __newindex(self, key, value)
		if type(key) ~= "number" and type(key) ~= "string" then
			error("Locale[key] = value : 'key' - number or string expected.")
		end

		if type(value) == "string" or ( type(key) == "string" and value == true ) then
			value = (value == true and key) or value
			rawset(self, key, value)
		else
			error("Locale[key] = value : 'value' - tring expected.")
		end
	end

	------------------------------------------------------
	-- __call for class instance
	------------------------------------------------------
	function __call(self, key)
		return self[key]
	end
endclass "Locale"

------------------------------------------------------
-- Global Settings
------------------------------------------------------

------------------------------------
--- Create or get a localization file
-- @name IGAS:NewLocale
-- @class function
-- @param name always be the addon's name
-- @param language the language' name, such as "zhCN"
-- @param asDefault if this language is default, always set to true if the locale is "enUS"
-- @return if "locale" is setted and equal to the game's version or "isDefault" is true, return the local table, else nil
-- @usage L = IGAS:NewLocale("HelloWorld", "zhCN")
------------------------------------
function IGAS:NewLocale(name, language, asDefault)
	return Locale(name, language, asDefault)
end