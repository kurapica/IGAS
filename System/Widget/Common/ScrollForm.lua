-- Author      : Kurapica
-- Create Date : 8/22/2008 23:25
-- ChangeLog   :
--              1/04/2009 the Container's Height can't be less then the frame
--              2010/02/16 Remove the back
--              2010/02/22 Add FixHeight to Container
--				2011/03/13	Recode as class


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

    -- Scripts
    _FrameBackdrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 9,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    }

	local function OnValueChanged(self, value)
        local frame, container = self.Parent, self.Parent:GetChild("Container")
		local viewheight, height = frame.Height, container.Height
		local offset = value

		if viewheight > height then
			offset = 0
		elseif offset > height - viewheight then
			offset = height - viewheight
		end

		container:ClearAllPoints()
		container:SetPoint("TOPLEFT",frame,"TOPLEFT",0,offset)
		container:SetPoint("TOPRIGHT",frame,"TOPRIGHT",-18,offset)
	end

	local OnSizeChanged

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

	local function FixScroll(self)
		self:GetChild("Container").OnSizeChanged = self:GetChild("Container").OnSizeChanged - OnSizeChanged

		if self.__AutoHeight then
			DoFixHeight(self:GetChild("Container"))
		end

		local bar = self:GetChild("Bar")
		local viewheight, height = self.Height, self:GetChild("Container").Height
		local curvalue = bar.Value

		if viewheight >= height then
			if self.__AutoHeight then
				self:GetChild("Container").Height = viewheight
			end
			bar:SetValue(0)
            bar:Disable()
			bar:Hide()
		else
			local maxValue = height - viewheight
            if curvalue > maxValue then curvalue = maxValue end
            bar:SetMinMaxValues(0,maxValue)
			bar:SetValue(curvalue)
            bar:Enable()
			bar:Show()
		end

		self:GetChild("Container").OnSizeChanged = self:GetChild("Container").OnSizeChanged + OnSizeChanged
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

    OnSizeChanged =  function(self)
        return FixScroll(self.Parent)
    end

	local function OnUpdate_Init(self)
		self:FixHeight()
		if self.Container.Height > 0 then
			self.OnUpdate = self.OnUpdate - OnUpdate_Init
		end
	end

	local function OnTimer(self)
		FixScroll(self.Parent)
	end

	local function Container_FixHeight(self)
		self.Parent:FixHeight()
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name FixHeight
		@type method
		@desc Adjust the container's height, using when you add, remove or modify some frames
		@return nil
	]======]
	function FixHeight(self)
		local flg = self.__AutoHeight
		self.__AutoHeight = true
		FixScroll(self)
		self.__AutoHeight = flg
	end

	-- Override Getheight & GetWidth
	function GetHeight(self)
		return self:GetChild("Bar"):GetHeight()
	end

	function GetWidth(self)
		return self:GetChild("Container").Width + 18
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Container
		@type property
		@desc the scrollform's container, using to contain other frames.
	]======]
	property "Container" {
		Get = function(self)
			return self:GetChild("Container")
		end,
	}

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
		@name AutoHeight
		@type property
		@desc true if the height of the container would be auto-adjust
	]======]
	property "AutoHeight" {
		Set = function(self, auto)
			self.__AutoHeight = (auto and true) or false
			if self.__AutoHeight then
				local timer = Timer("AutoTimer", self)
				timer.OnTimer = OnTimer
				timer.Interval = 2
			else
				if self.AutoTimer then
					self.AutoTimer:Dispose()
				end
			end
		end,

		Get = function(self)
			return (self.__AutoHeight and true) or false
		end,

		Type = Boolean,
	}

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

        local container = Frame("Container", self)
        self:SetScrollChild(container)
		container:SetPoint("TOPLEFT",self,"TOPLEFT",0,0)
		container:SetPoint("TOPRIGHT",self,"TOPRIGHT",-18,0)
		container.FixHeight = Container_FixHeight

        self.OnMouseWheel = self.OnMouseWheel + OnMouseWheel
        slider.OnSizeChanged = OnSizeChanged
        slider.OnValueChanged = OnValueChanged
        container.OnSizeChanged = container.OnSizeChanged + OnSizeChanged

		self.__AutoHeight = false

		-- Don't move this code
		slider.Value = 10
		slider.Value = 0

		self.OnUpdate = self.OnUpdate + OnUpdate_Init
    end
endclass "ScrollForm"