-- Author      : Kurapica
-- Create Date : 2012/08/10
-- ChangeLog   :

---------------------------------------------------------------
--- IFIterator
-- @type Interface
-- @name IFIterator
---------------------------------------------------------------

local version = 2

if not IGAS:NewAddon("IGAS.IFIterator", version) then
	return
end

namespace "System"

interface "IFIterator"
	local function SetObjectProperty(self, prop, value)
		self[prop] = value
	end

	------------------------------------------------------
	-- Enum
	------------------------------------------------------
	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Get the next element, Overridable
	-- @name Next
	-- @class function
	-- @param key
	-- @return nextFunc
	-- @return self
	-- @return firstKey
	------------------------------------
	function Next(self, key)
		return next, self, key and self[key] ~= nil and key or nil
	end

	------------------------------------
	--- Each elements to do
	-- @name EachK
	-- @class function
	-- @param key the index to start operation
	-- @param oper
	-- @param ...
	------------------------------------
	function EachK(self, key, oper, ...)
		if not oper then return end

		local chk, ret

		if type(oper) == "function" then
			-- Using direct
			for _, item in self:Next(key) do
				chk, ret = pcall(oper, item, ...)
				if not chk then
					errorhandler(ret)
				end
			end
		elseif type(oper) == "string" then
			for _, item in self:Next(key) do
				if type(item) == "table" then
					local cls = Object.GetClass(item)

					if cls then
						if type(rawget(item, oper)) == "function" or (rawget(item, oper) == nil and type(cls[oper]) == "function") then
							-- Check method first
							chk, ret = pcall(item[oper], item, ...)
							if not chk then
								errorhandler(ret)
							end
						else
							chk, ret = pcall(SetObjectProperty, item, oper, ...)
							if not chk then
								errorhandler(ret)
							end
						end
					else
						if type(item[oper]) == "function" then
							-- Check method first
							chk, ret = pcall(item[oper], item, ...)
							if not chk then
								errorhandler(ret)
							end
						else
							chk, ret = pcall(SetObjectProperty, item, oper, ...)
							if not chk then
								errorhandler(ret)
							end
						end
					end
				end
			end
		end
	end

	------------------------------------
	--- Each elements to do
	-- @name Each
	-- @class function
	-- @param oper
	-- @param ...
	------------------------------------
	function Each(self, oper, ...)
		return EachK(self, nil, oper, ...)
	end

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	------------------------------------------------------
	-- Property
	------------------------------------------------------
	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endinterface "IFIterator"
