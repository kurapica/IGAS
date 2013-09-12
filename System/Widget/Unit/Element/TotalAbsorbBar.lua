-- Author      : Kurapica
-- Create Date : 2013/09/12
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.TotalAbsorbBar", version) then
	return
end

class "TotalAbsorbBar"
	inherit "StatusBar"
	extend "IFAbsorb"

	doc [======[
		@name TotalAbsorbBar
		@type class
		@desc The prediction heal of the player
	]======]

	_TotalAbsorbBarMap = _TotalAbsorbBarMap or setmetatable({}, {__mode = "kv"})

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnSizeChanged(self)
		if _TotalAbsorbBarMap[self] then
			_TotalAbsorbBarMap[self].Size = self.Size
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name HealthBar
		@type property
		@desc The target health bar the prediction bar should attach to
	]======]
	property "HealthBar" {
		Storage = "__HealthBar",
		Set = function(self, value)
			if self.__HealthBar ~= value then
				if self.__HealthBar then
					self.__HealthBar.OnSizeChanged = self.__HealthBar.OnSizeChanged - OnSizeChanged
					_TotalAbsorbBarMap[self.__HealthBar] = nil
				end

				self.__HealthBar = value
				_TotalAbsorbBarMap[value] = self

				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", value.StatusBarTexture, "TOPRIGHT")
				self.FrameLevel = value.FrameLevel + 2
				self.Size = value.Size

				self.OverAbsorbGlow:ClearAllPoints()
				self.OverAbsorbGlow:SetPoint("TOPLEFT", value, "TOPRIGHT", -7, 0)
				self.OverAbsorbGlow:SetPoint("BOTTOMLEFT", value, "BOTTOMRIGHT", -7, 0)

				value.OnSizeChanged = value.OnSizeChanged + OnSizeChanged
			end
		end,
		Type = StatusBar,
	}

	property "OverAbsorb" {
		Set = function(self, value)
			self.OverAbsorbGlow.Visible = value
		end,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function TotalAbsorbBar(self)
    	local overAbsorbGlow = Texture("OverAbsorbGlow", self)

    	overAbsorbGlow.BlendMode = "ADD"
    	overAbsorbGlow.TexturePath = [[Interface\RaidFrame\Shield-Overshield]]
    	overAbsorbGlow.Width = 16
    	overAbsorbGlow.Visible = false
    end
endclass "TotalAbsorbBar"