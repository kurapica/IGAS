-- Author      : Kurapica
-- Create Date : 5/13/2012
-- ChangeLog

----------------------------------------------------------------------------------------------------------------------------------------
--- DockLayoutPanel
-- <br><br>inherit <a href=".\LayoutPanel.html">LayoutPanel</a> For all methods, properties and scriptTypes
-- @name DockLayoutPanel
----------------------------------------------------------------------------------------------------------------------------------------

local version = 6
if not IGAS:NewAddon("IGAS.Widget.DockLayoutPanel", version) then
	return
end

class "DockLayoutPanel"
	inherit "LayoutPanel"

	import "System.Reflector"

	_NORTH = "NORTH"
	_EAST = "EAST"
	_SOUTH = "SOUTH"
	_WEST = "WEST"
	_REST = "REST"

	_Error_Widget = "%swidget must be an object of [System.Widget.Region] or [System.Widget.VirtualUIObject]."
	_Error_NoMore = "%sthe panel can't add more widget."
	_Error_NoSize = "%sthere is no more space for the size."
	_Error_Number = "%ssize must be a number."
	_Error_Percent = "%ssize must be 0 - 100."
	_Error_LeZero = "%ssize can't be less than 0."
	_Error_Before = "%sbefore not exist."
	_Error_NoUnit = "%sunit not exist."
	_Error_NEDIR = "%sdirection can't be clear."
	_Error_CLDIR = "%scontent widget can't have direction."

	local function OnVisibleChanged(self)
		if Reflector.ObjectIsClass(self.Parent, DockLayoutPanel) then
			if self.Parent.AutoLayout and self.__DockLayout_DIR then
				self.Parent:Layout()
			end
		else
			self.OnVisibleChanged = self.OnVisibleChanged - OnVisibleChanged
		end
	end

	local function CalcSize(self, param, size, unit)
		if unit == LayoutPanel.Unit.PCT then
			return floor(self[param] * floor(size) / 100)
		elseif unit == LayoutPanel.Unit.MIX then
			return floor(self[param] * floor(size * 100 % 100) / 100) + floor(size)
		else
			return floor(size)
		end
	end

	local function TestLayout(self, index, inserted, _widget, _dir, _size, _unit)
		local startWidth = 0
		local startHeight = 0
		local remainWidth = self.Width
		local remainHeight = self.Height

		-- when self not setpoint, just let it go
		if remainHeight == 0 and remainWidth == 0 then return true end

		local dir, size, unit, calcSize

		local frm

		local i = 1

		while i <= self.Count or i <= index do
			if i == index and inserted then
				frm = _widget

				dir = _dir
				size = _size
				unit = _unit

				inserted = false
			elseif i <= self.Count then
				frm = self:GetWidget(i)

				i = i + 1

				if frm == _widget then
					dir = _dir
					size = _size
					unit = _unit
				else
					dir = frm.__DockLayout_DIR
					size = frm.__DockLayout_SIZE
					unit = frm.__DockLayout_UNIT
				end
			else
				break
			end

			if frm and Reflector.ObjectIsClass(frm, Region) then
				if dir and size and unit then
					if dir == _NORTH then
						calcSize = CalcSize(self, "Height", size, unit)

						if remainHeight - startHeight >= calcSize then
							startHeight = startHeight + calcSize + self.VSpacing
						else
							return false
						end
					elseif dir == _EAST then
						calcSize = CalcSize(self, "Width", size, unit)

						if remainWidth - startWidth >= calcSize then
							remainWidth = remainWidth - calcSize - self.HSpacing
						else
							return false
						end
					elseif dir == _SOUTH then
						calcSize = CalcSize(self, "Height", size, unit)

						if remainHeight - startHeight >= calcSize then
							remainHeight = remainHeight - calcSize - self.VSpacing
						else
							return false
						end
					elseif dir == _WEST then
						calcSize = CalcSize(self, "Width", size, unit)

						if remainWidth - startWidth >= calcSize then
							startWidth = startWidth + calcSize + self.HSpacing
						else
							return false
						end
					end
				end
			end
		end

		return true
	end

	local function UpdateLayout(self)
		local left = 0
		local top = 0
		local right = 0
		local bottom = 0

		local frm, dir, size, unit

		for i = 1, self.Count do
			frm = self:GetWidget(i)

			if Reflector.ObjectIsClass(frm, Region) and frm.Visible then
				dir = frm.__DockLayout_DIR
				size = frm.__DockLayout_SIZE or 0
				unit = frm.__DockLayout_UNIT

				if unit == LayoutPanel.Unit.PCT then
					size = floor(size) / 100
				elseif unit == LayoutPanel.Unit.PX then
					size = floor(size)
				end

				if dir then
					size = size

					if dir == _NORTH then
						self:SetWidgetLeftRight(frm, left, "MIX", right, "MIX")
						self:SetWidgetTopHeight(frm, top, "MIX", size, "MIX")

						top = top + size + self.VSpacing
					elseif dir == _EAST then
						self:SetWidgetRightWidth(frm, right, "MIX", size, "MIX")
						self:SetWidgetTopBottom(frm, top, "MIX", bottom, "MIX")

						right = right + size + self.HSpacing
					elseif dir == _SOUTH then
						self:SetWidgetLeftRight(frm, left, "MIX", right, "MIX")
						self:SetWidgetBottomHeight(frm, bottom, "MIX", size, "MIX")

						bottom = bottom + size + self.VSpacing
					elseif dir == _WEST then
						self:SetWidgetLeftWidth(frm, left, "MIX", size, "MIX")
						self:SetWidgetTopBottom(frm, top, "MIX", bottom, "MIX")

						left = left + size + self.HSpacing
					end
				end
			end
		end

		if self.__DockLayoutHasLast then
			self:SetWidgetLeftRight(self.__DockLayoutHasLast, left, "MIX", right, "MIX")
			self:SetWidgetTopBottom(self.__DockLayoutHasLast, top, "MIX", bottom, "MIX")
		end
	end

	local function SecureUpdateLayout(self)
		Super.SuspendLayout(self)

		pcall(UpdateLayout, self)

		Super.ResumeLayout(self)
	end

	local function ValidateAdd(self, prefix, direction, before, widget, size, unit)
		prefix = prefix or ""

		-- widget check
		if Reflector.ObjectIsClass(widget, Region) then
			-- pass
		elseif Reflector.ObjectIsClass(widget, VirtualUIObject) then
			-- clear
			direction = nil
			size = nil
			unit = nil
		else
			error(_Error_Widget:format(prefix), 3)
		end

		-- direction & size check
		direction = direction and Reflector.Validate(Direction, direction, "direction", prefix, 1)

		-- unit check
		unit = unit and Reflector.Validate(LayoutPanel.Unit, unit, "unit", prefix, 1)

		-- size check
		if direction and direction ~= _REST then
			if type(size) ~= "number" then
				error(_Error_Number:format(prefix), 3)
			end

			if unit == LayoutPanel.Unit.PCT then
				size = floor(size)

				if size < 0 or size >= 100 then
					error(_Error_Percent:format(prefix), 3)
				end
			elseif unit == LayoutPanel.Unit.PX then
				size = floor(size)

				if size <= 0 then
					error(_Error_LeZero:format(prefix), 3)
				end
			elseif unit == LayoutPanel.Unit.MIX then
				if size <= 0 then
					error(_Error_LeZero:format(prefix), 3)
				end
			else
				error(_Error_NoUnit:format(prefix), 3)
			end
		else
			-- clear make to use last area
			size = nil
			unit = nil
		end

		-- before check
		before = before and self:GetWidgetIndex(before)

		local index = self:GetWidgetIndex(widget)
		local inserted

		if index then
			inserted = false
		else
			inserted = true
			index = before or (self.__DockLayoutHasLast and self.Count or (self.Count + 1))
		end

		if inserted then
			if direction == _REST and self.__DockLayoutHasLast then
				error(_Error_NoMore:format(prefix), 3)
			end
		else
			if direction == _REST and self.__DockLayoutHasLast and self.__DockLayoutHasLast ~= widget then
				error(_Error_NEDIR:format(prefix), 3)
			elseif direction ~= _REST and self.__DockLayoutHasLast == widget then
				error(_Error_CLDIR:format(prefix), 3)
			end
		end

		-- Test new settings
		if direction and not TestLayout(self, index, inserted, widget, direction, size, unit) then
			error(_Error_NoSize:format(prefix), 3)
		end

		-- Insert the widget
		if inserted then
			Super.InsertWidget(self, index, widget)

			if direction then
				widget.OnVisibleChanged = widget.OnVisibleChanged + OnVisibleChanged
			end
		end

		-- Update docklayout settings
		if direction then
			widget.__DockLayout_DIR = direction
			widget.__DockLayout_SIZE = size
			widget.__DockLayout_UNIT = unit
		end

		-- Update control flag
		if direction == _REST then
			self.__DockLayoutHasLast = widget
		end

		-- Refresh self
		if direction then
			SecureUpdateLayout(self)
		end

		return index
	end

	------------------------------------------------------
	-- Enum
	------------------------------------------------------
	enum "Direction" {
		_NORTH,
		_EAST,
		_SOUTH,
		_WEST,
		_REST,
	}

	------------------------------------------------------
	-- Script
	------------------------------------------------------


	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------
	--- Add Widget to the panel
	-- @name DockLayoutPanel:AddWidget
	-- @class function
	-- @param direction
	-- @param widget
	-- @param size
	-- @param unit
	-- @return index
	------------------------------------
	function AddWidget(self, widget, direction, size, unit)
		local prefix = "Usage : DockLayoutPanel:AddWidget(widget, direction, size, unit) : "

		return ValidateAdd(self, prefix, direction, nil, widget, size, unit)
	end

	------------------------------------
	--- Insert Widget to the panel
	-- @name LayoutPanel:InsertWidget
	-- @class function
	-- @param index the index to be insert
	-- @param widget
	-- @return index
	------------------------------------
	function InsertWidget(self, before, widget, direction, size, unit)
		local prefix = "Usage : DockLayoutPanel:InsertWidget(before, widget, direction, size, unit) : "

		return ValidateAdd(self, prefix, direction, before, widget, size, unit)
	end

	------------------------------------
	--- Remove Widget to the panel
	-- @name LayoutPanel:RemoveWidget
	-- @class function
	-- @param index|name index or the name that need to be removed
	-- @param withoutDispose optional, true if need get the removed widget
	-- @return widget if withoutDispose is set to true
	------------------------------------
	function RemoveWidget(self, index, withoutDispose)
		local obj = Super.RemoveWidget(self, index, withoutDispose)

		if obj then
			obj.__DockLayout_DIR = nil
			obj.__DockLayout_SIZE = nil
			obj.__DockLayout_UNIT = nil

			if Reflector.ObjectIsClass(obj, Region) then
				obj.OnVisibleChanged = obj.OnVisibleChanged - OnVisibleChanged
			end
		end

		SecureUpdateLayout(self)

		return obj
	end

	------------------------------------
	--- Update layout
	-- @name LayoutPanel:Layout
	-- @class function
	------------------------------------
	function Layout(self)
		SecureUpdateLayout(self)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- HSpacing
	property "HSpacing" {
		Get = function(self)
			return self.__DockLayoutPanel_HSpacing or 0
		end,
		Set = function(self, spacing)
			if self.__DockLayoutPanel_HSpacing == spacing then return end

			self.__DockLayoutPanel_HSpacing = spacing > 0 and floor(spacing) or 0
			SecureUpdateLayout(self)
		end,
		Type = Number,
	}
	-- HSpacing
	property "VSpacing" {
		Get = function(self)
			return self.__DockLayoutPanel_VSpacing or 0
		end,
		Set = function(self, spacing)
			if self.__DockLayoutPanel_VSpacing == spacing then return end

			self.__DockLayoutPanel_VSpacing = spacing > 0 and floor(spacing) or 0
			SecureUpdateLayout(self)
		end,
		Type = Number,
	}
	-- AutoLayout
	property "AutoLayout" {
		Get = function(self)
			return self.__DockLayoutPanel__AutoLayout and true or false
		end,
		Set = function(self, flag)
			self.__DockLayoutPanel__AutoLayout = flag
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "DockLayoutPanel"