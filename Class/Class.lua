--[[
Copyright (c) 2011 WangXH <kurapica.igas@gmail.com>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
--]]

-- Class System
-- Author: kurapica.igas@gmail.com
-- Create Date : 2011/02/01
-- ChangeLog   :
--               2011/04/14	System.Reflector added.
--               2011/05/11 Script handlers can run as thread.
--				 2011/05/30 System.Reflector.GetParts added.
--               2011/06/24 Property definition ignore case
--               2011/07/04 Struct no longer need Constructor and Validate function
--               2011/07/08 System.Reflector.IsAbstractClass(cls) added
--               2011/07/12 System.Reflector.ParseEnum(enm, value) added
--               2011/07/27 Enum's validation method changed.
--               2011/10/26 Error report update for __index & __newindex
--               2011/10/30 System.Reflector.ConvertClass(obj, cls) added
--               2011/10/31 System.Reflector.InactiveThread added
--               2012/04/10 System.Reflector.IsNameSpace(obj) added
--               2012/05/01 System.Reflector.Validate(type, value) added
--               2012/05/06 System.Reflector.Validate(type, value, name, prefix) mod
--               2012/05/07 System.Reflector.BuildType removed
--               2012/05/14 Type add sub & unm metamethodes
--               2012/05/21 Keyword 'Super' is added to the class enviroment
--               2012/06/27 Interface system added
--               2012/06/28 Interface can access it's methodes
--               2012/06/29 System.Reflector Update for Interface
--               2012/06/30 BlockScript, IsScriptBlocked, UnBlockScript added to Reflector
--               2012/07/01 Interface can extend from multi-interface
--               2012/07/08 IFDispose added to support interface disposing
--               2012/07/09 Using cache to keep interface list for class object creation
--               2012/07/26 Fix a stack overflow problem
--               2012/07/31 Improve struct system
--               2012/08/14 Struct namespace object now has Validate method.
--               2012/08/14 Class & Struct env now can access base namespace directly.
--               2012/08/14 Reduce Struct Validate method cost.
--               2012/08/19 Don't block error when create object.
--               2012/08/30 IFDispoe removed, Class system will use Dispose as a system method,
--                          Interface's Dispose will be called first when object call like obj:Dispose(),
--                          then the class's own Dispose will be called,
--                          Class.Dispose will access the class' own Dispose method, not system one.
--               2012/09/07 Fix can't extend interface that defined in the class
--               2012/09/20 class without constructor now will use Super class's constructor.
--                          System.Reflector change to Interface.
--               2012/10/08 Object Method, Property, Script can't start with '_'.
--               2012/10/13 partclass keyword added to support part class definition.
--               2012/11/07 Interface constructor invoking mechanism improved.
--               2012/11/11 Disposing objects when Object created failded.
--               2012/11/14 Fix interface constructor systfem.
--               2012/11/16 Extend interface order system added.
--               2012/12/08 Re-order inherit & extend tree.

------------------------------------------------------------------------
-- Class system is used to provide a object-oriented system in lua.
-- With this system, you can created a class like
--
-- namespace "System"				-- define the namespace
--
-- class "MyClass"						-- declare starting to define the class
--		inherit "Object"					-- declare the class is inherited from System.Object
--
--		script "OnNameChanged"	-- declare the class have a script named "OnNameChanged"
--
--		function Print(self)				-- the global functions will be treated as the class's methodes, self means the object
--			print(self._Name)
--		end
--
--		property "Name" {				-- declare the class have a property named "Name"
--			Get = function(self)		-- the get method for property "Name"
--				return self._Name
--			end,
--			Set = function(self, value)	-- the set method for property "Name"
--				self._Name = value
--				self:OnNameChanged(value)	-- raise the "OnNameChanged" script to trigger it's handler functions.
--			end,
--			Type = String,				-- the property "Name"'s type, so when you assign a value to Name, it should be checked.
--		}
--
--		function MyClass(self, name)	-- the function with same name of the class is treated as the Constructor of the class
--			self._Name = name			-- use self to init
--		end
--	endclass "MyClass"					-- declare the definition of the class is over.
--
--	Using MyClass:
--
--	myObj = MyClass("Test")
--
--	myObj:Print()						-- print out : Test
--
--	function myObj:OnNameChanged(name)	-- define the script handler for 'OnNameChanged'
--		print("The Name is changed to "..name)
--	end
--
--	myObj.Name = "Hello"			-- print out : The Name is changed to Hello
------------------------------------------------------------------------

local version = 60

------------------------------------------------------
-- Version Check & Class Environment
------------------------------------------------------
do
	local _Meta = getmetatable(IGAS)

	-- Version Check
	if _Meta._IGAS_Class_Version and _Meta._IGAS_Class_Version >= version then
		return
	end

	_Meta._IGAS_Class_Version = version

	-- Class Environment
	_Meta._Class_ENV = _Meta._Class_ENV or {}
	_Meta._Class_ENV._Class_KeyWords = _Meta._Class_KeyWords

	setmetatable(_Meta._Class_ENV, {
		__index = function(self,  key)
			if type(key) == "string" and key ~= "_G" and key:find("^_") then
				return
			end

			if _G[key] then
				rawset(self, key, _G[key])
				return rawget(self, key)
			end
		end,
	})

	setfenv(1, _Meta._Class_ENV)

	-- Scripts
	strtrim = strtrim or function(s)
	  return s and (s:gsub("^%s*(.-)%s*$", "%1")) or ""
	end

	wipe = wipe or function(t)
		for k in pairs(t) do
			t[k] = nil
		end
	end

	tinsert = tinsert or table.insert
	tremove = tremove or table.remove
	unpack = unpack
	pcall = pcall
	sort = sort

	geterrorhandler = geterrorhandler or function()
		return print
	end

	errorhandler = errorhandler or function(err)
		return pcall(geterrorhandler(), err)
	end

	TYPE_CLASS = "Class"
	TYPE_ENUM = "Enum"
	TYPE_STRUCT = "Struct"
	TYPE_INTERFACE = "Interface"

	TYPE_NAMESPACE = "IGAS.NameSpace"
	TYPE_TYPE = "IGAS.TYPE"
end

------------------------------------------------------
-- NameSpace
------------------------------------------------------
do
	_NameSpace = _NameSpace or newproxy(true)

	-- Disposing method name
	_DisposeMethod = "Dispose"

	_NSInfo = _NSInfo or setmetatable({}, {
		__index = function(self, key)
			if not IsNameSpace(key) then
				return
			end

			self[key] = {
				Owner = key,
			}

			return rawget(self, key)
		end,
	})

	-- metatable for class
	_MetaNS = _MetaNS or getmetatable(_NameSpace)
	do
		_MetaNS.__call = function(self, ...)
			local info = _NSInfo[self]

			if info.Type == TYPE_CLASS then
				-- Create Class object
				return Class2Obj(self, ...)
			elseif info.Type == TYPE_STRUCT then
				-- Create Struct
				return Struct2Obj(self, ...)
			end

			error(("%s can't be used as a constructor."):format(tostring(self)), 2)
		end

		_MetaNS.__index = function(self, key)
			local info = _NSInfo[self]

			if info.Type == TYPE_STRUCT then
				if key == "Validate" then
					if not info.Validate then
						BuildStructVFalidate(self)
					end
					return info.Validate
				else
					return info.SubNS and info.SubNS[key]
				end
			elseif info.Type == TYPE_CLASS then
				if info.SubNS and info.SubNS[key] then
					return info.SubNS[key]
				elseif type(key) == "string" and (not key:find("^__")) and info.Cache4Method and info.Cache4Method[key] then
					return info.Cache4Method[key]
				elseif _KeyMeta[key] ~= nil then
					if _KeyMeta[key] then
						return info.MetaTable[key]
					else
						return info.MetaTable["_"..key]
					end
				end
			elseif info.Type == TYPE_ENUM then
				return type(key) == "string" and info.Enum[key:upper()] or error(("%s is not an enumeration value of %s."):format(tostring(key), tostring(self)), 2)
			elseif info.Type == TYPE_INTERFACE then
				if info.SubNS and info.SubNS[key] then
					return info.SubNS[key]
				elseif type(key) == "string" and (not key:find("^_")) and info.Cache4Method and info.Cache4Method[key] then
					return info.Cache4Method[key]
				elseif type(key) == "string" and type(rawget(info.InterfaceEnv, key)) == "function" then
					return rawget(info.InterfaceEnv, key)
				end
			else
				return info.SubNS and info.SubNS[key]
			end
		end

		_MetaNS.__newindex = function(self, key, value)
			error(("can't set value for %s, it's readonly."):format(tostring(self)), 2)
		end

		_MetaNS.__add = function(v1, v2)
			local ok, _type1, _type2

			ok, _type1 = pcall(_BuildType, v1)
			if not ok then
				_type1 = strtrim(_type1:match(":%d+:(.*)$") or _type1)
				error(_type1, 2)
			end

			ok, _type2 = pcall(_BuildType, v2)
			if not ok then
				_type2 = strtrim(_type2:match(":%d+:(.*)$") or _type2)
				error(_type2, 2)
			end

			return _type1 + _type2
		end

		_MetaNS.__sub = function(v1, v2)
			local ok, _type1, _type2

			ok, _type1 = pcall(_BuildType, v1)
			if not ok then
				_type1 = strtrim(_type1:match(":%d+:(.*)$") or _type1)
				error(_type1, 2)
			end

			ok, _type2 = pcall(_BuildType, v2, nil, true)
			if not ok then
				_type2 = strtrim(_type2:match(":%d+:(.*)$") or _type2)
				error(_type2, 2)
			end

			return _type1 + _type2
		end

		_MetaNS.__unm = function(v1)
			local ok, _type1

			ok, _type1 = pcall(_BuildType, v1, nil, true)
			if not ok then
				_type1 = strtrim(_type1:match(":%d+:(.*)$") or _type1)
				error(_type1, 2)
			end

			return _type1
		end

		_MetaNS.__tostring = function(self)
			return GetFullName4NS(self)
		end

		_MetaNS.__metatable = TYPE_NAMESPACE
	end

	-- IsNameSpace
	function IsNameSpace(ns)
		return ns and type(ns) == "userdata" and getmetatable(ns) == TYPE_NAMESPACE or false
	end

	-- BuildNameSpace
	function BuildNameSpace(ns, namelist)
		if type(namelist) ~= "string" or (ns ~= nil and not IsNameSpace(ns)) then
			return
		end

		if namelist:find("%.%s*%.") then
			error("the namespace 's name can't have empty string between dots.", 2)
		end

		local cls = ns
		local info = cls and _NSInfo[cls]
		local parent = cls

		for name in namelist:gmatch("[^%.]+") do
			name = name:match("[_%w]+")

			if not name or name == "" then
				error("the namespace's name must be composed with number, string or '_'.", 2)
			end

			if not info then
				cls = newproxy(_NameSpace)
			elseif info.Type == nil or info.Type == TYPE_CLASS or info.Type == TYPE_STRUCT or info.Type == TYPE_INTERFACE then
				info.SubNS = info.SubNS or {}
				info.SubNS[name] = info.SubNS[name] or newproxy(_NameSpace)

				cls = info.SubNS[name]
			else
				error(("can't add item to a %s."):format(tostring(info.Type)), 2)
			end

			info = _NSInfo[cls]
			info.Name = name
			if not info.NameSpace and parent ~= _NameSpace then
				info.NameSpace = parent
			end
			parent = cls
		end

		if cls == ns then
			return
		end

		return cls
	end

	-- GetNameSpace
	function GetNameSpace(ns, namelist)
		if type(namelist) ~= "string" or not IsNameSpace(ns) then
			return
		end

		if namelist:find("%.%s*%.") then
			error("the namespace 's name can't have empty string between dots.", 2)
		end

		local cls = ns

		for name in namelist:gmatch("[^%.]+") do
			name = name:match("[_%w]+")

			if not name or name == "" then
				error("the namespace's name must be composed with number, string or '_'.", 2)
			end

			cls = cls[name]
			if not cls then
				return
			end
		end

		if cls == ns then
			return
		end

		return cls
	end

	-- GetDefaultNameSpace
	function GetDefaultNameSpace()
		return _NameSpace
	end

	-- SetNameSpace
	function SetNameSpace4Env(env, name)
		if type(env) ~= "table" then
			return
		end

		if type(name) == "string" then
			local ns = BuildNameSpace(GetDefaultNameSpace(), name)

			if ns then
				rawset(env, "__IGAS_NameSpace", ns)
			else
				rawset(env, "__IGAS_NameSpace", nil)
			end
		elseif IsNameSpace(name) then
			rawset(env, "__IGAS_NameSpace", name)
		else
			rawset(env, "__IGAS_NameSpace", nil)
		end
	end

	-- GetEnvNameSpace
	function GetNameSpace4Env(env)
		local ns = type(env) == "table" and env.__IGAS_NameSpace
		if IsNameSpace(ns) then
			return ns
		end
	end

	-- GetFullName4NS
	function GetFullName4NS(ns)
		local info = _NSInfo[ns]

		if info then
			local name = info.Name

			while info and info.NameSpace do
				info = _NSInfo[info.NameSpace]

				if info then
					name = info.Name.."."..name
				end
			end

			return name
		end
	end

	------------------------------------
	--- Set the default namespace for the current environment, the class defined in this environment will be stored in this namespace
	-- @name namespace
	-- @class function
	-- @param name the namespace's name list, using "." to split.
	-- @usage namespace "Widget"
	------------------------------------
	function namespace(name)
		if name ~= nil and type(name) ~= "string" and not IsNameSpace(name) then
			error([[Usage: namespace "namespace"]], 2)
		end

		local fenv = getfenv(2)

		SetNameSpace4Env(fenv, name)
	end
