-- Author      : Kurapica
-- Create Date : 2010/12/27
-- Change Log  :
--				2011/03/14	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- SecureFrame is protected frame
-- <br><br>inherit <a href="..\Base\Frame.html">Frame</a> For all methods, properties and scriptTypes
-- @name SecureFrame
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 3
if not IGAS:NewAddon("IGAS.Widget.SecureFrame", version) then
	return
end

class "SecureFrame"
	inherit "Frame"
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
    function SecureFrame(name, parent, ...)
		local frame

		if select('#', ...) > 0 then
			frame = UIObject(name, parent, CreateFrame("Frame", name, parent, ...))
		else
			frame = UIObject(name, parent, CreateFrame("Frame", name, parent, "SecureFrameTemplate"))
		end

		return frame
    end
endclass "SecureFrame"
