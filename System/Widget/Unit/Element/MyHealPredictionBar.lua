-- Author      : Kurapica
-- Create Date : 2013/09/12
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.MyHealPredictionBar", version) then
	return
end

class "MyHealPredictionBar"
	inherit "StatusBar"
	extend "IFMyHealPrediction"

	doc [======[
		@name MyHealPredictionBar
		@type class
		@desc The prediction heal of the player
	]======]

	_MyHealPredictionBarMap = _MyHealPredictionBarMap or setmetatable({}, {__mode = "kv"})

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnSizeChanged(self)
		if _MyHealPredictionBarMap[self] then
			_MyHealPredictionBarMap[self].Size = self.Size
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
		Field = "__HealthBar",
		Set = function(self, value)
			if self.__HealthBar ~= value then
				if self.__HealthBar then
					self.__HealthBar.OnSizeChanged = self.__HealthBar.OnSizeChanged - OnSizeChanged
					_MyHealPredictionBarMap[self.__HealthBar] = nil
				end

				self.__HealthBar = value
				_MyHealPredictionBarMap[value] = self

				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", value.StatusBarTexture, "TOPRIGHT")
				self.FrameLevel = value.FrameLevel + 2
				self.Size = value.Size

				value.OnSizeChanged = value.OnSizeChanged + OnSizeChanged
			end
		end,
		Type = StatusBar,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function MyHealPredictionBar(self)
		self.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]
		self.StatusBarColor = ColorType(0, 0.827, 0.765)
    end
endclass "MyHealPredictionBar"