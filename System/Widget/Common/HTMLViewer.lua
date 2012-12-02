-- Author      : Kurapica
-- Create Date : 2012/12/2
-- Change Log  :

---------------------------------------------------------------------------------------------------------------------------------------
--- HTMLViewer is a widget type using to contain one line text
-- <br><br>inherit <a href="..\Base\ScrollingMessageFrame.html">ScrollingMessageFrame</a> For all methods, properties and scriptTypes
-- @name HTMLViewer
-- @class table
---------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1

if not IGAS:NewAddon("IGAS.Widget.HTMLViewer", version) then
	return
end

class "HTMLViewer"
	inherit "ScrollingMessageFrame"

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
	-- Script Handler
	------------------------------------------------------
	local function OnHyperlinkClick(self, linkData, link, button)
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function HTMLViewer(name, parent)
		local frame = ScrollForm(name, parent)

		frame.FrameStrata = "BACKGROUND"
		frame.Toplevel = true
		frame.HyperlinksEnabled = true
		-- frame:SetHyperlinkFormat(FontColor.GREEN .. "|H%s|h%s|h" .. FontColor.CLOSE)

		frame.OnHyperlinkClick = frame.OnHyperlinkClick + OnHyperlinkClick

		return frame
	end
endclass "HTMLViewer"
