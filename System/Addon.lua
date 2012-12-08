-- Addon & Module System
-- Author: kurapica.igas@gmail.com
-- Create Date : 2011/02/26
-- ChangeLog   :
--						2011/03/16	Modify the enable-disable system.
--						2011/06/12	Allow access Base namespaces without imports them.
--						2011/06/27	GetModules method added for addon & module
--                      2011/08/03  Hook System added.
--                      2011/10/29  OnHook Script added.
--                      2011/10/31  New SlashCmd System for addon & module.

----------------------------------------------------------------------------------------------------------------------------------------
--- Addon is an class type for addons in IGAS.The addon class supply some methods, to help authors to manager their addons easily.
-- an addon is also a private scope using to contains it's own functions and variables.
-- addons can access _G's functions and variables, and making an image in itself at the same time.When it access a frame in _G, it'll automatically convert it to an IGAS' frame into the addon' scope.
-- @name Addon
-- @class table
-- @field _Addon the addon self, readonly
-- @field _Name the addon's name, readonly
-- @field _Version the addon's version
-- @field _Enabled whether the addon is enabled or disabled.
-- @field _AutoWrapper whether the addon would auto making wrappers for frames defined in _G when the addon access it.
-- @field _Metadata the addon's metatable
----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------
--- Module is an class type for module in IGAS.a module is contained in an addon or another module.
-- a module is also a private scope.It can access all resources defined in it's container.
-- @name Module
-- @class table
-- @field _M the module self, readonly
-- @field _Name the module's name, readonly
-- @field _Version the module's version
-- @field _Enabled whether the module is enabled or disabled.
-- @field _Parent the module's parent module(addon)
----------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------
-- Version Check & Environment
------------------------------------------------------
do
	local version = 14

	local _Meta = getmetatable(IGAS)

	-- Version Check
	if _Meta._IGAS_Addon_Version and _Meta._IGAS_Addon_Version >= version then
		return
	end

	_Meta._IGAS_Addon_Version = version

	-- Class Environment
	_Meta._Addon_ENV = _Meta._Addon_ENV or {}

	setmetatable(_Meta._Addon_ENV, {
		__index = function(self,  key)
			if type(key) == "string" and key ~= "_G" and key:find("^_") then
				return
			end

			if _Meta._Class_KeyWords[key] then
				return _Meta._Class_KeyWords[key]
			end

			if _G[key] then
				rawset(self, key, _G[key])
				return rawget(self, key)
			end
		end,
	})

	-- Special
	_Meta._Addon_ENV._Class_KeyWords = _Meta._Class_KeyWords

	setfenv(1, _Meta._Addon_ENV)

	-- Scripts
	strtrim = strtrim or function(s)
	  return (s:gsub("^%s*(.-)%s*$", "%1")) or ""
	end

	wipe = wipe or function(t)
		for k in pairs(t) do
			t[k] = nil
		end
	end

	errorhandler = errorhandler or function(err)
		return geterrorhandler and geterrorhandler()(err) or print(err)
	end

	tinsert = tinsert or table.insert
	tremove = tremove or table.remove
end

namespace "System"

------------------------------------------------------
-- Storage Definition
------------------------------------------------------
_MetaWK = _MetaWK or {__mode = "k"}
_MetaWV = _MetaWV or {__mode = "v"}
_MetaWKV = _MetaWKV or {__mode = "kv"}

_Addon = _Addon or {}
_Info = _Info or setmetatable({}, _MetaWK)

_Special_KeyWord = _Special_KeyWord or {}

_Logined = _Logined or false

issecurevariable = issecurevariable or function() return false end

