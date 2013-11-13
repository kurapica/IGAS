-- Author      : Kurapica
-- Create Date : 2012/11/20
-- Change Log  :

-- Check Version
local version = 3
if not IGAS:NewAddon("IGAS.Widget.Unit.StatusText", version) then
	return
end

class "StatusText"
	inherit "FontString"

	doc [======[
		@name StatusText
		@type class
		@desc The fontstring used to display status value
	]======]

	abs = math.abs

	local function formatValue(self, value)
		if abs(value) >= 10^9 then
			return self.ValueFormat:format(value / 10^9) .. "b"
		elseif abs(value) >= 10^6 then
			return self.ValueFormat:format(value / 10^6) .. "m"
		elseif abs(value) >= 10^4 then
			return self.ValueFormat:format(value / 10^3) .. "k"
		else
			return tostring(value)
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name RefreshStatus
		@type method
		@desc Refresh the status, overridable
		@return nil
	]======]
	function RefreshStatus(self)
		if self.__Value then
			if self.__ShowPercent and self.__Max then
				if self.__Max > 0 then
					if self.__Value > self.__Max then
						self.Text = self.PercentFormat:format(100)
					else
						self.Text = self.PercentFormat:format(self.__Value * 100 / self.__Max)
					end
				else
					self.Text = self.PercentFormat:format(0)
				end
			elseif self.ShowLost and self.__Max then
				self.Text = formatValue(self, self.__Value - self.__Max)
			elseif self.ShowMax and self.__Max then
				self.Text = self.MaxFormat:format(formatValue(self, self.__Value), formatValue(self, self.__Max))
			else
				self.Text = formatValue(self, self.__Value)
			end

			if self.Text == "0" then
				self.Text = " "
			end
		else
			self.Text = " "
		end
	end

	doc [======[
		@name SetValue
		@type method
		@desc Sets the value of the fontstring
		@param value number, the value
		@return nil
	]======]
	function SetValue(self, value)
		if type(value) == "number" and value >= 0 then
			self.__Value = value
			return self:RefreshStatus()
		end
	end

	doc [======[
		@name GetValue
		@type method
		@desc Gets the value of the fontstring
		@return number
	]======]
	function GetValue(self)
		return self.__Value or 0
	end

	doc [======[
		@name SetMinMaxValues
		@type method
		@desc Sets the minimum and maximum values for the fontstring
		@param min number, lower boundary for the values
		@param max number, upper boundary for the values
		@return nil
	]======]
	function SetMinMaxValues(self, min, max)
		self.__Min, self.__Max = min, max
		return self:RefreshStatus()
	end

	doc [======[
		@name GetMinMaxValues
		@type method
		@desc Gets the minimum and maximum values
		@return min number, the lower boundary for the values
		@return max number, the upper boundary for the values
	]======]
	function GetMinMaxValues(self)
		return self.__Min, self.__Max
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name ValueFormat
		@type property
		@desc The display value format, default "%.2f"
	]======]
	property "ValueFormat" {
		Get = function(self)
			return self.__ValueFormat or "%.2f"
		end,
		Set = function(self, value)
			self.__ValueFormat = value
		end,
		Type = System.String + nil,
	}

	doc [======[
		@name MinMaxValue
		@type property
		@desc The minimum and maximum values
	]======]
	property "MinMaxValue" {
		Get = function(self)
			return MinMax(self:GetMinMaxValues())
		end,
		Set = function(self, value)
			self:SetMinMaxValues(value.min, value.max)
		end,
		Type = System.MinMax,
	}

	doc [======[
		@name Value
		@type property
		@desc The fontstring's value
	]======]
	property "Value" {
		Get = function(self)
			return self:GetValue()
		end,
		Set = function(self, value)
			self:SetValue(value)
		end,
		Type = System.Number,
	}

	doc [======[
		@name ShowLost
		@type property
		@desc Whether show lost value
	]======]
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

	doc [======[
		@name ShowMax
		@type property
		@desc Whether show the max value
	]======]
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

	doc [======[
		@name MaxFormat
		@type property
		@desc The display format when ShowMax is true, default "%s / %s"
	]======]
	property "MaxFormat" {
		Get = function(self)
			return self.__MaxFormat or "%s / %s"
		end,
		Set = function(self, value)
			self.__MaxFormat = value
		end,
		Type = System.String + nil,
	}

	doc [======[
		@name ShowPercent
		@type property
		@desc Whether show percent format
	]======]
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

	doc [======[
		@name PercentFormat
		@type property
		@desc The display format when ShowPercent is true, default "%d%%"
	]======]
	property "PercentFormat" {
		Get = function(self)
			return self.__PercentFormat or "%d%%"
		end,
		Set = function(self, value)
			self.__PercentFormat = value
		end,
		Type = System.String + nil,
	}

	function StatusText(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.FontObject = IGAS.TextStatusBarText
	end
endclass "StatusText"

class "HealthText"
	inherit "StatusText"
	extend "IFHealth"
	doc [======[
		@name HealthText
		@type class
		@desc The status text for health
	]======]
endclass "HealthText"

class "HealthTextFrequent"
	inherit "StatusText"
	extend "IFHealthFrequent"
	doc [======[
		@name HealthTextFrequent
		@type class
		@desc The status text for frequent health
	]======]
endclass "HealthTextFrequent"

class "PowerText"
	inherit "StatusText"
	extend "IFPower"
	doc [======[
		@name PowerText
		@type class
		@desc The status text for power
	]======]
endclass "PowerText"

class "PowerTextFrequent"
	inherit "StatusText"
	extend "IFPowerFrequent"
	doc [======[
		@name PowerTextFrequent
		@type class
		@desc The status text for frequent power
	]======]
endclass "PowerTextFrequent"