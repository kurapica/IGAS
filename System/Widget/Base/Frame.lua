-- Author      : Kurapica
-- Create Date : 6/12/2008 1:14:03 AM
-- ChangeLog
--				2011/03/12	Recode as class

----------------------------------------------------------------------------------------------------------------------------------------
--- Frame is in many ways the most fundamental widget object. Other types of widget derivatives such as FontStrings, Textures and Animations can only be created attached to a Frame or other derivative of a Frame. <br>
-- Frames provide the basis for interaction with the user, and registering and responding to game events.
-- <br><br>inherit <a href=".\Region.html">Region</a> For all methods, properties and scriptTypes
-- @name Frame
-- @class table
-- @field KeyboardEnabled whether keyboard interactivity is enabled for the frame
-- @field MouseEnabled whether mouse interactivity is enabled for the frame
-- @field MouseWheelEnabled whether mouse wheel interactivity is enabled for the frame
-- @field Backdrop the backdrop graphic for the frame
-- @field BackdropBorderColor the shading color for the frame's border graphic
-- @field BackdropColor the shading color for the frame's background graphic
-- @field ClampedToScreen whether the frame's boundaries are limited to those of the screen
-- @field ClampRectInsets offsets from the frame's edges used when limiting user movement or resizing of the frame
-- @field FrameLevel the level at which the frame is layered relative to others in its strata
-- @field FrameStrata the general layering strata of the frame
-- @field HitRectInsets the insets from the frame's edges which determine its mouse-interactable area
-- @field ID a numeric identifier for the frame
-- @field MaxResize the maximum size of the frame for user resizing
-- @field MinResize the minimum size of the frame for user resizing
-- @field Scale the frame's scale factor
-- @field Movable whether the frame can be moved by the user
-- @field Resizable whether the frame can be resized by the user
-- @field Toplevel whether the frame should automatically come to the front when clicked
-- @field Depth the 3D depth of the frame (for stereoscopic 3D setups)
-- @field DepthIgnored whether the frame's depth property is ignored (for stereoscopic 3D setups)
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 10
if not IGAS:NewAddon("IGAS.Widget.Frame", version) then
	return
end

