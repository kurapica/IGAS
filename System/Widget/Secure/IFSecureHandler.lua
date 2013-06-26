-- Author      : Kurapica
-- Create Date : 2012/07/02
-- Change Log  :

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
	doc [======[
		@name IFSecureHandler
		@type interface
		@desc IFSecureHandler contains several secure methods for secure frames
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name Execute
		@type method
		@desc Execute a snippet against a header frame
		@param body string, the snippet to be executed for the frame
		@return nil
		@usage object:Execute([[print(1, 2, 3)]])
	]======]
	function Execute(self, body)
		self = IGAS:GetUI(self)

		return _SecureHandlerExecute(self, body)
	end

	doc [======[
		@name WrapScript
		@type method
		@desc Wrap the script on a frame to invoke snippets against a header
		@param frame System.Widget.Frame, the frame which's script is to be wrapped
		@param script string, the script handle name
		@param preBody string, the snippet to be executed before the original script handler
		@param postBody string, the snippet to be executed after the original script handler
		@return nil
		@usage object:WrapScript(button, "OnEnter", [[]])
	]======]
	function WrapScript(self, frame, script, preBody, postBody)
		self = IGAS:GetUI(self)
		frame = IGAS:GetUI(frame)

		return _SecureHandlerWrapScript(frame, script, self, preBody, postBody)
	end

	doc [======[
		@name UnwrapScript
		@type method
		@desc Remove previously applied wrapping, returning its details
		@param frame System.Widget.Frame, the frame which's script is to be wrapped
		@param script name, the script handle name
		@return header System.Widget.Frame, self's handler
		@return preBody string, the snippet to be executed before the original script handler
		@return postBody string, the snippet to be executed after the original script handler
		@usage object:UnwrapScript(button, "OnEnter")
	]======]
	function UnwrapScript(self, frame, script)
		self = IGAS:GetUI(self)
		frame = IGAS:GetUI(frame)

		return _SecureHandlerUnwrapScript(frame, script)
	end

	doc [======[
		@name SetFrameRef
		@type method
		@desc Create a frame handle reference and store it against a frame
		@param label string, the frame handle's reference name
		@param refFrame System.Widget.Frame, the frame
		@return nil
		@usage object:SetFrameRef("MyButton", button)
	]======]
	function SetFrameRef(self, label, refFrame)
		self = IGAS:GetUI(self)
		refFrame = IGAS:GetUI(refFrame)

		return _SecureHandlerSetFrameRef(self, label, refFrame)
	end

	doc [======[
		@name RegisterAttributeDriver
		@type method
		@desc Register a frame attribute to be set automatically with changes in game state
		@param attribute string
		@param values string
		@return nil
		@usage object:RegisterAttributeDriver("hasunit", "[@mouseover, exists] true; false")
	]======]
	function RegisterAttributeDriver(self, attribute, values)
		self = IGAS:GetUI(self)

		return _RegisterAttributeDriver(self, attribute, values)
	end

	doc [======[
		@name UnregisterAttributeDriver
		@type method
		@desc Unregister a frame from the state driver manager
		@param attribute string
		@param values string
		@return nil
		@usage object:UnregisterAttributeDriver("hasunit")
	]======]
	function UnregisterAttributeDriver(self, attribute, values)
		self = IGAS:GetUI(self)

		return _UnregisterAttributeDriver(self, attribute, values)
	end

	doc [======[
		@name RegisterStateDriver
		@type method
		@desc Register a frame state to be set automatically with changes in game state
		@param state
		@param values
		@return nil
		@usage object:RegisterStateDriver("hasunit", "[@mouseover, exists] true; false")
	]======]
	function RegisterStateDriver(self, state, values)
		self = IGAS:GetUI(self)

		return _RegisterStateDriver(self, state, values)
	end

	doc [======[
		@name UnregisterStateDriver
		@type method
		@desc Unregister a frame from the state driver manager
		@param state
		@param values
		@return nil
		@usage object:UnregisterStateDriver("hasunit")
	]======]
	function UnregisterStateDriver(self, state)
		self = IGAS:GetUI(self)

		return _UnregisterStateDriver(self, state)
	end

	doc [======[
		@name RegisterUnitWatch
		@type method
		@desc Register a frame to be notified when a unit's existence changes
		@format [asState]
		@return nil
		@usage object:RegisterUnitWatch()
	]======]
	function RegisterUnitWatch(self, asState)
		self = IGAS:GetUI(self)

		return _RegisterUnitWatch(self, asState)
	end

	doc [======[
		@name UnregisterUnitWatch
		@type method
		@desc Unregister a frame from the unit existence monitor
		@return nil
	]======]
	function UnregisterUnitWatch(self)
		self = IGAS:GetUI(self)

		return _UnregisterUnitWatch(self)
	end

	doc [======[
		@name UnitWatchRegistered
		@type method
		@desc Check to see if a frame is registered
		@return boolean
	]======]
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