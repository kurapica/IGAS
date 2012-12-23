-- Author      : Kurapica
-- Create Date : 2012/07/22
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- ComboBar
-- @type Class
-- @name ComboBar
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.ComboBar", version) then
	return
end

class "ComboBar"
	inherit "Frame"
	extend "IFComboPoint"

	GameTooltip = _G.GameTooltip
	MAX_COMBO_POINTS = _G.MAX_COMBO_POINTS

	-----------------------------------------------
	--- ComboPoint
	-- @type class
	-- @name ComboPoint
	-----------------------------------------------
	class "ComboPoint"
		inherit "Frame"

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		-- Activated
		property "Activated" {
			Get = function(self)
				return self.__Activated or false
			end,
			Set = function(self, value)
				if self.Activated ~= value then
					self.__Activated = value

					if value then
						self.Glow.Deactivate.Playing = false
						self.Glow.Active.Playing = true
					else
						self.Glow.Active.Playing = false
						self.Glow.Deactivate.Playing = true
					end
				end
			end,
			Type = System.Boolean,
		}

		------------------------------------------------------
		-- Script Handler
		------------------------------------------------------
		local function Active_OnFinished(self)
			self.Parent.Alpha = 1
		end

		local function Deactivate_OnFinished(self)
			self.Parent.Alpha = 0
		end

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
	    function ComboPoint(self)
			self:SetSize(18, 17)

			-- BACKGROUND
			local bg = Texture("Bg", self, "BACKGROUND")
			bg.TexturePath = [[Interface\PlayerFrame\MonkUI]]
			bg:SetTexCoord(0.09375000, 0.17578125, 0.71093750, 0.87500000)
			bg:SetSize(21, 21)
			bg:SetPoint("CENTER")

			-- ARTWORK
			local glow = Texture("Glow", self, "ARTWORK")
			glow.Alpha = 0
			glow.TexturePath = [[Interface\PlayerFrame\MonkUI]]
			glow:SetTexCoord(0.00390625, 0.08593750, 0.71093750, 0.87500000)
			glow:SetSize(21, 21)
			glow:SetPoint("CENTER")

			-- Animation
			local active = AnimationGroup("Active", glow)
			local alpha = Alpha("Alpha", active)
			alpha.Duration = 0.2
			alpha.Order = 1
			alpha.Change = 1

			active.OnFinished = Active_OnFinished

			local deactivate = AnimationGroup("Deactivate", glow)
			alpha = Alpha("Alpha", deactivate)
			alpha.Duration = 0.3
			alpha.Order = 1
			alpha.Change = -1

			deactivate.OnFinished = Deactivate_OnFinished
	    end
	endclass "ComboPoint"

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Value
	property "Value" {
		Get = function(self)
			return self.__Value
		end,
		Set = function(self, value)
			if self.__Value ~= value then
				for  i = 1, MAX_COMBO_POINTS do
					self[i].Activated = i <= value
				end

				self.__Value = value
			end
		end,
		Type = System.Number,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function ComboBar(self, name, parent)
		self.__Value = 0

		self.FrameStrata = "LOW"
		self.Toplevel = true
		self:SetSize(136, 20)

		-- ComboPoint
		local prev

		for i = 1, MAX_COMBO_POINTS do
			local light = ComboPoint("ComboPoint"..i, self)

			if i == 1 then
				light:SetPoint("LEFT", (self.Width - light.Width * 5 - 6 * 3) / 2, 1)
			else
				light:SetPoint("LEFT", prev, "RIGHT", 5, 0)
			end

			prev = light
			self[i] = light
		end
	end
endclass "ComboBar"