class "Frame"
	inherit "Region"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when a frame attribute is changed
	-- @name Frame:OnAttributeChanged
	-- @class function
	-- @param name Name of the changed attribute, always lower case
	-- @param value New value of the attribute
	-- @usage function Frame:OnAttributeChanged(name, value)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnAttributeChanged"

	------------------------------------
	--- ScriptType, Run for each text character typed in the frame
	-- @name Frame:OnChar
	-- @class function
	-- @param text The text entered
	-- @usage function Frame:OnChar(text)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnChar"

	------------------------------------
	--- ScriptType, Run when the frame is disabled
	-- @name Frame:OnDisable
	-- @class function
	-- @usage function Frame:OnDisable()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnDisable"

	------------------------------------
	--- ScriptType, Run when the mouse is dragged starting in the frame
	-- @name Frame:OnDragStart
	-- @class function
	-- @param button Name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	-- @usage function Frame:OnDragStart(button)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnDragStart"

	------------------------------------
	--- ScriptType, Run when the mouse button is released after a drag started in the frame
	-- @name Frame:OnDragStop
	-- @class function
	-- @usage function Frame:OnDragStop()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnDragStop"

	------------------------------------
	--- ScriptType, Run when the frame is enabled
	-- @name Frame:OnEnable
	-- @class function
	-- @usage function Frame:OnEnable()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEnable"

	------------------------------------
	--- ScriptType, Run when the mouse cursor enters the frame's interactive area
	-- @name Frame:OnEnter
	-- @class function
	-- @param motion True if the handler is being run due to actual mouse movement; false if the cursor entered the frame due to other circumstances (such as the frame being created underneath the cursor)
	-- @usage function Frame:OnEnter(motion)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEnter"

	------------------------------------
	--- ScriptType, Run whenever an event fires for which the frame is registered
	-- @name Frame:OnEvent
	-- @class function
	-- @param event the event's name
	-- @param ... the event's parameters
	-- @usage function Frame:OnEvent("event", ...)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnEvent"

	------------------------------------
	--- ScriptType, Run when the frame's visbility changes to hidden
	-- @name Frame:OnHide
	-- @class function
	-- @usage function Frame:OnHide()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHide"

	------------------------------------
	--- ScriptType, Run when a keyboard key is pressed if the frame is keyboard enabled
	-- @name Frame:OnKeyDown
	-- @class function
	-- @param key Name of the key pressed
	-- @usage function Frame:OnKeyDown(key)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnKeyDown"

	------------------------------------
	--- ScriptType, Run when a keyboard key is released if the frame is keyboard enabled
	-- @name Frame:OnKeyUp
	-- @class function
	-- @param key Name of the key pressed
	-- @usage function Frame:OnKeyUp(key)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnKeyUp"

	------------------------------------
	--- ScriptType, Run when the mouse cursor leaves the frame's interactive area
	-- @name Frame:OnLeave
	-- @class function
	-- @param motion True if the handler is being run due to actual mouse movement; false if the cursor left the frame due to other circumstances (such as the frame being created underneath the cursor)
	-- @usage function Frame:OnLeave(motion)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnLeave"

	------------------------------------
	--- ScriptType, Run when the frame is created
	-- @name Frame:OnLoad
	-- @class function
	-- @usage function Frame:OnLoad()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnLoad"

	------------------------------------
	--- ScriptType, Run when a mouse button is pressed while the cursor is over the frame
	-- @name Frame:OnMouseDown
	-- @class function
	-- @param button Name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	-- @usage function Frame:OnMouseDown(button)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnMouseDown"

	------------------------------------
	--- ScriptType, Run when the mouse button is released following a mouse down action in the frame
	-- @name Frame:OnMouseUp
	-- @class function
	-- @param button Name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	-- @usage function Frame:OnMouseUp(button)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnMouseUp"

	------------------------------------
	--- ScriptType, Run when the frame receives a mouse wheel scrolling action
	-- @name Frame:OnMouseWheel
	-- @class function
	-- @param delta 1 for a scroll-up action, -1 for a scroll-down action
	-- @usage function Frame:OnMouseWheel(delta)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnMouseWheel"

	------------------------------------
	--- ScriptType, Run when the mouse button is released after dragging into the frame
	-- @name Frame:OnReceiveDrag
	-- @class function
	-- @usage function Frame:OnReceiveDrag()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnReceiveDrag"

	------------------------------------
	--- ScriptType, Run when the frame becomes visible
	-- @name Frame:OnShow
	-- @class function
	-- @usage function Frame:OnShow()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnShow"

	------------------------------------
	--- ScriptType, Run when a frame's size changes
	-- @name Frame:OnSizeChanged
	-- @class function
	-- @param width New width of the frame
	-- @param height New height of the frame
	-- @usage function Frame:OnSizeChanged(width, height)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnSizeChanged"

	------------------------------------
	--- ScriptType, Run each time the screen is drawn by the game engine
	-- @name Frame:OnUpdate
	-- @class function
	-- @param elapsed Number of seconds since the OnUpdate handlers were last run (likely a fraction of a second)
	-- @usage function Frame:OnUpdate(elapsed)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnUpdate"

	------------------------------------
	--- ScriptType, Run when a frame's minresize changes
	-- @name Frame:OnMinResizeChanged
	-- @class function
	-- @param width New width of the frame
	-- @param height New height of the frame
	-- @usage function Frame:OnMinResizeChanged(width, height)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnMinResizeChanged"

	------------------------------------
	--- ScriptType, Run when a frame's minresize changes
	-- @name Frame:OnMinResizeChanged
	-- @class function
	-- @param width New width of the frame
	-- @param height New height of the frame
	-- @usage function Frame:OnMinResizeChanged(width, height)<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnMaxResizeChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	-- Dispose, release resource
	function Dispose(self)
		UnregisterAllEvents(self)
	end

	------------------------------------
	--- Temporarily allows insecure code to modify the frame's attributes during combat. This permission is automatically rescinded when the frame's OnUpdate script next runs.
	-- @name Frame:AllowAttributeChanges
	-- @class function
	------------------------------------
	-- AllowAttributeChanges

	------------------------------------
	--- Returns whether secure frame attributes can currently be changed. Applies only to protected frames inheriting from one of the secure frame templates; frame attributes may only be changed by non-Blizzard scripts while the player is not in combat (or for a short time after a secure script calls :AllowAttributeChanges()).
	-- @name Frame:CanChangeAttribute
	-- @class function
	-- @return enabled - 1 if secure frame attributes can currently be changed; otherwise nil (1nil)
	------------------------------------
	-- CanChangeAttribute

	------------------------------------
	--- Creates a new FontString as a child of the frame
	-- @name Frame:CreateFontString
	-- @class function
	-- @param name Global name for the new font string (string)
	-- @param layer Graphic layer on which to create the font string; defaults to ARTWORK if not specified (string, layer)
	-- @param inherits Name of a template from which the new front string should inherit (string)
	-- @return fontstring - Reference to the new FontString object (fontstring)
	------------------------------------
	function CreateFontString(self, name, ...)
		return Widget["FontString"] and Widget["FontString"](name, self, ...)
	end

	------------------------------------
	--- Creates a new Texture as a child of the frame. The sublevel argument can be used to provide layering of textures within a draw layer. As it can be difficult to compute the proper layering, addon authors should avoid using this option, and it's XML equivalent textureSubLevel without reason. It should also be noted that FontStrings will always appear on top of all textures in a given draw layer.
	-- @name Frame:CreateTexture
	-- @class function
	-- @param name Global name for the new texture (string)
	-- @param layer Graphic layer on which to create the texture; defaults to ARTWORK if not specified (string, layer)
	-- @param inherits Name of a template from which the new texture should inherit (string)
	-- @param sublevel The sub-level on the given graphics layer ranging from -8- to 7. The default value of this argument is 0 (number)
	-- @return texture - Reference to the new Texture object (texture)
	------------------------------------
	function CreateTexture(self, name, ...)
		return Widget["Texture"] and Widget["Texture"](name, self, ...)
	end

	------------------------------------
	--- Creates a title region for dragging the frame. Creating a title region allows a frame to be repositioned by the user (by clicking and dragging in the region) without requiring additional scripts. (This behavior only applies if the frame is mouse enabled.)
	-- @name Frame:CreateTitleRegion
	-- @class function
	-- @return region - Reference to the new Region object (region)
	------------------------------------
	function CreateTitleRegion(self, ...)
		return IGAS:GetWrapper(self.__UI:CreateTitleRegion(...))
	end

	------------------------------------
	--- Prevents display of all child objects of the frame on a specified graphics layer
	-- @name Frame:DisableDrawLayer
	-- @class function
	-- @param layer Name of a graphics layer (string, layer)
	------------------------------------
	-- DisableDrawLayer

	------------------------------------
	--- Allows display of all child objects of the frame on a specified graphics layer
	-- @name Frame:EnableDrawLayer
	-- @class function
	-- @param layer Name of a graphics layer (string, layer)
	------------------------------------
	-- EnableDrawLayer

	------------------------------------
	--- Enables or disables joystick interactivity. Joystick interactivity must be enabled in order for a frame's joystick-related script handlers to be run.</p>
	--- <p>(As of this writing, joystick support is partially implemented but not enabled in the current version of World of Warcraft.)
	-- @name Frame:EnableJoystick
	-- @class function
	-- @param enable True to enable joystick interactivity; false to disable (boolean)
	------------------------------------
	-- EnableJoystick

	------------------------------------
	--- Enables or disables keyboard interactivity for the frame. Keyboard interactivity must be enabled in order for a frame's OnKeyDown, OnKeyUp, or OnChar scripts to be run.
	-- @name Frame:EnableKeyboard
	-- @class function
	-- @param enable True to enable keyboard interactivity; false to disable (boolean)
	------------------------------------
	function EnableKeyboard(self, enabled)
		if not self.InDesignMode then
			self.__UI:EnableKeyboard(enabled)
		else
			self.__KeyboardEnabled = (enabled and true) or false
		end
	end

	------------------------------------
	--- Enables or disables mouse interactivity for the frame. Mouse interactivity must be enabled in order for a frame's mouse-related script handlers to be run.
	-- @name Frame:EnableMouse
	-- @class function
	-- @param enable True to enable mouse interactivity; false to disable (boolean)
	------------------------------------
	function EnableMouse(self, enabled)
		if not self.InDesignMode then
			self.__UI:EnableMouse(enabled)
		else
			self.__MouseEnabled = (enabled and true) or false
		end
	end

	------------------------------------
	--- Enables or disables mouse wheel interactivity for the frame. Mouse wheel interactivity must be enabled in order for a frame's OnMouseWheel script handler to be run.
	-- @name Frame:EnableMouseWheel
	-- @class function
	-- @param enable True to enable mouse wheel interactivity; false to disable (boolean)
	------------------------------------
	-- EnableMouseWheel

	------------------------------------
	--- Returns the value of a secure frame attribute. See the secure template documentation for more information about frame attributes.
	-- @name Frame:GetAttribute
	-- @class function
	-- @param name Name of an attribute to query, case insensitive (string)
	-- @return value - Value of the named attribute (value)
	------------------------------------
	-- GetAttribute

	------------------------------------
	--- Returns information about the frame's backdrop graphic. See SetBackdrop.
	-- @name Frame:GetBackdrop
	-- @class function
	-- @return backdrop - A table containing the backdrop settings, or nil if the frame has no backdrop (table, backdrop)
	------------------------------------
	-- GetBackdrop

	------------------------------------
	--- Returns the shading color for the frame's border graphic
	-- @name Frame:GetBackdropBorderColor
	-- @class function
	-- @return red - Red component of the color (0.0 - 1.0) (number)
	-- @return green - Green component of the color (0.0 - 1.0) (number)
	-- @return blue - Blue component of the color (0.0 - 1.0) (number)
	-- @return alpha - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetBackdropBorderColor

	------------------------------------
	--- Returns the shading color for the frame's background graphic
	-- @name Frame:GetBackdropColor
	-- @class function
	-- @return red - Red component of the color (0.0 - 1.0) (number)
	-- @return green - Green component of the color (0.0 - 1.0) (number)
	-- @return blue - Blue component of the color (0.0 - 1.0) (number)
	-- @return alpha - Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetBackdropColor

	------------------------------------
	--- Returns the position and dimension of the smallest area enclosing the frame and its children. This information may not match that returned by :GetRect() if the frame contains textures, font strings, or child frames whose boundaries lie outside its own.
	-- @name Frame:GetBoundsRect
	-- @class function
	-- @return left - Distance from the left edge of the screen to the left edge of the area (in pixels) (number)
	-- @return bottom - Distance from the bottom edge of the screen to the bottom of the area (in pixels) (number)
	-- @return width - Width of the area (in pixels) (number)
	-- @return height - Height of the area (in pixels) (number)
	------------------------------------
	-- GetBoundsRect

	------------------------------------
	--- Returns a list of child frames of the frame
	-- @name Frame:GetChildren
	-- @class function
	-- @return ... - A list of the frames which are children of this frame (list)
	------------------------------------
	function GetChildren(self, ...)
		local lst = {self.__UI:GetChildren()}

		for i, v in ipairs(lst) do
			lst[i] = IGAS:GetWrapper(v)
		end

		return unpack(lst)
	end

	------------------------------------
	--- Returns offsets from the frame's edges used when limiting user movement or resizing of the frame. Note: despite the name of this method, the values are all offsets along the normal axes, so to inset the frame's clamping area from its edges, the left and bottom measurements should be positive and the right and top measurements should be negative.
	-- @name Frame:GetClampRectInsets
	-- @class function
	-- @return left - Offset from the left edge of the frame to the left edge of its clamping area (in pixels) (number)
	-- @return right - Offset from the right edge of the frame's clamping area to the right edge of the frame (in pixels) (number)
	-- @return top - Offset from the top edge of the frame's clamping area to the top edge of the frame (in pixels) (number)
	-- @return bottom - Offset from the bottom edge of the frame to the bottom edge of its clamping area (in pixels) (number)
	------------------------------------
	-- GetClampRectInsets

	------------------------------------
	--- Returns the 3D depth of the frame (for stereoscopic 3D setups)
	-- @name Frame:GetDepth
	-- @class function
	-- @return depth - Apparent 3D depth of this frame relative to that of its parent frame (number)
	------------------------------------
	-- GetDepth

	------------------------------------
	---
	-- @name Frame:GetDontSavePosition
	-- @class function
	------------------------------------
	-- GetDontSavePosition

	------------------------------------
	--- Returns the overall opacity of the frame. Unlike :GetAlpha() which returns the opacity of the frame relative to its parent, this function returns the absolute opacity of the frame, taking into account the relative opacity of parent frames.
	-- @name Frame:GetEffectiveAlpha
	-- @class function
	-- @return alpha - Effective alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetEffectiveAlpha

	------------------------------------
	--- Returns the overall 3D depth of the frame (for stereoscopic 3D configurations). Unlike :GetDepth() which returns the apparent depth of the frame relative to its parent, this function returns the absolute depth of the frame, taking into account the relative depths of parent frames.
	-- @name Frame:GetEffectiveDepth
	-- @class function
	-- @return depth - Apparent 3D depth of this frame relative to the screen (number)
	------------------------------------
	-- GetEffectiveDepth

	------------------------------------
	--- Returns the overall scale factor of the frame. Unlike :GetScale() which returns the scale factor of the frame relative to its parent, this function returns the absolute scale factor of the frame, taking into account the relative scales of parent frames.
	-- @name Frame:GetEffectiveScale
	-- @class function
	-- @return scale - Scale factor for the frame relative to its parent (number)
	------------------------------------
	-- GetEffectiveScale

	------------------------------------
	--- Sets the level at which the frame is layered relative to others in its strata. Frames with higher frame level are layered "in front of" frames with a lower frame level. When not set manually, a frame's level is determined by its place in the frame hierarchy -- e.g. UIParent's level is 1, children of UIParent are at level 2, children of those frames are at level 3, etc.
	-- @name Frame:GetFrameLevel
	-- @class function
	-- @return level - Layering level of the frame relative to others in its frameStrata (number)
	------------------------------------
	-- GetFrameLevel

	------------------------------------
	--- Returns the general layering strata of the frame
	-- @name Frame:GetFrameStrata
	-- @class function
	-- @return strata - Token identifying the strata in which the frame should be layered (string, frameStrata) <ul><li>BACKGROUND
	------------------------------------
	-- GetFrameStrata

	------------------------------------
	--- Returns the insets from the frame's edges which determine its mouse-interactable area
	-- @name Frame:GetHitRectInsets
	-- @class function
	-- @return left - Distance from the left edge of the frame to the left edge of its mouse-interactive area (in pixels) (number)
	-- @return right - Distance from the right edge of the frame to the right edge of its mouse-interactive area (in pixels) (number)
	-- @return top - Distance from the top edge of the frame to the top edge of its mouse-interactive area (in pixels) (number)
	-- @return bottom - Distance from the bottom edge of the frame to the bottom edge of its mouse-interactive area (in pixels) (number)
	------------------------------------
	-- GetHitRectInsets

	------------------------------------
	--- Returns the frame's numeric identifier. Frame IDs have no effect on frame behavior, but can be a useful way to keep track of multiple similar frames, especially in cases where a list of frames is created from a template (such as for action buttons, loot slots, or lines in a FauxScrollFrame).
	-- @name Frame:GetID
	-- @class function
	-- @return id - A numeric identifier for the frame (number)
	------------------------------------
	-- GetID

	------------------------------------
	--- Returns the maximum size of the frame for user resizing. Applies when resizing the frame with the mouse via :StartSizing().
	-- @name Frame:GetMaxResize
	-- @class function
	-- @return maxWidth - Maximum width of the frame (in pixels), or 0 for no limit (number)
	-- @return maxHeight - Maximum height of the frame (in pixels), or 0 for no limit (number)
	------------------------------------
	-- GetMaxResize

	------------------------------------
	--- Returns the minimum size of the frame for user resizing. Applies when resizing the frame with the mouse via :StartSizing().
	-- @name Frame:GetMinResize
	-- @class function
	-- @return minWidth - Minimum width of the frame (in pixels), or 0 for no limit (number)
	-- @return minHeight - Minimum height of the frame (in pixels), or 0 for no limit (number)
	------------------------------------
	-- GetMinResize

	------------------------------------
	--- Returns the number of child frames belonging to the frame
	-- @name Frame:GetNumChildren
	-- @class function
	-- @return numChildren - Number of child frames belonging to the frame (number)
	------------------------------------
	-- GetNumChildren

	------------------------------------
	--- Returns the number of non-Frame child regions belonging to the frame
	-- @name Frame:GetNumRegions
	-- @class function
	-- @return numRegions - Number of non-Frame child regions (FontStrings and Textures) belonging to the frame (number)
	------------------------------------
	-- GetNumRegions

	------------------------------------
	---
	-- @name Frame:GetPropagateKeyboardInput
	-- @class function
	------------------------------------
	-- GetPropagateKeyboardInput

	------------------------------------
	--- Returns a list of non-Frame child regions belonging to the frame
	-- @name Frame:GetRegions
	-- @class function
	-- @return ... - A list of each non-Frame child region (FontString or Texture) belonging to the frame (list)
	------------------------------------
	function GetRegions(self, ...)
		local lst = {self.__UI:GetRegions(...)}

		for i, v in ipairs(lst) do
			lst[i] = IGAS:GetWrapper(v)
		end

		return unpack(lst)
	end

	------------------------------------
	--- Returns the frame's scale factor
	-- @name Frame:GetScale
	-- @class function
	-- @return scale - Scale factor for the frame relative to its parent (number)
	------------------------------------
	-- GetScale

	------------------------------------
	--- Returns the frame's TitleRegion object. See :CreateTitleRegion() for more information.
	-- @name Frame:GetTitleRegion
	-- @class function
	-- @return region - Reference to the frame's TitleRegion object (region)
	------------------------------------
	function GetTitleRegion(self, ...)
		return IGAS:GetWrapper(self.__UI:GetTitleRegion(...))
	end

	------------------------------------
	--- Sets whether the frame's depth property is ignored (for stereoscopic 3D setups). If a frame's depth property is ignored, the frame itself is not rendered with stereoscopic 3D separation, but 3D graphics within the frame may be; this property is used on the default UI's WorldFrame.
	-- @name Frame:IgnoreDepth
	-- @class function
	-- @param enable True to ignore the frame's depth property; false to disable (boolean)
	------------------------------------
	-- IgnoreDepth

	------------------------------------
	--- Returns whether the frame's boundaries are limited to those of the screen
	-- @name Frame:IsClampedToScreen
	-- @class function
	-- @return enabled - 1 if the frame's boundaries are limited to those of the screen when user moving/resizing; otherwise nil (1nil)
	------------------------------------
	-- IsClampedToScreen

	------------------------------------
	--- Returns whether the frame's depth property is ignored (for stereoscopic 3D setups)
	-- @name Frame:IsIgnoringDepth
	-- @class function
	-- @return enabled - 1 if the frame's depth property is ignored; otherwise nil (1nil)
	------------------------------------
	-- IsIgnoringDepth

	------------------------------------
	--- Returns whether joystick interactivity is enabled for the frame. (As of this writing, joystick support is partially implemented but not enabled in the current version of World of Warcraft.)
	-- @name Frame:IsJoystickEnabled
	-- @class function
	-- @return enabled - 1 if joystick interactivity is enabled for the frame; otherwise nil (1nil)
	------------------------------------
	-- IsJoystickEnabled

	------------------------------------
	--- Returns whether keyboard interactivity is enabled for the frame
	-- @name Frame:IsKeyboardEnabled
	-- @class function
	-- @return enabled - 1 if keyboard interactivity is enabled for the frame; otherwise nil (1nil)
	------------------------------------
	function IsKeyboardEnabled(self, ...)
		if not self.InDesignMode then
			return (self.__UI:IsKeyboardEnabled() and true) or false
		else
			return (self.__KeyboardEnabled and true) or false
		end
	end

	------------------------------------
	--- Returns whether mouse interactivity is enabled for the frame
	-- @name Frame:IsMouseEnabled
	-- @class function
	-- @return enabled - 1 if mouse interactivity is enabled for the frame; otherwise nil (1nil)
	------------------------------------
	function IsMouseEnabled(self, ...)
		if not self.InDesignMode then
			return (self.__UI:IsMouseEnabled() and true) or false
		else
			return (self.__MouseEnabled and true) or false
		end
	end

	------------------------------------
	--- Returns whether mouse wheel interactivity is enabled for the frame
	-- @name Frame:IsMouseWheelEnabled
	-- @class function
	-- @return enabled - 1 if mouse wheel interactivity is enabled for the frame; otherwise nil (1nil)
	------------------------------------
	-- IsMouseWheelEnabled

	------------------------------------
	--- Returns whether the frame can be moved by the user
	-- @name Frame:IsMovable
	-- @class function
	-- @return movable - 1 if the frame can be moved by the user; otherwise nil (1nil)
	------------------------------------
	function IsMovable(self, ...)
		if not self.InDesignMode then
			return (self.__UI:IsMovable() and true) or false
		else
			return (self.__Movable and true) or false
		end
	end

	------------------------------------
	--- Returns whether the frame can be resized by the user
	-- @name Frame:IsResizable
	-- @class function
	-- @return enabled - 1 if the frame can be resized by the user; otherwise nil (1nil)
	------------------------------------
	function IsResizable(self, ...)
		if not self.InDesignMode then
			return (self.__UI:IsResizable() and true) or false
		else
			return (self.__Resizable and true) or false
		end
	end

	------------------------------------
	--- Returns whether the frame is automatically raised to the front when clicked
	-- @name Frame:IsToplevel
	-- @class function
	-- @return enabled - 1 if the frame is automatically raised to the front when clicked; otherwise nil (1nil)
	------------------------------------
	-- IsToplevel

	------------------------------------
	--- Returns whether the frame is flagged for automatic saving and restoration of position and dimensions
	-- @name Frame:IsUserPlaced
	-- @class function
	-- @return enabled - 1 if the frame is flagged for automatic saving and restoration of position and dimensions; otherwise nil (1nil)
	------------------------------------
	-- IsUserPlaced

	------------------------------------
	--- Reduces the frame's frame level below all other frames in its strata
	-- @name Frame:Lower
	-- @class function
	------------------------------------
	-- Lower

	------------------------------------
	--- Increases the frame's frame level above all other frames in its strata
	-- @name Frame:Raise
	-- @class function
	------------------------------------
	-- Raise

	------------------------------------
	--- Registers the frame for all events. This method is recommended for debugging purposes only, as using it will cause the frame's OnEvent script handler to be run very frequently for likely irrelevant events. (For code that needs to be run very frequently, use an OnUpdate script handler.)
	-- @name Frame:RegisterAllEvents
	-- @class function
	------------------------------------
	-- RegisterAllEvents

	------------------------------------
	--- Registers the frame for dragging. Once the frame is registered for dragging (and mouse enabled), the frame's OnDragStart and OnDragStop scripts will be called when the specified mouse button(s) are clicked and dragged starting from within the frame (or its mouse-interactive area).
	-- @name Frame:RegisterForDrag
	-- @class function
	-- @param ... A list of strings, each the name of a mouse button for which the frame should respond to drag actions (list) <ul><li>Button4
	------------------------------------
	-- RegisterForDrag

	------------------------------------
	--- Sets a secure frame attribute. See the secure template documentation for more information about frame attributes.
	-- @name Frame:SetAttribute
	-- @class function
	-- @param name Name of an attribute, case insensitive (string)
	-- @param value New value to set for the attribute (value)
	------------------------------------
	-- SetAttribute

	------------------------------------
	--- Sets a backdrop graphic for the frame. See example for details of the backdrop table format.
	-- @name Frame:SetBackdrop
	-- @class function
	-- @param backdrop A table containing the backdrop settings, or nil to remove the frame's backdrop (table, backdrop)
	------------------------------------
	function SetBackdrop(self, backdropTable)
		return self.__UI:SetBackdrop(backdropTable or nil)
	end

	------------------------------------
	--- Sets a shading color for the frame's border graphic. As with Texture:SetVertexColor(), this color is a shading applied to the colors of the texture image; a color of (1, 1, 1) allows the image's original colors to show.
	-- @name Frame:SetBackdropBorderColor
	-- @class function
	-- @param red Red component of the color (0.0 - 1.0) (number)
	-- @param green Green component of the color (0.0 - 1.0) (number)
	-- @param blue Blue component of the color (0.0 - 1.0) (number)
	-- @param alpha Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetBackdropBorderColor

	------------------------------------
	--- Sets a shading color for the frame's background graphic. As with Texture:SetVertexColor(), this color is a shading applied to the colors of the texture image; a color of (1, 1, 1) allows the image's original colors to show.
	-- @name Frame:SetBackdropColor
	-- @class function
	-- @param red Red component of the color (0.0 - 1.0) (number)
	-- @param green Green component of the color (0.0 - 1.0) (number)
	-- @param blue Blue component of the color (0.0 - 1.0) (number)
	-- @param alpha Alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetBackdropColor

	------------------------------------
	--- Sets whether the frame's boundaries should be limited to those of the screen. Applies to user moving/resizing of the frame (via :StartMoving(), :StartSizing(), or title region); attempting to move or resize the frame beyond the edges of the screen will move/resize it no further than the edge of the screen closest to the mouse position. Does not apply to programmatically setting the frame's position or size.
	-- @name Frame:SetClampedToScreen
	-- @class function
	-- @param enable True to limit the frame's boundaries to those of the screen; false to allow the frame to be moved/resized without such limits (boolean)
	------------------------------------
	-- SetClampedToScreen

	------------------------------------
	--- Sets offsets from the frame's edges used when limiting user movement or resizing of the frame. Note: despite the name of this method, the parameters are offsets along the normal axes -- to inset the frame's clamping area from its edges, the left and bottom measurements should be positive and the right and top measurements should be negative.
	-- @name Frame:SetClampRectInsets
	-- @class function
	-- @param left Offset from the left edge of the frame to the left edge of its clamping area (in pixels) (number)
	-- @param right Offset from the right edge of the frame's clamping area to the right edge of the frame (in pixels) (number)
	-- @param top Offset from the top edge of the frame's clamping area to the top edge of the frame (in pixels) (number)
	-- @param bottom Offset from the bottom edge of the frame to the bottom edge of its clamping area (in pixels) (number)
	------------------------------------
	-- SetClampRectInsets

	------------------------------------
	--- Sets the 3D depth of the frame (for stereoscopic 3D configurations)
	-- @name Frame:SetDepth
	-- @class function
	-- @param depth Apparent 3D depth of this frame relative to that of its parent frame (number)
	------------------------------------
	-- SetDepth

	------------------------------------
	---
	-- @name Frame:SetDontSavePosition
	-- @class function
	------------------------------------
	-- SetDontSavePosition

	------------------------------------
	--- Sets the level at which the frame is layered relative to others in its strata. Frames with higher frame level are layered "in front of" frames with a lower frame level.
	-- @name Frame:SetFrameLevel
	-- @class function
	-- @param level Layering level of the frame relative to others in its frameStrata (number)
	------------------------------------
	-- SetFrameLevel

	------------------------------------
	--- Sets the general layering strata of the frame. Where frame level provides fine control over the layering of frames, frame strata provides a coarser level of layering control: frames in a higher strata always appear "in front of" frames in lower strata regardless of frame level.
	-- @name Frame:SetFrameStrata
	-- @class function
	-- @param strata Token identifying the strata in which the frame should be layered (string, frameStrata)
	------------------------------------
	-- SetFrameStrata

	------------------------------------
	--- Sets the insets from the frame's edges which determine its mouse-interactable area
	-- @name Frame:SetHitRectInsets
	-- @class function
	-- @param left Distance from the left edge of the frame to the left edge of its mouse-interactive area (in pixels) (number)
	-- @param right Distance from the right edge of the frame to the right edge of its mouse-interactive area (in pixels) (number)
	-- @param top Distance from the top edge of the frame to the top edge of its mouse-interactive area (in pixels) (number)
	-- @param bottom Distance from the bottom edge of the frame to the bottom edge of its mouse-interactive area (in pixels) (number)
	------------------------------------
	-- SetHitRectInsets

	------------------------------------
	--- Sets a numeric identifier for the frame. Frame IDs have no effect on frame behavior, but can be a useful way to keep track of multiple similar frames, especially in cases where a list of frames is created from a template (such as for action buttons, loot slots, or lines in a FauxScrollFrame).
	-- @name Frame:SetID
	-- @class function
	-- @param id A numeric identifier for the frame (number)
	------------------------------------
	-- SetID

	------------------------------------
	--- Sets the maximum size of the frame for user resizing. Applies when resizing the frame with the mouse via :StartSizing().
	-- @name Frame:SetMaxResize
	-- @class function
	-- @param maxWidth Maximum width of the frame (in pixels), or 0 for no limit (number)
	-- @param maxHeight Maximum height of the frame (in pixels), or 0 for no limit (number)
	------------------------------------
	-- SetMaxResize
	function SetMaxResize(self, maxWidth, maxHeight)
		self.__UI:SetMaxResize(maxWidth, maxHeight)
		return self:Fire("OnMaxResizeChanged", maxWidth, maxHeight)
	end

	------------------------------------
	--- Sets the minimum size of the frame for user resizing. Applies when resizing the frame with the mouse via :StartSizing().
	-- @name Frame:SetMinResize
	-- @class function
	-- @param minWidth Minimum width of the frame (in pixels), or 0 for no limit (number)
	-- @param minHeight Minimum height of the frame (in pixels), or 0 for no limit (number)
	------------------------------------
	-- SetMinResize
	function SetMinResize(self, minWidth, minHeight)
		self.__UI:SetMinResize(minWidth, minHeight)
		return self:Fire("OnMinResizeChanged", minWidth, minHeight)
	end

	------------------------------------
	--- Sets whether the frame can be moved by the user. Enabling this property does not automatically implement behaviors allowing the frame to be dragged by the user -- such behavior must be implemented in the frame's mouse script handlers. If this property is not enabled, Frame:StartMoving() causes a Lua error.</p>
	--- <p>For simple automatic frame dragging behavior, see Frame:CreateTitleRegion().
	-- @name Frame:SetMovable
	-- @class function
	-- @param enable True to allow the frame to be moved by the user; false to disable (boolean)
	------------------------------------
	function SetMovable(self, enabled)
		if not self.InDesignMode then
			self.__UI:SetMovable(enabled)
		else
			self.__Movable = (enabled and true) or false
		end
	end

	------------------------------------
	---
	-- @name Frame:SetPropagateKeyboardInput
	-- @class function
	------------------------------------
	-- SetPropagateKeyboardInput

	------------------------------------
	--- Sets whether the frame can be resized by the user. Enabling this property does not automatically implement behaviors allowing the frame to be drag-resized by the user -- such behavior must be implemented in the frame's mouse script handlers. If this property is not enabled, Frame:StartSizing() causes a Lua error.
	-- @name Frame:SetResizable
	-- @class function
	-- @param enable True to allow the frame to be resized by the user; false to disable (boolean)
	------------------------------------
	function SetResizable(self, enabled)
		if not self.InDesignMode then
			self.__UI:SetResizable(enabled)
		else
			self.__Resizable = (enabled and true) or false
		end
	end

	------------------------------------
	--- Sets the frame's scale factor. A frame's scale factor affects the size at which it appears on the screen relative to that of its parent. The entire interface may be scaled by changing UIParent's scale factor (as can be done via the Use UI Scale setting in the default interface's Video Options panel).
	-- @name Frame:SetScale
	-- @class function
	-- @param scale Scale factor for the frame relative to its parent (number)
	------------------------------------
	-- SetScale

	------------------------------------
	--- Sets whether the frame should automatically come to the front when clicked. When a frame with Toplevel behavior enabled is clicked, it automatically changes its frame level such that it is greater than (and therefore drawn "in front of") all other frames in its strata.
	-- @name Frame:SetToplevel
	-- @class function
	-- @param enable True to cause the frame to automatically come to the front when clicked; false otherwise (boolean)
	------------------------------------
	-- SetToplevel

	------------------------------------
	--- Flags the frame for automatic saving and restoration of position and dimensions. The position and size of frames so flagged is automatically saved when the UI is shut down (as when quitting, logging out, or reloading) and restored when the UI next starts up (as when logging in or reloading). If the frame does not have a name (set at creation time) specified, its position will not be saved. As implied by its name, enabling this property is useful for frames which can be moved or resized by the user.</p>
	--- <p>This function is automatically called with the value true when frame:StartMoving() is called.
	-- @name Frame:SetUserPlaced
	-- @class function
	-- @param enable True to enable automatic saving and restoration of the frame's position and dimensions; false to disable (boolean)
	------------------------------------
	-- SetUserPlaced

	------------------------------------
	--- Begins repositioning the frame via mouse movement
	-- @name Frame:StartMoving
	-- @class function
	------------------------------------
	-- StartMoving

	------------------------------------
	--- Begins resizing the frame via mouse movement
	-- @name Frame:StartSizing
	-- @class function
	------------------------------------
	-- StartSizing

	------------------------------------
	--- Ends movement or resizing of the frame initiated with :StartMoving() or :StartSizing()
	-- @name Frame:StopMovingOrSizing
	-- @class function
	------------------------------------
	-- StopMovingOrSizing

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	-- KeyboardEnabled
	property "KeyboardEnabled" {
		Get = function(self)
			return self:IsKeyboardEnabled()
		end,
		Set = function(self, enabled)
			self:EnableKeyboard(enabled)
		end,
		Type = Boolean,
	}
	-- MouseEnabled
	property "MouseEnabled" {
		Get = function(self)
			return self:IsMouseEnabled()
		end,
		Set = function(self, enabled)
			self:EnableMouse(enabled)
		end,
		Type = Boolean,
	}
	-- Movable
	property "Movable" {
		Get = function(self)
			return self:IsMovable()
		end,
		Set = function(self, enabled)
			self:SetMovable(enabled)
		end,
		Type = Boolean,
	}
	-- Resizable
	property "Resizable" {
		Get = function(self)
			return self:IsResizable()
		end,
		Set = function(self, enabled)
			self:SetResizable(enabled)
		end,
		Type = Boolean,
	}
	-- MouseWheelEnabled
	property "MouseWheelEnabled" {
		Get = function(self)
			return (self:IsMouseWheelEnabled() and true) or false
		end,
		Set = function(self, enabled)
			self:EnableMouseWheel(enabled)
		end,
		Type = Boolean,
	}
	-- Backdrop
	property "Backdrop" {
		Get = function(self)
			return self:GetBackdrop()
		end,
		Set = function(self, backdropTable)
			self:SetBackdrop(backdropTable)
		end,
		Type = BackdropType,
	}
	-- BackdropBorderColor
	property "BackdropBorderColor" {
		Get = function(self)
			return ColorType(self:GetBackdropBorderColor())
		end,
		Set = function(self, colorTable)
			self:SetBackdropBorderColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
		end,
		Type = ColorType,
	}
	-- BackdropColor
	property "BackdropColor" {
		Get = function(self)
			return ColorType(self:GetBackdropColor())
		end,
		Set = function(self, colorTable)
			self:SetBackdropColor(colorTable.r, colorTable.g, colorTable.b, colorTable.a)
		end,
		Type = ColorType,
	}
	-- ClampedToScreen
	property "ClampedToScreen" {
		Get = function(self)
			return (self:IsClampedToScreen() and true) or false
		end,
		Set = function(self, enabled)
			self:SetClampedToScreen(enabled)
		end,
		Type = Boolean,
	}
	-- ClampRectInsets
	property "ClampRectInsets" {
		Get = function(self)
			return Inset(self:GetClampRectInsets())
		end,
		Set = function(self, RectInset)
			self:SetClampRectInsets(RectInset.left, RectInset.right, RectInset.top, RectInset.bottom)
		end,
		Type = Inset,
	}
	-- FrameLevel
	property "FrameLevel" {
		Get = function(self)
			return self:GetFrameLevel()
		end,
		Set = function(self, level)
			self:SetFrameLevel(level)
		end,
		Type = Number,
	}
	-- FrameStrata
	property "FrameStrata" {
		Get = function(self)
			return self:GetFrameStrata()
		end,
		Set = function(self, strata)
			self:SetFrameStrata(strata)
		end,
		Type = FrameStrata,
	}
	-- HitRectInsets
	property "HitRectInsets" {
		Get = function(self)
			return Inset(self:GetHitRectInsets())
		end,
		Set = function(self, RectInset)
			self:SetHitRectInsets(RectInset.left, RectInset.right, RectInset.top, RectInset.bottom)
		end,
		Type = Inset,
	}
	-- ID
	property "ID" {
		Get = function(self)
			return self:GetID()
		end,
		Set = function(self, id)
			self:SetID(id)
		end,
		Type = Number,
	}
	-- MaxResize
	property "MaxResize" {
		Get = function(self)
			return Size(self:GetMaxResize())
		end,
		Set = function(self, size)
			self:SetMaxResize(size.width, size.height)
		end,
		Type = Size,
	}
	-- MinResize
	property "MinResize" {
		Get = function(self)
			return Size(self:GetMinResize())
		end,
		Set = function(self, size)
			self:SetMinResize(size.width, size.height)
		end,
		Type = Size,
	}
	-- Scale
	property "Scale" {
		Get = function(self)
			return self:GetScale()
		end,
		Set = function(self, scale)
			self:SetScale(scale)
		end,
		Type = Number,
	}
	-- Toplevel
	property "Toplevel" {
		Get = function(self)
			return (self:IsToplevel() and true) or false
		end,
		Set = function(self, enabled)
			self:SetToplevel(enabled)
		end,
		Type = Boolean,
	}
	-- Depth
	property "Depth" {
		Get = function(self)
			return self:GetDepth()
		end,
		Set = function(self, depth)
			self:SetDepth(depth)
		end,
		Type = Number,
	}
	-- DepthIgnored
	property "DepthIgnored" {
		Get = function(self)
			return (self:IsIgnoringDepth() and true) or false
		end,
		Set = function(self, enabled)
			self:IgnoreDepth(enabled)
		end,
		Type = Boolean,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
	function Constructor(self, name, parent, ...)
		return CreateFrame("Frame", nil, parent, ...)
	end
endclass "Frame"

partclass "Frame"
	------------------------------------------------------
	-- BlzMethodes
	------------------------------------------------------
	StoreBlzMethod(Frame)
endclass "Frame"