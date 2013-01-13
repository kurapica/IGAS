-- Author      : Kurapica
-- Create Date : 6/12/2008 1:14:03 AM
-- ChangeLog
--				2011/03/12	Recode as class

-- Check Version
local version = 10
if not IGAS:NewAddon("IGAS.Widget.Frame", version) then
	return
end

class "Frame"
	inherit "Region"

	doc [======[
		@name Frame
		@type class
		@desc Frame is in many ways the most fundamental widget object. Other types of widget derivatives such as FontStrings, Textures and Animations can only be created attached to a Frame or other derivative of a Frame.
		@format name[, parent[, inherit]]
		@param name string, the name of the frame, accessed by it's parent
		@param parent System.Widget.Region, default UIParent
		@param inherit string, blizzard's template
	]======]

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	doc [======[
		@name OnAttributeChanged
		@type script
		@desc Run when a frame attribute is changed
		@param name string, name of the changed attribute, always lower case
		@param value any, new value of the attribute
	]======]
	script "OnAttributeChanged"

	doc [======[
		@name OnChar
		@type script
		@desc Run for each text character typed in the frame
		@param char string, the text character typed
	]======]
	script "OnChar"

	doc [======[
		@name OnDisable
		@type script
		@desc Run when the frame is disabled
	]======]
	script "OnDisable"

	doc [======[
		@name OnDragStart
		@type script
		@desc Run when the mouse is dragged starting in the frame
		@param button string, name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	]======]
	script "OnDragStart"

	doc [======[
		@name OnDragStop
		@type script
		@desc Run when the mouse button is released after a drag started in the frame
	]======]
	script "OnDragStop"

	doc [======[
		@name OnEnable
		@type script
		@desc Run when the frame is enabled
	]======]
	script "OnEnable"

	doc [======[
		@name OnEnter
		@type script
		@desc Run when the mouse cursor enters the frame's interactive area
		@param motion boolean, true if the handler is being run due to actual mouse movement; false if the cursor entered the frame due to other circumstances (such as the frame being created underneath the cursor)
	]======]
	script "OnEnter"

	doc [======[
		@name OnEvent
		@type script
		@desc Run whenever an event fires for which the frame is registered
		@format event[, ...]
		@param event string, the event's name
		@param ... the event's parameters
	]======]
	script "OnEvent"

	doc [======[
		@name OnHide
		@type script
		@desc Run when the frame's visbility changes to hidden
	]======]
	script "OnHide"

	doc [======[
		@name OnKeyDown
		@type script
		@desc Run when a keyboard key is pressed if the frame is keyboard enabled
		@param key string, name of the key pressed
	]======]
	script "OnKeyDown"

	doc [======[
		@name OnKeyUp
		@type script
		@desc Run when a keyboard key is released if the frame is keyboard enabled
		@param key string, name of the key pressed
	]======]
	script "OnKeyUp"

	doc [======[
		@name OnLeave
		@type script
		@desc Run when the mouse cursor leaves the frame's interactive area
		@param motion boolean, true if the handler is being run due to actual mouse movement; false if the cursor left the frame due to other circumstances (such as the frame being created underneath the cursor)
	]======]
	script "OnLeave"

	doc [======[
		@name OnLoad
		@type script
		@desc Run when the frame is created, no using in IGAS coding
	]======]
	script "OnLoad"

	doc [======[
		@name OnMouseDown
		@type script
		@desc Run when a mouse button is pressed while the cursor is over the frame
		@param button string, name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	]======]
	script "OnMouseDown"

	doc [======[
		@name OnMouseUp
		@type script
		@desc Run when the mouse button is released following a mouse down action in the frame
		@param button string, name of the mouse button responsible for the click action:Button4, Button5, LeftButton, MiddleButton, RightButton
	]======]
	script "OnMouseUp"

	doc [======[
		@name OnMouseWheel
		@type script
		@desc Run when the frame receives a mouse wheel scrolling action
		@param delta number, 1 for a scroll-up action, -1 for a scroll-down action
	]======]
	script "OnMouseWheel"

	doc [======[
		@name OnReceiveDrag
		@type script
		@desc Run when the mouse button is released after dragging into the frame
	]======]
	script "OnReceiveDrag"

	doc [======[
		@name OnShow
		@type script
		@desc Run when the frame becomes visible
	]======]
	script "OnShow"

	doc [======[
		@name OnSizeChanged
		@type script
		@desc Run when a frame's size changes
		@param width number, new width of the frame
		@param height number, new height of the frame
	]======]
	script "OnSizeChanged"

	doc [======[
		@name OnUpdate
		@type script
		@desc Run each time the screen is drawn by the game engine
		@param elapsed number, number of seconds since the OnUpdate handlers were last run (likely a fraction of a second)
	]======]
	script "OnUpdate"

	doc [======[
		@name OnMinResizeChanged
		@type script
		@desc Run when a frame's minresize changes
		@param width number, new width of the frame
		@param height number, new height of the frame
	]======]
	script "OnMinResizeChanged"

	doc [======[
		@name OnMaxResizeChanged
		@type script
		@desc Run when a frame's minresize changes
		@param width number, new width of the frame
		@param height number, new height of the frame
	]======]
	script "OnMaxResizeChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name AllowAttributeChanges
		@type method
		@desc Temporarily allows insecure code to modify the frame's attributes during combat. This permission is automatically rescinded when the frame's OnUpdate script next runs.
		@return nil
	]======]

	doc [======[
		@name CanChangeAttribute
		@type method
		@desc Returns whether secure frame attributes can currently be changed. Applies only to protected frames inheriting from one of the secure frame templates; frame attributes may only be changed by non-Blizzard scripts while the player is not in combat (or for a short time after a secure script calls :AllowAttributeChanges()).
		@return boolean 1 if secure frame attributes can currently be changed; otherwise nil
	]======]

	doc [======[
		@name CreateFontString
		@type method
		@desc Creates a new FontString as a child of the frame
		@format name[, layer[, inherits]]
		@param name string, global name for the new font string
		@param layer System.Widget.DrawLayer, graphic layer on which to create the font string; defaults to ARTWORK if not specified
		@param inherits string, name of a template from which the new front string should inherit
		@return System.Widget.FontString Reference to the new FontString object
	]======]
	function CreateFontString(self, name, ...)
		return Widget["FontString"] and Widget["FontString"](name, self, ...)
	end

	doc [======[
		@name CreateTexture
		@type method
		@desc Creates a new Texture as a child of the frame. The sublevel argument can be used to provide layering of textures within a draw layer. As it can be difficult to compute the proper layering, addon authors should avoid using this option, and it's XML equivalent textureSubLevel without reason. It should also be noted that FontStrings will always appear on top of all textures in a given draw layer.
		@format name[, layer[, inherits][, sublevel]]
		@param name string, global name for the new texture
		@param layer System.Widget.DrawLayer, graphic layer on which to create the texture; defaults to ARTWORK if not specified
		@param inherits string, name of a template from which the new texture should inherit
		@param sublevel number, the sub-level on the given graphics layer ranging from -8- to 7. The default value of this argument is 0
		@return System.Widget.Texture Reference to the new Texture object
	]======]
	function CreateTexture(self, name, ...)
		return Widget["Texture"] and Widget["Texture"](name, self, ...)
	end

	doc [======[
		@name CreateTitleRegion
		@type method
		@desc Creates a title region for dragging the frame. Creating a title region allows a frame to be repositioned by the user (by clicking and dragging in the region) without requiring additional scripts. (This behavior only applies if the frame is mouse enabled.)
		@return System.Widget.Region Reference to the new Region object
	]======]
	function CreateTitleRegion(self, ...)
		return IGAS:GetWrapper(self.__UI:CreateTitleRegion(...))
	end

	doc [======[
		@name DisableDrawLayer
		@type method
		@desc Prevents display of all child objects of the frame on a specified graphics layer
		@param layer System.Widget.DrawLayer, name of a graphics layer
		@return nil
	]======]

	doc [======[
		@name EnableDrawLayer
		@type method
		@desc Allows display of all child objects of the frame on a specified graphics layer
		@param layer System.Widget.DrawLayer, name of a graphics layer
		@return nil
	]======]

	doc [======[
		@name EnableJoystick
		@type method
		@desc Enables or disables joystick interactivity. Joystick interactivity must be enabled in order for a frame's joystick-related script handlers to be run.
		@param enable boolean, true to enable joystick interactivity; false to disable
		@return nil
	]======]

	doc [======[
		@name EnableKeyboard
		@type method
		@desc Enables or disables keyboard interactivity for the frame. Keyboard interactivity must be enabled in order for a frame's OnKeyDown, OnKeyUp, or OnChar scripts to be run.
		@param enable boolean, true to enable keyboard interactivity; false to disable
		@return nil
	]======]
	function EnableKeyboard(self, enabled)
		if not self.InDesignMode then
			self.__UI:EnableKeyboard(enabled)
		else
			self.__KeyboardEnabled = (enabled and true) or false
		end
	end

	doc [======[
		@name EnableMouse
		@type method
		@desc Enables or disables mouse interactivity for the frame. Mouse interactivity must be enabled in order for a frame's mouse-related script handlers to be run.
		@param enable boolean, true to enable mouse interactivity; false to disable
		@return nil
	]======]
	function EnableMouse(self, enabled)
		if not self.InDesignMode then
			self.__UI:EnableMouse(enabled)
		else
			self.__MouseEnabled = (enabled and true) or false
		end
	end

	doc [======[
		@name EnableMouseWheel
		@type method
		@desc Enables or disables mouse wheel interactivity for the frame. Mouse wheel interactivity must be enabled in order for a frame's OnMouseWheel script handler to be run.
		@param enable boolean, true to enable mouse wheel interactivity; false to disable
		@return nil
	]======]

	doc [======[
		@name GetAttribute
		@type method
		@desc Returns the value of a secure frame attribute. See the secure template documentation for more information about frame attributes.
		@param name string, name of an attribute to query, case insensitive
		@return any Value of the named attribute
	]======]

	doc [======[
		@name GetBackdrop
		@type method
		@desc Returns information about the frame's backdrop graphic.
		@return System.Widget.BackdropType A table containing the backdrop settings, or nil if the frame has no backdrop
	]======]

	doc [======[
		@name GetBackdropBorderColor
		@type method
		@desc Returns the shading color for the frame's border graphic
		@return red number, red component of the color (0.0 - 1.0)
		@return green number, green component of the color (0.0 - 1.0)
		@return blue number, blue component of the color (0.0 - 1.0)
		@return alpha number, alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name GetBackdropColor
		@type method
		@desc Returns the shading color for the frame's background graphic
		@return red number, red component of the color (0.0 - 1.0)
		@return green number, green component of the color (0.0 - 1.0)
		@return blue number, blue component of the color (0.0 - 1.0)
		@return alpha number, alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name GetBoundsRect
		@type method
		@desc Returns the position and dimension of the smallest area enclosing the frame and its children. This information may not match that returned by :GetRect() if the frame contains textures, font strings, or child frames whose boundaries lie outside its own.
		@return left number, distance from the left edge of the screen to the left edge of the area (in pixels)
		@return bottom number, distance from the bottom edge of the screen to the bottom of the area (in pixels)
		@return width number, width of the area (in pixels)
		@return height number, height of the area (in pixels)
	]======]

	doc [======[
		@name GetChildren
		@type method
		@desc Returns a list of child frames of the frame
		@return ... A list of the frames which are children of this frame
	]======]
	function GetChildren(self, ...)
		local lst = {self.__UI:GetChildren()}

		for i, v in ipairs(lst) do
			lst[i] = IGAS:GetWrapper(v)
		end

		return unpack(lst)
	end

	doc [======[
		@name GetClampRectInsets
		@type method
		@desc Returns offsets from the frame's edges used when limiting user movement or resizing of the frame. Note: despite the name of this method, the values are all offsets along the normal axes, so to inset the frame's clamping area from its edges, the left and bottom measurements should be positive and the right and top measurements should be negative.
		@return left number, offset from the left edge of the frame to the left edge of its clamping area (in pixels)
		@return right number, offset from the right edge of the frame's clamping area to the right edge of the frame (in pixels)
		@return top number, offset from the top edge of the frame's clamping area to the top edge of the frame (in pixels)
		@return bottom number, offset from the bottom edge of the frame to the bottom edge of its clamping area (in pixels)
	]======]

	doc [======[
		@name GetDepth
		@type method
		@desc Returns the 3D depth of the frame (for stereoscopic 3D setups)
		@return number apparent 3D depth of this frame relative to that of its parent frame
	]======]

	doc [======[
		@name GetDontSavePosition
		@type method
		@desc
		@return boolean
	]======]

	doc [======[
		@name GetEffectiveAlpha
		@type method
		@desc Returns the overall opacity of the frame. Unlike :GetAlpha() which returns the opacity of the frame relative to its parent, this function returns the absolute opacity of the frame, taking into account the relative opacity of parent frames.
		@return number, effective alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name GetEffectiveDepth
		@type method
		@desc Returns the overall 3D depth of the frame (for stereoscopic 3D configurations). Unlike :GetDepth() which returns the apparent depth of the frame relative to its parent, this function returns the absolute depth of the frame, taking into account the relative depths of parent frames.
		@return number, apparent 3D depth of this frame relative to the screen
	]======]

	doc [======[
		@name GetEffectiveScale
		@type method
		@desc Returns the overall scale factor of the frame. Unlike :GetScale() which returns the scale factor of the frame relative to its parent, this function returns the absolute scale factor of the frame, taking into account the relative scales of parent frames.
		@return number, scale factor for the frame relative to its parent
	]======]

	doc [======[
		@name GetFrameLevel
		@type method
		@desc Gets the level at which the frame is layered relative to others in its strata. Frames with higher frame level are layered "in front of" frames with a lower frame level. When not set manually, a frame's level is determined by its place in the frame hierarchy -- e.g. UIParent's level is 1, children of UIParent are at level 2, children of those frames are at level 3, etc.
		@return number, layering level of the frame relative to others in its frameStrata
	]======]

	doc [======[
		@name GetFrameStrata
		@type method
		@desc Returns the general layering strata of the frame
		@return System.Widget.FrameStrata Token identifying the strata in which the frame should be layered
	]======]

	doc [======[
		@name GetHitRectInsets
		@type method
		@desc Returns the insets from the frame's edges which determine its mouse-interactable area
		@return left number, distance from the left edge of the frame to the left edge of its mouse-interactive area (in pixels)
		@return right number, distance from the right edge of the frame to the right edge of its mouse-interactive area (in pixels)
		@return top number, distance from the top edge of the frame to the top edge of its mouse-interactive area (in pixels)
		@return bottom number, distance from the bottom edge of the frame to the bottom edge of its mouse-interactive area (in pixels)
	]======]

	doc [======[
		@name GetID
		@type method
		@desc Returns the frame's numeric identifier. Frame IDs have no effect on frame behavior, but can be a useful way to keep track of multiple similar frames, especially in cases where a list of frames is created from a template (such as for action buttons, loot slots, or lines in a FauxScrollFrame).
		@return number, a numeric identifier for the frame
	]======]

	doc [======[
		@name GetMaxResize
		@type method
		@desc Returns the maximum size of the frame for user resizing. Applies when resizing the frame with the mouse via :StartSizing().
		@return maxWidth number, maximum width of the frame (in pixels), or 0 for no limit
		@return maxHeight number, maximum height of the frame (in pixels), or 0 for no limit
	]======]

	doc [======[
		@name GetMinResize
		@type method
		@desc Returns the minimum size of the frame for user resizing. Applies when resizing the frame with the mouse via :StartSizing().
		@return minWidth number, minimum width of the frame (in pixels), or 0 for no limit
		@return minHeight number, minimum height of the frame (in pixels), or 0 for no limit
	]======]

	doc [======[
		@name GetNumChildren
		@type method
		@desc Returns the number of child frames belonging to the frame
		@return number Number of child frames belonging to the frame
	]======]

	doc [======[
		@name GetNumRegions
		@type method
		@desc Returns the number of non-Frame child regions belonging to the frame
		@return number Number of non-Frame child regions (FontStrings and Textures) belonging to the frame
	]======]

	doc [======[
		@name GetPropagateKeyboardInput
		@type method
		@desc
		@return boolean
	]======]

	doc [======[
		@name GetRegions
		@type method
		@desc Returns a list of non-Frame child regions belonging to the frame
		@return ... - A list of each non-Frame child region (FontString or Texture) belonging to the frame (list)
	]======]
	function GetRegions(self, ...)
		local lst = {self.__UI:GetRegions(...)}

		for i, v in ipairs(lst) do
			lst[i] = IGAS:GetWrapper(v)
		end

		return unpack(lst)
	end

	doc [======[
		@name GetScale
		@type method
		@desc Returns the frame's scale factor
		@return number Scale factor for the frame relative to its parent
	]======]

	doc [======[
		@name GetTitleRegion
		@type method
		@desc Returns the frame's TitleRegion object.
		@return System.Widget.Region Reference to the frame's TitleRegion object
	]======]
	function GetTitleRegion(self, ...)
		return IGAS:GetWrapper(self.__UI:GetTitleRegion(...))
	end

	doc [======[
		@name IgnoreDepth
		@type method
		@desc Sets whether the frame's depth property is ignored (for stereoscopic 3D setups). If a frame's depth property is ignored, the frame itself is not rendered with stereoscopic 3D separation, but 3D graphics within the frame may be; this property is used on the default UI's WorldFrame.
		@param enable boolean, true to ignore the frame's depth property; false to disable
		@return nil
	]======]

	doc [======[
		@name IsClampedToScreen
		@type method
		@desc Returns whether the frame's boundaries are limited to those of the screen
		@return boolean 1 if the frame's boundaries are limited to those of the screen when user moving/resizing; otherwise nil
	]======]

	doc [======[
		@name IsIgnoringDepth
		@type method
		@desc Returns whether the frame's depth property is ignored (for stereoscopic 3D setups)
		@return boolean 1 if the frame's depth property is ignored; otherwise nil
	]======]

	doc [======[
		@name IsJoystickEnabled
		@type method
		@desc Returns whether joystick interactivity is enabled for the frame. (As of this writing, joystick support is partially implemented but not enabled in the current version of World of Warcraft.)
		@return boolean 1 if joystick interactivity is enabled for the frame; otherwise nil
	]======]

	doc [======[
		@name IsKeyboardEnabled
		@type method
		@desc Returns whether keyboard interactivity is enabled for the frame
		@return boolean 1 if keyboard interactivity is enabled for the frame; otherwise nil
	]======]
	function IsKeyboardEnabled(self, ...)
		if not self.InDesignMode then
			return (self.__UI:IsKeyboardEnabled() and true) or false
		else
			return (self.__KeyboardEnabled and true) or false
		end
	end

	doc [======[
		@name IsMouseEnabled
		@type method
		@desc Returns whether mouse interactivity is enabled for the frame
		@return boolean 1 if mouse interactivity is enabled for the frame; otherwise nil
	]======]
	function IsMouseEnabled(self, ...)
		if not self.InDesignMode then
			return (self.__UI:IsMouseEnabled() and true) or false
		else
			return (self.__MouseEnabled and true) or false
		end
	end

	doc [======[
		@name IsMouseWheelEnabled
		@type method
		@desc Returns whether mouse wheel interactivity is enabled for the frame
		@return boolean 1 if mouse wheel interactivity is enabled for the frame; otherwise nil
	]======]

	doc [======[
		@name IsMovable
		@type method
		@desc Returns whether the frame can be moved by the user
		@return boolean 1 if the frame can be moved by the user; otherwise nil
	]======]
	function IsMovable(self, ...)
		if not self.InDesignMode then
			return (self.__UI:IsMovable() and true) or false
		else
			return (self.__Movable and true) or false
		end
	end

	doc [======[
		@name IsResizable
		@type method
		@desc Returns whether the frame can be resized by the user
		@return boolean 1 if the frame can be resized by the user; otherwise nil
	]======]
	function IsResizable(self, ...)
		if not self.InDesignMode then
			return (self.__UI:IsResizable() and true) or false
		else
			return (self.__Resizable and true) or false
		end
	end

	doc [======[
		@name IsToplevel
		@type method
		@desc Returns whether the frame is automatically raised to the front when clicked
		@return boolean 1 if the frame is automatically raised to the front when clicked; otherwise nil
	]======]

	doc [======[
		@name IsUserPlaced
		@type method
		@desc Returns whether the frame is flagged for automatic saving and restoration of position and dimensions
		@return boolean 1 if the frame is flagged for automatic saving and restoration of position and dimensions; otherwise nil
	]======]

	doc [======[
		@name Lower
		@type method
		@desc Reduces the frame's frame level below all other frames in its strata
		@return nil
	]======]

	doc [======[
		@name Raise
		@type method
		@desc Increases the frame's frame level above all other frames in its strata
		@return nil
	]======]

	doc [======[
		@name RegisterAllEvents
		@type method
		@desc Registers the frame for all events. This method is recommended for debugging purposes only, as using it will cause the frame's OnEvent script handler to be run very frequently for likely irrelevant events. (For code that needs to be run very frequently, use an OnUpdate script handler.)
		@return nil
	]======]

	doc [======[
		@name RegisterForDrag
		@type method
		@desc Registers the frame for dragging. Once the frame is registered for dragging (and mouse enabled), the frame's OnDragStart and OnDragStop scripts will be called when the specified mouse button(s) are clicked and dragged starting from within the frame (or its mouse-interactive area).
		@param ... A list of strings, each the name of a mouse button for which the frame should respond to drag actions
		@return nil
	]======]

	doc [======[
		@name SetAttribute
		@type method
		@desc Sets a secure frame attribute. See the secure template documentation for more information about frame attributes.
		@param name string, name of an attribute, case insensitive
		@param value any, new value to set for the attribute
		@return nil
	]======]

	doc [======[
		@name SetBackdrop
		@type method
		@desc Sets a backdrop graphic for the frame. See example for details of the backdrop table format.
		@param backdrop System.Widget.BackdropType A table containing the backdrop settings, or nil to remove the frame's backdrop
		@return nil
	]======]
	function SetBackdrop(self, backdropTable)
		return self.__UI:SetBackdrop(backdropTable or nil)
	end

	doc [======[
		@name SetBackdropBorderColor
		@type method
		@desc Sets a shading color for the frame's border graphic. As with Texture:SetVertexColor(), this color is a shading applied to the colors of the texture image; a color of (1, 1, 1) allows the image's original colors to show.
		@param red number, red component of the color (0.0 - 1.0)
		@param green number, green component of the color (0.0 - 1.0)
		@param blue number, blue component of the color (0.0 - 1.0)
		@param alpha number, alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name SetBackdropColor
		@type method
		@desc Sets a shading color for the frame's background graphic. As with Texture:SetVertexColor(), this color is a shading applied to the colors of the texture image; a color of (1, 1, 1) allows the image's original colors to show.
		@param red number, red component of the color (0.0 - 1.0)
		@param green number, green component of the color (0.0 - 1.0)
		@param blue number, blue component of the color (0.0 - 1.0)
		@param alpha number, alpha (opacity) for the graphic (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name SetClampedToScreen
		@type method
		@desc Sets whether the frame's boundaries should be limited to those of the screen. Applies to user moving/resizing of the frame (via :StartMoving(), :StartSizing(), or title region); attempting to move or resize the frame beyond the edges of the screen will move/resize it no further than the edge of the screen closest to the mouse position. Does not apply to programmatically setting the frame's position or size.
		@param enable boolean, true to limit the frame's boundaries to those of the screen; false to allow the frame to be moved/resized without such limits
		@return nil
	]======]

	doc [======[
		@name SetClampRectInsets
		@type method
		@desc Sets offsets from the frame's edges used when limiting user movement or resizing of the frame. Note: despite the name of this method, the parameters are offsets along the normal axes -- to inset the frame's clamping area from its edges, the left and bottom measurements should be positive and the right and top measurements should be negative.
		@param left number, offset from the left edge of the frame to the left edge of its clamping area (in pixels)
		@param right number, offset from the right edge of the frame's clamping area to the right edge of the frame (in pixels)
		@param top number, offset from the top edge of the frame's clamping area to the top edge of the frame (in pixels)
		@param bottom number, offset from the bottom edge of the frame to the bottom edge of its clamping area (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetDepth
		@type method
		@desc Sets the 3D depth of the frame (for stereoscopic 3D configurations)
		@param depth number, apparent 3D depth of this frame relative to that of its parent frame
		@return nil
	]======]

	doc [======[
		@name SetDontSavePosition
		@type method
		@desc
		@param boolean
		@return nil
	]======]

	doc [======[
		@name SetFrameLevel
		@type method
		@desc Sets the level at which the frame is layered relative to others in its strata. Frames with higher frame level are layered "in front of" frames with a lower frame level.
		@param level number, layering level of the frame relative to others in its frameStrata
		@return nil
	]======]

	doc [======[
		@name SetFrameStrata
		@type method
		@desc Sets the general layering strata of the frame. Where frame level provides fine control over the layering of frames, frame strata provides a coarser level of layering control: frames in a higher strata always appear "in front of" frames in lower strata regardless of frame level.
		@param strata System.Widget.FrameStrata, token identifying the strata in which the frame should be layered
		@return nil
	]======]

	doc [======[
		@name SetHitRectInsets
		@type method
		@desc Sets the insets from the frame's edges which determine its mouse-interactable area
		@param left number, distance from the left edge of the frame to the left edge of its mouse-interactive area (in pixels)
		@param right number, distance from the right edge of the frame to the right edge of its mouse-interactive area (in pixels)
		@param top number, distance from the top edge of the frame to the top edge of its mouse-interactive area (in pixels)
		@param bottom number, distance from the bottom edge of the frame to the bottom edge of its mouse-interactive area (in pixels)
		@return nil
	]======]

	doc [======[
		@name SetID
		@type method
		@desc Sets a numeric identifier for the frame. Frame IDs have no effect on frame behavior, but can be a useful way to keep track of multiple similar frames, especially in cases where a list of frames is created from a template (such as for action buttons, loot slots, or lines in a FauxScrollFrame).
		@param id number, a numeric identifier for the frame
		@return nil
	]======]

	doc [======[
		@name SetMaxResize
		@type method
		@desc Sets the maximum size of the frame for user resizing. Applies when resizing the frame with the mouse via :StartSizing().
		@param maxWidth number, maximum width of the frame (in pixels), or 0 for no limit
		 @param maxHeight number, maximum height of the frame (in pixels), or 0 for no limit
		@return nil
	]======]
	function SetMaxResize(self, maxWidth, maxHeight)
		self.__UI:SetMaxResize(maxWidth, maxHeight)
		return self:Fire("OnMaxResizeChanged", maxWidth, maxHeight)
	end

	doc [======[
		@name SetMinResize
		@type method
		@desc Sets the minimum size of the frame for user resizing. Applies when resizing the frame with the mouse via :StartSizing().
		@param minWidth number, minimum width of the frame (in pixels), or 0 for no limit
		@param minHeight number, minimum height of the frame (in pixels), or 0 for no limit
		@return nil
	]======]
	function SetMinResize(self, minWidth, minHeight)
		self.__UI:SetMinResize(minWidth, minHeight)
		return self:Fire("OnMinResizeChanged", minWidth, minHeight)
	end

	doc [======[
		@name SetMovable
		@type method
		@desc Sets whether the frame can be moved by the user. Enabling this property does not automatically implement behaviors allowing the frame to be dragged by the user -- such behavior must be implemented in the frame's mouse script handlers. If this property is not enabled, Frame:StartMoving() causes a Lua error.
		@param enable boolean, true to allow the frame to be moved by the user; false to disable
		@return nil
	]======]
	function SetMovable(self, enabled)
		if not self.InDesignMode then
			self.__UI:SetMovable(enabled)
		else
			self.__Movable = (enabled and true) or false
		end
	end

	doc [======[
		@name SetPropagateKeyboardInput
		@type method
		@desc
		@param enable boolean
		@return nil
	]======]

	doc [======[
		@name SetResizable
		@type method
		@desc Sets whether the frame can be resized by the user. Enabling this property does not automatically implement behaviors allowing the frame to be drag-resized by the user -- such behavior must be implemented in the frame's mouse script handlers. If this property is not enabled, Frame:StartSizing() causes a Lua error.
		@param enable boolean, true to allow the frame to be resized by the user; false to disable
		@return nil
	]======]
	function SetResizable(self, enabled)
		if not self.InDesignMode then
			self.__UI:SetResizable(enabled)
		else
			self.__Resizable = (enabled and true) or false
		end
	end

	doc [======[
		@name SetScale
		@type method
		@desc Sets the frame's scale factor. A frame's scale factor affects the size at which it appears on the screen relative to that of its parent. The entire interface may be scaled by changing UIParent's scale factor (as can be done via the Use UI Scale setting in the default interface's Video Options panel).
		@param scale number, scale factor for the frame relative to its parent
		@return nil
	]======]

	doc [======[
		@name SetToplevel
		@type method
		@desc Sets whether the frame should automatically come to the front when clicked. When a frame with Toplevel behavior enabled is clicked, it automatically changes its frame level such that it is greater than (and therefore drawn "in front of") all other frames in its strata.
		@param enable boolean, true to cause the frame to automatically come to the front when clicked; false otherwise
		@return nil
	]======]

	doc [======[
		@name SetUserPlaced
		@type method
		@desc Flags the frame for automatic saving and restoration of position and dimensions. The position and size of frames so flagged is automatically saved when the UI is shut down (as when quitting, logging out, or reloading) and restored when the UI next starts up (as when logging in or reloading). If the frame does not have a name (set at creation time) specified, its position will not be saved. As implied by its name, enabling this property is useful for frames which can be moved or resized by the user.
		@param enable boolean, true to enable automatic saving and restoration of the frame's position and dimensions; false to disable
		@return nil
	]======]

	doc [======[
		@name StartMoving
		@type method
		@desc Begins repositioning the frame via mouse movement
		@return nil
	]======]

	doc [======[
		@name StartSizing
		@type method
		@desc Begins resizing the frame via mouse movement
		@return nil
	]======]

	doc [======[
		@name StopMovingOrSizing
		@type method
		@desc Ends movement or resizing of the frame initiated with object:StartMoving() or object:StartSizing()
		@return nil
	]======]

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
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		UnregisterAllEvents(self)
	end

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