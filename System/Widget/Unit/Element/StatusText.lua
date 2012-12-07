-- Author      : Kurapica
-- Create Date : 2012/11/20
-- Change Log  :

-- Check Version
local version = 3
if not IGAS:NewAddon("IGAS.Widget.Unit.StatusText", version) then
	return
end

-----------------------------------------------
--- StatusText
-- @type class
-- @name StatusText
-----------------------------------------------
class "StatusText"
	inherit "FontString"

	_FloatTemplate = "%.2f"
	abs = math.abs

	local function formatValue(value)
		if abs(value) >= 10^9 then
			return _FloatTemplate:format(value / 10^9) .. "b"
		elseif abs(value) >= 10^6 then
			return _FloatTemplate:format(value / 10^6) .. "m"
		elseif abs(value) >= 10^4 then
			return _FloatTemplate:format(value / 10^3) .. "k"
		else
			return tostring(value)
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the status, overridable
	-- @name RefreshStatus
	-- @type function
	------------------------------------
	function RefreshStatus(self)
		if self.__Value then
			if self.__ShowPercent and self.__Max then
				if self.__Max > 0 then
					self.Text = self.PercentFormat:format(self.__Value * 100 / self.__Max)
				else
					self.Text = self.PercentFormat:format(0)
				end
			elseif self.ShowLost and self.__Max then
				self.Text = formatValue(self.__Value - self.__Max)
			elseif self.ShowMax and self.__Max then
				self.Text = self.MaxFormat:format(formatValue(self.__Value), formatValue(self.__Max))
			else
				self.Text = formatValue(self.__Value)
			end

			if self.Text == "0" then
				self.Text = " "
			end
		else
			self.Text = " "
		end
	end

	------------------------------------
	--- Sets the value of the HealthString
	-- @name HealthString:SetValue
	-- @class function
	-- @param value Value indicating the amount of the HealthString's area to be filled in (between minValue and maxValue, where minValue, maxValue = HealthString:GetMinMaxValues()) (number)
	------------------------------------
	-- SetValue
	function SetValue(self, value)
		if type(value) == "number" and value >= 0 then
			self.__Value = value
			return self:RefreshStatus()
		end
	end
	------------------------------------
	--- Returns the current value of the HealthString
	-- @name HealthString:GetValue
	-- @class function
	-- @return value - Value indicating the amount of the HealthString's area to be filled in (between minValue and maxValue, where minValue, maxValue = HealthString:GetMinMaxValues()) (number)
	------------------------------------
	-- GetValue
	function GetValue(self)
		return self.__Value or 0
	end

	------------------------------------
	--- Sets the minimum and maximum values of the HealthString
	-- @name HealthString:SetMinMaxValues
	-- @class function
	-- @param minValue Lower boundary for values represented on the HealthString (number)
	-- @param maxValue Upper boundary for values represented on the HealthString (number)
	------------------------------------
	-- SetMinMaxValues
	function SetMinMaxValues(self, min, max)
		self.__Min, self.__Max = min, max
		return self:RefreshStatus()
	end

	------------------------------------
	--- Returns the minimum and maximum values of the HealthString
	-- @name HealthString:GetMinMaxValues
	-- @class function
	-- @return minValue - Lower boundary for values represented on the HealthString (number)
	-- @return maxValue - Upper boundary for values represented on the HealthString (number)
	------------------------------------
	-- GetMinMaxValues
	function GetMinMaxValues(self)
		return self.__Min, self.__Max
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- MinMaxValue
	property "MinMaxValue" {
		Get = function(self)
			return MinMax(self:GetMinMaxValues())
		end,
		Set = function(self, value)
			self:SetMinMaxValues(value.min, value.max)
		end,
		Type = System.MinMax,
	}
	-- Value
	property "Value" {
		Get = function(self)
			return self:GetValue()
		end,
		Set = function(self, value)
			self:SetValue(value)
		end,
		Type = System.Number,
	}
	-- ShowLost
	property "ShowLost" {
		Get = function(self)
			return self.__ShowLost
		end,
		Set = function(self, value)
			if self.__ShowLost ~= value then
				self.__ShowLost = value
				return self:RefreshStatus()
			end
		end,
		Type = System.Boolean,
	}
	-- ShowMax
	property "ShowMax" {
		Get = function(self)
			return self.__ShowMax
		end,
		Set = function(self, value)
			if self.__ShowMax ~= value then
				self.__ShowMax = value
				return self:RefreshStatus()
			end
		end,
		Type = System.Boolean,
	}
	-- MaxFormat
	property "MaxFormat" {
		Get = function(self)
			return self.__MaxFormat or "%s / %s"
		end,
		Set = function(self, value)
			self.__MaxFormat = value
		end,
		Type = System.String + nil,
	}
	-- ShowPercent
	property "ShowPercent" {
		Get = function(self)
			return self.__ShowPercent
		end,
		Set = function(self, value)
			if self.__ShowPercent ~= value then
				self.__ShowPercent = value
				return self:RefreshStatus()
			end
		end,
		Type = System.Boolean,
	}
	-- PercentFormat
	property "PercentFormat" {
		Get = function(self)
			return self.__PercentFormat or "%d%%"
		end,
		Set = function(self, value)
			self.__PercentFormat = value
		end,
		Type = System.String + nil,
	}

	function StatusText(...)
		local text = Super(...)

		text.FontObject = IGAS.TextStatusBarText

		return text
	end
endclass "StatusText"

------------------------------------------------------
-- HealthText
------------------------------------------------------
class "HealthText"
	inherit "StatusText"
	extend "IFHealth"
endclass "HealthText"

------------------------------------------------------
-- HealthTextFrequent
------------------------------------------------------
class "HealthTextFrequent"
	inherit "StatusText"
	extend "IFHealthFrequent"
endclass "HealthTextFrequent"

------------------------------------------------------
-- PowerText
------------------------------------------------------
class "PowerText"
	inherit "StatusText"
	extend "IFPower"
endclass "PowerText"

------------------------------------------------------
-- PowerTextFrequent
------------------------------------------------------
class "PowerTextFrequent"
	inherit "StatusText"
	extend "IFPowerFrequent"
endclass "PowerTextFrequent"