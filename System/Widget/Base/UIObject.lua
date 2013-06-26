-- Author      : Kurapica
-- Create Date : 6/12/2008 1:12:25 AM
-- ChangeLog
--				2010/01/30	Change IsObjectType method
--				2010/11/28	Remove fake UIObject
--				2011/03/01	Recode as class

-- Check Version
local version = 15
if not IGAS:NewAddon("IGAS.Widget.UIObject", version) then
	return
end

class "UIObject"
	inherit "Object"

	doc [======[
		@name UIObject
		@type class
		@desc UIObject is the base ui elemenet type
		@param name string, the name of the object
		@param parent widgetObject, default UIParent
		@param ... the init parameters
	]======]

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	-- OnEventHandlerChanged
	_ScriptHandler = _ScriptHandler or {}

	local function GetEventHandler(handler)
		if type(handler) ~= "string" then
			error("The handler must be a string", 2)
		end
		if not _ScriptHandler[handler] then
			_ScriptHandler[handler] = function(self, ...)
				return self.__Wrapper and self.__Wrapper:Raise(handler, ...)
			end
		end
		return _ScriptHandler[handler]
	end

	local function OnEventHandlerChanged(self, scriptName)
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

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetObjectType
		@type method
		@desc Get the class name of the object
		@return string the object's class name
	]======]
	function GetObjectType(self)
		return Reflector.GetName(self:GetClass())
	end

	doc [======[
		@name IsObjectType
		@type method
		@desc Check if the object is an instance of the class.
		@param objType string the widget class's name
		@return boolean true if the object is an instance of the class
	]======]
	function IsObjectType(self, objType)
		if objType then
			if type(objType) == "string" then
				objType = Widget[objType]
			end

			return Reflector.IsClass(objType) and Object.IsClass(self, objType) or false
		end

		return false
	end

	doc [======[
		@name GetParent
		@type method
		@desc Get the parent object of this widget object
		@return widgetObject the parent of the object
	]======]
	function GetParent(self)
		if not self.__Parent and self.__UI["GetParent"] and self.__UI:GetParent() then
			self:SetParent(IGAS:GetWrapper(self.__UI:GetParent()))
		end
		return self.__Parent
	end

	doc [======[
		@name SetParent
		@type method
		@desc Set the parent widget object to this widget object
		@param parent the parent widget object or nil
		@return nil
	]======]
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

	doc [======[
		@name AddChild
		@type method
		@desc Add a widget object as child
		@param child the child widget object
		@return nil
	]======]
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

	doc [======[
		@name HasChilds
		@type method
		@desc Check if the widget object has child objects
		@return boolean true if the object has child
	]======]
	function HasChilds(self)
		if type(self.__Childs) == "table" and next(self.__Childs) then
			return true
		else
			return false
		end
	end

	doc [======[
		@name GetChilds
		@type method
		@desc Get the child list of the widget object, !!!IMPORTANT!!!, don't do any change to the return table, this table is the real table that contains the child objects.
		@return table the child objects list
	]======]
	function GetChilds(self)
		self.__Childs = self.__Childs or {}
		return self.__Childs
	end

	doc [======[
		@name GetChild
		@type method
		@desc Get the child object for the given name
		@param name string, the child's name
		@return widgetObject the child widget object if existed
	]======]
	function GetChild(self, name)
		if type(name) ~= "string" then
			error("Usage : UIObject:GetChild(name) : 'name' - string expected.", 2)
		end

		return rawget(self, "__Childs") and self.__Childs[name]
	end

	doc [======[
		@name RemoveChild
		@type method
		@desc Remove the child for the given name
		@param name string, the child's name
		@return nil
	]======]
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

	doc [======[
		@name GetName
		@type method
		@desc Not like property 'Name', this method return full name, it will concat the object's name with it's parent like 'UIParent.MyForm.MyObj'
		@return string the full name of the object
	]======]
	function GetName(self)
		return self.__UI:GetName() or GetFullName(self)
	end

	doc [======[
		@name GetScript
		@type method
		@desc Return the script handler of the given name (discarded)
		@param name string, the script's name
		@return function the script handler if existed
	]======]
	function GetScript(self, name)
		error(("Usage : func = object.%s"):format(tostring(name)), 2)
	end

	doc [======[
		@name SetScript
		@type method
		@desc Set the script hanlder of the given name (discarded)
		@param name string, the script's name
		@param handler function, the script handler
		@return nil
	]======]
	function SetScript(self, name, func)
		error(("Usage : object.%s = func"):format(tostring(name)), 2)
	end

	function HookScript(self, name, func)
		error(("Usage : object.%s = object.%s + func"):format(tostring(name), tostring(name)), 2)
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

	doc [======[
		@name Name
		@type property
		@desc The widget object's name, it's parent can use the name to access it by parent[self.Name]
	]======]
	property "Name" {
		Set = function(self, name)
			return SetName(self, name)
		end,

		Get = function(self)
			return self.__Name or ""
		end,

		Type = String + nil,
	}

	doc [======[
		@name InDesignMode
		@type property
		@desc Using to block some action when in design mode
	]======]
	property "InDesignMode" {
		Get = function(self)
			return (self.__InDesignMode and true) or false
		end,
	}

	doc [======[
		@name Parent
		@type property
		@desc the widget object's parent widget object, can be virtual or not.
	]======]
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
	-- Dispose
	------------------------------------------------------
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
	end

	------------------------------------------------------
	-- Constructor
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

	function Constructor(self, name, parent, ...)

	end

	function UIObject(self, name, parent, ...)
		if type(name) == "table" and type(name[0]) == "userdata" then
			-- Wrapper blz's element
			self[0] = name[0]
			self.__UI = name
			name.__Wrapper = self

			self.OnEventHandlerChanged = self.OnEventHandlerChanged + OnEventHandlerChanged

			SetName(self, name:GetName() or "Name"..random(100000))

			return
		end

		parent = parent or IGAS.UIParent

		parent = IGAS:GetWrapper(parent)

		-- Check parent
		if not Object.IsClass(parent, UIObject) then
			error(("Usage : %s(name, parent, ...) : 'parent' - UI element expected."):format(Reflector.GetName(cls)))
		end

		if type(name) ~= "string" then
			name = NewName(Object.GetClass(self), parent)
		end

		local obj = self:Constructor(name, parent, ...) or self
		self[0] = obj[0]
		self.__UI = obj
		obj.__Wrapper = self

		self.OnEventHandlerChanged = self.OnEventHandlerChanged + OnEventHandlerChanged

		SetName(self, name)
		SetParent(self, parent)
	end

	------------------------------------------------------
	-- Exist checking
	------------------------------------------------------
	function __exist(name, parent, ...)
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

			return
		end

		parent = parent or IGAS.UIParent

		parent = IGAS:GetWrapper(parent)

		-- Check parent
		if not Object.IsClass(parent, UIObject) then
			error(("Usage : %s(name, parent, ...) : 'parent' - UI element expected."):format(Reflector.GetName(cls)))
		end

		if type(name) == "string" then
			return parent:GetChild(name)
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