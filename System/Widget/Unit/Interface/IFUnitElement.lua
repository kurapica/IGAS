-- Author      : Kurapica
-- Create Date : 2012/07/02
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFUnitElement
-- @type Interface
-- @name IFUnitElement
----------------------------------------------------------------------------------------------------------------------------------------

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
	------------------------------------------------------
	-- Script
	------------------------------------------------------
	script "OnUnitChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		-- need override
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Unit
	property "Unit" {
		Get = function(self)
			return self.__IFUnitElement_Unit
		end,
		Set = function(self, unit)
			unit = unit and unit:lower()
			if self.__IFUnitElement_Unit ~= unit then
				self.__IFUnitElement_Unit = unit
				self:Fire("OnUnitChanged")
				self:Refresh()
			end
		end,
		Type = String + nil,
	}

	-- CanInspect
	property "CanInspect" {
		Get = function(self)
			return self.Unit and CanInspect(self.Unit) or false
		end,
	}
	-- CanTrade
	property "CanTrade" {
		Get = function(self)
			return self.Unit and UnitCanCooperate("player", self.Unit) and not UnitIsUnit("player", self.Unit) and CheckInteractDistance(self.Unit, 2) or false
		end,
	}
	-- CanDuel
	property "CanDuel" {
		Get = function(self)
			return self.Unit and UnitCanCooperate("player", self.Unit) and not UnitIsUnit("player", self.Unit) and CheckInteractDistance(self.Unit, 3) or false
		end,
	}
	-- CanFollow
	property "CanFollow" {
		Get = function(self)
			return self.Unit and UnitCanCooperate("player", self.Unit) and not UnitIsUnit("player", self.Unit) and CheckInteractDistance(self.Unit, 4) or false
		end,
	}
	-- GuildName
	property "GuildName" {
		Get = function(self)
			return self.Unit and (select(1, GetGuildInfo(self.Unit))) or ""
		end,
	}
	-- GuildRankName
	property "GuildRankName" {
		Get = function(self)
			return self.Unit and (select(2, GetGuildInfo(self.Unit))) or ""
		end,
	}
	-- GuildRankIndex
	property "GuildRankIndex" {
		Get = function(self)
			return self.Unit and (select(3, GetGuildInfo(self.Unit)))
		end,
	}
	-- Muted
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
	-- UnitName
	property "UnitName" {
		Get = function(self)
			return self.Unit and GetUnitName(self.Unit, true) or ""
		end,
	}
	-- Speed
	property "Speed" {
		Get = function(self)
			return self.Unit and (select(1, GetUnitSpeed(self.Unit))) or 0
		end,
	}
	-- GroundSpeed
	property "GroundSpeed" {
		Get = function(self)
			return self.Unit and (select(2, GetUnitSpeed(self.Unit))) or 0
		end,
	}
	-- FlightSpeed
	property "FlightSpeed" {
		Get = function(self)
			return self.Unit and (select(3, GetUnitSpeed(self.Unit))) or 0
		end,
	}
	-- SwimSpeed
	property "SwimSpeed" {
		Get = function(self)
			return self.Unit and (select(4, GetUnitSpeed(self.Unit))) or 0
		end,
	}
	-- InCombat
	property "InCombat" {
		Get = function(self)
			return self.Unit and UnitAffectingCombat(self.Unit) or false
		end,
	}
	-- CanAssist
	property "CanAssist" {
		Get = function(self)
			return self.Unit and UnitCanAssist("player", self.Unit) or false
		end,
	}
	-- CanAttack
	property "CanAttack" {
		Get = function(self)
			return self.Unit and UnitCanAttack("player", self.Unit) or false
		end,
	}
	-- CanCooperate
	property "CanCooperate" {
		Get = function(self)
			return self.Unit and UnitCanCooperate("player", self.Unit) or false
		end,
	}
	-- UnitClass
	property "UnitClass" {
		Get = function(self)
			return self.Unit and (select(2, UnitClassBase(self.Unit)))
		end,
	}
	-- UnitClassLocale
	property "UnitClassLocale" {
		Get = function(self)
			return self.Unit and (select(1, UnitClassBase(self.Unit)))
		end,
	}
	-- Classification
	property "Classification" {
		Get = function(self)
			return self.Unit and UnitClassification(self.Unit)
		end,
	}
	-- Existed
	property "Existed" {
		Get = function(self)
			return self.Unit and UnitExists(self.Unit) or false
		end,
	}
	-- Faction
	property "Faction" {
		Get = function(self)
			return self.Unit and (select(1, UnitFactionGroup(self.Unit)))
		end,
	}
	-- FactionLocale
	property "FactionLocale" {
		Get = function(self)
			return self.Unit and (select(2, UnitFactionGroup(self.Unit)))
		end,
	}
	-- GUID
	property "GUID" {
		Get = function(self)
			return self.Unit and UnitGUID(self.Unit)
		end,
	}
	-- Role
	property "Role" {
		Get = function(self)
			return self.Unit and UnitGroupRolesAssigned(self.Unit)
		end,
	}
	-- InBattleground
	property "InBattleground" {
		Get = function(self)
			return self.Unit and UnitInBattleground(self.Unit)
		end,
	}
	-- InParty
	property "InParty" {
		Get = function(self)
			return self.Unit and UnitInParty(self.Unit)
		end,
	}
	-- InRaid
	property "InRaid" {
		Get = function(self)
			return self.Unit and UnitInRaid(self.Unit)
		end,
	}
	-- InRange
	property "InRange" {
		Get = function(self)
			if self.Existed then
				local inRange, checkedRange = UnitInRange(self.Unit)

				return inRange or not checkedRange
			end
		end,
	}
	-- IsAFK
	property "IsAFK" {
		Get = function(self)
			return self.Unit and UnitIsAFK(self.Unit)
		end,
	}
	-- IsCharmed
	property "IsCharmed" {
		Get = function(self)
			return self.Unit and UnitIsCharmed(self.Unit)
		end,
	}
	-- IsConnected
	property "IsConnected" {
		Get = function(self)
			return self.Unit and UnitIsConnected(self.Unit) or false
		end,
	}
	-- IsControlling
	property "IsControlling" {
		Get = function(self)
			return self.Unit and UnitIsControlling(self.Unit) or false
		end,
	}
	-- IsDND
	property "IsDND" {
		Get = function(self)
			return self.Unit and UnitIsDND(self.Unit)
		end,
	}
	-- IsDead
	property "IsDead" {
		Get = function(self)
			return self.Unit and UnitIsDead(self.Unit)
		end,
	}
	-- IsGhost
	property "IsGhost" {
		Get = function(self)
			return self.Unit and UnitIsGhost(self.Unit)
		end,
	}
	-- IsEnemy
	property "IsEnemy" {
		Get = function(self)
			return self.Unit and UnitIsEnemy("player", self.Unit)
		end,
	}
	-- IsFeignDeath
	property "IsFeignDeath" {
		Get = function(self)
			return self.Unit and UnitIsFeignDeath(self.Unit)
		end,
	}
	-- IsFriend
	property "IsFriend" {
		Get = function(self)
			return self.Unit and UnitIsFriend("player", self.Unit)
		end,
	}
	-- IsPVP
	property "IsPVP" {
		Get = function(self)
			return self.Unit and UnitIsPVP(self.Unit)
		end,
	}
	-- IsPVPFreeForAll
	property "IsPVPFreeForAll" {
		Get = function(self)
			return self.Unit and UnitIsPVPFreeForAll(self.Unit)
		end,
	}
	-- IsPVPSanctuary
	property "IsPVPSanctuary" {
		Get = function(self)
			return self.Unit and UnitIsPVPSanctuary(self.Unit)
		end,
	}
	-- IsGroupLeader
	property "IsGroupLeader" {
		Get = function(self)
			return self.Unit and UnitIsGroupLeader(self.Unit)
		end,
	}
	-- IsPlayer
	property "IsPlayer" {
		Get = function(self)
			return self.Unit and UnitIsPlayer(self.Unit)
		end,
	}
	-- IsPossessed
	property "IsPossessed" {
		Get = function(self)
			return self.Unit and UnitIsPossessed(self.Unit)
		end,
	}
	-- IsGroupAssistant
	property "IsGroupAssistant" {
		Get = function(self)
			local unit = self.Unit
			return unit and UnitInRaid(unit) and UnitIsGroupAssistant(unit) and not UnitIsGroupLeader(unit)
		end,
	}
	-- IsSameServer
	property "IsSameServer" {
		Get = function(self)
			return self.Unit and UnitIsSameServer("player", self.Unit)
		end,
	}
	-- IsTapped
	property "IsTapped" {
		Get = function(self)
			return self.Unit and UnitIsTapped(self.Unit)
		end,
	}
	-- IsTappedByAllThreatList
	property "IsTappedByAllThreatList" {
		Get = function(self)
			return self.Unit and UnitIsTappedByAllThreatList(self.Unit)
		end,
	}
	-- IsTappedByPlayer
	property "IsTappedByPlayer" {
		Get = function(self)
			return self.Unit and UnitIsTappedByPlayer(self.Unit)
		end,
	}
	-- IsTrivial
	property "IsTrivial" {
		Get = function(self)
			return self.Unit and UnitIsTrivial(self.Unit)
		end,
	}
	-- IsTarget
	property "IsTarget" {
		Get = function(self)
			return self.Unit and UnitIsUnit(self.Unit, "target")
		end,
	}
	-- IsTargetTarget
	property "IsTargetTarget" {
		Get = function(self)
			return self.Unit and UnitIsUnit(self.Unit, "targettarget")
		end,
	}
	-- IsVisible
	property "IsVisible" {
		Get = function(self)
			return self.Unit and UnitIsVisible(self.Unit)
		end,
	}
	-- OnTaxi
	property "OnTaxi" {
		Get = function(self)
			return self.Unit and UnitOnTaxi(self.Unit)
		end,
	}
	-- Level
	property "Level" {
		Get = function(self)
			return self.Unit and UnitLevel(self.Unit)
		end,
	}
	-- PVPName
	property "PVPName" {
		Get = function(self)
			return self.Unit and UnitPVPName(self.Unit)
		end,
	}
	-- IsPlayerControlled
	property "IsPlayerControlled" {
		Get = function(self)
			return self.Unit and UnitPlayerControlled(self.Unit)
		end,
	}
	-- UnitRace
	property "Race" {
		Get = function(self)
			return self.Unit and (select(2, UnitRace(self.Unit)))
		end,
	}
	-- UnitRaceLocale
	property "RaceLocale" {
		Get = function(self)
			return self.Unit and (select(1, UnitRace(self.Unit)))
		end,
	}
	-- Reaction
	property "Reaction" {
		Get = function(self)
			return self.Unit and UnitReaction("player", self.Unit) and Reaction[tostring(UnitReaction("player", self.Unit))]
		end,
	}
	-- Sex
	property "Sex" {
		Get = function(self)
			return self.Unit and UnitSex(self.Unit) and Sex[tostring(UnitSex(self.Unit))]
		end,
	}
	-- UsingVehicle
	property "UsingVehicle" {
		Get = function(self)
			return self.Unit and UnitUsingVehicle(self.Unit) or false
		end,
	}
	-- SelectionColor
	property "SelectionColor" {
		Get = function(self)
			return self.Unit and UnitSelectionColor(self.Unit) and ColorType(UnitSelectionColor(self.Unit))
		end,
	}
	-- Health
	property "Health" {
		Get = function(self)
			return self.Unit and UnitHealth(self.Unit) or 0
		end,
	}
	-- MaxHealth
	property "MaxHealth" {
		Get = function(self)
			return self.Unit and UnitHealthMax(self.Unit) or 0
		end,
	}
	-- HealthPct
	property "HealthPct" {
		Get = function(self)
			return self.Unit and UnitHealth(self.Unit) * 100 / UnitHealthMax(self.Unit) or 0
		end,
	}
	-- Power
	property "Power" {
		Get = function(self)
			return self.Unit and UnitPower(self.Unit) or 0
		end,
	}
	-- MaxPower
	property "MaxPower" {
		Get = function(self)
			return self.Unit and UnitPowerMax(self.Unit) or 0
		end,
	}
	-- PowerType
	property "PowerType" {
		Get = function(self)
			return self.Unit and UnitPowerType(self.Unit) and PowerType[tostring(UnitPowerType(self.Unit))]
		end,
	}
	-- PowerPct
	property "PowerPct" {
		Get = function(self)
			return self.Unit and UnitPower(self.Unit) * 100 / UnitPowerMax(self.Unit) or 0
		end,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endinterface "IFUnitElement"