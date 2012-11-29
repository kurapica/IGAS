-- Author      : Kurapica
-- Create Date : 2012/09/01
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Action.ActionButton", version) then
	return
end

-----------------------------------------------
--- ActionButton
-- @type class
-- @name ActionButton
-----------------------------------------------
class "ActionButton"
	inherit "CheckButton"
	extend "IFActionHandler" "IFKeyBinding" "IFCooldownIndicator"

	RANGE_INDICATOR = "●"

	local function UpdateHotKey(self)
		local hotKey = self:GetChild("HotKey")

		if hotKey.Text == RANGE_INDICATOR then
			if self.__InRange == true then
				hotKey:Show()
				hotKey:SetVertexColor(1, 1, 1)
			elseif self.__InRange == false then
				hotKey:Show()
				hotKey:SetVertexColor(1, 0, 0)
			else
				hotKey:Hide()
			end
		else
			hotKey:Show()
			if self.__InRange == false then
				hotKey:SetVertexColor(1, 0, 0)
			else
				hotKey:SetVertexColor(1, 1, 1)
			end
		end
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------
	--- Update the action, must override
	-- @name UpdateAction
	-- @type function
	-- @param kind, target, texture, tooltip
	------------------------------------
	function UpdateAction(self, kind, target, texture, tooltip)
		if self:HasAction() then
			self.NormalTexturePath = [[Interface\Buttons\UI-Quickslot2]]
		else
			self.NormalTexturePath = [[Interface\Buttons\UI-Quickslot]]
		end
	end

	------------------------------------
	--- Set flyoutDirection for action button
	-- @name SetFlyoutDirection
	-- @type function
	-- @param dir
	-- @return nil
	------------------------------------
	function SetFlyoutDirection(self, dir)
		IFActionHandler.SetFlyoutDirection(self, dir)

		dir = self:GetAttribute("flyoutDirection")

		dir = dir == "UP" and "TOP"
			or dir == "DOWN" and "BOTTOM"
			or dir

		self:GetChild("FlyoutArrow"):ClearAllPoints()
		local point = dir == "TOP" and "BOTTOM"
							or dir == "BOTTOM" and "TOP"
							or dir == "LEFT" and "RIGHT"
							or dir == "RIGHT" and "LEFT"
		local angle = dir == "TOP" and 0
							or dir == "BOTTOM" and 180
							or dir == "LEFT" and 270
							or dir == "RIGHT" and 90
		self:GetChild("FlyoutArrow"):SetPoint(point, self, dir)
		self:GetChild("FlyoutArrow"):RotateDegree(angle)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Icon
	property "Icon" {
		Get = function(self)
			return self:GetChild("Icon").TexturePath
		end,
		Set = function(self, value)
			self:GetChild("Icon").TexturePath = value
		end,
		Type = System.String + nil,
	}
	-- Count
	property "Count" {
		Get = function(self)
			return self:GetChild("Count").Text
		end,
		Set = function(self, value)
			self:GetChild("Count").Text = tostring(value or "")
		end,
		Type = System.String + System.Number + nil,
	}
	-- Text
	property "Text" {
		Get = function(self)
			return self:GetChild("Name").Text
		end,
		Set = function(self, value)
			self:GetChild("Name").Text = value or ""
		end,
		Type = System.String + nil,
	}
	-- HotKey
	property "HotKey" {
		Get = function(self)
			return self:GetChild("HotKey").Text
		end,
		Set = function(self, value)
			self:GetChild("HotKey").Text = value or RANGE_INDICATOR
			UpdateHotKey(self)
		end,
		Type = System.String + nil,
	}
	-- FlashVisible
	property "FlashVisible" {
		Get = function(self)
			return self:GetChild("Flash").Visible
		end,
		Set = function(self, value)
			self:GetChild("Flash").Visible = value
		end,
	}
	-- FlyoutVisible
	property "FlyoutVisible" {
		Get = function(self)
			return self:GetChild("FlyoutArrow").Visible
		end,
		Set = function(self, value)
			self:GetChild("FlyoutArrow").Visible = value
		end,
		Type = System.Boolean,
	}
	-- Flyouting
	property "Flyouting" {
		Get = function(self)
			return self:GetChild("FlyoutBorder").Visible
		end,
		Set = function(self, value)
			self:GetChild("FlyoutBorder").Visible = value
			self:GetChild("FlyoutBorderShadow").Visible = value
		end,
		Type = System.Boolean,
	}
	-- InRange
	property "InRange" {
		Get = function(self)
			return self.__InRange
		end,
		Set = function(self, value)
			if self.__InRange ~= value then
				self.__InRange = value
				UpdateHotKey(self)
			end
		end,
		Type = System.Boolean+nil,
	}
	-- Usable
	property "Usable" {
		Get = function(self)
			return self.__Usable or false
		end,
		Set = function(self, value)
			if self.__Usable ~= value then
				self.__Usable = value
				if value then
					self:GetChild("Icon"):SetVertexColor(1.0, 1.0, 1.0)
				else
					self:GetChild("Icon"):SetVertexColor(0.4, 0.4, 0.4)
				end
			end
		end,
		Type = System.Boolean,
	}
	-- AutoCastable
	property "AutoCastable" {
		Get = function(self)
			return self.__AutoCastable or false
		end,
		Set = function(self, value)
			if self.AutoCastable ~= value then
				self.__AutoCastable = value
				if value then
					if not self:GetChild("AutoCastable") then
				    	local autoCast = Texture("AutoCastable", self, "OVERLAY")
				    	autoCast.Visible = false
				    	autoCast.TexturePath = [[Interface\Buttons\UI-AutoCastableOverlay]]
				    	autoCast:SetPoint("TOPLEFT", -14, 14)
				    	autoCast:SetPoint("BOTTOMRIGHT", 14, -14)
					end
					self:GetChild("AutoCastable").Visible = true
				else
					if self:GetChild("AutoCastable") then
						self:GetChild("AutoCastable").Visible = false
					end
				end
			end
		end,
		Type = System.Boolean,
	}
	-- AutoCasting
	property "AutoCasting" {
		Get = function(self)
			return self.__AutoCasting or false
		end,
		Set = function(self, value)
			if self.AutoCasting ~= value then
				self.__AutoCasting = value
				if value then
					if not self:GetChild("AutoCastShine") then
				    	local shine = AutoCastShine("AutoCastShine", self)
					end
					self:GetChild("AutoCastShine"):Start()
				else
					if self:GetChild("AutoCastShine") then
						self:GetChild("AutoCastShine"):Stop()
					end
				end
			end
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function ActionButton(name, parent, template)
    	local button
    	if type(template) ~= "string" or strtrim(template) == "" then
    		button = UIObject(name, parent, CreateFrame("CheckButton", name, parent, "SecureActionButtonTemplate"))
    	else
    		if not template:find("SecureActionButtonTemplate") then
    			template = "SecureActionButtonTemplate,"..template
    		end
    		button = UIObject(name, parent, CreateFrame("CheckButton", name, parent, template))
    	end

    	button:ConvertClass(ActionButton)

		button.Height = 36
		button.Width = 36

		-- Button Texture
		--- NormalTexture
		button.NormalTexturePath = [[Interface\Buttons\UI-Quickslot]]
		button.NormalTexture:ClearAllPoints()
		button.NormalTexture:SetPoint("TOPLEFT", -15, 15)
		button.NormalTexture:SetPoint("BOTTOMRIGHT", 15, -15)

		--- PushedTexture
		button.PushedTexturePath = [[Interface\Buttons\UI-Quickslot-Depress]]

		--- HighlightTexture
		button.HighlightTexturePath = [[Interface\Buttons\ButtonHilight-Square]]
		button.HighlightTexture.BlendMode = "Add"

		--- CheckedTexture
		button.CheckedTexturePath = [[Interface\Buttons\CheckButtonHilight]]
		button.CheckedTexture.BlendMode = "Add"

		-- BACKGROUND
		local icon = Texture("Icon", button, "BACKGROUND")
		icon:SetAllPoints(button)

		-- ARTWORK-1
		local flash = Texture("Flash", button, "ARTWORK", nil, 1)
		flash.Visible = false
		flash.TexturePath = [[Interface\Buttons\UI-QuickslotRed]]
		flash:SetAllPoints(button)

		local flyoutBorder = Texture("FlyoutBorder", button, "ARTWORK", nil, 1)
		flyoutBorder.Visible = false
		flyoutBorder.TexturePath = [[Interface\Buttons\ActionBarFlyoutButton]]
		flyoutBorder:SetTexCoord(0.01562500, 0.67187500, 0.39843750, 0.72656250)
		flyoutBorder:SetPoint("TOPLEFT", -3, 3)
		flyoutBorder:SetPoint("BOTTOMRIGHT", 3, -3)

		local flyoutBorderShadow = Texture("FlyoutBorderShadow", button, "ARTWORK", nil, 1)
		flyoutBorderShadow.Visible = false
		flyoutBorderShadow.TexturePath = [[Interface\Buttons\ActionBarFlyoutButton]]
		flyoutBorderShadow:SetTexCoord(0.01562500, 0.76562500, 0.00781250, 0.38281250)
		flyoutBorderShadow:SetPoint("TOPLEFT", -6, 6)
		flyoutBorderShadow:SetPoint("BOTTOMRIGHT", 6, -6)

		-- ARTWORK-2
		local flyoutArrow = Texture("FlyoutArrow", button, "ARTWORK", nil, 2)
		flyoutArrow.Visible = false
		flyoutArrow.TexturePath = [[Interface\Buttons\ActionBarFlyoutButton]]
		flyoutArrow:SetTexCoord(0.62500000, 0.98437500, 0.74218750, 0.82812500)
		flyoutArrow.Width = 23
		flyoutArrow.Height = 11
		flyoutArrow:SetPoint("BOTTOM", button, "TOP")

		local hotKey = FontString("HotKey", button, "ARTWORK", "NumberFontNormalSmallGray", 2)
		hotKey.JustifyH = "Right"
		hotKey.Height = 10
		hotKey:SetPoint("TOPLEFT", 1, -3)
		hotKey:SetPoint("TOPRIGHT", -1, -3)

		local count = FontString("Count", button, "ARTWORK", "NumberFontNormal", 2)
		count.JustifyH = "Right"
		count:SetPoint("BOTTOMRIGHT", -2, 2)

		-- OVERLAY
		local name = FontString("Name", button, "OVERLAY", "GameFontHighlightSmallOutline")
		name.JustifyH = "Center"
		name.Height = 10
		name:SetPoint("BOTTOMLEFT", 0, 2)
		name:SetPoint("BOTTOMRIGHT", 0, 2)

		local border = Texture("Border", button, "OVERLAY")
		border.BlendMode = "Add"
		border.Visible = false
		border.TexturePath = [[Interface\Buttons\UI-ActionButton-Border]]
		border:SetPoint("TOPLEFT", -8, 8)
		border:SetPoint("BOTTOMRIGHT", 8, -8)

		button.__InRange = -1

		return button
    end
endclass "ActionButton"