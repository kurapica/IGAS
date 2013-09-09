-- Author      : Kurapica
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 11

if not IGAS:NewAddon("IGAS.Widget.CheckBox", version) then
	return
end

class "CheckBox"
	inherit "Button"

	doc [======[
		@name CheckBox
		@type class
		@desc CheckBox is a widget type using for boolean selection with a label
	]======]

    GameTooltip = IGAS.GameTooltip

	_OnGameTooltip = nil

    local function getAnchors(frame)
        local x, y = frame:GetCenter()
        local xFrom, xTo = "", ""
        local yFrom, yTo = "", ""
        if x < GetScreenWidth() / 3 then
            xFrom, xTo = "LEFT", "RIGHT"
        elseif x > GetScreenWidth() / 3 then
            xFrom, xTo = "RIGHT", "LEFT"
        end
        if y < GetScreenHeight() / 3 then
            yFrom, yTo = "BOTTOM", "TOP"
        elseif y > GetScreenWidth() / 3 then
            yFrom, yTo = "TOP", "BOTTOM"
        end
        local from = yFrom..xFrom
        local to = yTo..xTo
        return (from == "" and "CENTER" or from), (to == "" and "CENTER" or to)
    end

	local function UpdateText(self)
		if self:GetChild("ChkBtn").Checked and type(self.__TrueText) == "string" then
			self.Text = self.__TrueText
		elseif (not self:GetChild("ChkBtn").Checked) and type(self.__FalseText) == "string" then
			self.Text = self.__FalseText
		end
	end

    local function OnClick(self, ...)
        self:GetChild("ChkBtn").Checked = not self:GetChild("ChkBtn").Checked
		UpdateText(self)

        return self:Fire("OnValueChanged", self:GetChild("ChkBtn").Checked)
    end

    local function OnEnter(self)
		GameTooltip:ClearLines()
		GameTooltip:Hide()
		_OnGameTooltip = nil

		if self.__Tooltip then
			_OnGameTooltip = self
			local from, to = getAnchors(self)

			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:ClearAllPoints()
			GameTooltip:SetPoint(from, self, to, 0, 0)
			GameTooltip:SetText(self.__Tooltip)
			self:Fire("OnGameTooltipShow", GameTooltip)
			GameTooltip:Show()
		end
        self:GetHighlightTexture():Show()
    end

    local function OnLeave(self)
		_OnGameTooltip = nil
		GameTooltip:ClearLines()
        GameTooltip:Hide()
        self:GetHighlightTexture():Hide()
    end

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnValueChanged
		@type event
		@desc Run when the checkbox's checking state is changed
		@param checked boolean, true if the checkbox is checked
	]======]
	event "OnValueChanged"

	doc [======[
		@name OnGameTooltipShow
		@type event
		@desc Run when the mouse is over an item, and the tooltip is setted
		@param gameTooltip System.Widget.GameTooltip, the GameTooltip object
	]======]
	event "OnGameTooltipShow"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name SetChecked
		@type method
		@desc Sets the checkbox's checking state
		@param checked boolean, true if set the checkbox to be checked
		@return nil
	]======]
	function SetChecked(self, flag)
		self:GetChild("ChkBtn").Checked = (flag and true) or false
		UpdateText(self)
	end

	doc [======[
		@name GetChecked
		@type method
		@desc  Gets the checkbox's checking state
		@return boolean true if set the checkbox to be checked
	]======]
	function GetChecked(self)
		return self:GetChild("ChkBtn").Checked or false
	end

	doc [======[
		@name SetText
		@type method
		@desc Sets the checkbox's label
		@param text string, the text to be displyed
		@return nil
	]======]
	function SetText(self, text)
		self:GetChild("Text").Text = text
	end

	doc [======[
		@name GetText
		@type method
		@desc Gets the checkbox's label
		@return string the text to be displyed
	]======]
	function GetText(self)
		return self:GetChild("Text").Text
	end

	doc [======[
		@name Enable
		@type method
		@desc Enable the checkbox, make it clickable
		@return nil
	]======]
	function Enable(self)
		self.__UI:Enable()
		self:GetChild("ChkBtn"):Enable()
	end

	doc [======[
		@name Disable
		@type method
		@desc Disable the checkbox, make it un-clickable
		@return nil
	]======]
	function Disable(self)
		self.__UI:Disable()
		self:GetChild("ChkBtn"):Disable()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Checked
		@type property
		@desc whether the CheckBox is checked
	]======]
	property "Checked" {
		Set = "SetChecked",
		Get = "GetChecked",
		Type = Boolean,
	}

	doc [======[
		@name Text
		@type property
		@desc the default text to be displyed
	]======]
	property "Text" {
		Set = function(self, text)
			self:SetText(text)
			self.Width = self:GetChild("Text"):GetStringWidth() + 32
		end,
		Get = "GetText",
		Type = LocaleString,
	}

	doc [======[
		@name TrueText
		@type property
		@desc the text to be displyed when checked if set
	]======]
	property "TrueText" {
		Set = function(self, text)
			self.__TrueText = text
			UpdateText(self)
		end,

		Get = function(self)
			return self.__TrueText
		end,

		Type = LocaleString + nil,
	}

	doc [======[
		@name FalseText
		@type property
		@desc the text to be displyed when un-checked if set
	]======]
	property "FalseText" {
		Set = function(self, text)
			self.__FalseText = text
			UpdateText(self)
		end,

		Get = function(self)
			return self.__FalseText
		end,

		Type = LocaleString + nil,
	}

	doc [======[
		@name Tooltip
		@type property
		@desc the tooltip to be displyed when mouse over
	]======]
	property "Tooltip" {
		Set = function(self, tip)
			self.__Tooltip = tip
			if _OnGameTooltip == self then
				GameTooltip:ClearLines()
				GameTooltip:Hide()
				_OnGameTooltip = nil

				if self.__Tooltip then
					_OnGameTooltip = self
					local from, to = getAnchors(self)

					GameTooltip:SetOwner(self, "ANCHOR_NONE")
					GameTooltip:ClearAllPoints()
					GameTooltip:SetPoint(from, self, to, 0, 0)
					GameTooltip:SetText(self.__Tooltip)
					self:Fire("OnGameTooltipShow", GameTooltip)
					GameTooltip:Show()
				end
			end
		end,

		Get = function(self)
			return self.__Tooltip
		end,

		Type = LocaleString + nil,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function CheckBox(self, name, parent)
        self.Height = 24
        self.Width = 100
        self.MouseEnabled = true

        local chkBtn = CheckButton("ChkBtn", self)
        chkBtn:SetPoint("LEFT", self, "LEFT")
        chkBtn.MouseEnabled = false

		chkBtn.Height = 26
		chkBtn.Width = 26

		chkBtn:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
		chkBtn:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
		chkBtn:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
		chkBtn:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])

        local text = FontString("Text",self,"OVERLAY","GameFontNormal")
        text.JustifyH = "LEFT"
		text.JustifyV = "MIDDLE"
        text:SetPoint("TOP", self, "TOP")
        text:SetPoint("LEFT", chkBtn, "RIGHT")
        text:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
        text.Text = ""

        self:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
        local t = self:GetHighlightTexture()
        t:SetBlendMode("ADD")
        t:SetAllPoints(text)

        self.OnEnter = self.OnEnter + OnEnter
        self.OnLeave = self.OnLeave + OnLeave
        self.OnClick = self.OnClick + OnClick
	end
endclass "CheckBox"
