-- Author      : Kurapica
-- Create Date : 2012/07/02
-- Change Log  :

----------------------------------------------------------------------------------------------------------------------------------------
--- IFSecureHandler
-- @type Interface
-- @name IFSecureHandler
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 1
if not IGAS:NewAddon("IGAS.Widget.IFSecureHandler", version) then
	return
end

_SecureHandlerExecute = SecureHandlerExecute
_SecureHandlerWrapScript = SecureHandlerWrapScript
_SecureHandlerUnwrapScript = SecureHandlerUnwrapScript
_SecureHandlerSetFrameRef = SecureHandlerSetFrameRef

_RegisterAttributeDriver = RegisterAttributeDriver
_UnregisterAttributeDriver = UnregisterAttributeDriver
_RegisterStateDriver = RegisterStateDriver
_UnregisterStateDriver = UnregisterStateDriver
_RegisterUnitWatch = RegisterUnitWatch
_UnregisterUnitWatch = UnregisterUnitWatch
_UnitWatchRegistered = UnitWatchRegistered

interface "IFSecureHandler"

	------------------------------------------------------
	-- Script
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	------------------------------------
	--- Execute a snippet against a header frame
	-- @name Execute
	-- @class function
	-- @param body the snippet to be executed for the frame
	-- @usage IFSecureHandler:Execute([[print(1, 2, 3)]])
	------------------------------------
	function Execute(self, body)
		self = IGAS:GetUI(self)

		return _SecureHandlerExecute(self, body)
	end

	------------------------------------
	--- Wrap the script on a frame to invoke snippets against a header
	-- @name WrapScript
	-- @class function
	-- @param frame the frame which's script is to be wrapped
	-- @param script the script handle name
	-- @param preBody the snippet to be executed before the original script handler
	-- @param postBody the snippet to be executed after the original script handler
	-- @usage IFSecureHandler:WrapScript(button, "OnEnter", [[]])
	------------------------------------
	function WrapScript(self, frame, script, preBody, postBody)
		self = IGAS:GetUI(self)
		frame = IGAS:GetUI(frame)

		return _SecureHandlerWrapScript(frame, script, self, preBody, postBody)
	end

	------------------------------------
	--- Remove previously applied wrapping, returning its details
	-- @name UnwrapScript
	-- @class function
	-- @param frame the frame which's script is to be wrapped
	-- @param script the script handle name
	-- @return header - self's handler
	-- @return preBody - the snippet to be executed before the original script handler
	-- @return postBody - the snippet to be executed after the original script handler
	-- @usage IFSecureHandler:UnwrapScript(button, "OnEnter")
	------------------------------------
	function UnwrapScript(self, frame, script)
		self = IGAS:GetUI(self)
		frame = IGAS:GetUI(frame)

		return _SecureHandlerUnwrapScript(frame, script)
	end

	------------------------------------
	--- Create a frame handle reference and store it against a frame
	-- @name SetFrameRef
	-- @class function
	-- @param label the frame handle's reference name
	-- @param refFrame the frame
	-- @usage IFSecureHandler:SetFrameRef("MyButton", button)
	------------------------------------
	function SetFrameRef(self, label, refFrame)
		self = IGAS:GetUI(self)
		refFrame = IGAS:GetUI(refFrame)

		return _SecureHandlerSetFrameRef(self, label, refFrame)
	end

	------------------------------------
	--- Register a frame attribute to be set automatically with changes in game state
	-- @name RegisterAttributeDriver
	-- @class function
	-- @param attribute
	-- @param values
	-- @usage IFSecureHandler:RegisterAttributeDriver("hasunit", "[@mouseover, exists] true; false")
	------------------------------------
	function RegisterAttributeDriver(self, attribute, values)
		self = IGAS:GetUI(self)

		return _RegisterAttributeDriver(self, attribute, values)
	end

	------------------------------------
	--- Unregister a frame from the state driver manager
	-- @name UnregisterAttributeDriver
	-- @class function
	-- @param attribute
	-- @param values
	-- @usage IFSecureHandler:UnregisterAttributeDriver("hasunit")
	------------------------------------
	function UnregisterAttributeDriver(self, attribute, values)
		self = IGAS:GetUI(self)

		return _UnregisterAttributeDriver(self, attribute, values)
	end

	------------------------------------
	--- Register a frame state to be set automatically with changes in game state
	-- @name RegisterStateDriver
	-- @class function
	-- @param state
	-- @param values
	-- @usage IFSecureHandler:RegisterStateDriver("hasunit", "[@mouseover, exists] true; false")
	------------------------------------
	function RegisterStateDriver(self, state, values)
		self = IGAS:GetUI(self)

		return _RegisterStateDriver(self, state, values)
	end

	------------------------------------
	--- Unregister a frame from the state driver manager
	-- @name UnregisterStateDriver
	-- @class function
	-- @param state
	-- @param values
	-- @usage IFSecureHandler:UnregisterStateDriver("hasunit")
	------------------------------------
	function UnregisterStateDriver(self, state)
		self = IGAS:GetUI(self)

		return _UnregisterStateDriver(self, state)
	end

	------------------------------------
	--- Register a frame to be notified when a unit's existence changes
	-- @name RegisterUnitWatch
	-- @class function
	-- @param [asState]
	-- @usage IFSecureHandler:RegisterUnitWatch()
	------------------------------------
	function RegisterUnitWatch(self, asState)
		self = IGAS:GetUI(self)

		return _RegisterUnitWatch(self, asState)
	end

	------------------------------------
	--- Unregister a frame from the unit existence monitor
	-- @name UnregisterUnitWatch
	-- @class function
	-- @usage IFSecureHandler:UnregisterUnitWatch()
	------------------------------------
	function UnregisterUnitWatch(self)
		self = IGAS:GetUI(self)

		return _UnregisterUnitWatch(self)
	end

	------------------------------------
	--- Check to see if a frame is registered
	-- @name UnitWatchRegistered
	-- @class function
	-- @return flag
	-- @usage IFSecureHandler:UnitWatchRegistered()
	------------------------------------
	function UnitWatchRegistered(self)
		self = IGAS:GetUI(self)

		return _UnitWatchRegistered(self)
	end

	------------------------------------------------------
	-- Property
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endinterface "IFSecureHandler"