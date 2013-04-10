-- Author      : Kurapica
-- Create Date : 2012/07/18
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.RangeChecker", version) then
	return
end

class "RangeChecker"
	inherit "Frame"
	extend "IFRange"

	doc [======[
		@name RangeChecker
		@type class
		@desc The in-range indicator
	]======]

	pi = math.pi
	atan = math.atan

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- InRange
	property "InRange" {
		Set = function(self, value)
			if value then
				self.Parent.Alpha = 1

				self.Visible = false
			else
				self.Parent.Alpha = 0.5

				if self.UseIndicator and (UnitInParty(self.Unit) or UnitInRaid(self.Unit)) then
					self.Visible = true
				else
					self.Visible = false
				end
			end
		end,
	}

	doc [======[
		@name Interval
		@type property
		@desc The refresh interval
	]======]
	property "Interval" {
		Get = function(self)
			return self.__Interval
		end,
		Set = function(self, int)
			if int > 0.1 then
				self.__Interval = int
			else
				self.__Interval = 0.1
			end
		end,
		Type = Number,
	}

	doc [======[
		@name UseIndicator
		@type property
		@desc description
	]======]
	property "UseIndicator" {
		Get = function(self)
			return self.__UseIndicator
		end,
		Set = function(self, value)
			self.__UseIndicator = value
		end,
		Type = Boolean,
	}

	doc [======[
		@name TexturePath
		@type property
		@desc The texture file path for the indicator
	]======]
	property "TexturePath" {
		Get = function(self)
			return self:GetChild("Indicator").TexturePath
		end,
		Set = function(self, value)
			self:GetChild("Indicator").TexturePath = value
		end,
		Type = System.String + nil,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnUpdate(self, elapsed)
		--self.__OnUpdateTimer = (self.__OnUpdateTimer or 0) + elapsed

		--if self.__OnUpdateTimer < self.__Interval then
		--	return
		--end
		
		--self.__OnUpdateTimer = 0

		local unit = self.Unit

		if UnitIsVisible(unit) then
			local tarx, tary = GetPlayerMapPosition(unit)
			local x, y = GetPlayerMapPosition("player")
			local facing = 2 * pi - GetPlayerFacing()
			local rad = 0

			if tarx and tary and x and y then
				self.Alpha = 1

				if tarx >= x then
					if tary < y then
						rad = atan((tarx - x)/(y - tary))
					elseif tary == y then
						rad = pi / 2
					else
						rad = pi - atan((tarx - x)/(tary - y))
					end
				elseif tarx < x then
					if tary > y then
						rad = pi + atan((x - tarx)/(tary - y))
					elseif tary == y then
						rad = pi + pi / 2
					else
						rad = 2 * pi - atan((x - tarx)/(y - tary))
					end
				end

				return self:GetChild("Indicator"):RotateRadian(rad - facing)
			end
		else
			self.Alpha = 0
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function RangeChecker(self)
		self:SetSize(32, 32)
		self.Visible = false
		self.__Interval = 0.1

		local icon = Texture("Indicator", self)
		icon:SetPoint("CENTER")
		icon:SetSize(32, 32)
		self.TexturePath = [[Interface\Minimap\MiniMap-QuestArrow]]

		self.OnUpdate = self.OnUpdate + OnUpdate
	end
endclass "RangeChecker"