-- Author		: Kurapica,zys924
--Change Log	:
--				2010.10.17	Allow set Template for the Form
--				2011/03/13	Recode as class
--              2012.05.13  Property Panel is added
--              2012.06.11  Super class changed

------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Form is using as a base frame to contain other frames. It can move, resize, has a caption, a close button, and a message bar.
-- <br><br>inherit <a href="..\Base\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name Form
-- @class table
-- @field CaptionAlign the caption's align:LEFT, RIGHT, CENTER
-- @field TitleBarColor the title bar's color, default alpha is 0, so make it can't be see
-- @field ShowCloseButton whether the close button is shown
-- @field Caption The text to be displayed at the top of the form.
-- @field Message The text to be displayed at the bottom of the form.
-- @field Position the position of the form' center.
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 11
if not IGAS:NewAddon("IGAS.Widget.Form", version) then
	return
end

class "Form"
	inherit "Frame"
	extend "IFContainer"

	-----------------------------------------------
	--- DockHeader
	-- @type class
	-- @name DockHeader
	-----------------------------------------------
	class "DockHeader"
		inherit "Frame"

		_Form_DockHeader = _Form_DockHeader or Frame("IGAS_FORM_DOCKHEADER")
		_Form_DockHeader.Visible = true

		local function AddReturn(str)
			local i = 1
			local char
			local outStr = ""

			while i <= str:len() do
				char = str:byte(i)

				char = bit.rshift(bit.band(char, 255), 4)

				if char == 14 then
					-- 3 byte
					outStr = outStr .. str:sub(i, i+2) .. "\n"
					i = i + 3
				elseif char >= 12 then
					-- 2 byte
					outStr = outStr .. str:sub(i, i+1) .. "\n"
					i = i + 2
				else
					-- 1 byte
					outStr = outStr .. str:sub(i, i+0) .. "\n"
					i = i + 1
				end
			end

			return outStr
		end

		local function Form_OnHide(self)
			self = self.__DockHeader
			if self.NeedHideForm then
				if self.NeedHideForm == 2 then
					self:GetChild("Name").Text = AddReturn(self.Form.Caption)
					self.Height = self:GetChild("Name"):GetStringHeight() + 6
					self.Width = self:GetChild("Name"):GetStringWidth() + 6
				else
					self:GetChild("Name").Text = self.Form.Caption
					self.Height = self:GetChild("Name"):GetStringHeight() + 18
					self.Width = self:GetChild("Name"):GetStringWidth() + 18
				end

				self.Visible = true
			end
		end

		local function CheckPosition(self, instant)
		    local l, b, w, h = self.Form:GetRect()

			if not l then
				self.NeedHideForm = nil
			else
				if l < 10 then
					self.NeedHideForm = 2

					self:ClearAllPoints()
					self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 0, b + h)
				elseif l + w > GetScreenWidth() - 10 then
					self.NeedHideForm = 2

					self:ClearAllPoints()
					self:SetPoint("TOPRIGHT", UIParent, "BOTTOMRIGHT", 0, b + h)
				elseif b < 10 then
					self.NeedHideForm = 1

					self:ClearAllPoints()
					self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", l, 0)
				elseif b + h > GetScreenHeight() - 10 then
					self.NeedHideForm = 1

					self:ClearAllPoints()
					self:SetPoint("TOPLEFT", UIParent, "TOPLEFT", l, 0)
				else
					self.NeedHideForm = nil
				end
			end

			if self.NeedHideForm then
				if self.Form.Visible then
					if instant then
						self.Form.Visible = false
					else
						RegisterAutoHide(self.Form, 1.5)
					end
				else
					Form_OnHide(self.Form)
				end
			else
				UnregisterAutoHide(self.Form)
			end
		end

		local function Form_OnShow(self)
			self = self.__DockHeader
			self.Visible = false
			CheckPosition(self)
		end

		local function Form_OnPositionChanged(self)
			self = self.__DockHeader
			CheckPosition(self)
		end

		------------------------------------------------------
		-- Script
		------------------------------------------------------

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		function Dispose(self)
			local form = self.Form

			form.OnShow = form.OnShow - Form_OnShow
			form.OnHide = form.OnHide - Form_OnHide
			form.OnPositionChanged = form.OnPositionChanged - Form_OnPositionChanged

			return Super.Dispose(self)
		end

		------------------------------------------------------
		-- Property
		------------------------------------------------------

		------------------------------------------------------
		-- Script Handler
		------------------------------------------------------
		local function OnEnter(self)
			if not InCombatLockdown() then
				self.Form.Visible = true
			end
		end

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function DockHeader(form)
			local dockHeader = Frame(nil, _Form_DockHeader)

			dockHeader.Form = form
			form.__DockHeader = dockHeader

			form.OnShow = form.OnShow + Form_OnShow
			form.OnHide = form.OnHide + Form_OnHide
			form.OnPositionChanged = form.OnPositionChanged + Form_OnPositionChanged

			dockHeader:SetBackdrop(_FrameBackdrop)
			dockHeader:SetBackdropColor(0, 0, 0)
			dockHeader:SetBackdropBorderColor(0.4, 0.4, 0.4)
			dockHeader.Height = 10
			dockHeader.Width = 10
			dockHeader.Visible = false

			local txtName = FontString("Name", dockHeader)
			txtName:SetAllPoints(dockHeader)

			dockHeader.OnEnter = dockHeader.OnEnter + OnEnter

			CheckPosition(dockHeader, true)

			return dockHeader
	    end

	    function __exist(cls, form)
	    	if form.__DockHeader then
	    		return form.__DockHeader
	    	end
	    end
	endclass "DockHeader"

	-- Define Style
    -- Style
    TEMPLATE_CLASSIC = "CLASSIC"
    TEMPLATE_LIGHT = "LIGHT"

    -- Define Block
	enum "FormStyle" {
        TEMPLATE_CLASSIC,
		TEMPLATE_LIGHT,
    }

	-- Backdrop Handlers
	_FrameBackdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 9,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}
	_FrameBackdropTitle = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "",
		tile = true, tileSize = 16, edgeSize = 0,
		insets = { left = 3, right = 3, top = 3, bottom = 0 }
	}
	_FrameBackdropCommon = {
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 }
	}

	-- Event Handlers
	local function frameOnMouseDown(self)
		if not self.Parent.InDesignMode and self.Parent.Movable then
			self.Parent:StartMoving()
		end
	end

	local function frameOnMouseUp(self)
		self.Parent:StopMovingOrSizing()
		self.Parent:Fire("OnPositionChanged")
	end

	local function sizerseOnMouseDown(self)
		if not self.Parent.InDesignMode and self.Parent.Resizable then
			self.Parent:StartSizing("BOTTOMRIGHT")
		end
	end

	local function sizerOnMouseUp(self)
		self.Parent:StopMovingOrSizing()
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the form is moved by cursor
	-- @name Form:OnPositionChanged
	-- @class function
	-- @usage function Form:OnPositionChanged()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnPositionChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Dispose(self)
		if self.__DockHeader then
			self.__DockHeader:Dispose()
		end
		return Super.Dispose(self)
	end

	------------------------------------
	--- Sets the Form's style
	-- @name Form:SetStyle
	-- @class function
	-- @param style the style of the Form : CLASSIC, LIGHT
	-- @usage Form:SetStyle("LIGHT")
	------------------------------------
	function SetStyle(self, style)
		local t

		style = FormStyle[style]

		-- Check Style
		if not style or style == self.__Style then
			return
		end

		-- Change Style
		if style == TEMPLATE_CLASSIC then
			self:SetBackdrop(_FrameBackdropCommon)

			self.Form_Btn_Close:SetPoint("TOPRIGHT", self, "TOPRIGHT", -2, -4)

			self.Form_Caption:SetBackdrop(nil)
			self.Form_Caption:ClearAllPoints()
			self.Form_Caption:SetPoint("TOP", self, "TOP", 0, 12)
			self.Form_Caption.Width = 136
			self.Form_Caption.Height = 36
			self.Form_Caption.Text.JustifyV = "MIDDLE"
			self.Form_Caption.Text.JustifyH = "CENTER"

			self.Form_Caption.Text:SetPoint("LEFT", self.Form_Caption, "LEFT")
			self.Form_Caption.Text:SetPoint("RIGHT", self.Form_Caption, "RIGHT")

			self.Sizer_se:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -8, 8)
			self.Form_StatusBar_Text:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 11, 11)

			local backTexture = Texture("HeaderBack", self.Form_Caption, "BACKGROUND")

			backTexture.TexturePath = [[Interface\DialogFrame\UI-DialogBox-Header]]
			backTexture:SetAllPoints(self.Form_Caption)
			backTexture:SetTexCoord(0.24, 0.76, 0, 0.56)
			backTexture.Visible = true

			if self:GetChild("Form_Caption"):GetChild("Text").Width + 36 > 136 then
				self:GetChild("Form_Caption").Width = self:GetChild("Form_Caption"):GetChild("Text").Width + 36
			else
				self:GetChild("Form_Caption").Width = 136
			end
		elseif style == TEMPLATE_LIGHT then
			self:SetBackdrop(_FrameBackdrop)
			self:SetBackdropColor(0, 0, 0)
			self:SetBackdropBorderColor(0.4, 0.4, 0.4)

			local title = Frame("Form_Caption", self)
			title:ClearAllPoints()
			title:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			title:SetPoint("RIGHT", self, "RIGHT")
			title:SetBackdrop(_FrameBackdropTitle)
			title:SetBackdropColor(1, 0, 0, 0)
			title.Height = 24

			self.Form_Caption.Text:SetPoint("LEFT", self.Form_Caption, "LEFT", 4, 0)
			self.Form_Caption.Text:SetPoint("RIGHT", self.Form_Caption, "RIGHT", -32, 0)

			if title.HeaderBack then
				title.HeaderBack.Visible = false
			end

			local CloseButton = NormalButton("Form_Btn_Close", self)
			CloseButton:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, 0)

			local statusText = FontString("Form_StatusBar_Text", self, "OVERLAY", "GameFontNormal")
			statusText:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 6, 4)

			-- Sizer
			local sizer_se = Button("Sizer_se", self)
			sizer_se:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
		end

		self.__Style = style
	end

	------------------------------------
	--- Gets the Form's style
	-- @name Form:GetStyle
	-- @class function
	-- @return the style of the Form : CLASSIC, LIGHT
	-- @usage Form:GetStyle()
	------------------------------------
	function GetStyle(self)
		return self.__Style or TEMPLATE_LIGHT
	end

	-- SetResizable, Override
	function SetResizable(self, enabled)
		enabled = (enabled and true) or false
		self.Sizer_se.Visible = enabled

		return Super.SetResizable(self, enabled)
	end

	------------------------------------
	--- Update the container's panel's postion
	-- @name Form:UpdatePanelPosition
	-- @class function
	-- @usage Form:UpdatePanelPosition()
	------------------------------------
	function UpdatePanelPosition(self)
		local panel = self.Panel

		panel:ClearAllPoints()
		panel:SetPoint("LEFT", 4, 0)
		panel:SetPoint("RIGHT", -4, 0)
		panel:SetPoint("TOP", self:GetChild("Form_Caption"), "BOTTOM")
		panel:SetPoint("BOTTOM", self:GetChild("Form_StatusBar_Text"), "TOP")
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Style
	property "Style" {
		Set = function(self, style)
			self:SetStyle(style)
		end,

		Get = function(self)
			return self:GetStyle()
		end,

		Type = FormStyle,
	}
	-- CaptionAlign
	property "CaptionAlign" {
		Get = function(self)
			return self:GetChild("Form_Caption"):GetChild("Text").JustifyH
		end,
		Set = function(self, value)
			if self.Style ~= TEMPLATE_CLASSIC then
				self:GetChild("Form_Caption"):GetChild("Text").JustifyH = value
			end
		end,
		Type = JustifyHType,
	}
	-- TitleBarColor
	property "TitleBarColor" {
		Get = function(self)
			return self:GetChild("Form_Caption").BackdropColor
		end,
		Set = function(self, value)
			self:GetChild("Form_Caption").BackdropColor = value
		end,
		Type = ColorType,
	}
	-- HasCloseButton
	property "ShowCloseButton" {
		Get = function(self)
			return self:GetChild("Form_Btn_Close").Visible
		end,
		Set = function(self, value)
			self:GetChild("Form_Btn_Close").Visible = value
		end,
		Type = Boolean,
	}
	-- Caption
	property "Caption" {
		Set = function(self, title)
			self:GetChild("Form_Caption"):GetChild("Text").Text = title

			if self.Style == TEMPLATE_CLASSIC then
				if self:GetChild("Form_Caption"):GetChild("Text").Width + 36 > 136 then
					self:GetChild("Form_Caption").Width =  self:GetChild("Form_Caption"):GetChild("Text").Width + 36
				else
					self:GetChild("Form_Caption").Width = 136
				end
			end
		end,
		Get = function(self)
			return self:GetChild("Form_Caption"):GetChild("Text").Text
		end,
		Type = LocaleString,
	}
	-- Message
	property "Message" {
		Set = function(self, mes)
			self:GetChild("Form_StatusBar_Text").Text = mes
		end,
		Get = function(self)
			return self:GetChild("Form_StatusBar_Text").Text
		end,
		Type = LocaleString,
	}
	-- Position
	property "Position" {
		Set = function(self, pos)
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", self.Parent, "BOTTOMLEFT", pos.x, pos.y)
			self:Fire("OnPositionChanged")
		end,
		Get = function(self)
			return Point(self:GetLeft(), self:GetTop())
		end,
		Type = Point,
	}
	-- DockMode
	property "DockMode" {
		Get = function(self)
			return self.__DockHeader and true or false
		end,
		Set = function(self, value)
			if self.DockMode ~= value then
				if value then
					DockHeader(self)
				else
					self.__DockHeader:Dispose()
				end
			end
		end,
		Type = System.Boolean,
	}

	function Form(name, parent, ...)
		-- New Frame
		local frame = Super(name, parent, ...)

		frame.Width = 400
		frame.Height = 300
		frame.Movable = true
		frame.Resizable = true
		frame.Toplevel = true

		frame:SetPoint("CENTER",parent,"CENTER",0,0)
		frame:SetMinResize(300,200)
        frame:SetBackdrop(_FrameBackdrop)
		frame:SetBackdropColor(0, 0, 0)
		frame:SetBackdropBorderColor(0.4, 0.4, 0.4)

		local title = Frame("Form_Caption", frame)
		title.MouseEnabled = true
		title.Height = 24
		title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
		title:SetPoint("RIGHT", frame, "RIGHT")
		title:SetBackdrop(_FrameBackdropTitle)
		title:SetBackdropColor(1, 0, 0, 0)
		title.OnMouseDown = frameOnMouseDown
		title.OnMouseUp = frameOnMouseUp

		local CloseButton = NormalButton("Form_Btn_Close", frame)
		CloseButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 0)
		CloseButton.FrameLevel = title.FrameLevel + 1
        CloseButton.Style = "CLOSE"

		local titleText = FontString("Text", title, "OVERLAY", "GameFontNormal")
		titleText:SetPoint("LEFT", title, "LEFT", 4, 0)
		titleText:SetPoint("RIGHT", title, "RIGHT", -32, 0)
		titleText:SetPoint("CENTER", title, "CENTER")
		titleText.Height = 24
		titleText.Text = "Form"
		titleText.JustifyV = "MIDDLE"
		titleText.JustifyH = "CENTER"

        local statusText = FontString("Form_StatusBar_Text", frame, "OVERLAY", "GameFontNormal")
        statusText.JustifyH = "LEFT"
        statusText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 4)
        statusText:SetPoint("RIGHT", frame, "RIGHT")
        statusText:SetText("")

		-- Sizer
		local sizer_se = Button("Sizer_se", frame)
		sizer_se.Width = 16
		sizer_se.Height = 16
		sizer_se.MouseEnabled = true
		sizer_se:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
		sizer_se.OnMouseDown = sizerseOnMouseDown
		sizer_se.OnMouseUp = sizerOnMouseUp
		sizer_se.NormalTexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]]
		sizer_se.HighlightTexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight]]
		sizer_se.PushedTexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Down]]

		frame.MouseWheelEnabled = true
		frame.MouseEnabled = true

		return frame
	end
endclass "Form"
