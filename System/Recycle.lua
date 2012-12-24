-- Author      : Kurapica
-- Create Date : 2012/08/31
-- ChangeLog   :

local version = 1

if not IGAS:NewAddon("IGAS.Recycle", version) then
	return
end

namespace "System"

-----------------------------------------------
--- Recycle
-- @type class
-- @name Recycle
-----------------------------------------------
class "Recycle"
	inherit "Object"

	_RecycleInfo = _RecycleInfo or setmetatable({}, {__mode = "k",})

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	script "OnPush"
	script "OnPop"
	script "OnInit"

	_Args = {}
	local function parseArgs(self)
		if not _RecycleInfo[self] or not _RecycleInfo[self].Args then
			return
		end

		local index = _RecycleInfo[self].Index or 1
		_RecycleInfo[self].Index = index + 1

		wipe(_Args)

		for _, arg in ipairs(_RecycleInfo[self].Args) do
			if type(arg) == "string" and arg:find("%%d") then
				arg = arg:format(index)
			end

			tinsert(_Args, arg)
		end

		return unpack(_Args)
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Push object in recycle bin
	-- @name Push
	-- @type function
	-- @param obj
	-- @return nil
	------------------------------------
	function Push(self, obj)
		if obj then
			-- Won't check obj because using cache means want quick-using.
			tinsert(self, obj)
			if _RecycleInfo[self] then
				return self:Fire("OnPush", obj)
			end
		end
	end

	------------------------------------
	--- Pop object from recycle bin
	-- @name Pop
	-- @type function
	-- @return obj
	------------------------------------
	function Pop(self)
		-- give out item
		if #self > 0 then
			if _RecycleInfo[self] then
				self:Fire("OnPop", self[#self])
			end
			return tremove(self, #self)
		end

		-- create new
		if not _RecycleInfo[self] then
			return {}
		else
			local obj = _RecycleInfo[self].Type(parseArgs(self))

			self:Fire("OnInit", obj)

			self:Fire("OnPop", obj)

			return obj
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function Recycle(self, cls, ...)
		if type(cls) == "string" then
			cls = Reflector.ForName(cls)
		end

		if cls and Reflector.IsClass(cls) then
			_RecycleInfo[self] = {
				Type = cls,
				Args = select('#', ...) > 0 and {...},
			}
		elseif cls and Reflector.IsStruct(cls) then
			_RecycleInfo[self] = {
				Type = cls,
				Args = select('#', ...) > 0 and {...},
			}
		end
    end

	------------------------------------------------------
	-- __call
	------------------------------------------------------
	function __call(self, obj)
		if obj then
			Push(self, obj)
		else
			return Pop(self)
		end
	end
endclass "Recycle"