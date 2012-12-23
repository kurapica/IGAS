-- Author      : Kurapica
-- ChangeLog
--				2011/03/07	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- VirtualUIObject is an abstract UI object type that is used to group together methods that are common to all Virtual interface types
-- @name VirtualUIObject
-- @class table
-- @field Name Set or get the frame's name, it's an unique identify in it's parent's childs
-- @field InDesignMode Check if the frame is under design
-- @field Parent Set or Get the frame's parent
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 11

if not IGAS:NewAddon("IGAS.Widget.VirtualUIObject", version) then
	return
end

class "VirtualUIObject"
	inherit "Object"

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
	-- @name VirtualUIObject:Dispose
	-- @class function
	-- @usage VirtualUIObject:Dispose()
	------------------------------------
	function Dispose(self)
		local name = self:GetName()

		self:SetParent(nil)

		-- Remove from _G if it exists
		if name and _G[name] == IGAS:GetUI(self) then
			_G[name] = nil
		end

		-- Clear
		return Object.Dispose(self)
	end

	------------------------------------
	--- Get the parent of this frame (The object, not just the name)
	-- @name VirtualUIObject:GetParent
	-- @class function
	-- @return the parent of the frame, if is not a igas frame, automaticaly convert
	-- @usage VirtualUIObject:GetParent()
	------------------------------------
	function GetParent(self)
		return self.__Parent
	end

	------------------------------------
	--- Set the parent for this frame
	-- @name VirtualUIObject:SetParent
	-- @class function
	-- @param parent the parent of the frame, if is not a igas frame, automaticaly convert
	-- @usage VirtualUIObject:SetParent(UIParent)
	------------------------------------
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

	------------------------------------
	--- Add a child to the frame
	-- @name VirtualUIObject:AddChild
	-- @class function
	-- @param child the child to be added, if is not a igas frame, automaticaly convert
	-- @usage VirtualUIObject:AddChild(MiniMap)
	------------------------------------
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

	------------------------------------
	--- Check if the frame has childs
	-- @name VirtualUIObject:HasChild
	-- @class function
	-- @return true if the frame has childs, else false
	-- @usage VirtualUIObject:HasChild()
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
	-- @name VirtualUIObject:GetChilds
	-- @class function
	-- @return the childs list
	-- @usage VirtualUIObject:GetChilds()
	------------------------------------
	function GetChilds(self)
		self.__Childs = self.__Childs or {}
		return self.__Childs
	end

	------------------------------------
	--- Get the child of the given name
	-- @name VirtualUIObject:GetChild
	-- @class function
	-- @param name the child's name or itself
	-- @return the child
	-- @usage VirtualUIObject:GetChild("BtnOkay")
	------------------------------------
	function GetChild(self, name)
		if type(name) ~= "string" then
			error("Usage : VirtualUIObject:GetChild(name) : 'name' - string expected.", 2)
		end

		return rawget(self, "__Childs") and self.__Childs[name]
	end

	------------------------------------
	--- Remove the child of the given name
	-- @name VirtualUIObject:RemoveChild
	-- @class function
	-- @param name the child's name or itself
	-- @usage VirtualUIObject:RemoveChild("BtnOkay")
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
	-- @name VirtualUIObject:GetName
	-- @class function
	-- @return the full path of the object
	-- @usage VirtualUIObject:GetName()
	------------------------------------
	function GetName(self)
		return GetFullName(self)
	end

	------------------------------------
	--- Return the script handler of the given name
	-- @name VirtualUIObject:GetScript
	-- @class function
	-- @param name the script type's name
	-- @return the script handler of the given name if exists
	-- @usage VirtualUIObject:GetScript("OnEnter")
	------------------------------------
	function GetScript(self, name)
		if type(name) ~= "string" then
			error(("Usage : VirtualUIObject:GetScript(name) : 'name' - string expected, got %s."):format(type(name)), 2)
		end

		return type(self.__Scripts) == "table" and rawget(self.__Scripts, name) and rawget(rawget(self.__Scripts, name), 0)
	end

	------------------------------------
	--- Set the script handler of the given name
	-- @name VirtualUIObject:SetScript
	-- @class function
	-- @param name the script type's name
	-- @param func the script handler
	-- @usage VirtualUIObject:SetScript("OnEnter", function() end)
	------------------------------------
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
			return Object.IsEventRegistered(self, event)
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

			Object.RegisterEvent(self, event)

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