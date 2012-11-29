-- Author      : Kurapica
-- Create Date : 2012/02/08
-- ChangeLog   :
--               2012/05/06 Push, Pop, Shift, Unshift added
--               2012/07/31 Struct supported
--               2012/09/18 Contain method added
----------------------------------------------------------------------------------------------------------------------------------------
--- Array
-- @name Array
----------------------------------------------------------------------------------------------------------------------------------------

local version = 6

if not IGAS:NewAddon("IGAS.Array", version) then
	return
end

namespace "System"

geterrorhandler = geterrorhandler

errorhandler = errorhandler or function(err)
	return geterrorhandler and geterrorhandler()(err) or print(err)
end

class "Array"
	extend "IFIterator"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Local functions
	------------------------------------------------------
	MAX_STACK = 100

	_ArrayInfo = _ArrayInfo or setmetatable({}, {__mode = "k",})

	local function defaultComp(t1, t2)
		return t1 < t2
	end

	local function bubble_sort(self, start, last, comp)
		start = start or 1
		last = last or #self
		comp = comp or defaultComp

		local chk = true
		local j

		if last > #self then last = #self end

		while last > start and chk do
			chk = false

			for i = start, last - 1 do
				if comp(self[i+1], self[i]) then
					self[i], self[i+1] = self[i+1], self[i]
					chk = true
				end

				j = last - (i - start)

				if comp(self[j], self[j - 1]) then
					self[j], self[j - 1] = self[j - 1], self[j]
					chk = true
				end
			end

			start = start  + 1
			last = last - 1
		end
	end

	local function buildLoserTree(tmp, loserTree, start, comp, pos)
		if pos >= start then
			return pos - start
		end

		local left = buildLoserTree(tmp, loserTree, start, comp, 2 * pos)
		local right = buildLoserTree(tmp, loserTree, start, comp, 2 * pos + 1)

		if comp(tmp[left * MAX_STACK + 1], tmp[right * MAX_STACK + 1]) then
			loserTree[pos] = right
			return left
		else
			loserTree[pos] = left
			return right
		end
	end

	local function adjustLoserTree(tmp, loserTree, grpPos, comp, pos, minGrp)
		if pos == 0 then return minGrp end

		local parentGrp = loserTree[pos]

		if grpPos[minGrp] > MAX_STACK then
			loserTree[pos] = minGrp
			return adjustLoserTree(tmp, loserTree, grpPos, comp, floor(pos/2), parentGrp)
		elseif grpPos[parentGrp] > MAX_STACK then
			return adjustLoserTree(tmp, loserTree, grpPos, comp, floor(pos/2), minGrp)
		elseif comp(tmp[minGrp * MAX_STACK + grpPos[minGrp]], tmp[parentGrp * MAX_STACK + grpPos[parentGrp]]) then
			return adjustLoserTree(tmp, loserTree, grpPos, comp, floor(pos/2), minGrp)
		else
			loserTree[pos] = minGrp
			return adjustLoserTree(tmp, loserTree, grpPos, comp, floor(pos/2), parentGrp)
		end
	end


	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------
	--- Sort table
	-- @name Array:Sort
	-- @class function
	-- @param optional compare function
	-- @usage System.Array.Sort(tbl) || Array:Sort(func)
	------------------------------------
	function Sort(self, comp)
		if type(comp) ~= "function" then comp = defaultComp end

		if #self <= MAX_STACK then
			return bubble_sort(self, 1, #self, comp)
		end

		local tmp = {}
		local len = #self

		for i = 1, len do
			tinsert(tmp, self[i])
		end

		local grp = 0

		while grp * MAX_STACK < len do
			bubble_sort(tmp, grp * MAX_STACK + 1, (grp + 1) * MAX_STACK, comp)
			grp = grp + 1
		end

		-- Build Loser Tree
		local loserTree = {}
		local grpPos = {}
		local minGrp = nil

		-- Init parent node
		for i = 1, grp - 1 do
			loserTree[i] = -1
		end

		-- Init leaf node
		for i = 0, grp - 1 do
			loserTree[grp + i] = i
			grpPos[i] = 1
		end

		-- Init Loser Tree
		minGrp = buildLoserTree(tmp, loserTree, grp, comp, 1)

		-- Sort
		local index = 1

		while index <= len do
			-- set data
			self[index] = tmp[minGrp * MAX_STACK + grpPos[minGrp]]
			grpPos[minGrp] = grpPos[minGrp] + 1

			if minGrp == (grp - 1) and (minGrp * MAX_STACK + grpPos[minGrp] > len) then
				grpPos[minGrp] = MAX_STACK + 1
			end

			index = index + 1

			-- get new min group
			minGrp = adjustLoserTree(tmp, loserTree, grpPos, comp, floor((grp + minGrp)/2), minGrp)
		end
	end

	------------------------------------
	--- Insert table
	-- @name Array:Insert
	-- @class function
	-- @param index
	-- @param value
	-- @usage Array:Insert(1, "test")
	------------------------------------
	function Insert(self, ...)
		if select('#', ...) == 2 then
			local index, value = ...

			if type(index) ~= "number" then
				error("Usage: Array:Insert([index], value) - index must be a number.", 2)
			end

			if value == nil then
				error("Usage: Array:Insert([index], value) - value must not be nil.", 2)
			end

			if index < 1 then
				error("Usage: Array:Insert([index], value) - index must be greater than 0.", 2)
			end

			if index > #self + 1 then index = #self + 1 end

			for i, obj in ipairs(self) do
				if obj == value then
					return i
				end
			end

			if _ArrayInfo[self] and _ArrayInfo[self].IsClass and _ArrayInfo[self].Type then
				if Reflector.ObjectIsClass(value, _ArrayInfo[self].Type) then
					for _, sc in ipairs(Reflector.GetScripts(_ArrayInfo[self].Type)) do
						if _ArrayInfo[self]["_ArrayActive_" .. sc] then
							Reflector.ActiveThread(value, sc)
						end
						if _ArrayInfo[self]["_ArrayBlock_" .. sc] then
							Reflector.BlockScript(value, sc)
						end

						if _ArrayInfo[self][sc] then
							value[sc] = _ArrayInfo[self][sc]
						end
					end
				else
					error(("Usage: Array:Insert([index], value) - value must be %s."):format(Reflector.GetFullName(_ArrayInfo[self].Type)), 2)
				end
			elseif _ArrayInfo[self] and _ArrayInfo[self].IsStruct and _ArrayInfo[self].Type then
				value = Reflector.Validate(_ArrayInfo[self].Type, value, "value", "Usage: Array:Insert([index], value) - ")
			end

			tinsert(self, index, value)

			return index
		elseif select('#', ...) == 1 then
			local value = ...

			if _ArrayInfo[self] and _ArrayInfo[self].IsClass and _ArrayInfo[self].Type then
				if Reflector.ObjectIsClass(value, _ArrayInfo[self].Type) then
					for _, sc in ipairs(Reflector.GetScripts(_ArrayInfo[self].Type)) do
						if _ArrayInfo[self]["_ArrayActive_" .. sc] then
							Reflector.ActiveThread(value, sc)
						end
						if _ArrayInfo[self]["_ArrayBlock_" .. sc] then
							Reflector.BlockScript(value, sc)
						end

						if _ArrayInfo[self][sc] then
							value[sc] = _ArrayInfo[self][sc]
						end
					end
				else
					error(("Usage: Array:Insert([index], value) - value must be %s."):format(Reflector.GetFullName(_ArrayInfo[self].Type)), 2)
				end
			elseif _ArrayInfo[self] and _ArrayInfo[self].IsStruct and _ArrayInfo[self].Type then
				value = Reflector.Validate(_ArrayInfo[self].Type, value, "value", "Usage: Array:Insert([index], value) - ")
			end

			tinsert(self, value)

			return #self
		else
			error("Usage: Array:Insert([index], value)", 2)
		end
	end

	------------------------------------
	--- Remove table
	-- @name Array:Remove
	-- @class function
	-- @param index|object
	-- @usage Array:Remove(1)
	------------------------------------
	function Remove(self, index)
		if type(index) ~= "number" then
			for i, ob in ipairs(self) do
				if ob == index then
					index = i
				end
			end

			if type(index) ~= "number" then
				error("Usage: Array:Remove(index) - index must be a number.", 2)
			end
		end

		if not self[index] then
			return
		end

		local value = self[index]

		if _ArrayInfo[self] and _ArrayInfo[self].IsClass and _ArrayInfo[self].Type and Reflector.ObjectIsClass(value, _ArrayInfo[self].Type) then
			for _, sc in ipairs(Reflector.GetScripts(_ArrayInfo[self].Type)) do
				if _ArrayInfo[self]["_ArrayActive_" .. sc] then
					Reflector.InactiveThread(value, sc)
				end
				if _ArrayInfo[self]["_ArrayBlock_" .. sc] then
					Reflector.UnBlockScript(value, sc)
				end

				if _ArrayInfo[self][sc] then
					value[sc] = nil
				end
			end
		end

		return tremove(self, index)
	end

	------------------------------------
	--- Check if the script type is supported by the frame
	-- @name Array:HasScript
	-- @class function
	-- @param name the script type's name
	-- @return true if the frame has that script type
	-- @usage Array:HasScript("OnEnter")
	------------------------------------
	function HasScript(self, key)
		return type(key) == "string" and _ArrayInfo[self] and _ArrayInfo[self].IsClass and Reflector.HasScript(_ArrayInfo[self].Type, key)
	end

	------------------------------------
	--- Active thread mode for special scripts.
	-- @name Array:ActiveThread
	-- @class function
	-- @param ... script name list
	-- @usage Array:ActiveThread("OnClick", "OnEnter")
	------------------------------------
	function ActiveThread(self, ...)
		if _ArrayInfo[self] and _ArrayInfo[self].IsClass then
			local cls = _ArrayInfo[self].Type
			local name

			if cls then
				for i = 1, select('#', ...) do
					name = select(i, ...)

					if Reflector.HasScript(cls, name) then
						_ArrayInfo[self]["_ArrayActive_" .. name] = true

						for _, obj in ipairs(self) do
							if Reflector.ObjectIsClass(obj, cls) then
								Reflector.ActiveThread(obj, name)
							end
						end
					end
				end
			end
		end
	end

	------------------------------------
	--- Whether the thread mode is actived for special scripts.
	-- @name Array:IsThreadActived
	-- @class function
	-- @param script
	-- @usage Array:IsThreadActived("OnClick")
	------------------------------------
	function IsThreadActived(self, sc)
		return type(sc) == "string" and _ArrayInfo[self] and _ArrayInfo[self].IsClass and _ArrayInfo[self]["_ArrayActive_" .. sc] or false
	end

	------------------------------------
	--- Inactive thread mode for special scripts.
	-- @name Array:InactiveThread
	-- @class function
	-- @param ... script name list
	-- @usage Array:InactiveThread("OnClick", "OnEnter")
	------------------------------------
	function InactiveThread(self, ...)
		if _ArrayInfo[self] and _ArrayInfo[self].IsClass then
			local cls = _ArrayInfo[self].Type
			local name

			if cls then
				for i = 1, select('#', ...) do
					name = select(i, ...)

					if Reflector.HasScript(cls, name) then
						_ArrayInfo[self]["_ArrayActive_" .. name] = nil

						for _, obj in ipairs(self) do
							if Reflector.ObjectIsClass(obj, cls) then
								Reflector.InactiveThread(obj, name)
							end
						end
					end
				end
			end
		end
	end

	------------------------------------
	--- Block script for array object
	-- @name Array:BlockScript
	-- @class function
	-- @param ... script name list
	-- @usage Array:BlockScript("OnClick", "OnEnter")
	------------------------------------
	function BlockScript(self, ...)
		if _ArrayInfo[self] and _ArrayInfo[self].IsClass then
			local cls = _ArrayInfo[self].Type
			local name

			if cls then
				for i = 1, select('#', ...) do
					name = select(i, ...)

					if Reflector.HasScript(cls, name) then
						_ArrayInfo[self]["_ArrayBlock_" .. name] = true

						for _, obj in ipairs(self) do
							if Reflector.ObjectIsClass(obj, cls) then
								Reflector.BlockScript(obj, name)
							end
						end
					end
				end
			end
		end
	end

	------------------------------------
	--- Whether the script is blocked for the array objects
	-- @name Array:IsScriptBlocked
	-- @class function
	-- @param script
	-- @usage Array:IsScriptBlocked("OnClick")
	------------------------------------
	function IsScriptBlocked(self, sc)
		return type(sc) == "string" and _ArrayInfo[self] and _ArrayInfo[self].IsClass and _ArrayInfo[self]["_ArrayBlock_" .. sc] or false
	end

	------------------------------------
	--- Un-Block script for array objects
	-- @name Array:UnBlockScript
	-- @class function
	-- @param ... script name list
	-- @usage Array:UnBlockScript("OnClick", "OnEnter")
	------------------------------------
	function UnBlockScript(self, ...)
		if _ArrayInfo[self] and _ArrayInfo[self].IsClass then
			local cls = _ArrayInfo[self].Type
			local name

			if cls then
				for i = 1, select('#', ...) do
					name = select(i, ...)

					if Reflector.HasScript(cls, name) then
						_ArrayInfo[self]["_ArrayBlock_" .. name] = nil

						for _, obj in ipairs(self) do
							if Reflector.ObjectIsClass(obj, cls) then
								Reflector.UnBlockScript(obj, name)
							end
						end
					end
				end
			end
		end
	end

	------------------------------------
	--- Add value into Array's end
	-- @name Array:Push
	-- @class function
	-- @param value
	-- @param [...]
	-- @usage Array:Push("test")
	------------------------------------
	function Push(self, ...)
		for i = 1, select('#', ...) do
			self:Insert(select(i, ...))
		end
	end

	------------------------------------
	--- Remove and return the Array's end value
	-- @name Array:Pop
	-- @class function
	-- @return value
	-- @usage Array:Pop()
	------------------------------------
	function Pop(self)
		local value = self[#self]

		if value then
			self:Remove(#self)

			return value
		end
	end

	------------------------------------
	--- Add value into Array's start
	-- @name Array:Unshift
	-- @class function
	-- @param value
	-- @param [...]
	-- @usage Array:Unshift("test")
	------------------------------------
	function Unshift(self, ...)
		for i = select('#', ...), 1, -1 do
			self:Insert(1, select(i, ...))
		end
	end

	------------------------------------
	--- Remove and return the Array's start value
	-- @name Array:Shift
	-- @class function
	-- @return value
	-- @usage Array:Shift()
	------------------------------------
	function Shift(self)
		local value = self[1]

		if value then
			self:Remove(1)

			return value
		end
	end

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
		return ipairs(self), self, tonumber(key) or 0
	end

	------------------------------------
	--- Check if the array contains item
	-- @name Contain
	-- @type function
	-- @param item
	-- @return boolean
	------------------------------------
	function Contain(self, item)
		if type(item) then
			for i, ob in ipairs(self) do
				if ob == item then
					return true
				end
			end
			return false
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	property "Count" {
		Get = function(self)
			return #self
		end,
	}

	property "Type" {
		Get = function(self)
			return _ArrayInfo[self] and _ArrayInfo[self].Type
		end,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Array(cls)
		local arr = {}

		if type(cls) == "string" then
			cls = Reflector.ForName(cls)
		end

		if cls and Reflector.IsClass(cls) then
			_ArrayInfo[arr] = {
				Type = cls,
				IsClass = true,
			}
		elseif cls and Reflector.IsStruct(cls) then
			_ArrayInfo[arr] = {
				Type = cls,
				IsStruct = true,
			}
		end

		return arr
	end

	------------------------------------------------------
	-- Exist checking
	------------------------------------------------------

	------------------------------------------------------
	-- __index for class instance
	------------------------------------------------------
	function __index(self, key)
		if type(key) == "string" and _ArrayInfo[self] and _ArrayInfo[self].IsClass and Reflector.HasScript(_ArrayInfo[self].Type, key) then
			return _ArrayInfo[self]["_ArrayScript_"..key]
		end
	end

	------------------------------------------------------
	-- __newindex for class instance
	------------------------------------------------------
	function __newindex(self, key, value)
		if type(key) == "string" and _ArrayInfo[self] and _ArrayInfo[self].IsClass and Reflector.HasScript(_ArrayInfo[self].Type, key) then
			if value == nil or type(value) == "function" then
				_ArrayInfo[self]["_ArrayScript_"..key] = value

				_ArrayInfo[self][key] = value and function(obj, ...)
					for i = 1, #self do
						if rawget(self, i) == obj then
							return value(self, i, ...)
						end
					end
				end

				for _, obj in ipairs(self) do
					if Reflector.ObjectIsClass(obj, _ArrayInfo[self].Type) then
						obj[key] = _ArrayInfo[self][key]
					end
				end
			else
				error(("The %s is the script name of this Array's elements, it's value must be nil or a function."):format(key), 2)
			end
		elseif type(key) == "number" then
			error("Use Array:Insert(index, obj) | Array:Remove(index) to modify this array.", 2)
		end

		return rawset(self, key, value)
	end

	------------------------------------------------------
	-- __call for class instance
	------------------------------------------------------
endclass "Array"