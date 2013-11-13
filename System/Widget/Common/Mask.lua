-- Author      : Kurapica
-- Created Date: 2012/11/17
-- Change Log  :

-- Check Version
local version = 2

if not IGAS:NewAddon("IGAS.Widget.Mask", version) then
	return
end

do
	------------------------------------------------------
	-- Move & Resize
	------------------------------------------------------
	Sleep = Threading.Sleep

	_Mask_Showing = _Mask_Showing or {}

	_SELECTPERCENT = 5
	_FixRange = 3
	_ISMoving = false

	_FixPosing = false
	_PointsPool = {}

	_FixPos = {
		TOP = Frame("IGAS_Mask_FixPos_TOP"),
		BOTTOM = Frame("IGAS_Mask_FixPos_BOTTOM"),
		LEFT = Frame("IGAS_Mask_FixPos_LEFT"),
		RIGHT = Frame("IGAS_Mask_FixPos_RIGHT"),
	}

	for dir, frm in pairs(_FixPos) do
		local txt = Texture("Texture", frm)

		frm.Visible = false
		frm.TopLevel = true
		frm.FrameStrata = "TOOLTIP"

		txt:SetAllPoints(frm)
		txt:SetTexture(1, 1, 1, 1)
	end

	_FixPos.TOP.Height = 2
	_FixPos.BOTTOM.Height = 2
	_FixPos.LEFT.Width = 2
	_FixPos.RIGHT.Width = 2

	function GetPos(frame, point, top, bottom, left, right)
		local x, y = frame:GetCenter()

		if point:find("TOP") then
			y = top or frame:GetTop()
		elseif point:find("BOTTOM") then
			y = bottom or frame:GetBottom()
		end

		if point:find("LEFT") then
			x = left or frame:GetLeft()
		elseif point:find("RIGHT") then
			x = right or frame:GetRight()
		end

		return x, y
	end

	function GetMouseArea(frame)
		local l, b, w, h = frame:GetRect()
		local e = frame:GetEffectiveScale()
		local x, y = GetCursorPosition()

		x, y = x / e, y / e
		x = x - l
		y = y - b

		local ret = ""

		if x >= 0 and x <= w and y >= 0 and y <= h then
			--[[if y <= h / _SELECTPERCENT then
				ret = "BOTTOM"
			elseif y >= (_SELECTPERCENT - 1) * h / _SELECTPERCENT then
				ret = "TOP"
			end

			if x <= w / _SELECTPERCENT then
				ret = ret .. "LEFT"
			elseif x >= (_SELECTPERCENT - 1) * w / _SELECTPERCENT then
				ret = ret .. "RIGHT"
			end--]]

			if y <= 16 and x >= (w - 16) then
				return "BOTTOMRIGHT"
			end
		end

		return ret
	end

	function AutoFixPos(self)
		local near, frm

		_FixPosing = true

		local mark = self

		while _FixPosing do
			Sleep(0.1)

			for dir, posFrm in pairs(_FixPos) do
				posFrm:ClearAllPoints()

				if dir == "TOP" then
					method = "GetTop"
				elseif dir == "BOTTOM" then
					method = "GetBottom"
				elseif dir == "LEFT" then
					method = "GetLeft"
				elseif dir == "RIGHT" then
					method = "GetRight"
				end

				near = nil
				pos = mark[method](mark)

				if not pos then return end

				for frm in pairs(_Mask_Showing) do
					if frm ~= mark then
						if frm.Visible and frm[method](frm) and abs(frm[method](frm) - pos) <= _FixRange then
							if near then
								if dir == "TOP" or dir == "BOTTOM" then
									if frm:GetLeft() < near:GetLeft() then
										near = frm
									end
								else
									if frm:GetTop() > near:GetTop() then
										near = frm
									end
								end
							else
								near = frm
							end
						end
					end
				end

				if near then
					if dir == "TOP" then
						posFrm:SetPoint("BOTTOM", near, "TOP")

						if mark:GetLeft() > near:GetLeft() then
							posFrm:SetPoint("LEFT", near, "LEFT", -16, 0)
						else
							posFrm:SetPoint("LEFT", mark, "LEFT", -16, 0)
						end

						if mark:GetRight() < near:GetRight() then
							posFrm:SetPoint("RIGHT", near, "RIGHT", 16, 0)
						else
							posFrm:SetPoint("RIGHT", mark, "RIGHT", 16, 0)
						end
					elseif dir == "BOTTOM" then
						posFrm:SetPoint("TOP", near, "BOTTOM")

						if mark:GetLeft() > near:GetLeft() then
							posFrm:SetPoint("LEFT", near, "LEFT", -16, 0)
						else
							posFrm:SetPoint("LEFT", mark, "LEFT", -16, 0)
						end

						if mark:GetRight() < near:GetRight() then
							posFrm:SetPoint("RIGHT", near, "RIGHT", 16, 0)
						else
							posFrm:SetPoint("RIGHT", mark, "RIGHT", 16, 0)
						end
					elseif dir == "LEFT" then
						posFrm:SetPoint("RIGHT", near, "LEFT")

						if mark:GetTop() < near:GetTop() then
							posFrm:SetPoint("TOP", near, "TOP", 0, 16)
						else
							posFrm:SetPoint("TOP", mark, "TOP", 0, 16)
						end

						if mark:GetBottom() > near:GetBottom() then
							posFrm:SetPoint("BOTTOM", near, "BOTTOM", 0, -16)
						else
							posFrm:SetPoint("BOTTOM", mark, "BOTTOM", 0, -16)
						end
					elseif dir == "RIGHT" then
						posFrm:SetPoint("LEFT", near, "RIGHT")

						if mark:GetTop() < near:GetTop() then
							posFrm:SetPoint("TOP", near, "TOP", 0, 16)
						else
							posFrm:SetPoint("TOP", mark, "TOP", 0, 16)
						end

						if mark:GetBottom() > near:GetBottom() then
							posFrm:SetPoint("BOTTOM", near, "BOTTOM", 0, -16)
						else
							posFrm:SetPoint("BOTTOM", mark, "BOTTOM", 0, -16)
						end
					end

					posFrm.Near = near
					posFrm.Visible = true
				else
					posFrm.Near = nil
					posFrm.Visible = false
				end
			end
		end

		-- End Operation
		mark:StopMovingOrSizing()

		frm = mark.Owner or mark.Parent

		if frm then
			-- Get Pos
			local top, bottom, left, right

			top = mark:GetTop()
			bottom = mark:GetBottom()
			left = mark:GetLeft()
			right = mark:GetRight()

			if _FixPos["TOP"].Visible then
				top = _FixPos["TOP"].Near:GetTop()
			end

			if _FixPos["BOTTOM"].Visible then
				bottom = _FixPos["BOTTOM"].Near:GetBottom()
			end

			if _FixPos["LEFT"].Visible then
				left = _FixPos["LEFT"].Near:GetLeft()
			end

			if _FixPos["RIGHT"].Visible then
				right = _FixPos["RIGHT"].Near:GetRight()
			end

			for dir, posFrm in pairs(_FixPos) do
				posFrm.Visible = false
				posFrm.Near = nil
				posFrm:ClearAllPoints()
			end

			frm:ClearAllPoints()

			frm.Width = mark.Width
			frm.Height = mark.Height

			for point, detail in pairs(_PointsPool) do
				local x, y = GetPos(mark, point, top, bottom, left, right)
				local rx, ry = GetPos(detail.relativeTo, detail.relativePoint)

				frm:SetPoint(point, detail.relativeTo, detail.relativePoint, x - rx, y - ry)
			end

			wipe(_PointsPool)

			Sleep(0.1) -- Sleep to keep safe
			-- Fire Script
			-- frm:UnBlockEvent("OnPositionChanged", "OnSizeChanged")

			mark:ClearAllPoints()
			mark:SetPoint("BOTTOMLEFT", frm)

			if _ISMoving then
				mark:Fire("OnMoveFinished")
			else
				mark:Fire("OnResizeFinished")
			end
		end
	end

	function Mask_OnMouseDown(self)
		local ret = ""

		local frm = self.Owner or self.Parent

		if not frm or _FixPosing then
			return
		end

		if self.AsResize then
			ret = GetMouseArea(self)
		end

		if not self.AsMove and ret == "" then
			return
		end

		wipe(_PointsPool)

		for i = 1, frm:GetNumPoints() do
			local point, relativeTo, relativePoint, xOffset, yOffset = frm:GetPoint(i)
			_PointsPool[point] = {	point = point,
									relativeTo = relativeTo or IGAS.UIParent,
									relativePoint = relativePoint,
									xOffset = xOffset,
									yOffset = yOffset,}
		end

		--frm:BlockEvent("OnPositionChanged", "OnSizeChanged")

		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", IGAS.UIParent, "BOTTOMLEFT", frm:GetLeft(), frm:GetBottom())
		frm:ClearAllPoints()
		frm:SetAllPoints(self)

		if ret == "" then
			if self.AsMove then
				_ISMoving = true
				self:Fire("OnMoveStarted")
				self:StartMoving()
			else
				return
			end
		else
			_ISMoving = false
			self:Fire("OnResizeStarted")
			self:StartSizing(ret)
		end

		return self:ThreadCall(AutoFixPos)
	end

	function Mask_OnMouseUp(self)
		_FixPosing = false
	end

	------------------------------------------------------
	-- Key Binding
	------------------------------------------------------
	function UpdateBindKey(self, key)
		if key then
			local oldKey = self.BindKey

			key = key:upper()

			if key == "UNKNOWN" or
				key == "LSHIFT" or
				key == "RSHIFT" or
				key == "LCTRL" or
				key == "RCTRL" or
				key == "LALT" or
				key == "RALT" then
				return
			end

			if key == GetBindingKey("SCREENSHOT") then
				Screenshot()
				return
			end

			if key == GetBindingKey("OPENCHAT") then
				if _G.ChatFrameEditBox then
					_G.ChatFrameEditBox:Show()
				end
				return
			end

			if key == "ESCAPE" then
				self.BindKey = nil
				return self:Fire("OnKeyClear", oldKey)
			end

			-- Remap mouse key
			if key == "LEFTBUTTON" then
				key = "BUTTON1"
			elseif key == "RIGHTBUTTON" then
				key = "BUTTON2"
			elseif key == "MIDDLEBUTTON" then
				key = "BUTTON3"
			end

			if IsShiftKeyDown() then
				key = "SHIFT-" .. key
			end
			if IsControlKeyDown() then
				key = "CTRL-" .. key
			end
			if IsAltKeyDown() then
				key = "ALT-" .. key
			end

			self.BindKey = key

			return self:Fire("OnKeySet", key, oldKey)
		end
	end

	function ToShortKey(key)
		if key then
			key = key:upper()
			key = key:gsub(' ', '')
			key = key:gsub('ALT%-', 'A')
			key = key:gsub('CTRL%-', 'C')
			key = key:gsub('SHIFT%-', 'S')
			key = key:gsub('NUMPAD', 'N')

			key = key:gsub('PLUS', '%+')
			key = key:gsub('MINUS', '%-')
			key = key:gsub('MULTIPLY', '%*')
			key = key:gsub('DIVIDE', '%/')

			key = key:gsub('BACKSPACE', 'BS')

			for i = 1, 31 do
				key = key:gsub('BUTTON' .. i, 'B'..i)
			end

			key = key:gsub('CAPSLOCK', 'CP')
			key = key:gsub('CLEAR', 'CL')
			key = key:gsub('DELETE', 'DL')
			key = key:gsub('END', 'EN')
			key = key:gsub('HOME', 'HM')
			key = key:gsub('INSERT', 'IN')
			key = key:gsub('MOUSEWHEELDOWN', 'MD')
			key = key:gsub('MOUSEWHEELUP', 'MU')
			key = key:gsub('NUMLOCK', 'NL')
			key = key:gsub('PAGEDOWN', 'PD')
			key = key:gsub('PAGEUP', 'PU')
			key = key:gsub('SCROLLLOCK', 'SL')
			key = key:gsub('SPACEBAR', 'SP')
			key = key:gsub('SPACE', 'SP')
			key = key:gsub('TAB', 'TB')

			key = key:gsub('DOWNARROW', 'DN')
			key = key:gsub('LEFTARROW', 'LF')
			key = key:gsub('RIGHTARROW', 'RT')
			key = key:gsub('UPARROW', 'UP')

			return key
		end
	end
