-- IGAS
-- In-Game Addon System
-- Author: kurapica.igas@gmail.com
-- Create Date : 2011/03/01
-- ChangeLog   :

local version = 3

if not IGAS:NewAddon("IGAS", version) then
	return
end

----------------------------------------------
-- Addon Initialize
----------------------------------------------
-- Keep this setting for gui lib, no need to set _AutoWrapper in other addons.
_AutoWrapper = false

----------------------------------------------
-- Looger
----------------------------------------------
Log = IGAS:NewLogger("IGAS")

Log.TimeFormat = "%X"
Log:SetPrefix(1, "[IGAS][Trace]")
Log:SetPrefix(2, "[IGAS][Debug]")
Log:SetPrefix(3, "[IGAS][Info]")
Log:SetPrefix(4, "[IGAS][Warn]")
Log:SetPrefix(5, "[IGAS][Error]")
Log:SetPrefix(6, "[IGAS][Fatal]")
Log.LogLevel = 3

Log:AddHandler(print)

----------------------------------------------
-- Short API
----------------------------------------------
strlen = string.len
strformat = string.format
strfind = string.find
strsub = string.sub
strbyte = string.byte
strchar = string.char
strrep = string.rep
strsub = string.gsub
strupper = string.upper
strtrim = strtrim or function(s)
  return (s:gsub("^%s*(.-)%s*$", "%1")) or ""
end
strmatch = string.match

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

tblconcat = table.concat
tinsert = tinsert or table.insert
tremove = tremove or table.remove

floor = math.floor
ceil = math.ceil
log = math.log
pow = math.pow
min = math.min
max = math.max
random = math.random

date = date or (os and os.date)

----------------------------------------------
-- Localization
----------------------------------------------
L = IGAS:NewLocale("IGAS")

----------------------------------------------
-- Event Handler
----------------------------------------------
function OnLoad(self)
	-- SavedVariables
	self:AddSavedVariable("IGAS_DB")
	self:AddSavedVariable("IGAS_DB_Char")

	-- Log Level
	if type(IGAS_DB.LogLevel) == "number" then
		Log.LogLevel = IGAS_DB.LogLevel
	end

	-- Slash command
	self:AddSlashCmd("/igas")
end

function OnSlashCmd(self, option, info)
	if option and option:lower() == "log" then
		if tonumber(info) then
			Log.LogLevel = tonumber(info)
			IGAS_DB.LogLevel = Log.LogLevel

			Log(3, "%s's LogLevel is switched to %d.", _Name, Log.LogLevel)
		else
			Log(3, "%s's LogLevel is %d for now.", _Name, Log.LogLevel)
		end
	end
end

local _Copyed = {}

local function CopySubTable(src, dest)
	dest = dest or {}

	for i, v in pairs(src) do
		if type(v) == "table" then
			_Copyed[v] = _Copyed[v] or CopySubTable(v)
			dest[i] = _Copyed[v]
		else
			dest[i] = v
		end
	end

	return dest
end

function CopyTable(src, dest)
	wipe(_Copyed)
	dest = CopySubTable(src, dest)
	wipe(_Copyed)

	return dest
end

function IGAS:CopyTable(...)
	return CopyTable(...)
end