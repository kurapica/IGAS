-- Author      : Kurapica
-- Create Date : 2013/09/12
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.HealAbsorbBar", version) then
	return
end

class "HealAbsorbBar"
	inherit "StatusBar"
	extend "IFHealAbsorb"

	doc [======[
		@name HealAbsorbBar
		@type class
		@desc The heal absorb of the unit
	]======]

	_HealAbsorbBarMap = _HealAbsorbBarMap or setmetatable({}, {__mode = "kv"})

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnSizeChanged(self)
		if _HealAbsorbBarMap[self] then
			_HealAbsorbBarMap[self].Size = self.Size
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
					_HealAbsorbBarMap[self.__HealthBar] = nil
				end

				self.__HealthBar = value
				_HealAbsorbBarMap[value] = self

				self:ClearAllPoints()
				self:SetPoint("TOPRIGHT", value.StatusBarTexture, "TOPRIGHT")
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
    function HealAbsorbBar(self)
    end
endclass "HealAbsorbBar"