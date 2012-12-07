-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- CastBar
-- <br><br>inherit <a href="..\Base\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name CastBar
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.CastBar", version) then
	return
end

class "CastBar"
	inherit "Frame"
	extend "IFCast" "IFCooldownLabel" "IFCooldownStatus"

	_DELAY_TEMPLATE = FontColor.RED .. "(%.1f)" .. FontColor.CLOSE

	-- Update SafeZone
	local function Status_OnValueChanged(self, value)
		local parent = self.Parent

		if parent.Unit ~= "player" then
			return
		end

		local _, _, _, latencyWorld = GetNetStats()

		if latencyWorld == parent.LatencyWorld then
			-- well, GetNetStats update every 30s, so no need to go on
			return
		end

		parent.LatencyWorld = latencyWorld

		if latencyWorld > 0 and parent.Duration and parent.Duration > 0 then
			parent.SafeZone.Visible = true

			parent.SafeZone.Width = self.Width * latencyWorld / parent.Duration / 1000
		else
			parent.SafeZone.Visible = false
		end
	end

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Custom the label
	-- @name SetUpCooldownLabel
	-- @class function
	-- @param label
	------------------------------------
	function SetUpCooldownLabel(self, label)
		label:SetPoint("RIGHT")
		label.JustifyH = "RIGHT"
		label.FontObject = "TextStatusBarText"
	end

	------------------------------------
	--- Custom the statusbar
	-- @name SetUpCooldownStatus
	-- @class function
	-- @param status
	------------------------------------
	function SetUpCooldownStatus(self, status)
		status:SetPoint("TOPLEFT", self.Icon, "TOPRIGHT")
		status:SetPoint("BOTTOMRIGHT")
		status.StatusBarTexturePath = [[Interface\TargetingFrame\UI-StatusBar]]
		status.FrameStrata = "LOW"
		status.MinMaxValue = MinMax(1, 100)
		status.Layer = "BORDER"

		status.OnValueChanged = status.OnValueChanged + Status_OnValueChanged
	end

	------------------------------------
	--- Fires when unit begins casting a spell
	-- @name Start
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Start(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime, _, _, canInter = UnitCastingInfo(self.Unit)

		if not name then
			self.Alpha = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		self.Duration = endTime - startTime
		self.EndTime = endTime
		self.Icon.TexturePath = texture
		self.Shield.Visible = not canInter
		self.SpellName.Text = text

		-- Init
		self.DelayTime = 0
		self.LatencyWorld = 0
		self.IFCooldownStatusReverse = true

		-- SafeZone
		self.SafeZone:ClearAllPoints()
		self.SafeZone:SetPoint("TOP")
		self.SafeZone:SetPoint("BOTTOM")
		self.SafeZone:SetPoint("RIGHT")
		self.SafeZone.Visible = false

		self:OnCooldownUpdate(startTime, self.Duration)

		self.Alpha = 1
	end

	------------------------------------
	--- Fires when unit's spell cast fails
	-- @name Fail
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Fail(self, spell, rank, lineID, spellID)
		self:OnCooldownUpdate()
		self.Alpha = 0
		self.Duration = 0
	end

	------------------------------------
	--- Fires when unit stops or cancels casting a spell
	-- @name Stop
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Stop(self, spell, rank, lineID, spellID)
		self:OnCooldownUpdate()
		self.Alpha = 0
		self.Duration = 0
	end

	------------------------------------
	--- Fires when unit's spell cast is interrupted
	-- @name Interrupt
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Interrupt(self, spell, rank, lineID, spellID)
		self:OnCooldownUpdate()
		self.Alpha = 0
		self.Duration = 0
	end

	------------------------------------
	--- Fires when unit's spell cast becomes interruptible again
	-- @name Interruptible
	-- @type function
	------------------------------------
	function Interruptible(self)
		self.Shield.Visible = false
	end

	------------------------------------
	--- Fires when unit's spell cast becomes uninterruptible
	-- @name UnInterruptible
	-- @type function
	------------------------------------
	function UnInterruptible(self)
		self.Shield.Visible = true
	end

	------------------------------------
	--- Fires when unit's spell cast is delayed
	-- @name Interrupt
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function Delay(self, spell, rank, lineID, spellID)
		local _, _, text, texture, startTime, endTime = UnitCastingInfo(self.Unit)

		if not startTime or not endTime then return end

		startTime = startTime / 1000
		endTime = endTime / 1000

		local duration = endTime - startTime

		-- Update
		self.LatencyWorld = 0
		self.DelayTime = endTime - self.EndTime
		self.Duration = duration
		self.SpellName.Text = text .. self.DelayFormatString:format(self.DelayTime)

		self:OnCooldownUpdate(startTime, self.Duration)
	end

	------------------------------------
	--- Fires when unit starts channeling a spell
	-- @name ChannelStart
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function ChannelStart(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime, _, canInter = UnitChannelInfo(self.Unit)

		if not name then
			self.Alpha = 0
			self.Duration = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		self.Duration = endTime - startTime
		self.EndTime = endTime
		self.Icon.TexturePath = texture
		self.Shield.Visible = not canInter
		self.SpellName.Text = text

		-- Init
		self.DelayTime = 0
		self.LatencyWorld = 0
		self.IFCooldownStatusReverse = false

		-- SafeZone
		self.SafeZone:ClearAllPoints()
		self.SafeZone:SetPoint("TOP")
		self.SafeZone:SetPoint("BOTTOM")
		self.SafeZone:SetPoint("LEFT", self.Icon, "RIGHT")
		self.SafeZone.Visible = false

		self:OnCooldownUpdate(startTime, self.Duration)

		self.Alpha = 1
	end

	------------------------------------
	--- Fires when unit's channeled spell is interrupted or delayed
	-- @name ChannelUpdate
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function ChannelUpdate(self, spell, rank, lineID, spellID)
		local name, _, text, texture, startTime, endTime = UnitChannelInfo(self.Unit)

		if not name or not startTime or not endTime then
			self:OnCooldownUpdate()
			self.Alpha = 0
			return
		end

		startTime = startTime / 1000
		endTime = endTime / 1000

		local duration = endTime - startTime

		-- Update
		self.LatencyWorld = 0
		self.DelayTime = endTime - self.EndTime
		self.Duration = duration
		if self.DelayTime > 0 then
			self.SpellName.Text = text .. self.DelayFormatString:format(self.DelayTime)
		end
		self:OnCooldownUpdate(startTime, self.Duration)
	end

	------------------------------------
	--- Fires when unit stops or cancels a channeled spell
	-- @name ChannelStop
	-- @type function
	-- @param spell - The name of the spell that's being casted. (string)
	-- @param rank - The rank of the spell that's being casted. (string)
	-- @param lineID - Spell lineID counter. (number)
	-- @param spellID - The id of the spell that's being casted. (number, spellID)
	------------------------------------
	function ChannelStop(self, spell, rank, lineID, spellID)
		self:OnCooldownUpdate()
		self.Alpha = 0
		self.Duration = 0
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- IFCooldownLabelUseDecimal
	property "IFCooldownLabelUseDecimal" {
		Get = function(self) return true end
	}
	-- IFCooldownLabelAutoColor
	property "IFCooldownLabelAutoColor" {
		Get = function(self) return false end
	}
	-- DelayFormatString
	property "DelayFormatString" {
		Get = function(self)
			return self.__DelayFormatString or _DELAY_TEMPLATE
		end,
		Set = function(self, text)
			if text then
				-- Try format
				local ok, ret = pcall(string.format, text, 123.123)

				if not ok or ret == text then
					error("CastBar.DelayFormatString muse be a template like (%.1f).", 2)
				end
			end

			self.__DelayFormatString = text
		end,
		Type = String + nil,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnSizeChanged(self)
		if self.Height > 0 then
			self.Icon.Width = self.Height
			self.SpellName:SetFont(self.SpellName:GetFont(), self.Height * 4 / 7, "OUTLINE")
		end
	end

	local function OnHide(self)
		self:OnCooldownUpdate()
		self.Alpha = 0
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function CastBar(name, parent)
		local frame = Super(name, parent)

		frame.Height = 16
		frame.Width = 200

		-- Icon
		local icon = Texture("Icon", frame, "ARTWORK")
		icon:SetPoint("TOPLEFT")
		icon:SetPoint("BOTTOMLEFT")
		icon.Width = frame.Height

		-- Shield
		local shield = Texture("Shield", frame, "OVERLAY")
		shield:SetPoint("TOPLEFT", icon,"TOPLEFT", -8, 8)
		shield:SetPoint("BOTTOMRIGHT", icon,"BOTTOMRIGHT", 8, -8)
		shield.TexturePath = [[Interface\SpellActivationOverlay\IconAlert]]
		shield:SetTexCoord(0.00781250,0.50781250,0.27734375,0.52734375)
		shield.Visible = false

		-- SpellName
		local text = FontString("SpellName", frame, "ARTWORK", "TextStatusBarText")
		text:SetPoint("LEFT", shield, "RIGHT")
		text.JustifyH = "LEFT"
		text:SetFont(text:GetFont(), frame.Height * 4 / 7, "OUTLINE")

		-- SafeZone
		local safeZone = Texture("SafeZone", frame, "ARTWORK")
		safeZone.Color = ColorType(1, 0, 0)
		safeZone.Visible = false

		frame.OnSizeChanged = frame.OnSizeChanged + OnSizeChanged
		frame.OnHide = frame.OnHide + OnHide

		return frame
	end
endclass "CastBar"