-- Author      : Kurapica
-- Create Date : 6/12/2008 1:12:25 AM
-- ChangeLog
--				2010/01/30	Change IsObjectType method
--				2010/11/28	Remove fake UIObject
--				2011/03/01	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- UIObject is the base Widget class that is used to group together methods that are common to all user interface types
-- @name UIObject
-- @class table
-- @field Name Set or get the frame's name, it's an unique identify in it's parent's childs
-- @field InDesignMode Check if the frame is under design
-- @field Parent Set or Get the frame's parent
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 14
if not IGAS:NewAddon("IGAS.Widget.UIObject", version) then
	return
end

class "UIObject"
	inherit "Object"

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	-- OnScriptHandlerChanged
	_ScriptHandler = _ScriptHandler or {}

	local function GetEventHandler(handler)
		if type(handler) ~= "string" then
			error("The handler must be a string", 2)
		end
		if not _ScriptHandler[handler] then
			_ScriptHandler[handler] = function(self, ...)
				return self.__Wrapper and self.__Wrapper:Fire(handler, ...)
			end
		end
		return _ScriptHandler[handler]
	end

	local function OnScriptHandlerChanged(self, scriptName)
		local _UI = rawget(self, "__UI")

		if type(_UI) ~= "table" or _UI == self or type(_UI.HasScript) ~= "function" or not _UI:HasScript(scriptName) then
			return
		end

		if self[scriptName]:IsEmpty() then
			-- UnRegister
			if _UI:GetScript(scriptName) == GetEventHandler(scriptName) then
				_UI:SetScript(scriptName, nil)
			end
		else
			-- Register
			if not _UI:GetScript(scriptName) then
				_UI:SetScript(scriptName, GetEventHandler(scriptName))
			elseif _UI:GetScript(scriptName) ~= GetEventHandler(scriptName) then
				if type(self.__HookedScript) ~= "table" or not self.__HookedScript[scriptName] then
					_UI:HookScript(scriptName, GetEventHandler(scriptName))
					self.__HookedScript = self.__HookedScript or {}
					self.__HookedScript[scriptName] = true
				end
				--error(("%s already has a handler for '%s'.Using UIObject:SetScript(name, func) if you really want to override it."):format(self.Name or _UI:GetName(), scriptName))
			end
		end
	end

	local function OnEvent(self, event, ...)
		if type(self[event]) == "function" then
			return self[event](self, ...)
		end
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Get the type of this object.
	-- @name UIObject:GetObjectType
	-- @class function
	-- @return the object type of the frame(the type is defined in IGAS)
	-- @usage UIObject:GetObjectType()
	------------------------------------
	function GetObjectType(self)
		return Reflector.GetName(self:GetClass())
	end

	------------------------------------
	--- Determine if this object is of the specified type, or a subclass of that type.
	-- @name UIObject:IsObjectType
	-- @class function
	-- @param type the object type to determined
	-- @return true if the frame's type is the given type or the given type's sub-type.
	-- @usage UIObject:IsObjectType("Form")
	------------------------------------
	function IsObjectType(self, objType)
		if objType then
			if type(objType) == "string" then
				objType = Widget[objType]
			end

			return Reflector.IsClass(objType) and Object.IsClass(self, objType) or false
		end

		return false
	end

	------------------------------------
	--- Release resource, will dipose it's childs the same time
	-- @name UIObject:Dispose
	-- @class function
	-- @usage UIObject:Dispose()
	------------------------------------
	function Dispose(self)
		local name = self:GetName()

		self:SetParent(nil)

		-- Call their childs' dispose method
		if type(self.__Childs) == "table" then
			for _,ob in pairs(self.__Childs) do
				ob:Dispose()
			end
		end

		-- Remove from _G if it exists
		if name and _G[name] == IGAS:GetUI(self) then
			_G[name] = nil
		end

		-- Clear
		return Object.Dispose(self)
	end

	------------------------------------
	--- Get the parent of this frame (The object, not just the name)
	-- @name UIObject:GetParent
	-- @class function
	-- @return the parent of the frame, if is not a igas frame, automaticaly convert
	-- @usage UIObject:GetParent()
	------------------------------------
	function GetParent(self)
		if not self.__Parent and self.__UI["GetParent"] and self.__UI:GetParent() then
			self:SetParent(IGAS:GetWrapper(self.__UI:GetParent()))
		end
		return self.__Parent
	end

	------------------------------------
	--- Set the parent for this frame
	-- @name UIObject:SetParent
	-- @class function
	-- @param parent the parent of the frame, if is not a igas frame, automaticaly convert
	-- @usage UIObject:SetParent(UIParent)
	------------------------------------
	function SetParent(self, parent)
		-- Get frame from name
		if type(parent) == "string" then
			parent = _G[parent]

			if type(parent) ~= "table" or type(parent[0]) ~= "userdata" then
				error("Usage : UIObject:SetParent(parent) : 'parent' - UI element expected.", 2)
			end
		end

		if parent then
			parent = IGAS:GetWrapper(parent)

			-- Check parent
			if not Object.IsClass(parent, UIObject) then
				error("Usage : UIObject:SetParent(parent) : 'parent' - UI element expected.", 2)
			end
		end

		-- Set parent
		if parent then
			if self.__Name then
				-- Check
				parent.__Childs = parent.__Childs or {}

				if parent.__Childs[self.__Name] then
					if parent.__Childs[self.__Name] ~= self then
						error("Usage : UIObject:SetParent(parent) : parent has another child with same name.", 2)
					else
						return
					end
				end

				-- Remove ob from it's old parent
				if not Object.IsClass(self, UIObject) then
					-- mean now this is only Object
					SetParent(self, nil)
				else
					self:SetParent(nil)
				end

				-- Add ob to new parent
				self.__Parent = parent
				parent.__Childs[self.__Name] = self

				-- SetParent
				if IGAS:GetUI(self) ~= self and IGAS:GetUI(self)["SetParent"] then
					IGAS:GetUI(self):SetParent(IGAS:GetUI(parent))
				end
			else
				error("Usage : UIObject:SetParent(parent) : 'UIObject' - must have a name.", 2)
			end
		else
			if self.__Name and self.__Parent and self.__Parent.__Childs then
				self.__Parent.__Childs[self.__Name] = nil
			end
			self.__Parent = nil
			-- SetParent to nil
			if IGAS:GetUI(self) ~= self and IGAS:GetUI(self)["SetParent"] then
				pcall(IGAS:GetUI(self).SetParent, IGAS:GetUI(self), nil)
			end
		end
	end

	------------------------------------
	--- Add a child to the frame
	-- @name UIObject:AddChild
	-- @class function
	-- @param child the child to be added, if is not a igas frame, automaticaly convert
	-- @usage UIObject:AddChild(MiniMap)
	------------------------------------
	function AddChild(self, child)
		-- Get frame from name
		if type(child) == "string" then
			child = _G[child] or child

			if type(child) == "string" then
				error("Usage : UIObject:AddChild(child) : 'child' - UI element expected.", 2)
			end
		end

		child = IGAS:GetWrapper(child)

		if Object.IsClass(child, UIObject) then
			child:SetParent(self)
		else
			error("Usage : UIObject:AddChild(child) : 'child' - UI element expected.", 2)
		end
	end

	------------------------------------
	--- Check if the frame has childs
	-- @name UIObject:HasChild
	-- @class function
	-- @return true if the frame has childs, else false
	-- @usage UIObject:HasChild()
	------------------------------------
	function HasChilds(self)
		if type(self.__Childs) == "table" and next(self.__Childs) then
			return true
		else
			return false
		end
	end

	------------------------------------
	--- Get the child list of the frame,IMPORTAND, don't do any change to the return table unless you know much about the igas system
	-- @name UIObject:GetChilds
	-- @class function
	-- @return the childs list
	-- @usage UIObject:GetChilds()
	------------------------------------
	function GetChilds(self)
		self.__Childs = self.__Childs or {}
		return self.__Childs
	end

	------------------------------------
	--- Get the child of the given name
	-- @name UIObject:GetChild
	-- @class function
	-- @param name the child's name or itself
	-- @return the child
	-- @usage UIObject:GetChild("BtnOkay")
	------------------------------------
	function GetChild(self, name)
		if type(name) ~= "string" then
			error("Usage : UIObject:GetChild(name) : 'name' - string expected.", 2)
		end

		return rawget(self, "__Childs") and self.__Childs[name]
	end

	------------------------------------
	--- Remove the child of the given name
	-- @name UIObject:RemoveChild
	-- @class function
	-- @param name the child's name or itself
	-- @usage UIObject:RemoveChild("BtnOkay")
	------------------------------------
	function RemoveChild(self, name)
		local child = nil

		if name then
			if type(name) == "string" then
				child = self.__Childs and self.__Childs[name]
			elseif type(name) == "table" and name.Name then
				if self.__Childs and self.__Childs[name.Name] == name then
					child = name
				end
			end

			if child then
				return child:SetParent(nil)
			end
		end
	end

	local function GetFullName(self)
		if not self.Name then
			return ""
		end

		if IGAS[self.Name] == self then
			return "IGAS."..tostring(self.Name)
		end

		if self.Parent == nil then
			return tostring(self.Name)
		end

		return GetFullName(self.Parent).."."..tostring(self.Name)
	end

	------------------------------------
	--- Get the full path of this object.
	-- @name UIObject:GetName
	-- @class function
	-- @return the full path of the object
	-- @usage UIObject:GetName()
	------------------------------------
	function GetName(self)
		return self.__UI:GetName() or GetFullName(self)
	end

	------------------------------------
	--- Return the script handler of the given name
	-- @name UIObject:GetScript
	-- @class function
	-- @param name the script type's name
	-- @return the script handler of the given name if exists
	-- @usage UIObject:GetScript("OnEnter")
	------------------------------------
	function GetScript(self, name)
		if type(name) ~= "string" then
			error(("Usage : UIObject:GetScript(name) : 'name' - string expected, got %s."):format(type(name)), 2)
		end

		local _UI = rawget(self, "__UI")

		if type(_UI) == "table" and _UI ~= self and type(_UI.HasScript) == "function" and _UI:HasScript(name) then
			local handler = _UI:GetScript(name)

			if handler == _ScriptHandler[name] then
				return type(self.__Scripts) == "table" and rawget(self.__Scripts, name) and rawget(rawget(self.__Scripts, name), 0)
			else
				return handler
			end
		end

		return type(self.__Scripts) == "table" and rawget(self.__Scripts, name) and rawget(rawget(self.__Scripts, name), 0)
	end

	------------------------------------
	--- Set the script handler of the given name
	-- @name UIObject:SetScript
	-- @class function
	-- @param name the script type's name
	-- @param func the script handler
	-- @usage UIObject:SetScript("OnEnter", function() end)
	------------------------------------
	function SetScript(self, name, func)
		if type(name) ~= "string" then
			error(("Usage : UIObject:SetScript(name, func) : 'name' - string expected, got %s."):format(type(name)), 2)
		end
		if func ~= nil and type(func) ~= "function" then
			error(("Usage : UIObject:SetScript(name, func) : 'func' - function or nil expected, got %s."):format(type(func)), 2)
		end

		if not self:HasScript(name) then
			error(("%s is not a supported script."):format(name), 2)
		end

		self[name] = func
	end

	------------------------------------
	--- Securely hooks a script handler
	-- @name UIObject:HookScript
	-- @class function
	-- @param name the script type's name
	-- @param func the script handler
	-- @usage UIObject:HookScript("OnEnter", function() end)
	------------------------------------
	function HookScript(self, name, func)
		error(("Usage : UIObject.%s = UIObject.%s + func"):format(tostring(name), tostring(name)), 2)
	end

	------------------------------------
	--- Returns whether the frame is registered for a given event
	-- @name UIObject:IsEventRegistered
	-- @class function
	-- @param event Name of an event (string)
	-- @return registered - 1 if the frame is registered for the event; otherwise nil (1nil)
	------------------------------------
	function IsEventRegistered(self, event)
		if self.InDesignMode then
			self.__RegisterEventList = self.__RegisterEventList or {}
			return self.__RegisterEventList[event] or false
		end
		if type(event) == "string" and event ~= "" then
			return (IGAS:GetUI(self).IsEventRegistered and IGAS:GetUI(self):IsEventRegistered(event)) or Object.IsEventRegistered(self, event)
		else
			error(("Usage : UIObject:IsRegistered(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
		end
	end

	------------------------------------
	--- Registers the frame for an event. The frame's OnEvent script handler will be run whenever the event fires. See the event documentation for details on event arguments.
	-- @name UIObject:RegisterEvent
	-- @class function
	-- @param event Name of an event (string)
	------------------------------------
	function RegisterEvent(self, event)
		if type(event) == "string" and event ~= "" then
			if self.InDesignMode then
				self.__RegisterEventList = self.__RegisterEventList or {}
				self.__RegisterEventList[event] = true
				return
			end

			if IGAS:GetUI(self).RegisterEvent then
				IGAS:GetUI(self):RegisterEvent(event)
			end

			if not IGAS:GetUI(self).RegisterEvent or not IGAS:GetUI(self):IsEventRegistered(event) then
				Object.RegisterEvent(self, event)
			end

			self.OnEvent = self.OnEvent + OnEvent
		else
			error(("Usage : UIObject:RegisterEvent(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
		end
	end

	------------------------------------
	--- Unregisters the frame from any events for which it is registered
	-- @name UIObject:UnregisterAllEvents
	-- @class function
	------------------------------------
	function UnregisterAllEvents(self)
		if self.InDesignMode then
			self.__RegisterEventList = self.__RegisterEventList or {}
			wipe(self.__RegisterEventList)
			return
		end
		IGAS:GetUI(self):UnregisterAllEvents()
		Object.UnregisterAllEvents(self)
	end

	------------------------------------
	--- Unregisters the frame for an event. Once unregistered, the frame's OnEvent script handler will not be called for that event. </p>
	--- <p>Unregistering from notifications for an event can be useful for improving addon performance at times when it's not necessary to process the event. For example, a frame which monitors target health does not need to receive the UNIT_HEALTH event while the player has no target. An addon that sorts the contents of the player's bags can register for the BAG_UPDATE event to keep track of when items are picked up, but unregister from the event while it performs its sorting.
	-- @name UIObject:UnregisterEvent
	-- @class function
	-- @param event Name of an event (string)
	------------------------------------
	function UnregisterEvent(self, event)
		if type(event) == "string" and event ~= "" then
			if self.InDesignMode then
				self.__RegisterEventList = self.__RegisterEventList or {}
				self.__RegisterEventList[event] = nil
				return
			end

			if IGAS:GetUI(self).UnregisterEvent then
				IGAS:GetUI(self):UnregisterEvent(event)
			end
			Object.UnregisterEvent(self, event)
		else
			error(("Usage : UIObject:Unregister(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	--- Name
	local function SetName(self, name)
		if self.__Parent then
			if name == self.__Name then
				return
			end

			if self.__Parent.__Childs and type(self.__Parent.__Childs) == "table" then
				if self.__Parent.__Childs[name] then
					error("the name is used by another child.", 2)
				end

				if self.__Name then
					self.__Parent.__Childs[self.__Name] = nil
				end
			end

			if not (self.__Parent.__Childs and type(self.__Parent.__Childs) == "table") then
				self.__Parent.__Childs = {}
			end
			self.__Parent.__Childs[name] = self
		end

		self.__Name = name
	end

	property "Name" {
		Set = function(self, name)
			return SetName(self, name)
		end,

		Get = function(self)
			return self.__Name or ""
		end,

		Type = String + nil,
	}

	-- InDesignMode
	property "InDesignMode" {
		Get = function(self)
			return (self.__InDesignMode and true) or false
		end,
	}

	--- Parent
	property "Parent" {
		Set = function(self, parent)
			self:SetParent(parent)
		end,
		Get = function(self)
			return self:GetParent()
		end,
		Type = UIObject + nil,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	-- __exist will do the Constructor work

	------------------------------------------------------
	-- Exist checking
	------------------------------------------------------
    --- Name Creator
	local function NewName(cls, parent)
		local i = 1
		local name = Reflector.GetName(cls)

		if not name or name == "" then
			name = "Widget"
		end

		while true do
			if parent:GetChild(name..i) then
				i = i + 1
			else
				break
			end
		end

		return name..i
	end

	function __exist(cls, name, parent, frame, ...)
		if type(name) == "table" and type(name[0]) == "userdata" then
			-- Do Wrapper the blz's UI element
			-- VirtualUIObject's instance will not be checked here.
			if Object.IsClass(name, UIObject) or not name.GetObjectType then
				-- UIObject's instance will be return here.
				return name
			end

			if name.__Wrapper and Object.IsClass(name.__Wrapper, UIObject) then
				return name.__Wrapper
			end

			local obj = Object()

			obj[0] = name[0]
			obj.__UI = name
			name.__Wrapper = obj

			obj.OnScriptHandlerChanged = obj.OnScriptHandlerChanged + OnScriptHandlerChanged

			SetName(obj, name:GetName() or "Name"..random(100000))

			return obj
		end

		parent = parent or IGAS.UIParent

		parent = IGAS:GetWrapper(parent)

		-- Check parent
		if not Object.IsClass(parent, UIObject) then
			error(("Usage : %s(name, parent, ...) : 'parent' - UI element expected."):format(Reflector.GetName(cls)))
		end

		if type(name) == "string" then
			if cls == UIObject then
				-- instead the Constructor
				if type(frame) == "table" and type(frame[0]) == "userdata" then
					if frame.__Wrapper and Object.IsClass(frame.__Wrapper, UIObject) then
						frame = frame.__Wrapper
					elseif not Object.IsClass(frame, UIObject) then
						local _UI = frame

						frame = Object()

						frame[0] = _UI[0]
						frame.__UI = _UI
						_UI.__Wrapper = frame

						frame.OnScriptHandlerChanged = frame.OnScriptHandlerChanged + OnScriptHandlerChanged
					end

					SetName(frame, name)
					SetParent(frame, parent)

					return frame
				else
					error("Usage : UIObject(name, parent, frame) : 'frame' - UI element expected.")
				end
			else
				-- checking if existed
				local child = parent:GetChild(name)

				if child then
					if Object.IsClass(child, cls) then
						return child
					else
						error(("%s already have a child named '%s' as type '%s'."):format(parent.Name, name, Reflector.GetName(Object.GetClass(child)) or ""))
					end
				end
			end
		elseif name == nil then
			name = NewName(cls, parent)
		else
			error(("Usage : %s(name, parent, ...) : 'name' - string expected."):format(Reflector.GetName(cls)))
		end

		if frame ~= nil then
			return false, name, parent, frame, ...
		else
			-- won't cause a nil arg confuse
			return false, name, parent
		end
	end

	------------------------------------------------------
	-- __index
	------------------------------------------------------
	function __index(self, key)
		if key == "__Childs" then
			rawset(self, key, {})
			return rawget(self, key, {})
		end
		if rawget(self, "__Childs") and type(rawget(self, "__Childs")) == "table" then
			return rawget(self.__Childs,  key)
		end
	end
endclass "UIObject"