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

Load("Loop", "Class.lua")
Load("Loop", "Error.lua")
Load("Loop", "IFIterator.lua")
Load("Loop", "Array.lua")
Load("Loop", "Threading.lua")
Load("Loop", "Logger.lua")
Load("Loop", "Recycle.lua")