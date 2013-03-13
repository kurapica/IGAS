-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 3
if not IGAS:NewAddon("IGAS.Widget.Unit.LevelLabel", version) then
	return
end

class "LevelLabel"
	inherit "FontString"
	extend "IFUnitLevel"

	doc [======[
		@name LevelLabel
		@type class
		@desc The unit level indicator
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name LevelFormat
		@type property
		@desc The level's format like 'Lvl %s', default '%s'
	]======]
	property "LevelFormat" {
		Get = function(self)
			return self.__LevelFormat or "%s"
		end,
		Set = function(self, value)
			self.__LevelFormat = value
		end,
		Type = System.String,
	}
	-- Value
	property "Value" {
		Get = function(self)
			return self.__Value
		end,
		Set = function(self, value)
			self.__Value = value

			if value and value > 0 then
				self.Text = self.LevelFormat:format(value)

				if UnitIsWildBattlePet(self.Unit) or UnitIsBattlePetCompanion(self.Unit) then
					local petLevel = UnitBattlePetLevel(self.Unit)

					self:SetVertexColor(1.0, 0.82, 0.0)
					self.Text = self.LevelFormat:format(petLevel)
				else
					if UnitCanAttack("player", self.Unit) then
						local color = GetQuestDifficultyColor(value)
						self:SetVertexColor(color.r, color.g, color.b)
					else
						self:SetVertexColor(1.0, 0.82, 0.0)
					end
				end
			else
				self.Text = self.LevelFormat:format("???")
				self:SetVertexColor(1.0, 0.82, 0.0)
			end
		end,
		Type = System.Number + nil,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function LevelLabel(self)
		self.DrawLayer = "BORDER"
	end
endclass "LevelLabel"