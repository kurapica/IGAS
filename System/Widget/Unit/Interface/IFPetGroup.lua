-- Author      : Kurapica
-- Create Date : 2013/02/03
-- Change Log  :
--               2013/07/22 ShadowGroupHeader added to refresh the unit panel

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFPetGroup", version) then
	return
end

interface "IFPetGroup"
	extend "IFGroup"

	doc [======[
		@name IFPetGroup
		@type interface
		@desc IFPetGroup is used to handle the pet group's updating
	]======]

	local function UpdateStateDriver(self, flag)
		if flag then
			if not self.__DeactivateStateRegistered then
				self.__DeactivateStateRegistered = true
				self.GroupHeader:RegisterStateDriver("visibility", "[group:raid]hide;show")
			end
		else
			if self.__DeactivateStateRegistered then
				self.__DeactivateStateRegistered = false
				self.GroupHeader:UnregisterStateDriver("visibility")

				self.GroupHeader.Activated = self.Activated
			end
		end
	end

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Activate
		@type method
		@desc Activate the unit panel
		@return nil
	]======]
	function Activate(self)
		if not self.Activated then
			self.__GroupHeaderActivated = true

			if self.DeactivateInRaid then
				IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateStateDriver, self, true)
			end

			IFGroup.Activate(self)
		end
	end

	doc [======[
		@name Deactivate
		@type method
		@desc Deactivate the unit panel
		@return nil
	]======]
	function Deactivate(self)
		if self.Activated then
			self.__GroupHeaderActivated = false

			IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateStateDriver, self, false)

			IFGroup.Deactivate(self)
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Activated
		@type property
		@desc Whether the unit panel is activated
	]======]
	property "Activated" {
		Get = function(self)
			return self.__GroupHeaderActivated or false
		end,
		Set = function(self, value)
			if value then
				self:Activate()
			else
				self:Deactivate()
			end
		end,
		Type = Boolean,
	}

	doc [======[
		@name FilterOnPet
		@type property
		@desc if true, then pet names are used when sorting the list
	]======]
	property "FilterOnPet" {
		Get = function(self)
			return self.GroupHeader:GetAttribute("filterOnPet") or false
		end,
		Set = function(self, value)
			IFNoCombatTaskHandler._RegisterNoCombatTask(self.GroupHeader.SetAttribute, self.GroupHeader, "filterOnPet", value)
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name DeactivateInRaid
		@type property
		@desc description
	]======]
	property "DeactivateInRaid" {
		Get = function(self)
			return self.__DeactivateInRaid or false
		end,
		Set = function(self, value)
			if self.DeactivateInRaid ~= value then
				self.__DeactivateInRaid = value

				if self.Activated then
					IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateStateDriver, self, value)
				end
			end
		end,
		Type = System.Boolean,
	}

	doc [======[
		@name GroupHeader
		@type property
		@desc The group header based on the blizzard's SecureGroupHeader
	]======]
	property "GroupHeader" {
		Get = function(self)
			return self:GetChild("ShadowGroupHeader") or IFGroup.ShadowGroupHeader("ShadowGroupHeader", self, "SecureGroupPetHeaderTemplate")
		end,
	}
endinterface "IFPetGroup"