-- Author      : Kurapica
-- Create Date : 2012/07/01
-- ChangeLog

local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFContainer", version) then
	return
end

interface "IFContainer"
	extend "IFIterator"

	doc [======[
		@name IFContainer
		@type interface
		@desc IFContainer is used to provide a layout panel to contain ui elements
	]======]

	local function nextWidget(self, key)
		key = key + 1
		local obj = self:GetWidget(key)

		if obj then
			return key, obj
		end
	end

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function Panel_OnMinResizeChanged(self, width, height)
		if self.Parent:GetNumPoints() == 0 or width == 0 or height == 0 or not self:GetLeft() then return end

		width = self:GetLeft() - self.Parent:GetLeft() + self.Parent:GetRight() - self:GetRight() + width
		height = self.Parent:GetTop() - self:GetTop() + self:GetBottom() - self.Parent:GetBottom() + height

		local mWidth, mHeight = self.Parent:GetMinResize()

		mWidth = mWidth or 0
		mHeight = mHeight or 0

		width = mWidth > width and mWidth or width
		height = mHeight > height and mHeight or height

		self.Parent:SetMinResize(width, height)
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name AddWidget
		@type method
		@desc Add Widget to the panel
		@format [name, ]element, ...
		@param name string, the element's name when created
		@param element
		@param ...
		@return number the element's index
	]======]
	function AddWidget(self, name, element, ...)
		local widget

		if type(name) == "string" then
			if Reflector.IsClass(element) and (Reflector.IsSuperClass(element, Region) or Reflector.IsSuperClass(element, VirtualUIObject)) then
				widget = element(name, self.Panel)

				return self.Panel:AddWidget(widget, ...)
			else
				error("Usage : IFContainer:AddWidget(name, element, ...) : element - must be a Region class.", 2)
			end
		elseif Reflector.ObjectIsClass(name, Region) or Reflector.ObjectIsClass(name, VirtualUIObject) then
			widget = name

			return self.Panel:AddWidget(widget, element, ...)
		elseif Reflector.IsClass(name) and (Reflector.IsSuperClass(name, Region) or Reflector.IsSuperClass(name, VirtualUIObject)) then
			widget = name(Reflector.GetName(name), self.Panel)

			return self.Panel:AddWidget(widget, element, ...)
		else
			error("Usage : IFContainer:AddWidget([name, ]element, ...) : element - must be a widget or class of [System.Widget.Region] or [System.Widget.VirtualUIObject].", 2)
		end
	end

	------------------------------------
	--- Insert Widget to the panel
	-- @name InsertWidget
	-- @class function
	-- @param before the index to be insert
	-- @param widget
	-- @param ...
	-- @return index
	------------------------------------
	function InsertWidget(self, before, name, element, ...)
		local widget

		if type(name) == "string" then
			if Reflector.IsClass(element) and (Reflector.IsSuperClass(element, Region) or Reflector.IsSuperClass(element, VirtualUIObject)) then
				widget = element(name, self.Panel)

				return self.Panel:InsertWidget(before, widget, ...)
			else
				error("Usage : IFContainer:InsertWidget(before, name, element, ...) : element - must be a Region class.", 2)
			end
		elseif Reflector.ObjectIsClass(name, Region) or Reflector.ObjectIsClass(name, VirtualUIObject) then
			widget = name

			return self.Panel:InsertWidget(before, widget, element, ...)
		elseif Reflector.IsClass(name) and (Reflector.IsSuperClass(name, Region) or Reflector.IsSuperClass(name, VirtualUIObject)) then
			widget = name(Reflector.GetName(name), self.Panel)

			return self.Panel:InsertWidget(before, widget, element, ...)
		else
			error("Usage : IFContainer:InsertWidget(before, [name, ]element, ...) : element - must be a widget or class of [System.Widget.Region] or [System.Widget.VirtualUIObject].", 2)
		end
	end

	------------------------------------
	--- Get Widget from the panel
	-- @name GetWidget
	-- @class function
	-- @param element
	-- @return widget
	-- @return index
	------------------------------------
	function GetWidget(self, element)
		local widget

		if Reflector.IsClass(element) then
			widget = Reflector.GetName(element)
		else
			widget = element
		end

		if not widget then return end

		return self.Panel:GetWidget(widget)
	end

	------------------------------------
	--- Remove Widget to the panel
	-- @name RemoveWidget
	-- @class function
	-- @param element
	-- @param [withoutDispose]
	-- @return widget
	------------------------------------
	function RemoveWidget(self, element, withoutDispose)
		local widget

		if Reflector.IsClass(element) then
			widget = Reflector.GetName(element)
		else
			widget = element
		end

		if not widget then return end

		return self.Panel:RemoveWidget(widget, withoutDispose)
	end

	------------------------------------
	--- Set Widget's left margin and right margin
	-- @name SetWidgetLeftRight
	-- @class function
	-- @param element
	-- @param left left margin value
	-- @param leftunit left margin's unit
	-- @param right right margin value
	-- @param rightunit right margin's unit
	-- @return panel
	------------------------------------
	function SetWidgetLeftRight(self, element, left, leftunit, right, rightunit)
		local widget

		if Reflector.IsClass(element) then
			widget = Reflector.GetName(element)
		else
			widget = element
		end

		if not widget then return end

		return self.Panel:SetWidgetLeftRight(widget, left, leftunit, right, rightunit)
	end

	SWLR = SetWidgetLeftRight

	------------------------------------
	--- Set Widget's left margin and width
	-- @name SetWidgetLeftWidth
	-- @class function
	-- @param element
	-- @param left left margin value
	-- @param leftunit left margin's unit
	-- @param width width value
	-- @param widthunit width unit
	-- @return panel
	------------------------------------
	function SetWidgetLeftWidth(self, element, left, leftunit, width, widthunit)
		local widget

		if Reflector.IsClass(element) then
			widget = Reflector.GetName(element)
		else
			widget = element
		end

		if not widget then return end

		return self.Panel:SetWidgetLeftWidth(widget, left, leftunit, width, widthunit)
	end

	SWLW = SetWidgetLeftWidth

	------------------------------------
	--- Set Widget's right margin and width
	-- @name SetWidgetRightWidth
	-- @class function
	-- @param element
	-- @param right right margin value
	-- @param rightunit right margin's unit
	-- @param width width value
	-- @param widthunit width unitv
	-- @return panel
	------------------------------------
	function SetWidgetRightWidth(self, element, right, rightunit, width, widthunit)
		local widget

		if Reflector.IsClass(element) then
			widget = Reflector.GetName(element)
		else
			widget = element
		end

		if not widget then return end

		return self.Panel:SetWidgetRightWidth(widget, right, rightunit, width, widthunit)
	end

	SWRW = SetWidgetRightWidth

	------------------------------------
	--- Set Widget's top margin and bottom margin
	-- @name SetWidgetTopBottom
	-- @class function
	-- @param element
	-- @param top top margin value
	-- @param topunit top margin's unit
	-- @param bottom bottom margin value
	-- @param bottomunit bottom margin's unit
	-- @return panel
	------------------------------------
	function SetWidgetTopBottom(self, element, top, topunit, bottom, bottomunit)
		local widget

		if Reflector.IsClass(element) then
			widget = Reflector.GetName(element)
		else
			widget = element
		end

		if not widget then return end

		return self.Panel:SetWidgetTopBottom(widget, top, topunit, bottom, bottomunit)
	end

	SWTB = SetWidgetTopBottom

	------------------------------------
	--- Set Widget's top margin and height
	-- @name SetWidgetTopHeight
	-- @class function
	-- @param element
	-- @param top top margin value
	-- @param topunit top margin's unit
	-- @param height height value
	-- @param heightunit height's unit
	-- @return panel
	------------------------------------
	function SetWidgetTopHeight(self, element, top, topunit, height, heightunit)
		local widget

		if Reflector.IsClass(element) then
			widget = Reflector.GetName(element)
		else
			widget = element
		end

		if not widget then return end

		return self.Panel:SetWidgetTopHeight(widget, top, topunit, height, heightunit)
	end

	SWTH = SetWidgetTopHeight

	------------------------------------
	--- Set Widget's top margin and height
	-- @name SetWidgetBottomHeight
	-- @class function
	-- @param element
	-- @param bottom top margin value
	-- @param bottomunit bottom margin's unit
	-- @param height height value
	-- @param heightunit height's unit
	-- @return panel
	------------------------------------
	function SetWidgetBottomHeight(self, element, bottom, bottomunit, height, heightunit)
		local widget

		if Reflector.IsClass(element) then
			widget = Reflector.GetName(element)
		else
			widget = element
		end

		if not widget then return end

		return self.Panel:SetWidgetBottomHeight(widget, bottom, bottomunit, height, heightunit)
	end

	SWBH = SetWidgetBottomHeight

	------------------------------------
	--- Update layout
	-- @name RefreshLayout
	-- @class function
	------------------------------------
	function RefreshLayout(self)
		return self.Panel:Layout()
	end

	------------------------------------
	--- stop the refresh of the LayoutPanel
	-- @name SuspendLayout
	-- @class function
	------------------------------------
	function SuspendLayout(self)
		return self.Panel:SuspendLayout()
	end

	------------------------------------
	--- resume the refresh of the LayoutPanel
	-- @name ResumeLayout
	-- @class function
	------------------------------------
	function ResumeLayout(self)
		return self.Panel:ResumeLayout()
	end

	------------------------------------
	--- Set the panel's layout
	-- @name SetLayout
	-- @class function
	-- @param layout
	------------------------------------
	function SetLayout(self, layout)
		layout = Reflector.Validate(-LayoutPanel, layout, "layout", "Usage : IFContainer:SetLayout(layout) : ")

		-- just keep safe
		if self.__IFContainer_NoSetPanel then return end

		local obj = self:GetChild("Panel")

		if obj then
			if obj:GetClass() == layout then
				return
			end

			obj:Dispose()
		end

		obj = layout("Panel", self)

		obj.OnMinResizeChanged = obj.OnMinResizeChanged + Panel_OnMinResizeChanged

		self.__IFContainer_NoSetPanel = true

		pcall(self.UpdatePanelPosition, self)

		self.__IFContainer_NoSetPanel = nil

		obj.AutoLayout = self.AutoLayout
	end

	------------------------------------
	--- Get the panel's layout
	-- @name GetLayout
	-- @class function
	-- @return layout
	------------------------------------
	function GetLayout(self)
		local obj = self:GetChild("Panel")

		return obj and obj:GetClass() or LayoutPanel
	end

	------------------------------------
	--- Get the panel object
	-- @name GetPanel
	-- @class function
	------------------------------------
	function GetPanel(self)
		local obj = self:GetChild("Panel")

		if not obj or not obj:IsClass(LayoutPanel) then
			if obj then obj:Dispose() end

			obj = LayoutPanel("Panel", self)

			obj.OnMinResizeChanged = obj.OnMinResizeChanged + Panel_OnMinResizeChanged

			self.__IFContainer_NoSetPanel = true

			pcall(self.UpdatePanelPosition, self)

			self.__IFContainer_NoSetPanel = nil

			obj.AutoLayout = self.AutoLayout
		end

		return obj
	end

	------------------------------------
	--- Update the container's panel's postion, Overridable
	-- @name IFContainer:UpdatePanelPosition
	-- @class function
	-- @usage IFContainer:UpdatePanelPosition()
	------------------------------------
	function UpdatePanelPosition(self)
		self.Panel:ClearAllPoints()
		self.Panel:SetAllPoints(self)
	end

	function Next(self, key)
		return nextWidget, self, tonumber(key) or 0
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Panel
	property "Panel" {
		Get = GetPanel,	-- don't want use custom GetPanel
	}

	-- Layout
	property "Layout" {
		Set = SetLayout,
		Get = GetLayout,
		Type = - LayoutPanel,
	}

	-- Count
	property "Count" {
		Get = function(self)
			return self.Panel.Count
		end,
	}

	-- AutoLayout
	property "AutoLayout" {
		Get = function(self)
			return self.__AutoLayout or false
		end,
		Set = function(self, value)
			self.__AutoLayout = value
			if self:GetChild("Panel") then
				self:GetChild("Panel").AutoLayout = value
			end
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endinterface "IFContainer"