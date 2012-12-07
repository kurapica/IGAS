-- Author      : Kurapica
-- Create Date : 2012/07/25
-- Change Log  :

-- Check Version
local version = 2
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
	_MinMax = MinMax(0, 100)

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
		_MinMax.max = 100
		status.MinMaxValue = _MinMax
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
	-- IFCooldownStatusAlwaysShow
	property "IFCooldownStatusAlwaysShow" {
		Get = function(self)
			return self.__IFCooldownStatusAlwaysShow
		end,
		Set = function(self, value)
			self.__IFCooldownStatusAlwaysShow = value
		end,
		Type = System.Boolean,
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
			status.__IFCooldownStatusAlwaysShow = self.IFCooldownStatusAlwaysShow

			_MinMax.max = duration
			status.MinMaxValue = _MinMax

			if self.IFCooldownStatusReverse then
				status.Value = 0
			else
				status.Value = duration
			end
			status.Visible = true
		else
			status.__IFCooldownStatus_End = nil
			status.__IFCooldownStatus_Duration = nil

			_MinMax.max = 100
			status.MinMaxValue = _MinMax

			if self.IFCooldownStatusReverse then
				status.value = 100
			else
				status.value = 0
			end

			if not self.IFCooldownStatusAlwaysShow then
				status.Visible = false
			end
		end
	end

	local function OnUpdate(self, elapsed)
		if not self.__IFCooldownStatus_End then return end

		self.__NextTime = (self.__NextTime or 0) + elapsed

		if self.__NextTime >= _Update_Interval then
			self.__NextTime = 0

			if GetTime() >= self.__IFCooldownStatus_End then
				-- Clear status
				self.__IFCooldownStatus_End = nil
				self.__IFCooldownStatus_Duration = nil

				_MinMax.max = 100
				self.MinMaxValue = _MinMax

				if self.__IFCooldownStatusReverse then
					self.value = 100
				else
					self.value = 0
				end

				if not self.__IFCooldownStatusAlwaysShow then
					self.Visible = false
				end
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

		local bar = self:GetChild("CooldownStatus")

		if bar and bar:IsClass("StatusBar") then
			-- pass
		else
			if bar then bar:Dispose() end
			self:SetUpCooldownStatus(StatusBar("CooldownStatus", self))
		end
		if not self.IFCooldownStatusAlwaysShow then
			self:GetChild("CooldownStatus").Visible = false
		end
		self:GetChild("CooldownStatus").OnUpdate = OnUpdate

		self.OnCooldownUpdate = self.OnCooldownUpdate + OnCooldownUpdate
	end
endinterface "IFCooldownStatus"
