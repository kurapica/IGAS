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
