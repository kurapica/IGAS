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

	-------------------------------------
	-- Shadow SecureGroupHeader
	-- A shadow refresh system based on the SecureGroupPetHeaderTemplate
	-------------------------------------
	class "ShadowGroupHeader"
		inherit "IFGroup.ShadowGroupHeader"

		doc [======[
			@name ShadowGroupHeader
			@type class
			@desc Used to handle the refresh in shadow
		]======]

		------------------------------------------------------
		-- Method
		------------------------------------------------------
		doc [======[
			@name Refresh
			@type method
			@desc The default refresh method
			@return nil
		]======]
		function Refresh(self)
			SecureGroupPetHeader_Update(IGAS:GetUI(self))
		end

		------------------------------------------------------
		-- Constructor
		------------------------------------------------------
		function Constructor(self, name, parent)
			return CreateFrame("Frame", nil, parent, "SecureGroupPetHeaderTemplate")
		end
	endclass "ShadowGroupHeader"

	------------------------------------------------------
	-- Helper functions
	------------------------------------------------------
	local function SecureSetAttribute(self, attr, value)
		IFNoCombatTaskHandler._RegisterNoCombatTask(self.SetAttribute, self, attr, value)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name FilterOnPet
		@type property
		@desc if true, then pet names are used when sorting the list
	]======]
	property "FilterOnPet" {
		Get = function(self)
			return self:GetChild("ShadowGroupHeader"):GetAttribute("filterOnPet") or false
		end,
		Set = function(self, value)
			SecureSetAttribute(self:GetChild("ShadowGroupHeader"), "filterOnPet", value)
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function IFPetGroup(self)
		ShadowGroupHeader("ShadowGroupHeader", self)
	end
endinterface "IFPetGroup"