------------------------------------------------------
-- IFModule
------------------------------------------------------
interface "IFModule"

	_MetaWK = _MetaWK
	_MetaWV = _MetaWV
	_MetaWKV = _MetaWKV

	_Info = _Info

	------------------------------------------------------
	-- _EventManager
	--
	-- _EventManager:Register(event, obj)
	-- _EventManager:IsRegistered(event, obj)
	-- _EventManager:Unregister(event, obj)
	-- _EventManager:UnregisterAll(obj)
	------------------------------------------------------
	do
		------------------------------------------------------
		-- For World of Warcraft
		------------------------------------------------------
		if CreateFrame then
			_EventManager = _EventManager or CreateFrame("Frame")
			_EventDistribution =  _EventDistribution or {}

			_UsedEvent = _UsedEvent or {}

			-- Register
			function _EventManager:Register(event, obj)
				if type(event) == "string" and event ~= "" then
					self:RegisterEvent(event)

					if self:IsEventRegistered(event) then
						_EventDistribution[event] = _EventDistribution[event] or setmetatable({}, _MetaWK)

						_EventDistribution[event][obj] = true
					else
						return Object.RegisterEvent(obj, event)
					end
				end
			end

			-- IsRegistered
			function _EventManager:IsRegistered(event, obj)
				if _EventDistribution[event] then
					return _EventDistribution[event][obj] or false
				else
					return Object.IsEventRegistered(obj, event)
				end
			end

			-- Unregister
			function _EventManager:Unregister(event, obj)
				if type(event) == "string" and event ~= "" then
					if _EventDistribution[event] then
						_EventDistribution[event][obj] = nil

						if not next(_EventDistribution[event]) and not _UsedEvent[event] then
							self:UnregisterEvent(event)
						end
					else
						return Object.UnregisterEvent(obj, event)
					end
				end
			end

			-- UnregisterAll
			function _EventManager:UnregisterAll(obj)
				for event, data in pairs(_EventDistribution) do
					if data[obj] then
						data[obj] = nil

						if not next(data) and not _UsedEvent[event] then
							self:UnregisterEvent(event)
						end
					end
				end

				return Object.UnregisterAllEvents(obj)
			end

			--  Special Settings for _EventManager
			do
				function _EventManager:OnEvent(event, ...)
					local chk, ret

					if type(self[event]) == "function" then
						chk, ret = pcall(self[event], self, ...)
						if not chk then
							errorhandler(ret)
						end
					end

					if _EventDistribution[event] then
						for obj in pairs(_EventDistribution[event]) do
							if not _Info[obj].Disabled then
								Object.Fire(obj, "OnEvent", event, ...)
							end
						end
					end
				end

				-- Loading
				local function loading(self)
					Object.Fire(self, "OnLoad")

					if _Info[self].Module then
						for _, mdl in pairs(_Info[self].Module) do
							loading(mdl)
						end
					end
				end

				-- Enabling
				local function enabling(self)
					if not _Info[self].Disabled then
						Object.Fire(self, "OnEnable")

						if _Info[self].Module then
							for _, mdl in pairs(_Info[self].Module) do
								enabling(mdl)
							end
						end
					end
				end

				function _EventManager:ADDON_LOADED(addonName)
					local addon = _Addon[addonName]

					if addon and _Info[addon].SavedVariables then
						-- relocate savedvariables
						for svn in pairs(_Info[addon].SavedVariables) do
							_G[svn] = _G[svn] or {}
							addon[svn] = _G[svn]
						end

						_Info[addon].SavedVariables = nil
					end

					if addon and not _Info[addon].Loaded then
						_Info[addon].Loaded = true

						-- Fire OnLoad, addon no need register ADDON_LOADED self.
						loading(addon)

						if _Logined then
							-- enable addon if player was already in game.
							enabling(addon)
						end
					end
				end

				function _EventManager:PLAYER_LOGIN()
					for _, addon in pairs(_Addon) do
						if _Info[addon].SavedVariables then
							-- relocate savedvariables
							for svn in pairs(_Info[addon].SavedVariables) do
								_G[svn] = _G[svn] or {}
								addon[svn] = _G[svn]
							end

							_Info[addon].SavedVariables = nil
						end

						if not _Info[addon].Loaded then
							_Info[addon].Loaded = true
							loading(addon)
						end

						-- Enabling addons
						enabling(addon)
					end

					_Logined = true
				end

				_UsedEvent.ADDON_LOADED = true
				_UsedEvent.PLAYER_LOGIN = true

				_EventManager:Hide()
				_EventManager:UnregisterAllEvents()
				for event, flag in pairs(_UsedEvent) do
					if flag then
						_EventManager:RegisterEvent(event)
					end
				end

				_EventManager:SetScript("OnEvent", _EventManager.OnEvent)
			end
		end
	end

	------------------------------------------------------
	-- _HookManager
	--
	-- _HookManager:Hook(obj, target, targetFunc, handler)
	-- _HookManager:UnHook(obj, target, targetFunc)
	-- _HookManager:UnHookAll(obj)
	--
	-- _HookManager:SecureHook(obj, target, targetFunc, handler)
	-- _HookManager:SecureUnHook(obj, target, targetFunc)
	-- _HookManager:SecureUnHookAll(obj)
	------------------------------------------------------
	do
		_HookManager = _HookManager or {}
		_HookDistribution = _HookDistribution or {}

		function _HookManager:Hook(obj, target, targetFunc, handler)
			if type(target[targetFunc]) == "function" or (_HookDistribution[target] and _HookDistribution[target][targetFunc]) then
				if issecurevariable(target, targetFunc) then
					error(("'%s' is secure method, use SecureHook instead."):format(targetFunc), 3)
				end

				_HookDistribution[target] = _HookDistribution[target] or {}

				local _store = _HookDistribution[target][targetFunc]

				if not _store then
					_HookDistribution[target][targetFunc] = setmetatable({}, _MetaWK)

					local _orig = target[targetFunc]

					_store = _HookDistribution[target][targetFunc]

					_HookDistribution[target][targetFunc][0] = function(...)
						for mdl, func in pairs(_store) do
							if mdl ~= 0 and not _Info[mdl].Disabled then
								if func == true then
									Object.Fire(mdl, "OnHook", targetFunc, ...)
								else
									Object.Fire(mdl, "OnHook", func, ...)
								end
							end
						end

						return _orig(...)
					end

					target[targetFunc] = _HookDistribution[target][targetFunc][0]
				end

				_store[obj] = (type(handler) == "function" or type(handler) == "string") and handler or true
			else
				error(("No method named '%s' can be found."):format(targetFunc), 3)
			end
		end

		function _HookManager:UnHook(obj, target, targetFunc)
			if _HookDistribution[target] then
				if type(targetFunc) == "string" then
					if _HookDistribution[target][targetFunc] then
						_HookDistribution[target][targetFunc][obj] = nil
					end
				elseif targetFunc == nil then
					for _, store in pairs(_HookDistribution[target]) do
						store[obj] = nil
					end
				end
			end
		end

		function _HookManager:UnHookAll(obj)
			for _, pool in pairs(_HookDistribution) do
				for _, store in pairs(pool) do
					store[obj] = nil
				end
			end
		end

		if type(hooksecurefunc) == "function" then
			_SecureHookDistribution = _SecureHookDistribution or {}

			function _HookManager:SecureHook(obj, target, targetFunc, handler)
				if type(target[targetFunc]) == "function" or (_SecureHookDistribution[target] and _SecureHookDistribution[target][targetFunc]) then
					_SecureHookDistribution[target] = _SecureHookDistribution[target] or {}

					local _store = _SecureHookDistribution[target][targetFunc]

					if not _store then
						_SecureHookDistribution[target][targetFunc] = setmetatable({}, _MetaWK)

						_store = _SecureHookDistribution[target][targetFunc]

						_SecureHookDistribution[target][targetFunc][0] = function(...)
							for mdl, func in pairs(_store) do
								if mdl ~= 0 and not _Info[mdl].Disabled then
									if func == true then
										Object.Fire(mdl, "OnHook", targetFunc, ...)
									else
										Object.Fire(mdl, "OnHook", func, ...)
									end
								end
							end
						end

						hooksecurefunc(target, targetFunc, _SecureHookDistribution[target][targetFunc][0])
					end

					_store[obj] = (type(handler) == "function" or type(handler) == "string") and handler or true
				else
					error(("No method named '%s' can be found."):format(targetFunc), 3)
				end
			end

			function _HookManager:SecureUnHook(obj, target, targetFunc)
				if _SecureHookDistribution[target] then
					if type(targetFunc) == "string" then
						if _SecureHookDistribution[target][targetFunc] then
							_SecureHookDistribution[target][targetFunc][obj] = nil
						end
					elseif targetFunc == nil then
						for _, store in pairs(_SecureHookDistribution[target]) do
							store[obj] = nil
						end
					end
				end
			end

			function _HookManager:SecureUnHookAll(obj)
				for _, pool in pairs(_SecureHookDistribution) do
					for _, store in pairs(pool) do
						store[obj] = nil
					end
				end
			end
		end
	end

	------------------------------------------------------
	-- _SlashCmdManager
	--
	-- _SlashCmdManager:AddSlashCmd(obj, cmd, ...)
	------------------------------------------------------
	do
		if _G["SlashCmdList"] then
			_SlashCmdManager = _SlashCmdManager or {}
			_SlashFuncs = _SlashFuncs or {}

			-- SlashCmd Operation
			local function GetSlashCmdArgs(msg, input)
				local option, info

				if msg and type(msg) == "string" and msg ~= "" then
					msg = strtrim(msg)

					if msg:sub(1, 1) == "\"" and msg:find("\"", 2) then
						option, info = msg:match("\"([^\"]+)\"%s*(.*)")
					else
						option, info = msg:match("(%S+)%s*(.*)")
					end

					if option == "" then option = nil end
					if info == "" then info = nil end
				end

				if IGAS.GetWrapper then
					-- Wrapper the inputbox if IGAS GUI lib is loaded.
					input = IGAS:GetWrapper(input)
				end

				return option, info, input
			end

			local function GetSlashCmd(name)
				_SlashFuncs[name] = _SlashFuncs[name] or function(msg, input)
					local mdl = IGAS:GetAddon(name)
					if mdl then
						return Object.Fire(mdl, "OnSlashCmd", GetSlashCmdArgs(msg, input))
					end
				end
				return _SlashFuncs[name]
			end

			------------------------------------
			--- Add slash commands to an addon
			-- @name _SlashCmdManager:AddSlashCmd
			-- @class function
			-- @param module addon or module
			-- @param slash1 the slash commands, a string started with "/", if not started with "/", will auto add it.
			-- @param slash2, ... Optional,other slash commands
			-- @return nil
			-- @usage _SlashCmdManager:AddSlashCmd(_Addon, "/hw", hw2")
			------------------------------------
			function _SlashCmdManager:AddSlashCmd(obj, ...)
				if not (obj:IsClass(Addon.Module) or obj:IsClass(Addon)) then
					return
				end

				if select('#', ...) == 0 then
					return nil
				end

				local AddName = _Info[obj].Name

				while obj:IsClass(Addon.Module) do
					obj = _Info[obj].Parent

					AddName = _Info[obj].Name .. "." .. AddName
				end

				local slash = {}
				local sl
				for i = 1, select('#', ...) do
					sl = select(i, ...)
					if sl and type(sl) == "string" then
						if sl:match("^/%S+") then
							slash[sl:match("^/%S+")] = true
						elseif sl:match("^%S+") then
							slash["/"..sl:match("^%S+")] = true
						end
					end
				end

				if not next(slash) then
					--error("Usage : Addon:AddSlashCmd(slash1 [, slash2, ...]) : no slash commands found.", 3)
					return
				end

				local index = 1

				while _G["SLASH_"..AddName..index] do
					slash[_G["SLASH_"..AddName..index]] = nil
					index = index + 1
				end

				for cmd in pairs(slash) do
					_G["SLASH_"..AddName..index] = cmd
					index = index + 1
				end

				if not _G["SlashCmdList"][AddName] then
					_G["SlashCmdList"][AddName] = GetSlashCmd(AddName)
				end
			end
		end
	end

	------------------------------------------------------
	-- Special keywords
	------------------------------------------------------
	do
		------------------------------------
		--- import classes from the given name's namespace to the current Addon
		-- @name import
		-- @class function
		-- @param name the namespace's name list, using "." to split.
		-- @usage import "System.Widget"
		------------------------------------
		function _Special_KeyWord.import(name)
			if type(name) ~= "string" then
				error([[Usage: import "namespaceA.namespaceB"]], 2)
			end

			if type(name) == "string" and name:find("%.%s*%.") then
				error("the namespace 's name can't have empty string between dots.", 2)
			end

			local env = getfenv(2)

			local info = _Info[env]

			if not info then
				error("can't use import here.", 2)
			end

			local ns = Reflector.ForName(name)

			if not ns then
				error(("no namespace is found with name : %s"):format(name), 2)
			end

			info.Import = info.Import or {}

			for _, v in ipairs(info.Import) do
				if v == ns then
					return
				end
			end

			tinsert(info.Import, ns)
		end
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	script "OnLoad"
	script "OnEnable"
	script "OnDisable"
	script "OnDispose"
	script "OnSlashCmd"
	script "OnHook"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	if _EventManager then
		------------------------------------
		--- Register a event
		-- @name RegisterEvent
		-- @class function
		-- @param event the event's name
		-- @return nil
		-- @Usage IFModule:RegisterEvent("CUSTOM_EVENT_1")
		------------------------------------
		function RegisterEvent(self, event)
			if type(event) == "string" and event ~= "" then
				return _EventManager:Register(event, self)
			else
				error(("Usage : IFModule:RegisterEvent(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
			end
		end

		------------------------------------
		--- Check if an event is registered for an Module
		-- @name IsEventRegistered
		-- @class function
		-- @param event the event's name
		-- @return true if the event is registered to that Module
		-- @Usage IFModule:IsEventRegistered("CUSTOM_EVENT_1")
		------------------------------------
		function IsEventRegistered(self, event)
			if type(event) == "string" and event ~= "" then
				return _EventManager:IsRegistered(event, self)
			else
				error(("Usage : IFModule:IsEventRegistered(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
			end
		end

		------------------------------------
		--- Undo register all events for the Module
		-- @name UnregisterAllEvents
		-- @class function
		-- @return nil
		-- @Usage IFModule:UnregisterAllEvents()
		------------------------------------
		function UnregisterAllEvents(self)
			return _EventManager:UnregisterAll(self)
		end

		------------------------------------
		--- Undo Register a event for an Module
		-- @name UnregisterEvent
		-- @class function
		-- @param event the event's name
		-- @return nil
		-- @Usage IFModule:UnregisterEvent("CUSTOM_EVENT_1")
		------------------------------------
		function UnregisterEvent(self, event)
			if type(event) == "string" and event ~= "" then
				return _EventManager:Unregister(event, self)
			else
				error(("Usage : IFModule:UnregisterEvent(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
			end
		end
	end

	if _SlashCmdManager then
		------------------------------------
		--- Add slash commands to a module
		-- @name AddSlashCmd
		-- @class function
		-- @param slash1 the slash commands, a string started with "/", if not started with "/", will auto add it.
		-- @param slash2, ... Optional,other slash commands
		-- @return nil
		-- @usage IFModule:AddSlashCmd("/hw", hw2")
		------------------------------------
		function AddSlashCmd(self, ...)
			return _SlashCmdManager:AddSlashCmd(self, ...)
		end
	end

	------------------------------------
	--- Enable the Module.
	-- @name Enable
	-- @class function
	-- @return nil
	-- @usage IFModule:Enable()
	------------------------------------
	function Enable(self)
		if _Info[self].Disabled then
			if _Info[self].Parent and _Info[_Info[self].Parent].Disabled then
				error("The module's parent module(addon) is disabled, can't enable it.", 2)
			end

			_Info[self].Disabled = nil
			_Info[self].DefaultState = nil

			if _Logined then Object.Fire(self, "OnEnable") end

			if not _Info[self].Module then return end

			for _, mdl in pairs(_Info[self].Module) do
				if _Info[mdl].DefaultState ~= false then
					Enable(mdl)
				end
			end
		end
	end

	------------------------------------
	--- Disable the Module.The Module won't receive events.
	-- @name Disable
	-- @class function
	-- @return nil
	-- @usage IFModule:Disable()
	------------------------------------
	function Disable(self)
		if not _Info[self].Disabled then
			_Info[self].Disabled = true

			if _Logined then Object.Fire(self, "OnDisable") end

			if not _Info[self].Module then return end

			for _, mdl in pairs(_Info[self].Module) do
				_Info[mdl].DefaultState = not _Info[mdl].Disabled
				if not _Info[mdl].Disabled then
					Disable(mdl)
				end
			end
		else
			_Info[self].DefaultState = false
		end
	end

	------------------------------------
	--- Check if the Module is enabled
	-- @name IsEnabled
	-- @class function
	-- @return true if the Module is enabled
	-- @usage IFModule:IsEnabled()
	------------------------------------
	function IsEnabled(self)
		return not _Info[self].Disabled
	end

	------------------------------------
	--- This is using to dispose a module, and set the enviroment to it's container if needed.
	-- @name Dispose
	-- @class function
	-- @return nil
	-- @usage IFModule:Dispose()
	------------------------------------
	function Dispose(self)
		local info = _Info[self]
		local chk, ret

		Object.Fire(self, "OnDispose")

		if self.UnregisterAllEvents then
			self:UnregisterAllEvents()
		end

		if info.Module then
			for _, mdl in pairs(info.Module) do
				chk, ret = pcall(mdl.Dispose, mdl)

				if not chk then
					errorhandler(ret)
				end
			end
		end

		if info.Parent then
			if _Info[info.Parent].Module then
				_Info[info.Parent].Module[info.Name] = nil
			end
			if info.Parent[info.Name] == self then
				info.Parent[info.Name] = nil
			end
		end

		wipe(info)
		_Info[self] = nil

		return Object.Dispose(self)
	end

	------------------------------------
	--- Create or get a child-module of this module.And set the environment to the child-module
	-- @name NewModule
	-- @class function
	-- @param name the child-module's name,can be "Mdl1.SubMdl1.SubSubMdl1", use dot to concat
	-- @param version Optional,used for version control, if there is another version, and the old version is equal or great than this one, return nil, else return the child-module
	-- @return the child-module
	-- @usage IFModule:NewModule("Mdl_MyFrame1")
	------------------------------------
	function NewModule(self, name, version)
		if type(name) ~= "string" or strtrim(name) == "" then
			error(("Usage : IFModule:NewModule(name, [version]) : 'name' - string expected, got %s."):format(type(name) == "string" and "empty string" or type(name)), 2)
		end

		if version ~= nil then
			if type(version) ~= "number" then
				error(("Usage : IFModule:NewModule(name, [version]) : 'version' - number expected, got %s."):format(type(version)), 2)
			elseif version < 1 then
				error("Usage : IFModule:NewModule(name, [version]) : 'version' - must be greater than 0.", 2)
			end
		end

		local module = self

		for sub in name:gmatch("[^%.]+") do
			sub = sub and strtrim(sub)
			if not sub or sub =="" then return end

			module = Addon.Module(module, sub)

			if not module then return end
		end

		if not module or module == self then return end

		if version and _Info[module].Version and _Info[module].Version >= version then
			return
		elseif version then
			_Info[module].Version = version
		end

		setfenv(2, module)

		return module
	end

	------------------------------------
	--- Get the child-module of this module.
	-- @name GetModule
	-- @class function
	-- @param name the child-module's name,can be "Mdl1.SubMdl1.SubSubMdl1", use dot to concat
	-- @param create if true, the module will be created if not existed
	-- @return the child-module
	-- @usage IFModule:GetModule("Mdl_MyFrame1")
	------------------------------------
	function GetModule(self, name, create)
		if type(name) ~= "string" or strtrim(name) == "" then
			error(("Usage : IFModule:GetModule(name, [create]) : 'name' - string expected, got %s."):format(type(name) == "string" and "empty string" or type(name)), 2)
		end

		local module = self

		if create then
			for sub in name:gmatch("[^%.]+") do
				sub = sub and strtrim(sub)
				if not sub or sub =="" then return end

				module = Addon.Module(module, sub)

				if not module then return end
			end
		else
			for sub in name:gmatch("[^%.]+") do
				sub = sub and strtrim(sub)
				if not sub or sub =="" then return end

				module =  _Info[module].Module and _Info[module].Module[sub]

				if not module then return end
			end
		end

		if module == self then return end

		return module
	end

	------------------------------------
	--- Get the child-modules of this module.
	-- @name GetModules
	-- @class function
	-- @return the child-module list
	-- @usage IFModule:GetModules()
	------------------------------------
	function GetModules(self)
		if _Info[self].Module then
			local lst = setmetatable({}, _MetaWV)

			for _, mdl in pairs(_Info[self].Module) do
				tinsert(lst, mdl)
			end

			return lst
		end
	end

	------------------------------------
	--- Hook taget's method.
	-- @name Hook
	-- @class function
	-- @param [target] table
	-- @param targetFunc method' name
	-- @param [handler] hook function
	-- @usage IFModule:Hook("print")
	------------------------------------
	function Hook(self, target, targetFunc, handler)
		if type(target) ~= "table" then
			target, targetFunc, handler = _G, target, targetFunc
		end

		if type(target) ~= "table" then
			error("Usage: IFModule:Hook([taget,] targetFunc[, handler]) - 'target' must be a table.", 2)
		end

		if type(targetFunc) ~= "string" then
			error("Usage: IFModule:Hook([taget,] targetFunc[, handler]) - 'targetFunc' must be the name of the method.", 2)
		end

		_HookManager:Hook(self, target, targetFunc, handler)
	end

	------------------------------------
	--- UnHook taget's method.
	-- @name UnHook
	-- @class function
	-- @param [target] table
	-- @param targetFunc method' name
	-- @usage IFModule:UnHook("print")
	------------------------------------
	function UnHook(self, target, targetFunc)
		if type(target) ~= "table" then
			target, targetFunc = _G, target
		end

		if type(target) ~= "table" then
			error("Usage: IFModule:UnHook([taget,] targetFunc) - 'target' must be a table.", 2)
		end

		if type(targetFunc) ~= "string" then
			error("Usage: IFModule:UnHook([taget,] targetFunc) - 'targetFunc' must be the name of the method.", 2)
		end

		_HookManager:UnHook(self, target, targetFunc)
	end

	------------------------------------
	--- UnHookAll all for the module.
	-- @name UnHookAll
	-- @class function
	-- @usage IFModule:UnHookAll()
	------------------------------------
	function UnHookAll(self)
		_HookManager:UnHookAll(self)
	end

	if _HookManager.SecureHook then
		------------------------------------
		--- SecureHook taget's method.
		-- @name SecureHook
		-- @class function
		-- @param [target] table
		-- @param targetFunc method' name
		-- @param [handler] hook function
		-- @usage IFModule:SecureHook("print")
		------------------------------------
		function SecureHook(self, target, targetFunc, handler)
			if type(target) ~= "table" then
				target, targetFunc, handler = _G, target, targetFunc
			end

			if type(target) ~= "table" then
				error("Usage: IFModule:SecureHook([taget,] targetFunc[, handler]) - 'target' must be a table.", 2)
			end

			if type(targetFunc) ~= "string" then
				error("Usage: IFModule:SecureHook([taget,] targetFunc[, handler]) - 'targetFunc' must be the name of the method.", 2)
			end

			_HookManager:SecureHook(self, target, targetFunc, handler)
		end

		------------------------------------
		--- SecureUnHook taget's method.
		-- @name SecureUnHook
		-- @class function
		-- @param [target] table
		-- @param targetFunc method' name
		-- @usage IFModule:SecureUnHook("print")
		------------------------------------
		function SecureUnHook(self, target, targetFunc)
			if type(target) ~= "table" then
				target, targetFunc = _G, target
			end

			if type(target) ~= "table" then
				error("Usage: IFModule:SecureUnHook([taget,] targetFunc) - 'target' must be a table.", 2)
			end

			if type(targetFunc) ~= "string" then
				error("Usage: IFModule:SecureUnHook([taget,] targetFunc) - 'targetFunc' must be the name of the method.", 2)
			end

			_HookManager:SecureUnHook(self, target, targetFunc)
		end

		------------------------------------
		--- SecureUnHookAll all for the module.
		-- @name SecureUnHookAll
		-- @class function
		-- @usage IFModule:SecureUnHookAll()
		------------------------------------
		function SecureUnHookAll(self)
			_HookManager:SecureUnHookAll(self)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- _Name
	property "_Name" {
		Get = function(self)
			return _Info[self].Name
		end,
	}
	-- _Version
	property "_Version" {
		Get = function(self)
			return _Info[self].Version or 0
		end,
		Set = function(self, version)
			if version > (_Info[self].Version or 0) then
				_Info[self].Version = version
			else
				error(("The version must be greater than %d."):format(_Info[self].Version or 0), 2)
			end
		end,
		Type = Number,
	}
	-- _Enabled
	property "_Enabled" {
		Get = function(self)
			return IsEnabled(self)
		end,
		Set = function(self, enabled)
			if enabled then
				Enable(self)
			else
				Disable(self)
			end
		end,
		Type = Boolean,
	}
	-- _Parent
	property "_Parent" {
		Get = function(self)
			return _Info[self].Parent
		end,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnEvent(self, event, ...)
		if type(self[event]) == "function" then
			return self[event](self, ...)
		end
	end

	local function OnHook(self, func, ...)
		if type(func) == "function" then
			return func(...)
		elseif type(self[func]) == "function" then
			return self[func](...)
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFModule(self)
		self.OnEvent = self.OnEvent + OnEvent
		self.OnHook = self.OnHook + OnHook
	end
endinterface "IFModule"

------------------------------------------------------
-- Addon
------------------------------------------------------
class "Addon"
	inherit "Object"
	extend "IFModule"

	_Class_KeyWords = _Class_KeyWords
	_Special_KeyWord = _Special_KeyWord

	_Info = _Info

	------------------------------------------------------
	-- Module
	------------------------------------------------------
	class "Module"
		inherit "Object"
		extend "IFModule"

		_Class_KeyWords = _Class_KeyWords
		_Special_KeyWord = _Special_KeyWord

		_Info = _Info

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		------------------------------------
		--- This is using to dispose a Addon, and set the enviroment to it's container if needed.
		-- @name Addon:Dispose
		-- @class function
		-- @return nil
		-- @usage Addon:Dispose()
		------------------------------------
		function Dispose(self)
			if getfenv(2) == self then
				if _Info[self].Parent then
					setfenv(2, _Info[self].Parent)
				else
					setfenv(2, _G)
				end
			end

			return IFModule.Dispose(self)
		end

		RegisterEvent = IFModule.RegisterEvent
		IsEventRegistered = IFModule.IsEventRegistered
		UnregisterAllEvents = IFModule.UnregisterAllEvents
		UnregisterEvent = IFModule.UnregisterEvent

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		-- _M
		property "_M" {
			Get = function(self)
				return self
			end,
		}

		------------------------------------------------------
		-- Script Handler
		------------------------------------------------------

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
		function Module(parent, name)
			if not Object.IsClass(parent, Module) and not Object.IsClass(parent, Addon) then
				error("Usage : Module(mdl, name) : 'mdl' - Addon or Module expected.", 2)
			end

			if type(name) ~= "string"  then
				error(("Usage : Module(mdl, name) : 'name' - string expected, got %s."):format(type(name)), 2)
			end

			name = name:match("[_%w]+")

			if not name or name == "" then return end

			_Info[parent].Module = _Info[parent].Module or {}
			_Info[parent].Module[name] = Object()

			local mdl = _Info[parent].Module[name]

			rawset(parent, name, mdl)

			_Info[mdl] = {
				Owner = mdl,
				Name = name,
				Parent = parent,
			}

			_Info[mdl].DefaultState = true
			_Info[mdl].Disabled = _Info[parent].Disabled

			return mdl
		end

		------------------------------------------------------
		-- Exist checking
		------------------------------------------------------
		function __exist(cls, parent, name)
			if (Object.IsClass(parent, Module) or Object.IsClass(parent, Addon)) and type(name) == "string" then
				name = name:match("[_%w]+")

				return name and _Info[parent].Module and _Info[parent].Module[name]
			end
		end

		------------------------------------------------------
		-- __index for class instance
		------------------------------------------------------
		function __index(self, key)
			if _Special_KeyWord[key] then
				return _Special_KeyWord[key]
			end

			if _Class_KeyWords[key] then
				return _Class_KeyWords[key]
			end

			-- Check namespace
			local ns = rawget(self, "__IGAS_NameSpace")
			local parent = _Info[self].Parent

			while not ns and parent do
				ns = rawget(parent, "__IGAS_NameSpace")
				parent = _Info[parent].Parent
			end

			if Reflector.GetName(ns) then
				if key == Reflector.GetName(ns) then
					rawset(self, key, ns)
					return rawget(self, key)
				elseif ns[key] then
					rawset(self, key, ns[key])
					return rawget(self, key)
				end
			end

			-- Check imports
			if _Info[self].Import then
				for _, ns in ipairs(_Info[self].Import) do
					if key == Reflector.GetName(ns) then
						rawset(self, key, ns)
						return rawget(self, key)
					elseif ns[key] then
						rawset(self, key, ns[key])
						return rawget(self, key)
					end
				end
			end

			-- Check base namespace
			if System.Reflector.ForName(key) then
				rawset(self, key, System.Reflector.ForName(key))
				return rawget(self, key)
			end

			local value = _Info[self].Parent and _Info[self].Parent[key]

			if type(value) == "table" or type(value) == "function" then
				rawset(self, key, value)
			end

			return value
		end

		------------------------------------------------------
		-- __newindex for class instance
		------------------------------------------------------
		function __newindex(self, key, value)
			if _Special_KeyWord[key] or _Class_KeyWords[key] then
				error(("%s is a keyword."):format(key), 2)
			end

			rawset(self, key, value)
		end
	endclass "Module"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	RegisterEvent = IFModule.RegisterEvent
	IsEventRegistered = IFModule.IsEventRegistered
	UnregisterAllEvents = IFModule.UnregisterAllEvents
	UnregisterEvent = IFModule.UnregisterEvent

	------------------------------------
	--- Add SaveVariables to the addon
	-- @name Addon:AddSavedVariable
	-- @class function
	-- @param name the savevariable's name
	-- @return the savevariable, no need to receive it, the name passed in this function will be the identify.
	-- @usage Addon:AddSavedVariable("HelloWorld_SaveV")
	------------------------------------
	function AddSavedVariable(self, name)
		if type(name) ~= "string" or strtrim(name) == "" then
			error(("Usage : Addon:AddSavedVariable(name) : 'name' - string expected, got %s."):format(type(name) == "string" and "empty string" or type(name)), 2)
		end

		name = strtrim(name)
		if not _Logined then
			_Info[self].SavedVariables = _Info[self].SavedVariables or {}
			_Info[self].SavedVariables[name] = true
		end

		_G[name] = _G[name] or {}
		self[name] = _G[name]

		return self[name]
	end

	------------------------------------
	--- Get the addon's information by the given name.
	-- @name Addon:GetMetadata
	-- @class function
	-- @param field the informations' name
	-- @return informations stored in the addon
	-- @usage Addon:GetMetadata("Author")    -- return "Kurapica"
	------------------------------------
	function GetMetadata(self, field)
		if type(field) ~= "string" or strtrim(field) == "" then
			error(("Usage : Addon:GetMetadata(field) : 'field' - string expected, got %s."):format(type(field) == "string" and "empty string" or type(field)), 2)
		end

		return self._Metadata[field]
	end

	------------------------------------
	--- Set the addon's information by the given name.
	-- @name Addon:SetMetadata
	-- @class function
	-- @param field the information's name
	-- @param value the information's value
	-- @usage Addon:SetMetadata("Author", "Kurapica")
	------------------------------------
	function SetMetadata(self, field, value)
		if type(field) ~= "string" or strtrim(field) == "" then
			error(("Usage : Addon:SetMetadata(field, value) : 'field' - string expected, got %s."):format(type(field) == "string" and "empty string" or type(field)), 2)
		end

		self._Metadata[field] = value
	end

	------------------------------------
	--- This is using to dispose a Addon, and set the enviroment to it's container if needed.
	-- @name Addon:Dispose
	-- @class function
	-- @return nil
	-- @usage Addon:Dispose()
	------------------------------------
	function Dispose(self)
		_Addon[_Info[self].Name] = nil

		if getfenv(2) == self then
			setfenv(2, _G)
		end

		return IFModule.Dispose(self)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- _Addon
	property "_Addon" {
		Get = function(self)
			return self
		end,
	}
	-- _AutoWrapper
	property "_AutoWrapper" {
		Get = function(self)
			return not _Info[self].NoAutoWrapper
		end,
		Set = function(self, auto)
			_Info[self].NoAutoWrapper = not auto
		end,
		Type = Boolean,
	}
	-- _Metadata
	property "_Metadata" {
		Get = function(self)
			_Info[self].MetaData = _Info[self].MetaData or setmetatable({}, {
				__index = function(meta, key)
					local value = GetAddOnMetadata and GetAddOnMetadata(_Info[self].Name, key)

					if value ~= nil then
						rawset(meta, key, value)
					end

					return rawget(meta, key)
				end,
				__newindex = function(meta, key, value)
					if type(key) == "string" and strtrim(key) ~= "" then
						rawset(meta, strtrim(key), value)
					end
				end,
			})

			return _Info[self].MetaData
		end,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Addon(name)
		if type(name) ~= "string" then
			error(("Usage : Addon(name) : 'name' - string expected, got %s."):format(type(name)), 2)
		end

		name = name:match("[_%w]+")

		if not name or name == "" then return end

		_Addon[name] = Object()

		local addon = _Addon[name]

		_Info[addon] = {
			Owner = addon,
			Name = name,
		}

		return addon
	end

	------------------------------------------------------
	-- Exist checking
	------------------------------------------------------
	function __exist(cls, name)
		if type(name) ~= "string" then
			return
		end

		name = name:match("[_%w]+")

		return name and _Addon[name]
	end

	------------------------------------------------------
	-- __index for class instance
	------------------------------------------------------
	function __index(self, key)
		if _Special_KeyWord[key] then
			return _Special_KeyWord[key]
		end

		if _Class_KeyWords[key] then
			return _Class_KeyWords[key]
		end

		-- Check namespace
		local ns = rawget(self, "__IGAS_NameSpace")
		if Reflector.GetName(ns) then
			if key == Reflector.GetName(ns) then
				rawset(self, key, ns)
				return rawget(self, key)
			elseif ns[key] then
				rawset(self, key, ns[key])
				return rawget(self, key)
			end
		end

		-- Check imports
		if _Info[self].Import then
			for _, ns in ipairs(_Info[self].Import) do
				if key == Reflector.GetName(ns) then
					rawset(self, key, ns)
					return rawget(self, key)
				elseif ns[key] then
					rawset(self, key, ns[key])
					return rawget(self, key)
				end
			end
		end

		-- Check base namespace
		if System.Reflector.ForName(key) then
			rawset(self, key, System.Reflector.ForName(key))
			return rawget(self, key)
		end

		if key ~= "_G" and type(key) == "string" and key:find("^_") then
			return
		end

		if _G[key] then
			if type(_G[key]) == "function" or type(_G[key]) == "table" then
				if not _Info[self].NoAutoWrapper and IGAS.GetWrapper then
					rawset(self, key, IGAS:GetWrapper(_G[key]))
				else
					rawset(self, key, _G[key])
				end
				return rawget(self, key)
			end

			return _G[key]
		end
	end

	------------------------------------------------------
	-- __newindex for class instance
	------------------------------------------------------
	function __newindex(self, key, value)
		if _Special_KeyWord[key] or _Class_KeyWords[key] then
			error(("%s is a keyword."):format(key), 2)
		end

		rawset(self, key, value)
	end
endclass "Addon"

------------------------------------------------------
-- Global Settings
------------------------------------------------------
do
	------------------------------------
	--- Create or Get an addon by name, then change the environment to the addon if not set setEnv to false
	-- @name IGAS:NewAddon
	-- @class function
	-- @param addonName	the addon's name, must be unique, also can be a serie tokens seperate by ".",the first token is addon' name, the second token will be a child-module to the addon, the third token will create the child-module to the second, and go on.
	-- @param version Optional,used for version control, if there is another version, and the old version is equal or great than this one, return nil, else return the child-module
	-- @param info Optional,Optional,must be a table, contains informations such as "author", "version" .etc
	-- @return addon that a table contains the addon's scope, no need to receive it if you don't set setEnv to false, after call this function, you can using "_Addon" to access the addon
	-- @usage local addon = IGAS:NewAddon("HelloWorld", 1, {Author="Kurapica", Version="1.0", Note="Hello World Example", Interface="30010", Title="Hello World"})
	-- @usage IGAS:NewAddon("HelloWorld")
	------------------------------------
	function IGAS:NewAddon(name, version, info)
		if type(name) ~= "string" or strtrim(name) == "" then
			error(("Usage : IGAS:NewAddon(name, [version]) : 'name' - string expected, got %s."):format(type(name) == "string" and "empty string" or type(name)), 2)
		end

		if version then
			if type(version) ~= "number" then
				error(("Usage : IGAS:NewAddon(name, [version]) : 'version' - number expected, got %s."):format(type(version)), 2)
			elseif version < 1 then
				error("Usage : IGAS:NewAddon(name, [version]) : 'version' - must be greater than 0.", 2)
			end
		end

		local module = _Addon
		local addon

		for sub in name:gmatch("[^%.]+") do
			sub = sub and strtrim(sub)
			if not sub or sub =="" then return end

			if module == _Addon then
				module = Addon(sub)
				addon = module
			else
				module = Addon.Module(module, sub)
			end

			if not module then return end
		end

		if not module or module == _Addon then return end

		if version and module._Version >= version then
			return
		elseif version then
			module._Version = version
		end

		-- MetaData
		if type(info) == "table" and next(info) then
			for field, v in pairs(info) do
				if type(field) == "string" and strtrim(field) ~= "" then
					addon._Metadata[field] = v
				end
			end
		end

		setfenv(2, module)

		return module
	end

	------------------------------------
	--- Get an addon by name
	-- @name IGAS:GetAddon
	-- @class function
	-- @param addonName	the addon's name, must be unique, also can be a serie tokens seperate by ".",the first token is addon' name, the second token will be a child-module to the addon, the third token will create the child-module to the second, and go on.
	-- @return addon that a table contains the addon's scope, no need to receive it if you don't set setEnv to false, after call this function, you can using "_Addon" to access the addon
	-- @usage local addon = IGAS:GetAddon("HelloWorld")
	-- @usage IGAS:GetAddon("HelloWorld")
	------------------------------------
	function IGAS:GetAddon(name, needCreate)
		if type(name) ~= "string" or strtrim(name) == "" then
			error(("Usage : IGAS:GetAddon(name) : 'name' - string expected, got %s."):format(type(name) == "string" and "empty string" or type(name)), 2)
		end

		local module = _Addon

		for sub in name:gmatch("[^%.]+") do
			sub = sub and strtrim(sub)
			if not sub or sub =="" then return end

			if module == _Addon then
				if needCreate then
					module = _Addon(sub)
				else
					module = _Addon[sub]
				end
			else
				module = module:GetModule(sub, needCreate)
			end

			if not module then return end
		end

		if not module or module == _Addon then return end

		return module
	end

	------------------------------------
	--- Get a list of the existed addons' name
	-- @name IGAS:GetAddonList
	-- @class function
	-- @return list a table contains all the existed addons' name
	-- @usage IGAS:GetAddonList()
	------------------------------------
	function IGAS:GetAddonList()
		local lst = {}

		for name in pairs(_Addon) do
			tinsert(lst, name)
		end

		return lst
	end
end
