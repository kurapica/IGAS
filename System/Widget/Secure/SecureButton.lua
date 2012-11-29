-- Author      : Kurapica
-- Create Date : 2010/12/27
-- Change Log  :
--				2011/03/13	Recode as class
--              2012/07/04  Extend from IFSecureHandler

----------------------------------------------------------------------------------------------------------------------------------------
--- SecureButton is protected Button
-- <br><br>inherit <a href="..\Base\Button.html">Button</a> For all methods, properties and scriptTypes
-- @name SecureButton
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 3
if not IGAS:NewAddon("IGAS.Widget.SecureButton", version) then
	return
end

class "SecureButton"
	inherit "Button"
	extend "IFSecureHandler"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function SecureButton(name, parent, ...)
		local button

		if select('#', ...) > 0 then
			button = UIObject(name, parent, CreateFrame("Button", name, parent, ...))
		else
			button = UIObject(name, parent, CreateFrame("Button", name, parent, "SecureFrameTemplate"))
		end

		return button
    end
endclass "SecureButton"
