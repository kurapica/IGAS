-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- NameLabel
-- <br><br>inherit <a href="..\Base\FontString.html">Texture</a> For all methods, properties and scriptTypes
-- @name NameLabel
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.NameLabel", version) then
	return
end

class "NameLabel"
	inherit "FontString"
	extend "IFUnitName" "IFFaction"

	_RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
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
				self.TextColor = _RAID_CLASS_COLORS[select(2, UnitClass(self.Unit))] or _DefaultColor
			end
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- UseTapColor
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
	-- UseSelectionColor
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
	-- UseClassColor
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