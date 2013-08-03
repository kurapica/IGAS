-- Author      : Kurapica
-- Create Date : 2013/02/03
-- Change Log  :
--               2013/07/22 ShadowGroupHeader added to refresh the unit panel
--               2013/08/03 Remove the state driver to reduce cost

-- Check Version
local version = 3
if not IGAS:NewAddon("IGAS.Widget.Unit.IFPetGroup", version) then
	return
end

-- Module Event
do
	_IFPetGroup_DeactivateInRaid = _IFPetGroup_DeactivateInRaid or {}
	_IFPetGroup_InRaid = false

	function OnLoad(self)
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
	end

	function GROUP_ROSTER_UPDATE(self)
		IFNoCombatTaskHandler._RegisterNoCombatTask(Update4Raid)
	end

	function Update4Raid()
		if IsInRaid() then
			if not _IFPetGroup_InRaid then
				_IFPetGroup_InRaid = true

				for obj in pairs(_IFPetGroup_DeactivateInRaid) do
					obj.GroupHeader.Activated = false
				end
			end
		else
			if _IFPetGroup_InRaid then
				_IFPetGroup_InRaid = false

				for obj in pairs(_IFPetGroup_DeactivateInRaid) do
					obj.GroupHeader.Activated = obj.Activated
				end
			end
		end
	end
end

interface "IFPetGroup"
	extend "IFGroup"

	doc [======[
		@name IFPetGroup
		@type interface
		@desc IFPetGroup is used to handle the pet group's updating
	]======]

	local function UpdateGroupHeader(self)
		if self.Activated and (not self.DeactivateInRaid or not IsInRaid()) then
			self.GroupHeader.Activated = true
		else
			self.GroupHeader.Activated = false
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

			IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateGroupHeader, self)
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

			IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateGroupHeader, self)
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

				if value then
					_IFPetGroup_DeactivateInRaid[self] = true
				else
					_IFPetGroup_DeactivateInRaid[self] = nil
				end

				IFNoCombatTaskHandler._RegisterNoCombatTask(UpdateGroupHeader, self)
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

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		_IFPetGroup_DeactivateInRaid[self] = nil
	end
endinterface "IFPetGroup"