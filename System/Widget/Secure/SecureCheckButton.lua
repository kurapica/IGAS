-- Author      : Kurapica
-- Create Date : 2010/12/27
-- Change Log  :
--				2011/03/13	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- SecureCheckButton is protected CheckButton
-- <br><br>inherit <a href="..\Base\CheckButton.html">CheckButton</a> For all methods, properties and scriptTypes
-- @name SecureCheckButton
-- @class table
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 2
if not IGAS:NewAddon("IGAS.Widget.SecureCheckButton", version) then
	return
end

SecureHandler_OnLoad = SecureHandler_OnLoad

class "SecureCheckButton"
	inherit "CheckButton"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Execute a snippet against a header frame
	-- @name SecureCheckButton:Execute
	-- @class function
	-- @param body the snippet to be executed for the frame
	-- @usage SecureCheckButton:Execute([[print(1, 2, 3)]])
	------------------------------------
	function Execute(self, body)
		return IGAS:GetUI(self):Execute(body)
	end

	------------------------------------
	--- Wrap the script on a frame to invoke snippets against a header
	-- @name SecureCheckButton:WrapScript
	-- @class function
	-- @param frame the frame which's script is to be wrapped
	-- @param script the script handle name
	-- @param preBody the snippet to be executed before the original script handler
	-- @param postBody the snippet to be executed after the original script handler
	-- @usage SecureCheckButton:WrapScript(button, "OnEnter", [[]])
	------------------------------------
	function WrapScript(self, frame, script, preBody, postBody)
		frame = IGAS:GetUI(frame)
		return IGAS:GetUI(self):WrapScript(frame, script, preBody, postBody)
	end

	------------------------------------
	--- Remove previously applied wrapping, returning its details
	-- @name SecureCheckButton:UnwrapScript
	-- @class function
	-- @param frame the frame which's script is to be wrapped
	-- @param script the script handle name
	-- @return header - self's handler
	-- @return preBody - the snippet to be executed before the original script handler
	-- @return postBody - the snippet to be executed after the original script handler
	-- @usage SecureCheckButton:UnwrapScript(button, "OnEnter")
	------------------------------------
	function UnwrapScript(self, frame, script)
		frame = IGAS:GetUI(frame)
		return IGAS:GetUI(self):UnwrapScript(frame, script)
	end

	------------------------------------
	--- Create a frame handle reference and store it against a frame
	-- @name SecureCheckButton:SetFrameRef
	-- @class function
	-- @param id the frame handle's reference name
	-- @param frame the frame
	-- @usage SecureCheckButton:SetFrameRef("MyButton", button)
	------------------------------------
	function SetFrameRef(self, id, frame)
		frame = IGAS:GetUI(frame)
		return IGAS:GetUI(self):SetFrameRef(id, frame)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
    function SecureCheckButton(name, parent, ...)
		local fullName = GetFullName(parent)

		if fullName and fullName ~= "" then
			fullName = fullName.."."..name
		else
			fullName = name
		end

        -- New Frame
		local frame = CreateFrame("CheckButton", fullName, IGAS:GetUI(parent), "SecureActionButtonTemplate")

		SecureHandler_OnLoad(frame)

		return UIObject(name, parent, frame)
    end
endclass "SecureCheckButton"
