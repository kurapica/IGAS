-- Author      : Kurapica
-- Create Date : 2012/07/25
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFCooldownStatus", version) then
	return
end

----------------------------------------------------------
--- IFCooldownStatus
-- @type Interface
-- @name IFCooldownStatus
----------------------------------------------------------
interface "IFCooldownStatus"
	extend "IFCooldown"

	_Update_Interval = 0.02

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------
	--- Custom the statusbar
	-- @name SetUpCooldownStatus
	-- @class function
	-- @param status
	------------------------------------
	function SetUpCooldownStatus(self, status)
		status:SetPoint("TOPLEFT", self, "TOPRIGHT")
		status:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT")
		status.Width = 100

		status.StatusBarTexturePath = [[Interface\TargetingFrame\UI-StatusBar]]
		status.MinMaxValue = MinMax(1, 100)
		status.Value = 0
		status.StatusBarColor = ColorType(random(100)/100, random(100)/100, random(100)/100)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- IFCooldownStatusReverse
	property "IFCooldownStatusReverse" {
		Get = function(self)
			return self.__IFCooldownStatusReverse
		end,
		Set = function(self, flag)
			self.__IFCooldownStatusReverse = flag
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	local function OnCooldownUpdate(self, start, duration)
		local status = self:GetChild("CooldownStatus")

		if start and start > 0 and duration and duration > 0 then
			-- Insert to update list
			status.__IFCooldownStatus_End = start + duration
			status.__IFCooldownStatus_Duration = duration
			status.__IFCooldownStatusReverse = self.IFCooldownStatusReverse

			status.MinMaxValue = MinMax(0, duration)

			if self.IFCooldownStatusReverse then
				status.Value = 0
			else
				status.Value = duration
			end
			status.Visible = true
		else
			status.Visible = false
		end
	end

	local function OnUpdate(self, elapsed)
		self.__NextTime = (self.__NextTime or 0) + elapsed

		if self.__NextTime >= _Update_Interval then
			self.__NextTime = 0

			if GetTime() >= self.__IFCooldownStatus_End then
				-- Clear status
				self.Visible = false
			else
				-- Update status
				if self.__IFCooldownStatusReverse then
					self.Value = self.__IFCooldownStatus_Duration - (self.__IFCooldownStatus_End - GetTime())
				else
					self.Value = self.__IFCooldownStatus_End - GetTime()
				end
			end
		end
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFCooldownStatus(self)
		if not Reflector.ObjectIsClass(self, Frame) then return end

		self:SetUpCooldownStatus(StatusBar("CooldownStatus", self))
		self:GetChild("CooldownStatus").Visible = false
		self:GetChild("CooldownStatus").OnUpdate = OnUpdate

		self.OnCooldownUpdate = self.OnCooldownUpdate + OnCooldownUpdate
	end
endinterface "IFCooldownStatus"
