-- Author		:	Kurapica
-- Create Date	:	2011/01/21

local version = 2

IGAS = IGAS or setmetatable({}, {})

local _Meta = getmetatable(IGAS)

------------------------------------------------------
-- Version Check
------------------------------------------------------
if _Meta._IGAS_Version and _Meta._IGAS_Version >= version then
	return
end
_Meta._IGAS_Version = version

------------------------------------------------------
-- Class System KeyWords
------------------------------------------------------
_Meta._Class_KeyWords = _Meta._Class_KeyWords or {}

------------------------------------------------------
-- MetaTable for IGAS
------------------------------------------------------
do
	-- __call
	_Meta.__call = function(self, name)
		if rawget(self, "GetAddon") and name and type(name) == "string" and name ~= "" then
			return self:GetAddon(name)
		end
	end
	
	-- __index
	_Meta.__index = function(self, key)
		if rawget(self, "GetWrapper") and _G[key] then
			local frame = _G[key]
			
			if type(frame) == "table" and type(frame[0]) == "userdata" and frame.GetObjectType then
				rawset(self, key, self:GetWrapper(frame))
				return rawget(self, key)
			end
		elseif rawget(self, "GetNameSpace") and type(key) == "string" then
			return self:GetNameSpace(key)
		end
	end
end