end

------------------------------------------------------
-- Type
------------------------------------------------------
do
	_Meta4Type = _Meta4Type or {}
	do
		_Meta4Type.__add = function(v1, v2)
			local ok, _type1, _type2

			ok, _type1 = pcall(_BuildType, v1)
			if not ok then
				_type1 = strtrim(_type1:match(":%d+:(.*)$") or _type1)
				error(_type1, 2)
			end

			ok, _type2 = pcall(_BuildType, v2)
			if not ok then
				_type2 = strtrim(_type2:match(":%d+:(.*)$") or _type2)
				error(_type2, 2)
			end

			if _type1 and _type2 then
				local _type = setmetatable({}, _Meta4Type)

				_type.AllowNil = _type1.AllowNil or _type2.AllowNil

				local tmp = {}

				for _, ns in ipairs(_type1) do
					tinsert(_type, ns)
					tmp[ns] = true
				end
				for _, ns in ipairs(_type2) do
					if not tmp[ns] then
						tinsert(_type, ns)
					end
				end

				wipe(tmp)

				local index = -1
				local pos = -1

				while _type1[index] do
					tmp[_type1[index]] = true
					_type[pos] = _type1[index]
					pos = pos -1
					index = index - 1
				end

				index = -1

				while _type2[index] do
					if not tmp[_type2[index]] then
						_type[pos] = _type2[index]
						pos = pos -1
					end
					index = index - 1
				end

				tmp = nil

				return _type
			else
				return _type1 or _type2
			end
		end

		_Meta4Type.__sub = function(v1, v2)
			if IsNameSpace(v2) then
				local ok, _type2

				ok, _type2 = pcall(_BuildType, v2, nil, true)
				if not ok then
					_type2 = strtrim(_type2:match(":%d+:(.*)$") or _type2)
					error(_type2, 2)
				end

				return v1 + _type2
			elseif v2 == nil then
				return v1
			else
				error("The operation '-' must be used with class or struct.", 2)
			end
		end

		_Meta4Type.__unm = function(v1)
			error("Can't use unary '-' before a type", 2)
		end

		_Meta4Type.__index = {
			-- value = Type:Validate(value)
			Validate = function(self, value)
				if value == nil and self.AllowNil then
					return value
				end

				local flag, msg, info, new

				local index = -1

                local types = ""

				while self[index] do
					info = _NSInfo[self[index]]

                    new = nil

                    if not info then
                        -- skip
					elseif info.Type == TYPE_CLASS then
						if value and rawget(_NSInfo, value) and _NSInfo[value].Type == TYPE_CLASS and IsChildClass(self[index], value) then
							return value
						end

						new = ("%s must be or must be subclass of [class]%s."):format("%s", tostring(self[index]))
					elseif info.Type == TYPE_INTERFACE then
						if value and rawget(_NSInfo, value) and _NSInfo[value].Type == TYPE_CLASS and IsExtend(self[index], value) then
							return value
						end

						new = ("%s must be extended from [interface]%s."):format("%s", tostring(self[index]))
                    elseif info.Type then
                        if value == info.Owner then
                            return value
                        else
                            types = types .. tostring(info.Owner) .. ", "
                        end
					end

					if new and not msg then
						if self.Name and self.Name ~= "" then
							if new:find("%%s([_%w]+)") then
								msg = new:gsub("%%s", "%%s"..self.Name..".")
							else
								msg = new:gsub("%%s", "%%s"..self.Name)
							end
						else
							msg = new
						end
					end

					index = index - 1
				end

                if types:len() >= 3 and not msg then
                    new = ("%s must be the type in ()."):format("%s", types:sub(1, -3))

                    if self.Name and self.Name ~= "" then
                        if new:find("%%s([_%w]+)") then
                            msg = new:gsub("%%s", "%%s"..self.Name..".")
                        else
                            msg = new:gsub("%%s", "%%s"..self.Name)
                        end
                    else
                        msg = new
                    end
                end

				for _, ns in ipairs(self) do
					info = _NSInfo[ns]

					new = nil

					if not info then
						-- do nothing
					elseif info.Type == TYPE_CLASS then
						-- Check if the value is an instance of this class
						if type(value) == "table" and getmetatable(value) and IsChildClass(ns, getmetatable(value)) then
							return value
						end

						new = ("%s must be an instance of [class]%s."):format("%s", tostring(ns))
					elseif info.Type == TYPE_INTERFACE then
						-- Check if the value is an instance of this interface
						if type(value) == "table" and getmetatable(value) and IsExtend(ns, getmetatable(value)) then
							return value
						end

						new = ("%s must be an instance extended from [interface]%s."):format("%s", tostring(ns))
					elseif info.Type == TYPE_ENUM then
						-- Check if the value is an enumeration value of this enum
						if type(value) == "string" and info.Enum[value:upper()] then
							return info.Enum[value:upper()]
						end

						for _, v in pairs(info.Enum) do
							if value == v then
								return v
							end
						end

						new = ("%s must be a value of [enum]%s ( %s )."):format("%s", tostring(ns), _GetShortEnumInfo(ns))
					elseif info.Type == TYPE_STRUCT then
						-- Check if the value is an enumeration value of this structure
						flag, new = pcall(ValidateStruct, ns, value)

						if flag then
							return new
						end

						new = strtrim(new:match(":%d+:(.*)$") or new)
					end

					if new and not msg then
						if self.Name and self.Name ~= "" then
							if new:find("%%s([_%w]+)") then
								msg = new:gsub("%%s", "%%s"..self.Name..".")
							else
								msg = new:gsub("%%s", "%%s"..self.Name)
							end
						else
							msg = new
						end
					end
				end

				if msg and self.AllowNil and not msg:match("%(Optional%)$") then
					msg = msg .. "(Optional)"
				end

				assert(not msg, msg)

				return value
			end,

			-- newType = type:Copy()
			Copy = function(self)
				local _type = setmetatable({}, _Meta4Type)

				for i, v in pairs(self) do
					_type[i] = v
				end

				return _type
			end,

			-- boolean = type:Is(nil)
			-- boolean = type:Is(System.String)
			Is = function(self, ns, onlyClass)
				local fenv = getfenv(2)

				if ns == nil then
					return self.AllowNil or false
				end

				if IsNameSpace(ns) then
					if not onlyClass then
						for _, v in ipairs(self) do
							if v == ns then
								return true
							end
						end
					else
						local index = -1

						while self[index] do
							if self[index] == ns then
								return true
							end
							index = index - 1
						end
					end
				end

				return false
			end,
		}

		_Meta4Type.__metatable = TYPE_TYPE
	end

	function IsType(tbl)
		return type(tbl) == "table" and getmetatable(tbl) == TYPE_TYPE or false
	end

	function _BuildType(ns, name, onlyClass)
		local allowNil = false

		if ns == nil then
			allowNil = true
		elseif IsType(ns) then
			if name then
				ns.Name = name
			end
			return ns
		end

		if ns == nil or IsNameSpace(ns) then
			local _type = setmetatable({}, _Meta4Type)

			_type.AllowNil = allowNil or nil

			if ns then
				if onlyClass then
					_type[-1] = ns
				else
					_type[1] = ns
				end
			end

			if name then
				_type.Name = name
			end
			return _type
		else
			error("The type must be nil, struct, enum or class.")
		end
	end
end

