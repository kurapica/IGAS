-- Author      : Kurapica
-- Create Date : 2013/07/22
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFSecurePanel", version) then
	return
end

-------------------------------------
-- Secure Manager
-------------------------------------
do
	-- Manager Frame
	_IFSecurePanel_ManagerFrame = SecureFrame("IGAS_IFSecurePanel_Manager", IGAS.UIParent)
	_IFSecurePanel_ManagerFrame.Visible = false

	_IFSecurePanel_ManagerFrame:Execute[[
		Manager = self

		IFSecurePanel_Panels = newtable()
		IFSecurePanel_Cache = newtable()
		IFSecurePanel_Map = newtable()

		UpdatePanelSize = [=[
			local noForce = ...
			local panel = IFSecurePanel_Map[self] or self
			local elements = IFSecurePanel_Panels[panel]
			local count = 0

			if elements and not panel:GetAttribute("IFSecurePanel_KeepMaxSize") and ( not noForce or panel:GetAttribute("IFSecurePanel_AutoSize") ) then
				for i = #elements, 1, -1 do
					if elements[i]:IsShown() then
						count = i
						break
					end
				end

				if count ~= IFSecurePanel_Cache[panel] then
					IFSecurePanel_Cache[panel] = count

					local row
					local column
					local columnCount = panel:GetAttribute("IFSecurePanel_ColumnCount") or 99
					local rowCount = panel:GetAttribute("IFSecurePanel_RowCount") or 99
					local elementWidth = panel:GetAttribute("IFSecurePanel_Width") or 16
					local elementHeight = panel:GetAttribute("IFSecurePanel_Height") or 16
					local hSpacing = panel:GetAttribute("IFSecurePanel_HSpacing") or 0
					local vSpacing = panel:GetAttribute("IFSecurePanel_VSpacing") or 0
					local marginTop = panel:GetAttribute("IFSecurePanel_MarginTop") or 0
					local marginBottom = panel:GetAttribute("IFSecurePanel_MarginBottom") or 0
					local marginLeft = panel:GetAttribute("IFSecurePanel_MarginLeft") or 0
					local marginRight = panel:GetAttribute("IFSecurePanel_MarginRight") or 0

					if panel:GetAttribute("IFSecurePanel_Orientation") == "HORIZONTAL" then
						row = ceil(i / columnCount)
						column = row == 1 and i or columnCount
					else
						column = ceil(i / rowCount)
						row = column == 1 and i or rowCount
					end

					panel:SetWidth(column * elementWidth + (column - 1) * hSpacing + marginLeft + marginRight)
					panel:SetHeight(row * elementHeight + (row - 1) * vSpacing + marginTop + marginBottom)
				end
			end
		]=]
	]]

	_IFSecurePanel_RegisterPanel = [=[
		local panel = Manager:GetFrameRef("SecurePanel")

		if panel and not IFSecurePanel_Panels[panel] then
			IFSecurePanel_Panels[panel] = newtable()
		end
	]=]

	_IFSecurePanel_UnregisterPanel = [=[
		local panel = Manager:GetFrameRef("SecurePanel")

		if panel then
			IFSecurePanel_Panels[panel] = nil
			IFSecurePanel_Cache[panel] = nil
		end
	]=]

	_IFSecurePanel_RegisterFrame = [=[
		local panel = Manager:GetFrameRef("SecurePanel")
		local frame = Manager:GetFrameRef("SecureElement")

		if panel and frame then
			IFSecurePanel_Panels[panel] = IFSecurePanel_Panels[panel] or newtable()
			tinsert(IFSecurePanel_Panels[panel], frame)

			IFSecurePanel_Map[frame] = panel
		end
	]=]

	_IFSecurePanel_UnregisterFrame = [=[
		local panel = Manager:GetFrameRef("SecurePanel")
		local frame = Manager:GetFrameRef("SecureElement")

		IFSecurePanel_Map[frame] = nil

		if panel and frame and IFSecurePanel_Panels[panel] then
			for k, v in ipairs(IFSecurePanel_Panels[panel]) do
				if v == frame then
					return tremove(IFSecurePanel_Panels[panel], k)
				end
			end
		end
	]=]

	_IFSecurePanel_WrapShow = [[
		Manager:RunFor(self, UpdatePanelSize, true)
	]]

	_IFSecurePanel_WrapHide = [[
		Manager:RunFor(self, UpdatePanelSize, true)
	]]

	_IFSecurePanel_UpdatePanelSize = [=[
		local panel = Manager:GetFrameRef("SecurePanel")

		IFSecurePanel_Cache[panel] = nil

		Manager:RunFor(panel, UpdatePanelSize)
	]=]

	_IFSecurePanel_ClearCache = [=[
		local panel = Manager:GetFrameRef("SecurePanel")

		IFSecurePanel_Cache[panel] = nil
	]=]

	function RegisterPanel(self)
		_IFSecurePanel_ManagerFrame:SetFrameRef("SecurePanel", self)
		_IFSecurePanel_ManagerFrame:Execute(_IFSecurePanel_RegisterPanel)
	end

	function UnregisterPanel(self)
		_IFSecurePanel_ManagerFrame:SetFrameRef("SecurePanel", self)
		_IFSecurePanel_ManagerFrame:Execute(_IFSecurePanel_UnregisterPanel)
	end

	function RegisterFrame(self, frame)
		_IFSecurePanel_ManagerFrame:SetFrameRef("SecurePanel", self)
		_IFSecurePanel_ManagerFrame:SetFrameRef("SecureElement", frame)
		_IFSecurePanel_ManagerFrame:Execute(_IFSecurePanel_RegisterFrame)

		_IFSecurePanel_ManagerFrame:WrapScript(frame, "OnShow", _IFSecurePanel_WrapShow)
		_IFSecurePanel_ManagerFrame:WrapScript(frame, "OnHide", _IFSecurePanel_WrapHide)
	end

	function UnregisterFrame(self, frame)
		_IFSecurePanel_ManagerFrame:UnwrapScript(frame, "OnShow")
    	_IFSecurePanel_ManagerFrame:UnwrapScript(frame, "OnHide")

		_IFSecurePanel_ManagerFrame:SetFrameRef("SecurePanel", self)
		_IFSecurePanel_ManagerFrame:SetFrameRef("SecureElement", frame)
		_IFSecurePanel_ManagerFrame:Execute(_IFSecurePanel_UnregisterFrame)
	end

	function SecureUpdatePanelSize(self)
		_IFSecurePanel_ManagerFrame:SetFrameRef("SecurePanel", self)
		_IFSecurePanel_ManagerFrame:Execute(_IFSecurePanel_UpdatePanelSize)
	end

	function SecureClearPanelCache(self)
		_IFSecurePanel_ManagerFrame:SetFrameRef("SecurePanel", self)
		_IFSecurePanel_ManagerFrame:Execute(_IFSecurePanel_ClearCache)
	end
