-- Author      : Kurapica
-- Create Date : 6/12/2008 1:13:21 AM
-- ChangeLog
--				2011/03/10	Recode as class
--              2012/04/13  ShowDialog is added
--              2012/07/09  OnVisibleChanged Script is added

-- Check Version
local version = 9
if not IGAS:NewAddon("IGAS.Widget.Region", version) then
	return
end

class "Region"
	inherit "UIObject"

	doc [======[
		@name Region
		@type class
		@desc Region is the basic type for anything that can occupy an area of the screen. As such, Frames, Textures and FontStrings are all various kinds of Region. Region provides most of the functions that support size, position and anchoring, including animation. It is a "real virtual" type; it cannot be instantiated, but objects can return true when asked if they are Regions.
	]======]

	------------------------------------------------------
	-- Event
	------------------------------------------------------
	doc [======[
		@name OnShow
		@type event
		@desc Run when the Region becomes visible
	]======]
	event "OnShow"

	doc [======[
		@name OnHide
		@type event
		@desc Run when the Region's visbility changes to hidden
	]======]
	event "OnHide"

	doc [======[
		@name OnVisibleChanged
		@type event
		@desc Run when the Region's visible state is changed
	]======]
	event "OnVisibleChanged"

	------------------------------------------------------
	-- Method
	------------------------------------------------------
	doc [======[
		@name GetAlpha
		@type method
		@desc Returns the opacity of the region relative to its parent
		@return number Alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque)
	]======]

	doc [======[
		@name Hide
		@type method
		@desc Hide the region
		@return nil
	]======]
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

	doc [======[
		@name IsShown
		@type method
		@desc Returns whether the region is shown. Indicates only whether the region has been explicitly shown or hidden -- a region may be explicitly shown but not appear on screen because its parent region is hidden. See VisibleRegion:IsVisible() to test for actual visibility.
		@return boolean 1 if the region is shown; otherwise nil
	]======]

	doc [======[
		@name IsVisible
		@type method
		@desc Returns whether the region is visible. A region is "visible" if it has been explicitly shown (or not explicitly hidden) and its parent is visible (that is, all of its ancestor frames (parent, parent's parent, etc) are also shown)
		@return boolean 1 if the region is visible; otherwise nil
	]======]

	doc [======[
		@name SetAlpha
		@type method
		@desc Sets the opacity of the region relative to its parent
		@param alpha number, alpha (opacity) of the region (0.0 = fully transparent, 1.0 = fully opaque)
		@return nil
	]======]

	doc [======[
		@name Show
		@type method
		@desc Show the region
		@return nil
	]======]
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

	doc [======[
		@name ShowDialog
		@type method
		@desc Show the region and stop parent's calling thread
		@return nil
	]======]
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

	doc [======[
		@name CanChangeProtectedState
		@type method
		@desc Returns whether protected properties of the region can be changed by non-secure scripts. Addon scripts are allowed to change protected properties for non-secure frames, or for secure frames while the player is not in combat.
		@return boolean 1 if addon scripts are currently allowed to change protected properties of the region (e.g. showing or hiding it, changing its position, or altering frame attributes); otherwise nil
	]======]

	doc [======[
		@name ClearAllPoints
		@type method
		@desc Removes all anchor points from the region
		@return nil
	]======]

	doc [======[
		@name CreateAnimationGroup
		@type method
		@desc Creates a new AnimationGroup as a child of the region
		@param name string, name to use for the new animation group
		@param inheritsFrom string, template from which the new animation group should inherit
		@return System.Widget.AnimationGroup The newly created AnimationGroup
	]======]
	function CreateAnimationGroup(self, name, inheritsFrom)
		return Widget["AnimationGroup"] and Widget["AnimationGroup"](name, self, inheritsFrom)
	end

	doc [======[
		@name GetAnimationGroups
		@type method
		@desc Returns a list of animation groups belonging to the region
		@return ... - A list of AnimationGroup objects for which the region is parent
	]======]
	function GetAnimationGroups(self)
		local lst = {self.__UI:GetAnimationGroups()}

		for i, v in ipairs(lst) do
			lst[i] = IGAS:GetWrapper(v)
		end

		return unpack(lst)
	end

	doc [======[
		@name GetBottom
		@type method
		@desc Returns the distance from the bottom of the screen to the bottom of the region
		@return number Distance from the bottom edge of the screen to the bottom edge of the region (in pixels)
	]======]

	doc [======[
		@name GetCenter
		@type method
		@desc Returns the screen coordinates of the region's center
		@return x number, distance from the left edge of the screen to the center of the region (in pixels)
		@return y number, distance from the bottom edge of the screen to the center of the region (in pixels)
	]======]

	doc [======[
		@name GetHeight
		@type method
		@desc Returns the height of the region
		@return number Height of the region (in pixels)
	]======]

	doc [======[
		@name GetLeft
		@type method
		@desc Returns the distance from the left edge of the screen to the left edge of the region
		@return number Distance from the left edge of the screen to the left edge of the region (in pixels)
	]======]

	doc [======[
		@name GetNumPoints
		@type method
		@desc Returns the number of anchor points defined for the region
		@return number Number of defined anchor points for the region
	]======]

	doc [======[
		@name GetPoint
		@type method
		@desc Returns information about one of the region's anchor points
		@param index number, index of an anchor point defined for the region (between 1 and region:GetNumPoints())
		@return point System.Widget.FramePoint, point on this region at which it is anchored to another
		@return relativeTo System.Widget.Region, reference to the other region to which this region is anchored
		@return relativePoint System.Widget.FramePoint, point on the other region to which this region is anchored
		@return xOffset number, horizontal distance between point and relativePoint (in pixels; positive values put point to the right of relativePoint)
		@return yOffset number, vertical distance between point and relativePoint (in pixels; positive values put point below relativePoint)
	]======]
	function GetPoint(self, pointNum)
		local point, frame, relativePoint, x, y = self.__UI:GetPoint(pointNum)
		frame = IGAS:GetWrapper(frame)
		return point, frame, relativePoint, x, y
	end

	doc [======[
		@name GetRect
		@type method
		@desc Returns the position and dimensions of the region
		@return left number, Distance from the left edge of the screen to the left edge of the region (in pixels)
		@return bottom number, Distance from the bottom edge of the screen to the bottom of the region (in pixels)
		@return width number, Width of the region (in pixels)
		@return height number, Height of the region (in pixels)
	]======]

	doc [======[
		@name GetRight
		@type method
		@desc Returns the distance from the left edge of the screen to the right edge of the region
		@return number Distance from the left edge of the screen to the right edge of the region (in pixels)
	]======]

	doc [======[
		@name GetSize
		@type method
		@desc Returns the width and height of the region
		@return width number, the width of the region
		@return height number, the height of the region
	]======]

	doc [======[
		@name GetTop
		@type method
		@desc Returns the distance from the bottom of the screen to the top of the region
		@return number Distance from the bottom edge of the screen to the top edge of the region (in pixels)
	]======]

	doc [======[
		@name GetWidth
		@type method
		@desc Returns the width of the region
		@return number Width of the region (in pixels)
	]======]

	doc [======[
		@name IsDragging
		@type method
		@desc Returns whether the region is currently being dragged
		@return boolean 1 if the region (or its parent or ancestor) is currently being dragged; otherwise nil
	]======]

	doc [======[
		@name IsMouseOver
		@type method
		@desc Returns whether the mouse cursor is over the given region. This function replaces the previous MouseIsOver FrameXML function.
		@param topOffset number, the amount by which to displace the top edge of the test rectangle
		@param leftOffset number, the amount by which to displace the left edge of the test rectangle
		@param bottomOffset number, the amount by which to displace the bottom edge of the test rectangle
		@param rightOffset number, the amount by which to displace the right edge of the test rectangle
		@return boolean 1 if the mouse is over the region; otherwise nil
	]======]

	doc [======[
		@name IsProtected
		@type method
		@desc Returns whether the region is protected. Non-secure scripts may change certain properties of a protected region (e.g. showing or hiding it, changing its position, or altering frame attributes) only while the player is not in combat. Regions may be explicitly protected by Blizzard scripts or XML; other regions can become protected by becoming children of protected regions or by being positioned relative to protected regions.
		@return isProtected boolean, 1 if the region is protected; otherwise nil
		@return explicit boolean, 1 if the region is explicitly protected; nil if the frame is only protected due to relationship with a protected region
	]======]

	doc [======[
		@name SetAllPoints
		@type method
		@desc Sets all anchor points of the region to match those of another region. If no region is specified, the region's anchor points are set to those of its parent.
		@format [name|region]
		@param name global name of a System.Widget.Region
		@param region System.Widget.Region
		@return nil
	]======]

	doc [======[
		@name SetHeight
		@type method
		@desc Sets the region's height
		@param height number, New height for the region (in pixels); if 0, causes the region's height to be determined automatically according to its anchor points
		@return nil
	]======]

	doc [======[
		@name GetHeight
		@type method
		@desc Gets the region's height
		@return number the height of the region
	]======]

	doc [======[
		@name SetPoint
		@type method
		@desc Sets an anchor point for the region
		@param point System.Widget.FramePoint, point on this region at which it is to be anchored to another
		@param relativeTo System.Widget.Region, reference to the other region to which this region is to be anchored; if nil or omitted, anchors the region relative to its parent (or to the screen dimensions if the region has no parent)
		@param relativePoint System.Widget.FramePoint, point on the other region to which this region is to be anchored; if nil or omitted, defaults to the same value as point
		@param xOffset number, horizontal distance between point and relativePoint (in pixels; positive values put point to the right of relativePoint); if nil or omitted, defaults to 0
		@param yOffset number, vertical distance between point and relativePoint (in pixels; positive values put point below relativePoint); if nil or omitted, defaults to 0
	]======]

	doc [======[
		@name SetSize
		@type method
		@desc Sets the size of the region to the specified values
		@param width number, the width to set for the region
		@param height number, the height to set for the region
	]======]

	doc [======[
		@name SetWidth
		@type method
		@desc Sets the region's width
		@param width number,New width for the region (in pixels); if 0, causes the region's width to be determined automatically according to its anchor points
		@return nil
	]======]

	doc [======[
		@name StopAnimating
		@type method
		@desc Stops any active animations involving the region or its children
		@return nil
	]======]

	------------------------------------------------------
	-- Property
	------------------------------------------------------
	doc [======[
		@name Alpha
		@type property
		@desc the frame's transparency value(0-1)
	]======]
	property "Alpha" {
		Get = function(self)
			return self:GetAlpha()
		end,
		Set = function(self, alpha)
			self:SetAlpha(alpha)
		end,
		Type = ColorFloat,
	}

	doc [======[
		@name Height
		@type property
		@desc the height of the region
	]======]
	property "Height" {
		Get = function(self)
			return self:GetHeight()
		end,
		Set = function(self, height)
			self:SetHeight(height)
		end,
		Type = Number,
	}

	doc [======[
		@name Width
		@type property
		@desc the width of the region
	]======]
	property "Width" {
		Get = function(self)
			return self:GetWidth()
		end,
		Set = function(self, width)
			self:SetWidth(width)
		end,
		Type = Number,
	}

	doc [======[
		@name Visible
		@type property
		@desc wheter the region is shown or not.
	]======]
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

	doc [======[
		@name Size
		@type property
		@desc the size of the region
	]======]
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

	doc [======[
		@name Location
		@type property
		@desc the location of the region
	]======]
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
	-- Event Handler
	------------------------------------------------------

	------------------------------------------------------
	-- Dispose
	------------------------------------------------------
	function Dispose(self)
		self:ClearAllPoints()
		self:Hide()
	end

	------------------------------------------------------
	-- Constructor
	------------------------------------------------------
endclass "Region"