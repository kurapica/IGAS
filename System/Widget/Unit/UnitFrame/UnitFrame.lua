-- Author      : Kurapica
-- Create Date : 2012/06/24
-- Change Log  :

-- Check Version
local version = 3
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

	local function UpdateUnit(self, unit)
		self:Each("Unit", unit)
	end

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUpdate(self, elapsed)
		self.__OnUpdateTimer = (self.__OnUpdateTimer or 0) + elapsed

		if self.__OnUpdateTimer > self.Interval then
			self.__OnUpdateTimer = 0
			return self:UpdateElements()
		end
	end

	local function UNIT_NAME_UPDATE(self, unit)
		if self.Unit and UnitIsUnit(self.Unit, unit) then
			return self:UpdateElements()
		end
	end

	------------------------------------------------------
	-- Script
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

		UpdateUnit(self, self.Unit)
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

		UpdateUnit(self, self.Unit)
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
		if type(unit) == "string" and not self.__Deactivated then
			unit = unit:lower()
		else
			unit = nil
		end

		local guid = unit and UnitGUID(unit) or nil

		if unit ~= self:GetAttribute("unit") or guid ~= self.__UnitGuid then
			self:SetAttribute("unit", unit)
			self.__UnitGuid = guid

			UpdateUnit(self, unit)

			if unit == "player" then
				self:UnregisterUnitWatch()
				self.Visible = true
			elseif unit then
				self:RegisterUnitWatch()
			else
				self:UnregisterUnitWatch()
				self.Visible = false
			end

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

			--if unit and (unit:match("%w+target") or unit:match("(boss)%d?$")) then
			if unit and (unit:match("%w+target")) then
				self.OnUpdate = OnUpdate
			else
				self.OnUpdate = nil
			end
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
		if self.__Deactivated then
			local unitId = type(self.__Deactivated) == "string" and self.__Deactivated or nil

			self.__Deactivated = nil

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
		if not self.__Deactivated then
			self.__Deactivated = self:GetUnit() or true
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
		Get = function(self)
			return self:GetUnit()
		end,
		Set = function(self, unit)
			self:SetUnit(unit)
		end,
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
				self.__Interval = nil
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
			return not self.__Deactivated
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
	-- Script Handler
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

	local function ShowMenu(self)
		local unit = self:GetAttribute("unit")
		local menu

		if unit == "player" then
			menu = _G.PlayerFrameDropDown
		elseif unit == "pet" then
			menu = _G.PetFrameDropDown
		elseif unit == "target" then
			menu = _G.TargetFrameDropDown
		elseif unit == "focus" then
			menu = _G.FocusFrameDropDown
		end

		if menu then
       		HideDropDownMenu(1)
       		ToggleDropDownMenu(1, nil, menu, self:GetName(), "cursor")
		end
	end

	local function OnShow(self)
		self:UpdateElements()
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent)
		return CreateFrame("Button", name, parent, "SecureUnitButtonTemplate")
	end

    function UnitFrame(self, name, parent)
		self.Layout = DockLayoutPanel
		self.AutoLayout = true

		self:SetAttribute("*type1", "target")
		self:SetAttribute("shift-type1", "focus")	-- default
		self:SetAttribute("*type2", "menu")

		IGAS:GetUI(self).menu = ShowMenu

		self:RegisterForClicks("AnyUp")

		self.OnEnter = self.OnEnter + OnEnter
		self.OnLeave = self.OnLeave + OnLeave
		self.OnShow = self.OnShow + OnShow
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
