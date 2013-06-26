-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.HealthBar", version) then
	return
end

_DEBUFF_ABILITIES = {
	["WARRIOR"] = {
	},
	["ROGUE"] = {
	},
	["HUNTER"] = {
	},
	["MAGE"] = {
		Curse = true,
	},
	["DRUID"] = {
		Poison = true,
		Curse = true,
		Magic = true,
	},
	["PALADIN"] = {
		Poison = true,
		Disease = true,
		Magic = true,
	},
	["PRIEST"] = {
		Disease = true,
		Magic = true,
	},
	["SHAMAN"] = {
		Curse = true,
		Magic = true,
	},
	["WARLOCK"] = {
		Magic = true,
	},
	["DEATHKNIGHT"] = {
	},
	["MONK"] = {
		Poison = true,
		Disease = true,
		Magic = true,
	},
}

_DEBUFF_ABLE = _DEBUFF_ABILITIES[select(2, UnitClass('player'))] or {}

_DefaultColor = ColorType(0, 1, 0)
_LowHPColor = ColorType(1, 1, 0)
_FinalColor = ColorType(1, 0, 0)

_RAID_CLASS_COLORS = CopyTable(_G.RAID_CLASS_COLORS)

_DebuffTypeColors = CopyTable(_G.DebuffTypeColor)

function HealthBar_OnStateChanged(self)
	local unit = self.Unit
	if not unit or not UnitExists(unit) then return end

	local value = self.Value
	local color
	local r, g, b
	local min, max = self:GetMinMaxValues()
	if ( (value < min) or (value > max) ) then return end
	if ( (max - min) > 0 ) then
		value = (value - min) / (max - min)
	else
		value = 0
	end

	-- Choose color
	if self.UseDebuffColor then
		if self.HasMagic and _DEBUFF_ABLE['Magic'] then
			color = _DebuffTypeColors.Magic
		elseif self.HasCurse and _DEBUFF_ABLE['Curse'] then
			color = _DebuffTypeColors.Curse
		elseif self.HasDisease and _DEBUFF_ABLE['Disease'] then
			color = _DebuffTypeColors.Disease
		elseif self.HasPoison and _DEBUFF_ABLE['Poison'] then
			color = _DebuffTypeColors.Poison
		end
	end

	if not color and not self.Smooth then
		if value < 0.6 and value >= 0.3 then
			color = _LowHPColor
		elseif value < 0.3 then
			color = _FinalColor
		end
	end

	if not color and self.UseClassColor then
		color = _RAID_CLASS_COLORS[select(2, UnitClass(self.Unit))]
	end

	color = color or _DefaultColor

	if(self.Smooth) then
		r = _FinalColor.r + (color.r - _FinalColor.r) * value
		g = _FinalColor.g + (color.g - _FinalColor.g) * value
		b = _FinalColor.b + (color.b - _FinalColor.b) * value
	else
		r, g, b = color.r, color.g, color.b
	end

	self:SetStatusBarColor(r, g, b)
end

class "HealthBar"
	inherit "StatusBar"
	extend "IFHealth" "IFDebuffState"

	doc [======[
		@name HealthBar
		@type class
		@desc The health bar with debuff state
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		IFHealth.Refresh(self)
		IFDebuffState.Refresh(self)
		HealthBar_OnStateChanged(self)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name UseDebuffColor
		@type property
		@desc Whether use the debuff color
	]======]
	property "UseDebuffColor" {
		Get = function(self)
			return self.__UseDebuffColor or false
		end,
		Set = function(self, value)
			self.__UseDebuffColor = Boolean
			HealthBar_OnStateChanged(self)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name UseClassColor
		@type property
		@desc Whether use the unit's class color
	]======]
	property "UseClassColor" {
		Get = function(self)
			return self.__UseClassColor or false
		end,
		Set = function(self, value)
			self.__UseClassColor = value
			HealthBar_OnStateChanged(self)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name Smooth
		@type property
		@desc Whether smoothing the color changing
	]======]
	property "Smooth" {
		Get = function(self)
			return self.__Smooth or false
		end,
		Set = function(self, value)
			self.__Smooth = value
			HealthBar_OnStateChanged(self)
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function HealthBar(self)
		self.OnStateChanged = self.OnStateChanged + HealthBar_OnStateChanged
		self.OnValueChanged = self.OnValueChanged + HealthBar_OnStateChanged

		HealthBar_OnStateChanged(self)
		self.FrameStrata = "LOW"
	end
endclass "HealthBar"


class "HealthBarFrequent"
	inherit "StatusBar"
	extend "IFHealthFrequent" "IFDebuffState"

	doc [======[
		@name HealthBarFrequent
		@type class
		@desc The frequent health bar with debuff state
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		IFHealthFrequent.Refresh(self)
		IFDebuffState.Refresh(self)
		HealthBar_OnStateChanged(self)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name UseDebuffColor
		@type property
		@desc Whether use the debuff color
	]======]
	property "UseDebuffColor" {
		Get = function(self)
			return self.__UseDebuffColor or false
		end,
		Set = function(self, value)
			self.__UseDebuffColor = Boolean
			HealthBar_OnStateChanged(self)
		end,
		Type = System.Any,
	}

	doc [======[
		@name UseClassColor
		@type property
		@desc Whether use the unit's class color
	]======]
	property "UseClassColor" {
		Get = function(self)
			return self.__UseClassColor or false
		end,
		Set = function(self, value)
			self.__UseClassColor = value
			HealthBar_OnStateChanged(self)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name Smooth
		@type property
		@desc Whether smoothing the color changing
	]======]
	property "Smooth" {
		Get = function(self)
			return self.__Smooth or false
		end,
		Set = function(self, value)
			self.__Smooth = value
			HealthBar_OnStateChanged(self)
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function HealthBarFrequent(self)
		self.OnStateChanged = self.OnStateChanged + HealthBar_OnStateChanged
		self.OnValueChanged = self.OnValueChanged + HealthBar_OnStateChanged

		HealthBar_OnStateChanged(self)
		self.FrameStrata = "LOW"
	end
endclass "HealthBarFrequent"