local IGAS_PATH, DIR_SEPT = ...

IGAS_PATH = IGAS_PATH or ""
DIR_SEPT = DIR_SEPT or "\\"

local function Load(...)
	local f, err = loadfile(IGAS_PATH .. table.concat({...}, DIR_SEPT))

	if not f then
		error(err)
	end

	f()
end

Load("Base.lua")
Load("Class", "Class.lua")
Load("System", "System.lua")
Load("System", "Addon.lua")
Load("System", "IFIterator.lua")
Load("System", "Array.lua")
Load("System", "Threading.lua")
Load("System", "Logger.lua")
Load("System", "Locale.lua")
Load("System", "Recycle.lua")
Load("IGAS.lua")