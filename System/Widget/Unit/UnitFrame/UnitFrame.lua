-- Author      : Kurapica
-- Create Date : 2012/06/24
-- Change Log  :
--               2013/05/25 Reduce memory cost
--               2013/07/04 UnitFrame can handle the change of attribute "unit"
--               2013/07/05 Use attribute "deactivated" instead of "__Deactivated"
--               2013/08/03 Add same unit check, reduce cost

-- Check Version
local version = 9
if not IGAS:NewAddon("IGAS.Widget.Unit.UnitFrame", version) then
	return
end

class "UnitFrame"
	inherit "Button"
	extend "IFContainer" "IFSecureHandler"

	doc [======[
		@name UnitFrame
		@type class
		@desc UnitFrame is used to display information about an unit, and can be used to do the common actions on the unit
	]======]

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnUpdate(self, elapsed)
		self.__OnUpdateTimer = (self.__OnUpdateTimer or 0) + elapsed

		if self.__OnUpdateTimer > self.__Interval then
			self.__OnUpdateTimer = 0
			return self:UpdateElements()
		end
	end

	local function UNIT_NAME_UPDATE(self, unit)
		if self.Unit and UnitIsUnit(self.Unit, unit) then
			return self:UpdateElements()
		end
	end

	local function UNIT_PET(self, unit)
		if unit and self.Unit and UnitIsUnit(self.Unit, unit .. "pet") then
			return self:UpdateElements()
		end
	end

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name AddElement
		@type method
		@desc Add a unit element into the unit frame
		@format elementType[, direction[, size, sizeunit]]
		@param elementType class, the unit element's class
		@param direction System.Widget.DockLayoutPanel.Direction
		@param size number, the height size if the direction is 'NORTH' or 'SOUTH', the width size if the direction is 'WEST' or 'EAST'
		@param sizeunit System.Widget.LayoutPanel.Unit
		@return nil
	]======]
	function AddElement(self, ...)
		IFContainer.AddWidget(self, ...)

		self:Each("Unit", self.Unit)
	end

	doc [======[
		@name InsertElement
		@type method
		@desc Insert a unit element into the unit frame
		@format before, elementType[, direction[, size, sizeunit]]
		@param before System.Widget.Region|System.Widget.VirtualUIObject, the element to be inserted before
		@param elementType class, the unit element's class
		@param direction System.Widget.DockLayoutPanel.Direction
		@param size number, the height size if the direction is 'NORTH' or 'SOUTH', the width size if the direction is 'WEST' or 'EAST'
		@param sizeunit System.Widget.LayoutPanel.Unit
		@return nil
	]======]
	function InsertElement(self, ...)
		IFContainer.InsertWidget(self, ...)

		self:Each("Unit", self.Unit)
	end

	doc [======[
		@name GetElement
		@type method
		@desc Gets the unit element
		@format name|elementType
		@param name string, the unit element's name or its class's name
		@param elementType class, the unit elements's class type
		@return System.Widget.Region|System.Widget.VirtualUIObject the unit element
	]======]
	function GetElement(self, ...)
		return IFContainer.GetWidget(self, ...)
	end

	doc [======[
		@name RemoveElement
		@type method
		@desc Remove the unit element
		@format name|elementType[, withoutDispose]
		@param name string, the unit element's name or its class's name
		@param elementType class, the unit elements's class type
		@param withoutDispose boolean, true if don't dispose the unit element
		@return System.Widget.Region|System.Widget.VirtualUIObject nil if the withoutDispose is false, or the unit element is the System.Widget.Region|System.Widget.VirtualUIObject is true
	]======]
	function RemoveElement(self, ...)
		return IFContainer.RemoveWidget(self, ...)
	end

	doc [======[
		@name SetUnit
		@type method
		@desc Sets the Unit for the unit frame
		@param unit string|nil, the unitid
		@return nil
	]======]
	function SetUnit(self, unit)
		if type(unit) == "string" then
			unit = strlower(unit)
		else
			unit = nil
		end

		if unit ~= self:GetAttribute("unit") then
			self:SetAttribute("unit", unit)
		else
			self:Each("Unit", unit)
		end
	end

	doc [======[
		@name GetUnit
		@type method
		@desc Gets the unit frame's Unit
		@return string
	]======]
	function GetUnit(self, unit)
		return self:GetAttribute("unit")
	end

	doc [======[
		@name UpdateElements
		@type method
		@desc Update all unit elements of the unit frame
		@return nil
	]======]
	function UpdateElements(self)
		self:Each("Refresh")
	end

	doc [======[
		@name Activate
		@type method
		@desc Activate the unit frame
		@return nil
	]======]
	function Activate(self)
		if self:GetAttribute("deactivated") then
			local unitId = type(self:GetAttribute("deactivated")) == "string" and self:GetAttribute("deactivated") or nil

			self:SetAttribute("deactivated", nil)

			self:SetUnit(unitId)
		end
	end

	doc [======[
		@name Deactivate
		@type method
		@desc Deactivate the unit frame
		@return nil
	]======]
	function Deactivate(self)
		if not self:GetAttribute("deactivated") then
			self:SetAttribute("deactivated", self:GetUnit() or true)

			SetUnit(self, nil)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Unit
		@type property
		@desc The unit's ID
	]======]
	property "Unit" {
		Get = "GetUnit",
		Set = "SetUnit",
		Type = String + nil,
	}

	doc [======[
		@name Interval
		@type property
		@desc The refresh interval for special unit like 'targettarget'
	]======]
	property "Interval" {
		Get = function(self)
			return self.__Interval or 0.5
		end,
		Set = function(self, int)
			if int > 0.1 then
				self.__Interval = int
			else
				self.__Interval = 0.5
			end
		end,
		Type = Number,
	}

	doc [======[
		@name Activated
		@type property
		@desc Whether the unit frame is activated
	]======]
	property "Activated" {
		Get = function(self)
			return not self:GetAttribute("deactivated")
		end,
		Set = function(self, value)
			if value then
				self:Activate()
			else
				self:Deactivate()
			end
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	_GameTooltip = _G.GameTooltip

	local function UpdateTooltip(self)
		GameTooltip_SetDefaultAnchor(_GameTooltip, self)
		if ( _GameTooltip:SetUnit(self.Unit) ) then
			self.UpdateTooltip = UpdateTooltip
		else
			self.UpdateTooltip = nil
		end
		local r, g, b = GameTooltip_UnitColor(self.Unit)
		_G.GameTooltipTextLeft1:SetTextColor(r, g, b)
	end

	local function OnEnter(self)
		if self.Unit then
			IGAS:GetUI(self).Unit = self.Unit
			UpdateTooltip(IGAS:GetUI(self))
		end
	end

	local function OnLeave(self)
		_GameTooltip:FadeOut()
	end

	local function OnShow(self)
		self:UpdateElements()
	end

	local function UpdateUnitFrame(self, unit)
		self = IGAS:GetWrapper(self)

		self:Each("Unit", unit)

		if unit == "target" then
			self:RegisterEvent("PLAYER_TARGET_CHANGED")
			self.PLAYER_TARGET_CHANGED = UpdateElements
		else
			self:UnregisterEvent("PLAYER_TARGET_CHANGED")
			self.PLAYER_TARGET_CHANGED = nil
		end

		if unit == "mouseover" then
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
			self.UPDATE_MOUSEOVER_UNIT = UpdateElements
		else
			self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
			self.UPDATE_MOUSEOVER_UNIT = nil
		end

		if unit == "focus" then
			self:RegisterEvent("PLAYER_FOCUS_CHANGED")
			self.PLAYER_FOCUS_CHANGED = UpdateElements
		else
			self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
			self.PLAYER_FOCUS_CHANGED = nil
		end

		if unit and (unit:match("^party%d") or unit:match("^raid%d")) then
			self:RegisterEvent("UNIT_NAME_UPDATE")
			self.UNIT_NAME_UPDATE = UNIT_NAME_UPDATE
		else
			self:UnregisterEvent("UNIT_NAME_UPDATE")
			self.UNIT_NAME_UPDATE = nil
		end

		if unit and unit:match("pet") then
			self:RegisterEvent("UNIT_PET")
			self.UNIT_PET = UNIT_PET
		else
			self:UnregisterEvent("UNIT_PET")
			self.UNIT_PET = nil
		end

		--if unit and (unit:match("%w+target") or unit:match("(boss)%d?$")) then
		if unit and (unit:match("%w+target")) then
			self.OnUpdate = OnUpdate
		else
			self.OnUpdate = nil
		end
	end

	_onattributechanged = [[
		if name == "unit" then
			if self:GetAttribute("deactivated") and value then
				return self:SetAttribute("unit", nil)
			end

			if type(value) == "string" then
				value = strlower(value)
			else
				value = nil
			end

			if value == "player" then
				UnregisterUnitWatch(self)
				self:Show()
			elseif value then
				RegisterUnitWatch(self)
			else
				UnregisterUnitWatch(self)
				self:Hide()
			end

			self:CallMethod("UnitFrame_UpdateUnitFrame", value)
		end
	]]

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent)
		return CreateFrame("Button", name, parent, "SecureUnitButtonTemplate, SecureHandlerAttributeTemplate")
	end

    function UnitFrame(self, name, parent)
		self.Layout = DockLayoutPanel
		self.AutoLayout = true

		self:SetAttribute("*type1", "target")
		self:SetAttribute("shift-type1", "focus")	-- default
		self:SetAttribute("*type2", "togglemenu")

		self:RegisterForClicks("AnyUp")

		self.OnEnter = self.OnEnter + OnEnter
		self.OnLeave = self.OnLeave + OnLeave
		self.OnShow = self.OnShow + OnShow

		-- Prepare for secure handler
		self:SetAttribute("_onattributechanged", _onattributechanged)
		IGAS:GetUI(self).UnitFrame_UpdateUnitFrame = UpdateUnitFrame

		self.__Interval = 0.5
    end

	------------------------------------------------------
	-- __index
	------------------------------------------------------
    function __index(self, key)
    	local value = UIObject.__index(self, key)
    	if value then
    		return value
    	end
    	return self:GetElement(key)
    end
endclass "UnitFrame"
