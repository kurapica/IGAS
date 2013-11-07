-- Author      : Kurapica
-- Create Date : 2012/08/03
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.AuraPanel", version) then
	return
end

class "AuraPanel"
	inherit "Frame"
	extend "IFElementPanel""IFAura"

	doc [======[
		@name AuraPanel
		@type class
		@desc The aura panel to display buffs or debuffs
	]======]

	_FILTER_LIST = {
		CANCELABLE = true,
		HARMFUL = true,
		HELPFUL = true,
		NOT_CANCELABLE = true,
		PLAYER = true,
		RAID = true,
	}

	local function CheckFilter(...)
		local ret = ""

		for i = 1, select('#', ...) do
			local part = select(i, ...)

			part = part and strtrim(part)

			if _FILTER_LIST[part] then
				if #ret > 0 then
					ret = ret .. "|" .. part
				else
					ret = part
				end
			end
		end

		return ret
	end

	class "AuraIcon"
		inherit "Frame"
		extend "IFCooldownIndicator"

		doc [======[
			@name AuraIcon
			@type class
			@desc The icon to display buff or debuff
		]======]

		_BorderColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
		_BackDrop = {
		    edgeFile = "Interface\\Buttons\\WHITE8x8",
		    edgeSize = 1,
		}

		------------------------------------------------------
		-- Event
		------------------------------------------------------

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		doc [======[
			@name Refresh
			@type method
			@desc Refresh the icon
			@format unit, index[, filter]
			@param unit string, the unit
			@param index number, the aura index
			@param filter string, the filiter token
			@return nil
		]======]
		function Refresh(self, unit, index, filter)
			local name, rank, texture, count, dtype, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff = UnitAura(unit, index, filter)

			if name then
				self.Index = index

				-- Texture
				self.Icon.TexturePath = texture

				-- Count
				if count and count > 1 then
					self.Count.Visible = true
					self.Count.Text = tostring(count)
				else
					self.Count.Visible = false
				end

				-- Stealable
				self.Stealable.Visible = not UnitIsUnit("player", unit) and isStealable

				-- Debuff
				if filter and not filter:find("HELPFUL") then
					self.Overlay.VertexColor = DebuffTypeColor[dtype] or DebuffTypeColor.none
					self.Overlay.Visible = true
				else
					self.Overlay.Visible = false
				end

				if self.Parent.HighLightPlayer then
					if caster == "player" then
						self:SetBackdrop(_BackDrop)
						self:SetBackdropBorderColor(_BorderColor.r, _BorderColor.g, _BorderColor.b)
					else
						self:SetBackdrop(nil)
					end
				else
					self:SetBackdrop(nil)
				end

				-- Remain
				self:OnCooldownUpdate(expires - duration, duration)

				self.Visible = true
			else
				self.Visible = false
			end
		end

		------------------------------------------------------
		-- Property
		------------------------------------------------------
		doc [======[
			@name Index
			@type property
			@desc The aura index
		]======]
		property "Index" { Type = Number }

		------------------------------------------------------
		-- Event Handler
		------------------------------------------------------
		local function UpdateTooltip(self)
			self = IGAS:GetWrapper(self)
			IGAS.GameTooltip:SetUnitAura(self.Parent.Unit, self.Index, self.Parent.Filter)
		end
		local function OnEnter(self)
			if self.Visible then
				IGAS.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
				UpdateTooltip(self)
			end
		end

		local function OnLeave(self)
			IGAS.GameTooltip.Visible = false
		end

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
		function AuraIcon(self, name, parent)
			local icon = Texture("Icon", self, "BORDER")
			icon:SetPoint("TOPLEFT", 1, -1)
			icon:SetPoint("BOTTOMRIGHT", -1, 1)

			local count = FontString("Count", self, "OVERLAY", "NumberFontNormal")
			count:SetPoint("BOTTOMRIGHT", -1, 0)

			local overlay = Texture("Overlay", self, "OVERLAY")
			overlay:SetAllPoints(self)
			overlay.TexturePath = [[Interface\Buttons\UI-Debuff-Overlays]]
			overlay:SetTexCoord(.296875, .5703125, 0, .515625)

			local stealable = Texture("Stealable", self, "OVERLAY")
			stealable.TexturePath = [[Interface\TargetingFrame\UI-TargetingFrame-Stealable]]
			stealable.BlendMode = "ADD"
			stealable:SetPoint("TOPLEFT", -3, 3)
			stealable:SetPoint("BOTTOMRIGHT", 3, -3)

			self.OnEnter = self.OnEnter + OnEnter
			self.OnLeave = self.OnLeave + OnLeave

			IGAS:GetUI(self).UpdateTooltip = UpdateTooltip
		end
	endclass "AuraIcon"

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	function Refresh(self)
		local index = 1
		local i = 1
		local name
		local unit = self.Unit
		local filter = self.Filter

		if unit then
			while i < self.MaxCount do
				if UnitAura(unit, index, filter) then
					if self:CustomFilter(unit, index, filter) then
						self.Element[i]:Refresh(unit, index, filter)
						i = i + 1
					end
				else
					break
				end

				index = index + 1
			end
		end

		while i <= self.Count do
			self.Element[i].Visible = false
			i = i + 1
		end

		self:UpdatePanelSize()
	end

	doc [======[
		@name CustomFilter
		@type method
		@desc The custom filter method, overridable
		@format unit, index[, filter]
		@param unit string, the unit
		@param index number, the aura index
		@param filter string, the filiter token
		@return boolean true if the aura should be shown
	]======]
	function CustomFilter(self, unit, index, filter)
		return true
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Filter
		@type property
		@desc The filter token, CANCELABLE | HARMFUL | HELPFUL | NOT_CANCELABLE | PLAYER | RAID, can be combined with '|'
	]======]
	property "Filter" {
		Get = function(self)
			return self.__AuraPanelFilter
		end,
		Set = function(self, filter)
			if filter then
				filter = CheckFilter(strsplit("|", filter:upper()))

				if #filter == 0 then
					filter = nil
				end
			end

			self.__AuraPanelFilter = filter
		end,
		Type = String + nil,
	}

	doc [======[
		@name HighLightPlayer
		@type class
		@desc Whether should highlight auras that casted by the player
	]======]
	property "HighLightPlayer" {
		Get = function(self)
			return self.__HighLightPlayer or false
		end,
		Set = function(self, value)
			self.__HighLightPlayer = value
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function AuraPanel(self, name, parent)
		self.FrameStrata = "MEDIUM"
		self.AutoSize = true
		self.ColumnCount = 7
		self.RowCount = 6
		self.ElementWidth = 16
		self.ElementHeight = 16
		self.HSpacing = 2
		self.VSpacing = 2
		self.ElementType = AuraIcon
	end
endclass "AuraPanel"