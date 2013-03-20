-- Author      : Kurapica
-- Create Date : 2012/07/02
-- Change Log  :

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.IFUnitElement", version) then
	return
end

------------------------------------------------------
-- Enum
------------------------------------------------------
enum "Classification" {
	"elite",
	"normal",
	"rare",
	"rareelite",
	"worldboss",
}

enum "Role" {
	"DAMAGER",
	"HEALER",
	"NONE",
	"TANK",
}

enum "PowerType" {
	["0"] = "Mana",
	["1"] = "Rage",
	["2"] = "Focus",
	["3"] = "Energy",
	["4"] = "Runic Power",
}

enum "Reaction" {
	["1"] = "Hated",
	["2"] = "Hostile",
	["3"] = "Unfriendly",
	["4"] = "Neutral",
	["5"] = "Friendly",
	["6"] = "Honored",
	["7"] = "Revered",
	["8"] = "Exalted",
}

enum "Sex" {
	["1"] = "Neuter",
	["2"] = "Male",
	["3"] = "Female",
}

interface "IFUnitElement"
	doc [======[
		@name IFUnitElement
		@type interface
		@desc IFUnitElement is the root interface for the unit system, contains several useful property definitions
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	doc [======[
		@name OnUnitChanged
		@type script
		@desc Fired when the object's unit is changed
	]======]
	script "OnUnitChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Refresh
		@type method
		@desc The default Refresh method, overridable
		@return nil
	]======]
	function Refresh(self)
		-- need override
	end

	doc [======[
		@name Activate
		@type method
		@desc Activate the unit element
		@return nil
	]======]
	function Activate(self)
		if self.__IFUnitElement_Deactivated then
			local unit = type(self.__IFUnitElement_Deactivated) == "string" and self.__IFUnitElement_Deactivated or nil
			self.__IFUnitElement_Deactivated = nil
			self.Unit = unit
		end
	end

	doc [======[
		@name Deactivate
		@type method
		@desc Deactivate the unit element
		@return nil
	]======]
	function Deactivate(self)
		if not self.__IFUnitElement_Deactivated then
			local unit = self.Unit
			self.Unit = nil
			self.__IFUnitElement_Deactivated = unit or true
		end
	end
	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Activated
		@type property
		@desc Whether the unit element is activated
	]======]
	property "Activated" {
		Get = function(self)
			return not self.__IFUnitElement_Deactivated
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
		@name Unit
		@type property
		@desc The object's unit
	]======]
	property "Unit" {
		Get = function(self)
			return self.__IFUnitElement_Unit
		end,
		Set = function(self, unit)
			unit = unit and unit:lower()

			if self.__IFUnitElement_Deactivated then
				self.__IFUnitElement_Deactivated = unit or true
			elseif self.__IFUnitElement_Unit ~= unit then
				self.__IFUnitElement_Unit = unit
				self:Fire("OnUnitChanged")
				self:Refresh()
			end
		end,
		Type = String + nil,
	}

	doc [======[
		@name CanInspect
		@type property
		@desc Whether the unit can be inspected
	]======]
	property "CanInspect" {
		Get = function(self)
			return self.Unit and CanInspect(self.Unit) or false
		end,
	}

	doc [======[
		@name CanTrade
		@type property
		@desc Whether the unit can be traded with
	]======]
	property "CanTrade" {
		Get = function(self)
			return self.Unit and UnitCanCooperate("player", self.Unit) and not UnitIsUnit("player", self.Unit) and CheckInteractDistance(self.Unit, 2) or false
		end,
	}

	doc [======[
		@name CanDuel
		@type property
		@desc Whether the unit can be duel with
	]======]
	property "CanDuel" {
		Get = function(self)
			return self.Unit and UnitCanCooperate("player", self.Unit) and not UnitIsUnit("player", self.Unit) and CheckInteractDistance(self.Unit, 3) or false
		end,
	}

	doc [======[
		@name CanFollow
		@type property
		@desc Whether the unit can be followed
	]======]
	property "CanFollow" {
		Get = function(self)
			return self.Unit and UnitCanCooperate("player", self.Unit) and not UnitIsUnit("player", self.Unit) and CheckInteractDistance(self.Unit, 4) or false
		end,
	}

	doc [======[
		@name GuildName
		@type property
		@desc The unit's guild name
	]======]
	property "GuildName" {
		Get = function(self)
			return self.Unit and (select(1, GetGuildInfo(self.Unit))) or ""
		end,
	}

	doc [======[
		@name GuildRankName
		@type property
		@desc The unit's guild rank name
	]======]
	property "GuildRankName" {
		Get = function(self)
			return self.Unit and (select(2, GetGuildInfo(self.Unit))) or ""
		end,
	}

	doc [======[
		@name GuildRankIndex
		@type property
		@desc The unit's guild rank index
	]======]
	property "GuildRankIndex" {
		Get = function(self)
			return self.Unit and (select(3, GetGuildInfo(self.Unit)))
		end,
	}

	doc [======[
		@name Muted
		@type property
		@desc Whether the unit is muted
	]======]
	property "Muted" {
		Get = function(self)
			if not self.Unit then return false end

			local mode
			local inInstance, instanceType = IsInInstance()

			if instanceType == "pvp" or instanceType == "arena" then
				mode = "Battleground"
			elseif IsInRaid() then
				mode = "raid"
			elseif GetNumGroupMembers() > 0 then
				mode = "party"
			end

			return GetMuteStatus(self.Unit, mode)
		end,
	}

	doc [======[
		@name UnitName
		@type property
		@desc The unit's name
	]======]
	property "UnitName" {
		Get = function(self)
			return self.Unit and GetUnitName(self.Unit, true) or ""
		end,
	}

	doc [======[
		@name Speed
		@type property
		@desc The unit's speed
	]======]
	property "Speed" {
		Get = function(self)
			return self.Unit and (select(1, GetUnitSpeed(self.Unit))) or 0
		end,
	}

	doc [======[
		@name GroundSpeed
		@type property
		@desc The unit's ground speed
	]======]
	property "GroundSpeed" {
		Get = function(self)
			return self.Unit and (select(2, GetUnitSpeed(self.Unit))) or 0
		end,
	}

	doc [======[
		@name FlightSpeed
		@type property
		@desc The unit's flight speed
	]======]
	property "FlightSpeed" {
		Get = function(self)
			return self.Unit and (select(3, GetUnitSpeed(self.Unit))) or 0
		end,
	}

	doc [======[
		@name SwimSpeed
		@type property
		@desc The unit's swimming speed
	]======]
	property "SwimSpeed" {
		Get = function(self)
			return self.Unit and (select(4, GetUnitSpeed(self.Unit))) or 0
		end,
	}

	doc [======[
		@name InCombat
		@type property
		@desc Whether the unit is in combat
	]======]
	property "InCombat" {
		Get = function(self)
			return self.Unit and UnitAffectingCombat(self.Unit) or false
		end,
	}

	doc [======[
		@name CanAssist
		@type property
		@desc Whether the unit can be assisted by the player
	]======]
	property "CanAssist" {
		Get = function(self)
			return self.Unit and UnitCanAssist("player", self.Unit) or false
		end,
	}

	doc [======[
		@name CanAttack
		@type property
		@desc Whether the unit can be attacked by the player
	]======]
	property "CanAttack" {
		Get = function(self)
			return self.Unit and UnitCanAttack("player", self.Unit) or false
		end,
	}

	doc [======[
		@name CanCooperate
		@type property
		@desc Whether the unit can be cooperated with
	]======]
	property "CanCooperate" {
		Get = function(self)
			return self.Unit and UnitCanCooperate("player", self.Unit) or false
		end,
	}

	doc [======[
		@name UnitClass
		@type property
		@desc The unit's class name
	]======]
	property "UnitClass" {
		Get = function(self)
			return self.Unit and (select(2, UnitClassBase(self.Unit)))
		end,
	}

	doc [======[
		@name UnitClassLocale
		@type property
		@desc The unit's localization class name
	]======]
	property "UnitClassLocale" {
		Get = function(self)
			return self.Unit and (select(1, UnitClassBase(self.Unit)))
		end,
	}

	doc [======[
		@name Classification
		@type property
		@desc Returns the unit's classification
	]======]
	property "Classification" {
		Get = function(self)
			return self.Unit and UnitClassification(self.Unit)
		end,
	}

	doc [======[
		@name Existed
		@type property
		@desc Whether the unit is existed
	]======]
	property "Existed" {
		Get = function(self)
			return self.Unit and UnitExists(self.Unit) or false
		end,
	}

	doc [======[
		@name Faction
		@type property
		@desc The unit's faction like 'Horde', 'Alliance'
	]======]
	property "Faction" {
		Get = function(self)
			return self.Unit and (select(1, UnitFactionGroup(self.Unit)))
		end,
	}

	doc [======[
		@name FactionLocale
		@type property
		@desc The unit's localization faction
	]======]
	property "FactionLocale" {
		Get = function(self)
			return self.Unit and (select(2, UnitFactionGroup(self.Unit)))
		end,
	}

	doc [======[
		@name GUID
		@type property
		@desc The unit's GUID
	]======]
	property "GUID" {
		Get = function(self)
			return self.Unit and UnitGUID(self.Unit)
		end,
	}

	doc [======[
		@name Role
		@type property
		@desc The unit's role in the group
	]======]
	property "Role" {
		Get = function(self)
			return self.Unit and UnitGroupRolesAssigned(self.Unit)
		end,
	}

	doc [======[
		@name InBattleground
		@type property
		@desc Whether the unit is in the battle ground
	]======]
	property "InBattleground" {
		Get = function(self)
			return self.Unit and UnitInBattleground(self.Unit)
		end,
	}

	doc [======[
		@name InParty
		@type property
		@desc Whether the unit is in the party
	]======]
	property "InParty" {
		Get = function(self)
			return self.Unit and UnitInParty(self.Unit)
		end,
	}

	doc [======[
		@name InRaid
		@type property
		@desc Whether the unit is in the raid
	]======]
	property "InRaid" {
		Get = function(self)
			return self.Unit and UnitInRaid(self.Unit)
		end,
	}

	doc [======[
		@name InRange
		@type property
		@desc Whether the unit is in the range for the player
	]======]
	property "InRange" {
		Get = function(self)
			if self.Existed then
				local inRange, checkedRange = UnitInRange(self.Unit)

				return inRange or not checkedRange
			end
		end,
	}

	doc [======[
		@name IsAFK
		@type property
		@desc Whether the unit is afk
	]======]
	property "IsAFK" {
		Get = function(self)
			return self.Unit and UnitIsAFK(self.Unit)
		end,
	}

	doc [======[
		@name IsCharmed
		@type property
		@desc Whether the unit is charmed
	]======]
	property "IsCharmed" {
		Get = function(self)
			return self.Unit and UnitIsCharmed(self.Unit)
		end,
	}

	doc [======[
		@name IsConnected
		@type property
		@desc Whether the unit is connected
	]======]
	property "IsConnected" {
		Get = function(self)
			return self.Unit and UnitIsConnected(self.Unit) or false
		end,
	}

	doc [======[
		@name IsControlling
		@type property
		@desc Whether the unit is controlling another unit
	]======]
	property "IsControlling" {
		Get = function(self)
			return self.Unit and UnitIsControlling(self.Unit) or false
		end,
	}

	doc [======[
		@name IsDND
		@type property
		@desc Whether the unit is DND (Do Not Disturb)
	]======]
	property "IsDND" {
		Get = function(self)
			return self.Unit and UnitIsDND(self.Unit)
		end,
	}

	doc [======[
		@name IsDead
		@type property
		@desc Whether the unit is dead now
	]======]
	property "IsDead" {
		Get = function(self)
			return self.Unit and UnitIsDead(self.Unit)
		end,
	}

	doc [======[
		@name IsGhost
		@type property
		@desc Whether the unit is a ghost now
	]======]
	property "IsGhost" {
		Get = function(self)
			return self.Unit and UnitIsGhost(self.Unit)
		end,
	}

	doc [======[
		@name IsEnemy
		@type property
		@desc Whether the unit is an enemy to the player
	]======]
	property "IsEnemy" {
		Get = function(self)
			return self.Unit and UnitIsEnemy("player", self.Unit)
		end,
	}

	doc [======[
		@name IsFeignDeath
		@type property
		@desc Whether the unit is feign death
	]======]
	property "IsFeignDeath" {
		Get = function(self)
			return self.Unit and UnitIsFeignDeath(self.Unit)
		end,
	}

	doc [======[
		@name IsFriend
		@type property
		@desc Whether the unit is friend to the player
	]======]
	property "IsFriend" {
		Get = function(self)
			return self.Unit and UnitIsFriend("player", self.Unit)
		end,
	}

	doc [======[
		@name IsPVP
		@type property
		@desc Whether the unit's pvp flag is on
	]======]
	property "IsPVP" {
		Get = function(self)
			return self.Unit and UnitIsPVP(self.Unit)
		end,
	}

	doc [======[
		@name IsPVPFreeForAll
		@type property
		@desc Whether the unit's free for all pvp flag is on
	]======]
	property "IsPVPFreeForAll" {
		Get = function(self)
			return self.Unit and UnitIsPVPFreeForAll(self.Unit)
		end,
	}

	doc [======[
		@name IsPVPSanctuary
		@type property
		@desc Whether the unit is in an pvp sanctuary
	]======]
	property "IsPVPSanctuary" {
		Get = function(self)
			return self.Unit and UnitIsPVPSanctuary(self.Unit)
		end,
	}

	doc [======[
		@name IsGroupLeader
		@type property
		@desc Whether the unit is the group's leader
	]======]
	property "IsGroupLeader" {
		Get = function(self)
			return self.Unit and UnitIsGroupLeader(self.Unit)
		end,
	}

	doc [======[
		@name IsPlayer
		@type property
		@desc Whether the unit is a player
	]======]
	property "IsPlayer" {
		Get = function(self)
			return self.Unit and UnitIsPlayer(self.Unit)
		end,
	}

	doc [======[
		@name IsPossessed
		@type property
		@desc Whether the unit is possessed
	]======]
	property "IsPossessed" {
		Get = function(self)
			return self.Unit and UnitIsPossessed(self.Unit)
		end,
	}

	doc [======[
		@name IsGroupAssistant
		@type property
		@desc Whether the unit is the group assistant
	]======]
	property "IsGroupAssistant" {
		Get = function(self)
			local unit = self.Unit
			return unit and UnitInRaid(unit) and UnitIsGroupAssistant(unit) and not UnitIsGroupLeader(unit)
		end,
	}

	doc [======[
		@name IsSameServer
		@type property
		@desc Whether the unit is in the same server with the player
	]======]
	property "IsSameServer" {
		Get = function(self)
			return self.Unit and UnitIsSameServer("player", self.Unit)
		end,
	}

	doc [======[
		@name IsTapped
		@type property
		@desc Whether the unit is tapped
	]======]
	property "IsTapped" {
		Get = function(self)
			return self.Unit and UnitIsTapped(self.Unit)
		end,
	}

	doc [======[
		@name IsTappedByAllThreatList
		@type property
		@desc Whether a unit allows all players on its threat list to receive kill credit
	]======]
	property "IsTappedByAllThreatList" {
		Get = function(self)
			return self.Unit and UnitIsTappedByAllThreatList(self.Unit)
		end,
	}

	doc [======[
		@name IsTappedByPlayer
		@type property
		@desc Whether the unit is tapped by the player or the player's group
	]======]
	property "IsTappedByPlayer" {
		Get = function(self)
			return self.Unit and UnitIsTappedByPlayer(self.Unit)
		end,
	}

	doc [======[
		@name IsTrivial
		@type property
		@desc Whether the unit is trivial at the player's level
	]======]
	property "IsTrivial" {
		Get = function(self)
			return self.Unit and UnitIsTrivial(self.Unit)
		end,
	}

	doc [======[
		@name IsTarget
		@type property
		@desc Whether the unit is the target of the player
	]======]
	property "IsTarget" {
		Get = function(self)
			return self.Unit and UnitIsUnit(self.Unit, "target")
		end,
	}

	doc [======[
		@name IsTargetTarget
		@type property
		@desc Whether the unit is the target's target
	]======]
	property "IsTargetTarget" {
		Get = function(self)
			return self.Unit and UnitIsUnit(self.Unit, "targettarget")
		end,
	}

	doc [======[
		@name IsVisible
		@type property
		@desc Whether the unit is in the player's area of interest
	]======]
	property "IsVisible" {
		Get = function(self)
			return self.Unit and UnitIsVisible(self.Unit)
		end,
	}

	doc [======[
		@name OnTaxi
		@type property
		@desc Whether the unit is on the taxi
	]======]
	property "OnTaxi" {
		Get = function(self)
			return self.Unit and UnitOnTaxi(self.Unit)
		end,
	}

	doc [======[
		@name Level
		@type property
		@desc The unit's level
	]======]
	property "Level" {
		Get = function(self)
			return self.Unit and UnitLevel(self.Unit)
		end,
	}

	doc [======[
		@name PVPName
		@type property
		@desc Returns the name of the unit including the unit's current title
	]======]
	property "PVPName" {
		Get = function(self)
			return self.Unit and UnitPVPName(self.Unit)
		end,
	}

	doc [======[
		@name IsPlayerControlled
		@type property
		@desc Whether the unit is controlled by a player
	]======]
	property "IsPlayerControlled" {
		Get = function(self)
			return self.Unit and UnitPlayerControlled(self.Unit)
		end,
	}

	doc [======[
		@name Race
		@type property
		@desc The unit's race name
	]======]
	property "Race" {
		Get = function(self)
			return self.Unit and (select(2, UnitRace(self.Unit)))
		end,
	}

	doc [======[
		@name RaceLocale
		@type property
		@desc The unit's localization race name
	]======]
	property "RaceLocale" {
		Get = function(self)
			return self.Unit and (select(1, UnitRace(self.Unit)))
		end,
	}

	doc [======[
		@name Reaction
		@type property
		@desc The reaction of the unit with regards to player as a number
	]======]
	property "Reaction" {
		Get = function(self)
			return self.Unit and UnitReaction("player", self.Unit) and Reaction[tostring(UnitReaction("player", self.Unit))]
		end,
	}

	doc [======[
		@name Sex
		@type property
		@desc The unit's sex
	]======]
	property "Sex" {
		Get = function(self)
			return self.Unit and UnitSex(self.Unit) and Sex[tostring(UnitSex(self.Unit))]
		end,
	}

	doc [======[
		@name UsingVehicle
		@type property
		@desc Whether the unit is using vehicle
	]======]
	property "UsingVehicle" {
		Get = function(self)
			return self.Unit and UnitUsingVehicle(self.Unit) or false
		end,
	}

	doc [======[
		@name SelectionColor
		@type property
		@desc The color indicating hostility and related status of the unit
	]======]
	property "SelectionColor" {
		Get = function(self)
			return self.Unit and UnitSelectionColor(self.Unit) and ColorType(UnitSelectionColor(self.Unit))
		end,
	}

	doc [======[
		@name Health
		@type property
		@desc The unit's health
	]======]
	property "Health" {
		Get = function(self)
			return self.Unit and UnitHealth(self.Unit) or 0
		end,
	}

	doc [======[
		@name MaxHealth
		@type property
		@desc The unit's max health
	]======]
	property "MaxHealth" {
		Get = function(self)
			return self.Unit and UnitHealthMax(self.Unit) or 0
		end,
	}

	doc [======[
		@name HealthPct
		@type property
		@desc The unit's health percent
	]======]
	property "HealthPct" {
		Get = function(self)
			return self.Unit and UnitHealth(self.Unit) * 100 / UnitHealthMax(self.Unit) or 0
		end,
	}

	doc [======[
		@name Power
		@type property
		@desc The unit's power
	]======]
	property "Power" {
		Get = function(self)
			return self.Unit and UnitPower(self.Unit) or 0
		end,
	}

	doc [======[
		@name MaxPower
		@type property
		@desc The unit's max power
	]======]
	property "MaxPower" {
		Get = function(self)
			return self.Unit and UnitPowerMax(self.Unit) or 0
		end,
	}

	doc [======[
		@name PowerType
		@type property
		@desc The unit's power type
	]======]
	property "PowerType" {
		Get = function(self)
			return self.Unit and UnitPowerType(self.Unit) and PowerType[tostring(UnitPowerType(self.Unit))]
		end,
	}

	doc [======[
		@name PowerPct
		@type property
		@desc The unit's power percent
	]======]
	property "PowerPct" {
		Get = function(self)
			return self.Unit and UnitPower(self.Unit) * 100 / UnitPowerMax(self.Unit) or 0
		end,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endinterface "IFUnitElement"