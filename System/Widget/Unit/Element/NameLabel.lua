-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.NameLabel", version) then
	return
end

class "NameLabel"
	inherit "FontString"
	extend "IFUnitName" "IFFaction"

	doc [======[
		@name NameLabel
		@type class
		@desc The unit name label with faction color settings
	]======]

	_DefaultColor = ColorType(1, 1, 1)

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Refresh(self)
		IFUnitName.Refresh(self)

		-- Handle the text color
		if self.Unit then
			if self.UseTapColor then
				if UnitIsTapped(self.Unit) and not UnitIsTappedByPlayer(self.Unit) and not UnitIsTappedByAllThreatList(self.Unit) then
					return self:SetTextColor(0.5, 0.5, 0.5)
				end
			end

			if self.UseSelectionColor and not UnitIsPlayer(self.Unit) then
				self:SetTextColor(UnitSelectionColor(self.Unit))
			elseif self.UseClassColor then
				self.TextColor = RAID_CLASS_COLORS[select(2, UnitClass(self.Unit))] or _DefaultColor
			end
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name UseTapColor
		@type property
		@desc Whether using the tap color, default false
	]======]
	property "UseTapColor" {
		Get = function(self)
			return self.__UseTapColor
		end,
		Set = function(self, value)
			self.__UseTapColor = value
			self:Refresh()
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name UseSelectionColor
		@type property
		@desc Whether using the selection color, default false
	]======]
	property "UseSelectionColor" {
		Get = function(self)
			return self.__UseSelectionColor
		end,
		Set = function(self, value)
			self.__UseSelectionColor = value
			self:Refresh()
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name UseClassColor
		@type property
		@desc Whether using the class color, default false
	]======]
	property "UseClassColor" {
		Get = function(self)
			return self.__UseClassColor
		end,
		Set = function(self, value)
			self.__UseClassColor = value
			self:Refresh()
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function NameLabel(self)
		self.DrawLayer = "BORDER"
		self.TextColor = _DefaultColor
	end
endclass "NameLabel"