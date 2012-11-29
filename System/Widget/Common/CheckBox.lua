-- Author      : Kurapica
-- Change Log  :
--				2011/03/13	Recode as class

---------------------------------------------------------------------------------------------------------------------------------------
--- CheckBox is a widget type using for boolean selection with a label.
-- <br><br>inherit <a href="..\Base\Button.html">Button</a> For all methods, properties and scriptTypes
-- @name CheckBox
-- @class table
-- @field Checked whether the checkbox is checked
-- @field Text the text to be displayed for informations
-- @filed TrueText the text to be displayed when the checkbox is checked
-- @field FalseText the text to be displyed when the checkbox is un-checked
---------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 11

if not IGAS:NewAddon("IGAS.Widget.CheckBox", version) then
	return
end

class "CheckBox"
	inherit "Button"

	-- Script
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
		if self.InDesignMode then return end

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
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the checkbox's checking state is changed
	-- @name CheckBox:OnValueChanged
	-- @class function
	-- @param checked true if the checkbox is checked
	-- @usage function CheckBox:OnValueChanged(checked)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnValueChanged"

	------------------------------------
	--- ScriptType, Run when the mouse is over an item, and the tooltip is setted.
	-- @name List:OnGameTooltipShow
	-- @class function
	-- @param GameTooltip the GameTooltip object
	-- @usage function List:OnGameTooltipShow(GameTooltip)<br>
	--    -- do someting like<br>
	--    GameTooltip:AddLine("Version 1")
	-- end
	------------------------------------
	script "OnGameTooltipShow"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Sets the checkbox's checking state
	-- @name CheckBox:SetChecked
	-- @class function
	-- @param checked true if set the checkbox to be checked
	-- @usage CheckBox:SetChecked(true)
	------------------------------------
	function SetChecked(self, flag)
		self:GetChild("ChkBtn").Checked = (flag and true) or false
		UpdateText(self)
	end

	------------------------------------
	--- Gets the checkbox's checking state
	-- @name CheckBox:GetChecked
	-- @class function
	-- @return checked - true if set the checkbox to be checked
	-- @usage CheckBox:GetChecked()
	------------------------------------
	function GetChecked(self)
		return self:GetChild("ChkBtn").Checked or false
	end

	------------------------------------
	--- Sets the checkbox's label
	-- @name CheckBox:SetText
	-- @class function
	-- @param text the text to be displyed
	-- @usage CheckBox:SetText("Enable the addon")
	------------------------------------
	function SetText(self, text)
		self:GetChild("Text").Text = text
	end

	------------------------------------
	--- Gets the checkbox's label
	-- @name CheckBox:GetText
	-- @class function
	-- @return text - the text to be displyed
	-- @usage CheckBox:GetText()
	------------------------------------
	function GetText(self)
		return self:GetChild("Text").Text
	end

	------------------------------------
	--- Enable the checkbox, make it clickable
	-- @name CheckBox:Enable
	-- @class function
	-- @usage CheckBox:Enable()
	------------------------------------
	function Enable(self)
		self.__UI:Enable()
		self:GetChild("ChkBtn"):Enable()
	end

	------------------------------------
	--- Disable the checkbox, make it un-clickable
	-- @name CheckBox:Disable
	-- @class function
	-- @usage CheckBox:Disable()
	------------------------------------
	function Disable(self)
		self.__UI:Disable()
		self:GetChild("ChkBtn"):Disable()
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Checked
	property "Checked" {
		Set = function(self, value)
			self:SetChecked(value)
		end,

		Get = function(self)
			return (self:GetChecked() and true) or false
		end,

		Type = Boolean,
	}
	-- Text
	property "Text" {
		Set = function(self, text)
			self:SetText(text)
			self.Width = self:GetChild("Text"):GetStringWidth() + 32
		end,

		Get = function(self)
			return self:GetText()
		end,

		Type = LocaleString,
	}
	-- TrueText
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
	-- FalseText
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
	-- Tooltip
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
	function CheckBox(name, parent)
		-- New Frame
		local frame = Button(name,parent)

        frame.Height = 24
        frame.Width = 100
        frame.MouseEnabled = true

        local chkBtn = CheckButton("ChkBtn", frame)
        chkBtn:SetPoint("LEFT", frame, "LEFT")
        chkBtn.MouseEnabled = false

		chkBtn.Height = 26
		chkBtn.Width = 26

		chkBtn:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
		chkBtn:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
		chkBtn:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
		chkBtn:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])

        local text = FontString("Text",frame,"OVERLAY","GameFontNormal")
        text.JustifyH = "LEFT"
		text.JustifyV = "MIDDLE"
        text:SetPoint("TOP", frame, "TOP")
        text:SetPoint("LEFT", chkBtn, "RIGHT")
        text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
        text.Text = ""

        frame:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
        local t = frame:GetHighlightTexture()
        t:SetBlendMode("ADD")
        t:SetAllPoints(text)

        frame.OnEnter = frame.OnEnter + OnEnter
        frame.OnLeave = frame.OnLeave + OnLeave
        frame.OnClick = frame.OnClick + OnClick

		return frame
	end
endclass "CheckBox"