------------------------------------------------------
-- Interface
------------------------------------------------------
do
	_IFEnv2Info = _IFEnv2Info or setmetatable({}, {__mode = "kv",})

	_KeyWord4IFEnv = _KeyWord4IFEnv or {}

	-- metatable for interface's env
	_MetaIFEnv = _MetaIFEnv or {}
	do
		_MetaIFEnv.__index = function(self, key)
			local info = _IFEnv2Info[self]

			-- Check owner
			if key == info.Name then
				return info.Owner
			end

			-- Check keywords
			if _KeyWord4IFEnv[key] then
				return _KeyWord4IFEnv[key]
			end

			-- Check namespace
			if info.NameSpace then
				if key == _NSInfo[info.NameSpace].Name then
					rawset(self, key, info.NameSpace)
					return rawget(self, key)
				elseif info.NameSpace[key] then
					rawset(self, key, info.NameSpace[key])
					return rawget(self, key)
				end
			end

			-- Check imports
			if info.Import4Env then
				for _, ns in ipairs(info.Import4Env) do
					if key == _NSInfo[ns].Name then
						rawset(self, key, ns)
						return rawget(self, key)
					elseif ns[key] then
						rawset(self, key, ns[key])
						return rawget(self, key)
					end
				end
			end

			-- Check base namespace
			if GetNameSpace(GetDefaultNameSpace(), key) then
				rawset(self, key, GetNameSpace(GetDefaultNameSpace(), key))
				return rawget(self, key)
			end

			-- Check Base
			if info.BaseEnv then
				local value = info.BaseEnv[key]

				if type(value) == "table" or type(value) == "function" then
					rawset(self, key, value)
				end

				return value
			end
		end

		_MetaIFEnv.__newindex = function(self, key, value)
			local info = _IFEnv2Info[self]

			if _KeyWord4IFEnv[key] then
				error(("'%s' is a keyword."):format(key), 2)
			end

			if key == info.Name then
				if type(value) == "function" then
					rawset(info, "Constructor", value)
					return
				else
					error(("'%s' must be a function as constructor."):format(key), 2)
				end
			end

			if type(key) == "string" and not key:find("^_") and key ~= _DisposeMethod and type(value) == "function" then
				info.Method[key] = true
				-- keep function in env, just register the method
			end

			rawset(self, key, value)
		end
	end

	do
		_BaseScripts = _BaseScripts or {
			OnScriptHandlerChanged = true,
		}

		function CloneWithoutOverride(dest, src)
			for key, value in pairs(src) do
				if dest[key] == nil then
					dest[key] = value
				end
			end
		end

		function CloneWithoutOverride4Method(dest, src, method)
			if method then
				for key in pairs(method) do
					if dest[key] == nil and type(key) == "string" and type(src[key]) == "function" then
						dest[key] = src[key]
					end
				end
			else
				for key, value in pairs(src) do
					if type(key) == "string" and type(value) == "function" then
						if dest[key] == nil then
							dest[key] = value
						end
					end
				end
			end
		end

		_Extend_Temp = {}
		function RefreshCache(ns)
			local info = _NSInfo[ns]

			wipe(_Extend_Temp)

			if info.ExtendInterface then
				for IF, index in pairs(info.ExtendInterface) do
					_Extend_Temp[index] = IF
				end
			end

			-- Cache4Script
			wipe(info.Cache4Script)
			--- BaseScripts
			CloneWithoutOverride(info.Cache4Script, _BaseScripts)
			--- self script
			CloneWithoutOverride(info.Cache4Script, info.Script)
			--- superclass script
			if info.SuperClass then
				CloneWithoutOverride(info.Cache4Script, _NSInfo[info.SuperClass].Cache4Script)
			end
			--- extend script
			for _, IF in ipairs(_Extend_Temp) do
				CloneWithoutOverride(info.Cache4Script, _NSInfo[IF].Cache4Script)
			end

			-- Cache4Property
			wipe(info.Cache4Property)
			--- self property
			CloneWithoutOverride(info.Cache4Property, info.Property)
			--- superclass property
			if info.SuperClass then
				CloneWithoutOverride(info.Cache4Property, _NSInfo[info.SuperClass].Cache4Property)
			end
			--- extend property
			for _, IF in ipairs(_Extend_Temp) do
				CloneWithoutOverride(info.Cache4Property, _NSInfo[IF].Cache4Property)
			end

			-- Cache4Method
			wipe(info.Cache4Method)
			--- self method
			CloneWithoutOverride4Method(info.Cache4Method, info.ClassEnv or info.InterfaceEnv, info.Method)
			--- superclass method
			if info.SuperClass then
				CloneWithoutOverride4Method(info.Cache4Method, _NSInfo[info.SuperClass].Cache4Method)
			end
			--- extend method
			for _, IF in ipairs(_Extend_Temp) do
				CloneWithoutOverride4Method(info.Cache4Method, _NSInfo[IF].Cache4Method)
			end

			wipe(_Extend_Temp)

			--[[ Property access method
			for name, prop in pairs(info.Property) do
				if prop.Get and info.Cache4Method["Get"..name] == nil then
					info.Cache4Method["Get"..name] = prop.Get
				end
				if prop.Set and info.Cache4Method["Set"..name] == nil then
					info.Cache4Method["Set"..name] = prop.Set
				end
			end--]]

			-- Clear branch
			if info.ChildClass then
				for subcls in pairs(info.ChildClass) do
					RefreshCache(subcls)
				end
			elseif info.ExtendClass then
				for subcls in pairs(info.ExtendClass) do
					RefreshCache(subcls)
				end
			end
		end
	end


	function IsExtend(IF, cls)
		if not IF or not cls or not _NSInfo[IF] or _NSInfo[IF].Type ~= TYPE_INTERFACE or not _NSInfo[cls] then
			return false
		end

		if IF == cls then return true end

		if _NSInfo[cls].ExtendInterface then
			if _NSInfo[cls].ExtendInterface[IF] then return true end

			for pIF in pairs(_NSInfo[cls].ExtendInterface) do
				if IsExtend(IF, pIF) then return true end
			end
		end

		if _NSInfo[cls].Type == TYPE_CLASS then
			cls = _NSInfo[cls].SuperClass

			return cls and IsExtend(IF, cls) or false
		end

		return false
	end

	------------------------------------
	--- Create interface in currect environment's namespace or default namespace
	-- @name interface
	-- @class function
	-- @param name the interface's name
	-- @usage interface "IFSocket"
	------------------------------------
	function interface(name)
		if type(name) ~= "string" or name:find("%.") or not name:match("[_%w]+") then
			error([[Usage: interface "interfacename"]], 2)
		end
		local fenv = getfenv(2)
		local ns = GetNameSpace4Env(fenv)

		-- Create interface or get it
		local IF

		name = name:match("[_%w]+")

		if ns then
			IF = BuildNameSpace(ns, name)

			if _NSInfo[IF] then
				if _NSInfo[IF].Type and _NSInfo[IF].Type ~= TYPE_INTERFACE then
					error(("%s is existed as %s, not interface."):format(name, tostring(_NSInfo[IF].Type)), 2)
				end

				if _NSInfo[IF].BaseEnv and _NSInfo[IF].BaseEnv ~= fenv then
					error(("%s is defined in another place, can't be defined here."):format(name), 2)
				end
			end
		else
			IF = fenv[name]

			if not(_NSInfo[IF] and _NSInfo[IF].BaseEnv == fenv and _NSInfo[IF].NameSpace == nil and _NSInfo[IF].Type == TYPE_INTERFACE) then
				IF = BuildNameSpace(nil, name)
			end
		end

		if not IF then
			error("no interface is created.", 2)
		end

		-- save interface to the environment
		rawset(fenv, name, IF)

		-- Build interface
		info = _NSInfo[IF]
		info.Type = TYPE_INTERFACE
		info.NameSpace = ns
		info.BaseEnv = fenv
		info.Script = info.Script or {}
		info.Property = info.Property or {}
		info.Method = info.Method or {}

		info.InterfaceEnv = info.InterfaceEnv or setmetatable({}, _MetaIFEnv)
		_IFEnv2Info[info.InterfaceEnv] = info

		-- Clear
		info.Constructor = nil
		wipe(info.Property)
		wipe(info.Script)
		wipe(info.Method)
		for i, v in pairs(info.InterfaceEnv) do
			if type(v) == "function" then
				info.InterfaceEnv[i] = nil
			end
		end

		-- Set namespace
		SetNameSpace4Env(info.InterfaceEnv, IF)

		-- Cache
		info.Cache4Script = info.Cache4Script or {}
		info.Cache4Property = info.Cache4Property or {}
		info.Cache4Method = info.Cache4Method or {}

		-- ExtendInterface
		if info.ExtendInterface then
			for pIF in pairs(info.ExtendInterface) do
				if _NSInfo[pIF].ExtendClass then
					_NSInfo[pIF].ExtendClass[info.Owner] = nil
				end
			end
			wipe(info.ExtendInterface)
		end

		-- Import
		info.Import4Env = info.Import4Env or {}
		wipe(info.Import4Env)

		-- Set the environment to interface's environment
		setfenv(2, info.InterfaceEnv)
	end

	------------------------------------
	--- Set the current interface' extended interface
	-- @name extend
	-- @class function
	-- @param name the namespace's name list, using "." to split.
	-- @usage extend "System.IFSocket"
	------------------------------------
	function extend_IF(name)
		if name and type(name) ~= "string" and not IsNameSpace(name) then
			error([[Usage: extend "namespace.interfacename"]], 2)
		end

		if type(name) == "string" and name:find("%.%s*%.") then
			error("the namespace 's name can't have empty string between dots.", 2)
		end

		local env = getfenv(2)

		if rawget(_IFEnv2Info, env) == nil then
			error("can't using extend here.", 2)
		end

		local info = _IFEnv2Info[env]

		local IF

		if type(name) == "string" then
			IF = GetNameSpace(info.NameSpace, name) or env[name]

			if not IF then
				for subname in name:gmatch("[^%.]+") do
					subname = subname:match("[_%w]+")

					if not subname or subname == "" then
						error("the namespace's name must be composed with number, string or '_'.", 2)
					end

					if not IF then
						IF = info.BaseEnv[subname]
					else
						IF = IF[subname]
					end

					if not IsNameSpace(IF) then
						error(("no interface is found with the name : %s"):format(name), 2)
					end
				end
			end
		else
			IF = name
		end

		local IFInfo = _NSInfo[IF]

		if not IFInfo or IFInfo.Type ~= TYPE_INTERFACE then
			error("Usage: extend (interface) : 'interface' - interface expected", 2)
		end

		if IsExtend(info.Owner, IF) then
			error(("%s is extended from %s, can't be used here."):format(tostring(IF), tostring(info.Owner)), 2)
		end

		IFInfo.ExtendClass = IFInfo.ExtendClass or {}
		IFInfo.ExtendClass[info.Owner] = true

		info.ExtendInterface = info.ExtendInterface or {}

		-- Check if IF is already extend by extend tree
		for pIF in pairs(info.ExtendInterface) do
			if IsExtend(IF, pIF) then
				return extend_IF
			end
		end

		wipe(_Extend_Temp)

		-- Then check if IF extend from exist and re-order
		for pIF, index in pairs(info.ExtendInterface) do
			_Extend_Temp[index] = pIF
		end

		for index = #_Extend_Temp, 1, -1 do
			if IsExtend(_Extend_Temp[index], IF) then
				info.ExtendInterface[_Extend_Temp[index]] = nil
				tremove(_Extend_Temp, index)
			end
		end

		tinsert(_Extend_Temp, IF)

		for index, pIF in ipairs(_Extend_Temp) do
			info.ExtendInterface[pIF] = index
		end

		wipe(_Extend_Temp)

		return extend_IF
	end

	------------------------------------
	--- import classes from the given name's namespace to the current environment
	-- @name import
	-- @class function
	-- @param name the namespace's name list, using "." to split.
	-- @usage import "System.Widget"
	------------------------------------
	function import_IF(name)
		if type(name) ~= "string" and not IsNameSpace(name) then
			error([[Usage: import "namespaceA.namespaceB"]], 2)
		end

		if type(name) == "string" and name:find("%.%s*%.") then
			error("the namespace 's name can't have empty string between dots.", 2)
		end

		local env = getfenv(2)

		local info = _IFEnv2Info[env]

		if not info then
			error("can't use import here.", 2)
		end

		local ns

		if type(name) == "string" then
			ns = GetNameSpace(GetDefaultNameSpace(), name)
		elseif IsNameSpace(name) then
			ns = name
		end

		if not ns then
			error(("no namespace is found with name : %s"):format(name), 2)
		end

		info.Import4Env = info.Import4Env or {}

		for _, v in ipairs(info.Import4Env) do
			if v == ns then
				return
			end
		end

		tinsert(info.Import4Env, ns)
	end

	------------------------------------
	--- Add or remove a script for current interface
	-- @name script
	-- @class function
	-- @param name the name of the script
	-- @usage script "OnClick"
	------------------------------------
	function script_IF(name)
		if type(name) ~= "string" or name:find("^_") then
			error([[Usage: script "scriptName"]], 2)
		end

		local env = getfenv(2)

		local info = _IFEnv2Info[env]

		if not info then
			error("can't use script here.", 2)
		end

		info.Script[name] = true
	end

	_TEMP_PROPERTY = _TEMP_PROPERTY or {}

	local function SetProperty2IF(info, name, set)
		if type(set) ~= "table" then
			error([=[Usage: property "propertyName" {
				Get = function(self)
					-- return the property's value
				end,
				Set = function(self, value)
					-- Set the property's value
				end,
				Type = Type1 [+ Type2 [+ nil]],	-- set the property's type
			}]=], 2)
		end

		wipe(_TEMP_PROPERTY)

		for i, v in pairs(set) do
			if type(i) == "string" then
				if i:lower() == "get" then
					_TEMP_PROPERTY.Get = v
				elseif i:lower() == "set" then
					_TEMP_PROPERTY.Set = v
				elseif i:lower() == "type" then
					_TEMP_PROPERTY.Type = v
				end
			end
		end

		local prop = info.Property[name] or {}
		info.Property[name] = prop

		wipe(prop)

		prop.Name = name
		prop.Get = type(_TEMP_PROPERTY.Get) == "function" and _TEMP_PROPERTY.Get
		prop.Set = type(_TEMP_PROPERTY.Set) == "function" and _TEMP_PROPERTY.Set

		if _TEMP_PROPERTY.Type then
			local ok, _type = pcall(_BuildType, _TEMP_PROPERTY.Type, name)
			if ok then
				prop.Type = _type
			else
				_type = strtrim(_type:match(":%d+:(.*)$") or _type)

				wipe(_TEMP_PROPERTY)

				error(_type, 3)
			end
		end

		wipe(_TEMP_PROPERTY)
	end

	------------------------------------
	--- set a propert to the current interface
	-- @name property
	-- @class function
	-- @param name the name of the property
	-- @usage property "Title" {
	--		Get = function(self)
	--			-- return the property's value
	--		end,
	--		Set = function(self, value)
	--			-- Set the property's value
	--		end,
	--		Type = "XXXX",	-- set the property's type
	--}
	------------------------------------
	function property_IF(name)
		if type(name) ~= "string" or strtrim(name:match("[_%w]+")) == "" then
			error([=[Usage: property "propertyName" {
				Get = function(self)
					-- return the property's value
				end,
				Set = function(self, value)
					-- Set the property's value
				end,
				Type = Type1 [+ Type2 [+ nil]],	-- set the property's type
			}]=], 2)
		end

		name = name:match("[_%w]+")

		local env = getfenv(2)

		local info = _IFEnv2Info[env]

		if not info then
			error("can't use property here.", 2)
		end

		return function(set)
			return SetProperty2IF(info, name, set)
		end
	end

	------------------------------------
	--- End the interface's definition and restore the environment
	-- @name class
	-- @class function
	-- @param name the name of the interface
	-- @usage endinterface "IFSocket"
	------------------------------------
	function endinterface(name)
		if type(name) ~= "string" or name:find("%.") then
			error([[Usage: endinterface "interfacename"]], 2)
		end

		local env = getfenv(2)

		local info = _IFEnv2Info[env]

		if info.Name == name then
			setfenv(2, info.BaseEnv)
			RefreshCache(info.Owner)
			return
		else
			error(("%s is not closed."):format(info.Name), 2)
		end
	end

	_KeyWord4IFEnv.interface = interface
	_KeyWord4IFEnv.extend = extend_IF
	_KeyWord4IFEnv.import = import_IF
	_KeyWord4IFEnv.script = script_IF
	_KeyWord4IFEnv.property = property_IF
	_KeyWord4IFEnv.endinterface = endinterface
end

