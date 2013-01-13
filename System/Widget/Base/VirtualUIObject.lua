-- Author      : Kurapica
-- ChangeLog
--				2011/03/07	Recode as class

-- Check Version
local version = 11

if not IGAS:NewAddon("IGAS.Widget.VirtualUIObject", version) then
	return
end

class "VirtualUIObject"
	inherit "Object"

	doc [======[
		@name VirtualUIObject
		@type class
		@desc VirtualUIObject is an abstract UI object type.
		@param name string, the name of the object
		@param parent widgetObject, default UIParent
		@param ... the other init parameters
	]======]

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
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

			if type(parent) ~= "table" then
				error("Usage : VirtualUIObject:SetParent(parent) : 'parent' - UI element expected.", 2)
			end
		end

		if parent then
			parent = IGAS:GetWrapper(parent)

			-- Check parent
			if not (Object.IsClass(parent, UIObject) or Object.IsClass(parent, VirtualUIObject)) then
				error("Usage : VirtualUIObject:SetParent(parent) : 'parent' - UI element expected.", 2)
			end
		end

		-- Set parent
		if parent then
			if self.__Name then
				-- Check
				parent.__Childs = parent.__Childs or {}

				if parent.__Childs[self.__Name] then
					if parent.__Childs[self.__Name] ~= self then
						error("Usage : VirtualUIObject:SetParent(parent) : parent has another child with same name.", 2)
					else
						return
					end
				end

				-- Remove ob from it's old parent
				if not Object.IsClass(self, VirtualUIObject) then
					-- mean now this is only Object
					SetParent(self, nil)
				else
					self:SetParent(nil)
				end

				-- Add ob to new parent
				self.__Parent = parent
				parent.__Childs[self.__Name] = self
			else
				error("Usage : VirtualUIObject:SetParent(parent) : 'VirtualUIObject' - must have a name.", 2)
			end
		else
			if self.__Name and self.__Parent and self.__Parent.__Childs then
				self.__Parent.__Childs[self.__Name] = nil
			end
			self.__Parent = nil
		end
	end

	doc [======[
		@name AddChild
		@type method
		@desc Add a virtual widget object as child
		@param child the child virtual widget object
		@return nil
	]======]
	function AddChild(self, child)
		-- Get frame from name
		if type(child) == "string" then
			child = _G[child] or child

			if type(child) == "string" then
				error("Usage : VirtualUIObject:AddChild(child) : 'child' - UI element expected.", 2)
			end
		end

		child = IGAS:GetWrapper(child)

		if Object.IsClass(child, VirtualUIObject) then
			child:SetParent(self)
		else
			error("Usage : VirtualUIObject:AddChild(child) : 'child' - Virtual UI element expected.", 2)
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
			error("Usage : VirtualUIObject:GetChild(name) : 'name' - string expected.", 2)
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
		return GetFullName(self)
	end

	doc [======[
		@name GetScript
		@type method
		@desc Return the script handler of the given name
		@param name string, the script's name
		@return function the script handler if existed
	]======]
	function GetScript(self, name)
		if type(name) ~= "string" then
			error(("Usage : VirtualUIObject:GetScript(name) : 'name' - string expected, got %s."):format(type(name)), 2)
		end

		return type(self.__Scripts) == "table" and rawget(self.__Scripts, name) and rawget(rawget(self.__Scripts, name), 0)
	end

	doc [======[
		@name SetScript
		@type method
		@desc Set the script hanlder of the given name
		@param name string, the script's name
		@param handler function, the script handler
		@return nil
	]======]
	function SetScript(self, name, func)
		if type(name) ~= "string" then
			error(("Usage : VirtualUIObject:SetScript(name, func) : 'name' - string expected, got %s."):format(type(name)), 2)
		end
		if func ~= nil and type(func) ~= "function" then
			error(("Usage : VirtualUIObject:SetScript(name, func) : 'func' - function or nil expected, got %s."):format(type(func)), 2)
		end

		if not self:HasScript(name) then
			error(("%s is not a supported script."):format(name), 2)
		end

		self[name] = func
	end

	doc [======[
		@name IsEventRegistered
		@type method
		@desc Check if the widget object has registered the given name event
		@param name string, the event's name
		@return boolean true if the event is registered
	]======]
	function IsEventRegistered(self, event)
		if self.InDesignMode then
			self.__RegisterEventList = self.__RegisterEventList or {}
			return self.__RegisterEventList[event] or false
		end
		if type(event) == "string" and event ~= "" then
			return Object.IsEventRegistered(self, event)
		else
			error(("Usage : UIObject:IsRegistered(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
		end
	end

	doc [======[
		@name RegisterEvent
		@type method
		@desc Register event for the object
		@param event string, the event's name
		@return nil
	]======]
	function RegisterEvent(self, event)
		if type(event) == "string" and event ~= "" then
			if self.InDesignMode then
				self.__RegisterEventList = self.__RegisterEventList or {}
				self.__RegisterEventList[event] = true
				return
			end

			Object.RegisterEvent(self, event)

			self.OnEvent = self.OnEvent + OnEvent
		else
			error(("Usage : UIObject:RegisterEvent(event) : 'event' - string expected, got %s."):format(type(event) == "string" and "empty string" or type(event)), 2)
		end
	end

	doc [======[
		@name UnregisterAllEvents
		@type method
		@desc Un-register all events
		@return nil
	]======]
	function UnregisterAllEvents(self)
		if self.InDesignMode then
			self.__RegisterEventList = self.__RegisterEventList or {}
			wipe(self.__RegisterEventList)
			return
		end
		Object.UnregisterAllEvents(self)
	end

	doc [======[
		@name UnregisterEvent
		@type method
		@desc Un-register given name event
		@param event string, the event's name
		@return nil
	]======]
	function UnregisterEvent(self, event)
		if type(event) == "string" and event ~= "" then
			if self.InDesignMode then
				self.__RegisterEventList = self.__RegisterEventList or {}
				self.__RegisterEventList[event] = nil
				return
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
					error("the name is used by another child.",2)
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
		@desc The virtual widget object's name, it's parent can use the name to access it by parent[self.Name]
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
		@desc the virtual widget object's parent widget object, can be virtual or not.
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

	function VirtualUIObject(self, name, parent)
		parent = parent or IGAS.UIParent

		parent = IGAS:GetWrapper(parent)

		-- Check parent
		if not (Object.IsClass(parent, UIObject) or Object.IsClass(parent, VirtualUIObject)) then
			error(("Usage : %s(name, parent, ...) : 'parent' - UI element expected."):format(Reflector.GetName(cls)))
		end

		if type(name) ~= "string" then
			name = NewName(Object.GetClass(self), parent)
		end

		SetName(self, name)
		SetParent(self, parent)
	end

	------------------------------------------------------
	-- Exist checking
	------------------------------------------------------
	function __exist(name, parent, ...)
		parent = parent or IGAS.UIParent

		parent = IGAS:GetWrapper(parent)

		-- Check parent
		if not (Object.IsClass(parent, UIObject) or Object.IsClass(parent, VirtualUIObject)) then
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
endclass "VirtualUIObject"