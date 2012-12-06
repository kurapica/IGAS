-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- LevelLabel
-- <br><br>inherit <a href="..\Base\FontString.html">Texture</a> For all methods, properties and scriptTypes
-- @name LevelLabel
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.LevelLabel", version) then
	return
end

class "LevelLabel"
	inherit "FontString"
	extend "IFUnitLevel"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- LevelFormat
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
			else
				self.Text = self.LevelFormat:format("???")
			end
		end,
		Type = System.Number + nil,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function LevelLabel(...)
		local label = Super(...)

		label.DrawLayer = "BORDER"

		return label
	end
endclass "LevelLabel"