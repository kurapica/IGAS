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

Load("PLoop", "PLoop.lua")
Load("PLoop", "System.lua")
Load("PLoop", "Error.lua")
Load("PLoop", "IFIterator.lua")
Load("PLoop", "Array.lua")
Load("PLoop", "Threading.lua")
Load("PLoop", "Logger.lua")
Load("PLoop", "Recycle.lua")
Load("PLoop", "Xml.lua")