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
		@desc IFContainer is used to provide a layout panel to contain ui elements for the ui objects
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
		@desc Add element to the panel
		@format [name, ]element[, ...]
		@param name string, the element's name when created, only needed when the element is a ui element class not a ui element, default the class's name
		@param element System.Widget.Region | System.Widget.VirtualUIObject | System.Widget.Region class | System.Widget.VirtualUIObject class, an ui element or ui element class to be added
		@param ... arguments for the layout panel's AddWidget method
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

	doc [======[
		@name InsertWidget
		@type method
		@desc Insert element to the panel
		@format before, [name, ]element[, ...]
		@param before element that existed in the layout panel
		@param name string, the element's name when created, only needed when the element is a ui element class not a ui element, default the class's name
		@param element System.Widget.Region | System.Widget.VirtualUIObject | System.Widget.Region class | System.Widget.VirtualUIObject class, an ui element or ui element class to be inserted
		@param ... arguments for the layout panel's AddWidget method
		@return number the element's index
	]======]
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

	doc [======[
		@name GetWidget
		@type method
		@desc Get element from the panel
		@param element string | System.Widget.Region class, name or or ui element class
		@return element the ui element
		@return number the element's index
	]======]
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

	doc [======[
		@name RemoveWidget
		@type method
		@desc Remove element from the panel
		@format index|name|element[, withoutDispose]
		@param index number, the index of the element
		@param name string, the name of the element
		@param element System.Widget.Region|System.Widget.VirtualUIObject, the element
		@param withoutDispose boolean, true if need get the removed widget
		@return element if withoutDispose is set to true

	]======]
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

	doc [======[
		@name SetWidgetLeftRight
		@type method
		@desc Set Widget's left margin and right margin
		@param index|name|widget the ui element
		@param left number, left margin value
		@param leftunit string, left margin's unit
		@param right number, right margin value
		@param rightunit string, right margin's unit
		@return object the panel self
	]======]
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

	doc [======[
		@name SWLR
		@type method
		@desc Short for SetWidgetLeftRight, Set Widget's left margin and right margin
		@param index|name|widget the ui element
		@param left number, left margin value
		@param leftunit System.Widget.LayoutPanel.Unit, left margin's unit
		@param right number, right margin value
		@param rightunit System.Widget.LayoutPanel.Unit, right margin's unit
		@return object the panel self
	]======]
	SWLR = SetWidgetLeftRight

	doc [======[
		@name SetWidgetLeftWidth
		@type method
		@desc Set Widget's left margin and width
		@param index|name|widget the ui element
		@param left number, left margin value
		@param leftunit System.Widget.LayoutPanel.Unit, left margin's unit
		@param width number, width value
		@param widthunit System.Widget.LayoutPanel.Unit, width unit
		@return object the panel self
	]======]
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

	doc [======[
		@name SWLW
		@type method
		@desc Short for SetWidgetLeftWidth.Set Widget's left margin and width
		@param index|name|widget the ui element
		@param left number, left margin value
		@param leftunit System.Widget.LayoutPanel.Unit, left margin's unit
		@param width number, width value
		@param widthunit System.Widget.LayoutPanel.Unit, width unit
		@return object the panel self
	]======]
	SWLW = SetWidgetLeftWidth

	doc [======[
		@name SetWidgetRightWidth
		@type method
		@desc Set Widget's right margin and width
		@param index|name|widget the ui element
		@param right number, right margin value
		@param rightunit System.Widget.LayoutPanel.Unit, right margin's unit
		@param width number, width value
		@param widthunit System.Widget.LayoutPanel.Unit, width unitv
		@return object the panel self
	]======]
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

	doc [======[
		@name SWRW
		@type method
		@desc Short for SetWidgetRightWidth. Set Widget's right margin and width
		@param index|name|widget the ui element
		@param right number, right margin value
		@param rightunit System.Widget.LayoutPanel.Unit, right margin's unit
		@param width number, width value
		@param widthunit System.Widget.LayoutPanel.Unit, width unitv
		@return object the panel self
	]======]
	SWRW = SetWidgetRightWidth

	doc [======[
		@name SetWidgetTopBottom
		@type method
		@desc Set Widget's top margin and bottom margin
		@param index|name|widget the ui element
		@param top number, top margin value
		@param topunit System.Widget.LayoutPanel.Unit, top margin's unit
		@param bottom number, bottom margin value
		@param bottomunit System.Widget.LayoutPanel.Unit, bottom margin's unit
		@return object the panel self
	]======]
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

	doc [======[
		@name SWTB
		@type method
		@desc description
		@desc Short for SetWidgetTopBottom. Set Widget's top margin and bottom margin
		@param index|name|widget the ui element
		@param top number, top margin value
		@param topunit System.Widget.LayoutPanel.Unit, top margin's unit
		@param bottom number, bottom margin value
		@param bottomunit System.Widget.LayoutPanel.Unit, bottom margin's unit
		@return object the panel self
	]======]
	SWTB = SetWidgetTopBottom

	doc [======[
		@name SetWidgetTopHeight
		@type method
		@desc Set Widget's top margin and height
		@param index|name|widget the ui element
		@param top number, top margin value
		@param topunit System.Widget.LayoutPanel.Unit, top margin's unit
		@param height number, height value
		@param heightunit System.Widget.LayoutPanel.Unit, height's unit
		@return object the panel self
	]======]
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

	doc [======[
		@name SWTH
		@type method
		@desc Short for SetWidgetTopHeight. Set Widget's top margin and height
		@param index|name|widget the ui element
		@param top number, top margin value
		@param topunit System.Widget.LayoutPanel.Unit, top margin's unit
		@param height number, height value
		@param heightunit System.Widget.LayoutPanel.Unit, height's unit
		@return object the panel self
	]======]
	SWTH = SetWidgetTopHeight

	doc [======[
		@name SetWidgetBottomHeight
		@type method
		@desc Set Widget's bottom margin and height
		@param index|name|widget the ui element
		@param bottom number, bottom margin value
		@param bottomunit System.Widget.LayoutPanel.Unit, bottom margin's unit
		@param height number, height value
		@param heightunit System.Widget.LayoutPanel.Unit, height's unit
		@return object the panel self
	]======]
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

	doc [======[
		@name SWBH
		@type method
		@desc Short for SetWidgetBottomHeight. Set Widget's bottom margin and height
		@param index|name|widget the ui element
		@param bottom number, bottom margin value
		@param bottomunit System.Widget.LayoutPanel.Unit, bottom margin's unit
		@param height number, height value
		@param heightunit System.Widget.LayoutPanel.Unit, height's unit
		@return object the panel self
	]======]
	SWBH = SetWidgetBottomHeight

	doc [======[
		@name RefreshLayout
		@type method
		@desc Refresh the layout panel
		@return nil
	]======]
	function RefreshLayout(self)
		return self.Panel:Layout()
	end

	doc [======[
		@name SuspendLayout
		@type method
		@desc Stop the refresh of the layout panel
		@return nil
	]======]
	function SuspendLayout(self)
		return self.Panel:SuspendLayout()
	end

	doc [======[
		@name ResumeLayout
		@type method
		@desc Resume the refresh of the layout panel
		@return nil
	]======]
	function ResumeLayout(self)
		return self.Panel:ResumeLayout()
	end

	doc [======[
		@name SetLayout
		@type method
		@desc Set the layout panel's type
		@param layout System.Widget.LayoutPanel class
		@return nil
	]======]
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

	doc [======[
		@name GetLayout
		@type method
		@desc Get the layout panel's type
		@return class the layout panel's type
	]======]
	function GetLayout(self)
		local obj = self:GetChild("Panel")

		return obj and obj:GetClass() or LayoutPanel
	end

	doc [======[
		@name GetPanel
		@type method
		@desc Get the layout panel
		@return System.Widget.LayoutPanel
	]======]
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

	doc [======[
		@name UpdatePanelPosition
		@type method
		@desc Update the container's panel's postion, Overridable
		@return nil
	]======]
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
	doc [======[
		@name Panel
		@type property
		@desc The layout panel
	]======]
	property "Panel" {
		Get = GetPanel,	-- don't want use custom GetPanel
	}

	doc [======[
		@name Layout
		@type property
		@desc The layout panel's type
	]======]
	property "Layout" {
		Set = SetLayout,
		Get = GetLayout,
		Type = - LayoutPanel,
	}

	doc [======[
		@name Count
		@type property
		@desc The element's count in the layout panel
	]======]
	property "Count" {
		Get = function(self)
			return self.Panel.Count
		end,
	}

	doc [======[
		@name AutoLayout
		@type property
		@desc Whether the layout panel is auto update
	]======]
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