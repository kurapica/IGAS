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
	function Constructor(self, name, parent, ...)
		if select('#', ...) > 0 then
			return CreateFrame("Frame", name, parent, ...)
		else
			return CreateFrame("Frame", name, parent, "SecureFrameTemplate")
		end
	end
endclass "SecureFrame"
