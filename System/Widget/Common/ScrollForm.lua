-- Author      : Kurapica
-- Create Date : 8/22/2008 23:25
-- ChangeLog   :
--              1/04/2009 the Container's Height can't be less then the frame
--              2010/02/16 Remove the back
--              2010/02/22 Add FixHeight to Container
--				2011/03/13 Recode as class
--              2013/02/04 Recode

-- Check Version
local version = 8
if not IGAS:NewAddon("IGAS.Widget.ScrollForm", version) then
	return
end

class "ScrollForm"
	inherit "ScrollFrame"

	doc [======[
		@name ScrollForm
		@type class
		@desc ScrollForm is used as a scrollable container
	]======]

	class "Container"
		inherit "Frame"

		doc [======[
			@name Container
			@type class
			@desc The container used for scroll form
		]======]

		local function ConvertPos(point)
			if strfind(strupper(point), "BOTTOM") then
				return 1
			elseif strfind(strupper(point), "TOP") then
				return -1
			else
				return 0
			end
		end

		local function GetPos(frame, _Frame, _Center)
			local point, relativeTo, relativePoint, xOfs, yOfs
			local dx, dxp

			_Center[frame] = _Center[frame] or 0

			for i = 1, frame:GetNumPoints() do
				point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(i)

				if _Frame[relativeTo] then
					if not _Center[relativeTo] then
						GetPos(relativeTo, _Frame, _Center)
					end

					dx = ConvertPos(point)
					dxp = ConvertPos(relativePoint)

					if dx == -1 or _Center[frame] == 0 then
						_Center[frame] = _Center[relativeTo] + dxp * (relativeTo.Height / 2) - yOfs - dx * (frame.Height / 2)
					end
				end
			end
		end

		local function DoFixHeight(self)
			local _Frame = {}
			local _Center = {}
			local _MaxHeight = 0
			local h

			_Frame[self] = true
			_Center[self] = self.Height / 2

			for i, v in pairs(self:GetChilds()) do
				if v.GetPoint and v.Visible then
					_Frame[v] = true
				end
			end

			for i in pairs(_Frame) do
				if not _Center[i] then
					GetPos(i, _Frame, _Center)
				end
			end

			for i, v in pairs(_Center) do
				if i ~= self then
					h = v + i.Height / 2
					_MaxHeight = (_MaxHeight > h and _MaxHeight) or h
				end
			end

			self.Height = _MaxHeight
		end


		------------------------------------------------------
		-- Script
		------------------------------------------------------

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		doc [======[
			@name UpdateSize
			@type method
			@desc Update the size based on child elements
			@return nil
		]======]
		function UpdateSize(self)
			return DoFixHeight(self)
		end

		------------------------------------------------------
		-- Property
		------------------------------------------------------

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	endclass "Container"

    -- Scripts
    _FrameBackdrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 9,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    }

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name SetScrollChild
		@type method
		@desc Sets the scroll child frame
		@param frame System.Widget.Region
		@return nil
	]======]
	function SetScrollChild(self, frame)
		if not Reflector.ObjectIsClass(frame, System.Widget.Region) then
			frame = nil
		end

		if self.__ScrollChild == frame then
			return
		end

		-- Clear previous scroll child
		if self.__ScrollChild then
			Super.SetScrollChild(self, nil)
			self.__ScrollChild:Dispose()
			self.__ScrollChild = nil
		end

		-- Add new scroll child
		Super.SetScrollChild(self, frame)
		self.__ScrollChild = frame
	end

	doc [======[
		@name GetScrollChild
		@type method
		@desc Gets the scoll child frame
		@return nil
	]======]
	function GetScrollChild(self)
		return self.__ScrollChild
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name ValueStep
		@type property
		@desc the minimum increment between allowed slider values
	]======]
	property "ValueStep" {
		Set = function(self, value)
			if value > 1 then
				self:GetChild("Bar").ValueStep = value
			else
				self:GetChild("Bar").ValueStep = 1
			end
		end,

		Get = function(self)
			return self:GetChild("Bar").ValueStep
		end,

		Type = Number,
	}

	doc [======[
		@name Value
		@type property
		@desc the value representing the current position of the slider thumb
	]======]
	property "Value" {
		Set = function(self, value)
			self:GetChild("Bar").Value = value
		end,

		Get = function(self)
			return self:GetChild("Bar").Value
		end,

		Type = Number,
	}

	doc [======[
		@name ScrollChild
		@type property
		@desc The scroll child frame
	]======]
	property "ScrollChild" {
		Get = function(self)
			return self:GetScrollChild()
		end,
		Set = function(self, value)
			self:SetScrollChild(value)
		end,
		Type = System.Widget.Region + nil,
	}

	------------------------------------------------------
	-- Script handler
	------------------------------------------------------
	local function OnScrollRangeChanged(self, xrange, yrange)
		if ( not yrange ) then
			yrange = self:GetVerticalScrollRange()
		end

		local bar = self:GetChild("Bar")
		local value = bar:GetValue()
		if(value > yrange)
			value = yrange
		end
		bar:SetMinMaxValues(0, yrange)
		bar:SetValue(value)
	end

    local function OnMouseWheel(self, delta)
        local scrollBar = self:GetChild("Bar")
		local minV, maxV = scrollBar:GetMinMaxValues()

        if (delta > 0 ) then
			if scrollBar.Value - (scrollBar.Height / 2) >= minV then
				scrollBar.Value = scrollBar.Value - (scrollBar.Height / 2)
			else
				scrollBar.Value = minV
			end
        else
			if scrollBar.Value + (scrollBar.Height / 2) <= maxV then
				scrollBar.Value = scrollBar.Value + (scrollBar.Height / 2)
			else
				scrollBar.Value = maxV
			end
        end
    end

    local function OnSizeChanged(self)
    	if self.__ScrollChild then

    	end
    end

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		if self.__ScrollChild then
			self.__ScrollChild:Dispose()
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function ScrollForm(self, name, parent)
        self:SetBackdrop(_FrameBackdrop)
		self:SetBackdropColor(0, 0, 0)
		self:SetBackdropBorderColor(0.4, 0.4, 0.4)
        self.MouseWheelEnabled = true
		self.MouseEnabled = true

        local slider = ScrollBar("Bar", self)
        slider:SetMinMaxValues(0,0)
        slider.Value = 0
        slider.ValueStep = 10
        slider.Visible = false

        self.OnScrollRangeChanged = self.OnScrollRangeChanged + OnScrollRangeChanged
        self.OnMouseWheel = self.OnMouseWheel + OnMouseWheel
    end
endclass "ScrollForm"
