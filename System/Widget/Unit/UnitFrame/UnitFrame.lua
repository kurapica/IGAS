-- Author      : Kurapica
-- Create Date : 2012/06/24
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- UnitFrame
-- <br><br>inherit <a href="..\Secure\SecureButton.html">SecureButton</a> For all methods, properties and scriptTypes
-- @name UnitFrame
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.UnitFrame", version) then
	return
end

class "UnitFrame"
	inherit "Button"
	extend "IFContainer" "IFSecureHandler"

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

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Add Element
	-- @name AddElement
	-- @class function
	-- @param ...
	------------------------------------
	function AddElement(self, ...)
		IFContainer.AddWidget(self, ...)

		UpdateUnit(self, self.Unit)
	end

	------------------------------------
	--- Insert Element
	-- @name InsertElement
	-- @class function
	-- @param ...
	------------------------------------
	function InsertElement(self, ...)
		IFContainer.InsertWidget(self, ...)

		UpdateUnit(self, self.Unit)
	end

	------------------------------------
	--- Get Element
	-- @name GetElement
	-- @class function
	-- @param ...
	------------------------------------
	function GetElement(self, ...)
		return IFContainer.GetWidget(self, ...)
	end

	------------------------------------
	--- Remove Element
	-- @name RemoveElement
	-- @class function
	-- @param ...
	------------------------------------
	function RemoveElement(self, ...)
		return IFContainer.RemoveWidget(self, ...)
	end

	------------------------------------
	--- Set Unit
	-- @name SetUnit
	-- @class function
	-- @param unit
	------------------------------------
	function SetUnit(self, unit)
		if type(unit) == "string" then
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

			--if unit and (unit:match("%w+target") or unit:match("(boss)%d?$")) then
			if unit and (unit:match("%w+target")) then
				self.OnUpdate = OnUpdate
			else
				self.OnUpdate = nil
			end
		end
	end

	------------------------------------
	--- Get Unit
	-- @name GetUnit
	-- @class function
	-- @return unit
	------------------------------------
	function GetUnit(self, unit)
		return self:GetAttribute("unit")
	end

	------------------------------------
	--- UpdateElements
	-- @name GetUnit
	-- @class function
	-- @return unit
	------------------------------------
	function UpdateElements(self)
		self:Each("Refresh")
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Unit
	property "Unit" {
		Get = function(self)
			return self:GetUnit()
		end,
		Set = function(self, unit)
			self:SetUnit(unit)
		end,
		Type = String + nil,
	}
	-- Interval
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