end

interface "IFSecurePanel"
	extend "IFIterator"

	doc [======[
		@name IFSecurePanel
		@type interface
		@desc IFSecurePanel provides features to build a secure panel to contain elements of same secure class in a grid, the elements are generated by the IFSecurePanel
	]======]

	local function AdjustElement(element, self)
		if not element.ID then return end

		element.Width = self.ElementWidth
		element.Height = self.ElementHeight

		if self.Orientation == Orientation.HORIZONTAL then
			-- Row first
			element:SetPoint("CENTER", self, "TOPLEFT", (element.ID - 1) % self.ColumnCount * (self.ElementWidth + self.HSpacing) + self.MarginLeft + (self.ElementWidth/2), -floor((element.ID - 1) / self.ColumnCount) * (self.ElementHeight + self.VSpacing) - self.MarginTop - (self.ElementHeight/2))
		else
			-- Column first
			element:SetPoint("CENTER", self, "TOPLEFT", floor((element.ID - 1) / self.RowCount) * (self.ElementWidth + self.HSpacing) + self.MarginLeft + (self.ElementWidth/2), -((element.ID - 1) % self.RowCount) * (self.ElementHeight + self.VSpacing) - self.MarginTop - (self.ElementHeight/2))
		end
	end

	local function AdjustPanel(self)
		if self.KeepMaxSize then
			self.Width = self.ColumnCount * self.ElementWidth + (self.ColumnCount - 1) * self.HSpacing + self.MarginLeft + self.MarginRight
			self.Height = self.RowCount * self.ElementHeight + (self.RowCount - 1) * self.VSpacing + self.MarginTop + self.MarginBottom
		else
			SecureUpdatePanelSize(self)
		end
	end

	local function Reduce(self, index)
		index = index or self.RowCount * self.ColumnCount

		if index < self.Count then
			local ele

			for i = self.Count, index + 1, -1 do
				ele = self:GetChild(self.ElementPrefix .. i)
				self:Fire("OnElementRemove", ele)
				ele:Dispose()

				self:SetAttribute("IFSecurePanel_Count", i - 1)
			end

			AdjustPanel(self)
		end
	end

	local function Generate(self, index)
		if self.ElementType and index > self.Count then
			local ele

			for i = self.Count + 1, index do
				ele = self.ElementType(self.ElementPrefix .. i, self)
				ele.ID = i

				AdjustElement(ele, self)

				self:Fire("OnElementAdd", ele)

				self:SetAttribute("IFSecurePanel_Count", i)
			end

			AdjustPanel(self)
		end
	end

	local function nextItem(self, index)
		index = index + 1
		if self:GetChild(self.ElementPrefix .. index) then
			return index, self:GetChild(self.ElementPrefix .. index)
		end
	end

	class "Element"
		doc [======[
			@name Element
			@type class
			@desc Element is an accessor to the IFSecurePanel's elements, used like object.Element[i].Prop = value
		]======]

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function Element(self, elementPanel)
			self.__IFSecurePanel = elementPanel
	    end

		------------------------------------------------------
		-- __index
		------------------------------------------------------
		function __index(self, index)
			self = self.__IFSecurePanel

			if type(index) == "number" and index >= 1 and index <= self.ColumnCount * self.RowCount then
				index = floor(index)

				if self:GetChild(self.ElementPrefix .. index) then return self:GetChild(self.ElementPrefix .. index) end

				if self.ElementType and not InCombatLockdown() then
					Generate(self, index)

					return self:GetChild(self.ElementPrefix .. index)
				else
					return nil
				end
			end
		end
	endclass "Element"

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnElementAdd
		@type event
		@desc Fired when an element is added
		@param element System.Widget.Region, the new element that added to the panel
	]======]
	event "OnElementAdd"

	doc [======[
		@name OnElementRemove
		@type event
		@desc Fired when an element is removed
		@param element System.Widget.Region, the new element that removed from the panel
	]======]
	event "OnElementRemove"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Next(self, key)
		return nextItem, self, tonumber(key) or 0
	end

	function EachK(self, key, oper, ...)
		IFIterator.EachK(self, key, oper, ...)

		IFNoCombatTaskHandler._RegisterNoCombatTask(AdjustPanel, self)
	end

	function Each(self, oper, ...)
		IFIterator.Each(self, oper, ...)

		IFNoCombatTaskHandler._RegisterNoCombatTask(AdjustPanel, self)
	end

	doc [======[
		@name UpdatePanelSize
		@type method
		@desc Update the panel size manually
		@return nil
	]======]
	function UpdatePanelSize(self)
		IFNoCombatTaskHandler._RegisterNoCombatTask(SecureUpdatePanelSize, self)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name ColumnCount
		@type property
		@desc The columns's count
	]======]
	property "ColumnCount" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_ColumnCount") or 99
		end,
		Set = function(self, cnt)
			cnt = floor(cnt)

			if cnt < 1 then
				error("IFSecurePanel.ColumnCount must be greater than 0.", 2)
			end

			if cnt ~= self.ColumnCount then
				IFNoCombatTaskHandler._RegisterNoCombatTask(function()
					self:SetAttribute("IFSecurePanel_ColumnCount", cnt)

					Reduce(self)
					self:Each(AdjustElement, self)
				end)
			end
		end,
		Type = Number,
	}

	doc [======[
		@name RowCount
		@type property
		@desc The row's count
	]======]
	property "RowCount" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_RowCount") or 99
		end,
		Set = function(self, cnt)
			cnt = floor(cnt)

			if cnt < 1 then
				error("IFSecurePanel.RowCount must be greater than 0.", 2)
			end

			if cnt ~= self.RowCount then
				IFNoCombatTaskHandler._RegisterNoCombatTask(function()
					self:SetAttribute("IFSecurePanel_RowCount", cnt)

					Reduce(self)
					self:Each(AdjustElement, self)
				end)
			end
		end,
		Type = Number,
	}

	doc [======[
		@name MaxCount
		@type property
		@desc The elements's max count
	]======]
	property "MaxCount" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_ColumnCount") * self:GetAttribute("IFSecurePanel_RowCount")
		end,
	}

	doc [======[
		@name ElementWidth
		@type property
		@desc The element's width
	]======]
	property "ElementWidth" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_Width") or 16
		end,
		Set = function(self, cnt)
			cnt = floor(cnt)

			if cnt < 1 then
				error("IFSecurePanel.ElementWidth must be greater than 0.", 2)
			end

			if cnt ~= self.ElementWidth then
				IFNoCombatTaskHandler._RegisterNoCombatTask(function()
					self:SetAttribute("IFSecurePanel_Width", cnt)

					self:Each(AdjustElement, self)
				end)
			end
		end,
		Type = Number,
	}

	doc [======[
		@name ElementHeight
		@type property
		@desc The element's height
	]======]
	property "ElementHeight" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_Height") or 16
		end,
		Set = function(self, cnt)
			cnt = floor(cnt)

			if cnt < 1 then
				error("IFSecurePanel.ElementHeight must be greater than 0.", 2)
			end

			if cnt ~= self.ElementHeight then
				IFNoCombatTaskHandler._RegisterNoCombatTask(function()
					self:SetAttribute("IFSecurePanel_Height", cnt)

					self:Each(AdjustElement, self)
				end)
			end
		end,
		Type = Number,
	}

	doc [======[
		@name Count
		@type property
		@desc The element's count
	]======]
	property "Count" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_Count") or 0
		end,
		Set = function(self, cnt)
			cnt = floor(cnt)

			if cnt < 0 then
				error("Count can't be negative.", 2)
			elseif cnt > self.RowCount * self.ColumnCount then
				error("Count can't be more than "..self.RowCount * self.ColumnCount, 2)
			end

			if cnt > self.Count then
				if self.ElementType then
					IFNoCombatTaskHandler._RegisterNoCombatTask(Generate, self, cnt)
				else
					error("ElementType not set.", 2)
				end
			elseif cnt < self.Count then
				IFNoCombatTaskHandler._RegisterNoCombatTask(Reduce, self, cnt)
			end
		end,
		Type = Number,
	}

	doc [======[
		@name Orientation
		@type property
		@desc The orientation for elements
	]======]
	property "Orientation" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_Orientation") or Orientation.HORIZONTAL
		end,
		Set = function(self, orientation)
			if orientation == self.Orientation then return end

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self:SetAttribute("IFSecurePanel_Orientation", orientation)

				self:Each(AdjustElement, self)
			end)
		end,
		Type = Orientation,
	}

	doc [======[
		@name ElementType
		@type property
		@desc The element's type
	]======]
	property "ElementType" {
		Get = function(self)
			return self.__IFSecurePanel_Type
		end,
		Set = function(self, elementType)
			if elementType ~= self.__IFSecurePanel_Type then
				self.__IFSecurePanel_Type = elementType
			end
		end,
		Type = -IFSecureHandler,
	}

	doc [======[
		@name HSpacing
		@type property
		@desc The horizontal spacing
	]======]
	property "HSpacing" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_HSpacing") or 0
		end,
		Set = function(self, spacing)
			if self:GetAttribute("IFSecurePanel_HSpacing") == spacing then return end

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self:SetAttribute("IFSecurePanel_HSpacing", spacing > 0 and floor(spacing) or 0)

				self:Each(AdjustElement, self)
			end)
		end,
		Type = Number,
	}

	doc [======[
		@name VSpacing
		@type property
		@desc The vertical spacing
	]======]
	property "VSpacing" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_VSpacing") or 0
		end,
		Set = function(self, spacing)
			if self:GetAttribute("IFSecurePanel_VSpacing") == spacing then return end

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self:SetAttribute("IFSecurePanel_VSpacing", spacing > 0 and floor(spacing) or 0)

				self:Each(AdjustElement, self)
			end)
		end,
		Type = Number,
	}

	doc [======[
		@name AutoSize
		@type property
		@desc Whether the elementPanel is autosize
	]======]
	property "AutoSize" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_AutoSize") and true or false
		end,
		Set = function(self, flag)
			if flag == self.AutoSize then return end

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self:SetAttribute("IFSecurePanel_AutoSize", flag)

				SecureUpdatePanelSize(self)
			end)
		end,
		Type = Boolean,
	}

	doc [======[
		@name MarginTop
		@type property
		@desc The top margin
	]======]
	property "MarginTop" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_MarginTop") or 0
		end,
		Set = function(self, spacing)
			if self:GetAttribute("IFSecurePanel_MarginTop") == spacing then return end

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self:SetAttribute("IFSecurePanel_MarginTop", spacing > 0 and floor(spacing) or 0)

				self:Each(AdjustElement, self)
			end)
		end,
		Type = Number,
	}

	doc [======[
		@name MarginBottom
		@type property
		@desc The bottom margin
	]======]
	property "MarginBottom" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_MarginBottom") or 0
		end,
		Set = function(self, spacing)
			if self:GetAttribute("IFSecurePanel_MarginBottom") == spacing then return end

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self:SetAttribute("IFSecurePanel_MarginBottom", spacing > 0 and floor(spacing) or 0)

				AdjustPanel(self)
			end)
		end,
		Type = Number,
	}

	doc [======[
		@name MarginLeft
		@type property
		@desc The left margin
	]======]
	property "MarginLeft" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_MarginLeft") or 0
		end,
		Set = function(self, spacing)
			if self:GetAttribute("IFSecurePanel_MarginLeft") == spacing then return end

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self:SetAttribute("IFSecurePanel_MarginLeft", spacing > 0 and floor(spacing) or 0)

				self:Each(AdjustElement, self)
			end)
		end,
		Type = Number,
	}

	doc [======[
		@name MarginRight
		@type property
		@desc The right margin
	]======]
	property "MarginRight" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_MarginRight") or 0
		end,
		Set = function(self, spacing)
			if self:GetAttribute("IFSecurePanel_MarginRight") == spacing then return end

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self:SetAttribute("IFSecurePanel_MarginRight", spacing > 0 and floor(spacing) or 0)

				AdjustPanel(self)
			end)
		end,
		Type = Number,
	}

	doc [======[
		@name Element
		@type property
		@desc The Element accessor, used like obj.Element[i]
	]======]
	property "Element" {
		Get = function(self)
			self.__IFSecurePanel_Element = self.__IFSecurePanel_Element or Element(self)
			return self.__IFSecurePanel_Element
		end,
		Type = Element,
	}

	doc [======[
		@name ElementPrefix
		@type property
		@desc The prefix for the element's name
	]======]
	property "ElementPrefix" {
		Get = function(self)
			return self.__ElementPrefix or "Element"
		end,
		Set = function(self, value)
			self.__ElementPrefix = value
		end,
		Type = System.String + nil,
	}

	doc [======[
		@name KeepMaxSize
		@type property
		@desc Whether the elementPanel should keep it's max size
	]======]
	property "KeepMaxSize" {
		Get = function(self)
			return self:GetAttribute("IFSecurePanel_KeepMaxSize") or false
		end,
		Set = function(self, value)
			if value == self.KeepMaxSize then return end

			IFNoCombatTaskHandler._RegisterNoCombatTask(function()
				self:SetAttribute("IFSecurePanel_KeepMaxSize", value)

				AdjustPanel(self)
			end)
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnElementAdd(self, element)
		IFNoCombatTaskHandler._RegisterNoCombatTask(RegisterFrame, self, element)
	end

	local function OnElementRemove(self, element)
		IFNoCombatTaskHandler._RegisterNoCombatTask(UnregisterFrame, self, IGAS:GetUI(element))
	end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		self.OnElementAdd = self.OnElementAdd - OnElementAdd
		self.OnElementRemove = self.OnElementRemove - OnElementRemove

		for i = 1, self.Count do
			IFNoCombatTaskHandler._RegisterNoCombatTask(UnregisterFrame, IGAS:GetUI(self), IGAS:GetUI(self.Element[i]))
		end

		IFNoCombatTaskHandler._RegisterNoCombatTask(UnregisterPanel, IGAS:GetUI(self))
	end

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
	function IFSecurePanel(self)
		self.OnElementAdd = self.OnElementAdd + OnElementAdd
		self.OnElementRemove = self.OnElementRemove + OnElementRemove

		RegisterPanel(self)
	end
endinterface "IFSecurePanel"