------------------------------------------------------
-- Class
------------------------------------------------------
do
	_SuperIndex = "Super"

	_ClsEnv2Info = _ClsEnv2Info or setmetatable({}, {__mode = "kv",})

	_KeyWord4ClsEnv = _KeyWord4ClsEnv or {}

	_KeyMeta = {
		__add = true,		-- a + b
		__sub = true,		-- a - b
		__mul = true,		-- a * b
		__div = true,		-- a / b
		__mod = true,		-- a % b
		__pow = true,		-- a ^ b
		__unm = true,		-- - a
		__concat = true,	-- a..b
		__len = true,		-- #a
		__eq = true,		-- a == b
		__lt = true,		-- a < b
		__le = true,		-- a <= b
		__index = false,	-- return a[b]
		__newindex = false,	-- a[b] = v
		__call = true,		-- a()
		__gc = false,		-- dispose a
		__tostring = true,	-- tostring(a)
		__exist = true,		-- ClassName(...)	-- return object if existed
	}

	--------------------------------------------------
	-- Init & Dispose System
	--------------------------------------------------
	do
		local function GetInterfaces(lst, ns)
			if not ns then return end

			local info = _NSInfo[ns]

			if info.Type == TYPE_INTERFACE then
				for _, eIF in ipairs(lst) do
					if eIF == ns then
						return
					end
				end
			end

			if info.SuperClass then
				GetInterfaces(lst, info.SuperClass)
			end

			if info.ExtendInterface then
				for IF in pairs(info.ExtendInterface) do
					GetInterfaces(lst, IF)
				end
			end

			if info.Type == TYPE_INTERFACE then
				tinsert(lst, ns)
			end
		end

		_DisposeCache = _DisposeCache or setmetatable({}, {
			__call = function(self, lst)
				if lst then
					wipe(lst)
					tinsert(self, lst)
				else
					if #self > 0 then
						return tremove(self, #self)
					else
						return {}
					end
				end
			end,
		})

		function InitObjectWithClass(cls, obj, ...)
			local  info = _NSInfo[cls]

			if info.SuperClass then
				InitObjectWithClass(info.SuperClass, obj, ...)
			end

			if type(info.Constructor) == "function" then
				info.Constructor(obj, ...)
			end
		end

		function InitObjectWithInterface(cls, obj)
			local lst = _DisposeCache()

			GetInterfaces(lst, cls)

			local ok, msg, info

			for _, IF in ipairs(lst) do
				info = _NSInfo[IF]
				if info.Constructor then
					ok, msg = pcall(info.Constructor, obj)

					if not ok then
						errorhandler(msg)
					end
				end
			end

			-- Recycle
			_DisposeCache(lst)
		end

		------------------------------------
		--- Dispose this object
		-- @name DisposeObject
		-- @class function
		------------------------------------
		function DisposeObject(self)
			-- Clear form interface
			-- Since we don't have right to do the true dispose
			-- We need a special method named Dispose to do this job
			local disfunc
			local lst = _DisposeCache()
			local objCls = Reflector.GetObjectClass(self)
			local IF

			GetInterfaces(lst, objCls)

			for i = #lst, 1, -1 do
				IF = lst[i]
				disfunc = rawget(_NSInfo[IF].InterfaceEnv, _DisposeMethod)

				if type(disfunc) == "function" then
					pcall(disfunc, self)
				end
			end

			-- Recycle
			_DisposeCache(lst)

			-- Call Normal Dispose
			if type(objCls[_DisposeMethod]) == "function" then
				objCls[_DisposeMethod](self)
			end

			-- Clear the table
			-- setmetatable(self, nil)

			wipe(self)
		end
	end

	-- metatable for class's env
	_MetaClsEnv = _MetaClsEnv or {}
	do
		_MetaClsEnv.__index = function(self, key)
			local info = _ClsEnv2Info[self]

			-- Check owner
			if key == info.Name then
				return info.Owner
			end

			if key == _SuperIndex then
				return info.SuperClass or error("No super class for this class.", 2)
			end

			-- Check keywords
			if _KeyWord4ClsEnv[key] then
				return _KeyWord4ClsEnv[key]
			end

			-- Check namespace
			if info.NameSpace then
				if key == _NSInfo[info.NameSpace].Name then
					rawset(self, key, info.NameSpace)
					return rawget(self, key)
				elseif info.NameSpace[key] then
					rawset(self, key, info.NameSpace[key])
					return rawget(self, key)
				end
			end

			-- Check imports
			if info.Import4Env then
				for _, ns in ipairs(info.Import4Env) do
					if key == _NSInfo[ns].Name then
						rawset(self, key, ns)
						return rawget(self, key)
					elseif ns[key] then
						rawset(self, key, ns[key])
						return rawget(self, key)
					end
				end
			end

			-- Check base namespace
			if GetNameSpace(GetDefaultNameSpace(), key) then
				rawset(self, key, GetNameSpace(GetDefaultNameSpace(), key))
				return rawget(self, key)
			end

			-- Check Base
			if info.BaseEnv then
				local value = info.BaseEnv[key]

				if type(value) == "table" or type(value) == "function" then
					rawset(self, key, value)
				end

				return value
			end
		end

		_MetaClsEnv.__newindex = function(self, key, value)
			local info = _ClsEnv2Info[self]

			if _KeyWord4ClsEnv[key] or key == _SuperIndex then
				error(("'%s' is a keyword."):format(key), 2)
			end

			if key == info.Name then
				if type(value) == "function" then
					rawset(info, "Constructor", value)
					return
				else
					error(("'%s' must be a function as constructor."):format(key), 2)
				end
			end

			if _KeyMeta[key] ~= nil then
				if type(value) == "function" then
					local rMeta = _KeyMeta[key] and key or "_"..key
					SetMetaFunc(rMeta, info.ChildClass, info.MetaTable[rMeta], value)
					info.MetaTable[rMeta] = value
					return
				else
					error(("'%s' must be a function."):format(key), 2)
				end
			end

			if type(key) == "string" and type(value) == "function" then
				info.Method[key] = true
				-- Keep function body in env
			end

			rawset(self, key, value)
		end
	end

	-- metatable for ScriptHandler
	_MetaScriptHandler = _MetaScriptHandler or {}
	do
		_MetaScriptHandler.__index = {
			Add = function(self, func)
				if type(func) ~= "function" then
					error("Usage: obj.OnXXXX:Add(func)", 2)
				end

				for _, f in ipairs(self) do
					if f == func then
						return self
					end
				end

				tinsert(self, func)

				if self._Owner and self._Name then
					CallScriptWithoutCreate(self._Owner, "OnScriptHandlerChanged", self._Name)
				end

				return self
			end,
			Remove = function(self, func)
				local flag = false

				if type(func) ~= "function" then
					error("Usage: obj.OnXXXX:Remove(func)", 2)
				end

				for i, f in ipairs(self) do
					if f == func then
						tremove(self, i)
						flag = true
						break
					end
				end

				if flag and self._Owner and self._Name then
					CallScriptWithoutCreate(self._Owner, "OnScriptHandlerChanged", self._Name)
				end

				return self
			end,
			Clear = function(self)
				local flag = false

				for i = #self, 0, -1 do
					if not flag and self[i] then
						flag = true
					end
					tremove(self, i)
				end

				if flag and self._Owner and self._Name then
					CallScriptWithoutCreate(self._Owner, "OnScriptHandlerChanged", self._Name)
				end

				return self
			end,
			IsEmpty = function(self)
				return #self == 0 and self[0] == nil
			end,
		}

		_MetaScriptHandler.__add = function(self, func)
			if type(func) ~= "function" then
				error("Usage: obj.OnXXXX = obj.OnXXXX + func", 2)
			end

			for _, f in ipairs(self) do
				if f == func then
					return self
				end
			end

			tinsert(self, func)

			if self._Owner and self._Name then
				CallScriptWithoutCreate(self._Owner, "OnScriptHandlerChanged", self._Name)
			end

			return self
		end

		_MetaScriptHandler.__sub = function(self, func)
			local flag = false

			if type(func) ~= "function" then
				error("Usage: obj.OnXXXX = obj.OnXXXX - func", 2)
			end

			for i, f in ipairs(self) do
				if f == func then
					tremove(self, i)
					flag = true
					break
				end
			end

			if flag and self._Owner and self._Name then
				CallScriptWithoutCreate(self._Owner, "OnScriptHandlerChanged", self._Name)
			end

			return self
		end

		local create = coroutine.create
		local resume = coroutine.resume
		local status = coroutine.status

		_MetaScriptHandler.__call = function(self, obj, ...)
			if not obj then
				error("Usage: obj:OnXXXX(...).", 2)
			end

			if self._Blocked then
				return
			end

			local chk = false
			local ret = false

			for i = 1, #self do
				if self._ThreadActived then
					local thread = create(self[i])
					chk, ret = resume(thread, obj, ...)
					if status(thread) ~= "dead" then
						-- not stop when the thread not dead
						ret = nil
					end
				else
					chk, ret = pcall(self[i], obj, ...)
				end
				if not chk then
					return errorhandler(ret)
				end

				if not rawget(obj, "__Scripts") then
					-- means it's disposed
					ret = true
				end
				if ret then
					break
				end
			end

			if not ret and self[0] then
				if self._ThreadActived then
					chk, ret = resume(create(self[0]), obj, ...)
				else
					chk, ret = pcall(self[0], obj, ...)
				end
				if not chk then
					return errorhandler(ret)
				end
			end
		end
	end

	_MetaScripts = _MetaScripts or {}
	do
		_MetaScripts.__index = function(self, key)
			-- Check Script
			local cls = self._Owner and getmetatable(self._Owner)

			if _NSInfo[cls].Cache4Script[key] == nil then
				return
			end

			-- Add Script Handler
			rawset(self, key, setmetatable({_Owner = self._Owner, _Name = key}, _MetaScriptHandler))
			return rawget(self, key)
		end

		_MetaScripts.__newindex = function(self, key, value)
		end
	end

	function IsChildClass(cls, child)
		if not cls or not child or not _NSInfo[cls] or _NSInfo[cls].Type ~= TYPE_CLASS or not _NSInfo[child] or _NSInfo[child].Type ~= TYPE_CLASS then
			return false
		end

		if cls == child then
			return true
		end

		local info = _NSInfo[child]

		while info and info.SuperClass and info.SuperClass ~= cls do
			info = _NSInfo[info.SuperClass]
		end

		if info and info.SuperClass == cls then
			return true
		end

		return false
	end

	function SetMetaFunc(meta, sub, pre, now)
		if sub and pre ~= now then
			for cls in pairs(sub) do
				local info = _NSInfo[cls]

				if info.MetaTable[meta] == pre then
					info.MetaTable[meta] = now

					SetMetaFunc(meta, info.ChildClass, pre, now)
				end
			end
		end
	end

	function CheckProperty(prop, value)
		if prop and prop.Type then
			local ok, ret = pcall(prop.Type.Validate, prop.Type, value)

			if not ok then
				ret = strtrim(ret:match(":%d+:(.*)$") or ret)

				if ret:find("%%s") then
					ret = ret:gsub("%%s[_%w]*", prop.Name)
				end

				error(ret, 3)
			end

			return ret
		end

		return value
	end

	function CallScriptWithoutCreate(self, scriptName, ...)
		if rawget(self, "__Scripts") and rawget(self.__Scripts, scriptName) then
			return self[scriptName](self, ...)
		end
	end

	function Class2Obj(cls, ...)
		local info = _NSInfo[cls]
		local obj

		if not info then return end

		-- Check if this class has __exist so no need to create again.
		if type(info.MetaTable.__exist) == "function" then
			obj = info.MetaTable.__exist(...)

			if type(obj) == "table" then
				if getmetatable(obj) == cls then
					return obj
				else
					error(("There is an existed object as type '%s'."):format(Reflector.GetName(Reflector.GetObjectClass(obj)) or ""), 2)
				end
			end
		end

		-- Create new object
		obj = setmetatable({}, info.MetaTable)
		InitObjectWithClass(cls, obj, ...)

		InitObjectWithInterface(cls, obj)

		return obj
	end

	------------------------------------
	--- Create class in currect environment's namespace or default namespace
	-- @name class
	-- @class function
	-- @param name the class's name
	-- @usage class "Form"
	------------------------------------
	function class(name)
		if type(name) ~= "string" or name:find("%.") or not name:match("[_%w]+") then
			error([[Usage: class "classname"]], 2)
		end
		local fenv = getfenv(2)
		local ns = GetNameSpace4Env(fenv)

		-- Create class or get it
		local cls

		name = name:match("[_%w]+")

		if ns then
			cls = BuildNameSpace(ns, name)

			if _NSInfo[cls] then
				if _NSInfo[cls].Type and _NSInfo[cls].Type ~= TYPE_CLASS then
					error(("%s is existed as %s, not class."):format(name, tostring(_NSInfo[cls].Type)), 2)
				end

				if _NSInfo[cls].BaseEnv and _NSInfo[cls].BaseEnv ~= fenv then
					error(("%s is defined in another place, can't be defined here."):format(name), 2)
				end
			end
		else
			cls = fenv[name]

			if not(_NSInfo[cls] and _NSInfo[cls].BaseEnv == fenv and _NSInfo[cls].NameSpace == nil and _NSInfo[cls].Type == TYPE_CLASS) then
				cls = BuildNameSpace(nil, name)
			end
		end

		if not cls then
			error("no class is created.", 2)
		end

		-- save class to the environment
		rawset(fenv, name, cls)

		-- Build class
		info = _NSInfo[cls]
		info.Type = TYPE_CLASS
		info.NameSpace = ns
		info.BaseEnv = fenv
		info.Script = info.Script or {}
		info.Property = info.Property or {}
		info.Method = info.Method or {}

		info.ClassEnv = info.ClassEnv or setmetatable({}, _MetaClsEnv)
		_ClsEnv2Info[info.ClassEnv] = info

		-- Clear
		info.Constructor = nil
		wipe(info.Property)
		wipe(info.Script)
		wipe(info.Method)
		for i, v in pairs(info.ClassEnv) do
			if type(v) == "function" then
				info.ClassEnv[i] = nil
			end
		end

		-- Set namespace
		SetNameSpace4Env(info.ClassEnv, cls)

		-- Cache
		info.Cache4Script = info.Cache4Script or {}
		info.Cache4Property = info.Cache4Property or {}
		info.Cache4Method = info.Cache4Method or {}

		-- SuperClass
		local prevInfo = info.SuperClass and _NSInfo[info.SuperClass]

		if prevInfo and prevInfo.ChildClass then
			prevInfo.ChildClass[info.Owner] = nil
		end

		info.SuperClass = nil

		-- ExtendInterface
		if info.ExtendInterface then
			for IF in pairs(info.ExtendInterface) do
				if _NSInfo[IF].ExtendClass then
					_NSInfo[IF].ExtendClass[info.Owner] = nil
				end
			end
			wipe(info.ExtendInterface)
		end

		-- Import
		info.Import4Env = info.Import4Env or {}
		wipe(info.Import4Env)

		-- MetaTable
		info.MetaTable = info.MetaTable or {}
		do
			local MetaTable = info.MetaTable
			local rMeta

			-- Clear
			for meta, flag in pairs(_KeyMeta) do
				rMeta = flag and meta or "_"..meta
				SetMetaFunc(rMeta, info.ChildClass, MetaTable[rMeta], nil)
				MetaTable[rMeta] = nil
			end

			local ClassEnv = info.ClassEnv
			local Cache4Script = info.Cache4Script
			local Cache4Property = info.Cache4Property
			local Cache4Method = info.Cache4Method
			local ClassName = info.Name

			MetaTable.__class = cls

			MetaTable.__metatable = cls

			MetaTable.__index = function(self, key)
				if type(key) == "string" and not key:find("^__") then
					-- Property Get
					if Cache4Property[key] then
						if Cache4Property[key]["Get"] then
							return Cache4Property[key]["Get"](self)
						else
							error(("%s is write-only."):format(tostring(key)),2)
						end
					end

					-- Dispose Method
					if key == _DisposeMethod then
						return DisposeObject
					end

					-- Method Get
					if not key:find("^_") and Cache4Method[key] then
						return Cache4Method[key]
					end

					-- Scripts
					if Cache4Script[key] ~= nil then
						if type(rawget(self, "__Scripts")) ~= "table" or getmetatable(self.__Scripts) ~= _MetaScripts then
							rawset(self, "__Scripts", setmetatable({_Owner = self}, _MetaScripts))
						end

						return self.__Scripts[key]
					end
				end

				-- Custom index metametods
				if rawget(MetaTable, "___index") then
					if type(rawget(MetaTable, "___index")) == "table" then
						return rawget(MetaTable, "___index")[key]
					elseif type(rawget(MetaTable, "___index")) == "function" then
						return rawget(MetaTable, "___index")(self, key)
						--[[local ok, ret = pcall(rawget(MetaTable, "___index"), self, key)

						if not ok then
							ret = strtrim(ret:match(":%d+:(.*)$") or ret)

							error(ret, 2)
						end

						return ret--]]
					end
				end
			end

			MetaTable.__newindex = function(self, key, value)
				if type(key) == "string" and not key:find("^__") then
					-- Property Set
					if Cache4Property[key] then
						if Cache4Property[key]["Set"] then
							return Cache4Property[key]["Set"](self, CheckProperty(Cache4Property[key], value))
						else
							error(("%s is read-only."):format(tostring(key)),2)
						end
					end

					-- Scripts
					if Cache4Script[key] ~= nil then
						if type(rawget(self, "__Scripts")) ~= "table" or getmetatable(self.__Scripts) ~= _MetaScripts then
							rawset(self, "__Scripts", setmetatable({_Owner = self}, _MetaScripts))
						end

						if value == nil or type(value) == "function" then
							if Cache4Script[key] then
								if self.__Scripts[key][0] ~= value then
									rawset(self.__Scripts[key], 0, value)
									CallScriptWithoutCreate(self, "OnScriptHandlerChanged", key)
								end
							else
								error(("%s is not supported for class '%s'."):format(tostring(key), ClassName), 2)
							end
						elseif type(value) == "table" and getmetatable(value) == _MetaScriptHandler then
							if value == self.__Scripts[key] then
								return
							end

							for i = #self.__Scripts[key], 0, -1 do
								tremove(self.__Scripts[key], i)
							end

							for i =0, #value do
								self.__Scripts[key][i] = value[i]
							end

							CallScriptWithoutCreate(self, "OnScriptHandlerChanged", key)
						else
							error("can't set this value to a scipt handler.", 2)
						end

						return
					end
				end

				-- Custom newindex metametods
				if type(rawget(MetaTable, "___newindex")) == "function" then
					return rawget(MetaTable, "___newindex")(self, key, value)
					--[[local ok, ret = pcall(rawget(MetaTable, "___newindex"), self, key, value)

					if not ok then
						ret = strtrim(ret:match(":%d+:(.*)$") or ret)

						error(ret, 2)
					end

					return ret--]]
				end

				rawset(self,key,value)			-- Other key can be set as usual
			end
		end

		-- Set the environment to class's environment
		setfenv(2, info.ClassEnv)
	end

	------------------------------------
	--- Part class definition
	-- @name partclass
	-- @type function
	-- @param name the class's name
	-- @usage partclass "Form"
	------------------------------------
	function partclass(name)
		if type(name) ~= "string" or name:find("%.") or not name:match("[_%w]+") then
			error([[Usage: class "classname"]], 2)
		end
		local fenv = getfenv(2)
		local ns = GetNameSpace4Env(fenv)

		-- Create class or get it
		local cls

		name = name:match("[_%w]+")

		if ns then
			cls = BuildNameSpace(ns, name)

			if _NSInfo[cls] then
				if _NSInfo[cls].Type and _NSInfo[cls].Type ~= TYPE_CLASS then
					error(("%s is existed as %s, not class."):format(name, tostring(_NSInfo[cls].Type)), 2)
				end

				if _NSInfo[cls].BaseEnv and _NSInfo[cls].BaseEnv ~= fenv then
					error(("%s is defined in another place, can't be defined here."):format(name), 2)
				end
			end
		else
			cls = fenv[name]

			if not(_NSInfo[cls] and _NSInfo[cls].BaseEnv == fenv and _NSInfo[cls].NameSpace == nil and _NSInfo[cls].Type == TYPE_CLASS) then
				cls = BuildNameSpace(nil, name)
			end
		end

		if not cls then
			error("no class is created.", 2)
		end

		-- save class to the environment
		rawset(fenv, name, cls)

		-- Build class
		info = _NSInfo[cls]
		info.Type = TYPE_CLASS
		info.NameSpace = ns
		info.BaseEnv = fenv
		info.Script = info.Script or {}
		info.Property = info.Property or {}
		info.Method = info.Method or {}

		info.ClassEnv = info.ClassEnv or setmetatable({}, _MetaClsEnv)
		_ClsEnv2Info[info.ClassEnv] = info

		-- Set namespace
		SetNameSpace4Env(info.ClassEnv, cls)

		-- Cache
		info.Cache4Script = info.Cache4Script or {}
		info.Cache4Property = info.Cache4Property or {}
		info.Cache4Method = info.Cache4Method or {}

		-- Import
		info.Import4Env = info.Import4Env or {}

		-- MetaTable
		info.MetaTable = info.MetaTable or {}
		do
			local MetaTable = info.MetaTable
			local rMeta

			local ClassEnv = info.ClassEnv
			local Cache4Script = info.Cache4Script
			local Cache4Property = info.Cache4Property
			local Cache4Method = info.Cache4Method
			local ClassName = info.Name

			MetaTable.__class = cls

			MetaTable.__metatable = cls

			MetaTable.__index = MetaTable.__index or function(self, key)
				if type(key) == "string" and not key:find("^__") then
					-- Property Get
					if Cache4Property[key] then
						if Cache4Property[key]["Get"] then
							return Cache4Property[key]["Get"](self)
						else
							error(("%s is write-only."):format(tostring(key)),2)
						end
					end

					-- Dispose Method
					if key == _DisposeMethod then
						return DisposeObject
					end

					-- Method Get
					if not key:find("^_") and Cache4Method[key] then
						return Cache4Method[key]
					end

					-- Scripts
					if Cache4Script[key] ~= nil then
						if type(rawget(self, "__Scripts")) ~= "table" or getmetatable(self.__Scripts) ~= _MetaScripts then
							rawset(self, "__Scripts", setmetatable({_Owner = self}, _MetaScripts))
						end

						return self.__Scripts[key]
					end
				end

				-- Custom index metametods
				if rawget(MetaTable, "___index") then
					if type(rawget(MetaTable, "___index")) == "table" then
						return rawget(MetaTable, "___index")[key]
					elseif type(rawget(MetaTable, "___index")) == "function" then
						return rawget(MetaTable, "___index")(self, key)
						--[[local ok, ret = pcall(rawget(MetaTable, "___index"), self, key)

						if not ok then
							ret = strtrim(ret:match(":%d+:(.*)$") or ret)

							error(ret, 2)
						end

						return ret--]]
					end
				end
			end

			MetaTable.__newindex = MetaTable.__newindex or function(self, key, value)
				if type(key) == "string" and not key:find("^__") then
					-- Property Set
					if Cache4Property[key] then
						if Cache4Property[key]["Set"] then
							return Cache4Property[key]["Set"](self, CheckProperty(Cache4Property[key], value))
						else
							error(("%s is read-only."):format(tostring(key)),2)
						end
					end

					-- Scripts
					if Cache4Script[key] ~= nil then
						if type(rawget(self, "__Scripts")) ~= "table" or getmetatable(self.__Scripts) ~= _MetaScripts then
							rawset(self, "__Scripts", setmetatable({_Owner = self}, _MetaScripts))
						end

						if value == nil or type(value) == "function" then
							if Cache4Script[key] then
								if self.__Scripts[key][0] ~= value then
									rawset(self.__Scripts[key], 0, value)
									CallScriptWithoutCreate(self, "OnScriptHandlerChanged", key)
								end
							else
								error(("%s is not supported for class '%s'."):format(tostring(key), ClassName), 2)
							end
						elseif type(value) == "table" and getmetatable(value) == _MetaScriptHandler then
							if value == self.__Scripts[key] then
								return
							end

							for i = #self.__Scripts[key], 0, -1 do
								tremove(self.__Scripts[key], i)
							end

							for i =0, #value do
								self.__Scripts[key][i] = value[i]
							end

							CallScriptWithoutCreate(self, "OnScriptHandlerChanged", key)
						else
							error("can't set this value to a scipt handler.", 2)
						end

						return
					end
				end

				-- Custom newindex metametods
				if type(rawget(MetaTable, "___newindex")) == "function" then
					return rawget(MetaTable, "___newindex")(self, key, value)
					--[[local ok, ret = pcall(rawget(MetaTable, "___newindex"), self, key, value)

					if not ok then
						ret = strtrim(ret:match(":%d+:(.*)$") or ret)

						error(ret, 2)
					end

					return ret--]]
				end

				rawset(self,key,value)			-- Other key can be set as usual
			end
		end

		-- Set the environment to class's environment
		setfenv(2, info.ClassEnv)
	end

	------------------------------------
	--- Set the current class' super class
	-- @name inherit
	-- @class function
	-- @param name the namespace's name list, using "." to split.
	-- @usage inherit "System.Widget.Frame"
	------------------------------------
	function inherit_Cls(name)
		if name and type(name) ~= "string" and not IsNameSpace(name) then
			error([[Usage: inherit "namespace.classname"]], 2)
		end

		if type(name) == "string" and name:find("%.%s*%.") then
			error("the namespace 's name can't have empty string between dots.", 2)
		end

		local env = getfenv(2)

		if rawget(_ClsEnv2Info, env) == nil then
			error("can't using inherit here.", 2)
		end

		local info = _ClsEnv2Info[env]

		local prevInfo = info.SuperClass and _NSInfo[info.SuperClass]

		if prevInfo and prevInfo.ChildClass then
			prevInfo.ChildClass[info.Owner] = nil
		end

		info.SuperClass = nil

		local superCls

		if type(name) == "string" then
			superCls = GetNameSpace(info.NameSpace, name) or env[name]

			if not superCls then
				for subname in name:gmatch("[^%.]+") do
					subname = subname:match("[_%w]+")

					if not subname or subname == "" then
						error("the namespace's name must be composed with number, string or '_'.", 2)
					end

					if not superCls then
						-- superCls = info.BaseEnv[subname]
						superCls = env[subname]
					else
						superCls = superCls[subname]
					end

					if not IsNameSpace(superCls) then
						error(("no class is found with the name : %s"):format(name), 2)
					end
				end
			end
		else
			superCls = name
		end

		local superInfo = _NSInfo[superCls]

		if not superInfo or superInfo.Type ~= TYPE_CLASS then
			error("Usage: inherit (class) : 'class' - class expected", 2)
		end

		if IsChildClass(info.Owner, superCls) then
			error(("%s is inherited from %s, can't be used as super class."):format(tostring(superCls), tostring(info.Owner)), 2)
		end

		superInfo.ChildClass = superInfo.ChildClass or {}
		superInfo.ChildClass[info.Owner] = true
		info.SuperClass = superCls

		-- Copy Metatable
		local rMeta
		for meta, flag in pairs(_KeyMeta) do
			rMeta = flag and meta or "_"..meta

			if info.MetaTable[rMeta] == nil and superInfo.MetaTable[rMeta] then
				SetMetaFunc(rMeta, info.ChildClass, nil, superInfo.MetaTable[rMeta])
				info.MetaTable[rMeta] = superInfo.MetaTable[rMeta]
			end
		end
	end

	------------------------------------
	--- Set the current class' extended interface
	-- @name extend
	-- @class function
	-- @param name the namespace's name list, using "." to split.
	-- @usage extend "System.IFSocket"
	------------------------------------
	function extend_Cls(name)
		if name and type(name) ~= "string" and not IsNameSpace(name) then
			error([[Usage: extend "namespace.interfacename"]], 2)
		end

		if type(name) == "string" and name:find("%.%s*%.") then
			error("the namespace 's name can't have empty string between dots.", 2)
		end

		local env = getfenv(2)

		if rawget(_ClsEnv2Info, env) == nil then
			error("can't using extend here.", 2)
		end

		local info = _ClsEnv2Info[env]

		local IF

		if type(name) == "string" then
			IF = GetNameSpace(info.NameSpace, name) or env[name]

			if not IF then
				for subname in name:gmatch("[^%.]+") do
					subname = subname:match("[_%w]+")

					if not subname or subname == "" then
						error("the namespace's name must be composed with number, string or '_'.", 2)
					end

					if not IF then
						IF = info.BaseEnv[subname]
					else
						IF = IF[subname]
					end

					if not IsNameSpace(IF) then
						error(("no interface is found with the name : %s"):format(name), 2)
					end
				end
			end
		else
			IF = name
		end

		local IFInfo = _NSInfo[IF]

		if not IFInfo or IFInfo.Type ~= TYPE_INTERFACE then
			error("Usage: extend (interface) : 'interface' - interface expected", 2)
		end

		IFInfo.ExtendClass = IFInfo.ExtendClass or {}
		IFInfo.ExtendClass[info.Owner] = true

		info.ExtendInterface = info.ExtendInterface or {}

		-- Check if IF is already extend by extend tree
		for pIF in pairs(info.ExtendInterface) do
			if IsExtend(IF, pIF) then
				return extend_Cls
			end
		end

		wipe(_Extend_Temp)

		-- Then check if IF extend from exist and re-order
		for pIF, index in pairs(info.ExtendInterface) do
			_Extend_Temp[index] = pIF
		end

		for index = #_Extend_Temp, 1, -1 do
			if IsExtend(_Extend_Temp[index], IF) then
				info.ExtendInterface[_Extend_Temp[index]] = nil
				tremove(_Extend_Temp, index)
			end
		end

		tinsert(_Extend_Temp, IF)

		for index, pIF in ipairs(_Extend_Temp) do
			info.ExtendInterface[pIF] = index
		end

		wipe(_Extend_Temp)

		return extend_Cls
	end

	------------------------------------
	--- import classes from the given name's namespace to the current environment
	-- @name import
	-- @class function
	-- @param name the namespace's name list, using "." to split.
	-- @usage import "System.Widget"
	------------------------------------
	function import_Cls(name)
		if type(name) ~= "string" and not IsNameSpace(name) then
			error([[Usage: import "namespaceA.namespaceB"]], 2)
		end

		if type(name) == "string" and name:find("%.%s*%.") then
			error("the namespace 's name can't have empty string between dots.", 2)
		end

		local env = getfenv(2)

		local info = _ClsEnv2Info[env]

		if not info then
			error("can't use import here.", 2)
		end

		local ns

		if type(name) == "string" then
			ns = GetNameSpace(GetDefaultNameSpace(), name)
		elseif IsNameSpace(name) then
			ns = name
		end

		if not ns then
			error(("no namespace is found with name : %s"):format(name), 2)
		end

		info.Import4Env = info.Import4Env or {}

		for _, v in ipairs(info.Import4Env) do
			if v == ns then
				return
			end
		end

		tinsert(info.Import4Env, ns)
	end

	------------------------------------
	--- Add or remove a script for current class
	-- @name script
	-- @class function
	-- @param name the name of the script, if started with "-" means to remove this script
	-- @usage script "OnClick"
	-- @usage script "-OnClick"
	------------------------------------
	function script_Cls(name)
		if type(name) ~= "string" or name:find("^_") then
			error([[Usage: script "[-]scriptName"]], 2)
		end

		local env = getfenv(2)

		local info = _ClsEnv2Info[env]

		if not info then
			error("can't use script here.", 2)
		end

		local flag

		name, flag = name:gsub("^-", "")

		info.Script[name] = (flag == 0)
	end

	_TEMP_PROPERTY = _TEMP_PROPERTY or {}

	local function SetProperty2Cls(info, name, set)
		if type(set) ~= "table" then
			error([=[Usage: property "propertyName" {
				Get = function(self)
					-- return the property's value
				end,
				Set = function(self, value)
					-- Set the property's value
				end,
				Type = Type1 [+ Type2 [+ nil]],	-- set the property's type
			}]=], 2)
		end

		wipe(_TEMP_PROPERTY)

		for i, v in pairs(set) do
			if type(i) == "string" then
				if i:lower() == "get" then
					_TEMP_PROPERTY.Get = v
				elseif i:lower() == "set" then
					_TEMP_PROPERTY.Set = v
				elseif i:lower() == "type" then
					_TEMP_PROPERTY.Type = v
				end
			end
		end

		local prop = info.Property[name] or {}
		info.Property[name] = prop

		wipe(prop)

		prop.Name = name
		prop.Get = type(_TEMP_PROPERTY.Get) == "function" and _TEMP_PROPERTY.Get
		prop.Set = type(_TEMP_PROPERTY.Set) == "function" and _TEMP_PROPERTY.Set

		if _TEMP_PROPERTY.Type then
			local ok, _type = pcall(_BuildType, _TEMP_PROPERTY.Type, name)
			if ok then
				prop.Type = _type
			else
				_type = strtrim(_type:match(":%d+:(.*)$") or _type)

				wipe(_TEMP_PROPERTY)

				error(_type, 3)
			end
		end

		wipe(_TEMP_PROPERTY)
	end

	------------------------------------
	--- set a propert to the current class
	-- @name property
	-- @class function
	-- @param name the name of the property
	-- @usage property "Title" {
	--		Get = function(self)
	--			-- return the property's value
	--		end,
	--		Set = function(self, value)
	--			-- Set the property's value
	--		end,
	--		Type = "XXXX",	-- set the property's type
	--}
	------------------------------------
	function property_Cls(name)
		if type(name) ~= "string" or strtrim(name:match("[_%w]+")) == "" then
			error([=[Usage: property "propertyName" {
				Get = function(self)
					-- return the property's value
				end,
				Set = function(self, value)
					-- Set the property's value
				end,
				Type = Type1 [+ Type2 [+ nil]],	-- set the property's type
			}]=], 2)
		end

		name = name:match("[_%w]+")

		local env = getfenv(2)

		local info = _ClsEnv2Info[env]

		if not info then
			error("can't use property here.", 2)
		end

		return function(set)
			return SetProperty2Cls(info, name, set)
		end
	end

	------------------------------------
	--- End the class's definition and restore the environment
	-- @name class
	-- @class function
	-- @param name the name of the class
	-- @usage endclass "Form"
	------------------------------------
	function endclass(name)
		if type(name) ~= "string" or name:find("%.") then
			error([[Usage: endclass "classname"]], 2)
		end

		local env = getfenv(2)

		local info = _ClsEnv2Info[env]

		if info.Name == name then
			setfenv(2, info.BaseEnv)
			RefreshCache(info.Owner)
			return
		else
			error(("%s is not closed."):format(info.Name), 2)
		end
	end

	_KeyWord4ClsEnv.partclass = partclass
	_KeyWord4ClsEnv.class = class
	_KeyWord4ClsEnv.inherit = inherit_Cls
	_KeyWord4ClsEnv.extend = extend_Cls
	_KeyWord4ClsEnv.import = import_Cls
	_KeyWord4ClsEnv.script = script_Cls
	_KeyWord4ClsEnv.property = property_Cls
	_KeyWord4ClsEnv.endclass = endclass
end

------------------------------------------------------
-- Enum
------------------------------------------------------
do
	local function BuildEnum(info, set)
		if type(set) ~= "table" then
			error([[Usage: enum "enumName" {
				"enumValue1",
				"enumValue2",
			}]], 2)
		end

		info.Enum = info.Enum or {}

		wipe(info.Enum)

		for i, v in pairs(set) do
			if type(i) == "string" then
				info.Enum[i:upper()] = v
			elseif type(v) == "string" then
				info.Enum[v:upper()] = v
			end
		end
	end

	function _GetShortEnumInfo(cls)
		if _NSInfo[cls] then
			local str

			for n in pairs(_NSInfo[cls].Enum) do
				if str and #str > 30 then
					str = str .. " | ..."
					break
				end

				str = str and (str .. " | " .. n) or n
			end

			return str or ""
		end

		return ""
	end

	------------------------------------
	--- create a enumeration
	-- @name enum
	-- @class function
	-- @param name the name of the enum
	-- @usage enum "ButtonState" {
	--		"PUSHED",
	--		"NORMAL",
	--}
	------------------------------------
	function enum(name)
		if type(name) ~= "string" or name:find("%.") or strtrim(name:match("[_%w]+") or "") == "" then
			error([[Usage: enum "enumName" {
				"enumValue1",
				"enumValue2",
			}]], 2)
		end

		name = name:match("[_%w]+")

		local fenv = getfenv(2)
		local ns = GetNameSpace4Env(fenv)

		-- Create class or get it
		local enm

		if ns then
			enm = BuildNameSpace(ns, name)

			if _NSInfo[cls] then
				if _NSInfo[cls].Type and _NSInfo[cls].Type ~= TYPE_ENUM then
					error(("%s is existed as %s, not enumeration."):format(name, tostring(_NSInfo[cls].Type)), 2)
				end
			end
		else
			enm = fenv[name]

			if not(_NSInfo[enm] and _NSInfo[enm].Type == TYPE_ENUM) then
				enm = BuildNameSpace(nil, name)
			end
		end

		if not enm then
			error("no enumeration is created.", 2)
		end

		-- save class to the environment
		rawset(fenv, name, enm)

		-- Build enm
		local info = _NSInfo[enm]
		info.Type = TYPE_ENUM
		info.NameSpace = ns

		return function(set)
			return BuildEnum(info, set)
		end
	end
end

------------------------------------------------------
-- Struct
------------------------------------------------------
do
	_StructEnv2Info = _StructEnv2Info or setmetatable({}, {__mode = "kv",})

	_KeyWord4StrtEnv = _KeyWord4StrtEnv or {}

	_STRUCT_TYPE_MEMBER = "MEMBER"
	_STRUCT_TYPE_ARRAY = "ARRAY"
	_STRUCT_TYPE_CUSTOM = "CUSTOM"

	-- metatable for class's env
	_MetaStrtEnv = _MetaStrtEnv or {}
	do
		_MetaStrtEnv.__index = function(self, key)
			local info = _StructEnv2Info[self]

			-- Check owner
			if key == info.Name then
				return info.Owner
			end

			if key == "Validate" then
				return info.UserValidate
			end

			-- Check keywords
			if _KeyWord4StrtEnv[key] then
				return _KeyWord4StrtEnv[key]
			end

			-- Check namespace
			if info.NameSpace then
				if key == _NSInfo[info.NameSpace].Name then
					rawset(self, key, info.NameSpace)
					return rawget(self, key)
				elseif info.NameSpace[key] then
					rawset(self, key, info.NameSpace[key])
					return rawget(self, key)
				end
			end

			-- Check imports
			if info.Import4Env then
				for _, ns in ipairs(info.Import4Env) do
					if key == _NSInfo[ns].Name then
						rawset(self, key, ns)
						return rawget(self, key)
					elseif ns[key] then
						rawset(self, key, ns[key])
						return rawget(self, key)
					end
				end
			end

			-- Check base namespace
			if GetNameSpace(GetDefaultNameSpace(), key) then
				rawset(self, key, GetNameSpace(GetDefaultNameSpace(), key))
				return rawget(self, key)
			end

			-- Check Base
			if info.BaseEnv then
				return info.BaseEnv[key]
			end
		end

		_MetaStrtEnv.__newindex = function(self, key, value)
			local info = _StructEnv2Info[self]

			if _KeyWord4StrtEnv[key] then
				error(("the '%s' is a keyword."):format(key), 2)
			end

			if key == info.Name then
				-- error(("the '%s' is the struct name, can't be used."):format(key), 2)
				if type(value) == "function" then
					rawset(info, "Constructor", value)
					return
				else
					error(("the '%s' must be a function as constructor."):format(key), 2)
				end
			end

			if key == "Validate" then
				if value == nil or type(value) == "function" then
					info.UserValidate = value
					return
				else
					error(("the '%s' must be a function used for validation."):format(key), 2)
				end
			end

			if type(key) == "string" and (value == nil or IsType(value) or IsNameSpace(value)) then
				local ok, ret = pcall(_BuildType, value, key)

				if ok then
					rawset(self, key, ret)

					if info.SubType == _STRUCT_TYPE_MEMBER then
						info.Members = info.Members or {}
						tinsert(info.Members, key)
					elseif info.SubType == _STRUCT_TYPE_ARRAY then
						info.ArrayElement = ret
					end

					return
				else
					ret = strtrim(ret:match(":%d+:(.*)$") or ret)
					error(ret, 2)
				end
			end

			rawset(self, key, value)
		end
	end

	function ValidateStruct(strt, value)
		local info = _NSInfo[strt]

		if info.SubType == _STRUCT_TYPE_MEMBER and info.Members then
			assert(type(value) == "table", ("%s must be a table, got %s."):format("%s", type(value)))

			for _, n in ipairs(info.Members) do
				value[n] = info.StructEnv[n]:Validate(value[n])
			end
		end

		if info.SubType == _STRUCT_TYPE_ARRAY and info.ArrayElement then
			assert(type(value) == "table", ("%s must be a table, got %s."):format("%s", type(value)))

			local flag, ret

			for i, v in ipairs(value) do
				flag, ret = pcall(info.ArrayElement.Validate, info.ArrayElement, v)

				if flag then
					value[i] = ret
				else
					ret = strtrim(ret:match(":%d+:(.*)$") or ret)

					if ret:find("%%s([_%w]+)") then
						ret = ret:gsub("%%s([_%w]+)", "%%s["..i.."]")
					end

					assert(false, ret)
				end
			end
		end

		if type(info.UserValidate) == "function" then
			value = info.UserValidate(value)
		end

		return value
	end

	function Struct2Obj(strt, ...)
		local info = _NSInfo[strt]

		if type(info.Constructor) == "function" then
			local ok, ret = pcall(info.Constructor, ...)
			if ok then
				return ret
			else
				ret = strtrim(ret:match(":%d+:(.*)$") or ret)

				error(ret, 3)
			end
		end

		if info.SubType == _STRUCT_TYPE_MEMBER and info.Members and #info.Members > 0 then
			local ret = {}

			for i, n in ipairs(info.Members) do
				ret[n] = select(i, ...)
			end

			local ok, value = pcall(ValidateStruct, strt, ret)

			if ok then
				return value
			else
				value = strtrim(value:match(":%d+:(.*)$") or value)
				value = value:gsub("%%s%.", ""):gsub("%%s", "")

				local args = ""
				for i, n in ipairs(info.Members) do
					if info.StructEnv[n]:Is(nil) and not args:find("%[") then
						n = "["..n
					end
					if i == 1 then
						args = n
					else
						args = args..", "..n
					end
				end
				if args:find("%[") then
					args = args.."]"
				end
				error(("Usage : %s(%s) - %s"):format(tostring(strt), args, value), 3)
			end
		end

		if info.SubType == _STRUCT_TYPE_ARRAY and info.ArrayElement then
			local ret = {}

			for i = 1, select('#', ...) do
				ret[i] = select(i, ...)
			end

			local ok, value = pcall(ValidateStruct, strt, ret)

			if ok then
				return value
			else
				value = strtrim(value:match(":%d+:(.*)$") or value)
				value = value:gsub("%%s%.", ""):gsub("%%s", "")

				error(("Usage : %s(...) - %s"):format(tostring(strt), value), 3)
			end
		end

		error(("struct '%s' is abstract."):format(tostring(strt)), 3)
	end

	function BuildStructVFalidate(strt)
		local info = _NSInfo[strt]

		info.Validate = function ( value )
			local ok, ret = pcall(ValidateStruct, strt, value)

			if not ok then
				ret = strtrim(ret:match(":%d+:(.*)$") or ret)

				ret = ret:gsub("%%s", "[".. info.Name .."]")

				error(ret, 2)
			end

			return ret
		end
	end
	------------------------------------
	--- create a structure
	-- @name struct
	-- @class function
	-- @param name the name of the enum
	-- @usage struct "ButtonState" {
	--
	--}
	------------------------------------
	function struct(name)
		if type(name) ~= "string" or name:find("%.") or not name:match("[_%w]+") then
			error([[Usage: struct "structname"]], 2)
		end
		local fenv = getfenv(2)
		local ns = GetNameSpace4Env(fenv)

		-- Create class or get it
		local strt

		name = name:match("[_%w]+")

		if ns then
			strt = BuildNameSpace(ns, name)

			if _NSInfo[strt] then
				if _NSInfo[strt].Type and _NSInfo[strt].Type ~= TYPE_STRUCT then
					error(("%s is existed as %s, not struct."):format(name, tostring(_NSInfo[strt].Type)), 2)
				end

				if _NSInfo[strt].BaseEnv and _NSInfo[strt].BaseEnv ~= fenv then
					error(("%s is defined in another place, can't be defined here."):format(name), 2)
				end
			end
		else
			strt = fenv[name]

			if not(_NSInfo[strt] and _NSInfo[strt].BaseEnv == fenv and _NSInfo[strt].NameSpace == nil and _NSInfo[strt].Type == TYPE_STRUCT) then
				strt = BuildNameSpace(nil, name)
			end
		end

		if not strt then
			error("no struct is created.", 2)
		end

		-- save class to the environment
		rawset(fenv, name, strt)

		-- Build class
		info = _NSInfo[strt]
		info.Type = TYPE_STRUCT
		info.NameSpace = ns
		info.BaseEnv = fenv
		info.Members = nil
		info.ArrayElement = nil
		info.UserValidate = nil
		info.Validate = nil
		info.SubType = _STRUCT_TYPE_MEMBER

		info.StructEnv = info.StructEnv or setmetatable({}, _MetaStrtEnv)
		_StructEnv2Info[info.StructEnv] = info

		-- Clear
		info.Constructor = nil

		wipe(info.StructEnv)

		-- Set namespace
		SetNameSpace4Env(info.StructEnv, strt)

		-- Set the environment to class's environment
		setfenv(2, info.StructEnv)
	end

	------------------------------------
	--- import classes from the given name's namespace to the current environment
	-- @name import
	-- @class function
	-- @param name the namespace's name list, using "." to split.
	-- @usage import "System.Widget"
	------------------------------------
	function import_STRT(name)
		if type(name) ~= "string" and not IsNameSpace(name) then
			error([[Usage: import "namespaceA.namespaceB"]], 2)
		end

		if type(name) == "string" and name:find("%.%s*%.") then
			error("the namespace 's name can't have empty string between dots.", 2)
		end

		local env = getfenv(2)

		local info = _StructEnv2Info[env]

		if not info then
			error("can't use import here.", 2)
		end

		local ns

		if type(name) == "string" then
			ns = GetNameSpace(GetDefaultNameSpace(), name)
		elseif IsNameSpace(name) then
			ns = name
		end

		if not ns then
			error(("no namespace is found with name : %s"):format(name), 2)
		end

		info.Import4Env = info.Import4Env or {}

		for _, v in ipairs(info.Import4Env) do
			if v == ns then
				return
			end
		end

		tinsert(info.Import4Env, ns)
	end

	function structtype(name)
		if type(name) ~= "string" then
			error([[Usage: structtype "Member"|"Array"|"Custom"]], 2)
		end

		local env = getfenv(2)

		local info = _StructEnv2Info[env]

		if not info then
			error("can't use structtype here.", 2)
		end

		name = name:upper()

		if name == "MEMBER" then
			-- use member list, default type
			info.SubType = _STRUCT_TYPE_MEMBER
			info.ArrayElement = nil
		elseif name == "ARRAY" then
			-- user array list
			info.SubType = _STRUCT_TYPE_ARRAY
			info.Members = nil
		else
			-- else all custom
			info.SubType = _STRUCT_TYPE_CUSTOM
			info.Members = nil
			info.ArrayElement = nil
		end
	end

	------------------------------------
	--- End the class's definition and restore the environment
	-- @name class
	-- @class function
	-- @param name the name of the class
	-- @usage endclass "Form"
	------------------------------------
	function endstruct(name)
		if type(name) ~= "string" or name:find("%.") then
			error([[Usage: endstruct "structname"]], 2)
		end

		local env = getfenv(2)

		while rawget(_StructEnv2Info, env) do
			local info = _StructEnv2Info[env]

			if info.Name == name then
				setfenv(2, info.BaseEnv)
				return
			end

			env = info.BaseEnv
		end

		error(("no struct is found with name: %s"):format(name), 2)
	end

	_KeyWord4StrtEnv.struct = struct
	_KeyWord4StrtEnv.import = import_STRT
	_KeyWord4StrtEnv.structtype = structtype
	_KeyWord4StrtEnv.endstruct = endstruct
end

------------------------------------------------------
-- System Namespace
------------------------------------------------------
do
	namespace "System"
end

------------------------------------------------------
-- System.Reflector
------------------------------------------------------
do
	interface "Reflector"
		_NSInfo = _NSInfo
		TYPE_CLASS = TYPE_CLASS
		TYPE_STRUCT = TYPE_STRUCT
		TYPE_ENUM = TYPE_ENUM
		TYPE_INTERFACE = TYPE_INTERFACE

		local GetNameSpace = GetNameSpace
		local GetDefaultNameSpace = GetDefaultNameSpace
		local IsChildClass = IsChildClass
		local IsExtend = IsExtend
		local unpack = unpack
		local tinsert = tinsert
		local sort = table.sort
		local IsType = IsType

		------------------------------------
		--- Get the namespace for the name
		-- @name ForName
		-- @class function
		-- @param name the namespace's name, split by "."
		-- @return namespace the namespace
		-- @usage System.Reflector.ForName("System")
		------------------------------------
		function ForName(name)
			return GetNameSpace(GetDefaultNameSpace(), name)
		end

		------------------------------------
		--- Get the type for the namespace
		-- @name GetType
		-- @class function
		-- @param name the namespace
		-- @return type
		-- @usage System.Reflector.GetType("System.Object")
		------------------------------------
		function GetType(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			return ns and rawget(_NSInfo, ns) and _NSInfo[ns].Type
		end

		------------------------------------
		--- Get the name for the namespace
		-- @name GetName
		-- @class function
		-- @param name the namespace
		-- @return name
		-- @usage System.Reflector.GetName(System.Object)
		------------------------------------
		function GetName(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			return ns and rawget(_NSInfo, ns) and _NSInfo[ns].Name
		end

		------------------------------------
		--- Get the full name for the namespace
		-- @name GetFullName
		-- @class function
		-- @param name the namespace
		-- @return name
		-- @usage System.Reflector.GetFullName(System.Object)
		------------------------------------
		function GetFullName(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			return GetFullName4NS(ns)
		end

		------------------------------------
		--- Get the superclass for the class
		-- @name GetSuperClass
		-- @class function
		-- @param class
		-- @return superclass
		-- @usage System.Reflector.GetSuperClass(System.Object)
		------------------------------------
		function GetSuperClass(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			return ns and rawget(_NSInfo, ns) and _NSInfo[ns].SuperClass
		end

		------------------------------------
		--- Check if the object is a NameSpace
		-- @name IsNameSpace
		-- @class function
		-- @param obj
		-- @return boolean
		-- @usage System.Reflector.IsNameSpace(System.Object)
		------------------------------------
		function IsNameSpace(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			return ns and rawget(_NSInfo, ns) and true or false
		end

		------------------------------------
		--- Check if the namespace is a class
		-- @name IsClass
		-- @class function
		-- @param namespace
		-- @return boolean
		-- @usage System.Reflector.IsClass(System.Object)
		------------------------------------
		function IsClass(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			return ns and rawget(_NSInfo, ns) and _NSInfo[ns].Type == TYPE_CLASS or false
		end

		------------------------------------
		--- Check if the namespace is a struct
		-- @name IsStruct
		-- @class function
		-- @param namespace
		-- @return boolean
		-- @usage System.Reflector.IsStruct(System.Object)
		------------------------------------
		function IsStruct(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			return ns and rawget(_NSInfo, ns) and _NSInfo[ns].Type == TYPE_STRUCT or false
		end

		------------------------------------
		--- Check if the namespace is an enum
		-- @name IsEnum
		-- @class function
		-- @param namespace
		-- @return boolean
		-- @usage System.Reflector.IsEnum(System.Object)
		------------------------------------
		function IsEnum(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			return ns and rawget(_NSInfo, ns) and _NSInfo[ns].Type == TYPE_ENUM or false
		end

		------------------------------------
		--- Check if the namespace is an interface
		-- @name IsInterface
		-- @class function
		-- @param namespace
		-- @return boolean
		-- @usage System.Reflector.IsInterface(System.IFSocket)
		------------------------------------
		function IsInterface(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			return ns and rawget(_NSInfo, ns) and _NSInfo[ns].Type == TYPE_INTERFACE or false
		end

		------------------------------------
		--- Get the sub namespace of the namespace
		-- @name GetSubNamespace
		-- @class function
		-- @param namespace
		-- @return table
		-- @usage System.Reflector.GetSubNamespace(System)
		------------------------------------
		function GetSubNamespace(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and _NSInfo[ns]

			if info and info.SubNS then
				local ret = {}

				for key in pairs(info.SubNS) do
					tinsert(ret, key)
				end

				sort(ret)

				return ret
			end
		end

		------------------------------------
		--- Get the extend interfaces of the class
		-- @name GetExtendInterfaces
		-- @class function
		-- @param class
		-- @return table
		-- @usage System.Reflector.GetExtendInterfaces(System.Object)
		------------------------------------
		function GetExtendInterfaces(cls)
			if type(cls) == "string" then cls = ForName(cls) end

			local info = cls and _NSInfo[cls]

			if info.ExtendInterface then
				local ret = {}

				for IF in pairs(info.ExtendInterface) do
					tinsert(ret, IF)
				end

				return ret
			end
		end

		------------------------------------
		--- Get the child classes of the class
		-- @name GetChildClasses
		-- @class function
		-- @param class
		-- @return table
		-- @usage System.Reflector.GetChildClasses(System.Object)
		------------------------------------
		function GetChildClasses(cls)
			if type(cls) == "string" then cls = ForName(cls) end

			local info = cls and _NSInfo[cls]

			if info.Type == TYPE_CLASS and info.ChildClass then
				local ret = {}

				for subCls in pairs(info.ChildClass) do
					tinsert(ret, subCls)
				end

				return ret
			end
		end

		------------------------------------
		--- Get the scripts of the class
		-- @name GetScripts
		-- @class function
		-- @param namespace
		-- @param noSuper
		-- @return table
		-- @usage System.Reflector.GetScripts(System.Object)
		------------------------------------
		function GetScripts(ns, noSuper)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and _NSInfo[ns]

			if info and (info.Type == TYPE_CLASS or info.Type == TYPE_INTERFACE) then
				local ret = {}

				for i, v in pairs(noSuper and info.Script or info.Cache4Script) do
					if v then
						tinsert(ret, i)
					end
				end

				sort(ret)

				return ret
			end
		end

		------------------------------------
		--- Get the properties of the class
		-- @name GetProperties
		-- @class function
		-- @param namespace
		-- @param [noSuper] true if only get the properties defined in the class.
		-- @return table
		-- @usage System.Reflector.GetProperties(System.Object)
		------------------------------------
		function GetProperties(ns, noSuper)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and _NSInfo[ns]

			if info and (info.Type == TYPE_CLASS or info.Type == TYPE_INTERFACE) then
				local ret = {}

				for i, v in pairs(noSuper and info.Property or info.Cache4Property) do
					if v then
						tinsert(ret, i)
					end
				end

				sort(ret)

				return ret
			end
		end

		------------------------------------
		--- Get the methods of the class
		-- @name GetMethods
		-- @class function
		-- @param namespace
		-- @param noSuper
		-- @return table
		-- @usage System.Reflector.GetMethods(System.Object)
		------------------------------------
		function GetMethods(ns, noSuper)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and _NSInfo[ns]

			if info and (info.Type == TYPE_CLASS or info.Type == TYPE_INTERFACE) then
				local ret = {}

				for i, v in pairs(noSuper and info.Method or info.Cache4Method) do
					if v then
						tinsert(ret, i)
					end
				end

				sort(ret)

				return ret
			end
		end

		------------------------------------
		--- Get the property type of the class
		-- @name GetPropertyType
		-- @class function
		-- @param namespace
		-- @param propName
		-- @return table
		-- @usage System.Reflector.GetPropertyType(System.Object, "Name")
		------------------------------------
		function GetPropertyType(ns, propName)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and _NSInfo[ns]

			if info and (info.Type == TYPE_CLASS or info.Type == TYPE_INTERFACE) and info.Cache4Property[propName] then
				local ty = info.Cache4Property[propName].Type

				return ty and ty:Copy()
			end
		end

		------------------------------------
		--- whether the property is existed
		-- @name HasProperty
		-- @class function
		-- @param namespace
		-- @param propName
		-- @return boolean
		-- @usage System.Reflector.HasProperty(System.Object, "Name")
		------------------------------------
		function HasProperty(ns, propName)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and _NSInfo[ns]

			if info and (info.Type == TYPE_CLASS or info.Type == TYPE_INTERFACE) and info.Cache4Property[propName] then
				return true
			end

			return false
		end

		------------------------------------
		--- whether the property is readable
		-- @name IsPropertyReadable
		-- @class function
		-- @param namespace
		-- @param propName
		-- @return boolean
		-- @usage System.Reflector.IsPropertyReadable(System.Object, "Name")
		------------------------------------
		function IsPropertyReadable(ns, propName)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and _NSInfo[ns]

			if info and (info.Type == TYPE_CLASS or info.Type == TYPE_INTERFACE) and info.Cache4Property[propName] then
				return type(info.Cache4Property[propName].Get) == "function"
			end
		end

		------------------------------------
		--- whether the property is writable
		-- @name IsPropertyWritable
		-- @class function
		-- @param namespace
		-- @param propName
		-- @return boolean
		-- @usage System.Reflector.IsPropertyWritable(System.Object, "Name")
		------------------------------------
		function IsPropertyWritable(ns, propName)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and _NSInfo[ns]

			if info and (info.Type == TYPE_CLASS or info.Type == TYPE_INTERFACE) and info.Cache4Property[propName] then
				return type(info.Cache4Property[propName].Set) == "function"
			end
		end

		------------------------------------
		--- Get the enums of the enum
		-- @name GetEnums
		-- @class function
		-- @param namespace
		-- @return table
		-- @usage System.Reflector.GetEnums(System.SampleEnum)
		------------------------------------
		function GetEnums(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and _NSInfo[ns]

			if info and info.Type == TYPE_ENUM then
				local tmp = {}

				for i in pairs(info.Enum) do
					tinsert(tmp, i)
				end

				sort(tmp)

				return tmp
			end
		end

		------------------------------------
		--- Get the enum index of the enum value
		-- @name ParseEnum
		-- @class function
		-- @param namespace
		-- @param value
		-- @return table
		-- @usage System.Reflector.ParseEnum(System.SampleEnum, 1)
		------------------------------------
		function ParseEnum(ns, value)
			if type(ns) == "string" then ns = ForName(ns) end

			if ns and _NSInfo[ns] and _NSInfo[ns].Type == TYPE_ENUM and _NSInfo[ns].Enum then
				for n, v in pairs(_NSInfo[ns].Enum) do
					if v == value then
						return n
					end
				end
			end
		end

		------------------------------------
		--- Check if the class has that script
		-- @name System.Reflector.HasScript
		-- @class function
		-- @param class the class that need to check
		-- @param script the script name
		-- @return true if the class has this script, otherwise false, nil when no class is found.
		-- @usage System.Reflector.HasScript(Addon, "OnEvent")
		------------------------------------
		function HasScript(cls, sc)
			if type(cls) == "string" then cls = ForName(cls) end

			local info = _NSInfo[cls]

			if info and (info.Type == TYPE_CLASS or info.Type == TYPE_INTERFACE) then
				return info.Cache4Script[sc] or false
			end
		end

		------------------------------------
		--- Get the parts of the struct
		-- @name System.Reflector.GetStructParts
		-- @class function
		-- @param struct the struct
		-- @return a list to contains the parts' names
		-- @usage System.Reflector.GetStructParts(Position)
		------------------------------------
		function GetStructParts(ns)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and rawget(_NSInfo, ns)

			if info and info.Type == TYPE_STRUCT and info.Members and #info.Members > 0 then
				local tmp = {}

				for _, part in ipairs(info.Members) do
					tinsert(tmp, part)
				end

				return tmp
			end
		end

		------------------------------------
		--- Get the part's type of the struct
		-- @name System.Reflector.GetStructPart
		-- @class function
		-- @param struct the struct
		-- @param part the name of the part
		-- @return type of the part of the struct
		-- @usage System.Reflector.GetStructPart(Position, "x")
		------------------------------------
		function GetStructPart(ns, part)
			if type(ns) == "string" then ns = ForName(ns) end

			local info = ns and rawget(_NSInfo, ns)

			if info and info.Type == TYPE_STRUCT and info.Members and #info.Members > 0  then
				for _, p in ipairs(info.Members) do
					if p == part and IsType(info.StructEnv[p]) then
						return info.StructEnv[p]:Copy()
					end
				end
			end
		end

		------------------------------------
		--- Check if this first arg is a child class of the next arg
		-- @name System.Reflector.IsSuperClass
		-- @class function
		-- @param child the child class
		-- @param suepr the super class
		-- @return flag
		-- @usage System.Reflector.IsSuperClass(UIObject, Object)
		------------------------------------
		function IsSuperClass(child, super)
			if type(child) == "string" then child = ForName(child) end
			if type(super) == "string" then super = ForName(super) end

			return IsClass(child) and IsClass(super) and IsChildClass(super, child)
		end

		------------------------------------
		--- Check if the class is extended from the interface
		-- @name System.Reflector.IsExtendedInterface
		-- @class function
		-- @param cls the class
		-- @param IF the interface
		-- @return flag
		-- @usage System.Reflector.IsExtendedInterface(UIObject, IFSocket)
		------------------------------------
		function IsExtendedInterface(cls, IF)
			if type(cls) == "string" then cls = ForName(cls) end
			if type(IF) == "string" then IF = ForName(IF) end

			return IsExtend(IF, cls)
		end

		------------------------------------
		--- Get the class type of this object
		-- @name System.Reflector.GetObjectClass
		-- @class function
		-- @param obj the object
		-- @usage System.Reflector.GetObjectClass(obj)
		------------------------------------
		function GetObjectClass(obj)
			return type(obj) == "table" and getmetatable(obj)
		end

		------------------------------------
		--- Check if this object is an instance of the class
		-- @name System.Reflector.ObjectIsClass
		-- @class function
		-- @param obj the object
		-- @param class	the class type that you want to check if this object is an instance of.
		-- @usage System.Reflector.ObjectIsClass(obj, Object)
		------------------------------------
		function ObjectIsClass(obj, cls)
			if type(cls) == "string" then cls = ForName(cls) end
			return (obj and cls and IsChildClass(cls, GetObjectClass(obj))) or false
		end

		------------------------------------
		--- Check if this object is an instance of the interface
		-- @name System.Reflector.ObjectIsClass
		-- @class function
		-- @param obj the object
		-- @param class	the class type that you want to check if this object is an instance of.
		-- @usage System.Reflector.ObjectIsClass(obj, Object)
		------------------------------------
		function ObjectIsInterface(obj, IF)
			if type(IF) == "string" then IF = ForName(IF) end
			return (obj and IF and IsExtend(IF, GetObjectClass(obj))) or false
		end

		------------------------------------
		--- Active thread mode for special scripts.
		-- @name ActiveThread
		-- @class function
		-- @param obj object
		-- @param ... script name list
		-- @usage System.Reflector.ActiveThread(obj, "OnClick", "OnEnter")
		------------------------------------
		function ActiveThread(obj, ...)
			local cls = GetObjectClass(obj)
			local name

			if cls then
				for i = 1, select('#', ...) do
					name = select(i, ...)

					if HasScript(cls, name) then
						obj[name]._ThreadActived = true
					end
				end
			end
		end

		------------------------------------
		--- Whether the thread mode is actived for special scripts.
		-- @name IsThreadActived
		-- @class function
		-- @param obj object
		-- @param script
		-- @usage System.Reflector.IsThreadActived(obj, "OnClick")
		------------------------------------
		function IsThreadActived(obj, sc)
			local cls = GetObjectClass(obj)
			local name

			if cls and HasScript(cls, sc) then
				return obj[sc]._ThreadActived or false
			end

			return false
		end

		------------------------------------
		--- Inactive thread mode for special scripts.
		-- @name InactiveThread
		-- @class function
		-- @param obj object
		-- @param ... script name list
		-- @usage System.Reflector.InactiveThread(obj, "OnClick", "OnEnter")
		------------------------------------
		function InactiveThread(obj, ...)
			local cls = GetObjectClass(obj)
			local name

			if cls then
				for i = 1, select('#', ...) do
					name = select(i, ...)

					if HasScript(cls, name) then
						obj[name]._ThreadActived = nil
					end
				end
			end
		end

		------------------------------------
		--- Block script for object
		-- @name BlockScript
		-- @class function
		-- @param obj object
		-- @param ... script name list
		-- @usage System.Reflector.BlockScript(obj, "OnClick", "OnEnter")
		------------------------------------
		function BlockScript(obj, ...)
			local cls = GetObjectClass(obj)
			local name

			if cls then
				for i = 1, select('#', ...) do
					name = select(i, ...)

					if HasScript(cls, name) then
						obj[name]._Blocked = true
					end
				end
			end
		end

		------------------------------------
		--- Whether the script is blocked for object
		-- @name IsScriptBlocked
		-- @class function
		-- @param obj object
		-- @param script
		-- @usage System.Reflector.IsScriptBlocked(obj, "OnClick")
		------------------------------------
		function IsScriptBlocked(obj, sc)
			local cls = GetObjectClass(obj)
			local name

			if cls and HasScript(cls, sc) then
				return obj[sc]._Blocked or false
			end

			return false
		end

		------------------------------------
		--- Un-Block script for object
		-- @name UnBlockScript
		-- @class function
		-- @param obj object
		-- @param ... script name list
		-- @usage System.Reflector.UnBlockScript(obj, "OnClick", "OnEnter")
		------------------------------------
		function UnBlockScript(obj, ...)
			local cls = GetObjectClass(obj)
			local name

			if cls then
				for i = 1, select('#', ...) do
					name = select(i, ...)

					if HasScript(cls, name) then
						obj[name]._Blocked = nil
					end
				end
			end
		end

		--[[----------------------------------
		--- Build type.
		-- @name BuildType
		-- @class function
		-- @param type value's type
		-- @param name type's name
		-- @usage System.Reflector.BuildType(System.String+nil, "Mark")
		------------------------------------
		function BuildType(types, name)
			local ok, _type = pcall(_BuildType, types, name)

			if not ok then
				_type = strtrim(_type:match(":%d+:(.*)$") or _type)

				error("Usage : System.Reflector.BuildType(type[, name]) : " .. _type, 2)
			end

			return _type
		end--]]

		_Test_Type = _BuildType(nil)

		------------------------------------
		--- Validating the value to the given type.
		-- @name Validate
		-- @class function
		-- @param type value's type
		-- @param value test value
		-- @pram name the parameter's name
		-- @param prefix optional, the prefix string
		-- @param stacklevel optinal, number, set if not in the main function call, only work when prefix is setted
		-- @usage System.Reflector.Validate(System.String+nil, "Test")
		------------------------------------
		function Validate(types, value, name, prefix, stacklevel)
			stacklevel = type(stacklevel) == "number" and stacklevel > 0 and stacklevel or 0

			stacklevel = math.floor(stacklevel)

			if type(name) ~= "string" then name = "value" end

			if types == nil then
				return value
			end

			if IsNameSpace(types) then
				_Test_Type.AllowNil = nil
				_Test_Type[1] = types
				_Test_Type.Name = name

				types = _Test_Type
			end

			local ok, _type = pcall(_BuildType, types, name)

			if ok then
				if _type then
					ok, value = pcall(_type.Validate, _type, value)

					if not ok then
						value = strtrim(value:match(":%d+:(.*)$") or value)

						if value:find("%%s") then
							value = value:gsub("%%s[_%w]*", name)
						end

						if type(prefix) == "string" then
							error(prefix .. value, 3 + stacklevel)
						else
							error(value, 2)
						end
					end
				end

				return value
			else
				error("Usage : System.Reflector.Validate(type, value[, name[, prefix]]) : type - must be nil, enum, struct or class.", 2)
			end

			return value
		end

	endinterface "Reflector"
end

------------------------------------------------------
-- Global Settings
------------------------------------------------------
do
	---[[
	_G.partclass = _G.partclass or partclass
	_G.class = _G.class or class
	_G.enum = _G.enum or enum
	_G.namespace = _G.namespace or namespace
	_G.struct = _G.struct or struct
	_G.interface = _G.interface or interface
	_G.import = function(name, all)
		local ns = Reflector.ForName(name)
		local env = getfenv(2)

		if ns and env then
			env[Reflector.GetName(ns)] = ns

			if all then
				for _, subNs in ipairs(Reflector.GetSubNamespace(ns)) do
					env[subNs] = ns[subNs]
				end
			end
		else
			error("No such namespace.", 2)
		end
	end
	--]]

	_Class_KeyWords.namespace = namespace
	_Class_KeyWords.class = class
	_Class_KeyWords.partclass = partclass
	_Class_KeyWords.enum = enum
	_Class_KeyWords.struct = struct
	_Class_KeyWords.interface = interface

	function IGAS:GetNameSpace(ns)
		return Reflector.ForName(ns)
	end
end
