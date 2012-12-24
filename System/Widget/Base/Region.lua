-- Author      : Kurapica
-- Create Date : 6/12/2008 1:13:21 AM
-- ChangeLog
--				2011/03/10	Recode as class
--              2012/04/13  ShowDialog is added
--              2012/07/09  OnVisibleChanged Script is added

----------------------------------------------------------------------------------------------------------------------------------------
--- Button is the primary means for users to control the game and their characters.
-- <br><br>inherit <a href=".\UIObject.html">UIObject</a> For all methods, properties and scriptTypes
-- @name Region
-- @class table
-- @field Alpha Set or get the frame's transparency value(0-1)
-- @field Height the height of the region
-- @field Width the width of the region
-- @field Visible the visible of the region
-- @field Size the size of the region
----------------------------------------------------------------------------------------------------------------------------------------

-- Check Version
local version = 9
if not IGAS:NewAddon("IGAS.Widget.Region", version) then
	return
end

class "Region"
	inherit "UIObject"

	------------------------------------------------------
	-- Script
	------------------------------------------------------
	------------------------------------
	--- ScriptType, Run when the Region becomes visible
	-- @name Region:OnShow
	-- @class function
	-- @usage function Region:OnShow()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnShow"

	------------------------------------
	--- ScriptType, Run when the Region's visbility changes to hidden
	-- @name Region:OnHide
	-- @class function
	-- @usage function Region:OnHide()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnHide"

	------------------------------------
	--- ScriptType, Run when the Region's visible state is changed
	-- @name Region:OnVisibleChanged
	-- @class function
	-- @usage function Region:OnVisibleChanged()<br>
	--    -- do someting<br>
	-- end
	------------------------------------
	script "OnVisibleChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	-- Dispose, release resource
	function Dispose(self)
		self:ClearAllPoints()
		self:Hide()
	end

	------------------------------------
	--- Returns the opacity of the region relative to its parent
	-- @name VisibleRegion:GetAlpha
	-- @class function
	-- @return alpha - Alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- GetAlpha

	------------------------------------
	--- Hides the region
	-- @name VisibleRegion:Hide
	-- @class function
	------------------------------------
	-- Hide
	function Hide(self)
		local flag = self:IsShown()

		self.__UI:Hide()

		if flag then
			if self:IsClass(LayeredRegion) then
				self:Fire("OnHide")
			end

			self:Fire("OnVisibleChanged")
		end

		return self.__ShowDialogThread and self.__ShowDialogThread()
	end

	------------------------------------
	--- Returns whether the region is shown. Indicates only whether the region has been explicitly shown or hidden -- a region may be explicitly shown but not appear on screen because its parent region is hidden. See VisibleRegion:IsVisible() to test for actual visibility.
	-- @name VisibleRegion:IsShown
	-- @class function
	-- @return shown - 1 if the region is shown; otherwise nil (1nil)
	------------------------------------
	-- IsShown

	------------------------------------
	--- Returns whether the region is visible. A region is "visible" if it has been explicitly shown (or not explicitly hidden) and its parent is visible (that is, all of its ancestor frames (parent, parent's parent, etc) are also shown).</p>
	--- <p>A region may be "visible" and not appear on screen -- it may not have any anchor points set, its position and size may be outside the bounds of the screen, or it may not draw anything (e.g. a FontString with no text, a Texture with no image, or a Frame with no visible children).
	-- @name VisibleRegion:IsVisible
	-- @class function
	-- @return visible - 1 if the region is visible; otherwise nil (1nil)
	------------------------------------
	-- IsVisible

	------------------------------------
	--- Sets the opacity of the region relative to its parent
	-- @name VisibleRegion:SetAlpha
	-- @class function
	-- @param alpha Alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque) (number)
	------------------------------------
	-- SetAlpha

	------------------------------------
	--- Shows the region
	-- @name VisibleRegion:Show
	-- @class function
	------------------------------------
	-- Show
	function Show(self)
		local flag = self:IsShown()

		self.__UI:Show()

		if not flag then
			if self:IsClass(LayeredRegion) then
				self:Fire("OnShow")
			end

			self:Fire("OnVisibleChanged")
		end
	end

	------------------------------------
	--- Shows the region
	-- @name VisibleRegion:ShowDialog
	-- @class function
	------------------------------------
	-- ShowDialog
	function ShowDialog(self)
		local flag = self:IsShown()

		self.__ShowDialogThread = System.Threading.Thread()
		self.__UI:Show()

		if not flag then
			if self:IsClass(LayeredRegion) then
				self:Fire("OnShow")
			end

			self:Fire("OnVisibleChanged")
		end

		return self.__ShowDialogThread:Yield()
	end

	------------------------------------
	--- Returns whether protected properties of the region can be changed by non-secure scripts. Addon scripts are allowed to change protected properties for non-secure frames, or for secure frames while the player is not in combat.
	-- @name Region:CanChangeProtectedState
	-- @class function
	-- @return canChange - 1 if addon scripts are currently allowed to change protected properties of the region (e.g. showing or hiding it, changing its position, or altering frame attributes); otherwise nil (value, 1nil)
	------------------------------------
	-- CanChangeProtectedState

	------------------------------------
	--- Removes all anchor points from the region
	-- @name Region:ClearAllPoints
	-- @class function
	------------------------------------
	-- ClearAllPoints

	------------------------------------
	--- Creates a new AnimationGroup as a child of the region
	-- @name Region:CreateAnimationGroup
	-- @class function
	-- @param name A global name to use for the new animation group (string)
	-- @param inheritsFrom Template from which the new animation group should inherit (string)
	-- @return animationGroup - The newly created AnimationGroup (animgroup)
	------------------------------------
	function CreateAnimationGroup(self, name, inheritsFrom)
		return Widget["AnimationGroup"] and Widget["AnimationGroup"](name, self, inheritsFrom)
	end

	------------------------------------
	--- Returns a list of animation groups belonging to the region
	-- @name Region:GetAnimationGroups
	-- @class function
	-- @return ... - A list of AnimationGroup objects for which the region is parent (list)
	------------------------------------
	function GetAnimationGroups(self)
		local lst = {self.__UI:GetAnimationGroups()}

		for i, v in ipairs(lst) do
			lst[i] = IGAS:GetWrapper(v)
		end

		return unpack(lst)
	end

	------------------------------------
	--- Returns the distance from the bottom of the screen to the bottom of the region
	-- @name Region:GetBottom
	-- @class function
	-- @return bottom - Distance from the bottom edge of the screen to the bottom edge of the region (in pixels) (number)
	------------------------------------
	-- GetBottom

	------------------------------------
	--- Returns the screen coordinates of the region's center
	-- @name Region:GetCenter
	-- @class function
	-- @return x - Distance from the left edge of the screen to the center of the region (in pixels) (number)
	-- @return y - Distance from the bottom edge of the screen to the center of the region (in pixels) (number)
	------------------------------------
	-- GetCenter

	------------------------------------
	--- Returns the height of the region
	-- @name Region:GetHeight
	-- @class function
	-- @return height - Height of the region (in pixels) (number)
	------------------------------------
	-- GetHeight

	------------------------------------
	--- Returns the distance from the left edge of the screen to the left edge of the region
	-- @name Region:GetLeft
	-- @class function
	-- @return left - Distance from the left edge of the screen to the left edge of the region (in pixels) (number)
	------------------------------------
	-- GetLeft

	------------------------------------
	--- Returns the number of anchor points defined for the region
	-- @name Region:GetNumPoints
	-- @class function
	-- @return numPoints - Number of defined anchor points for the region (number)
	------------------------------------
	-- GetNumPoints

	------------------------------------
	--- Returns information about one of the region's anchor points
	-- @name Region:GetPoint
	-- @class function
	-- @param index Index of an anchor point defined for the region (between 1 and region:GetNumPoints()) (number)
	-- @return point - Point on this region at which it is anchored to another (string, anchorPoint)
	-- @return relativeTo - Reference to the other region to which this region is anchored (region)
	-- @return relativePoint - Point on the other region to which this region is anchored (string, anchorPoint)
	-- @return xOffset - Horizontal distance between point and relativePoint (in pixels; positive values put point to the right of relativePoint) (number)
	-- @return yOffset - Vertical distance between point and relativePoint (in pixels; positive values put point below relativePoint) (number)
	------------------------------------
	function GetPoint(self, pointNum)
		local point, frame, relativePoint, x, y = self.__UI:GetPoint(pointNum)
		frame = IGAS:GetWrapper(frame)
		return point, frame, relativePoint, x, y
	end

	------------------------------------
	--- Returns the position and dimensions of the region
	-- @name Region:GetRect
	-- @class function
	-- @return left - Distance from the left edge of the screen to the left edge of the region (in pixels) (number)
	-- @return bottom - Distance from the bottom edge of the screen to the bottom of the region (in pixels) (number)
	-- @return width - Width of the region (in pixels) (number)
	-- @return height - Height of the region (in pixels) (number)
	------------------------------------
	-- GetRect

	------------------------------------
	--- Returns the distance from the left edge of the screen to the right edge of the region
	-- @name Region:GetRight
	-- @class function
	-- @return right - Distance from the left edge of the screen to the right edge of the region (in pixels) (number)
	------------------------------------
	-- GetRight

	------------------------------------
	--- Returns the width and height of the region
	-- @name Region:GetSize
	-- @class function
	-- @return width - The width of the region (number)
	-- @return height - The height of the region (number)
	------------------------------------
	-- GetSize

	------------------------------------
	--- Returns the distance from the bottom of the screen to the top of the region
	-- @name Region:GetTop
	-- @class function
	-- @return top - Distance from the bottom edge of the screen to the top edge of the region (in pixels) (number)
	------------------------------------
	-- GetTop

	------------------------------------
	--- Returns the width of the region
	-- @name Region:GetWidth
	-- @class function
	-- @return width - Width of the region (in pixels) (number)
	------------------------------------
	-- GetWidth

	------------------------------------
	--- Returns whether the region is currently being dragged
	-- @name Region:IsDragging
	-- @class function
	-- @return isDragging - 1 if the region (or its parent or ancestor) is currently being dragged; otherwise nil (1nil)
	------------------------------------
	-- IsDragging

	------------------------------------
	--- Returns whether the mouse cursor is over the given region. This function replaces the previous MouseIsOver FrameXML function.</p>
	--- <p>If provided, the arguments are treated as offsets by which to adjust the hit rectangle when comparing it to the mouse. They are in screen coordinates; positive offsets move an edge right or up, negative values move it left or down. No frame edges are actually moved. For example:     </p>
	--- <pre> if button:IsMouseOver(2, -2, -2, 2) then
	--- </pre>
	--- <p>will return true if the mouse is within 2 pixels of the given frame.
	-- @name Region:IsMouseOver
	-- @class function
	-- @param topOffset The amount by which to displace the top edge of the test rectangle (number)
	-- @param leftOffset The amount by which to displace the left edge of the test rectangle (number)
	-- @param bottomOffset The amount by which to displace the bottom edge of the test rectangle (number)
	-- @param rightOffset The amount by which to displace the right edge of the test rectangle (number)
	-- @return isOver - 1 if the mouse is over the region; otherwise nil (1nil)
	------------------------------------
	-- IsMouseOver

	------------------------------------
	--- Returns whether the region is protected. Non-secure scripts may change certain properties of a protected region (e.g. showing or hiding it, changing its position, or altering frame attributes) only while the player is not in combat. Regions may be explicitly protected by Blizzard scripts or XML; other regions can become protected by becoming children of protected regions or by being positioned relative to protected regions.
	-- @name Region:IsProtected
	-- @class function
	-- @return isProtected - 1 if the region is protected; otherwise nil (value, 1nil)
	-- @return explicit - 1 if the region is explicitly protected; nil if the frame is only protected due to relationship with a protected region (value, 1nil)
	------------------------------------
	-- IsProtected

	------------------------------------
	--- Sets all anchor points of the region to match those of another region. If no region is specified, the region's anchor points are set to those of its parent.
	-- @name Region:SetAllPoints
	-- @class function
	-- @param region Reference to a region (region)
	-- @param name Global name of a region (string)
	------------------------------------
	-- SetAllPoints

	------------------------------------
	--- Sets the region's height
	-- @name Region:SetHeight
	-- @class function
	-- @param height New height for the region (in pixels); if 0, causes the region's height to be determined automatically according to its anchor points (number)
	------------------------------------
	-- SetHeight

	------------------------------------
	--- Gets the region's height
	-- @name Region:GetHeight
	-- @class function
	-- @return height New height for the region (in pixels); if 0, causes the region's height to be determined automatically according to its anchor points (number)
	------------------------------------
	-- GetHeight

	------------------------------------
	--- Makes another frame the parent of this region
	-- @name Region:SetParent
	-- @class function
	-- @param frame The new parent frame (frame)
	-- @param name Global name of a frame (string)
	------------------------------------
	-- SetParent

	------------------------------------
	--- Sets an anchor point for the region
	-- @name Region:SetPoint
	-- @class function
	-- @param point Point on this region at which it is to be anchored to another (string, anchorPoint)
	-- @param relativeTo Reference to the other region to which this region is to be anchored; if nil or omitted, anchors the region relative to its parent (or to the screen dimensions if the region has no parent) (region)
	-- @param relativePoint Point on the other region to which this region is to be anchored; if nil or omitted, defaults to the same value as point (string, anchorPoint)
	-- @param xOffset Horizontal distance between point and relativePoint (in pixels; positive values put point to the right of relativePoint); if nil or omitted, defaults to 0 (number)
	-- @param yOffset Vertical distance between point and relativePoint (in pixels; positive values put point below relativePoint); if nil or omitted, defaults to 0 (number)
	------------------------------------
	-- SetPoint

	------------------------------------
	--- Sets the size of the region to the specified values
	-- @name Region:SetSize
	-- @class function
	-- @param width The width to set for the region (number)
	-- @param height The height to set for the region (number)
	------------------------------------
	-- SetSize

	------------------------------------
	--- Sets the region's width
	-- @name Region:SetWidth
	-- @class function
	-- @param width New width for the region (in pixels); if 0, causes the region's width to be determined automatically according to its anchor points (number)
	------------------------------------
	-- SetWidth

	------------------------------------
	--- Stops any active animations involving the region or its children
	-- @name Region:StopAnimating
	-- @class function
	------------------------------------
	-- StopAnimating

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	--- Alpha
	property "Alpha" {
		Get = function(self)
			return self:GetAlpha()
		end,
		Set = function(self, alpha)
			self:SetAlpha(alpha)
		end,
		Type = ColorFloat,
	}
	--- Height
	property "Height" {
		Get = function(self)
			return self:GetHeight()
		end,
		Set = function(self, height)
			self:SetHeight(height)
		end,
		Type = Number,
	}
	--- Width
	property "Width" {
		Get = function(self)
			return self:GetWidth()
		end,
		Set = function(self, width)
			self:SetWidth(width)
		end,
		Type = Number,
	}
	--- Visible
	property "Visible" {
		Get = function(self)
			if not self.InDesignMode then
				return (self:IsShown() and true ) or false
			else
				if self.__Visible == nil then
					self.__Visible = true
				end
				return (self.__Visible and true) or false
			end
		end,
		Set = function(self, visible)
			if not self.InDesignMode then
				if visible then
					self:Show()
				else
					self:Hide()
				end
			else
				self.__Visible = (visible and true) or false
			end
		end,
		Type = Boolean,
	}
	-- Size
	property "Size" {
		Get = function(self)
			return System.Widget.Size(self:GetWidth(), self:GetHeight())
		end,
		Set = function(self, size)
			self:SetWidth(size.width)
			self:SetHeight(size.height)
		end,
		Type = System.Widget.Size,
	}
	-- Location
	property "Location" {
		Get = function(self)
			local ret = {}

			for i = 1, self:GetNumPoints() do
				local point, relativeTo, relativePoint, x, y = self:GetPoint(i)

				relativeTo = relativeTo or IGAS.UIParent

				ret[i] = AnchorPoint(point, relativeTo:GetName(), relativePoint, x, y)
			end

			return ret
		end,
		Set = function(self, loc)
			if #loc > 0 then
				self:ClearAllPoints()
				for _, anchor in ipairs(loc) do
					local parent = IGAS:GetFrame(anchor.relativeTo)

					if parent then
						self:SetPoint(anchor.point, parent, anchor.relativePoint, anchor.xOffset, anchor.yOffset)
					end
				end
			end
		end,
		Type = Location,
	}

	------------------------------------------------------
	-- Script Handler
	------------------------------------------------------
	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "Region"