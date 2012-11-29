-- Author      : Kurapica
-- Create Date : 2012/11/01
-- Change Log  :

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.Unit.Totem", version) then
	return
end

-----------------------------------------------
--- Totem
-- @type class
-- @name Totem
-----------------------------------------------
class "Totem"
	inherit "Button"
	extend "IFTotem" "IFCooldownIndicator"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Icon
	property "Icon" {
		Get = function(self)
			return self:GetChild("Icon").TexturePath
		end,
		Set = function(self, value)
			self:GetChild("Icon").TexturePath = value
		end,
		Type = System.String + nil,
	}

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function Totem(...)
		local obj = Super(...)

		obj:SetSize(36, 36)
		obj.ID = 1 	-- Default

		local icon = Texture("Icon", obj, "OVERLAY")
		icon:SetAllPoints()

		return obj
    end
endclass "Totem"