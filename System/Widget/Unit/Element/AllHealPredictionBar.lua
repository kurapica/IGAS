-- Author      : Kurapica
-- Create Date : 2013/09/12
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.AllHealPredictionBar", version) then
	return
end

class "AllHealPredictionBar"
	inherit "StatusBar"
	extend "IFAllHealPrediction"

	doc [======[
		@name AllHealPredictionBar
		@type class
		@desc The prediction heal of the player
	]======]

	_AllHealPredictionBarMap = _AllHealPredictionBarMap or setmetatable({}, {__mode = "kv"})

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnSizeChanged(self)
		if _AllHealPredictionBarMap[self] then
			_AllHealPredictionBarMap[self].Size = self.Size
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
					_AllHealPredictionBarMap[self.__HealthBar] = nil
				end

				self.__HealthBar = value
				_AllHealPredictionBarMap[value] = self

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
    function AllHealPredictionBar(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.StatusBarTexturePath = [[Interface\Tooltips\UI-Tooltip-Background]]
		self.StatusBarColor = ColorType(0, 0.631, 0.557)
    end
endclass "AllHealPredictionBar"