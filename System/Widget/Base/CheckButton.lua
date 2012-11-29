-- Author      : Kurapica
-- Create Date : 7/16/2008 15:01
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- CheckButtons are a specialized form of Button; they maintain an on/off state, which toggles automatically when they are clicked, and additional textures for when they are checked, or checked while disabled.
-- <br><br>inherit <a href=".\Button.html">Button</a> For all methods, properties and scriptTypes
-- @name CheckButton
-- @class table
-- @field Checked true if the checkbutton is checked
-- @field CheckedTexture the texture used when the button is checked
-- @field CheckedTexturePath the texture file used when the button is checked
-- @field DisabledCheckedTexture the texture used when the button is disabled and checked
-- @field DisabledCheckedTexturePath the texture file used when the button is disabled and checked
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 7
if not IGAS:NewAddon("IGAS.Widget.CheckButton", version) then
	return
end

class "CheckButton"
	inherit "Button"

	------------------------------------------------------
	-- Script
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Returns whether the check button is checked
	-- @name CheckButton:GetChecked
	-- @class function
	-- @return enabled - 1 if the button is checked; nil if the button is unchecked (1nil)
	------------------------------------
	-- GetChecked

	------------------------------------
	--- Returns the texture used when the button is checked
	-- @name CheckButton:GetCheckedTexture
	-- @class function
	-- @return texture - Reference to the Texture object used when the button is checked (texture)
	------------------------------------
	function GetCheckedTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetCheckedTexture(...))
	end

	------------------------------------
	--- Returns the texture used when the button is disabled and checked
	-- @name CheckButton:GetDisabledCheckedTexture
	-- @class function
	-- @return texture - Reference to the Texture object used when the button is disabled and checked (texture)
	------------------------------------
	function GetDisabledCheckedTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetDisabledCheckedTexture(...))
	end

	------------------------------------
	--- Sets whether the check button is checked
	-- @name CheckButton:SetChecked
	-- @class function
	-- @param enable True to check the button; false to uncheck (boolean)
	------------------------------------
	-- SetChecked

	------------------------------------
	--- Sets the texture used when the button is checked
	-- @name CheckButton:SetCheckedTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	------------------------------------
	-- SetCheckedTexture

	------------------------------------
	--- Sets the texture used when the button is disabled and checked
	-- @name CheckButton:SetDisabledCheckedTexture
	-- @class function
	-- @param texture Reference to an existing Texture object (texture)
	-- @param filename Path to a texture image file (string)
	------------------------------------
	-- SetDisabledCheckedTexture

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- Checked
	property "Checked" {
		Get = function(self)
			return (self:GetChecked() and true) or false
		end,
		Set = function(self, value)
			self:SetChecked(value)
		end,
		Type = Boolean,
	}
	-- CheckedTexture
	property "CheckedTexture" {
		Get = function(self)
			return self:GetCheckedTexture()
		end,
		Set = function(self, texture)
			self:SetCheckedTexture(texture)
		end,
		Type = Texture + nil,
	}
	-- CheckedTexturePath
	property "CheckedTexturePath" {
		Get = function(self)
			return self:GetCheckedTexture() and self:GetCheckedTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetCheckedTexture(texture)
		end,
		Type = String + nil,
	}
	-- DisabledCheckedTexture
	property "DisabledCheckedTexture" {
		Get = function(self)
			return self:GetDisabledCheckedTexture()
		end,
		Set = function(self, texture)
			self:SetDisabledCheckedTexture(texture)
		end,
		Type = Texture + nil,
	}
	-- DisabledCheckedTexturePath
	property "DisabledCheckedTexturePath" {
		Get = function(self)
			return self:GetDisabledCheckedTexture() and self:GetDisabledCheckedTexture().TexturePath
		end,
		Set = function(self, texture)
			self:SetDisabledCheckedTexture(texture)
		end,
		Type = String + nil,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function CheckButton(name, parent, ...)
		return UIObject(name, parent, CreateFrame("CheckButton", nil, parent, ...))
	end
endclass "CheckButton"

partclass "CheckButton"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(CheckButton)
endclass "CheckButton"