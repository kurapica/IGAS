-- Author      : Kurapica
-- Create Date : 2012/06/25
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- RoleIcon
-- <br><br>inherit <a href="..\Base\Texture.html">Texture</a> For all methods, properties and scriptTypes
-- @name RoleIcon
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.Unit.RoleIcon", version) then
	return
end

_M:RegisterEvent"PLAYER_REGEN_DISABLED"
_M:RegisterEvent"PLAYER_REGEN_ENABLED"

_RoleIcon_HideInCombat = _RoleIcon_HideInCombat or {}

_InCombat = false

function PLAYER_REGEN_DISABLED(self)
	_InCombat = true
	for icon in pairs(_RoleIcon_HideInCombat) do
		icon:Refresh()
	end
end

function PLAYER_REGEN_ENABLED(self)
	_InCombat = false
	for icon in pairs(_RoleIcon_HideInCombat) do
		icon:Refresh()
	end
end

class "RoleIcon"
	inherit "Texture"
	extend "IFGroupRole"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Refresh the element
	-- @name Refresh
	-- @type function
	------------------------------------
	function Refresh(self)
		if not _M._InCombat or self.ShowInCombat then
			local role = self.Unit and UnitGroupRolesAssigned(self.Unit)

			if role == 'TANK' or role == 'HEALER' or role == 'DAMAGER' then
				if self:IsClass(Texture) then
					self:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
				end
				self.Visible = true
			else
				self.Visible = false
			end
		else
			self.Visible = false
		end
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- ShowInCombat
	property "ShowInCombat" {
		Get = function(self)
			return self.__ShowInCombat or false
		end,
		Set = function(self, value)
			if self.__ShowInCombat ~= value then
				self.__ShowInCombat = value
				if value then
					_RoleIcon_HideInCombat[self] = nil
				else
					_RoleIcon_HideInCombat[self] = true
				end
				self:Refresh()
			end
		end,
		Type = System.Boolean,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function RoleIcon(...)
		local icon = Super(...)

		icon.Height = 16
		icon.Width = 16

		icon.TexturePath = [[Interface\LFGFrame\UI-LFG-ICON-PORTRAITROLES]]

		_RoleIcon_HideInCombat[icon] = true

		return icon
	end
endclass "RoleIcon"