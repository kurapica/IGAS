-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :
--               2013/06/28 Refresh when the LevelFormat is changed

-- Check Version
local version = 4
if not IGAS:NewAddon("IGAS.Widget.Unit.LevelLabel", version) then
	return
end

__Doc__[[The unit level indicator]]
class "LevelLabel"
	inherit "FontString"
	extend "IFUnitLevel"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	__Doc__[[The level's format like 'Lvl %s', default '%s']]
	property "LevelFormat" {
		Get = function(self)
			return self.__LevelFormat or "%s"
		end,
		Set = function(self, value)
			self.__LevelFormat = value

			self:Refresh()
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
	function LevelLabel(self, name, parent, ...)
		Super(self, name, parent, ...)

		self.DrawLayer = "BORDER"
	end
endclass "LevelLabel"