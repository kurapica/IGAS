-- Author      : Kurapica
-- Create Date : 7/16/2008 15:01
-- Change Log  :
--				2011/03/13	Recode as class

-- Check Version
local version = 7
if not IGAS:NewAddon("IGAS.Widget.CheckButton", version) then
	return
end

class "CheckButton"
	inherit "Button"

	doc [======[
		@name CheckButton
		@type class
		@desc CheckButtons are a specialized form of Button; they maintain an on/off state, which toggles automatically when they are clicked, and additional textures for when they are checked, or checked while disabled.
	]======]

	------------------------------------------------------
	-- Script
	-----------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetChecked
		@type method
		@desc Returns whether the check button is checked
		@return boolean 1 if the button is checked; nil if the button is unchecked
	]======]

	doc [======[
		@name GetCheckedTexture
		@type method
		@desc Returns the texture used when the button is checked
		@return System.Widget.Texture Reference to the Texture object used when the button is checked
	]======]
	function GetCheckedTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetCheckedTexture(...))
	end

	doc [======[
		@name GetDisabledCheckedTexture
		@type method
		@desc Returns the texture used when the button is disabled and checked
		@return  System.Widget.Texture Reference to the Texture object used when the button is disabled and checked
	]======]
	function GetDisabledCheckedTexture(self, ...)
		return IGAS:GetWrapper(self.__UI:GetDisabledCheckedTexture(...))
	end

	doc [======[
		@name SetChecked
		@type method
		@desc Sets whether the check button is checked
		@param enable boolean, true to check the button; false to uncheck
		@return nil
	]======]

	doc [======[
		@name SetCheckedTexture
		@type method
		@desc Sets the texture used when the button is checked
		@format texture|filename
		@param texture System.Widget.Texture, reference to an existing Texture object
		@param filename string, path to a texture image file
		@return nil
	]======]

	doc [======[
		@name SetDisabledCheckedTexture
		@type method
		@desc Sets the texture used when the button is disabled and checked
		@format texture|filename
		@param texture System.Widget.Texture, reference to an existing Texture object
		@param filename string, path to a texture image file
		@return nil
	]======]

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
	function Constructor(self, name, parent, ...)
		return CreateFrame("CheckButton", nil, parent, ...)
	end
endclass "CheckButton"

partclass "CheckButton"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(CheckButton)
endclass "CheckButton"