end

-----------------------------------------------
--- Mask
-- @type class
-- @name Mask
-----------------------------------------------
class "Mask"
	inherit "Button"

	doc [======[
		@name Mask
		@type class
		@desc Mask is used to moving, resizing or key binding for other frames.
	]======]

	_FrameBackdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 8,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	}

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnMoveStarted
		@type event
		@desc Fired when start moving
	]======]
	event "OnMoveStarted"

	doc [======[
		@name OnMoveFinished
		@type event
		@desc Fired when finish moving
	]======]
	event "OnMoveFinished"

	doc [======[
		@name OnResizeStarted
		@type event
		@desc Fired when start resizing
	]======]
	event "OnResizeStarted"

	doc [======[
		@name OnResizeFinished
		@type event
		@desc Fired when finish resizing
	]======]
	event "OnResizeFinished"

	doc [======[
		@name OnKeySet
		@type event
		@desc Fired when binding key is Set
		@param newkey string, the new binding key
		@param oldkey string, the old binding key
	]======]
	event "OnKeySet"

	doc [======[
		@name OnKeyClear
		@type event
		@desc Fired when binding key is clear
		@param oldkey string, the old binding key
	]======]
	event "OnKeyClear"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function SetParent(self, parent)
		Super.SetParent(self, parent)
		if parent then
			self:ClearAllPoints()
			self:SetPoint("BOTTOMLEFT")
			self.Width = parent.Width
			self.Height = parent.Height
		else
			self:ClearAllPoints()
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name AsMove
		@type property
		@desc The mask is used to move parent
	]======]
	property "AsMove" {
		Field = "__AsMove",
		Type = System.Boolean,
	}

	doc [======[
		@name AsResize
		@type property
		@desc The mask is used to resize parent
	]======]
	property "AsResize" {
		Get = function(self)
			return self.TextureSe.Visible
		end,
		Set = function(self, value)
			self.TextureSe.Visible = value
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name AsKeyBind
		@type event
		@desc The mask is used to bind key
	]======]
	property "AsKeyBind" {
		Field = "__AsKeyBind",
		Type = System.Boolean,
	}

	doc [======[
		@name BindKey
		@type event
		@desc The binding key
	]======]
	property "BindKey" {
		Field = "__BindKey",
		Set = function(self, value)
			self.__BindKey = value
			self.Text = ToShortKey(value) or " "
		end,
		Type = System.String + nil,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------
	local function OnShow(self)
		if not self.Parent then
			self.Visible = false
			return
		end
		self.Width = self.Parent.Width
		self.Height = self.Parent.Height

		if self.AsMove or self.AsResize then
			_Mask_Showing[self] = true
		end
	end

	local function OnHide(self)
		_Mask_Showing[self] = nil
	end

	local function OnClick(self, button)
		if self.AsKeyBind then
			return UpdateBindKey(self, button)
		end
	end

	local function OnKeyDown(self, key)
		if self.AsKeyBind then
			return UpdateBindKey(self, key)
		end
	end

	local function OnMouseWheel(self, wheel)
		if self.AsKeyBind then
			if wheel > 0 then
				return UpdateBindKey(self, "MOUSEWHEELUP")
			else
				return UpdateBindKey(self, "MOUSEWHEELDOWN")
			end
		end
	end

	local function OnLeave(self)
		self.KeyboardEnabled = false
	end

	local function OnEnter(self)
		if self.AsKeyBind then
			self.KeyboardEnabled = true
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function Mask(self, name, parent, ...)
    	Super(self, name, parent, ...)

		self.Visible = false

		self:SetPoint("BOTTOMLEFT")

		self:SetNormalFontObject(GameFontNormal)
		self.Text = ""

		self.TopLevel = true
		self.FrameStrata = "TOOLTIP"
		self.Movable = true
		self.Resizable = true
		self.MouseEnabled = true
		self.MouseWheelEnabled = true
		self:RegisterForClicks("anyUp")

		self.Backdrop = _FrameBackdrop
		self.BackdropColor = ColorType(0, 1, 0, 0.4)

		local txtSe = Texture("TextureSe", self)
		txtSe:SetPoint("BOTTOMRIGHT")
		txtSe:SetSize(16, 16)
		txtSe.TexturePath = [[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]]
		txtSe.Visible = false

		-- Move & Resize
		self.OnShow = self.OnShow + OnShow
		self.OnHide = self.OnHide + OnHide

		self.OnMouseDown = self.OnMouseDown + Mask_OnMouseDown
		self.OnMouseUp = self.OnMouseUp + Mask_OnMouseUp

		-- Key Bind
		self.OnClick = self.OnClick + OnClick
		self.OnMouseWheel = self.OnMouseWheel + OnMouseWheel
		self.OnKeyDown = self.OnKeyDown + OnKeyDown
		self.OnEnter = self.OnEnter + OnEnter
		self.OnLeave = self.OnLeave + OnLeave

		self.KeyboardEnabled = false
    end
endclass "Mask"