-- Author      : Kurapica
-- Create Date : 2012/08/27
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFElementPanel", version) then
	return
end

interface "IFElementPanel"
	extend "IFIterator"

	doc [======[
		@name IFElementPanel
		@type interface
		@desc IFElementPanel provides features to build an panel to contain elements of same class in a grid, the elements are created by the IFElementPanel
	]======]

	local function AdjustElement(element, self)
		if not element.ID then return end

		element.Width = self.ElementWidth
		element.Height = self.ElementHeight

		if self.Orientation == Orientation.HORIZONTAL then
			-- Row first
			--element:SetPoint("TOPLEFT", (element.ID - 1) % self.ColumnCount * (self.ElementWidth + self.HSpacing) + self.MarginLeft, -floor((element.ID - 1) / self.ColumnCount) * (self.ElementHeight + self.VSpacing) - self.MarginTop)
			element:SetPoint("CENTER", self, "TOPLEFT", (element.ID - 1) % self.ColumnCount * (self.ElementWidth + self.HSpacing) + self.MarginLeft + (self.ElementWidth/2), -floor((element.ID - 1) / self.ColumnCount) * (self.ElementHeight + self.VSpacing) - self.MarginTop - (self.ElementHeight/2))
		else
			-- Column first
			--element:SetPoint("TOPLEFT", floor((element.ID - 1) / self.RowCount) * (self.ElementWidth + self.HSpacing) + self.MarginLeft, -((element.ID - 1) % self.RowCount) * (self.ElementHeight + self.VSpacing) - self.MarginTop)
			element:SetPoint("CENTER", self, "TOPLEFT", floor((element.ID - 1) / self.RowCount) * (self.ElementWidth + self.HSpacing) + self.MarginLeft + (self.ElementWidth/2), -((element.ID - 1) % self.RowCount) * (self.ElementHeight + self.VSpacing) - self.MarginTop - (self.ElementHeight/2))
		end
	end

	local function AdjustPanel(self)
		if self.KeepMaxSize then
			self.Width = self.ColumnCount * self.ElementWidth + (self.ColumnCount - 1) * self.HSpacing + self.MarginLeft + self.MarginRight
			self.Height = self.RowCount * self.ElementHeight + (self.RowCount - 1) * self.VSpacing + self.MarginTop + self.MarginBottom
		elseif self.AutoSize then
			local i = self.Count

			while i > 0 do
				if self:GetChild(self.ElementPrefix .. i).Visible then
					break
				end
				i = i - 1
			end

			local row
			local column

			if self.Orientation == Orientation.HORIZONTAL then
				row = ceil(i / self.ColumnCount)
				column = row == 1 and i or self.ColumnCount
			else
				column = ceil(i / self.RowCount)
				row = column == 1 and i or self.RowCount
			end

			self.Width = column * self.ElementWidth + (column - 1) * self.HSpacing + self.MarginLeft + self.MarginRight
			self.Height = row * self.ElementHeight + (row - 1) * self.VSpacing + self.MarginTop + self.MarginBottom
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

				self.__ElementPanel_Count = i - 1
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

				self.__ElementPanel_Count = i
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
			@desc Element is an accessor to the IFElementPanel's elements, used like object.Element[i].Prop = value
		]======]

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function Element(self, elementPanel)
			self.__ElementPanel = elementPanel
	    end

		------------------------------------------------------
		-- __index
		------------------------------------------------------
		function __index(self, index)
			self = self.__ElementPanel

			if type(index) == "number" and index >= 1 and index <= self.ColumnCount * self.RowCount then
				index = floor(index)

				if self:GetChild(self.ElementPrefix .. index) then return self:GetChild(self.ElementPrefix .. index) end

				if self.ElementType then
					Generate(self, index)

					return self:GetChild(self.ElementPrefix .. index)
				else
					return nil
				end
			end
		end
	endclass "Element"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	doc [======[
		@name OnElementAdd
		@type script
		@desc Fired when an element is added
		@param element System.Widget.Region, the new element that added to the panel
	]======]
	script "OnElementAdd"

	doc [======[
		@name OnElementRemove
		@type script
		@desc Fired when an element is removed
		@param element System.Widget.Region, the new element that removed from the panel
	]======]
	script "OnElementRemove"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Get the next element, Overridable
	-- @name Next
	-- @class function
	-- @param key
	-- @return nextFunc
	-- @return self
	-- @return firstKey
	------------------------------------
	doc [======[
		@name Next
		@type method
		@desc Get the next element
		@param key
		@return nextFunc
		@return	self
		@return firstKey
	]======]
	function Next(self, key)
		return nextItem, self, tonumber(key) or 0
	end

	------------------------------------
	--- Each elements to do
	-- @name EachK
	-- @class function
	-- @param key the index to start operation
	-- @param oper
	-- @param ...
	------------------------------------
	function EachK(self, key, oper, ...)
		IFIterator.EachK(self, key, oper, ...)

		AdjustPanel(self)
	end

	------------------------------------
	--- Each elements to do
	-- @name Each
	-- @class function
	-- @param oper
	-- @param ...
	------------------------------------
	function Each(self, oper, ...)
		IFIterator.Each(self, oper, ...)

		AdjustPanel(self)
	end

	------------------------------------
	--- Update the panel size
	-- @name UpdatePanelSize
	-- @type function
	-- @param ...
	-- @return nil
	------------------------------------
	function UpdatePanelSize(self)
		local autoSize = self.AutoSize
		self.AutoSize = true
		AdjustPanel(self)
		self.AutoSize = autoSize
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- ColumnCount
	property "ColumnCount" {
		Get = function(self)
			return self.__ElementPanel_ColumnCount or 99
		end,
		Set = function(self, cnt)
			cnt = floor(cnt)

			if cnt < 1 then
				error("ElementPanel.ColumnCount must be greater than 0.", 2)
			end

			if cnt ~= self.ColumnCount then
				self.__ElementPanel_ColumnCount = cnt

				Reduce(self)
				self:Each(AdjustElement, self)
			end
		end,
		Type = Number,
	}
	-- RowCount
	property "RowCount" {
		Get = function(self)
			return self.__ElementPanel_RowCount or 99
		end,
		Set = function(self, cnt)
			cnt = floor(cnt)

			if cnt < 1 then
				error("ElementPanel.RowCount must be greater than 0.", 2)
			end

			if cnt ~= self.RowCount then
				self.__ElementPanel_RowCount = cnt

				Reduce(self)
				self:Each(AdjustElement, self)
			end
		end,
		Type = Number,
	}
	-- MaxCount
	property "MaxCount" {
		Get = function(self)
			return self.__ElementPanel_ColumnCount * self.__ElementPanel_RowCount
		end,
	}
	-- ElementWidth
	property "ElementWidth" {
		Get = function(self)
			return self.__ElementPanel_Width or 16
		end,
		Set = function(self, cnt)
			cnt = floor(cnt)

			if cnt < 1 then
				error("ElementPanel.ElementWidth must be greater than 0.", 2)
			end

			if cnt ~= self.ElementWidth then
				self.__ElementPanel_Width = cnt

				self:Each(AdjustElement, self)
			end
		end,
		Type = Number,
	}
	-- ElementHeight
	property "ElementHeight" {
		Get = function(self)
			return self.__ElementPanel_Height or 16
		end,
		Set = function(self, cnt)
			cnt = floor(cnt)

			if cnt < 1 then
				error("ElementPanel.ElementHeight must be greater than 0.", 2)
			end

			if cnt ~= self.ElementHeight then
				self.__ElementPanel_Height = cnt

				self:Each(AdjustElement, self)
			end
		end,
		Type = Number,
	}
	-- ElementCount
	property "Count" {
		Get = function(self)
			return self.__ElementPanel_Count or 0
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
					Generate(self, cnt)
				else
					error("ElementType not set.", 2)
				end
			elseif cnt < self.Count then
				Reduce(self, cnt)
			end
		end,
		Type = Number,
	}
	-- Orientation
	property "Orientation" {
		Get = function(self)
			return self.__ElementPanel_Orientation or Orientation.HORIZONTAL
		end,
		Set = function(self, orientation)
			if orientation ~= self.Orientation then
				self.__ElementPanel_Orientation = orientation

				self:Each(AdjustElement, self)
			end
		end,
		Type = Orientation,
	}
	-- ElementType
	property "ElementType" {
		Get = function(self)
			return self.__ElementPanel_Type
		end,
		Set = function(self, elementType)
			if elementType ~= self.__ElementPanel_Type then
				self.__ElementPanel_Type = elementType
			end
		end,
		Type = -Region,
	}
	-- HSpacing
	property "HSpacing" {
		Get = function(self)
			return self.__ElementPanel_HSpacing or 0
		end,
		Set = function(self, spacing)
			if self.__ElementPanel_HSpacing == spacing then return end

			self.__ElementPanel_HSpacing = spacing > 0 and floor(spacing) or 0

			self:Each(AdjustElement, self)
		end,
		Type = Number,
	}
	-- HSpacing
	property "VSpacing" {
		Get = function(self)
			return self.__ElementPanel_VSpacing or 0
		end,
		Set = function(self, spacing)
			if self.__ElementPanel_VSpacing == spacing then return end

			self.__ElementPanel_VSpacing = spacing > 0 and floor(spacing) or 0

			self:Each(AdjustElement, self)
		end,
		Type = Number,
	}
	-- AutoSize
	property "AutoSize" {
		Get = function(self)
			return self.__ElementPanel_AutoSize and true or false
		end,
		Set = function(self, flag)
			self.__ElementPanel_AutoSize = flag
		end,
		Type = Boolean,
	}
	-- MarginTop
	property "MarginTop" {
		Get = function(self)
			return self.__ElementPanel_MarginTop or 0
		end,
		Set = function(self, spacing)
			if self.__ElementPanel_MarginTop == spacing then return end

			self.__ElementPanel_MarginTop = spacing > 0 and floor(spacing) or 0

			self:Each(AdjustElement, self)
		end,
		Type = Number,
	}
	-- MarginBottom
	property "MarginBottom" {
		Get = function(self)
			return self.__ElementPanel_MarginBottom or 0
		end,
		Set = function(self, spacing)
			if self.__ElementPanel_MarginBottom == spacing then return end

			self.__ElementPanel_MarginBottom = spacing > 0 and floor(spacing) or 0

			AdjustPanel(self)
		end,
		Type = Number,
	}
	-- MarginLeft
	property "MarginLeft" {
		Get = function(self)
			return self.__ElementPanel_MarginLeft or 0
		end,
		Set = function(self, spacing)
			if self.__ElementPanel_MarginLeft == spacing then return end

			self.__ElementPanel_MarginLeft = spacing > 0 and floor(spacing) or 0

			self:Each(AdjustElement, self)
		end,
		Type = Number,
	}
	-- MarginRight
	property "MarginRight" {
		Get = function(self)
			return self.__ElementPanel_MarginRight or 0
		end,
		Set = function(self, spacing)
			if self.__ElementPanel_MarginRight == spacing then return end

			self.__ElementPanel_MarginRight = spacing > 0 and floor(spacing) or 0

			AdjustPanel(self)
		end,
		Type = Number,
	}
	-- Element
	property "Element" {
		Get = function(self)
			self.__ElementPanel_Element = self.__ElementPanel_Element or Element(self)
			return self.__ElementPanel_Element
		end,
	}
	-- ElementPrefix
	property "ElementPrefix" {
		Get = function(self)
			return self.__ElementPrefix or "Element"
		end,
		Set = function(self, value)
			self.__ElementPrefix = value
		end,
		Type = System.String + nil,
	}
	-- KeepMaxSize
	property "KeepMaxSize" {
		Get = function(self)
			return self.__KeepMaxSize or false
		end,
		Set = function(self, value)
			self.__KeepMaxSize = value
			return AdjustPanel(self)
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Initialize
	------------------------------------------------------
endinterface "IFElementPanel"